---
name: work-unit.linear.meta
type: meta-template
scope: схема work-unit для Linear-managed целевых
extends: work-product.meta.md
location_in_target: .claude/sdlc/phases/requirements/<work-unit-slug>.md
source: ADR-013, ADR-016; Wave 7 Gap-6
tracker_category: issue-tracker
tracker_tool: linear
---

# Мета-шаблон work-unit (Linear-flavored)

Используется когда `tool-bindings.md` указывает Linear как issue-tracker.

## Обязательный frontmatter

```yaml
---
name: <issue-slug>
type: work-unit
phase: requirements
project: <target-project>
tracker: linear
issue_id: <ENG-123> или null если не создан
team_key: <ENG>
project_id: <linear-project-uuid> или null
cycle_id: <linear-cycle-uuid> или null
sme_level: <pet|mid|enterprise>
alphas: [Work, Requirements]
role: <product-manager|architect|developer>
priority: 0 | 1 | 2 | 3 | 4
estimate: 1 | 2 | 3 | 5 | 8
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

## Обязательные секции

### 1. Title + Description

Linear style: title ≤80 символов, description в markdown.

### 2. Acceptance Criteria

Bullet-list. Минимум 3.

### 3. Estimate (T-shirt или Fibonacci)

`estimate` поле в frontmatter (Fibonacci 1/2/3/5/8).

### 4. Priority

`priority`: 0=No priority, 1=Urgent, 2=High, 3=Medium, 4=Low.

### 5. Project / Cycle

Привязка к Linear project и текущему cycle.

### 6. Связанные альфы

`Work`, `Requirements`.

## Поля специфичные для Linear

- `parent_issue` — для sub-issues.
- `relations` — blocks / blocked-by / related-to (Linear native).
- `labels` — Linear labels.

## Правила

- Создание Linear issue через `sdlc-tool-router` (Linear MCP).
- AskUserQuestion перед write (принцип 1).
- `issue_id` записывается после успешного создания.

## Валидация

`validate-artifact.sh` + проверка `tracker: linear`.
