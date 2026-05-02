# Changelog

Формат соответствует [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/).
Версионирование следует [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

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

[Unreleased]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/releases/tag/v0.1.0
