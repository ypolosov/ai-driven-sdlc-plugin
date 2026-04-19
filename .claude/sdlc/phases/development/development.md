---
name: development
type: development
phase: development
sme_level: mid
method: TDD-first итерации с CI-гейтами и линтерами
tool: bats-core + shellcheck + shfmt + GitHub Actions
alphas: [Software System, Work]
disciplines: [test-driven-development, software-engineering]
role: method-engineer
traces_from:
  - ../testing/testing.md
  - ../architecture/architecture.md
traces_to: []
system_of_attention: ai-driven-sdlc-plugin
created: 2026-04-19
updated: 2026-04-19
---

# Стратегия фазы development плагина ai-driven-sdlc

## 1. Назначение

Продвинуть альфу Software System от Architecture Selected к Demonstrable.
Продвинуть альфу Work от Initiated к Under Control.
Метод — TDD-first итерации; каждая единица работы закрывается зелёным тестом.

## 2. Привязка к фазе и методу

- Фаза: development.
- Уровень SME: mid.
- Дисциплины: test-driven-development, software-engineering.
- Инструменты: bats-core (unit tests), shellcheck (static), shfmt (formatter), GitHub Actions (CI).
- Work-state: `alphas.md` (макро) + GitHub Issues через MCP (micro units).

## 3. Содержание

### 3.1. TDD-цикл (принцип 5)

Порядок для каждой единицы работы:

1. Написать bats-тест (красный).
2. Реализовать минимум кода (зелёный).
3. Провести рефакторинг при зелёных тестах.
4. Слой 1 — `enforce-tdd.sh` проверяет пару source↔test.
5. Слой 2 — `sdlc-artifact-validator` проверяет семантику теста.
6. Слой 3 — green-build на фазе testing (§5 testing.md).

### 3.2. Инструментальная цепочка (принцип 6)

| Задача | Инструмент | Scope | Запуск |
|---|---|---|---|
| Unit-тесты | bats-core | `scripts/**/*.sh` | `bats tests/unit/` |
| Static-анализ | shellcheck | все `.sh` | `shellcheck scripts/*.sh` |
| Формат | shfmt | `scripts/**/*.sh` | `shfmt -d -i 2 scripts/` |
| CI-оркестрация | GitHub Actions | репо | `.github/workflows/ci.yml` |

### 3.3. Work-трекинг (принцип 9)

- Единица работы — issue в GitHub с лейблом `work-unit`.
- Evidence для Work alpha — закрытый issue с PR-ссылкой.
- Макросостояние в `alphas.md` обновляется при закрытии milestone.
- state_artifact в `plugin-config.md`: `kind: mcp`, `ref: github`.

### 3.4. Первый инкремент

- Установить bats-core в `vendor/bats-core/` (git submodule).
- Написать `tests/unit/validate-artifact.bats` — 1 базовый тест.
- Зафиксировать `BATS_LIB_PATH` в makefile или wrapper-скрипте.
- Evidence для Software System: прогон `bats tests/unit/` зелёный.

### 3.5. Backlog первых итераций

Список единиц работы (каждая — отдельный issue):

1. Unit-тесты для 9 скриптов из `testing.md` §3.1.
2. Shellcheck-чистота по всем `.sh`.
3. GitHub Actions workflow `ci.yml` с bats + shellcheck.
4. Shfmt интеграция в pre-commit.
5. Gitleaks config + CI-gate (NFR secrets-not-in-git).
6. Реализация activate `tdd_pairs` в `plugin-config.md`.

## 4. Трассируемость

- `traces_from`:
  - [`testing.md`](../testing/testing.md) §3 — пирамида и fitness.
  - [`architecture.md`](../architecture/architecture.md) §3 — подсистемы и ADR.
- `traces_to`: пуст; deployment ещё не начат.
- Каждая единица работы ссылается на AC из `requirements.md`.

## 5. Критерии готовности фазы

- Артефакт `development.md` валиден.
- bats-core установлен; первый тест проходит зелёным.
- GitHub Actions workflow создан и прогоняется.
- shellcheck выдаёт ноль warnings на модифицированных `.sh`.
- shfmt формат применён к `scripts/**/*.sh`.
- Альфа Software System достигла Demonstrable при зелёном CI.
- Альфа Work достигла Under Control при ≥1 закрытом issue.

## 6. Открытые вопросы

- Установка bats-core через submodule или vendor-copy — решить при первой реализации.
- GitHub Issues template для `work-unit` — создать при первом issue.
- Matrix-CI (ubuntu + macos) — отложить до deployment.
