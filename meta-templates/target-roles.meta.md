---
name: target-roles.meta
type: meta-template
scope: схема role-extensions.md — конкретные ролевые специализации целевого проекта
location_in_target: .claude/sdlc/role-extensions.md
source: Левенчук Том 1 гл. 5; принцип 3 (абстрактное в плагине, конкретное в целевом)
---

# Мета-шаблон `role-extensions.md`

Реестр конкретных ролевых специализаций целевого проекта.
Каждая запись расширяет одну или несколько абстрактных ролей плагина.
Абстрактные роли определены в `catalogs/roles.md` плагина (9 ролей).
Категории инструментов — в `catalogs/tool-categories.md` плагина (7 категорий).

## Обязательный frontmatter

```yaml
---
name: role-extensions
type: target-role-mapping
project: <slug>
updated: <YYYY-MM-DD>
---
```

## Обязательная схема записи роли

```yaml
- id: <slug>
  title: <человекочитаемое название>
  extends: [<abstract-role>, ...]
  agent_kind: human | ai | both
  tool_categories: [<id>...]
  phases: [<phase>...]
  alphas: [<alpha>...]
  interests: [<short text>...]
  notes: <free text>
```

## Поля записи

- `id` — уникальный slug роли в целевом проекте.
- `title` — человекочитаемое имя роли.
- `extends` — список абстрактных ролей плагина, которые конкретная роль реализует.
- `agent_kind` — тип актора: `human`, `ai`, `both`.
- `tool_categories` — категории SDLC-инструментов, релевантные роли.
- `phases` — фазы SDLC, где роль активна.
- `alphas` — обязательные альфы, за продвижение которых отвечает.
- `interests` — интересы роли (Левенчук Том 1 гл. 6).
- `notes` — свободный комментарий о роли.

## Примеры по уровню SME

### pet (одна составная роль)

```yaml
- id: solo-entrepreneur
  title: Соло-предприниматель
  extends: [product-owner, architect, developer, tester, devops]
  agent_kind: human
  tool_categories: [vcs]
  phases: [vision, requirements, architecture, development, testing, deployment, operations]
  alphas: [Opportunity, Software System, Work]
  interests: [скорость, минимум инструментов, окупаемость]
  notes: один человек играет все абстрактные роли pet-проекта
```

### mid (5–7 ролей команды)

```yaml
- id: business-owner
  title: Бизнес-владелец продукта
  extends: [product-owner]
  agent_kind: human
  tool_categories: [issue-tracker, knowledge-base, chat]
  phases: [vision, requirements]
  alphas: [Opportunity, Stakeholders]
  interests: [рынок, ROI, стратегия]
- id: backend-developer
  title: Backend-разработчик
  extends: [developer]
  agent_kind: human
  tool_categories: [vcs, issue-tracker, chat]
  phases: [development, testing]
  alphas: [Software System, Work]
  interests: [API, производительность, надёжность]
- id: frontend-developer
  title: Frontend-разработчик
  extends: [developer]
  agent_kind: human
  tool_categories: [vcs, issue-tracker, chat]
  phases: [development, testing]
  alphas: [Software System]
  interests: [UX, доступность, кросс-браузерность]
```

### enterprise (10+ ролей с AI-агентами)

```yaml
- id: consistency-auditor
  title: Сквозной аудитор согласованности
  extends: [method-engineer]
  agent_kind: ai
  tool_categories: [knowledge-base, issue-tracker]
  phases: [сквозная]
  alphas: [Way of Working]
  interests: [согласованность артефактов, fitness-функции]
  notes: AI-агент; запускается webhook'ом любого изменения artifact'а
- id: delivery-lead
  title: Лидер поставки
  extends: [method-engineer]
  agent_kind: ai
  tool_categories: [issue-tracker, cd-platform, chat]
  phases: [сквозная]
  alphas: [Work, Team]
  interests: [пропускная способность команды, блокеры]
  notes: AI-агент; закрывает epic #21 (роль-владелец альф Work и Team)
```

## Правила

- Поле `extends` обязательно ссылается на абстрактные роли из `catalogs/roles.md`.
- Запрещено создавать конкретные роли в плагине; только в целевом.
- При добавлении роли пользователь обязан передать `AskUserQuestion` ДО записи.
- Расширение каталога абстрактных ролей — только PR в плагин с обновлённым ADR.
- `agent_kind: ai` требует чтобы агент был зарегистрирован в `agents/`.
- `agent_kind: both` означает что роль может играть и человек, и AI.

## Связь с другими артефактами

- `roles.md` целевого (по `roles-state.meta.md`) ссылается на `id` отсюда.
- `tool-bindings.md` целевого использует `tool_categories` отсюда.
- `profile.md` целевого фиксирует SME-уровень, влияющий на подбор ролей.
