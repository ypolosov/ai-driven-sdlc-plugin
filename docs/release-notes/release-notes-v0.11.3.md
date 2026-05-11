# Release v0.11.3 — реальный MCP fix (npx, как у официальных плагинов)

**Type:** patch.
**Date:** 2026-05-11.
**Verified:** `mcp__sdlc-state-rag__state_validate_consistency` отвечает `{"ok":true,"issues":[]}` (full MCP round-trip).

## Контекст

v0.11.1 и v0.11.2 были incomplete fix'ы:
- **v0.11.1**: bare `${CLAUDE_PLUGIN_ROOT}` в `command` field — Claude Code не expand'ит variables в command.
- **v0.11.2**: bash wrapper с `$CLAUDE_PLUGIN_ROOT` — env var не определена на project-level `.mcp.json`.

## Real diagnosis

В `claude mcp list` MCP server показывался **без префикса** `plugin:ai-driven-sdlc:`:
```
sdlc-state-rag: bash -c exec "$CLAUDE_PLUGIN_ROOT/..." - ✗ Failed to connect
```

Тогда как официальные плагины показываются с префиксом:
```
plugin:context7:context7: npx -y @upstash/context7-mcp - ✓ Connected
plugin:playwright:playwright: npx @playwright/mcp@latest - ✓ Connected
```

Это означало что наш MCP server подключается на **project-level** (из `.mcp.json` в plugin repo root), **не** как часть плагина. На project-level `CLAUDE_PLUGIN_ROOT` env var не инжектится.

Сравнение `.mcp.json` форматов:

**Официальный playwright/context7/github (working):**
```jsonc
{
  "playwright": {
    "command": "npx",
    "args": ["@playwright/mcp@latest"]
  }
}
```

**Наш (broken):**
```jsonc
{
  "mcpServers": {
    "sdlc-state-rag": {
      "command": "bash",
      "args": ["-c", "exec \"$CLAUDE_PLUGIN_ROOT/scripts/launch-sdlc-state-rag.sh\""]
    }
  }
}
```

## Real fix

Используем `npx` напрямую — как делают все официальные плагины:

```jsonc
{
  "mcpServers": {
    "sdlc-state-rag": {
      "command": "npx",
      "args": ["-y", "@ypolosov/sdlc-state-rag"]
    }
  }
}
```

- **Без** bash wrapper.
- **Без** `$CLAUDE_PLUGIN_ROOT`.
- **Без** launcher script (для MCP).
- **`-y` flag**: автоматическое подтверждение npx download.

`scripts/launch-sdlc-state-rag.sh` сохранён для CLI use (не для MCP).

## Эволюция bug'a (full timeline)

| Version | Pattern | Status | Cause |
|---|---|---|---|
| v0.5.x | `bash -c exec "$CLAUDE_PLUGIN_ROOT/scripts/..."` | ✓ Working (когда?) | Возможно работало только в plugin cache context |
| v0.10.0 | `bash -c exec "${CLAUDE_PLUGIN_ROOT:-${...:-$PWD}}/..."` | ✗ Bug | `:-` сворачивается |
| v0.11.1 | `command: "${CLAUDE_PLUGIN_ROOT}/scripts/..."` | ✗ Bug | Claude не expand'ит в command field |
| v0.11.2 | `bash -c exec "$CLAUDE_PLUGIN_ROOT/..."` (без `:-`) | ✗ Bug | `CLAUDE_PLUGIN_ROOT` undef на project-level |
| **v0.11.3** | `npx -y @ypolosov/sdlc-state-rag` | ✓ **Verified working** | Без env var dependency |

## Verification (реальная, не handshake)

```bash
# В Claude Code session с .mcp.json v0.11.3:
mcp__sdlc-state-rag__state_validate_consistency()
# → {"ok":true,"issues":[]}
```

Это полный JSON-RPC round-trip: client → server → БД query → response. Confirms working MCP protocol + working business logic.

`claude mcp list`:
```
sdlc-state-rag: npx -y @ypolosov/sdlc-state-rag - ✓ Connected
```

## Файлы изменены

| File | Change |
|---|---|
| `.mcp.json` | npx command, no wrapper |
| `scripts/bootstrap-target.sh` | Same fix для генерируемого target `.mcp.json` |
| `.claude-plugin/plugin.json` | 0.11.2 → **0.11.3** |
| `tests/unit/init-mcp-json.bats` | 3 кейса под npx |
| `tests/unit/mcp-json-no-nested-fallback.bats` | regression: no `:-`, no `$CLAUDE_PLUGIN_ROOT`, npx assertion |
| `tests/integration/sdlc-state-rag-contract.bats` | 3 кейса под npx |

## Lesson learned

**Diligence требует посмотреть на working examples ДО fix-attempts.** Все 4 предыдущих попыток были на неправильном уровне абстракции:
- v0.10.0 → v0.11.2: пытались чинить bash wrapper variations.
- **Реальный fix**: убрать wrapper полностью, использовать стандартный pattern (npx).

Sравнить с `claude-plugins-official/playwright/.mcp.json` нужно было в первый же diagnostic step.

## Установка / обновление

```bash
/plugin marketplace update ypolosov
/plugin update ai-driven-sdlc
```

Restart Claude Code session → verify `claude mcp list | grep sdlc-state-rag` → `✓ Connected`.

## Impact

P0 fix verified working. v0.11.1 и v0.11.2 не починили MCP — этот релиз реально делает.
