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
| testing | mid | Пирамида автотестов с покрытием как пороговым критерием | Unit + Integration + E2E | hitl |
| development | mid | TDD-first итерации с CI-гейтами и линтерами | bats-core + shellcheck + shfmt + GitHub Actions | hitl |
| deployment | mid | Стратегия релизов с semver и CHANGELOG | semver + CHANGELOG + GitHub Releases + marketplace | hitl |
| operations | pet | GitHub Issues как единственный канал обратной связи | Issue templates + SUPPORT.md | hitl |

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
- 2026-04-19 — testing выбран: mid, Unit + Integration + E2E, autonomy hitl.
- 2026-04-19 — development выбран: mid, bats-core + shellcheck + shfmt + GitHub Actions, autonomy hitl.
- 2026-04-19 — deployment выбран: mid, semver + CHANGELOG + GitHub Releases + marketplace, autonomy hitl.
- 2026-04-19 — operations выбран: pet, GitHub Issues + templates + SUPPORT.md, autonomy hitl.
