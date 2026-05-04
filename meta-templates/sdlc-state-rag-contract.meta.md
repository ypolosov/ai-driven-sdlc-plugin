---
name: sdlc-state-rag-contract.meta
type: meta-template
scope: контракт MCP-сервера sdlc-state-rag (5 доменов в одной БД)
location_in_target: подключается через .mcp.json целевого
source: ADR-011; OMG Essence 1.2; принципы 13, 20, 21
---

# Контракт `sdlc-state-rag` MCP-сервера

`sdlc-state-rag` — единый MCP-сервер per-target, объединяющий пять доменов в одной БД PostgreSQL+pgvector.
Полностью замещает `essence-alpha-mcp` (см. ADR-009 → Deprecated; ADR-011).

## Backend

- **pet** — embedded `@electric-sql/pglite` v0.4+ (in-process Postgres-WASM с pgvector).
- **mid** — shared PostgreSQL instance с pgvector extension.
- **enterprise** — managed cloud (Supabase / Neon / AWS RDS).

DSN передаётся через переменную окружения `SDLC_STATE_RAG_DSN` из `<target>/.env`.

## Пять доменов в одной БД

| Домен | Назначение | Ключевые таблицы |
|---|---|---|
| Alpha state machine | OMG Essence 1.2 переходы альф | `alpha_definitions`, `alpha_states`, `alpha_transitions` |
| RAG vectors | Векторное хранилище для поиска по артефактам | `documents`, `chunks` (с pgvector embedding) |
| Decisions journal | Журнал альтернатив (принцип 1) | `decisions` |
| Audit log | Журнал событий аудита | `audit_events` |
| Sync events | События от worker'ов и webhook'ов | `sync_events` |

## Tools (стандартизованные имена)

### Alpha state machine

- `state_get_alpha(alpha)` → `{state, evidence_uri, updated_at}`
- `state_advance_alpha(alpha, new_state, evidence_artifact)` → `{ok, transition_id}`
- `state_regress_alpha(alpha, new_state, audit_reason)` → `{ok, transition_id}`
- `state_list_transitions(alpha, limit)` → `[{from, to, evidence_uri, ts}, ...]`
- `state_validate_consistency(target_id)` → `{ok, violations}`
- `state_describe_alpha(alpha)` → `{name, states, transitions}`
- `state_get_state_chart()` → `{alphas, transitions}` (полная state-chart всех 7 альф)

### RAG vectors

- `rag_upsert_documents([{id, source, content, metadata}])` → `{ok, ids}`
- `rag_query_chunks(query_text, top_k, filters)` → `[{chunk, score, provenance}, ...]`
- `rag_purge_by_ttl(category, ttl_days)` → `{deleted}`
- `rag_stats()` → `{documents, chunks, sources}`

### Decisions journal

- `decisions_record(phase, alternatives, choice, rationale)` → `{id}`
- `decisions_list_relevant(intent, top_k)` → `[{decision, ts, score}, ...]`

### Audit log

- `audit_emit(kind, payload, evidence_uri)` → `{id}`
- `audit_query(filters)` → `[{event, ts}, ...]`

### Sync events

- `sync_emit(category, source, payload)` → `{id}`
- `sync_query(filters)` → `[{event, ts}, ...]`

### Композитные tools (атомарные операции, MCP stateless)

- `state_advance_with_decision(alpha, new_state, evidence_artifact, decision)` —
  одна PostgreSQL-транзакция: продвижение альфы + запись решения.
- `state_regress_with_audit(alpha, new_state, audit_reason, audit_payload)` —
  регресс альфы + audit-событие в одной транзакции.
- `rag_upsert_with_sync_event(documents, sync_event)` —
  upsert + sync-событие в одной транзакции.

## Транзакционность

- Изоляция `SERIALIZABLE` для критических переходов альф.
- Изоляция `READ COMMITTED` для read-операций.
- `SELECT … FOR UPDATE` на записи альфы при продвижении.
- Composite tools работают в одной транзакции; не зависят от cross-call state.

## Концурент-безопасность

- Каждая целевая система — свой instance БД (или своя schema в shared PostgreSQL).
- Connection-string per-target в `<target>/.env`.
- Параллельные `state_advance_alpha` сериализуются через `SERIALIZABLE` + `FOR UPDATE`.
- SQLite запрещён для team-проектов из-за single-writer.

## Связь с трекером

`sdlc-alpha-tracker` дёргает **только** `sdlc-state-rag` через `state_*` tools.
Никаких прямых обращений к `alphas.md` (принцип 13).
Никаких обращений к `essence-alpha` MCP (после Wave 5 он удалён из `.mcp.json`).

## Реализация

Внешний npm-пакет `@ypolosov/sdlc-state-rag` (TypeScript).
OMG Essence 1.2 state machine реализована **внутри** сервера (TypeScript), не как внешний backend.
PR-E2a — схема БД и PostgreSQL backend.
PR-E2b — OMG Essence engine + composite tools + concurrent-safety тесты.
PR-E2c — RAG/decisions/audit/sync домены.
PR-E2d — pglite + dogfooding миграция.

## Связь

- Принципы 13 (single source альф), 20 (worker по SME), 21 (per-target БД).
- ADR-011 (sdlc-state-rag) supersedes ADR-009 (essence-alpha-mcp).
- Конфигурация — `plugin-config.meta.md` секция `rag_ref`.
- Воркер — `meta-templates/rag-config.meta.md` (PR-F).
