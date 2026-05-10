---
name: work-unit.jira.meta
type: meta-template
scope: схема work-unit для Jira-managed целевых
extends: work-product.meta.md
location_in_target: .claude/sdlc/phases/requirements/<work-unit-slug>.md
source: ADR-013 (категории), ADR-016 (tool-router); Wave 7 Gap-6
tracker_category: issue-tracker
tracker_tool: jira
---

# Мета-шаблон work-unit (Jira-flavored)

Используется когда `tool-bindings.md` указывает Jira как issue-tracker.
Соответствует Jira issue types: Epic / Story / Task / Sub-task.

## Обязательный frontmatter

```yaml
---
name: <issue-slug>
type: work-unit
phase: requirements
project: <target-project>
tracker: jira
issue_type: epic | story | task | sub-task
issue_key: <PROJ-1234> или null если не создан
parent_key: <PARENT-1234> для sub-task
sme_level: <pet|mid|enterprise>
alphas: [Work, Requirements]
role: <product-manager|architect|developer>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

## Обязательные секции

### 1. Заголовок и описание (Jira: Summary + Description)

Краткое summary ≤80 символов; полное описание ≤200 слов.

### 2. Acceptance Criteria

Bullet-list проверяемых утверждений. Минимум 3.

### 3. Story points (для story и task)

Plan-poker оценка: 1, 2, 3, 5, 8, 13, 21.

### 4. Sprint / Fix version

Привязка к sprint cycle или milestone.

### 5. Components / Labels

Jira components и labels для классификации.

### 6. Связанные альфы

`Work` (initiated → under-control), `Requirements`.

## Поля специфичные для Jira

- `epic-link` — ссылка на parent epic.
- `linked-issues` — blocks / is-blocked-by / relates-to.
- `assignee` — slug человека (если приватность позволяет).

## Правила

- Создание Jira issue делегируется `sdlc-tool-router` (write через MCP).
- Перед созданием — `AskUserQuestion` (принцип 1).
- `issue_key` записывается ПОСЛЕ создания через MCP.

## Валидация

`validate-artifact.sh` + специфичная проверка `tracker: jira` ↔ `tool-bindings.md`.
