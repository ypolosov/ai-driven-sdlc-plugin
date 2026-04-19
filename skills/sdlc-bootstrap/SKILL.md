---
name: sdlc-bootstrap
description: Инициализация SDLC-каркаса в целевом проекте. Создаёт .claude/sdlc/, собирает профиль SME по фазам, фиксирует активную роль, настраивает plugin-config.md. Запускается командой /sdlc-init.
scope: cross-cutting
disciplines: [situational-method-engineering]
alphas: [Way of Working, Team, Stakeholders]
default_autonomy: hitl
meta_templates: [profile.meta.md, plugin-config.meta.md, alpha-state.meta.md, system-context.meta.md, roles-state.meta.md, decisions.meta.md, credentials.meta.md]
---

# Skill: инициализация целевого проекта

## Назначение фазы

Закладывает каркас `.claude/sdlc/` в целевом проекте.
Собирает первичный SME-профиль и активную роль пользователя.
Настраивает `plugin-config.md` для работы hooks.

## Альфы, которые продвигает

- **Way of Working** — от Principles Established до Foundation Established.
- **Team** — от Seeded до Formed (если роли определены).
- **Stakeholders** — Recognized.

## Дисциплины

- Situational Method Engineering (`catalogs/disciplines.md`).

## Обязательный интерактивный опрос (принцип 1)

**Skill инициализирует проект; решения принимает пользователь, не плагин.**

Шаг 0 — ДО создания `.claude/sdlc/`:
1. Вызвать `AskUserQuestion` с вопросами ниже.
2. Показать 2–3 альтернативы по каждому выбору.
3. Дождаться ответа пользователя; не угадывать значения.
4. Auto mode среды не отменяет интерактивность.
5. Только `/sdlc-autonomy --task hootl` разрешает пропуск опроса.
6. Если `AskUserQuestion` недоступна — остановиться и сообщить пользователю.

### Вопросы bootstrap

1. Какой это проект: pet / mid / enterprise по масштабу команды и рисков?
2. Есть ли уже существующий `.claude/sdlc/` — запустить в режиме `--fail-if-exists`, `--merge` или `--force`?
3. Какую роль вы играете сейчас? (выбор из `catalogs/roles.md`)
4. Какую систему считаете целевой на старте? (обычно корневая система репозитория)
5. Где хранить состояние работ? (state-артефакт: файл / каталог / GitHub Issues через MCP)

Вопросы про конкретные инструменты не задаются здесь — только в skills фаз.

## Матрица SME

Опрос делегируется skill `sdlc-method-engineering`; здесь только уровни.
Варианты из `catalogs/method-tool-matrix.md` runtime.

## Протокол инстанцирования

0. **Обязательно:** вызвать `AskUserQuestion` с блоком выше и дождаться ответов пользователя.
1. Проверить наличие `<target>/.claude/sdlc/`; выбрать режим (принцип 14).
2. Создать `CLAUDE.md` целевого проекта с основными правилами плагина.
3. Создать `profile.md` по `profile.meta.md` с пустой таблицей фаз.
4. Создать `plugin-config.md` по `plugin-config.meta.md`.
5. Создать `alphas.md` по `alpha-state.meta.md` (все альфы в начальном состоянии).
6. Создать `system-context.md` по `system-context.meta.md` (текущая цель — корень).
7. Создать `roles.md` по `roles-state.meta.md` с выбранной ролью.
8. Создать `decisions.md` по `decisions.meta.md` (пустой журнал).
9. Создать `.env.example` и дополнить `.gitignore` строкой `.env` (по `credentials.meta.md`).
10. Зафиксировать первый choice в `decisions.md`: выбранные уровень проекта и state-артефакт.

Команда плагина: `/sdlc-init`. Реализация в `scripts/bootstrap-target.sh`.

## Критерии готовности

- `<target>/.claude/sdlc/` содержит все 7 обязательных файлов.
- `validate-artifact.sh` проходит на всех созданных артефактах.
- `check-cross-refs.sh` не находит осиротевших ссылок.
- В `decisions.md` есть первая запись о bootstrap-решениях.

## Следующие шаги по ролям

- product-owner → `/sdlc-phase vision`.
- architect → `/sdlc-phase architecture` (если vision и requirements уже есть).
- developer → `/sdlc-phase development` (если architecture уже есть).
- другие роли → `/sdlc-continue` для предложения фаз по состоянию альф.
