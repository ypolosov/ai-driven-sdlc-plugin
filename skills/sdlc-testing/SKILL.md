---
name: sdlc-testing
description: Фаза Testing — проверка соответствия воплощения описанию. TDD-контракты, автотесты, покрытие. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Запускается командой /sdlc-phase testing.
phase: testing
scope: phase
disciplines: [software-testing, tdd]
alphas: [Software System, Requirements]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Ручная проверка основного сценария и редкие автотесты"}
  mid: {method_abstract: "Пирамида автотестов с покрытием как пороговым критерием"}
  enterprise: {method_abstract: "Исполняемые инварианты архитектуры и проверка устойчивости под нагрузкой"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Testing

## Назначение фазы

Формулировка тестов как контрактов будущего поведения (TDD).
Проверка соответствия кода требованиям.
Зафиксировать стратегию покрытия и пирамиду тестов.

## Альфы, которые продвигает

- **Software System** — от Demonstrable до Usable.
- **Requirements** — от Acceptable до Addressed (через прохождение тестов).

## Дисциплины

- Software testing.
- Test-driven development.

## Обязательный интерактивный опрос (принцип 1)

**Skill ведёт пользователя по фазе; не заменяет его решения автогенерацией.**

Шаг 0 — ДО записи любых артефактов:
1. Вызвать `AskUserQuestion` с вопросами ниже.
2. Показать 2–3 альтернативы по каждому выбору.
3. Дождаться ответа пользователя; не угадывать.
4. Auto mode среды не отменяет интерактивность.
5. Только `/sdlc-autonomy --task hootl` разрешает пропуск опроса.
6. Если `AskUserQuestion` недоступна — остановиться и сообщить пользователю.

### Вопросы фазы Testing

Сначала SME-опрос делегируется `sdlc-method-engineering` с `phase: testing`.
Дополнительно:
1. Какая стратегия пирамиды тестов? (pet: smoke; mid: unit+integration+E2E; enterprise: + mutation/chaos)
2. Какие целевые показатели покрытия?
3. Нужны ли contract tests (на границах с внешними системами)?
4. Какие fitness-функции архитектуры проверяются автоматически?

## Протокол инстанцирования

1. **Обязательно:** вызвать `AskUserQuestion` с блоком выше и дождаться ответов.
2. Вызвать `sdlc-method-engineering` с `phase: testing`.
3. Получить уровень SME и инструменты тестирования.
4. Через `context7` получить референс выбранного инструмента.
5. Инстанцировать артефакт стратегии тестирования в `phases/testing/`.
6. Обеспечить trace-ссылки на requirements и architecture.
7. Если настраивается coverage-gate — добавить в `plugin-config.md`.
8. Обновить `alphas.md`.

## Критерии готовности

- Артефакт фазы валиден.
- `traces_from` указывает на requirements и architecture.
- Альфа Software System достигла Usable при проходе тестов.
- Coverage-gate (если включён) проходит.
- `check-cross-refs.sh` проходит.

## Следующие шаги по ролям

- tester → добавить недостающие тесты; переоткрыть фазу при изменениях.
- developer → `/sdlc-phase development` для реализации теста.
- devops → `/sdlc-phase deployment`.
