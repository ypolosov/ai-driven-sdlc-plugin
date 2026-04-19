---
name: sdlc-architecture
description: Фаза Architecture — значимые структурные решения и функциональная декомпозиция. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Запускается командой /sdlc-phase architecture.
phase: architecture
scope: phase
disciplines: [software-architecture, functional-decomposition]
alphas: [Software System, Requirements]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Одностраничное описание структуры системы с одной диаграммой"}
  mid: {method_abstract: "Фиксация значимых архитектурных решений и многоуровневое визуальное моделирование"}
  enterprise: {method_abstract: "Формальная оценка качественных атрибутов и моделирование системной архитектуры"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Architecture

## Назначение фазы

Зафиксировать значимые структурные решения целевой системы.
Провести функциональную декомпозицию (Том 2 гл. 10).
Согласовать архитектуру с системами внимания и требованиями.

## Альфы, которые продвигает

- **Software System** — от Recognized до Architecture Selected.
- **Requirements** — от Coherent до Acceptable (уточнение NFR).

## Дисциплины

- Software architecture.
- Functional decomposition (Том 2 гл. 10: функциональный анализ vs модульный синтез).

## Обязательный интерактивный опрос (принцип 1)

**Skill ведёт пользователя по фазе; не заменяет его решения автогенерацией.**

Шаг 0 — ДО записи любых артефактов:
1. Вызвать `AskUserQuestion` с вопросами ниже.
2. Показать 2–3 альтернативы по каждому выбору.
3. Дождаться ответа пользователя; не угадывать.
4. Auto mode среды не отменяет интерактивность.
5. Только `/sdlc-autonomy --task hootl` разрешает пропуск опроса.
6. Если `AskUserQuestion` недоступна — остановиться и сообщить пользователю.

### Вопросы фазы Architecture

Сначала SME-опрос делегируется `sdlc-method-engineering` с `phase: architecture`.
Дополнительно:
1. Какие качественные атрибуты критичны? (производительность, безопасность, устойчивость)
2. Где границы целевой системы? (сверить с `system-context.md`)
3. Какие значимые решения требуют документации?
4. Есть ли подсистемы, заслуживающие отдельного фокуса `/sdlc-focus`?

## Протокол инстанцирования

1. **Обязательно:** вызвать `AskUserQuestion` с блоком выше и дождаться ответов.
2. Вызвать `sdlc-method-engineering` с `phase: architecture`.
3. Получить уровень и инструмент; зафиксировать в `profile.md`.
4. Через `context7` получить референс выбранного инструмента.
5. Инстанцировать артефакт в `<target>/.claude/sdlc/phases/architecture/`.
6. Связать с `system-context.md`: границы, надсистема, подсистемы.
7. Обеспечить trace-ссылки на артефакты requirements (`traces_from`).
8. Обновить `alphas.md` через `sdlc-alpha-tracker`.

## Критерии готовности

- Артефакт фазы валиден.
- `traces_from` ссылается на артефакты requirements.
- Альфа Software System достигла минимум Architecture Selected.
- Сущности из `system-context.md` согласованы с артефактом.
- `check-cross-refs.sh` проходит.

## Следующие шаги по ролям

- architect → `/sdlc-phase testing` (сначала тесты) или `/sdlc-phase development`.
- developer → `/sdlc-phase testing` перед `/sdlc-phase development` (TDD-first).
- systems-thinker → `/sdlc-focus` на подсистемы.
