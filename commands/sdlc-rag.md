---
name: sdlc-rag
description: Управление RAG-индексом целевого через sdlc-state-rag MCP. Подкоманды reindex, query, stats, purge. Все mutating действия через AskUserQuestion (принцип 1). Скелет в Волне 5; полная функциональность зависит от реализации @ypolosov/sdlc-state-rag npm-пакета.
---

# `/sdlc-rag <subcommand>`

Управление RAG-индексом артефактов и внешних источников целевого.

## Подкоманды

### `/sdlc-rag reindex [--source <id>]`

Переиндексировать источники в RAG.

1. Прочитать `<target>/.claude/sdlc/rag-config.md`.
2. Если `enabled: false` — отказать; сообщить `/sdlc-rag enable`.
3. Через `AskUserQuestion` подтвердить переиндексацию (объём, время).
4. Для каждого источника из `sources` собрать документы.
5. Вызвать `mcp__sdlc_state_rag__rag_upsert_documents`.
6. Записать sync-событие через `sync_emit`.
7. Вывести статистику: документов / чанков / время.

### `/sdlc-rag query <text> [--top-k N]`

Поиск по индексу.

1. Прочитать `rag-config.md`; убедиться `enabled: true`.
2. Вызвать `mcp__sdlc_state_rag__rag_query_chunks`.
3. Вывести таблицу: chunk → score → provenance.
4. Read-only; AskUserQuestion не требуется.

### `/sdlc-rag stats`

Сводка по индексу.

1. Вызвать `mcp__sdlc_state_rag__rag_stats`.
2. Вывести: документов, чанков, источников, последний reindex.

### `/sdlc-rag purge [--ttl-days N]`

Удалить устаревшие чанки.

1. Через `AskUserQuestion` подтвердить намерение и TTL.
2. Вызвать `mcp__sdlc_state_rag__rag_purge_by_ttl`.
3. Вывести количество удалённых чанков.
4. В HOOTL `--force` пропускает подтверждение; альтернативы в `decisions.md`.

## Поведение в HOOTL

Деструктивные действия (`purge`) требуют `--force` в HOOTL.
В HITL/HOTL `AskUserQuestion` обязателен (принцип 1).

## Связи

- Использует MCP-сервер `sdlc-state-rag` (ADR-011).
- Конфиг — `rag-config.meta.md`.
- Мета-шаблон контракта — `sdlc-state-rag-contract.meta.md`.
- Закрывает каркас Волны 5; полная функциональность — в `@ypolosov/sdlc-state-rag`.

## Ограничения

- Команда не пишет в `alphas.md`; альфы — через `sdlc-alpha-tracker`.
- Команда не упоминает имена конкретных продуктов; только slugs категорий.
- При `enabled: false` команда отказывается работать (принцип 19a applies).
