# v0.4.0 — Multi-agent extension + sdlc-state-rag (Wave 4 + Wave 5)

Дата: 2026-05-05.

## ⚠️ BREAKING CHANGES

1. **`@ypolosov/essence-alpha-mcp` удалён из `.mcp.json`.**
   Заменён на `@ypolosov/sdlc-state-rag` (новый репозиторий, новый npm-пакет).
   Существующим target'ам нужно: переустановить плагин и выполнить `bash scripts/migrate-essence-to-state-rag.sh`.
2. **ENV-переменная `ESSENCE_ALPHA_VALIDATE_CMD` переименована в `SDLC_STATE_RAG_VALIDATE_CMD`.**
   Старое имя даёт deprecation-warning одну версию (Wave 6 удалит совместимость).
3. **`alphas.md` остаётся PR-видимым snapshot, но source of truth — БД sdlc-state-rag.**
   `sdlc-alpha-tracker` дёргает только `mcp__sdlc_state_rag__state_*` tools.

## Новые возможности (Wave 4)

- **7 категорий инструментов** в `catalogs/tool-categories.md` (issue-tracker, knowledge-base, vcs, chat, observability, cd-platform, test-management).
- **9 абстрактных ролей** (добавлена `security-engineer`); поля `tool_categories` и `agent_kind` (human/ai/both).
- **`sdlc-context-aggregator`** — фасад консолидации RAG + state-reader + targeted MCP с провенансом каждого фрагмента.
- **`sdlc-tool-router`** — обязательный `AskUserQuestion` ДО write-операций через MCP.
- **`/sdlc-tools list|bind|test|unbind`** — CLI для биндингов категорий → MCP в целевом.
- **`sdlc-integrations`** skill — фаза подключения внешних инструментов SDLC.
- **`target-roles.meta.md`** — `<target>/.claude/sdlc/role-extensions.md` для конкретных ролей с `extends: <abstract>`.
- **3 новых принципа:** 18 (категории+роли agnostic), 19 (контекст как услуга), 19a (опрос MCP всегда до RAG).
- **4 новых ADR:** ADR-010, ADR-013, ADR-015, ADR-016.

## Новые возможности (Wave 5)

- **`@ypolosov/sdlc-state-rag` v0.1.0** — новый MCP-сервер: 5 доменов в одной БД (alphas + RAG + decisions + audit + sync). PostgreSQL+pgvector / pglite v0.4 embedded. 20 MCP-tools включая 3 композитных для атомарных транзакций. SERIALIZABLE + SELECT FOR UPDATE для concurrent-safe альф.
- **`rag-config.meta.md`** — конфиг RAG по уровню SME (pet → C, mid → cron, enterprise → cron+webhooks).
- **`/sdlc-rag reindex|query|stats|purge`** — CLI для управления RAG-индексом.
- **`webhooks.meta.md`** — реестр webhook-эндпоинтов для enterprise (HMAC required).
- **`.sdlc-worker/` Mastra runtime** — пример enterprise-цели в `examples/wave-5-enterprise/`.
- **2 новых принципа:** 20 (worker по SME, RDB-backend), 21 (per-target БД, concurrent-safe).
- **3 новых ADR:** ADR-011 (sdlc-state-rag), ADR-012 (worker pattern), ADR-014 (enterprise dogfooding); ADR-009 → Deprecated.
- **PR-H:** `scripts/migrate-essence-to-state-rag.sh` — разовая утилита миграции dogfooding.

## Закрытые epics

- **#3** — runtime vs dev-time MCP разграничены (`tool-bindings.md` ↔ `.mcp.json`).
- **#6** — role-extensions фиксируют активную роль на фазе.
- **#7** — multi-agent coexistence через aggregator + RDB-backend.
- **#13** — `/sdlc-tools test` верифицирует стек на onboarding.
- **#20** — enterprise webhook + Mastra-runtime.
- **#21** — `agent_kind: ai` для delivery-lead.

## Итоговые числа

- Skills: 12 → 13.
- Commands: 8 → 10.
- Agents: 5 → 7.
- Catalogs: 4 → 5.
- Meta-templates: 11 → 16.
- Scripts: 13 → 16.
- ADRs: 9 → 14 (1 Deprecated).
- Принципы: 18 → 22.
- Tests: unit 6 → 11 файлов / 31 → 80 кейсов; integration 0 → 2 файла / 0 → 40 кейсов.

## Внешние зависимости

- **Установить:** `npm install -g @ypolosov/sdlc-state-rag` (или `npx -y @ypolosov/sdlc-state-rag`).
- **Удалить:** `@ypolosov/essence-alpha-mcp` больше не требуется (Deprecated).

## Команды миграции для существующих target'ов

```bash
bash scripts/migrate-essence-to-state-rag.sh --dry-run
bash scripts/migrate-essence-to-state-rag.sh --exec
bash scripts/bench-hooks.sh
```

## PR в этом релизе

#36 (CI fix), #29 PR-A, #37 PR-B, #38 PR-C, #39 PR-D, #40 PR-E1, #41 PR-F (план), #42 PR-G (план), PR-H (план).
