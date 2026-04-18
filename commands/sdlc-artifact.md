---
name: sdlc-artifact
description: ВНУТРЕННЯЯ КОМАНДА. Инстанцирует конкретный шаблон в целевом проекте по выбору метода и инструмента. Пользователь напрямую не вызывает — вызывается skills фаз через /sdlc-phase.
argument-hint: "<type> --phase <name> --method <slug> --tool <slug> [--level <level>]"
internal: true
---

# `/sdlc-artifact` — internal

> **Warning.** Эта команда является внутренней. Пользователю не следует вызывать её напрямую.
> Все инстанцирования проходят через skills фаз (`/sdlc-phase <name>`), которые корректно заполняют аргументы.

## Назначение

Низкоуровневое создание конкретного артефакта в `<target>/.claude/sdlc/phases/<phase>/`.
Используется skills фаз после опроса `sdlc-method-engineering`.

## Поведение

1. Разобрать аргументы: тип артефакта, фаза, метод, инструмент, уровень SME.
2. Прочитать `meta-templates/phase-artifact.meta.md` (схема-оболочка).
3. Через MCP `context7` получить референсную структуру выбранного инструмента.
4. Объединить: обязательные поля frontmatter + обязательные секции из мета-шаблона + содержимое из референса.
5. Записать итоговый `.md` в `<target>/.claude/sdlc/phases/<phase>/<slug>.md`.
6. Обеспечить trace-ссылки на артефакты предыдущей фазы.
7. Обновить `alphas.md` через `sdlc-alpha-tracker`.
8. После записи сработают PostToolUse hooks: validator → check-cross-refs → auditor async.

## Аргументы (все обязательные)

- `<type>` — slug артефакта (например, `vision-one-pager`).
- `--phase <name>` — фаза SDLC.
- `--method <slug>` — выбранный метод из `method-tool-matrix.md`.
- `--tool <slug>` — выбранный инструмент.
- `--level <level>` — уровень SME (pet/mid/enterprise).

## Связи

- Вызывается skills фаз: `sdlc-vision`, `sdlc-requirements`, …, `sdlc-operations`.
- Использует `meta-templates/phase-artifact.meta.md`.
- Использует MCP `context7`.
- Триггерит `sdlc-alpha-tracker` для обновления состояния альф.

## Запрет на прямой вызов

- В `/help` команда помечена как `internal`.
- При прямом вызове без необходимых аргументов — подсказка перенаправить на `/sdlc-phase`.
