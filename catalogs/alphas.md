---
name: alphas
type: catalog
scope: определения альф SDLC, не их состояние
source: OMG Essence / SEMAT; Левенчук «Методология 2025»
---

# Каталог альф SDLC

Альфа — объект отслеживания состояния в методе.
Это не документ, а сущность, продвигаемая по состояниям.
Каждая альфа имеет жизненный цикл и чек-лист признаков состояния.

## Базовые альфы (адаптация Essence)

### Opportunity — «Возможность»
Описывает почему разрабатывают систему, какую проблему решают.
Продвигается в фазе Vision.
Состояния: Identified → Solution Needed → Value Established → Viable → Addressed → Benefit Accrued.
Источник: Essence, OMG.

### Stakeholders — «Стейкхолдеры»
Группы людей и систем с интересами к продукту.
Продвигается в фазах Vision и Requirements.
Состояния: Recognized → Represented → Involved → In Agreement → Satisfied for Deployment → Satisfied in Use.
Источник: Essence; Левенчук Том 1 гл. 6 (интересы).

### Requirements — «Требования»
Что система должна делать и с каким качеством.
Продвигается в фазе Requirements.
Состояния: Conceived → Bounded → Coherent → Acceptable → Addressed → Fulfilled.
Источник: Essence.

### Software System — «Программная система»
Воплощённая целевая система: код, конфигурация, инфраструктура.
Продвигается в фазах Architecture, Development, Deployment, Operations.
Состояния: Architecture Selected → Demonstrable → Usable → Ready → Operational → Retired.
Источник: Essence; Левенчук Том 1 гл. 4 (воплощение).

### Work — «Работа»
Активности команды по продвижению других альф.
Продвигается постоянно.
Состояния: Initiated → Prepared → Started → Under Control → Concluded → Closed.
Источник: Essence.

### Team — «Команда»
Группа ролей и акторов, ведущих разработку.
Продвигается в фазах всех.
Состояния: Seeded → Formed → Collaborating → Performing → Adjourned.
Источник: Essence.

### Way of Working — «Способ работы»
Метод, практики, инструменты и правила команды.
Продвигается через фазу Bootstrap и изменения профиля SME.
Состояния: Principles Established → Foundation Established → In Use → In Place → Working Well → Retired.
Источник: Essence; Левенчук «Методология 2025».

## Привязка альф к фазам SDLC

| Фаза | Продвигаемые альфы |
|---|---|
| Vision | Opportunity, Stakeholders |
| Requirements | Stakeholders, Requirements |
| Architecture | Software System, Requirements |
| Development | Software System, Work |
| Testing | Software System, Requirements |
| Deployment | Software System |
| Operations | Software System, Opportunity |

## Правила использования

Каждый артефакт SDLC привязывается минимум к одной альфе.
`sdlc-alpha-tracker` — единственный источник истины о текущих состояниях.
Продвижение альфы без подтверждающего артефакта отклоняется аудитором.
