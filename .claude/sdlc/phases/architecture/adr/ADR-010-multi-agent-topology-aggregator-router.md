---
name: ADR-010
type: adr
title: Multi-agent topology — aggregator-фасад поверх tool-router'а
status: Accepted
date: 2026-05-05
nfr: [reliability, maintainability, security]
principles: [1, 13, 18, 19, 19a]
---

# ADR-010: Multi-agent topology — aggregator-фасад поверх tool-router'а

## Контекст

Wave 4 multi-agent extension вводит коллаборацию `human` + `ai` ролей.
Skills не должны знать имена MCP-серверов или продуктов (принцип 3).
Skills не должны читать `alphas.md` напрямую (принцип 13).
До RAG (Wave 5) skills должны опрашивать MCP-серверы вживую (принцип 19a).
При конфликте провенансов нужна обязательная фиксация альтернатив (принцип 1).

## Решение

Введён агент `sdlc-context-aggregator` как единственная точка входа для skills.
Aggregator оркестрирует трёх внутренних поставщиков:
- `sdlc-state-reader` — фокус, профиль, роли (читает `system-context.md`, `roles.md`).
- `sdlc-alpha-tracker` — состояния альф (единственный путь к альфам).
- `sdlc-tool-router` — MCP-запросы по категориям (с провенансом).

При наличии RAG (Wave 5) aggregator делает RAG-запросы перед опросом MCP.
При `rag_enabled=false` aggregator ОБЯЗАН опрашивать MCP по `tool-bindings`.
При конфликте провенансов aggregator вызывает `AskUserQuestion` (HITL/HOTL).
В HOOTL aggregator пишет альтернативы в `decisions.md` и продолжает.

## Альтернативы

- A1. Skills вызывают `sdlc-tool-router` напрямую (без агрегатора).
  Отказ: дублирует логику конфликтов и провенанса в каждом skill.
- A2. Один монолитный агент, объединяющий router и state-reader.
  Отказ: нарушает single-responsibility; сложнее тестировать.
- A3. Aggregator пишет в state-артефакты сам.
  Отказ: aggregator только читает; запись — через skills/команды.

## Последствия

- Закрытие epic #7 (параллельная командная работа): aggregator консолидирует контекст.
- Подготовка к epic #10 (evolution-фаза): RAG-индексация артефактов фаз.
- Skills не знают имён MCP-серверов; только slugs категорий и intent'ов.
- Каждый ответ aggregator несёт `provenance`; конфликты явно отображены.
- Запрет обхода `sdlc-alpha-tracker` валидируется integration-тестом.
- Принцип 19a фиксируется в коде агента: при `rag_enabled=false` MCP-опрос обязателен.
- README inventory: Agents 6→7 после PR-D.
- Тестируется через фикстуру `tests/fixture/mid-target/` с mock-MCP.

## Связь

- Реализует принципы 1, 13, 18, 19, 19a.
- Использует ADR-013 (tool-categories), ADR-016 (tool-router).
- Готовит ADR-011 (sdlc-state-rag) и ADR-012 (worker pattern).
- Закрывает epic #7; продвигает epic #10.
