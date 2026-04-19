---
name: hooks
type: system-readme
kind: logical
role_vs_target: subsystem
project: ai-driven-sdlc-plugin
last_focused_at: 2026-04-19
focus_count: 1
updated: 2026-04-19
---

# Описание системы hooks

## 1. Назначение и границы

Подсистема hooks обеспечивает детерминированные проверки артефактов и кода.
Граница — композиция `hooks/hooks.json` + `scripts/enforce-*.sh` + `scripts/check-*.sh`.
Конфигурация команд — `plugin-config.md` (tdd_pairs, formatter, linter, scope).
Запись о системе в `system-context.md` таблица систем внимания.

## 2. Текущий фокус

- Роль относительно целевой (плагин): subsystem.
- last_focused_at: 2026-04-19.
- focus_count: 1.

## 3. Состояние альф относительно системы

Данные запрашиваются через `sdlc-alpha-tracker` (принцип 13).

| Альфа | Состояние | Артефакт-свидетельство |
|---|---|---|
| Software System | Architecture Selected | `architecture.md` §3.2 (подсистема hooks) |
| Requirements | Acceptable | `architecture.md` §4 (NFR hooks-performance) |
| Way of Working | In Use | `testing.md` §4 (fitness hooks-performance) |

## 4. Связанные артефакты SDLC

- `phases/architecture/architecture.md` §3.1 — функция «Валидация артефактов».
- `phases/architecture/architecture.md` §3.2 — подсистема hooks (materialized).
- `phases/architecture/architecture.md` §4 — NFR hooks-performance.
- `phases/architecture/adr/ADR-005-tdd-three-layers.md` — TDD в три слоя.
- `phases/architecture/adr/ADR-006-deterministic-over-llm.md` — детерминированное первично.
- `phases/testing/testing.md` §3.1 — unit-тесты bats для каждого скрипта.
- `phases/testing/testing.md` §4 — fitness hooks-performance <200ms.
- `plugin-config.md` — `tdd_scope`, `formatter`, `linter`, `no_comments_whitelist`.

## 5. Роли, активные в системе

- `method-engineer` — определяет политики hooks через `plugin-config.md`.
- `developer` — затронут PreToolUse блокировкой TDD и no-comments.
- `sdlc-artifact-validator` — LLM-агент, вызываемый PostToolUse.
- `sdlc-consistency-auditor` — LLM-агент, вызываемый PostToolUse async.

Определения ролей — `catalogs/roles.md` плагина.

## 6. Состав hooks (детали)

### 6.1. Скрипты детерминированной проверки

| Скрипт | Триггер | Цель |
|---|---|---|
| validate-artifact.sh | PostToolUse Write/Edit на `.claude/sdlc/**` | frontmatter и 15-слов |
| check-cross-refs.sh | PostToolUse Write/Edit на `.claude/sdlc/**` | осиротевшие markdown-ссылки |
| check-system-readmes.sh | PostToolUse Write/Edit на `system-context.md` | каждая система имеет README |
| check-memom-consistency.sh | pre-commit | CLAUDE.md без memom → блок |
| check-readme-inventory.sh | pre-commit | README плагина синхронен с файлами |
| enforce-tdd.sh | PreToolUse Write/Edit на src/** | парный тест или подтверждение |
| enforce-format-lint.sh | PreToolUse Write/Edit на code | форматер ОК |
| enforce-no-comments.sh | PreToolUse Write/Edit на code | комментарии запрещены |
| bootstrap-target.sh | ручной запуск /sdlc-init | создание каркаса |

### 6.2. Три слоя TDD (принцип 5)

- Слой 1: `enforce-tdd.sh` — проверка пары source↔test.
- Слой 2: `sdlc-artifact-validator` — семантика теста относительно diff.
- Слой 3: coverage-gate фазы testing — в mid это green-build без %.

### 6.3. Открытые вопросы подсистемы

- Бенчмарк hooks-performance <200ms не реализован.
- Секция hooks в plugin-config.md не содержит конкретных tdd_pairs.
- Fixture-проект для integration-тестов hooks отсутствует.

## 7. Приоритет при аудите

TTL системы из `plugin-config.md` — 30 дней.
Фокус свежий (2026-04-19); расхождения получают полный приоритет.
