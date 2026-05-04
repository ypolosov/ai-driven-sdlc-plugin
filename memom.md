---
name: memom
type: plugin-evolution-journal
scope: журнал эволюции принципов плагина (принцип 15)
source_of_truth_for_principles: CLAUDE.md
---

# Memom плагина `ai-driven-sdlc`

Журнал изменений принципов плагина как системы.
**Источник истины о текущих принципах — `CLAUDE.md`**.
Этот файл — только история; не читается hooks для решения о текущем состоянии.

## Формат записи

Одна секция `##` на каждое изменение.

```markdown
## <YYYY-MM-DD> — <краткий заголовок>
- principle: <номер, например 17>
- action: add | modify | remove
- before: <предыдущая формулировка или null>
- after: <новая формулировка или null>
- motive: <причина изменения>
- consequences: <что меняется в артефактах, скриптах, командах>
- related_commits: [<хеши>] или [PR #N, PR #M] до merge
```

## Журнал

## 2026-04-17 — Волна 2: введены принципы 14–17
- principle: 14, 15, 16, 17
- action: add
- before: null
- after:
  - 14: Конвенция пути артефактов `<target>/.claude/sdlc/`; bootstrap-режимы.
  - 15: `CLAUDE.md` — источник истины; `memom.md` — журнал; hook блокирует изменение принципа без записи.
  - 16: README плагина как живой артефакт со сверкой имён (не только счётчиков).
  - 17: README per система внимания в целевом проекте; kind materialized/logical; флаги --transient и --retire.
- motive: завершение плана MVP; переход от Волны 1 (каркас) к Волне 2 (dogfooding-зрелость).
- consequences:
  - Добавлены мета-шаблон `system-readme.meta.md` и 3 скрипта.
  - Расширены `system-context.meta.md`, `plugin-config.meta.md`.
  - Расширена команда `/sdlc-focus` флагами.
  - Добавлена таблица привязки принципов 1–17 + 4a к главам Левенчука.
- related_commits: []

## 2026-04-19 — Принцип 1: обязательность `AskUserQuestion` в skills
- principle: 1
- action: modify
- before: «В HITL показывает пользователю и ждёт выбора» (описательно, без предписания инструмента).
- after: Skills фаз и bootstrap **обязаны** вызвать `AskUserQuestion` до записи артефактов; Auto mode среды ≠ HOOTL; пропуск только через `/sdlc-autonomy --task hootl`.
- motive: в dogfooding-сессии плагин автогенерировал артефакты без опроса пользователя; принцип 1 интерпретировался LLM как «можно угадать».
- consequences:
  - Добавлен «Обязательный интерактивный опрос» в 7 skills фаз, bootstrap и method-engineering.
  - Обновлён агент `sdlc-method-engineer`: первое действие — `AskUserQuestion`.
  - Обновлены `/sdlc-phase` и `/sdlc-init` с разделом «Интерактивность».
  - В «Протоколах инстанцирования» шаг 0 — опрос пользователя.
- related_commits: []

## 2026-05-01 — Принцип 13: детерминированный backend через essence-alpha-mcp
- principle: 13
- action: modify
- before: «Единственный источник истины о состоянии альф — sdlc-alpha-tracker; другие агенты обращаются к трекеру, не читают alphas.md напрямую» (без указания backend трекера).
- after: дополнено: «Авторитативный backend трекера — `@ypolosov/essence-alpha-mcp` (см. ADR-009). Markdown `alphas.md` — PR-видимый snapshot; журнал переходов живёт в БД».
- motive: ADR-009 ввёл MCP-сервер как формальную state machine OMG Essence; markdown остался как snapshot. Принцип 13 не отражал смену backend.
- consequences:
  - Уточнена формулировка принципа 13 в `CLAUDE.md`.
  - `agents/sdlc-alpha-tracker.md` использует MCP-tools; markdown пишется атомарно.
  - `meta-templates/alpha-state.meta.md` поддерживает оба режима journal/snapshot.
  - PostToolUse hook `check-alpha-consistency.sh` валидирует БД при записи snapshot.
  - `scripts/seed-essence-alpha.sh` bootstrap-ит БД для существующих проектов.
- related_commits: [PR #22, PR #23]

## 2026-05-05 — Волна 4: введён принцип 18 (категории и абстрактные роли)
- principle: 18
- action: add
- before: null
- after: Плагин оперирует 7 категориями инструментов и 9 абстрактными ролями. Связи «категория → MCP» и «абстрактная роль → конкретная роль» живут в целевом. Hooks и агенты не упоминают конкретные продукты или должности.
- motive: enterprise-проекты содержат 9+ конкретных ролей (BO, BD, FD, QE, CR, CA, RM, UX-UI, SE) и многократно больше инструментов. Плагин должен оставаться agnostic; конкретика — в целевом.
- consequences:
  - Добавлены `catalogs/tool-categories.md` (PR-A), `meta-templates/target-roles.meta.md` (PR-B), `meta-templates/tool-binding.meta.md` (PR-C).
  - Добавлен `agents/sdlc-tool-router.md` (PR-C) и `agents/sdlc-context-aggregator.md` (PR-D).
  - Расширены `catalogs/roles.md` (поля `tool_categories`, `agent_kind`) и `meta-templates/plugin-config.meta.md` (секции `tool_bindings`, `rag_ref`).
  - Добавлены команда `/sdlc-tools` и skill `sdlc-integrations`.
  - ADR-013, ADR-015, ADR-016, ADR-010.
- related_commits: [PR #29, PR #30, PR #31]

## 2026-05-05 — Волна 4: введён принцип 19 (контекст как услуга агента)
- principle: 19
- action: add
- before: null
- after: Skills получают контекст только через `sdlc-context-aggregator`. Агрегатор соединяет RAG + state-reader + targeted MCP с провенансом каждого фрагмента. При конфликте провенансов — обязательный AskUserQuestion (HITL/HOTL) и запись альтернатив в `decisions.md` (HOOTL).
- motive: skills в multi-agent сценариях получают данные из 3+ источников; без единого фасада неизбежны дубли логики и потеря провенанса.
- consequences:
  - `agents/sdlc-context-aggregator.md` стал единственным фасадом.
  - Запрет skills вызывать MCP-серверы напрямую (через router агрегатор).
  - Каждый фрагмент в ответе несёт `provenance` (source, fetched_at, intent).
  - Конфликты явно отображены в поле `conflicts`.
- related_commits: [PR #32]

## 2026-05-05 — Волна 4: введён принцип 19a (опрос инструментов до RAG)
- principle: 19a
- action: add
- before: null
- after: При `rag.enabled=false` `sdlc-context-aggregator` ОБЯЗАН опросить актуальные MCP/API/CLI всех `tool-bindings`, релевантных intent'у. Запрещено отвечать без провенанса фрагментов. Запрещено полагаться на устаревший snapshot из `.claude/sdlc/`. Aggregator не читает `alphas.md` напрямую — только через `sdlc-alpha-tracker` (соблюдает принцип 13).
- motive: до Wave 5 RAG отсутствует у большинства проектов (все pet, многие mid). Без принципа 19a aggregator может вернуть устаревшие данные из markdown-snapshot'ов.
- consequences:
  - `agents/sdlc-context-aggregator.md` содержит явный шаг «MCP-опрос обязателен при rag_enabled=false».
  - Integration-тест в фикстуре `mid-target/` проверяет MCP-обращение.
  - Конфликтует с принципом 13 (нет): альфы по-прежнему через `sdlc-alpha-tracker`.
- related_commits: [PR #32]

## 2026-05-05 — Волна 5: введён принцип 20 (worker по SME, единый RDB)
- principle: 20
- action: add
- before: null
- after: Pet — нет worker'а; mid — cron-workflow; enterprise — cron + webhooks. Горячие данные хранятся в единой БД `sdlc-state-rag` (PostgreSQL+pgvector) per-target. Markdown — только PR-видимый snapshot. Pet — embedded pglite v0.4; mid — shared PostgreSQL; enterprise — managed cloud.
- motive: SQLite single-writer не подходит для team-сценариев. Векторный поиск pgvector нужен для RAG-домена. Worker-pattern должен соответствовать масштабу (pet=ничего, enterprise=cron+webhooks).
- consequences:
  - Добавлен `meta-templates/sdlc-state-rag-contract.meta.md` (5 доменов).
  - Расширен `plugin-config.meta.md` секцией `workers`.
  - ADR-011 (sdlc-state-rag) supersedes ADR-009 (essence-alpha-mcp).
  - Готовится ADR-012 (worker pattern) в PR-F.
- related_commits: [PR #33]

## 2026-05-05 — Волна 5: введён принцип 21 (per-target БД, concurrent-safe)
- principle: 21
- action: add
- before: null
- after: Каждая целевая система имеет свой instance `sdlc-state-rag`. Connection-string в `<target>/.env`. SQLite запрещён для team-проектов. Mutating операции через PostgreSQL транзакции. Альфы продвигаются с row-level lock. Композитные tools обеспечивают атомарность.
- motive: команды работают над проектом параллельно; нужна concurrent-safe state machine. MCP stateless — для атомарности нужны композитные tools, не cross-call transaction_token.
- consequences:
  - `.mcp.json` плагина: `essence-alpha` удалён, добавлен `sdlc-state-rag`.
  - `agents/sdlc-alpha-tracker.md` использует `state_*` tools вместо `essence_*`.
  - Композитные tools `state_advance_with_decision`, `state_regress_with_audit`, `rag_upsert_with_sync_event`.
  - `SERIALIZABLE` для критических переходов; `SELECT … FOR UPDATE` на альфах.
  - Bats-фикстуры используют `SDLC_STATE_RAG_VALIDATE_CMD` (rename из `ESSENCE_ALPHA_VALIDATE_CMD`).
- related_commits: [PR #33]

## 2026-05-05 — Принцип 13: backend переключён на sdlc-state-rag
- principle: 13
- action: modify
- before: «Авторитативный backend трекера — `@ypolosov/essence-alpha-mcp` (см. ADR-009). Markdown `alphas.md` — PR-видимый snapshot; журнал переходов живёт в БД».
- after: «Авторитативный backend трекера — `@ypolosov/sdlc-state-rag` (см. ADR-011). OMG Essence 1.2 state machine реализована внутри сервера (TypeScript, не внешний backend). Markdown `alphas.md` — PR-видимый snapshot; журнал переходов и RAG-домены живут в БД».
- motive: Wave 5 объединяет 5 доменов в одной БД per-target. Деаутентификация двух MCP-серверов. ADR-009 → Deprecated.
- consequences:
  - Принцип 13 формулируется через `sdlc-state-rag`, не `essence-alpha-mcp`.
  - `.mcp.json` плагина обновлён.
  - `agents/sdlc-alpha-tracker.md` использует новые tools.
  - ADR-009 → Deprecated (`superseded_by: ADR-011`).
- related_commits: [PR #33]

## Правила ведения

- Запись создаётся **до** или **вместе** с изменением `CLAUDE.md`.
- Hook `check-memom-consistency.sh` блокирует коммит, где изменён `CLAUDE.md` без новой записи.
- Откат принципа — новая запись с `action: remove` или `action: modify`.
- `memom.md` не источник истины; он о прошлом, не о настоящем.
