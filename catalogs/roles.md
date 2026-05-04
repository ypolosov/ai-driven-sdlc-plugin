---
name: roles
type: catalog
scope: абстрактные роли проекта, их методы, интересы, привязка к фазам и альфам
source: Левенчук Том 1 гл. 5 (роли), гл. 6 (интересы); ADR-security-engineer
warning: только абстрактные роли; конкретные специализации — в target/.claude/sdlc/role-extensions.md
---

# Каталог абстрактных ролей

Роль — функциональная позиция актора в проекте.
Один актор может играть несколько ролей; роль может играть несколько акторов.
Актор — человек, AI-агент или гибрид (`agent_kind`).
Конкретные ролевые специализации проекта живут в `<target>/.claude/sdlc/role-extensions.md`.
Они расширяют абстрактные роли через поле `extends:` мета-шаблона `target-roles.meta.md`.

## Схема записи

```yaml
role: <slug>
title: <название>
phases: [фазы, где роль активна]
alphas: [альфы, за продвижение которых отвечает]
interests: [интересы роли; Том 1 гл. 6]
methods: [дисциплины/методы, которые несёт]
tool_categories: [<id из catalogs/tool-categories.md>]
agent_kind: human | ai | both
```

## Поля схемы (после Wave 4)

- `tool_categories` — категории инструментов SDLC, которые роль использует.
- `agent_kind` — тип актора, играющего роль: `human`, `ai`, `both`.
- Расшифровка категорий — `catalogs/tool-categories.md`.

## Абстрактные роли (9)

### product-owner
title: Владелец продукта
phases: [vision, requirements, operations]
alphas: [Opportunity, Stakeholders, Requirements]
interests: [ценность для пользователя, приоритеты фичей, метрики успеха]
methods: [product-discovery, stakeholder-analysis]
tool_categories: [issue-tracker, knowledge-base, chat]
agent_kind: both

### architect
title: Архитектор
phases: [architecture, development, testing]
alphas: [Software System, Requirements]
interests: [значимые решения, качественные атрибуты, долговечность]
methods: [software-architecture, functional-decomposition]
tool_categories: [knowledge-base, vcs, issue-tracker]
agent_kind: both

### developer
title: Разработчик
phases: [development, testing]
alphas: [Software System, Work]
interests: [сопровождаемость кода, скорость фидбэка, автоматизация]
methods: [software-construction, tdd]
tool_categories: [vcs, issue-tracker, chat]
agent_kind: both

### tester
title: Тестировщик
phases: [testing, development]
alphas: [Software System, Requirements]
interests: [покрытие поведения, устойчивость, регрессии]
methods: [software-testing, tdd]
tool_categories: [test-management, issue-tracker, vcs]
agent_kind: both

### devops
title: DevOps-инженер
phases: [deployment, operations]
alphas: [Software System]
interests: [скорость доставки, обратимость, предсказуемость сред]
methods: [continuous-delivery]
tool_categories: [cd-platform, vcs, observability]
agent_kind: both

### sre
title: Site Reliability Engineer
phases: [operations]
alphas: [Software System, Opportunity]
interests: [надёжность, SLO, бюджеты ошибок, инциденты]
methods: [site-reliability-engineering]
tool_categories: [observability, issue-tracker, chat]
agent_kind: both

### security-engineer
title: Инженер безопасности
phases: [architecture, development, deployment, operations]
alphas: [Software System, Requirements]
interests: [угрозы, уязвимости, compliance, цепочка поставки]
methods: [threat-modeling, vulnerability-management]
tool_categories: [vcs, observability, issue-tracker]
agent_kind: both

### method-engineer
title: Инженер методов
phases: [сквозная]
alphas: [Way of Working]
interests: [соответствие метода ситуации проекта, эволюция практик]
methods: [situational-method-engineering]
tool_categories: [knowledge-base, issue-tracker]
agent_kind: both

### systems-thinker
title: Системный мыслитель
phases: [сквозная]
alphas: [Software System, Opportunity]
interests: [границы системы, надсистема, подсистемы, окружение]
methods: [systems-thinking]
tool_categories: [knowledge-base]
agent_kind: both

## Правила использования

Пользователь выбирает текущую роль через `/sdlc-continue`.
`sdlc-state-reader` читает роль из `target/.claude/sdlc/roles.md`.
Роль сужает предлагаемые фазы и задачи.
Интересы роли учитываются в опросе `sdlc-method-engineering`.
Конкретные роли целевого добавляются через `role-extensions.md` (см. `target-roles.meta.md`).

## Схема `role → [phases] → [alphas обязательные]`

| Роль | Фазы | Обязательные альфы |
|---|---|---|
| product-owner | vision, requirements | Opportunity, Requirements |
| architect | architecture | Software System |
| developer | development | Software System |
| tester | testing | Software System, Requirements |
| devops | deployment | Software System |
| sre | operations | Software System |
| security-engineer | architecture, deployment | Software System |
| method-engineer | сквозная | Way of Working |
| systems-thinker | сквозная | Software System |
