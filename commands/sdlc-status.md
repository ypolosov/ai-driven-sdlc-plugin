---
name: sdlc-status
description: Показать текущее состояние SDLC целевого проекта: альфы, профиль SME, активная роль, фокус системы внимания, последние решения.
---

# `/sdlc-status`

Краткая сводка состояния целевого проекта.

## Поведение

1. Прочитать `profile.md` — текущие уровни SME по фазам.
2. Запросить состояние альф у `sdlc-alpha-tracker`.
3. Прочитать `system-context.md` — текущая целевая система и соседи.
4. Прочитать `roles.md` — активные роли.
5. Прочитать последние записи `decisions.md`.
6. При наличии `audit.md` — показать статус последнего аудита.
7. Вывести сводку в один экран.

## Формат вывода

```
## SDLC status для <project>

Текущая целевая система: <slug> (kind: <kind>)
Активная роль: <slug>
Уровень по фазам:
  vision:       <level> — <инструмент>
  requirements: <level> — <инструмент>
  architecture: <level> — <инструмент>
  development:  <level> — <инструмент>
  testing:      <level> — <инструмент>
  deployment:   <level> — <инструмент>
  operations:   <level> — <инструмент>

Альфы:
  Opportunity:     <state>
  Stakeholders:    <state>
  Requirements:    <state>
  Software System: <state>
  Work:            <state>
  Team:            <state>
  Way of Working:  <state>

Последний аудит: <status> (<дата>)
Последнее решение: <заголовок из decisions.md>
```

## Связи

- Использует `sdlc-state-reader` и `sdlc-alpha-tracker`.
- Не изменяет артефакты; только читает.
