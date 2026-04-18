---
name: sdlc-requirements
description: Фаза Requirements — декомпозиция целей в проверяемые единицы работы. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Запускается командой /sdlc-phase requirements.
phase: requirements
scope: phase
disciplines: [requirements-engineering, stakeholder-analysis]
alphas: [Requirements, Stakeholders]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Свободный список желаемого поведения без критериев приёмки"}
  mid: {method_abstract: "Декомпозиция на проверяемые единицы с явными критериями готовности и приёмки"}
  enterprise: {method_abstract: "Формальная спецификация с трассируемостью, верификацией и управлением изменениями"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Requirements

## Назначение фазы

Декомпозировать ценность из vision в проверяемые единицы работы.
Сформулировать критерии приёмки для каждой единицы.
Зафиксировать связи между требованиями и стейкхолдерами.

## Альфы, которые продвигает

- **Requirements** — от Conceived до Bounded (pet) или Coherent (mid+).
- **Stakeholders** — от Represented до Involved.

## Дисциплины

- Requirements engineering.
- Stakeholder analysis.

## Мета-вопросы

Опрос делегируется `sdlc-method-engineering` с контекстом `phase: requirements`.
Дополнительно:
1. Какие единицы работы нужны минимально для MVP?
2. Какие критерии приёмки делают единицу «готовой»?
3. Где хранить backlog (state-артефакт из `plugin-config.md`)?
4. Как часто будут меняться требования? (влияет на выбор уровня)

## Протокол инстанцирования

1. Вызвать `sdlc-method-engineering` с `phase: requirements`.
2. Получить уровень и инструмент; зафиксировать в `profile.md`.
3. Через `context7` получить референс выбранного инструмента.
4. Инстанцировать артефакт в `<target>/.claude/sdlc/phases/requirements/`.
5. Обеспечить trace-ссылки на артефакты vision (`traces_from`).
6. Обновить `alphas.md` через `sdlc-alpha-tracker`.
7. Записать в `decisions.md`.

## Критерии готовности

- Артефакт фазы валиден (`validate-artifact.sh`).
- `traces_from` ссылается на артефакт vision.
- Альфа Requirements достигла минимум Bounded.
- State-артефакт (backlog) обновлён и читается `sdlc-state-reader`.
- `check-cross-refs.sh` проходит.

## Следующие шаги по ролям

- product-owner → пересмотр приоритетов, запуск `/sdlc-continue`.
- architect → `/sdlc-phase architecture`.
- developer → `/sdlc-phase architecture` (для понимания структурного контекста).
