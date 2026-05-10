# v0.9.0 — Wave 7 PR-3: Gap-6 work-unit meta-templates per tracker

Дата: 2026-05-10.

## TL;DR

Закрывает #58 (Gap-6, P1) из Wave 6 backlog. 3 tracker-flavored meta-templates для work-unit'ов: Jira, Linear, GitHub Issues. Skill `sdlc-requirements` выбирает шаблон через поле `work_unit_template` в `plugin-config.md`.

## Что добавлено

### Meta-templates (3)

- `meta-templates/work-unit.jira.meta.md` — Jira issue types (Epic/Story/Task/Sub-task) + story_points, sprint, components, epic-link.
- `meta-templates/work-unit.linear.meta.md` — Linear issue_id, project_id, cycle_id, priority (0-4), estimate Fibonacci.
- `meta-templates/work-unit.github.meta.md` — GitHub issue_number, milestone, labels, task-list AC. Pet-friendly default.

Все 3 extends `work-product.meta.md` (базовая схема).

### plugin-config schema

Поле `work_unit_template: jira | linear | github` в `meta-templates/plugin-config.meta.md`. Default `github` (pet-friendly).

### Tests

`tests/unit/work-unit-templates.bats` — 7 кейсов: existence (3) / frontmatter (1) / extends (1) / config field (1) / alphas (1).

## Тесты

- Unit total: 104 → 111 кейсов.
- Все 111 unit + 47 integration GREEN.

## Использование

```yaml
# В <target>/.claude/sdlc/plugin-config.md
work_unit_template: jira

# Skill sdlc-requirements при инстанцировании work-unit использует:
# meta-templates/work-unit.jira.meta.md
```

## ⚠️ ACTION REQUIRED

После merge — `/plugin update ai-driven-sdlc` или перезагрузка Claude Code.

## Wave 7 прогресс

| Issue | Severity | Статус |
|---|---|---|
| #55 Gap-0 (realpath) | P1 | ✅ v0.7.0 |
| #56 Gap-2 (heredoc) | P1 | ✅ v0.7.0 |
| #57 Gap-4 (role-extensions) | P1 | ✅ v0.8.0 |
| #58 Gap-6 (work-unit templates) | P1 | ✅ v0.9.0 |
| #54 Gap-3 (external-systems) | P0 | pending → v0.10.0 |

После v0.9.0 — все 4 P1 issues из Wave 7 закрыты. Остаётся 1 P0 (#54).
