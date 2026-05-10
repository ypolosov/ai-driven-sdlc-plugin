---
name: iteration.meta
type: meta-template
scope: схема итерации (kanban-style) для группировки work-units
extends: work-product.meta.md
location_in_target: .claude/sdlc/phases/requirements/iterations/<iteration-id>.md
source: Wave 8 #61 Gap-8 (gt-validation)
---

# Мета-шаблон итерации (kanban-style)

Используется для kanban-style декомпозиции work'ов по sprint'ам или milestone'ам.
Связывает несколько work-unit-артефактов в одну итерацию с временным окном.

## Обязательный frontmatter

```yaml
---
name: <iteration-slug>
type: iteration
phase: requirements
project: <target-project>
iteration_id: <ITER-N или sprint-name>
sprint_or_milestone: <sprint-name | milestone-name | null>
status: <planned|in-progress|completed>
work_units: [<ссылки на work-unit-артефакты>]
start_date: <YYYY-MM-DD>
end_date: <YYYY-MM-DD>
sme_level: <pet|mid|enterprise>
alphas: [Work, Requirements]
role: <product-owner|method-engineer>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

## Status enum (kanban-states)

- `planned` — итерация определена, но не начата.
- `in-progress` — активная итерация; work-units в работе.
- `completed` — все work-units закрыты; итерация завершена.

## Обязательные секции

### 1. Назначение

Одно утверждение, какую цель преследует итерация (бизнес-смысл).

### 2. Включённые work-units

Markdown-таблица или bullet-list ссылок на work-unit-артефакты.
Каждая ссылка указывает имя и текущий статус.

### 3. Acceptance Criteria итерации

Что считается «итерация завершена» — суммарные критерии готовности.

### 4. Связи с другими артефактами

- `traces_from`: vision/requirements какие drove'ят итерацию.
- `traces_to`: testing/deployment где проверяется завершённость.

### 5. Критерии готовности

Fitness-функции итерации:
- Все work-units в статусе `completed` или `cancelled`.
- AC выполнены и подтверждены тестами.
- Demo проведено если применимо.

## Поля специфичные для kanban

- `wip_limit` (опционально) — максимум work-units в `in-progress` одновременно.
- `cycle_time_avg` (опционально) — среднее время прохождения work-unit через итерацию.
- `velocity` (опционально) — story-points или count work-units завершённых.

## Привязка к альфам

Итерация продвигает:
- `Work` (Initiated → Under Control → Concluded для каждого work-unit).
- `Requirements` (постепенно от Conceived через Bounded к Acceptable).

## Правила

- Создание через skill `sdlc-requirements` (опционально по pet/mid/enterprise scope).
- AskUserQuestion перед write (принцип 1).
- `work_units` ссылается только на существующие work-unit-артефакты в `<target>/.claude/sdlc/phases/requirements/`.
- Pet-проекты могут пропустить итерации; mid+ обычно используют.

## Валидация

`validate-artifact.sh` + проверка enum `status` и формата `start_date`/`end_date`.

## Pet vs Mid vs Enterprise

| Уровень | Использование |
|---|---|
| pet | Опционально; обычно один global iteration на проект. |
| mid | Sprint-based (2-week iterations) или milestone-based. |
| enterprise | PI (Program Increment) или quarter-based; multiple parallel iterations. |
