---
name: alphas
type: alpha-snapshot
project: ai-driven-sdlc-plugin
updated: 2026-04-30
source_of_truth: mcp://essence-alpha
snapshot_role: pr-visible-mirror
generated_after: mcp-write
---

# Snapshot состояний альф

Авторитативный backend — MCP-сервер `essence-alpha` (см. ADR-009).
Этот файл — PR-видимый snapshot текущих состояний альф.
Журнал переходов живёт в БД через `essence_list_transitions`.
Прямое чтение этого файла другими агентами запрещено (принцип 13).

## Текущее состояние альф

| Альфа | Состояние | Артефакт-свидетельство | Дата |
|---|---|---|---|
| Opportunity | Value Established | `.claude/sdlc/phases/vision/vision.md` | 2026-04-19 |
| Stakeholders | Involved | `.claude/sdlc/phases/requirements/requirements.md` | 2026-04-19 |
| Requirements | Acceptable | `.claude/sdlc/phases/architecture/architecture.md` | 2026-04-19 |
| Software System | Usable | `CHANGELOG.md#0.2.1` | 2026-04-21 |
| Work | Under Control | `tests/unit/validate-artifact.bats` | 2026-04-19 |
| Team | Seeded | `.claude/sdlc/roles.md` | 2026-04-19 |
| Way of Working | In Use | `.claude/sdlc/phases/testing/testing.md` | 2026-04-19 |

Прочерк значит: альфа ещё не продвигалась.

## Журнал переходов

Журнал делегирован MCP-серверу `essence-alpha`.
Получение через `mcp__essence_alpha__essence_list_transitions(alpha=<kebab-id>)`.
Исторический журнал до 2026-04-30 — out of scope MVP интеграции.

## Bootstrap БД

При первом старте БД пустая.
Bootstrap текущих состояний — отдельная задача (см. ADR-009 Out of scope).
До bootstrap'а snapshot и БД могут расходиться.
