---
name: testing
type: testing
phase: testing
sme_level: mid
method: Пирамида автотестов с покрытием как пороговым критерием
tool: Unit + Integration + E2E
alphas: [Software System, Requirements]
disciplines: [software-testing, tdd]
role: method-engineer
traces_from:
  - ../requirements/requirements.md
  - ../architecture/architecture.md
traces_to: []
system_of_attention: ai-driven-sdlc-plugin
fitness_functions: [tool-names-isolation, hooks-performance, alpha-evidence-consistency, secrets-not-in-git, reversibility-integration]
created: 2026-04-19
updated: 2026-04-19
---

# Стратегия тестирования плагина ai-driven-sdlc

## 1. Назначение

Продвинуть альфу Software System от Architecture Selected к Demonstrable.
Продвинуть альфу Requirements от Acceptable к Addressed при прохождении тестов.
Метод — пирамида автотестов плюс fitness-функции архитектуры.

## 2. Привязка к фазе и методу

- Фаза: testing.
- Уровень SME: mid.
- Дисциплины: software-testing, test-driven-development.
- Инструменты: bats-core (unit bash), shellcheck (static), validate-artifact.sh (integration).
- Coverage-gate: green-build без численного порога (см. §5).

## 3. Пирамида тестов

### 3.1. Unit (основание)

Тестирование отдельных bash-функций и скриптов изолированно.

| Что тестируется | Инструмент | Расположение |
|---|---|---|
| scripts/validate-artifact.sh | bats-core | tests/unit/validate-artifact.bats |
| scripts/check-cross-refs.sh | bats-core | tests/unit/check-cross-refs.bats |
| scripts/check-system-readmes.sh | bats-core | tests/unit/check-system-readmes.bats |
| scripts/check-memom-consistency.sh | bats-core | tests/unit/check-memom-consistency.bats |
| scripts/check-readme-inventory.sh | bats-core | tests/unit/check-readme-inventory.bats |
| scripts/enforce-tdd.sh | bats-core | tests/unit/enforce-tdd.bats |
| scripts/enforce-format-lint.sh | bats-core | tests/unit/enforce-format-lint.bats |
| scripts/enforce-no-comments.sh | bats-core | tests/unit/enforce-no-comments.bats |
| scripts/bootstrap-target.sh | bats-core | tests/unit/bootstrap-target.bats |

### 3.2. Static (слой анализа)

- shellcheck по всем `.sh` — ноль warnings.
- validate-artifact.sh по всем `.claude/sdlc/**/*.md` в тестовой фикстуре.

### 3.3. Integration (средний слой)

Сценарии прогона commands на тестовой фикстуре-проекте.

| Сценарий | Трассировка на AC |
|---|---|
| /sdlc-init в пустом проекте создаёт 7 файлов | AC-01.1 |
| /sdlc-init повторно отказывает без --merge | AC-01.2 |
| /sdlc-phase vision вызывает AskUserQuestion до write | AC-02.1 |
| sdlc-alpha-tracker отказывает без evidence | AC-03.1 |
| /sdlc-focus materialized создаёт README.sdlc.md | AC-04.2 |
| /sdlc-focus logical создаёт external-systems/slug.md | AC-04.3 |
| /sdlc-audit формирует audit.md с альтернативами | AC-05.1 |
| pre-commit блокирует CLAUDE.md без memom записи | AC-06.1 |
| check-readme-inventory блокирует переименование | AC-08.1 |

### 3.4. E2E (вершина)

- Демо-сценарий 1 — прогон на todo-list (Волна 1).
- Демо-сценарий 2 — dogfooding плагина (Волна 2, уже выполнен).

## 4. Fitness-функции архитектуры

Автоматические проверки NFR из `architecture.md` §4.

| Fitness | NFR | Реализация | Триггер |
|---|---|---|---|
| tool-names-isolation | extensibility | `grep -r "ADR\|Lean Canvas\|Gherkin" skills/ agents/ commands/` пуст | CI + pre-commit |
| hooks-performance | hooks-performance | `time validate-artifact.sh` <200ms на средний артефакт | CI бенчмарк |
| alpha-evidence-consistency | determinism | каждое состояние в `alphas.md` имеет существующий артефакт | CI + PostToolUse |
| secrets-not-in-git | security | gitleaks по репозиторию; `.env` в `.gitignore` | pre-commit + CI |
| reversibility-integration | reversibility | integration-сценарий AC-01.2 (`/sdlc-init` отказ без `--merge`) | CI integration |

## 5. Coverage-gate

Numerical coverage не применяется — метрика спорна для bash.
Пороговый критерий фазы — green-build всех слоёв:

- все bats-тесты проходят.
- shellcheck выдаёт ноль warnings.
- все 4 fitness-функции зелёные.
- validate-artifact.sh по всем артефактам проходит.

## 6. Трассируемость

- `traces_from`:
  - [`requirements.md`](../requirements/requirements.md) — через AC каждой US.
  - [`architecture.md`](../architecture/architecture.md) §4 — через fitness NFR.
- `traces_to`: пуст; фаза development ещё не начата.
- Каждая US из requirements имеет минимум один integration-сценарий.

## 7. Критерии готовности фазы

- Артефакт `testing.md` валиден.
- Пирамида зафиксирована (§3.1–§3.4).
- Fitness-функции определены с триггерами (§4).
- Coverage-gate зафиксирован (§5).
- Трассировка на requirements и architecture присутствует (§6).
- Альфа Software System готова к Demonstrable при реализации тестов.

## 8. Открытые вопросы

- Реализация bats-тестов — задача фазы development.
- ~~Бенчмарк hooks-performance требует фикстуры «средний артефакт».~~
  - Резолюция 2026-04-19: `scripts/bench-hooks.sh` на `testing.md` как samples; все <200ms.
- Gitleaks конфиг — настроить при первом CI-прогоне.
- ~~Тестовая фикстура для integration-сценариев не создана.~~
  - Резолюция 2026-04-19: `tests/fixture/minimal-target/` — валидный минимальный каркас.
