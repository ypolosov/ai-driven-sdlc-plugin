---
name: profile
type: sdlc-profile
project: ai-driven-sdlc-plugin
created: 2026-04-19
updated: 2026-05-05
active_phase: development
active_phase_set_at: 2026-05-10T20:42:00Z
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
- 2026-05-04 — Wave 4 merged (PR-A..G): tool-categories, abstract roles, tool-router, aggregator, sdlc-state-rag contract, rag-config, webhooks (ADR-010..016).
- 2026-05-05 — Wave 5 v0.5.0 ввёл принцип 22 + PreToolUse hook `enforce-sdlc-phase.sh`.
- 2026-05-06 — Wave 5 v0.5.1..v0.5.4: серия фиксов MCP Failed-to-connect (launch-sdlc-state-rag.sh).
- 2026-05-09 — Wave 6 v0.6.0: Fix A1 (`adr_paths` массив) + Fix A2 (`<target>/.mcp.json` auto-merge).
- 2026-05-10 — Wave 7 v0.7.0..v0.10.0: closed issues #54-#58 (1 P0 + 4 P1); 4 PR merged (#62-#65).
- 2026-05-10 — фаза development re-активирована для docs-PR drift cleanup (Wave 7 closure).
- 2026-05-10 — `sdlc-integrations` skill (Wave 4) фиксируется как **out-of-band** cross-cutting; не отдельная фаза в SME-таблице.
- 2026-05-10 — фаза deployment активирована для release v0.10.1 patch (PR #66 merged).
- 2026-05-10 — фаза development активирована для Wave 8 PR-1 (#69 check-alpha-consistency hook pglite fix).
- 2026-05-10 — фаза development активирована для Wave 8 PR-2 (#61 iteration.meta.md).
