---
name: c4-diagram.meta
type: meta-template
scope: схема C4-диаграммы для архитектурного описания (Context/Container/Component/Code)
extends: work-product.meta.md
location_in_target: .claude/sdlc/phases/architecture/c4/<level>-<diagram-slug>.md
source: Wave 8 #60 Gap-7 (gt-validation), Simon Brown C4 model
level: <Context|Container|Component|Code>
format: <plantuml|structurizr|mermaid>
file_path: null
---

# Мета-шаблон C4-диаграммы

Используется для описания архитектуры через 4 уровня C4-модели (Simon Brown).
Один файл = одна диаграмма одного уровня.

## Обязательный frontmatter

```yaml
---
name: <diagram-slug>
type: c4-diagram
phase: architecture
project: <target-project>
level: <Context|Container|Component|Code>
format: <plantuml|structurizr|mermaid>
file_path: <относительный путь к рендерному файлу .puml/.dsl/.mmd, или null если inline>
sme_level: <pet|mid|enterprise>
alphas: [Software System]
role: <architect|developer>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

## C4 Levels (Simon Brown)

| Level | Назначение | Аудитория |
|---|---|---|
| Context | Система и её внешние зависимости (people, systems) | бизнес + tech |
| Container | High-level technology choices (apps, databases, services) | tech leads |
| Component | Внутренние компоненты одного container'а | разработчики |
| Code | Class-level / file-level decomposition (опционально) | разработчики |

## Format options

- **PlantUML** (`.puml`) — текстовый DSL; рендеринг через `plantuml.jar` или Kroki API.
  - Использовать `c4-plantuml` library: `!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml`.
- **Structurizr** (`.dsl`) — Structurizr DSL; рендеринг через Structurizr Lite или Cloud.
  - Workspace-based, multiple views в одном файле.
- **Mermaid** (`.mmd`) — markdown-friendly; нативный рендер в GitHub README.
  - C4 поддержка через `c4Context`, `c4Container` синтаксис (experimental).

## Обязательные секции

### 1. Назначение

Одно утверждение, какой архитектурный аспект диаграмма описывает.

### 2. Diagram (inline или ссылка)

Если `file_path` null — diagram-text inline в fenced-блок:
````markdown
```plantuml
@startuml
!include C4_Context.puml
Person(user, "User", "End user")
System(myApp, "MyApp", "The system")
Rel(user, myApp, "Uses")
@enduml
```
````

Если `file_path` установлен — ссылка на external file:
```markdown
См. [c4/context-overview.puml](c4/context-overview.puml).
```

### 3. Описание элементов

Markdown-list или таблица: имя элемента → роль → ответственность.

### 4. Связи с другими C4-уровнями

- Container-уровень детализирует Context-системы.
- Component-уровень детализирует Container'ы.
- traces_to: ссылки на ADR'ы, описывающие выбор technology.

### 5. Критерии готовности

- Все элементы диаграммы имеют описание.
- Связи направлены и подписаны.
- Если level≥Container — указаны technology choices.

## Привязка к альфам

Диаграмма продвигает:
- `Software System` — добавляет evidence на Architecture Selected.

## Pet vs Mid vs Enterprise

| Уровень | C4-уровни типично | Format |
|---|---|---|
| pet | Context only (single diagram) | Mermaid (markdown-native) |
| mid | Context + Container (1-2 diagrams) | PlantUML или Mermaid |
| enterprise | Context + Container + Component (3+ diagrams) | Structurizr (workspace) |

## Правила

- Создание через skill `sdlc-architecture` опционально (mid+ обычно используют).
- AskUserQuestion перед write (принцип 1).
- `level` enum валидируется при `validate-artifact.sh`.
- Diagram source — versioned в `<target>/.claude/sdlc/phases/architecture/c4/`.

## Валидация

`validate-artifact.sh` + проверка enum `level` и `format`.
