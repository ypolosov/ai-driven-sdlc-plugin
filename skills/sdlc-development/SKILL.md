---
name: sdlc-development
description: Фаза Development с TDD-first подходом. Тесты пишутся до кода. Форматер и линтер настраиваются обязательно. Выбор уровня SME и инструментов делегируется sdlc-method-engineering. Запускается командой /sdlc-phase development.
phase: development
scope: phase
disciplines: [software-construction, tdd]
alphas: [Software System, Work]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Линейная история изменений в одной основной ветке"}
  mid: {method_abstract: "Короткоживущие ветки с обязательным независимым ревью и автоматическими проверками"}
  enterprise: {method_abstract: "Формализованные ветки релизов с управлением правами, безопасностью и цепочкой поставки"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Development (TDD-first)

## Назначение фазы

Реализация кода с TDD по умолчанию (принцип 5).
Обязательная настройка форматера и линтера (принцип 6).
Запрет комментариев в коде (принцип 4a).

## Альфы, которые продвигает

- **Software System** — от Architecture Selected до Demonstrable, далее Usable.
- **Work** — от Initiated до Under Control.

## Дисциплины

- Software construction.
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

### Вопросы фазы Development

Сначала SME-опрос делегируется `sdlc-method-engineering` с `phase: development`.
Дополнительно фаза Development требует настроек для hooks:
1. Какой стек/язык используется? (для TDD-пар в `plugin-config.md`)
2. Какой форматер выбираете? (варианты из матрицы; выбор обязателен)
3. Какой линтер выбираете? (варианты из матрицы; выбор обязателен)
4. Какие пути входят в TDD-scope? (по умолчанию `src/**`, `lib/**`)
5. Какую git-модель используете? Уровни описаны в `catalogs/method-tool-matrix.md#4-development`.

## Протокол инстанцирования

1. **Обязательно:** вызвать `AskUserQuestion` с блоком выше и дождаться ответов.
2. Вызвать `sdlc-method-engineering` с `phase: development`.
3. Получить уровни SME для git-workflow, форматера, линтера.
4. Записать в `plugin-config.md`:
   - `tdd_pairs` по языку.
   - `tdd_scope.include`.
   - `formatter.command` и `linter.command`.
5. Записать в `profile.md` строку фазы development.
6. Инстанцировать артефакт развёрнутых правил разработки в `phases/development/`.
7. Активировать hooks: `enforce-tdd.sh`, `enforce-format-lint.sh`, `enforce-no-comments.sh`.
8. Зафиксировать в `decisions.md`.

## Критерии готовности

- `plugin-config.md` содержит валидные `tdd_pairs`, `formatter`, `linter`.
- Смок-тест hooks: правка кода без теста → TDD-hook требует подтверждения.
- Смок-тест форматера: неотформатированный код → hook блокирует запись.
- Смок-тест no-comments: код с `//` или `#` → hook блокирует запись.
- Альфа Software System достигла минимум Demonstrable.

## Следующие шаги по ролям

- developer → писать код по TDD: сначала `/sdlc-phase testing`, затем правка `src/**`.
- tester → пересмотр покрытия тестами.
- devops → `/sdlc-phase deployment`.
