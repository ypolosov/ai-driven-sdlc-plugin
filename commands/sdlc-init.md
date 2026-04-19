---
name: sdlc-init
description: Инициализация SDLC-каркаса в текущем целевом проекте. Создаёт .claude/sdlc/, собирает профиль SME, настраивает plugin-config.md. Режимы --fail-if-exists (по умолчанию) / --merge / --force.
argument-hint: "[--fail-if-exists | --merge | --force]"
---

# `/sdlc-init`

Активирует skill `sdlc-bootstrap` для текущего целевого проекта.

## Поведение

1. Проверить текущий рабочий каталог — это целевой проект.
2. Проверить наличие `<target>/.claude/sdlc/`:
   - нет → создать каркас.
   - есть, режим `--fail-if-exists` (по умолчанию) → отказать с подсказкой.
   - есть, режим `--merge` → добавить недостающие файлы, не перезаписывать.
   - есть, режим `--force` → запросить явное подтверждение пользователя.
3. Запустить skill `sdlc-bootstrap`: **обязательный** опрос через `AskUserQuestion`, создание файлов, первая запись в `decisions.md`.
4. Активировать hooks через `hooks/hooks.json`.

## Интерактивность

Плагин ведёт пользователя по инициализации; решения принимает пользователь.
Auto mode среды не отменяет интерактивность (принцип 1).
Пропуск опроса возможен только через `/sdlc-autonomy --task hootl`.

## Аргументы

- `--fail-if-exists` — безопасный режим по умолчанию.
- `--merge` — неразрушающий merge.
- `--force` — перезапись с подтверждением (использовать только с `/sdlc-autonomy hitl`).

## Создаваемые файлы (минимум)

- `<target>/.claude/CLAUDE.md`
- `<target>/.claude/sdlc/profile.md`
- `<target>/.claude/sdlc/plugin-config.md`
- `<target>/.claude/sdlc/alphas.md`
- `<target>/.claude/sdlc/system-context.md`
- `<target>/.claude/sdlc/roles.md`
- `<target>/.claude/sdlc/decisions.md`
- `<target>/.env.example` (если нет)
- обновлённый `<target>/.gitignore` (с `.env`)

## После выполнения

Плагин предлагает следующий шаг через `/sdlc-continue`.
