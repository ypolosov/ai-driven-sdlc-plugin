---
name: ADR-011
type: adr
title: Единый sdlc-state-rag backend (PostgreSQL+pgvector + embedded OMG Essence)
status: Accepted
date: 2026-05-05
nfr: [reliability, maintainability, security, performance]
principles: [6, 13, 20, 21]
supersedes: ADR-009
---

# ADR-011: Единый `sdlc-state-rag` backend (PostgreSQL+pgvector + embedded OMG Essence)

## Контекст

ADR-009 ввёл `essence-alpha-mcp` как авторитативный backend альф (SQLite).
Wave 4/5 multi-agent extension требует:
- Per-target instance БД (одна команда → одна БД).
- Concurrent-safe продвижение альф (несколько агентов параллельно).
- Векторный поиск по артефактам (RAG для контекста).
- Журнал решений и аудита для агрегатора.
- Markdown как PR-видимый snapshot, не источник истины.

SQLite single-writer не подходит для команд 5+ человек.
Два MCP-сервера (essence-alpha + RAG) усложняют операционную модель.
Альфы и RAG-доменные данные одинаково реляционные и часто связаны.

## Решение

Введён единый MCP-сервер `sdlc-state-rag` per-target, объединяющий 5 доменов:
- Alpha state machine (OMG Essence 1.2, реализованная **внутри** сервера в TypeScript).
- RAG vectors (pgvector embedding'и).
- Decisions journal (альтернативы и выборы).
- Audit log (события аудита).
- Sync events (worker / webhook events).

Backend: PostgreSQL+pgvector.
Pet: embedded `@electric-sql/pglite` v0.4+ (in-process WASM Postgres с pgvector).
Mid: shared PostgreSQL.
Enterprise: managed cloud (Supabase / Neon / AWS RDS).

Connection-string per-target в `<target>/.env` (`SDLC_STATE_RAG_DSN`).
`sdlc-alpha-tracker` дёргает **только** `state_*` tools `sdlc-state-rag`.
Регистрация `essence-alpha` удаляется из `.mcp.json` плагина.
ADR-009 переходит в статус `Deprecated` (логика инкорпорирована).

Композитные tools для атомарных операций (MCP stateless):
- `state_advance_with_decision`, `state_regress_with_audit`, `rag_upsert_with_sync_event`.
Изоляция `SERIALIZABLE` для критических переходов; `SELECT … FOR UPDATE` на альфах.

## Альтернативы

- A1. Оставить `essence-alpha-mcp` (SQLite) + отдельный RAG-сервер.
  Отказ: single-writer на team; два сервера усложняют конфиг.
- A2. Embedded SQLite во всех уровнях, без PostgreSQL.
  Отказ: не поддерживает pgvector в стабильном API; single-writer.
- A3. Реализовать OMG Essence как отдельный микросервис вне MCP.
  Отказ: дополнительный operational hop; усложняет dogfooding.
- A4. Внешний transaction_token для cross-call транзакций.
  Отказ: MCP stateless по протоколу; cross-call state нестандартен.

## Последствия

- Принципы 20 (worker по SME), 21 (per-target БД) формализованы в CLAUDE.md.
- ADR-009 → `Deprecated`; в frontmatter: `superseded_by: ADR-011`.
- `essence-alpha` удалена из `.mcp.json` плагина.
- `sdlc-state-rag` добавлена в `.mcp.json` плагина с `${SDLC_STATE_RAG_DSN}`.
- `sdlc-alpha-tracker` обновлён: использует `state_*` tools вместо `essence_*`.
- Связь с принципом 13 сохранена: трекер — единственный путь к альфам.
- Mid+ команды получают concurrent-safe продвижение альф.
- Единый MCP-сервер вместо двух упрощает onboarding.
- Pglite v0.4 даёт offline-friendly pet-режим (cold-start через `npx -y`).
- Bats-фикстуры renamed: `ESSENCE_ALPHA_VALIDATE_CMD` → `SDLC_STATE_RAG_VALIDATE_CMD`.
- Migration `scripts/migrate-essence-to-state-rag.sh` — разовая, для dogfooding.

## Связь

- Реализует принципы 6 (детерминизм), 13 (single source альф), 20 (worker), 21 (per-target).
- Supersedes ADR-009.
- Готовит ADR-012 (worker pattern по SME) и ADR-014 (enterprise dogfooding).
- Контракт — `meta-templates/sdlc-state-rag-contract.meta.md`.
- Внешний npm-пакет — `@ypolosov/sdlc-state-rag` (PR-E2a..d).
