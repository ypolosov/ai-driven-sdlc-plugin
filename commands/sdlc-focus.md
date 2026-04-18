---
name: sdlc-focus
description: Сменить целевую систему внимания. Определяет относительно неё надсистему, подсистемы, окружение, систему создания. Обновляет system-context.md. Поддерживает --transient и --retire.
argument-hint: "<slug-системы> [--transient | --retire]"
---

# `/sdlc-focus`

Активирует skill `sdlc-focus` для переноса внимания на указанную систему.

## Поведение

1. Разобрать аргумент (slug системы) и флаги.
2. Прочитать `system-context.md`.
3. В зависимости от флага:
   - без флагов: сделать систему текущей целевой; пересчитать роли соседей.
   - `--transient`: запись в журнал фокусировок, но без создания описания.
   - `--retire <slug>`: перенести систему в `retired-systems/` (Волна 2).
4. Обновить `system-context.md` (`current_focus`, `last_focused_at`, `focus_count`, таблица систем).
5. Создать/актуализировать описание системы по мета-шаблону `system-readme.meta.md`:
   - `kind=materialized` → `<system-root>/README.sdlc.md` (sidecar, не трогает существующий `README.md`).
   - `kind=logical` → `<target>/.claude/sdlc/external-systems/<slug>.md`.
6. Зафиксировать решение в `decisions.md` (принцип 1).
7. После записи сработает `check-system-readmes.sh` PostToolUse.

## Аргументы

- `<slug-системы>` — уникальный идентификатор системы (без пробелов).
- `--transient` — разовый перенос внимания без создания описания.
- `--retire <slug>` — архивировать систему из рассмотрения.

## Пример

```
/sdlc-focus web-frontend
```

Плагин спросит:
- Это `materialized` (директория в репо) или `logical` (абстракция)?
- Если materialized — путь внутри репо.
- Какая роль относительно прежней целевой? (subsystem / in_environment / …)

## Связи

- Использует `meta-templates/system-context.meta.md` для обновлений.
- В Волне 2 — использует `scripts/check-system-readmes.sh`.
- Результат влияет на `/sdlc-audit` и все skills фаз.
