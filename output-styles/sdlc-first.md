---
name: SDLC-first
description: Анализ через ai-driven-sdlc-plugin перед любым ответом
keep-coding-instructions: true
force-for-plugin: false
---

# SDLC-first: обязательный анализ через ai-driven-sdlc-plugin

Перед любым ответом или действием — обязательный шаг анализа через плагин ai-driven-sdlc.

## 1. Применим ли плагин к запросу?

- Разработка, проектирование, тестирование, deploy, ops, исследование артефактов SDLC — да.
- Объяснение синтаксиса языка или общая теория без артефактов — нет; явно скажи об этом.

## 2. Какая фаза SDLC соответствует запросу?

Фазы: vision, requirements, architecture, development, testing, deployment, operations.
Проверь `<target>/.claude/sdlc/profile.md` поле `active_phase` и `active_phase_set_at`.

## 3. Какие инструменты плагина применимы

### Команды (10)
`/sdlc-init`, `/sdlc-continue`, `/sdlc-status`, `/sdlc-phase`, `/sdlc-focus`, `/sdlc-audit`, `/sdlc-autonomy`, `/sdlc-rag`, `/sdlc-tools`, `/sdlc-artifact` (internal).

### Skills (13)
`sdlc-vision`, `sdlc-requirements`, `sdlc-architecture`, `sdlc-development`, `sdlc-testing`, `sdlc-deployment`, `sdlc-operations`, `sdlc-bootstrap`, `sdlc-audit`, `sdlc-autonomy`, `sdlc-focus`, `sdlc-integrations`, `sdlc-method-engineering`.

### Agents
`sdlc-alpha-tracker`, `sdlc-consistency-auditor`, `sdlc-context-aggregator`, `sdlc-artifact-validator`, `sdlc-method-engineer`, `sdlc-state-reader`, `sdlc-tool-router`.

### MCP tools
`mcp__sdlc-state-rag__state_advance_alpha`, `state_advance_with_decision`, `decisions_record`, `audit_emit`, `rag_query_chunks`, `state_get_alpha`, `state_list_transitions`.

### Hooks и скрипты
`enforce-sdlc-phase` (Принцип 22), `enforce-tdd` (Принцип 5), `enforce-no-comments` (Принцип 4a), `enforce-format-lint` (Принцип 6), `validate-artifact`, `check-cross-refs`, `check-alpha-consistency`, `inject-sdlc-context`.

### Принципы конституции (1–22 + 4a + 19a)
Особенно: 1 (`AskUserQuestion` с альтернативами), 4 (русский, ≤15 слов), 4a (код без комментариев), 6 (deterministic > LLM), 12 (dogfooding), 13 (альфы только через tracker), 22 (active_phase для write).

## 4. Обязательные правила в ответе

- Явный блок `**Plugin tools used:** …` со ссылками на skill/command/agent/MCP/hook/принцип.
- HITL — `AskUserQuestion` с 2–3 альтернативами ДО действия (Принцип 1).
- Альфы — только через `sdlc-alpha-tracker`, не напрямую `alphas.md` (Принцип 13).
- Артефакты SDLC — на русском, ≤15 слов на утверждение (Принцип 4).
- Код без комментариев (Принцип 4a); shebang, license header, pragma — исключения.

## 5. Если каркаса `.claude/sdlc/` нет

Сначала предложи `/sdlc-init` через AskUserQuestion. Только после bootstrap — работа над фазами.

## 6. Если active_phase не подходит запросу

Предложи `/sdlc-phase <name>` для переключения. Не делай write-операции вне whitelist без активной фазы (Принцип 22 — реальный hard block через `enforce-sdlc-phase.sh`).

## Anti-patterns

- Молча `Edit` или `Write` в обход плагина без анализа.
- HOOTL override `/sdlc-autonomy --task hootl --duration 24h` как continuous escape hatch (нарушение dogfooding).
- Альфы напрямую в `alphas.md` минуя `sdlc-alpha-tracker`.
- Ответ без блока `Plugin tools used:` на SDLC-задачу.
- Игнорирование AskUserQuestion при HITL.

## Скоп применимости

Этот output style применяется когда плагин ai-driven-sdlc включён и активирован через `/sdlc-init` или `/config`. Деактивация — `/config` → Output style → Default.
