# v0.5.3 — hotfix MCP bash-wrapper для двух контекстов

Дата: 2026-05-05.

## Что исправлено

v0.5.2 использовал `${CLAUDE_PLUGIN_ROOT}` в `.mcp.json`, но эта переменная подставляется **только в plugin-level** `.mcp.json` (когда плагин установлен через marketplace). При **project-level** чтении (dogfooding — работа над самим плагином как проектом) переменная остаётся не подставленной, и MCP-launcher не находит скрипт. Запись отображалась как `Failed to connect`.

## Решение

`.mcp.json` теперь использует bash-wrapper:

```json
{
  "command": "bash",
  "args": [
    "-c",
    "exec \"${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/launch-sdlc-state-rag.sh\""
  ]
}
```

Bash параметр-expansion `${A:-${B:-$C}}` корректно работает в обоих контекстах:
- **Plugin context** (после install): `${CLAUDE_PLUGIN_ROOT}` указывает на cache dir.
- **Project context** (dogfooding): `${CLAUDE_PROJECT_DIR}` указывает на source repo.
- **Fallback**: `$PWD`.

## ⚠️ ACTION REQUIRED

Перезагрузите Claude Code или выполните `/plugin reload ai-driven-sdlc`.

## Verification

```bash
claude mcp list | grep sdlc-state-rag
# должно показать: sdlc-state-rag: ... ✓ Connected
```

## Связанные релизы

- v0.5.0 — принцип 22 + enforce-sdlc-phase hook.
- v0.5.1 — попытка фикса MCP через прямой бинарь (не работало в nvm-окружениях).
- v0.5.2 — launcher-скрипт с fallback PATH→nvm→standard locations→npx (работало в plugin context, но ломалось в project context).
- v0.5.3 — этот релиз: bash-wrapper для обоих контекстов.
