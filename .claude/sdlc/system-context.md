---
name: system-context
type: attention-context
project: ai-driven-sdlc-plugin
current_focus: hooks
updated: 2026-04-19
---

# Реестр систем внимания

Система внимания — выбранный пользователем уровень системной иерархии.
Относительно неё определяются надсистема, подсистемы, окружение, система создания.
Источник — Левенчук Том 2 гл. 7 и гл. 9.

## Таблица систем внимания

| slug | role_vs_target | kind | last_focused_at | focus_count |
|---|---|---|---|---|
| ai-driven-sdlc-plugin | target | materialized | 2026-04-19 | 1 |
| hooks | subsystem | logical | 2026-04-19 | 1 |

## Пояснения

`current_focus=hooks` — внимание перенесено на подсистему hooks.
`role_vs_target` остаётся относительно корня проекта (ai-driven-sdlc-plugin=target, dogfooding, принцип 12).
Надсистему, подсистемы и окружение фиксируйте через `/sdlc-focus` по мере необходимости.

## Журнал фокусировок

### 2026-04-19 — bootstrap

- focus: `ai-driven-sdlc-plugin` (kind=materialized).
- Граница: корень репозитория ai-driven-sdlc-plugin.
- Описание системы: `README.sdlc.md` в корне проекта.

### 2026-04-19 — перенос внимания на hooks

- focus: `hooks` (kind=logical).
- Граница: `hooks/hooks.json` + `scripts/enforce-*.sh` + `scripts/check-*.sh`.
- Описание системы: `.claude/sdlc/external-systems/hooks.md`.
- Мотив: §8 architecture.md — подсистема заслуживает отдельного анализа.
