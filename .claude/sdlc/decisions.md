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

## 2026-04-19 15:00 — SME фазы vision (уровень)

- context: выбор уровня SME для фазы vision в dogfooding плагина.
- autonomy_mode: hitl
- phase: vision
- role: method-engineer
- alternatives:
  1. pet — одностраничное описание проблемы и цели без формализации.
  2. mid — структурированная модель ценности со стейкхолдерами и метрикой.
  3. enterprise — формальное моделирование мотивации и потока ценности.
- choice: 1
- rationale: соло-разработка, риски низкие, согласуется с уровнем проекта.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/vision/vision.md`

## 2026-04-19 15:01 — SME фазы vision (инструмент)

- context: выбор инструмента при уровне pet для фазы vision.
- autonomy_mode: hitl
- phase: vision
- role: method-engineer
- alternatives:
  1. README-as-vision — корневой README несёт цель и проблему.
  2. Elevator Pitch — одно предложение проблемы, решения, отличия.
  3. Mission Statement — декларация миссии плагина.
- choice: 1
- rationale: согласуется с принципом 16; README плагина живой артефакт.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/vision/vision.md`

## 2026-04-19 15:02 — целевой бенефициар плагина

- context: определение основного получателя ценности плагина.
- autonomy_mode: hitl
- phase: vision
- role: method-engineer
- alternatives:
  1. AI-first соло-разработчики применяют Claude Code для SDLC-осмысленной работы.
  2. Команды с AI-агентами координируются через общий методологический каркас.
  3. Инженеры методов настраивают SDLC-метод под другие команды.
  4. Автор плагина как первый пользователь (dogfooding).
- choice: 1
- rationale: соло-разработчик — наиболее частый профиль Claude Code пользователя.
- traces_to:
  - `.claude/sdlc/phases/vision/vision.md` (секция 3.2)

## 2026-04-19 15:03 — формулировка проблемы

- context: ключевая проблема, которую решает плагин.
- autonomy_mode: hitl
- phase: vision
- role: method-engineer
- alternatives:
  1. AI-агенты генерируют код без осмысления системы и стейкхолдеров.
  2. Жёсткие SDLC-фреймворки не адаптируются под ситуацию проекта.
  3. Решения между альтернативами теряются в AI-чатах без фиксации.
- choice: 1
- rationale: это первичный симптом; пункты 2 и 3 усугубляют, но вторичны.
- traces_to:
  - `.claude/sdlc/phases/vision/vision.md` (секция 3.1)

## 2026-04-19 15:04 — карта альтернатив в нише

- context: какие решения уже существуют для выявленной проблемы.
- autonomy_mode: hitl
- phase: vision
- role: method-engineer
- alternatives:
  1. Ручные CLAUDE.md и slash-commands без методологического каркаса.
  2. Классические SDLC-фреймворки без AI-интеграции и ситуативности.
  3. AI-плагины узкого назначения без покрытия всего SDLC.
  4. Системное мышление как теория без инструментальной поддержки в AI-среде.
- choice: 1, 2, 3, 4
- rationale: все четыре альтернативы присутствуют, ни одна не покрывает задачу целиком.
- traces_to:
  - `.claude/sdlc/phases/vision/vision.md` (секция 3.5)

## 2026-04-19 15:05 — противоречия интересов стейкхолдеров

- context: фиксация конфликтов, которые разрешает плагин.
- autonomy_mode: hitl
- phase: vision
- role: method-engineer
- alternatives:
  1. Скорость против методичности — разрешается автономией HOTL/HOOTL.
  2. Автономия против контроля — default HITL, override по задаче.
  3. Простота против полноты — уровни SME по фазам независимо.
- choice: 1, 2, 3
- rationale: все три конфликта актуальны; плагин несёт механизмы для каждого.
- traces_to:
  - `.claude/sdlc/phases/vision/vision.md` (секция 3.7)
