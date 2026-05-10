# v0.6.0 — Wave 6 Phase 1: pre-validation fixes для enterprise-применения

Дата: 2026-05-10.

## TL;DR

Wave 6 — валидация плагина на реальном enterprise-проекте через применение к `~/DEV/GITS/gt`. Эта Phase 1 — фиксы P0-блокеров, без которых validation бессмысленна.

После критического аудита плана Wave 6 обнаружены 2 P0 gaps в плагине, которые блокируют enterprise-применение:
- **A1**: `phases/architecture/adr/` hardcoded — gt и подобные enterprise-проекты имеют ADR в `docs/adrs/` или `architecture/decisions/`.
- **A2**: `/sdlc-init` не создаёт `<target>/.mcp.json` → MCP-сервер `sdlc-state-rag` не подключается per-target (нарушение принципа 21).

Этот релиз закрывает оба.

## Что добавлено

### Fix A2: Авто-создание/мердж `<target>/.mcp.json`

`scripts/bootstrap-target.sh` после создания `.claude/sdlc/`:

1. Если `<target>/.mcp.json` отсутствует — создаёт с записью `sdlc-state-rag` (bash-launcher pattern).
2. Если существует БЕЗ `sdlc-state-rag` — добавляет entry, не трогает остальные `mcpServers.*`.
3. Если существует С `sdlc-state-rag` — по умолчанию keep (safe). Overwrite через env var `MCP_OVERWRITE_SDLC_RAG=yes`.
4. Если JSON невалидный — exit 2 с сообщением.

Запись:

```json
"sdlc-state-rag": {
  "type": "stdio",
  "command": "bash",
  "args": ["-c", "exec \"${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/launch-sdlc-state-rag.sh\""],
  "env": { "SDLC_STATE_RAG_DSN": "${SDLC_STATE_RAG_DSN}" }
}
```

Эффект: каждая целевая система получает свой instance `sdlc-state-rag` с per-target БД (pglite по умолчанию), что соответствует принципу 21.

### Fix A1: Поле `adr_paths` в `plugin-config.md`

Массив путей к каталогам ADR в целевом проекте. Поддерживает greenfield-таргеты (default) и existing-таргеты с собственной структурой docs.

```yaml
# Default greenfield (если поле отсутствует или явно):
adr_paths:
  - phases/architecture/adr/

# Existing-проект с docs/:
adr_paths:
  - docs/adrs/
  - devops/configuration/decisions/
```

`scripts/check-adr-paths.sh` валидирует существование путей.
`agents/sdlc-context-aggregator.md` использует `adr_paths` при чтении ADR.

## Что изменилось

- `meta-templates/plugin-config.meta.md` — раздел `adr_paths` (Волна 6).
- `agents/sdlc-context-aggregator.md` — раздел «Подготовка» включает извлечение `adr_paths`.
- `README.md` — Scripts 18→19, unit tests 11→13 файлов / 84→94 кейса.

## Тесты

- `tests/unit/init-mcp-json.bats` — 5 кейсов (Fix A2).
- `tests/unit/plugin-config-adr-paths.bats` — 5 кейсов (Fix A1).
- Total bats: 13 unit файлов, 94 кейса (было 11 / 84).

## ⚠️ ACTION REQUIRED

1. Перезагрузите Claude Code: `/plugin update ai-driven-sdlc` или restart.
2. После update — `/sdlc-init` в новых targets создаст `.mcp.json` автоматически.
3. Existing targets — `.mcp.json` создаётся при следующем `/sdlc-init --merge`.

## Что дальше

Phase 2 Wave 6 — gt-validation:
- `git worktree add ~/DEV/GITS/gt-sdlc-experiment experiment/sdlc-plugin-validation`.
- `/sdlc-init` в gt-experiment с фиксами A1/A2.
- Walkthrough 3 фаз (vision/requirements/architecture) на synthetic feature `add-tournament-mode`.
- Documenting gaps → backlog Wave 7.

## Не делается в v0.6.0

- ❌ RAG embedder (CocoIndex / Ollama / Onyx) — отложен до явной необходимости после gt-validation.
- ❌ Принцип 23 (избегать on-demand API LLM) — отложен.
- ❌ Cross-tool RAG категория — Wave 7+.
- ❌ Phase 4-7 в gt walkthrough — только vision/requirements/architecture.

## Известные limitations

- **Gap-2 (P1, обнаружен в этой сессии)**: hook `enforce-no-comments.sh` не различает heredoc-контент в bash-скриптах от code-comments. При редактировании плагин-скриптов с heredocs (CLAUDE.md шаблон, .gitignore content) hook жалуется на pre-existing markdown-заголовки. Записан в backlog Wave 7.
- **Gap-0 (P1)**: hook `enforce-sdlc-phase.sh` блокирует write на файлы вне CWD-tree (например plan-файлы в `~/.claude/plans/`). Решение: проверять realpath(file_path), пропускать paths вне target.

Эти gaps не блокируют v0.6.0 функциональность, но мешают dogfooding-разработке плагина.
