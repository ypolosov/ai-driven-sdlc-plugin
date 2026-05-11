# Release v0.11.2 — реальный fix MCP sdlc-state-rag connect (bash wrapper, no `:-`)

**Type:** patch (incomplete v0.11.1 → real fix).
**Date:** 2026-05-11.

## Контекст

v0.11.1 пытался убрать bash-обёртку и использовать bare `${CLAUDE_PLUGIN_ROOT}` напрямую в `command`. **Не сработало** — Claude Code не делает variable substitution в `command` field:

```bash
$ claude mcp list | grep sdlc-state-rag
sdlc-state-rag: ${CLAUDE_PLUGIN_ROOT}/scripts/launch-sdlc-state-rag.sh  - ✗ Failed to connect
```

`${CLAUDE_PLUGIN_ROOT}` передаётся literally в exec, который не expand'ит variables.

## Real fix

Возвращаем bash-обёртку (как в v0.5.x), но **избегаем оригинальной ошибки** — никаких вложенных `:-` fallback'ов.

```jsonc
"sdlc-state-rag": {
  "type": "stdio",
  "command": "bash",
  "args": [
    "-c",
    "exec \"$CLAUDE_PLUGIN_ROOT/scripts/launch-sdlc-state-rag.sh\""
  ],
  "env": {"SDLC_STATE_RAG_DSN": "${SDLC_STATE_RAG_DSN}"}
}
```

Bash подставит `$CLAUDE_PLUGIN_ROOT` (env var, который Claude Code инжектит в MCP child process). Никаких fallback'ов — если переменная пуста, bash exec вылетит с явной ошибкой (видимо в логах), а не silently попадёт в неправильный путь.

## Эволюция bag'а

| Version | Pattern | Status |
|---|---|---|
| v0.5.x | `bash -c exec "$CLAUDE_PLUGIN_ROOT/scripts/..."` | ✓ Working (no nested `:-`) |
| ...v0.10.0 | `bash -c exec "${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/..."` | ✗ Bug: вложенный `:-` сворачивается |
| v0.11.1 | `command: "${CLAUDE_PLUGIN_ROOT}/scripts/..."` | ✗ Claude Code не expand'ит в command |
| **v0.11.2** | `bash -c exec "$CLAUDE_PLUGIN_ROOT/scripts/..."` (back to v0.5.x style) | ✓ Real fix |

## Файлы изменены

| File | Change |
|---|---|
| `.mcp.json` | bash wrapper с bare `$CLAUDE_PLUGIN_ROOT` |
| `scripts/bootstrap-target.sh` | Same для генерируемого `<target>/.mcp.json` |
| `.claude-plugin/plugin.json` | 0.11.1 → **0.11.2** |
| `tests/unit/mcp-json-no-nested-fallback.bats` | Обновлён под bash wrapper (4 кейса) |
| `tests/integration/sdlc-state-rag-contract.bats` | Обновлён (2 кейса) |

## Verification

Smoke-test:
```bash
CLAUDE_PLUGIN_ROOT=/home/ypolosov/.claude/plugins/cache/ypolosov/ai-driven-sdlc/0.11.2 \
  bash -c 'exec "$CLAUDE_PLUGIN_ROOT/scripts/launch-sdlc-state-rag.sh"'
# Server starts, blocks on stdin (timeout exit 124 = healthy)
```

`bats tests/unit/` — 159/159 green.
`bats tests/integration/` — 47/47 green.

After release + reconnect:
```bash
claude mcp list | grep sdlc-state-rag
# Expected: bash -c exec "$CLAUDE_PLUGIN_ROOT/..." - ✓ Connected
```

## Установка

```bash
/plugin marketplace update ypolosov
/plugin update ai-driven-sdlc
```

После update — restart Claude Code session (или `/mcp` reconnect для force-reload `.mcp.json`).

## Что НЕ изменилось

- `scripts/launch-sdlc-state-rag.sh` — не трогался.
- `SDLC_STATE_RAG_DSN` — unset by default, pglite fallback.

## Plugin tools used (принцип 12 dogfooding)

- skill `/sdlc-phase deployment` методологически.
- Smoke-test через bash CLI (не requires running MCP).
- TDD: regression bats обновлены (red → green).
- Принципы: 12, 22.

## Impact

P0 fix. v0.11.1 был incomplete — MCP всё ещё Failed to connect. Этот release реально подключает MCP для всех будущих sessions.
