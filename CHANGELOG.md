# Changelog

Формат соответствует [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/).
Версионирование следует [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

## [0.5.2] — 2026-05-05

### Fixed

- `.mcp.json` для `sdlc-state-rag`: прямой `command: "sdlc-state-rag"` (v0.5.1) не работает в Claude Code MCP launcher из-за ограниченного PATH (не находит `node` через nvm). Заменено на launcher-скрипт `${CLAUDE_PLUGIN_ROOT}/scripts/launch-sdlc-state-rag.sh`, который пытается резолвить бинарь через PATH → nvm.sh → стандартные локации (`/usr/local/bin`, `/opt/homebrew/bin`, `~/.local/bin`) → fallback на `npx -y`.
- `scripts/enforce-no-comments.sh`: добавлен whitelist для `# shellcheck` директив (как `# pylint:`, `// eslint-`).
- `tests/integration/sdlc-state-rag-contract.bats`: 2 новых кейса на launcher-скрипт (21→23 кейса).

### Added

- `scripts/launch-sdlc-state-rag.sh` — launcher с fallback-цепочкой для разных Node-окружений.

## [0.5.1] — 2026-05-05

### Fixed

- `.mcp.json` для `sdlc-state-rag`: `npx -y @ypolosov/sdlc-state-rag` заменён на прямой `sdlc-state-rag` без аргументов. NPX cold-fetch (108 deps включая pglite/pg/pgvector) превышает таймаут health-check Claude Code, плагиновая запись отображается как `Failed to connect`. Та же проблема была у `essence-alpha-mcp` в v0.3.1.
- README §MCP: требование `npm install -g @ypolosov/sdlc-state-rag` (минимум v0.1.1) перед использованием плагина.
- `tests/integration/sdlc-state-rag-contract.bats`: новый кейс «.mcp.json uses direct binary not npx» (21-й кейс).

## [0.5.0] — 2026-05-05

Принцип 22 «Обязательное использование плагина для write-операций» + `enforce-sdlc-phase` PreToolUse hook.

### ⚠️ ACTION REQUIRED после установки

Перезагрузить Claude Code или выполнить `/plugin reload ai-driven-sdlc` для активации нового PreToolUse hook'а.

### Added

- `scripts/enforce-sdlc-phase.sh` — PreToolUse hook принципа 22.
  Блокирует Bash blacklist (git commit/push/tag/rebase/reset/checkout/rm/merge,
  gh pr (create|merge|edit|close|reopen)|release|repo (delete|create),
  npm publish/unpublish/deprecate) и Edit/Write вне whitelist
  (`.claude/sdlc/**`, `.claude/CLAUDE.md`, `.gitignore`, `.env.example`,
  `README.sdlc.md`) при отсутствии `active_phase` в profile.md.
- `tests/unit/enforce-sdlc-phase.bats` — 10 кейсов.
- `tests/integration/enforce-sdlc-phase-integration.bats` — 4 кейса.
- `meta-templates/profile.meta.md`: поля `active_phase`, `active_phase_set_at`.
- `meta-templates/plugin-config.meta.md`: секция `phase_enforcement` (TTL, whitelist).
- `hooks/hooks.json`: PreToolUse matcher расширен до `Bash|Write|Edit`.
- `scripts/bench-hooks.sh`: entry `enforce-sdlc-phase` (avg 26ms локально).
- `.gitignore`: `.claude/sdlc/autonomy.session.md` (ephemeral HOOTL override).
- CLAUDE.md: принцип 22 + источник в таблице принципов.
- memom.md: запись add 2026-05-05.

### Override механизмы

- `/sdlc-autonomy --task hootl --duration <N>m` — ephemeral autonomy.session.md.
- `SDLC_PHASE_ENFORCE=skip` env var — escape hatch для CI.
- `SDLC_PHASE_TTL_HOURS=<N>` — переопределяет TTL (default 24 ч).

### Changed

- README inventory: Scripts 16→17, принципы 22→23, unit bats 74→84 (10→11 файлов), integration 40→44 (2→3 файла).

### Notes

- Skills `/sdlc-phase` пока не пишут `active_phase` автоматически (TODO в следующем минорном). Временно — вручную или `SDLC_PHASE_ENFORCE=skip`.
- Самоприменение (dogfooding): этот PR-релиз создавался уже после merge enforce-sdlc-phase в main; команды git push/gh release блокируются hook'ом без активной фазы. Workaround на текущей итерации — `SDLC_PHASE_ENFORCE=skip` для процесса релиза.

## [0.4.1-cleanup] — 2026-05-05 (post-v0.4.0 hotfix)

### Removed (post-v0.4.0 cleanup)

- npm-пакет `@ypolosov/essence-alpha-mcp` unpublished.
- GitHub-репо `ypolosov/essence-alpha-mcp` удалён.
- `scripts/seed-essence-alpha.sh` + `tests/unit/seed-essence-alpha.bats` (legacy bootstrap).
- `.claude/sdlc/external-systems/essence-alpha-mcp.md` (sidecar logical-системы).
- Deprecation-alias `ESSENCE_ALPHA_VALIDATE_CMD` в `check-alpha-consistency.sh`.
- `.gitignore` записи `essence-alpha.db*`.

### Changed (cleanup)

- README/agents/meta-templates: убраны упоминания `essence-alpha-mcp` как живой зависимости.
- Scripts inventory: 17 → 16. Tests inventory: unit 80 → 74 кейса.

### Preserved

- ADR-009 как Deprecated исторический record (`superseded_by: ADR-011`).

## [0.4.0] — 2026-05-05

Multi-agent extension (Wave 4) + sdlc-state-rag (Wave 5).

### ⚠️ BREAKING CHANGES

- `@ypolosov/essence-alpha-mcp` удалён из `.mcp.json`; `sdlc-alpha-tracker` дёргает только `mcp__sdlc_state_rag__state_*`.
- ENV var `ESSENCE_ALPHA_VALIDATE_CMD` переименован в `SDLC_STATE_RAG_VALIDATE_CMD` (deprecation-warning одну версию).
- ADR-009 переведён в `Deprecated` (superseded by ADR-011).

### Added (Wave 4)

- `catalogs/tool-categories.md` — 7 агностических категорий инструментов SDLC.
- `catalogs/roles.md`: новая абстрактная роль `security-engineer` + поля `tool_categories`/`agent_kind`.
- `meta-templates/target-roles.meta.md` — `<target>/.claude/sdlc/role-extensions.md`.
- `meta-templates/tool-binding.meta.md` — `<target>/.claude/sdlc/tool-bindings.md`.
- `agents/sdlc-tool-router.md` — обязательный AskUserQuestion ДО write-операций (ADR-016).
- `agents/sdlc-context-aggregator.md` — фасад консолидации с провенансом каждого фрагмента (ADR-010).
- `commands/sdlc-tools.md` — list/bind/test/unbind для биндингов категорий.
- `skills/sdlc-integrations/SKILL.md` — фаза подключения инструментов SDLC целевого.
- `scripts/check-tool-binding.sh`, `scripts/detect-credentials.sh`.
- `tests/integration/context-aggregator-mid.bats` — 20 кейсов, фикстура `tests/fixture/mid-target/`.
- ADR-010 (multi-agent topology), ADR-013 (категории как агностический интерфейс), ADR-015 (security-engineer), ADR-016 (tool-router).
- Принципы 18 (категории+роли agnostic), 19 (контекст как услуга), 19a (опрос MCP всегда до RAG).

### Added (Wave 5)

- `meta-templates/sdlc-state-rag-contract.meta.md` — контракт MCP-сервера `@ypolosov/sdlc-state-rag` (5 доменов: alpha state machine + RAG + decisions + audit + sync).
- `meta-templates/rag-config.meta.md` — RAG-конфиг по уровню SME (pet/mid/enterprise).
- `meta-templates/webhooks.meta.md` — реестр webhook-эндпоинтов для enterprise.
- `commands/sdlc-rag.md` — reindex/query/stats/purge.
- `scripts/check-rag-config.sh` — валидация по уровню SME (8 bats-кейсов).
- `scripts/migrate-essence-to-state-rag.sh` — разовая утилита миграции (--dry-run/--verify/--exec).
- `tests/unit/migrate-essence-to-state-rag.bats` — 7 кейсов.
- `tests/integration/sdlc-state-rag-contract.bats` — 20 кейсов.
- `examples/wave-5-enterprise/` — демо enterprise target с PgVector + cron + webhooks.
- TypeScript whitelist в `enforce-no-comments.sh` (`@ts-`, `eslint-`, `biome-ignore`).
- ADR-011 (sdlc-state-rag unified backend), ADR-012 (worker pattern по SME), ADR-014 (enterprise dogfooding).
- Принципы 20 (worker по SME, единый RDB), 21 (per-target БД, concurrent-safe).
- `.gitignore`: запись `.sdlc-db/`.

### Closed epics

- **#3** — runtime vs dev-time MCP разграничены (`tool-bindings.md` ↔ `.mcp.json`).
- **#6** — role-extensions фиксируют активную роль на фазе.
- **#7** — multi-agent coexistence через aggregator + RDB-backend.
- **#13** — `/sdlc-tools test` верифицирует стек на onboarding.
- **#20** — enterprise webhook + Mastra-runtime.
- **#21** — `agent_kind: ai` для delivery-lead.

### Changed

- `.mcp.json`: убран `essence-alpha`, добавлен `sdlc-state-rag` (npx).
- `agents/sdlc-alpha-tracker.md`: переключён на `mcp__sdlc_state_rag__state_*` tools + композитные `state_advance_with_decision`, `state_regress_with_audit`.
- `scripts/check-alpha-consistency.sh`: ENV var rename с deprecation warning.
- `meta-templates/plugin-config.meta.md`: добавлены секции `tool_bindings`, `rag_ref`, `workers`.
- `CLAUDE.md` принцип 13: ссылка на ADR-011 и backend `@ypolosov/sdlc-state-rag`.
- README: Skills 12→13, Commands 8→10, Agents 5→7, Catalogs 4→5, Meta-templates 11→16, Scripts 13→17, ADRs 9→14.
- Tests: unit 6→11 файлов / 31→80 кейсов; integration 0→2 файла / 0→40 кейсов.

### Внешние артефакты

- `@ypolosov/sdlc-state-rag@0.1.0` опубликован на npm (`npx -y @ypolosov/sdlc-state-rag`).
- Репо: https://github.com/ypolosov/sdlc-state-rag.

## [0.3.1] — 2026-05-04

### Fixed
- `.mcp.json` для `essence-alpha`: `npx -y @ypolosov/essence-alpha-mcp` заменён на прямой `essence-alpha-mcp serve`. NPX cold-fetch (127 deps) превышал таймаут health-check Claude Code, плагиновая запись отображалась как Failed to connect даже на исправной версии CLI.
- Скрипты `seed-essence-alpha.sh` и `check-alpha-consistency.sh`: дефолт `ESSENCE_ALPHA_CMD` / `ESSENCE_ALPHA_VALIDATE_CMD` переключён с `npx -y` на прямой бинарник.

### Changed
- README §MCP-серверы: требование `npm install -g @ypolosov/essence-alpha-mcp` (минимум v0.1.1) перед использованием плагина.
- ADR-009 / external-systems/essence-alpha-mcp.md: минимум v0.1.1 (исправлен ранний-exit stdio сервера в v0.1.0).

## [0.3.0] — 2026-05-01

### Added
- Интеграция MCP-сервера `@ypolosov/essence-alpha-mcp` как authoritative backend трекера альф (ADR-009).
- `scripts/check-alpha-consistency.sh` — PostToolUse hook валидации БД essence-alpha.
- `scripts/seed-essence-alpha.sh` — bootstrap БД с цепочками переходов OMG Essence.
- `tests/unit/check-alpha-consistency.bats` (5 кейсов), `tests/unit/seed-essence-alpha.bats` (4 кейса).
- ADR-009 essence-alpha-mcp integration; NFR `reliability` и `maintainability`.
- `external-systems/essence-alpha-mcp.md` — sidecar logical-системы (Принцип 17).
- `meta-templates/alpha-state.meta.md`: режим `alpha-snapshot` плюс поля `source_of_truth`, `snapshot_role`, `generated_after`.
- `phases/testing/testing.md` §7a — снимок latency 8 hooks.

### Changed
- `alphas.md` сжат до PR-видимого snapshot; журнал переходов делегирован MCP-БД.
- `agents/sdlc-alpha-tracker.md`: 6 MCP-tools; маппинг PascalCase ↔ kebab-case.
- `scripts/bench-hooks.sh` расширен с 5 до 8 hooks (+ check-alpha-consistency, enforce-no-comments, enforce-format-lint).
- `phases/architecture/architecture.md`: ADR-009 в §5; NFR reliability/maintainability в §4.
- `CLAUDE.md` принцип 13: дополнено упоминанием MCP-backend и snapshot-роли markdown.
- `memom.md`: запись `2026-05-01 — Принцип 13: детерминированный backend через essence-alpha-mcp`.
- `plugin-config.md`: 6 активных tdd_pairs (было 4 в 0.2.1).
- README: scripts 11→13, bats 4→6 файлов, 21→31 кейс, MCP инвентарь.
- Альфа Way of Working продвинута через MCP до **Working Well** (была In Use).

### Fixed
- `validate-artifact.sh` парсер ≤15 слов: false positive на нумерованных заголовках.
- 7 находок аудита 2026-04-30 (issue templates, focus_count, evidence-version).

## [0.2.1] — 2026-04-19

### Fixed
- Убран `context7` из `.mcp.json`: конфликт с dedicated плагином `context7@claude-plugins-official`.
- README §«Рекомендуемые MCP-плагины»: документирует внешние зависимости.

## [0.2.0] — 2026-04-19

### Added
- Фаза testing: `phases/testing/testing.md` (пирамида + 5 fitness-функций).
- Фаза development: `phases/development/development.md` (план TDD + backlog 6 единиц).
- Фаза deployment: `phases/deployment/deployment.md` (стратегия релизов + CHANGELOG).
- Фаза operations: `phases/operations/operations.md` (GitHub Issues как канал feedback).
- Описание подсистемы hooks: `external-systems/hooks.md` (материализованный анализ §8 architecture).
- Скрипт `scripts/bootstrap-dev-env.sh` — детектит pkg-manager, выводит команду установки.
- Скрипт `scripts/bench-hooks.sh` — бенчмарк 5 детерминированных hooks (NFR hooks-performance).
- Bats-тесты: `tests/unit/validate-artifact.bats` (6), `tests/unit/check-cross-refs.bats` (6), `tests/unit/enforce-no-comments.bats` (6), `tests/unit/bootstrap-dev-env.bats` (3).
- CI workflow `.github/workflows/ci.yml` — bats + shellcheck + shfmt + deterministic checks.
- Фикстура `tests/fixture/minimal-target/` — минимальный валидный каркас для integration-тестов.
- GitHub Issue templates: `.github/ISSUE_TEMPLATE/bug.yml`, `feature.yml`, `question.yml`.
- `SUPPORT.md` в корне — канал обратной связи и политика reply.
- `CHANGELOG.md` восстанавливает версии 0.1.0 → 0.1.2 + текущая 0.2.0.
- README плагина §Scripts расширен до 11 скриптов.

### Changed
- `plugin-config.md`: активированы `tdd_pairs` для 4 скриптов; formatter=`shfmt -i 2 -ci`, linter=`shellcheck`.
- `profile.md`: testing=mid, development=mid, deployment=mid, operations=pet.
- `alphas.md`: Software System → Demonstrable; Work → Under Control; Way of Working → In Use.
- Убрана неиспользуемая переменная `body` в `scripts/validate-artifact.sh` (SC2034).
- `scripts/check-cross-refs.sh`: рефактор SC2015 (паттерн `A && B || C` → explicit if-then-else).
- Трассировки `traces_to` заполнены между всеми соседними фазами (двунаправленная цепочка).

### Fixed
- `plugin-config.md`: формат `command:` без пустой строки (парсер hook игнорирует).
- Интерпретация `scope_globs` hook-ом: inline-массив YAML вместо multi-line списка.

## [0.1.2] — 2026-04-17

### Fixed
- Интерактивность skills фаз: обязательный вызов `AskUserQuestion` до записи артефактов.
- 6 hook-багов: шедбанг, экранирование, парсинг YAML, обработка stdin.

## [0.1.1] — 2026-04-15

### Changed
- Release bump; подготовка к публикации в marketplace.

## [0.1.0] — 2026-04-10

### Added
- Первый релиз плагина: каркас SDLC, catalogs, мета-шаблоны, 12 skills, 8 commands, 5 agents, 8 скриптов.
- Принципы Волны 1 (1-13 + 4a).
- Демо-сценарий на todo-list.

[Unreleased]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.2...HEAD
[0.5.2]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/releases/tag/v0.1.0
