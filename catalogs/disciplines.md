---
name: disciplines
type: catalog
scope: дисциплины, закреплённые за фазами SDLC
source: Левенчук «Методология 2025»; Том 1 гл. 5
---

# Каталог дисциплин SDLC

Дисциплина — знаниевый корпус, поддерживающий исполнение метода.
Дисциплина не привязана к инструменту; инструмент — способ её реализации.
Каждая фаза SDLC опирается на одну или несколько дисциплин.

## Дисциплины Волны 1

### Product discovery
Выявление возможностей и проверка гипотез ценности.
Фазы: Vision.
Альфы: Opportunity, Stakeholders.
Источник: Essence; Lean Startup.

### Stakeholder analysis
Выявление акторов и анализ их интересов.
Фазы: Vision, Requirements.
Альфы: Stakeholders.
Источник: Левенчук Том 1 гл. 6 (интересы).

### Requirements engineering
Формулирование, уточнение, верификация требований.
Фазы: Requirements.
Альфы: Requirements.
Источник: IEEE 830; BABOK.

### Software architecture
Проектирование значимых структурных решений.
Фазы: Architecture.
Альфы: Software System.
Источник: SEI Views-and-Beyond; TOGAF.

### Functional decomposition
Разбиение на функциональные роли независимо от реализации.
Фазы: Architecture, Requirements.
Источник: Том 2 гл. 10; IEC 1392/09.

### Software construction
Написание и эволюция исходного кода.
Фазы: Development.
Альфы: Software System, Work.
Источник: SWEBOK.

### Test-driven development
Формулирование теста как контракта до кода.
Фазы: Development, Testing.
Альфы: Software System, Requirements.
Источник: Beck «Test Driven Development».

### Software testing
Проверка соответствия воплощения описанию.
Фазы: Testing.
Альфы: Software System, Requirements.
Источник: SWEBOK; ISTQB.

### Continuous delivery
Автоматизированная доставка изменений в среды.
Фазы: Deployment.
Альфы: Software System.
Источник: Humble, Farley «Continuous Delivery».

### Site reliability engineering
Обеспечение надёжности в эксплуатации.
Фазы: Operations.
Альфы: Software System.
Источник: Google SRE book.

### Systems thinking
Выделение систем вниманием; работа с надсистемой, подсистемами, окружением.
Фазы: сквозная (через `sdlc-focus`).
Источник: Левенчук Том 2 гл. 7, 9.

### Situational method engineering
Выбор метода по ситуации проекта.
Фазы: сквозная (через `sdlc-method-engineering`).
Источник: Левенчук «Методология 2025».

## Привязка дисциплин к фазам

| Фаза | Основные дисциплины |
|---|---|
| Vision | Product discovery, Stakeholder analysis |
| Requirements | Requirements engineering, Stakeholder analysis |
| Architecture | Software architecture, Functional decomposition |
| Development | Software construction, TDD |
| Testing | Software testing, TDD |
| Deployment | Continuous delivery |
| Operations | Site reliability engineering |
| Сквозное | Systems thinking, Situational method engineering |

## Правила использования

Каждая skill-фаза объявляет дисциплины во frontmatter.
Метод в матрице «method-tool-matrix.md» реализует одну или несколько дисциплин.
Смена инструмента не меняет дисциплину; меняется лишь способ её исполнения.
