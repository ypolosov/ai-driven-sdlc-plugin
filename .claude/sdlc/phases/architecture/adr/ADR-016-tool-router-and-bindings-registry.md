---
name: ADR-016
type: adr
title: Маршрутизатор инструментов и реестр привязок tool-bindings
status: Accepted
date: 2026-05-05
nfr: [security, maintainability, extensibility]
principles: [1, 3, 13, 18]
---

# ADR-016: Маршрутизатор инструментов и реестр привязок `tool-bindings`

## Контекст

Целевые проекты используют разные SDLC-инструменты в каждой категории.
Принцип 3 запрещает имена продуктов в плагине; категории определены в ADR-013.
Skills и агенты должны выполнять read/write операции через MCP, не зная имён продуктов.
Принцип 1 требует AskUserQuestion ДО любого write-действия в HITL/HOTL.

## Решение

Введён новый агент `sdlc-tool-router` как фасад поверх MCP-серверов целевого.
Введён новый мета-шаблон `tool-binding.meta.md` для `tool-bindings.md` целевого.
Введён новый skill `sdlc-integrations` для подключения внешних инструментов.
Введена команда `/sdlc-tools list|bind|test|unbind` как пользовательская точка входа.
Скрипт `check-tool-binding.sh` валидирует категории привязок против каталога.
Скрипт `detect-credentials.sh` проверяет `.env` и обязательные `env_keys`.

`sdlc-tool-router` обязан вызвать `AskUserQuestion` ДО любой write-операции.
В HOOTL альтернативы пишутся в `decisions.md`, исполнение продолжается.
Каждый ответ агента содержит блок `provenance` (source, fetched_at, intent).
Запрещено читать `alphas.md` напрямую; альфы — только через `sdlc-alpha-tracker`.

## Альтернативы

- A1. Каждый skill сам вызывает MCP-серверы напрямую.
  Отказ: дублирует логику; протекает имя продукта в код skills.
- A2. Использовать единый `.mcp.json` без mapping-файла в целевом.
  Отказ: имя сервера в `.mcp.json` теряет смысловую категорию.
- A3. Делать AskUserQuestion внутри MCP-сервера.
  Отказ: MCP-сервер не имеет доступа к UI Claude Code; не реализуемо.

## Последствия

- Закрытие epic #3 (dev-time vs runtime MCP): `tool-bindings.md` runtime, `.mcp.json` dev-time.
- Закрытие epic #13 (верификация стека): `/sdlc-tools test` выполняет ping и detect-credentials.
- Каркас для PR-D: aggregator поверх tool-router'а с провенансом.
- README inventory: Skills 12→13; Commands 8→9; Agents 5→6; Scripts 13→15; Meta-templates 12→13.
- 60 bats-кейсов всего после PR-C (рост 51→60 за счёт `detect-credentials.bats` и расширения `check-tool-binding.bats`).
- `sdlc-tool-router` использует Read/Glob/Grep/AskUserQuestion; не имеет MCP-tools в frontmatter.
- Конкретные MCP-tools резолвятся динамически по `mcp_server` из привязки.

## Связь

- Реализует принципы 1 (AskUserQuestion), 3 (агностический плагин), 18 (категории и роли).
- Подкрепляет принцип 13 (запрет обхода `sdlc-alpha-tracker`).
- Использует ADR-013 (tool-categories как агностический интерфейс).
- Готовит почву для ADR-010 (PR-D, aggregator-фасад).
