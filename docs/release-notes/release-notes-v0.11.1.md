# Release v0.11.1 — fix MCP sdlc-state-rag connect (CLAUDE_PLUGIN_ROOT resolve)

**Type:** patch (single-file fix, no API changes).
**Date:** 2026-05-11.
**Issue:** MCP server `sdlc-state-rag` показывал `✗ Failed to connect` в Claude Code runtime.

## Корневая причина

`.mcp.json` использовал вложенную форму variable substitution:

```jsonc
"args": ["-c", "exec \"${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/launch-sdlc-state-rag.sh\""]
```

Claude Code variable substitution поддерживает простую форму `${CLAUDE_PLUGIN_ROOT}`, но **сворачивает** вложенный fallback `${CLAUDE_PLUGIN_ROOT:-fallback}` в fallback-ветку, как если бы переменная была пустой. В результате bash получал путь относительно `CLAUDE_PROJECT_DIR/$PWD` (root пользовательского проекта), где launcher-скрипта нет:

```
ls: cannot access '/home/ypolosov/DEV/GITS/gt/scripts/launch-sdlc-state-rag.sh': No such file or directory
```

А сам скрипт лежит только в plugin cache:

```
/home/ypolosov/.claude/plugins/cache/ypolosov/ai-driven-sdlc/0.11.0/scripts/launch-sdlc-state-rag.sh
```

## Fix

Уберём bash-обёртку. Claude Code сам подставит `${CLAUDE_PLUGIN_ROOT}` в `command`. Скрипт уже исполняемый.

**До:**
```jsonc
"sdlc-state-rag": {
  "type": "stdio",
  "command": "bash",
  "args": ["-c", "exec \"${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/launch-sdlc-state-rag.sh\""],
  "env": {"SDLC_STATE_RAG_DSN": "${SDLC_STATE_RAG_DSN}"}
}
```

**После:**
```jsonc
"sdlc-state-rag": {
  "type": "stdio",
  "command": "${CLAUDE_PLUGIN_ROOT}/scripts/launch-sdlc-state-rag.sh",
  "args": [],
  "env": {"SDLC_STATE_RAG_DSN": "${SDLC_STATE_RAG_DSN}"}
}
```

## Что НЕ изменилось

- `scripts/launch-sdlc-state-rag.sh` — не трогался, уже корректно ищет бинарь через PATH/nvm/standard locations/npx fallback.
- `SDLC_STATE_RAG_DSN` остаётся unset by default — launcher fallback'ит на embedded pglite.
- Никаких API изменений в `sdlc-state-rag` контракте.

## Verification

После update:

```bash
claude mcp list | grep sdlc-state-rag
# Expected: ✓ Connected
```

MCP-инструменты должны быть доступны:
- `mcp__sdlc-state-rag__state_get_alpha`
- `mcp__sdlc-state-rag__state_advance_alpha`
- `mcp__sdlc-state-rag__decisions_record`
- etc.

`/sdlc-status` в целевом проекте должен отрабатывать без "MCP unavailable".

End-to-end smoke с pglite (DSN не задан):
```bash
cd <target with .claude/sdlc/>
ls .sdlc-db/  # PGlite data dir появится после первого запроса
```

## Установка / обновление

```bash
/plugin marketplace update ypolosov
/plugin update ai-driven-sdlc
```

После update — verify: версия v0.11.1.

## Plugin tools used (принцип 12 dogfooding)

- skill `/sdlc-phase deployment` методологически.
- `mcp__sdlc-state-rag__decisions_record` (теперь работает после fix).
- Принципы: 12 (dogfooding fixed before next session), 22 (active_phase enforce).

## Impact

P0 fix для real-world plugin use. Без этого patch плагин в production функционирует только частично (markdown artifacts) — все MCP-based features недоступны (decisions, state advancement, audit).
