---
name: profile
type: sdlc-profile
project: ai-driven-sdlc-plugin
created: 2026-04-19
updated: 2026-04-19
---

# SME-профиль проекта

Методологический слой: выборы уровней сложности и инструментов по фазам.
Технические параметры hooks живут в `plugin-config.md`.

## Таблица SME по фазам

| Фаза | Уровень SME | Выбранный метод | Выбранный инструмент | default_autonomy |
|---|---|---|---|---|
| vision | pet | Одностраничное описание проблемы и цели | README-as-vision | hitl |
| requirements | mid | Декомпозиция на проверяемые единицы с AC | User Stories + Gherkin AC | hitl |

| architecture | mid | Фиксация значимых решений и многоуровневое моделирование | ADR (Nygard) | hitl |
| development | — | — | — | hitl |
| testing | — | — | — | hitl |
| deployment | — | — | — | hitl |
| operations | — | — | — | hitl |

Прочерк значит: уровень и инструмент ещё не выбраны, запустите `/sdlc-phase <name>`.

## Активная роль

- `method-engineer` — инженер методов; отвечает за альфу Way of Working.

Полное определение роли — в `catalogs/roles.md` плагина.
Журнал смены ролей — в `roles.md` целевого проекта.

## История изменений SME

- 2026-04-19 — bootstrap; уровень проекта зафиксирован как pet.
- 2026-04-19 — vision выбран: pet, README-as-vision, autonomy hitl.
- 2026-04-19 — requirements выбран: mid, User Stories + Gherkin AC, autonomy hitl.
- 2026-04-19 — architecture выбран: mid, ADR (Nygard), autonomy hitl.
