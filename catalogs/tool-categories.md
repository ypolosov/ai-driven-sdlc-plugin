---
name: tool-categories
type: catalog
scope: 7 агностических категорий инструментов SDLC; имена реальных продуктов отсутствуют
source: ADR-013; принципы 3, 18 плагина
warning: имена инструментов живут только в `method-tool-matrix.md` и в целевом проекте
---

# Каталог категорий инструментов SDLC

Категория — функциональный класс инструментов целевого проекта.
Плагин знает только категории; конкретные продукты выбираются пользователем.
Связь «категория → MCP-сервер» живёт в `<target>/.claude/sdlc/tool-bindings.md`.

## Схема записи категории

```yaml
id: <kebab-slug>
purpose: <назначение в одну строку>
capabilities: [<capability-id>, ...]
binds_to_alphas: [<alpha-id>, ...]
state_artifact_compatible: true | false
```

## 7 категорий

### issue-tracker
purpose: учёт работы и связь с альфой Work через дискретные единицы.
capabilities: [issue.create, issue.update, issue.search, comment.add, label.set, status.set]
binds_to_alphas: [Work, Requirements]
state_artifact_compatible: true

### knowledge-base
purpose: длинные документы, спецификации, runbooks и страницы политик.
capabilities: [page.create, page.update, page.search, page.read, attachment.upload]
binds_to_alphas: [Requirements, Way of Working]
state_artifact_compatible: false

### vcs
purpose: код, ветки, ревью изменений и теги релизов.
capabilities: [pr.create, pr.review, pr.merge, branch.create, commit.read, tag.create, file.read]
binds_to_alphas: [Software System]
state_artifact_compatible: false

### chat
purpose: оперативная коммуникация и нотификации между агентами.
capabilities: [message.post, channel.list, thread.read, mention.parse]
binds_to_alphas: [Team]
state_artifact_compatible: false

### observability
purpose: метрики, логи, алерты и распределённые трейсы.
capabilities: [metric.query, log.search, alert.list, trace.read, dashboard.read]
binds_to_alphas: [Software System, Opportunity]
state_artifact_compatible: false

### cd-platform
purpose: декларативная доставка и прогрессивный выкат изменений в среды.
capabilities: [app.list, app.sync, app.rollback, env.list, deploy.history]
binds_to_alphas: [Software System]
state_artifact_compatible: false

### test-management
purpose: ведение тест-кейсов, прогонов и связи с требованиями.
capabilities: [run.create, run.report, case.link, case.create, coverage.read]
binds_to_alphas: [Requirements, Software System]
state_artifact_compatible: false

## Правила использования

Каждая категория идентифицируется по `id` без упоминания продукта.
В целевом проекте `tool-bindings.md` ссылается на `id` категории.
MCP-сервер целевого должен покрыть `capabilities` категории по контракту.
Расширение каталога допускается через `target/.claude/sdlc/tool-categories-extensions.md`.
Hooks и агенты плагина опираются только на эту таблицу `id`.

## Связь с альфами SEMAT

| Категория | Влияет на альфы |
|---|---|
| issue-tracker | Work, Requirements |
| knowledge-base | Requirements, Way of Working |
| vcs | Software System |
| chat | Team |
| observability | Software System, Opportunity |
| cd-platform | Software System |
| test-management | Requirements, Software System |

## Валидация

`scripts/check-tool-binding.sh` отказывает при ссылке на `id` вне каталога.
Имена реальных продуктов в этом файле запрещены проверкой `grep`.
