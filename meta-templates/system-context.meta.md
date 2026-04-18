---
name: system-context.meta
type: meta-template
scope: схема system-context.md — фокус внимания на системах
location_in_target: .claude/sdlc/system-context.md
source: Левенчук Том 2 гл. 7 (системные уровни), гл. 9 (целевая и надсистема)
---

# Мета-шаблон `system-context.md`

Реестр систем, на которые пользователь переносил внимание.
Поддерживает принципы 7 (граница по вниманию) и 17 (README систем внимания).

## Обязательный frontmatter

```yaml
---
name: system-context
type: attention-context
project: <slug>
current_focus: <slug текущей системы внимания>
updated: <YYYY-MM-DD>
---
```

## Обязательная таблица систем внимания

| slug | role_vs_target | kind | last_focused_at | focus_count |
|---|---|---|---|---|
| <slug> | supersystem \| target \| subsystem \| in_environment \| creation_system | materialized \| logical | <YYYY-MM-DD> | <число> |

### Значения `role_vs_target` (Левенчук Том 2 гл. 9)

- **supersystem** — объемлющая система, частью которой является целевая.
- **target** — текущая целевая система.
- **subsystem** — часть целевой системы.
- **in_environment** — взаимодействует с целевой, но не содержит её.
- **creation_system** — систем создания (человек, команда, плагин).

### Значения `kind` (принцип 17)

- **materialized** — представлена директорией в репозитории.
- **logical** — абстракция или внешний продукт вне репозитория.

## Обязательный раздел «Журнал фокусировок»

Хронология переносов внимания: дата, slug, действие (focus/transient/retire).

## Правила

- Переход целевой системы смещает значение `current_focus`.
- Прежняя целевая получает другую роль (обычно `supersystem` или `in_environment`).
- При `kind=materialized` создаётся `<system-root>/README.sdlc.md` (Волна 2).
- При `kind=logical` создаётся `.claude/sdlc/external-systems/<slug>.md` (Волна 2).
- `/sdlc-focus --transient` регистрирует фокус без создания описания.
- `/sdlc-focus --retire` переносит slug в список архивных систем.
