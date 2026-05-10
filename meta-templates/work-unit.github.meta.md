---
name: work-unit.github.meta
type: meta-template
scope: схема work-unit для GitHub Issues-managed целевых
extends: work-product.meta.md
location_in_target: .claude/sdlc/phases/requirements/<work-unit-slug>.md
source: ADR-013, ADR-016; Wave 7 Gap-6
tracker_category: issue-tracker
tracker_tool: github
---

# Мета-шаблон work-unit (GitHub Issues-flavored)

Используется когда `tool-bindings.md` указывает GitHub Issues как issue-tracker.
Подходит pet-проектам и open-source.

## Обязательный frontmatter

```yaml
---
name: <issue-slug>
type: work-unit
phase: requirements
project: <target-project>
tracker: github
repo: <owner/repo>
issue_number: <int> или null если не создан
milestone: <milestone-name> или null
labels: [<label>, ...]
sme_level: <pet|mid|enterprise>
alphas: [Work, Requirements]
role: <product-owner|developer>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

## Обязательные секции

### 1. Title + Body

GitHub style: title ≤72 символа, body в markdown.

### 2. Acceptance Criteria

Bullet-list checkboxes (`- [ ]` task list).

### 3. Definition of Done

Список технических критериев (тесты, документация, ревью).

### 4. Labels (категоризация)

Стандартные: `bug`, `enhancement`, `documentation`, `wave-N`, `pN`.

### 5. Milestone

Привязка к milestone (release или sprint).

### 6. Связанные альфы

`Work`, `Requirements`.

## Поля специфичные для GitHub

- `assignees` — список handle'ов.
- `linked_pr` — номер PR при merge.
- `closes_issues` — issues, которые закрываются этим work-unit'ом.

## Правила

- Создание через `sdlc-tool-router` → `mcp__github__create_issue`.
- AskUserQuestion перед write (принцип 1).
- `issue_number` записывается после успешного создания.

## Валидация

`validate-artifact.sh` + проверка `tracker: github`.

## Pet-friendly особенность

GitHub Issues — самый low-friction для pet-проектов:
- Public repo → free issue tracking.
- GitHub MCP — Wave 4 baseline integration.
- Markdown-friendly.
