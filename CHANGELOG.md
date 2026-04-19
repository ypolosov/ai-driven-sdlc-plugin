# Changelog

Формат соответствует [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/).
Версионирование следует [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

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

[Unreleased]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/releases/tag/v0.1.0
