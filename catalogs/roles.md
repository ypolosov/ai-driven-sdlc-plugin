---
name: roles
type: catalog
scope: роли проекта, их методы, интересы, привязка к фазам и альфам
source: Левенчук Том 1 гл. 5 (роли), гл. 6 (интересы)
---

# Каталог ролей

Роль — функциональная позиция актора в проекте.
Один человек может играть несколько ролей, одну роль — несколько людей.
Каждая роль имеет интересы; интересы — основание разделения труда.

## Схема записи

```yaml
role: <slug>
title: <название>
phases: [фазы, где роль активна]
alphas: [альфы, за продвижение которых отвечает]
interests: [интересы роли; Том 1 гл. 6]
methods: [дисциплины/методы, которые несёт]
```

## Роли Волны 1

### product-owner
title: Владелец продукта
phases: [vision, requirements, operations]
alphas: [Opportunity, Stakeholders, Requirements]
interests: [ценность для пользователя, приоритеты фичей, метрики успеха]
methods: [product-discovery, stakeholder-analysis]

### architect
title: Архитектор
phases: [architecture, development, testing]
alphas: [Software System, Requirements]
interests: [значимые решения, качественные атрибуты, долговечность]
methods: [software-architecture, functional-decomposition]

### developer
title: Разработчик
phases: [development, testing]
alphas: [Software System, Work]
interests: [сопровождаемость кода, скорость фидбэка, автоматизация]
methods: [software-construction, tdd]

### tester
title: Тестировщик
phases: [testing, development]
alphas: [Software System, Requirements]
interests: [покрытие поведения, устойчивость, регрессии]
methods: [software-testing, tdd]

### devops
title: DevOps-инженер
phases: [deployment, operations]
alphas: [Software System]
interests: [скорость доставки, обратимость, предсказуемость сред]
methods: [continuous-delivery]

### sre
title: Site Reliability Engineer
phases: [operations]
alphas: [Software System, Opportunity]
interests: [надёжность, SLO, бюджеты ошибок, инциденты]
methods: [site-reliability-engineering]

### method-engineer
title: Инженер методов
phases: [сквозная]
alphas: [Way of Working]
interests: [соответствие метода ситуации проекта, эволюция практик]
methods: [situational-method-engineering]

### systems-thinker
title: Системный мыслитель
phases: [сквозная]
alphas: [Software System, Opportunity]
interests: [границы системы, надсистема, подсистемы, окружение]
methods: [systems-thinking]

## Правила использования

Пользователь выбирает текущую роль через `/sdlc-continue`.
`sdlc-state-reader` читает роль из `target/.claude/sdlc/roles.md`.
Роль сужает предлагаемые фазы и задачи.
Интересы роли учитываются в опросе `sdlc-method-engineering`.

## Схема `role → [phases] → [alphas обязательные]`

| Роль | Фазы | Обязательные альфы |
|---|---|---|
| product-owner | vision, requirements | Opportunity, Requirements |
| architect | architecture | Software System |
| developer | development | Software System |
| tester | testing | Software System, Requirements |
| devops | deployment | Software System |
| sre | operations | Software System |
| method-engineer | сквозная | Way of Working |
| systems-thinker | сквозная | Software System |
