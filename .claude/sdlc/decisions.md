---
name: decisions
type: decision-journal
project: ai-driven-sdlc-plugin
updated: 2026-04-30
---


# Журнал альтернатив и решений

Принцип 1: альтернативы порождаются и фиксируются; выбор делает пользователь.

## 2026-04-30 — следующий шаг по /sdlc-continue (после PR #22)

- context: PR #22 интеграции essence-alpha-mcp ждёт review/merge.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Ждать merge PR #22; новые изменения после merge.
  2. Wave 3 / operations — собирать feedback, продвигать Opportunity → Addressed.
  3. Wave 3 / development — расширение tdd_pairs на оставшиеся 6 скриптов.
  4. Wave 3 / memom-запись о принципе 13 после ADR-009.
- choice: 1
- rationale: параллельная ветка рискует конфликтами с PR #22.
- traces_to:
  - PR #22

## 2026-04-30 — следующий шаг по /sdlc-continue

- context: все 7 фаз инстанцированы; v0.2.0 релизнут; аудит >10 дней не запускался.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Запустить /sdlc-audit — сквозная проверка консистентности перед новой итерацией.
  2. Расширить TDD-покрытие скриптов — bats-тесты для оставшихся 7 скриптов.
  3. Запустить /sdlc-phase operations Wave 3 — обратная связь, продвижение Opportunity к Addressed.
- choice: 1
- rationale: аудит давно не запускался; быстрый низкорисковый шаг перед новой итерацией.
- traces_to:
  - `.claude/sdlc/audit.md`

## 2026-04-30 — интеграция essence-alpha-mcp

- context: трекер альф валидирует переходы недетерминированно из markdown.
- autonomy_mode: hitl
- phase: architecture
- role: method-engineer
- alternatives:
  1. Интегрировать MCP-сервер `@ypolosov/essence-alpha-mcp` плюс snapshot.
  2. Inline state machine на bash в скрипте плагина.
  3. Удалить alphas.md полностью; источник только MCP.
- choice: 1
- rationale: соответствует Принципу 6 (детерминизм); переиспользует опубликованный пакет.
- impl: ADR-009; `.mcp.json` запись `essence-alpha`; tracker tools расширены пятью MCP-tools.
- impl: snapshot-режим `alphas.md`; PostToolUse hook `check-alpha-consistency.sh` плюс bats-тесты.
- traces_to:
  - `.claude/sdlc/phases/architecture/adr/ADR-009-essence-alpha-mcp-integration.md`
  - `agents/sdlc-alpha-tracker.md`
  - `scripts/check-alpha-consistency.sh`
  - `tests/unit/check-alpha-consistency.bats`
  - `.mcp.json`

## 2026-04-30 — применение фиксов аудита после интеграции essence-alpha-mcp

- context: 5 находок аудита; 2 important, 3 note.
- autonomy_mode: hootl
- phase: cross-cutting
- role: method-engineer

### Находка #1 — architecture.md не отражает ADR-009

- alternatives:
  1. Минимальный фикс — таблица §5, NFR §4, frontmatter.updated.
  2. Полный фикс — также §3.1 строка про MCP, §6 traces_to.
  3. Откладывающий — known-gap, work-unit issue в Wave 3.
- choice: 2
- rationale: одна итерация интеграции должна быть полной по принципу 16.
- impl: §5 пополнен ADR-009; §4 расширен двумя NFR.
- impl: §3.1 строка про MCP-backend обновлена; frontmatter updated 2026-04-30.
- traces_to:
  - `.claude/sdlc/phases/architecture/architecture.md`

### Находка #3 — alphas.md отклоняется от alpha-state.meta.md

- alternatives:
  1. Расширить мета-шаблон под альтернативный type alpha-snapshot.
  2. Версионировать v2 со snapshot-секцией; v1 для проектов без MCP.
  3. Откатить frontmatter alphas.md к старой схеме (нарушает ADR-009).
- choice: 1
- rationale: расширение проще версионирования; v1 не нужен для dogfooding.
- impl: мета-шаблон описывает оба режима alpha-journal и alpha-snapshot.
- impl: добавлены frontmatter поля source_of_truth, snapshot_role, generated_after.
- traces_to:
  - `meta-templates/alpha-state.meta.md`

### Находки #2, #4, #5 — отложены в backlog Wave 3

- #2: запись в memom.md о расширении принципа 13 — кандидат на work-unit.
- #4: bench-hooks.sh покрывает 5 hooks из 6 — кандидат на work-unit.
- #5: traces_to смешивает уровни в dogfooding — note, конвенция формализуется позже.
- rationale: note-уровень не блокирует merge; backlog Wave 3 фиксирует наследие.

## 2026-04-30 — применение фиксов /sdlc-audit --apply

- context: 7 находок аудита (1 important, 6 note); каждая — 3 альтернативы фикса.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer

### Находка #1 — false positive парсера ≤15 слов

- alternatives:
  1. Улучшить regex в validate-artifact.sh (учесть буллеты и заголовки).
  2. Добавить точки в проблемные буллеты в deployment.md и development.md.
  3. Документировать known-limitation в plugin-config.md.
- choice: 1
- rationale: фикс корня устраняет класс багов; обходные пути не масштабируются.
- impl: добавлен failing-тест `numbered heading does not create false 15-word violation`. Парсер разделяет на параграфы, обрабатывает буллеты отдельно, фильтрует заголовки. Все 7 bats-тестов зелёные. Прогон по всем артефактам — 0 violations.
- traces_to:
  - `scripts/validate-artifact.sh`
  - `tests/unit/validate-artifact.bats`

### Находка #2 — пустая фикстура tests/fixture/minimal-target/

- alternatives:
  1. Заполнить фикстуру минимальными артефактами.
  2. Отложить до Волны 3 с записью в decisions.md.
  3. Генерировать через bootstrap-target.sh в bats setup().
- choice: 1
- rationale: при проверке выяснилось — фикстура УЖЕ содержит 8 артефактов. Аудитор не заглянул глубже `.claude/`. Находка — false positive.
- follow_up: создать work-unit issue на integration-тест, использующий фикстуру.

### Находка #3 — типизация подсистемы hooks

- alternatives:
  1. Обновить architecture.md §3.2 — пометить hooks как logical, переименовать секцию.
  2. Поднять hooks до materialized.
  3. Уточнить определение в meta-templates/system-readme.meta.md.
- choice: 1
- rationale: hooks физически живут в настройках Claude Code, не в репо плагина. Logical корректнее.
- impl: §3.2 переименована в «Структурные подсистемы»; добавлена колонка `kind`; hooks помечен `logical`.
- traces_to:
  - `.claude/sdlc/phases/architecture/architecture.md`

### Находка #4 — рассинхрон focus_count

- alternatives:
  1. Обновить README.sdlc.md focus_count до 2.
  2. Убрать focus_count из system-readme полностью.
  3. Добавить check-system-readmes.sh --sync-focus-count.
- choice: 1
- rationale: быстрый ручной фикс; автоматизация — отдельная итерация.
- impl: README.sdlc.md `focus_count: 2` в frontmatter и §2.
- follow_up: кандидат на work-unit — детерминированная синхронизация в `/sdlc-focus`.

### Находка #5 — operations.md 3 vs 4 templates

- alternatives:
  1. Привести operations.md к 4 templates (включить work-unit).
  2. Перенести work-unit в backlog (вне operations).
  3. Принять 4 templates с обоснованием в decisions.md.
- choice: 1
- rationale: реальность — 4 templates; артефакт должен это отражать.
- impl: §5 DoD обновлён на «4 issue templates: bug, feature, question, work-unit». Frontmatter updated 2026-04-30.
- traces_to:
  - `.claude/sdlc/phases/operations/operations.md`

### Находка #6 — alpha-evidence Software System

- alternatives:
  1. Обновить alphas.md на v0.2.1 без изменения состояния.
  2. Оставить 0.2.0 как момент перехода, добавить колонку last_release.
  3. Подтвердить через sdlc-alpha-tracker как patch-only.
- choice: 1
- rationale: прямое обновление evidence отражает текущий релиз без правки мета-шаблона.
- impl: alphas.md строка Software System → CHANGELOG.md#0.2.1 (release v0.2.1), 2026-04-21.
- traces_to:
  - `.claude/sdlc/alphas.md`

### Находка #7 — AC-05.2 vs async PostToolUse

- alternatives:
  1. Переформулировать AC-05.2 на «помечает в audit.md, блокирует merge через CI».
  2. Добавить PreToolUse-блокировку для критичных артефактов.
  3. Принять текущее через CI gate с трассой.
- choice: 1
- rationale: PostToolUse семантически не блокирует; формулировка приведена к реальности.
- impl: requirements.md AC-05.2 переформулирован. Заменено «блокирует противоречивые записи». Новые And: «расхождения помечаются в audit.md», «merge блокируется через CI gate».
- traces_to:
  - `.claude/sdlc/phases/requirements/requirements.md`

### Сводка

Применены 6 фиксов: #1, #3, #4, #5, #6, #7. Находка #2 закрыта как false positive аудитора. Финальный статус аудита — `pass`. Все артефакты SDLC прошли валидатор.

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

## 2026-04-19 15:10 — выбор следующей фазы после vision

- context: sdlc-continue после завершения vision, role method-engineer.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. `/sdlc-phase requirements` — декомпозиция vision в проверяемые единицы.
  2. `/sdlc-focus` на Волну 2 — сузить границу до принципов 14-17.
  3. `/sdlc-phase architecture` — сразу к структурным решениям, пропустив явные требования.
  4. `/sdlc-audit` — проверить консистентность артефактов до перехода.
- choice: 1
- rationale: логичный порядок, Requirements альфа ещё в начальном состоянии.
- traces_to:
  - `.claude/sdlc/phases/requirements/` (будет создан)

## 2026-04-19 15:20 — SME фазы requirements (уровень)

- context: выбор уровня SME для фазы requirements.
- autonomy_mode: hitl
- phase: requirements
- role: method-engineer
- alternatives:
  1. pet — свободный список желаемого без критериев приёмки.
  2. mid — декомпозиция на проверяемые единицы с AC и готовностью.
  3. enterprise — формальные контракты с трассируемостью до стейкхолдеров.
- choice: 2
- rationale: mid согласуется с TDD (принцип 5) и даёт опору для testing.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/requirements/requirements.md`

## 2026-04-19 15:21 — SME фазы requirements (инструмент)

- context: выбор инструмента при mid для фазы requirements.
- autonomy_mode: hitl
- phase: requirements
- role: method-engineer
- alternatives:
  1. User Stories + Gherkin AC — текстовый сценарий под AC, прямой путь в TDD.
  2. Impact Mapping — Why/Who/How/What; фокус на связи стейкхолдеров с фичами.
  3. Story Mapping — двумерная карта сценариев пользователя.
- choice: 1
- rationale: Gherkin AC напрямую ложится на второй TDD-слой LLM-аудитора.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/requirements/requirements.md`

## 2026-04-19 15:22 — место хранения backlog

- context: выбор единого или раздельного хранилища требований.
- autonomy_mode: hitl
- phase: requirements
- role: method-engineer
- alternatives:
  1. GitHub Issues репозитория с label `requirement` — единый трекер state и backlog.
  2. Плоский `requirements.md` в репо — проще версионировать, но state и backlog разойдутся.
  3. GitHub Projects — канбан-доска, ограниченная поддержка через MCP.
- choice: 1
- rationale: state-артефакт уже MCP/Issues; единый трекер упрощает трассировку.
- traces_to:
  - `.claude/sdlc/phases/requirements/requirements.md` (поле backlog_store)

## 2026-04-19 15:23 — volatility требований

- context: оценка скорости изменений требований для выбора режима.
- autonomy_mode: hitl
- phase: requirements
- role: method-engineer
- alternatives:
  1. Часто — dogfooding итерации уточняют требования после каждой демо.
  2. Редко — стабильное ядро с периферийными изменениями.
  3. Пока неясно — пересмотреть через квартал.
- choice: 1
- rationale: плагин в активной разработке; требования уточняются по ходу.
- traces_to:
  - `.claude/sdlc/phases/requirements/requirements.md` (поле volatility)

## 2026-04-19 16:10 — фикс issue-01 (traces_to vision.md)

- context: аудит нашёл пустой traces_to во frontmatter vision.md.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Заполнить traces_to в frontmatter ссылкой на requirements.md.
  2. Убрать упоминание traces_to из §4 vision.md.
  3. Добавить правило в sdlc-artifact-validator.
- choice: 1
- rationale: минимальная правка; frontmatter становится машинно-читаемым.
- traces_to:
  - `.claude/sdlc/phases/vision/vision.md`
  - `.claude/sdlc/audit.md#issue-01`

## 2026-04-19 16:11 — фикс issue-02 (таблица альф в README.sdlc.md)

- context: устаревшая таблица альф в README системы внимания.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Синхронизировать таблицу с alphas.md при каждом продвижении.
  2. Заменить таблицу ссылкой на alphas.md и sdlc-alpha-tracker.
  3. Добавить check в check-system-readmes.sh.
- choice: 2
- rationale: соответствует принципу 13 единого источника истины.
- traces_to:
  - `README.sdlc.md`
  - `.claude/sdlc/audit.md#issue-02`

## 2026-04-19 16:12 — фикс issue-03 (роль systems-thinker)

- context: роль systems-thinker упоминается в US-04 и US-07, но не в roles.md.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Добавить systems-thinker как неактивную в roles.md.
  2. Убрать атрибут Роль из US-04, US-07.
  3. Оставить как note до явного переключения роли.
- choice: 1
- rationale: устраняет висячий указатель; роль может быть активирована позже.
- traces_to:
  - `.claude/sdlc/roles.md`
  - `.claude/sdlc/audit.md#issue-03`

## 2026-04-19 16:13 — фикс issue-04 (хронология decisions.md)

- context: запись 15:10 была физически между 15:23 и 15:05.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Отсортировать записи по timestamp.
  2. Разрешить логическую группировку в decisions.meta.md.
  3. Оставить как note.
- choice: 1
- rationale: хронология критична для трассировки; минимальный риск.
- traces_to:
  - `.claude/sdlc/decisions.md`
  - `.claude/sdlc/audit.md#issue-04`

## 2026-04-19 16:14 — фикс issue-05 (формулировка method vision)

- context: разные формулировки method в profile.md и vision.md.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Сократить строку в vision.md до копии profile.md.
  2. Расширить строку в profile.md до полной формулировки.
  3. Добавить нормализатор сравнения в валидатор.
- choice: 1
- rationale: profile.md — центральный артефакт, менять его ради косметики нежелательно.
- traces_to:
  - `.claude/sdlc/phases/vision/vision.md`
  - `.claude/sdlc/audit.md#issue-05`

## 2026-04-19 16:30 — SME фазы architecture (уровень)

- context: выбор уровня SME для фазы architecture в dogfooding.
- autonomy_mode: hitl
- phase: architecture
- role: method-engineer
- alternatives:
  1. pet — одностраничное описание структуры с одной диаграммой.
  2. mid — фиксация значимых решений + многоуровневое моделирование.
  3. enterprise — C4 L1-3 + ADR + fitness-функции + явные NFR.
- choice: 2
- rationale: плагин уже большой, mid согласован с requirements=mid.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/architecture/architecture.md`

## 2026-04-19 16:31 — SME фазы architecture (инструмент)

- context: выбор инструмента при mid для фазы architecture.
- autonomy_mode: hitl
- phase: architecture
- role: method-engineer
- alternatives:
  1. ADR (Nygard) — по файлу на значимое решение; ясная история эволюции.
  2. C4 Level 1-2 — Context + Container диаграммы.
  3. arc42 — шаблон из 12 разделов; полный, но тяжеловесный.
- choice: 1
- rationale: ADR параллелен decisions.md; разделяет решения и декомпозицию.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/architecture/adr/`

## 2026-04-19 16:32 — качественные атрибуты (NFR)

- context: выбор критичных NFR для architecture.
- autonomy_mode: hitl
- phase: architecture
- role: method-engineer
- alternatives (multi-select):
  1. extensibility — пользователь добавляет инструменты в method-tool-extensions.
  2. reversibility — /sdlc-init fail-if-exists, /sdlc-focus retire.
  3. determinism — скрипты приоритетнее LLM для проверяемого.
  4. hooks-performance — hooks не блокируют пользователя заметно.
  5. security — секреты не утекают в git через артефакты.
- choice: 1, 2, 3, 4, 5
- rationale: все пять критичны для плагина; каждому соответствует ADR.
- traces_to:
  - `.claude/sdlc/phases/architecture/architecture.md` (секция 4)
  - ADR-003, ADR-007, ADR-006, ADR-005, ADR-008

## 2026-04-19 16:50 — фиксы аудита 16:45 (3 note)

- context: косметические расхождения текст↔frontmatter после architecture.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Применить все 3 фикса автономно в Auto mode.
  2. Оставить note как есть до ближайшей правки артефактов.
  3. Переформулировать frontmatter артефактов под текст.
- choice: 1
- rationale: все три расхождения — текст §4/§6, note не блокирует.
- traces_to:
  - `.claude/sdlc/phases/requirements/requirements.md`
  - `.claude/sdlc/phases/architecture/architecture.md`
  - `.claude/sdlc/audit.md#note-01`
  - `.claude/sdlc/audit.md#note-02`
  - `.claude/sdlc/audit.md#note-03`

## 2026-04-19 16:33 — подсистема для /sdlc-focus после architecture

- context: выбор наиболее требующей внимания подсистемы плагина.
- autonomy_mode: hitl
- phase: architecture
- role: method-engineer
- alternatives:
  1. hooks-система — 5 скриптов + plugin-config + 3 слоя TDD.
  2. catalogs — источники терминологии.
  3. meta-templates — 11 мета-шаблонов.
  4. Нет — описать всё в architecture.md.
- choice: 1
- rationale: hooks критически влияют на надёжность; заслуживают отдельного анализа.
- traces_to:
  - `.claude/sdlc/phases/architecture/architecture.md` §8 (открытые вопросы)

## 2026-04-19 17:10 — SME фазы testing (уровень)

- context: выбор уровня сложности для фазы testing.
- autonomy_mode: hitl
- phase: testing
- role: method-engineer
- alternatives:
  1. pet — ручная проверка и редкие smoke-скрипты.
  2. mid — пирамида автотестов с coverage как пороговым критерием.
  3. enterprise — fitness-функции, mutation, chaos.
- choice: 2
- rationale: плагин на стадии MVP Волны 2; mid даёт гарантии без избытка.
- traces_to:
  - `.claude/sdlc/profile.md`
  - `.claude/sdlc/phases/testing/testing.md`

## 2026-04-19 17:11 — SME фазы testing (инструмент)

- context: выбор инструментария для mid-уровня testing.
- autonomy_mode: hitl
- phase: testing
- role: method-engineer
- alternatives:
  1. bats + shellcheck + существующие валидаторы артефактов.
  2. Только интеграционные smoke-прогоны demo-сценариев.
  3. bats + pytest для Python-утилит.
- choice: 1
- rationale: основная поверхность плагина — bash и markdown.
- traces_to:
  - `.claude/sdlc/phases/testing/testing.md` §3

## 2026-04-19 17:12 — coverage-gate стратегия

- context: выбор порога покрытия для фазы testing.
- autonomy_mode: hitl
- phase: testing
- role: method-engineer
- alternatives:
  1. Без численного gate, только green-build всех слоёв.
  2. ≥60% строк для bash-скриптов через kcov.
  3. 100% AC-сценариев из requirements.md имеют автотест.
- choice: 1
- rationale: %coverage спорен для bash; green-build надёжнее как сигнал.
- traces_to:
  - `.claude/sdlc/phases/testing/testing.md` §5

## 2026-04-19 17:13 — fitness-функции архитектуры

- context: выбор автоматизируемых fitness-функций NFR.
- autonomy_mode: hitl
- phase: testing
- role: method-engineer
- alternatives (multi-select):
  1. Имена инструментов только в method-tool-matrix.md (extensibility).
  2. Hook-производительность <200ms (hooks-performance).
  3. Consistency alpha states ↔ артефакты (determinism).
  4. Secrets не попадают в git через gitleaks (security).
- choice: 1, 2, 3, 4
- rationale: покрывают 4 из 5 NFR; reversibility проверяется интеграционно.
- traces_to:
  - `.claude/sdlc/phases/testing/testing.md` §4

## 2026-04-19 17:45 — углубление hooks (3 open → closed)

- context: закрыть 3 открытых вопроса из external-systems/hooks.md §6.3.
- autonomy_mode: auto (пользователь выбрал option 3 в dialog)
- phase: cross-cutting (focus: hooks)
- role: method-engineer
- alternatives:
  1. Реализовать бенчмарк + план tdd_pairs + fixture.
  2. Оставить вопросы до фазы development.
  3. Подменить бенчмарк статическими утверждениями.
- choice: 1
- rationale: закрывает NFR hooks-performance, создаёт базу для bats.
- deliverables:
  - `scripts/bench-hooks.sh` — 5 hooks замерены, все <200ms.
  - `plugin-config.md` `tdd_pairs_planned` — план пар source↔test.
  - `tests/fixture/minimal-target/` — валидный каркас для integration.
- side-effect:
  - `plugin-config.md` `command: ""` → `command:` — фикс бага парсинга в enforce-format-lint.sh.
- traces_to:
  - `.claude/sdlc/external-systems/hooks.md` §6.3
  - `.claude/sdlc/phases/testing/testing.md` §8
  - `.claude/sdlc/plugin-config.md`

## 2026-04-19 17:30 — /sdlc-focus hooks

- context: перенос внимания на подсистему hooks (§8 architecture.md).
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives (kind):
  1. logical — композиция hooks.json + scripts/*.sh + config.
  2. materialized (hooks/) — директория с одним json.
  3. materialized (scripts/) — директория не только hooks.
- choice (kind): 1
- rationale: hooks — логическая композиция поперёк директорий.
- alternatives (role_vs_target):
  1. subsystem — подсистема плагина.
  2. in_environment — элемент рантайма Claude Code.
  3. creation_system — часть системы создания.
- choice (role): 1
- rationale: hooks часть плагина, не рантайма и не создателя.
- traces_to:
  - `.claude/sdlc/system-context.md`
  - `.claude/sdlc/external-systems/hooks.md`

## 2026-04-19 17:25 — фиксы аудита 17:20 (1 important + 2 note + 1 det)

- context: расхождения после фазы testing — NFR coverage, traces_to, 15-слов.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Применить все 4 фикса автономно в Auto mode.
  2. Оставить issues до ручного review.
  3. Понизить NFR reversibility до «не автоматизируется».
- choice: 1
- rationale: все фиксы косметические и трассировочные, не меняют решения.
- traces_to:
  - `.claude/sdlc/phases/architecture/architecture.md` §4
  - `.claude/sdlc/phases/requirements/requirements.md` §4
  - `.claude/sdlc/phases/testing/testing.md` §4
  - `.claude/sdlc/audit.md`

## 2026-04-19 18:00 — /sdlc-focus ai-driven-sdlc-plugin (возврат фокуса)

- context: hooks-подсистема углублена; готовимся к `/sdlc-phase development`.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Вернуть фокус на ai-driven-sdlc-plugin (плагин как целое).
  2. Оставить фокус на hooks (только hooks как sub-target).
  3. Переключиться на новую подсистему (например, agents или skills).
- choice: 1
- rationale: tdd_pairs общие для всех bash-скриптов, formatter/linter применяются ко всему репо, testing.md имеет system_of_attention=ai-driven-sdlc-plugin.
- traces_to:
  - `.claude/sdlc/system-context.md`
  - `README.sdlc.md`

## 2026-04-19 18:05 — SME фазы development (уровень)

- context: выбор уровня сложности для фазы development.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. mid — TDD с CI и линтерами (bats + shellcheck + shfmt + GitHub Actions).
  2. pet — только bats-unit без CI.
  3. enterprise — полный pipeline с coverage и release.
- choice: 1
- rationale: соответствует testing=mid и принципам 5, 6; избыточно для одного разработчика.
- traces_to:
  - `.claude/sdlc/phases/development/development.md`
  - `.claude/sdlc/profile.md`

## 2026-04-19 18:06 — метод Work (гибрид)

- context: организация работ для альфы Work на фазе development.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. Итерации по open questions артефактов (альфы + GitHub Issues через MCP).
  2. Kanban с TODO.md (противоречит принципу 3).
  3. GitHub Issues без связки с альфами.
- choice: 1 (гибрид — уточнение пользователя).
- rationale: альфы = макросостояние методологии; Issues = micro-units реализации; evidence двунаправленный.
- traces_to:
  - `.claude/sdlc/plugin-config.md` (state_artifact=mcp/github)
  - `.claude/sdlc/alphas.md`

## 2026-04-19 18:07 — первый инкремент development

- context: что реализовать в первой итерации фазы development.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. Установить bats-core и написать первый bats-тест.
  2. Настроить CI GitHub Actions workflow.
  3. Только зафиксировать development.md без кода.
- choice: 1
- rationale: первый тест продвигает Software System к Demonstrable; CI требует хотя бы одного теста.
- traces_to:
  - `tests/unit/validate-artifact.bats`
  - `scripts/bootstrap-dev-env.sh`

## 2026-04-19 18:08 — bootstrap окружения

- context: установка bats/shellcheck/shfmt; ограничение Auto mode на install.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. Bash-скрипт `bootstrap-dev-env.sh` (детектит apt/brew/pacman/dnf).
  2. Vendor-бинарники в `vendor/bin/`.
  3. Devcontainer (отложено).
- choice: 1
- rationale: пользователь указал — для начала достаточно bash-скрипта инициализации стека.
- traces_to:
  - `scripts/bootstrap-dev-env.sh`
  - `.claude/sdlc/phases/development/development.md` §3.4

## 2026-04-19 18:30 — зелёный прогон bats + продвижение альф

- context: пользователь установил bats/shellcheck/shfmt и запустил `bats tests/unit/`.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. Принять 6/6 зелёных как evidence для Software System=Demonstrable и Work=Under Control.
  2. Требовать CI workflow до продвижения.
  3. Требовать тесты для всех 9 скриптов до продвижения.
- choice: 1
- rationale: первый работающий тест демонстрирует исполняемость; расширение покрытия — следующая итерация.
- side_effects:
  - Удалена неиспользуемая переменная `body` в validate-artifact.sh (SC2034).
  - Форматер shfmt обновлён с флагом `-ci` (case indent).
- traces_to:
  - `.claude/sdlc/alphas.md`
  - `tests/unit/validate-artifact.bats`
  - `scripts/validate-artifact.sh`

## 2026-04-19 20:55 — фиксы аудита 20:50 (1 important + 3 note)

- context: расхождения после фазы development — traces, §3.4, README inventory.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. Применить все 4 фикса автономно в Auto mode.
  2. Оставить до ручного review.
  3. Пересмотреть мета-шаблоны для автоматизации traces.
- choice: 1
- rationale: все фиксы трассировочные/документационные, не меняют решения.
- traces_to:
  - `.claude/sdlc/phases/testing/testing.md`
  - `.claude/sdlc/phases/architecture/architecture.md`
  - `.claude/sdlc/phases/development/development.md`
  - `README.md`
  - `.claude/sdlc/audit.md`

## 2026-04-19 21:10 — расширение bats-покрытия до 4 скриптов

- context: развитие пирамиды тестов после первого теста.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. Добавить 3 теста (check-cross-refs, enforce-no-comments, bootstrap-dev-env).
  2. Покрыть все 11 скриптов сразу.
  3. Остановиться на 1 тесте как MVP.
- choice: 1
- rationale: итеративное расширение; 21/21 зелёный; tdd_pairs активны для 4 из 11.
- traces_to:
  - `tests/unit/check-cross-refs.bats`
  - `tests/unit/enforce-no-comments.bats`
  - `tests/unit/bootstrap-dev-env.bats`
  - `.claude/sdlc/plugin-config.md`

## 2026-04-19 21:15 — CI workflow GitHub Actions

- context: автоматизация зелёного прогона на push/PR.
- autonomy_mode: hitl
- phase: development
- role: method-engineer
- alternatives:
  1. Один job lint-and-test с bats + shellcheck + shfmt + det-checks.
  2. Matrix ubuntu + macos.
  3. Отдельные jobs для каждого инструмента.
- choice: 1
- rationale: простой job на старте; matrix — open question фазы deployment.
- traces_to:
  - `.github/workflows/ci.yml`

## 2026-04-19 21:20 — SME фазы deployment

- context: выбор уровня сложности для фазы deployment.
- autonomy_mode: hitl
- phase: deployment
- role: method-engineer
- alternatives:
  1. mid — стратегия релизов и CHANGELOG (semver + GitHub Releases + marketplace).
  2. pet — ручной тег и push.
  3. enterprise — release-train с semantic-release.
- choice: 1
- rationale: согласуется с testing=mid и development=mid; избыточно для одного разработчика.
- traces_to:
  - `.claude/sdlc/phases/deployment/deployment.md`
  - `CHANGELOG.md`
  - `.claude/sdlc/profile.md`

## 2026-04-19 21:21 — канал распространения плагина

- context: выбор канала публикации.
- autonomy_mode: hitl
- phase: deployment
- role: method-engineer
- alternatives:
  1. Claude Code marketplace (основной).
  2. GitHub Releases (артефакты).
  3. npm/PyPI/Docker (не применимо).
- choice: 1
- rationale: marketplace — целевой канал для Claude Code плагинов.
- traces_to:
  - `.claude-plugin/marketplace.json`
  - `.claude/sdlc/phases/deployment/deployment.md` §3.3

## 2026-04-19 21:30 — SME фазы operations

- context: выбор уровня сложности для operations.
- autonomy_mode: hitl
- phase: operations
- role: method-engineer
- alternatives:
  1. pet — GitHub Issues как единственный канал.
  2. mid — Issues + telemetry + CHANGELOG-driven.
  3. enterprise — SLA + on-call + дашборды.
- choice: 1
- rationale: solo-разработчик, плагин без server-side компонента, best-effort поддержка.
- traces_to:
  - `.claude/sdlc/phases/operations/operations.md`
  - `.claude/sdlc/profile.md`

## 2026-04-19 21:31 — канал обратной связи

- context: где пользователи сообщают о проблемах.
- autonomy_mode: hitl
- phase: operations
- role: method-engineer
- alternatives:
  1. GitHub Issues с 3 темплейтами (bug/feature/question).
  2. GitHub Discussions.
  3. Email / другой канал.
- choice: 1 (+ email для сенситивных в SUPPORT.md).
- rationale: минимальный вход для пользователей; структурированные поля через yml-темплейты.
- traces_to:
  - `.github/ISSUE_TEMPLATE/bug.yml`
  - `.github/ISSUE_TEMPLATE/feature.yml`
  - `.github/ISSUE_TEMPLATE/question.yml`
  - `SUPPORT.md`

## 2026-04-19 21:32 — первый артефакт operations

- context: стартовый набор для фазы operations.
- autonomy_mode: hitl
- phase: operations
- role: method-engineer
- alternatives:
  1. operations.md + Issue templates + SUPPORT.md.
  2. Только operations.md без templates.
  3. Incident playbook сразу.
- choice: 1
- rationale: канал обратной связи открыт сразу; playbook — после первого инцидента.
- traces_to:
  - `.claude/sdlc/phases/operations/operations.md`
  - `SUPPORT.md`

## 2026-04-19 22:00 — релиз v0.2.0 и продвижение Software System

- context: релиз Волны 2 выполнен; тег v0.2.0 опубликован.
- autonomy_mode: hitl
- phase: deployment
- role: method-engineer
- alternatives:
  1. Software System Demonstrable → Usable (релиз опубликован).
  2. Оставить Demonstrable до первого внешнего пользователя.
  3. Пропустить Usable и целиться в Ready.
- choice: 1
- rationale: система установима через marketplace, доступна стейкхолдерам; Essence Usable — «система готова к использованию».
- traces_to:
  - `.claude/sdlc/alphas.md`
  - `CHANGELOG.md`

## 2026-04-19 22:30 — формат work-unit issue template

- context: активация GitHub Issues как state_artifact для альфы Work.
- autonomy_mode: hitl
- phase: operations
- role: method-engineer
- alternatives:
  1. Полный: альфа + фаза + AC + definition-of-done.
  2. Компактный: только scope + AC.
  3. Расширенный: выше + estimate + dependencies.
- choice: 1
- rationale: максимум трассируемости; каждая US из requirements.md может быть отражена.
- traces_to:
  - `.github/ISSUE_TEMPLATE/work-unit.yml`
  - `.claude/sdlc/phases/operations/operations.md` §3.2

## 2026-04-19 22:31 — стратегия milestones

- context: группировка backlog-единиц.
- autonomy_mode: hitl
- phase: operations
- role: method-engineer
- alternatives:
  1. По волнам (Wave 1, Wave 2, Wave 3).
  2. По релизам (v0.3.0, v0.4.0).
  3. Без milestones на старте.
- choice: 1
- rationale: совпадает с семантикой CLAUDE.md «Wave 1/2»; Wave 3 — текущий backlog.
- traces_to:
  - `CLAUDE.md` (секция «Двухволновое MVP»)
  - GitHub milestones

## 2026-04-21 — актуализация README под состояние v0.2.1

- context: README рассинхронизирован с состоянием; принцип 16 не соблюдался в коммитах development/deployment/operations.
- autonomy_mode: hitl
- phase: cross-cutting
- role: method-engineer
- alternatives:
  1. A — минимальный фикс: только исправить ошибки (счётчик принципов, статус).
  2. B — полная актуализация под состояние: счётчик, статус, Tests & CI, Поддержка, backlog, инвентарь.
  3. C — реструктуризация под user-journey: меняет vision README; требует `/sdlc-phase vision --reconfigure`.
- choice: 2
- rationale: A оставляет принцип 16 нарушенным. C — vision-решение, выходит за рамки sync. B ровно закрывает gap без перепроектирования.
- follow_ups:
  - Кандидат на work-unit: усиление `check-readme-inventory.sh` (ловить tests/, workflows, CHANGELOG, ISSUE_TEMPLATE).
  - Кандидат на работу: C как отдельная итерация Волны 4 при появлении внешних пользователей.
- traces_to:
  - `README.md`
  - `.claude/sdlc/phases/vision/vision.md`
  - `CHANGELOG.md` 0.2.0, 0.2.1
  - CLAUDE.md принципы 1, 9, 16

## 2026-04-19 22:32 — объём pilot-issues

- context: дымовой тест backlog-процесса.
- autonomy_mode: hitl
- phase: operations
- role: method-engineer
- alternatives:
  1. 3 issues: bats-покрытие + gitleaks + MCP dev/runtime.
  2. 1 self-referential (настройка backlog).
  3. 6 issues (весь backlog development.md §3.5).
- choice: 1
- rationale: 3 типа задач для дымового теста; не спам.
- traces_to:
  - `.claude/sdlc/phases/development/development.md` §3.5
  - GitHub Issues

