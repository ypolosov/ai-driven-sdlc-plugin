---
name: alphas
type: alpha-snapshot
project: ai-driven-sdlc-plugin
updated: 2026-05-10
source_of_truth: mcp://sdlc-state-rag
snapshot_role: pr-visible-mirror
generated_after: mcp-write
---

# Snapshot состояний альф

Авторитативный backend — MCP-сервер `sdlc-state-rag` (см. ADR-011).
Этот файл — PR-видимый snapshot текущих состояний альф.
Журнал переходов живёт в БД через `state_list_transitions`.
Прямое чтение этого файла другими агентами запрещено (принцип 13).

## Текущее состояние альф

| Альфа | Состояние | Артефакт-свидетельство | Дата |
|---|---|---|---|
| Opportunity | Value Established | `.claude/sdlc/phases/vision/vision.md` | 2026-04-19 |
| Stakeholders | Involved | `.claude/sdlc/phases/requirements/requirements.md` | 2026-04-19 |
| Requirements | Acceptable | `.claude/sdlc/phases/architecture/architecture.md` | 2026-04-19 |
| Software System | Usable | `CHANGELOG.md#0.10.0` | 2026-05-10 |
| Work | Under Control | `tests/unit/validate-artifact.bats` | 2026-04-19 |
| Team | Seeded | `.claude/sdlc/roles.md` | 2026-04-19 |
| Way of Working | Working Well | `.claude/sdlc/phases/testing/testing.md` §7a | 2026-05-01 |

Прочерк значит: альфа ещё не продвигалась.

## Журнал переходов

Журнал делегирован MCP-серверу `sdlc-state-rag` (ADR-011).
Получение через `mcp__sdlc_state_rag__state_list_transitions(alpha_id=<kebab-id>)`.
Исторический журнал — `.claude/sdlc/alphas.md.backup-2026-05-05` (snapshot до миграции Wave 5).

## Bootstrap БД (Wave 5)

БД (pglite в `.sdlc-db/`) заселена 2026-05-05 через `scripts/migrate-essence-to-state-rag.sh`.
7 альф мигрированы из snapshot; OMG Essence 1.2 conformance — внутри `@ypolosov/sdlc-state-rag@0.1.1`.

## Журнал MCP-продвижений

- 2026-05-01: way-of-working In Use → In Place; затем In Place → Working Well.
- Evidence обоих переходов — `phases/testing/testing.md` §7a.
- Триггер — расширение bench-hooks с 5 до 8 hooks.
- 2026-05-02: software-system Usable → Demonstrable → Usable (refresh evidence).
- Evidence обновлён на `CHANGELOG.md` секция [0.3.0]; rationale — релиз v0.3.0.
- Состояние Usable сохранено; продвижение на Ready отложено до Стадии D.
- 2026-05-10: software-system evidence refresh на `CHANGELOG.md` секция [0.10.0] через `decisions_record` (без artificial state-cycle).
- Rationale: v0.10.0 published, Wave 7 closed 5 issues, P2 issues #59-#61 ещё открыты — Ready criteria не достигнуты.
- 2026-05-10: way-of-working evidence refresh с bench-hooks 9 hooks (Wave 5 enforce-sdlc-phase).
