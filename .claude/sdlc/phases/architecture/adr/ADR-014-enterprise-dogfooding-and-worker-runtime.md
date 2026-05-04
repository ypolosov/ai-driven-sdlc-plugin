---
name: ADR-014
type: adr
title: Enterprise dogfooding и worker-runtime через .sdlc-worker
status: Accepted
date: 2026-05-05
nfr: [reliability, maintainability, security]
principles: [12, 14, 20]
---

# ADR-014: Enterprise dogfooding и worker-runtime через `.sdlc-worker`

## Контекст

Wave 5 sdlc-state-rag индексирует артефакты целевого через worker'ы.
Принцип 14 (Волна 2) ограничивал артефакты SDLC директорией `.claude/sdlc/`.
Worker-runtime (TypeScript Mastra или подобный) — не SDLC-артефакт; это runtime-инфраструктура.
Принцип 12 (dogfooding) требует чтобы плагин применялся к самому себе как enterprise-target.

## Решение

Worker-runtime живёт в корне целевого по конвенции `.sdlc-worker/` (gitignored по умолчанию).
SDLC-артефакты остаются в `.claude/sdlc/` (без расширения принципа 14 в коде).
Однако memom фиксирует **расширение** принципа 14: hooks/агенты по-прежнему опираются только на `.claude/sdlc/`, но runtime-инфраструктура (БД, Docker, MCP, worker) живёт по конвенции в корне.

`.sdlc-worker/` — пример Mastra-проекта (TypeScript) для enterprise-target'а:
- `.sdlc-worker/package.json` — зависимости (mastra, @mastra/rag, @mastra/pg, sdlc-state-rag client).
- `.sdlc-worker/src/workflows/` — cron-workflow'ы.
- `.sdlc-worker/src/webhooks/` — webhook-handler'ы.
- `.sdlc-worker/src/index.ts` — точка входа.

`enforce-no-comments.sh` расширяется на `.sdlc-worker/**.ts` (принцип 4a).
TypeScript-pragma directives (`// @ts-ignore`, `// @ts-expect-error`) добавлены в whitelist.

## Альтернативы

- A1. Worker внутри `.claude/sdlc/`.
  Отказ: смешивает SDLC-артефакты с runtime-кодом; нарушает разделение.
- A2. Worker в отдельном репозитории.
  Отказ: усложняет dogfooding; runtime-конфиг привязан к проекту.
- A3. Worker как ещё один MCP-сервер.
  Отказ: cron-workflow и webhooks — long-running, MCP — request/response.

## Последствия

- Принцип 14 формально не меняется (hooks смотрят только `.claude/sdlc/`).
- Memom-запись фиксирует расширение конвенции для runtime-инфраструктуры.
- `enforce-no-comments.sh` распространяется на `.sdlc-worker/**.ts` с TS-whitelist.
- Демо-сценарий 4 показывает enterprise-target с PgVector + cron + webhooks.
- README inventory: Meta-templates 15→16 (+webhooks.meta.md).
- Pet/mid не трогаются (worker.kind=null/cron, без webhooks).

## Связь

- Реализует принципы 12 (dogfooding на enterprise), 14 (конвенция пути), 20 (worker по SME).
- Использует ADR-011 (sdlc-state-rag), ADR-012 (worker pattern).
- Поглощает webhooks-эндпоинты в `meta-templates/webhooks.meta.md`.
- Закрывает epic #20 (enterprise: команда ~10 человек).
