---
name: profile.meta
type: meta-template
scope: схема profile.md — методологический слой (SME-решения)
location_in_target: .claude/sdlc/profile.md
---

# Мета-шаблон `profile.md`

SME-решения пользователя по целевому проекту.
Методологический слой; не конфиг hooks (это `plugin-config.md`).

## Обязательный frontmatter

```yaml
---
name: profile
type: sdlc-profile
project: <slug целевого проекта>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

## Обязательная таблица SME

Каждая фаза SDLC — строка таблицы. Открытая схема: фазы могут добавляться.

| Фаза | Уровень SME | Выбранный метод | Выбранный инструмент | default_autonomy |
|---|---|---|---|---|
| vision | pet|mid|enterprise | <из матрицы> | <из матрицы> | hitl|hotl|hootl |
| requirements | … | … | … | … |
| architecture | … | … | … | … |
| development | … | … | … | … |
| testing | … | … | … | … |
| deployment | … | … | … | … |
| operations | … | … | … | … |

## Обязательный раздел «Активная роль»

Одна-две активные роли пользователя на текущий момент.
Ссылка на запись в `roles.md`.

## Обязательный раздел «История изменений SME»

Записи о смене уровня или инструмента по фазе.
Формат: дата, фаза, было/стало, мотив.

## Правила

- Per-task override автономности в profile.md не пишется (ephemeral).
- Изменение уровня SME по фазе фиксируется в истории.
- Артефакты фаз сверяются аудитором с этим профилем.

## Что хранится отдельно

- TDD-пары, форматер, линтер, scope, state-артефакт — в `plugin-config.md`.
- Состояние альф — в `alphas.md` (через `sdlc-alpha-tracker`).
- Системы внимания — в `system-context.md`.
