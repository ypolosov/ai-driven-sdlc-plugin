---
name: roles-state.meta
type: meta-template
scope: схема roles.md — журнал играемых ролей
location_in_target: .claude/sdlc/roles.md
source: Левенчук Том 1 гл. 5 (роли), гл. 6 (интересы)
---

# Мета-шаблон `roles.md`

Журнал ролей, которые играет пользователь в целевом проекте.
Ссылается на определения ролей в `catalogs/roles.md` плагина.

## Обязательный frontmatter

```yaml
---
name: roles
type: role-journal
project: <slug>
active_roles: [список slug активных ролей]
updated: <YYYY-MM-DD>
---
```

## Обязательная таблица ролей

| slug | title | активна | last_played_at | phases | interests | alphas |
|---|---|---|---|---|---|---|
| <из catalogs/roles.md> | <название> | да|нет | <YYYY-MM-DD> | [фазы] | [интересы] | [альфы] |

## Обязательный раздел «Текущая роль»

Какую роль пользователь играет сейчас (или неизвестно).
Фиксируется при запуске `/sdlc-continue`.

## Обязательный раздел «Журнал смены ролей»

Хронология: дата, роль, действие (start/stop/switch).

## Правила

- Активная роль сужает предложения `/sdlc-continue` и `sdlc-method-engineering`.
- Одновременно активных ролей может быть несколько.
- Интересы роли влияют на вопросы SME-опроса (Левенчук Том 1 гл. 6).
- Расширение каталога ролей — только через правку `catalogs/roles.md` плагина.
