---
name: wave-5-enterprise-example
type: example
scope: демо-сценарий 4 — enterprise target с PgVector + cron-workflow + webhook
source: ADR-014; принцип 12 (dogfooding); ADR-011 (sdlc-state-rag)
---

# Демо-сценарий 4: enterprise target с PgVector + cron + webhooks

Пример enterprise-целевого проекта, использующего полную Wave 5 функциональность:

- `sdlc-state-rag` MCP подключён через DSN на managed PostgreSQL+pgvector.
- Worker `.sdlc-worker/` (Mastra) запускает cron-workflow и обрабатывает webhook-эндпоинты.
- Реестр webhook'ов в `.claude/sdlc/webhooks.md` (по `webhooks.meta.md`).
- Альфы продвигаются concurrent-safe через `state_advance_with_decision`.

## Структура

```
examples/wave-5-enterprise/
├── README.md                        # этот файл
├── .claude/
│   └── sdlc/
│       ├── plugin-config.md         # rag_ref на rag-config.md, workers.cron+webhooks
│       ├── rag-config.md            # enabled=true, embedder, sources, worker.kind=cron+webhooks
│       ├── tool-bindings.md         # 6 категорий через MCP
│       ├── webhooks.md              # 3 endpoint'а (issue-tracker, vcs, observability)
│       └── role-extensions.md       # 10+ ролей включая AI consistency-auditor
├── .sdlc-worker/
│   ├── package.json                 # mastra, @mastra/rag, @mastra/pg, sdlc-state-rag
│   └── src/
│       └── index.ts                 # точка входа: cron-workflow + webhook routes
└── .env.example                     # SDLC_STATE_RAG_DSN + 6 token'ов + 3 webhook secret'а
```

## Поток данных

1. Webhook от issue-tracker → endpoint `tracker-issue-events` → `sdlc-state-rag sync_emit`.
2. Cron-workflow (каждые 4ч) → `rag_upsert_documents` для filesystem + MCP-источников.
3. `sdlc-context-aggregator` запрашивает контекст у `rag_query_chunks` + state-reader + tool-router.
4. Альфа продвигается через `sdlc-alpha-tracker` → `state_advance_with_decision` (одна транзакция).

## Запуск (концепт)

```bash
# 1. PostgreSQL+pgvector (managed: Supabase / Neon / RDS)
export SDLC_STATE_RAG_DSN=postgresql://user:pass@host:5432/my_target

# 2. Поднять worker (Mastra)
cd .sdlc-worker && npm install && npm run start

# 3. Запустить плагин в Claude Code
/sdlc-init
/sdlc-tools bind issue-tracker
/sdlc-rag reindex
```

## Связь

- `.claude/sdlc/plugin-config.md` со ссылкой на `rag-config.md`.
- `.sdlc-worker/` — runtime (gitignored по умолчанию через `.gitignore`).
- `webhooks.md` — конфигурация endpoint'ов.
- ADR-014 — обоснование dogfooding и worker-runtime.
- ADR-011, ADR-012 — backend и worker-pattern.
