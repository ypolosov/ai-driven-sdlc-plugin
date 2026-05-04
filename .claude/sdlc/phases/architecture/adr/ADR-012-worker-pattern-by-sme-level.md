---
name: ADR-012
type: adr
title: Worker pattern по уровню SME, LLM-loop только HOOTL-override
status: Accepted
date: 2026-05-05
nfr: [reliability, performance, maintainability]
principles: [6, 20]
---

# ADR-012: Worker pattern по уровню SME, LLM-loop только HOOTL-override

## Контекст

Wave 5 sdlc-state-rag индексирует артефакты целевого проекта в RAG.
Источники индексации: filesystem + MCP-серверы (issue-tracker, vcs, knowledge-base).
Worker должен быть детерминированным (принцип 6).
Уровень SME (pet/mid/enterprise) задаёт допустимую сложность операционной модели.

## Решение

Worker-pattern фиксируется в `rag-config.md` целевого по правилу:

| Уровень | Pattern | Тип worker'а |
|---|---|---|
| pet | `null` | нет worker'а; on-demand RAG-запросы |
| mid | `cron` | детерминированный workflow по расписанию |
| enterprise | `cron+webhooks` | cron как baseline + webhook'и для real-time |

LLM-loop (subagent опрашивает MCP в цикле) запрещён как worker.
Допускается только HOOTL-override через `profile.md` для специальных случаев.
Worker реализуется через детерминированный runner (Mastra, GitHub Actions, cron).

`scripts/check-rag-config.sh` валидирует соответствие `worker.kind` ↔ SME-уровень.
Несоответствие (например, pet с cron) — блокирующая ошибка.

## Альтернативы

- A1. Hybrid: subagent + loop как worker.
  Отказ: LLM недетерминирован; нарушает принцип 6; стоимость растёт.
- A2. Pure per-tool MCP без worker'а на всех уровнях.
  Отказ: enterprise-проектам нужны кэш и webhook'и; rate-limit риски.
- A3. Один универсальный pattern для всех уровней.
  Отказ: pet — переусложнение; enterprise — недостаточно.

## Последствия

- Принцип 20 формализован: worker-pattern → SME-уровень.
- `meta-templates/rag-config.meta.md` содержит правила worker'ов.
- `scripts/check-rag-config.sh` валидирует соответствие.
- Pet-проекты — без worker'ов (минимум операционных усилий).
- Mid — cron daily/hourly через `sdlc-state-rag sync`.
- Enterprise — cron + webhook endpoints (PR-G).
- LLM-loop subagent'ы оставлены только для HOOTL-сценариев пользователя.
- README inventory: Scripts 15→16; Meta-templates 14→15; Commands 9→10.

## Связь

- Реализует принципы 6 (детерминизм), 20 (worker по SME).
- Использует ADR-011 (sdlc-state-rag).
- Готовит ADR-014 (enterprise dogfooding) в PR-G.
- Конфиг — `rag-config.meta.md` секция `worker`.
