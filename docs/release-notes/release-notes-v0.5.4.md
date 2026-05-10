# v0.5.4 — корневая причина Failed-to-connect: DSN literal sanitize

Дата: 2026-05-05.

## Что исправлено

После 4 итераций hotfix'ов (v0.5.0..0.5.3) обнаружена корневая причина серии `✗ Failed to connect`.

**Claude Code НЕ подставляет `${VAR}` в env-секции `.mcp.json`** (только в command/args). Server получал `process.env.SDLC_STATE_RAG_DSN = "${SDLC_STATE_RAG_DSN}"` (литерал строка) и пытался открыть PostgreSQL connection с такой строкой — падал на этапе init.

## Решение

`scripts/launch-sdlc-state-rag.sh` sanitize'ит `SDLC_STATE_RAG_DSN` перед запуском:

```bash
case "${SDLC_STATE_RAG_DSN:-}" in
  '${SDLC_STATE_RAG_DSN}' | '${'*'}')
    unset SDLC_STATE_RAG_DSN
    ;;
esac
```

Если значение начинается с `${`, переменная unset → server falls back на pglite (embedded в `.sdlc-db/`).

## Совместимость со старым plugin cache

Также переписан nvm-source-block без `# shellcheck` директив (через переменную `_nvm_path`). Это нужно потому, что hook `enforce-no-comments.sh` в кешированном plugin v0.5.1 не имеет whitelist для `# shellcheck` (whitelist добавлен только в v0.5.2).

## ⚠️ ACTION REQUIRED

1. Перезагрузите Claude Code.
2. Проверьте: `claude mcp list | grep sdlc-state-rag` → `✓ Connected`.

## Если хотите подключить реальную PostgreSQL (mid/enterprise)

Установите переменную в shell-окружении (НЕ в `.mcp.json`):

```bash
export SDLC_STATE_RAG_DSN=postgresql://user:pass@host:5432/db
```

Launcher не unset'ит реальную DSN — только литерал-плейсхолдер.

## Серия hotfix'ов с объяснением каждой итерации

| Версия | Попытка | Причина провала |
|---|---|---|
| v0.5.0 | `npx -y @ypolosov/sdlc-state-rag` | npx cold-fetch медленнее MCP health-check timeout |
| v0.5.1 | `command: "sdlc-state-rag"` (direct binary) | Не работало в nvm-окружениях (PATH без node) |
| v0.5.2 | Launcher-скрипт через `${CLAUDE_PLUGIN_ROOT}` | Подставлялся только в plugin context, не в project |
| v0.5.3 | Bash-wrapper `${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}` | Не помогло — ROOT cause не в пути, а в env-секции |
| **v0.5.4** | **DSN-sanitize в launcher** | ✓ Корневая причина устранена |
