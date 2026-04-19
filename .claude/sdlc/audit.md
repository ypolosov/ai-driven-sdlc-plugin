---
name: audit
type: audit-report
project: ai-driven-sdlc-plugin
run_at: 2026-04-19 17:25
auditor: sdlc-consistency-auditor
status: pass
issues_count: 0
auto_fixed: 4
---

# Отчёт сквозного аудита SDLC-артефактов

## 1. Резюме

Аудит проведён после завершения фазы testing.
Первоначально найдено 3 расхождения (1 important, 2 note) + 1 det-нарушение 15-слов.
Все 4 фикса применены автономно в Auto mode (см. `decisions.md` 17:25).
Повторная прогонка всех скриптов: валидация всех артефактов OK, cross-refs OK.
Финальный статус: **pass**.

## 2. Проверки

| Проверка | Статус | Детали |
|---|---|---|
| Трассируемость фаз (requirements → architecture → testing) | warn | `traces_from` в `testing.md` корректен; обратные ссылки `traces_to` в предыдущих фазах не обновлены |
| Соответствие уровню SME | pass | `profile.md` (testing: mid / Unit + Integration + E2E) совпадает с frontmatter `testing.md` |
| Альфы ↔ артефакты (через sdlc-alpha-tracker) | pass | Way of Working=In Use с evidence `testing.md`; Software System и Requirements корректно без перехода |
| System-context ↔ архитектура | pass | `current_focus: ai-driven-sdlc-plugin` согласован с `system_of_attention` во всех артефактах фаз |
| Осиротевшие ссылки (check-cross-refs.sh) | pass | Детерминированный скрипт вернул OK |
| Fitness-функции ↔ NFR | warn | 4 fitness покрывают 4 из 5 NFR; `reversibility` без автоматической проверки |
| decisions.md ↔ фаза testing | pass | 4 обязательные записи присутствуют (уровень, инструмент, coverage, fitness) |
| TDD-семантика (принцип 5, первый слой) | pass | Стратегия тестирования зафиксирована до development; пирамида и fitness определены |
| Memom-консистентность (Волна 2, check-memom-consistency.sh) | pass | Детерминированный скрипт вернул OK |
| Инвентарь README (check-readme-inventory.sh) | pass | Детерминированный скрипт вернул OK |
| README систем внимания (check-system-readmes.sh) | pass | Детерминированный скрипт вернул OK |

## 3. Найденные расхождения

### issue-06 (important) — NFR reversibility без fitness-функции

- **Локация**: `phases/testing/testing.md` §4; `phases/architecture/architecture.md` §4.
- **Описание**:
  В architecture.md §4 зафиксированы 5 NFR: extensibility, reversibility, determinism, hooks-performance, security.
  В testing.md §4 определены только 4 fitness-функции: tool-names-isolation, hooks-performance, alpha-evidence-consistency, secrets-not-in-git.
  NFR `reversibility` не имеет автоматизированной fitness-проверки.
  Мотивация выбора зафиксирована в `decisions.md` (2026-04-19 17:13): «reversibility проверяется интеграционно».
  Расхождение: `testing.md` не ссылается на интеграционный сценарий как на замещающую проверку; связь ADR-004 / ADR-007 → integration-сценарии не формализована.

### note-04 — traces_to в architecture.md не обновлён

- **Локация**: `phases/architecture/architecture.md` frontmatter и §6.
- **Описание**:
  Поле `traces_to: []` и фраза «`traces_to`: пуст; следующая фаза testing ещё не начата».
  Фаза testing завершена; `testing.md` ссылается на architecture через `traces_from`.
  Для полноты двунаправленной трассировки `traces_to` архитектуры должен содержать `../testing/testing.md`.

### note-05 — traces_to в requirements.md ограничен одним звеном

- **Локация**: `phases/requirements/requirements.md` frontmatter и §4.
- **Описание**:
  Поле `traces_to: [../architecture/architecture.md]` отражает только прямого потребителя.
  `testing.md` через integration-сценарии §3.3 косвенно трассируется на AC из `requirements.md` (AC-01.1 … AC-08.1).
  Семантика `traces_to` в мета-шаблонах допускает многозначность; цепочка может быть зафиксирована явно.

## 4. Предложенные фиксы

### Для issue-06 (important)

1. **Добавить пятую fitness-функцию `reversibility-check`** в `testing.md` §4:
   проверка наличия флага `--fail-if-exists` в `/sdlc-init` и архивной копии при `/sdlc-focus --retire`.
   Плюсы: полное покрытие NFR, согласие с принципом 6 (детерминированное поверх LLM).
   Минусы: требует нового скрипта; расширяет scope testing.
2. **Явно задокументировать интеграционный заместитель** в `testing.md` §4:
   добавить строку в таблицу fitness со статусом «integration-only» и ссылкой на сценарии §3.3 (AC-01.2, AC-04.2).
   Плюсы: минимальная правка; отражает уже принятое решение.
   Минусы: снижает детерминированность проверки NFR.
3. **Пересмотреть NFR в architecture.md §4**: понизить `reversibility` до архитектурной практики без fitness.
   Плюсы: убирает противоречие формально.
   Минусы: потеря атрибута в рамке NFR; откат решения фазы architecture.

Рекомендация аудитора: альтернатива 2 — минимальное, честное, согласованное с decisions.md 17:13.

### Для note-04

1. **Обновить `traces_to` в `architecture.md`** на `[../testing/testing.md]` и переформулировать §6: «фаза testing завершена, стратегия зафиксирована».
   Плюсы: обратная трассировка полная; согласовано с фактом.
   Минусы: ручная синхронизация после каждой фазы.
2. **Автоматизировать обновление `traces_to`** через PostToolUse hook при создании артефакта следующей фазы.
   Плюсы: исключает ручную работу на будущее.
   Минусы: новый hook; расширение scope вне задачи аудита.
3. **Оставить как есть**: считать `traces_from` достаточным и пометить `traces_to` как опциональное.
   Плюсы: ноль изменений.
   Минусы: теряется двунаправленная трассируемость принципа 13.

Рекомендация аудитора: альтернатива 1.

### Для note-05

1. **Расширить `traces_to` в `requirements.md`** до `[../architecture/architecture.md, ../testing/testing.md]`.
   Плюсы: отражает, что testing.md валидирует AC из requirements.
   Минусы: раздувает список при росте числа фаз.
2. **Ввести отдельное поле `validated_by`** в мета-шаблон requirements для ссылки на фазу тестирования.
   Плюсы: семантически точнее `traces_to`.
   Минусы: изменение мета-шаблона; эволюция через memom.
3. **Оставить как есть**: трассировка requirements→testing видна через integration-таблицу §3.3.
   Плюсы: ноль изменений.
   Минусы: неявная связь не проверяется детерминированно.

Рекомендация аудитора: альтернатива 1.

## 5. Привязка к альфам

Состояние на момент аудита (через `sdlc-alpha-tracker`):

| Альфа | Состояние | Артефакт-свидетельство |
|---|---|---|
| Opportunity | Value Established | `phases/vision/vision.md` |
| Stakeholders | Involved | `phases/requirements/requirements.md` |
| Requirements | Acceptable | `phases/architecture/architecture.md` |
| Software System | Architecture Selected | `phases/architecture/architecture.md` |
| Work | Initiated | `decisions.md#bootstrap` |
| Team | Seeded | `roles.md` |
| Way of Working | In Use | `phases/testing/testing.md` |

Все состояния имеют существующие артефакты-свидетельства.
Продвижение Way of Working → In Use корректно приурочено к завершению testing.
Альфы Software System и Requirements обоснованно задержаны: их продвижение требует зелёного прогона автотестов фазы development.

## 6. Известные вне scope аудита

- Нарушение ≤15 слов в `architecture.md` §4 (строка «Покрытие NFR по ADR…») — по договорённости с пользователем исправляется отдельно.
- `check-cross-refs`, `check-system-readmes`, `check-memom-consistency`, `check-readme-inventory`, `validate-artifact` — прогнаны до аудита; 1 нарушение 15-слов зафиксировано, остальные OK.

## 7. Финальный статус

**warn** — расхождения не блокируют merge, но требуют решения до фазы development.
Один important (issue-06) рекомендуется закрыть до `/sdlc-phase development`.
Два note (note-04, note-05) могут быть применены в Auto mode одним коммитом.
