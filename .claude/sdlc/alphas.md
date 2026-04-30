---
name: alphas
type: alpha-snapshot
project: ai-driven-sdlc-plugin
updated: 2026-05-01
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
| Way of Working | Working Well | `.claude/sdlc/phases/testing/testing.md` §7a | 2026-05-01 |

Прочерк значит: альфа ещё не продвигалась.

## Журнал переходов

Журнал делегирован MCP-серверу `essence-alpha`.
Получение через `mcp__essence_alpha__essence_list_transitions(alpha=<kebab-id>)`.
Исторический журнал до 2026-04-30 — out of scope MVP интеграции.

## Bootstrap БД

БД заселена 2026-04-30 через `scripts/seed-essence-alpha.sh`.
Записан 21 переход; `essence_validate_consistency` возвращает ok.
Snapshot и БД синхронизированы по итогам Стадии A.

## Журнал MCP-продвижений

- 2026-05-01: way-of-working In Use → In Place; затем In Place → Working Well.
- Evidence обоих переходов — `phases/testing/testing.md` §7a.
- Триггер — расширение bench-hooks с 5 до 8 hooks.
