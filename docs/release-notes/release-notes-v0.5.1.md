# v0.5.1 — hotfix MCP `sdlc-state-rag` Failed to connect

Дата: 2026-05-05.

## Что исправлено

После релиза v0.5.0 MCP-сервер `sdlc-state-rag` показывался в Claude Code как `✗ Failed to connect`. Причина — `npx -y @ypolosov/sdlc-state-rag` cold-fetch (108 deps включая pglite/pg/pgvector) превышал таймаут health-check Claude Code.

Та же проблема и аналогичный фикс был у `essence-alpha-mcp` в v0.3.1.

## Изменения

- `.mcp.json`: `command: "sdlc-state-rag"`, `args: []` (прямой бинарь без npx).
- README: добавлено требование `npm install -g @ypolosov/sdlc-state-rag` перед использованием плагина.
- `tests/integration/sdlc-state-rag-contract.bats`: новый кейс «`.mcp.json` uses direct binary not npx» (21-й).

## ⚠️ ACTION REQUIRED

**Установите пакет глобально перед перезагрузкой Claude Code:**

```bash
npm install -g @ypolosov/sdlc-state-rag
```

Затем перезагрузите Claude Code или выполните `/plugin reload ai-driven-sdlc`.

## Verification

После перезагрузки в новой сессии:
- `claude mcp list` должен показать `sdlc-state-rag: ✓ Connected`.
- Tools `mcp__sdlc_state_rag__state_*` доступны агентам.

## Связанные релизы

- v0.5.0 — принцип 22 + enforce-sdlc-phase hook.
- `@ypolosov/sdlc-state-rag@0.1.1` — backend трекера альф.
