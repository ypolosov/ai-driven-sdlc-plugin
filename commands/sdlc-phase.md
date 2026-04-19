---
name: sdlc-phase
description: Запустить фазу SDLC. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Поддерживает --level для форсирования уровня и --reconfigure для переопределения выбора.
argument-hint: "<vision|requirements|architecture|development|testing|deployment|operations> [--level pet|mid|enterprise] [--reconfigure]"
---

# `/sdlc-phase`

Активирует skill соответствующей фазы SDLC.

## Поведение

1. Разобрать аргумент: имя фазы.
2. Если `--reconfigure` — удалить выбор в `profile.md` для этой фазы.
3. Активировать skill `sdlc-<phase>`.
4. Skill **обязательно** вызывает `AskUserQuestion` ДО записи артефактов (принцип 1).
5. Skill делегирует SME-опрос в `sdlc-method-engineering`.
6. По выбору пользователя инстанцировать конкретный шаблон в `<target>/.claude/sdlc/phases/<phase>/`.
7. Обновить `alphas.md` через `sdlc-alpha-tracker`.
8. Зафиксировать решение в `decisions.md`.

## Интерактивность

Плагин ведёт пользователя по фазе; не заменяет его решения автогенерацией.
Auto mode среды не отменяет интерактивность.
Пропуск опроса возможен только через `/sdlc-autonomy --task hootl`.

## Аргументы

- `<phase>` — имя фазы из списка.
- `--level <pet|mid|enterprise>` — форсировать уровень SME (обычно решает опрос).
- `--reconfigure` — сбросить предыдущий выбор и переопросить.

## Допустимые фазы

- `vision` — Vision (Opportunity, Stakeholders).
- `requirements` — Requirements (Requirements, Stakeholders).
- `architecture` — Architecture (Software System, Requirements).
- `development` — Development TDD-first (Software System, Work).
- `testing` — Testing (Software System, Requirements).
- `deployment` — Deployment (Software System).
- `operations` — Operations (Software System, Opportunity).

## Порядок по умолчанию

Рекомендация `sdlc-continue` по состоянию альф:
vision → requirements → architecture → testing → development → deployment → operations.
Testing перед development (TDD-first, принцип 5).

## Связи

- Использует одноимённый skill `sdlc-<phase>`.
- Использует `sdlc-method-engineering` и низкоуровневую `/sdlc-artifact`.
- После завершения — подсказывает следующую фазу по роли.
