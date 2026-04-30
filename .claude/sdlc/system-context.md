---
name: system-context
type: attention-context
project: ai-driven-sdlc-plugin
current_focus: essence-alpha-mcp
updated: 2026-05-01
---

# Реестр систем внимания

Система внимания — выбранный пользователем уровень системной иерархии.
Относительно неё определяются надсистема, подсистемы, окружение, система создания.
Источник — Левенчук Том 2 гл. 7 и гл. 9.

## Таблица систем внимания

| slug | role_vs_target | kind | last_focused_at | focus_count |
|---|---|---|---|---|
| ai-driven-sdlc-plugin | target | materialized | 2026-04-19 | 2 |
| hooks | subsystem | logical | 2026-04-19 | 1 |
| essence-alpha-mcp | in_environment | logical | 2026-04-30 | 1 |

## Пояснения

`current_focus=essence-alpha-mcp` — внимание на внешней зависимости (in_environment).
Целевая система остаётся `ai-driven-sdlc-plugin` (dogfooding, принцип 12).
`role_vs_target` указывается относительно корня плагина для каждой записи.
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

### 2026-04-19 — возврат внимания на ai-driven-sdlc-plugin

- focus: `ai-driven-sdlc-plugin` (kind=materialized).
- Граница: корень репозитория.
- Описание системы: `README.sdlc.md` в корне проекта.
- Мотив: подготовка к `/sdlc-phase development` для всего плагина.

### 2026-04-30 — фокус на essence-alpha-mcp (in_environment)

- focus: `essence-alpha-mcp` (kind=logical).
- Граница: npm-пакет `@ypolosov/essence-alpha-mcp`.
- Описание системы: `.claude/sdlc/external-systems/essence-alpha-mcp.md`.
- Мотив: bootstrap БД, эксплуатация, релиз v0.3.0 (см. ADR-009).

### 2026-05-01 — фоновый фокус на hooks (Стадия B)

- focus остаётся `essence-alpha-mcp`; `hooks` затронут косвенно.
- Расширение bench-hooks 5→8 потребовало доступа к подсистеме `hooks`.
- Описание `external-systems/hooks.md` уже существует с Волны 2.
- focus_count для hooks без инкремента (Стадия B без отдельного `/sdlc-focus`).
