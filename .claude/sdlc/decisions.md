---
name: decisions
type: decision-journal
project: ai-driven-sdlc-plugin
updated: 2026-04-19
---

# Журнал альтернатив и решений

Принцип 1: альтернативы порождаются и фиксируются; выбор делает пользователь.

## 2026-04-19 14:40 — bootstrap SDLC-каркаса плагина

- context: инициализация dogfooding плагина как целевой системы.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Уровень pet — минимум церемоний, соло-разработка, низкие риски.
  2. Уровень mid — командный процесс с частичной автоматизацией.
  3. Уровень enterprise — строгая трассируемость и compliance.
- choice: 1
- rationale: соло-разработка, риски низкие, pet соответствует текущему состоянию плагина.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/alphas.md`

## 2026-04-19 14:41 — выбор активной роли

- context: определение роли пользователя в bootstrap.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. method-engineer — сквозная роль инженера методов, владеет Way of Working.
  2. architect — значимые структурные решения плагина.
  3. product-owner — ценность и приоритеты фич плагина.
  4. systems-thinker — границы системы, надсистема, подсистемы.
- choice: 1
- rationale: dogfooding методологического каркаса — естественная работа инженера методов.
- traces_to:
  - `.claude/sdlc/roles.md`
  - `.claude/sdlc/profile.md`

## 2026-04-19 14:42 — выбор целевой системы

- context: определение границы внимания на старте.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Сам плагин ai-driven-sdlc — широкая граница, весь репозиторий.
  2. Только Волна 2 (принципы 14-17) — узкий фокус на итерации.
  3. Только catalogs — ещё уже, на подсистему каталогов.
- choice: 1
- rationale: dogfooding предполагает охват всего методологического каркаса.
- traces_to:
  - `.claude/sdlc/system-context.md`
  - `README.sdlc.md`

## 2026-04-19 14:43 — выбор state-артефакта

- context: где хранить состояние работ (принцип 9).
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Плоский файл `.claude/sdlc/state.md` — просто, без внешних зависимостей.
  2. Каталог `.claude/sdlc/state/` — файл на задачу, удобно при росте.
  3. GitHub Issues через MCP — внешний трекер, интеграция с репо.
- choice: 3
- rationale: MCP github уже подключён, репо публичный, Issues дают трассировку.
- traces_to:
  - `.claude/sdlc/plugin-config.md#state_artifact`
