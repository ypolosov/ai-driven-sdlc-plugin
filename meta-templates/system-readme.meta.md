---
name: system-readme.meta
type: meta-template
scope: описание системы внимания (принцип 17)
locations:
  - <system-root>/README.sdlc.md для kind=materialized
  - <target>/.claude/sdlc/external-systems/<slug>.md для kind=logical
source: Левенчук Том 2 гл. 7, 9 (системные уровни, целевая и надсистема)
---

# Мета-шаблон описания системы внимания

Один артефакт на каждую систему, на которую пользователь переносил внимание.
Sidecar для `materialized`, отдельный файл в `external-systems/` для `logical`.

## Обязательный frontmatter

```yaml
---
name: <slug системы>
type: system-readme
kind: materialized | logical
role_vs_target: supersystem | target | subsystem | in_environment | creation_system
project: <slug целевого проекта>
last_focused_at: <YYYY-MM-DD>
focus_count: <число>
updated: <YYYY-MM-DD>
---
```

## Обязательные секции

### 1. Назначение и границы
Одно утверждение о том, что есть эта система и где её граница.
Ссылка на запись в `system-context.md`.

### 2. Текущий фокус
- Роль относительно текущей целевой (`role_vs_target`).
- Когда последний раз была в фокусе (`last_focused_at`).
- Сколько раз пользователь возвращался к ней (`focus_count`).

### 3. Состояние альф относительно системы
Таблица: альфа, состояние, артефакт-свидетельство.
Данные получаются через `sdlc-alpha-tracker` (принцип 13).

### 4. Связанные артефакты SDLC
Ссылки на артефакты по фазам, относящиеся к этой системе.

### 5. Роли, активные в системе
Список ролей с их интересами (Левенчук Том 1 гл. 6).
Ссылки на `catalogs/roles.md`.

## Правила

- Язык — русский; ≤15 слов на утверждение.
- Для `materialized` файл живёт рядом с кодом системы; не трогать существующий корневой README.
- Для `logical` slug фигурирует в имени файла в `external-systems/`.
- `/sdlc-focus --transient` описание не создаёт.
- `/sdlc-focus --retire` перемещает описание в `retired-systems/`.
- Проверяется `check-system-readmes.sh`.
