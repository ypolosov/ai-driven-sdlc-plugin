# Release v0.15.0 — Wave 12: bootstrap-полнота + методологическая корректность

**Тип:** minor (semver) — изменение протокола `sdlc-bootstrap` + schema `system-context`.

## Контекст

Wave 12 закрывает **оставшиеся 5 находок** issue [#82](https://github.com/ypolosov/ai-driven-sdlc-plugin/issues/82) из 3-раундового критического аудита. После Wave 10-12 закрыто **12 пунктов** — bootstrap для GromTech enterprise полностью готов.

## Изменения

| Fix | Что | Линза |
|---|---|---|
| **B1.2** | `bootstrap-target.sh` создаёт `tool-bindings.md` skeleton (7 категорий, `verified: false`) | устраняет orphan-ссылку; `sdlc-tool-router` не refuse |
| **B1.3** | `.env.example`: `SDLC_STATE_RAG_DSN` + category placeholder'ы | enterprise-onboarding |
| **B6.1** | `system-context.meta.md`: ось `axis: functional \| constructive` + предупреждение про конструктивы | Левенчук Том 2 гл.7 (A1) |
| **B3.4** | `SKILL.md`: provenance-маркировка seed-значений; запрет выдумывать при недоступном MCP | принцип 19a (A5) |
| **B2.5** | `SKILL.md`: enterprise SME = `proposal`, требует team-review | Essence Stakeholders (A7) |

## Прогресс по #82 (итог Wave 10-12)

- **v0.13.0:** B0.1, B0.2, B0.3, B0.6, B4.4 (5 истинных блокеров)
- **v0.14.0:** B0.4, B0.5 (методологический корень + Этап-0 gate)
- **v0.15.0:** B1.2, B1.3, B6.1, B3.4, B2.5 (полнота + корректность)

**Итого 12 пунктов.** Остаток #82 — нижнеприоритетные P2 (B2.1 team-onboarding doc, B2.2 shared settings.json, B2.3 per-phase TTL, B2.4 meta-versioning, B3.x наблюдаемость, B4.x безопасность, B5.x docs).

## Качество

- 258 bats-теста зелёные, 0 регрессий (211 unit + 47 integration); +15 новых кейсов (TDD red→green).
- `shellcheck` CLEAN; `check-readme-inventory: OK`; Принцип 16 (README/CHANGELOG).

## Применение к GromTech

После `/plugin update` (v0.15.0) + рестарт: `/sdlc-init` в `/workspaces/gt` с ответом «brownfield» → корректные альфы, tool-bindings skeleton готов, provenance-маркировка при отключённых MCP, SME как team-proposal.
