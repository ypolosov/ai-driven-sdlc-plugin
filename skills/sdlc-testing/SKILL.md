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

## Мета-вопросы

Опрос делегируется `sdlc-method-engineering` с контекстом `phase: testing`.
Дополнительно:
1. Какая стратегия пирамиды тестов? (pet: smoke; mid: unit+integration+E2E; enterprise: + mutation/chaos)
2. Какие целевые показатели покрытия?
3. Нужны ли contract tests (на границах с внешними системами)?
4. Какие fitness-функции архитектуры проверяются автоматически?

## Протокол инстанцирования

1. Вызвать `sdlc-method-engineering` с `phase: testing`.
2. Получить уровень SME и инструменты тестирования.
3. Через `context7` получить референс выбранного инструмента.
4. Инстанцировать артефакт стратегии тестирования в `phases/testing/`.
5. Обеспечить trace-ссылки на requirements и architecture.
6. Если настраивается coverage-gate — добавить в `plugin-config.md`.
7. Обновить `alphas.md`.

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
