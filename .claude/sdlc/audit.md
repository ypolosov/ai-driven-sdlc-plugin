---
name: audit
type: audit-report
project: ai-driven-sdlc-plugin
run_at: 2026-04-30 21:50
applied_at: 2026-04-30 22:30
auditor: sdlc-consistency-auditor
status: pass
issues_count: 7
issues_resolved: 7
---

# Отчёт сквозного аудита SDLC-артефактов

## 1. Резюме

Прогон выполнен после релиза v0.2.1 и продвижения альфы Software System до Usable.
Детерминированные проверки чистые (`check-cross-refs.sh` exit 0, `validate-artifact.sh` ОК по frontmatter).
2 подозрения парсера на ≤15 слов (в `development.md` и `deployment.md`) — **false positive**: regex склеил буллет с предыдущей строкой.
Семантически оба утверждения укладываются в 15 слов.

Найдено 7 расхождений уровней important / note. Финальный статус — **warn**.
Блокирующих находок нет; merge в main не блокируется.

## 2. Проверки

| Проверка | Статус | Детали |
|---|---|---|
| Трассируемость фаз (vision → … → operations) | pass | `traces_from` / `traces_to` корректны во всех 7 артефактах фаз; цепочка двунаправленная |
| Соответствие уровню SME (mid/pet по `profile.md`) | pass | Все артефакты несут `sme_level` в frontmatter; структура соответствует `phase-artifact.meta.md` |
| Альфы ↔ артефакты (через `sdlc-alpha-tracker`) | warn | Все 7 свидетельств существуют; **но**: альфа Software System=Usable, evidence — `CHANGELOG.md#0.2.0`, тогда как фактический последний релиз `v0.2.1` |
| System-context ↔ архитектура | warn | `current_focus` согласован; **расхождение типизации**: hooks в `system-context.md` и `external-systems/hooks.md` помечены `kind: logical`, но в `architecture.md` §3.2 «Подсистемы (materialized)» |
| Осиротевшие ссылки (`check-cross-refs.sh`) | pass | Скрипт вернул exit 0 |
| Правило ≤15 слов | pass | 2 подозрения детерминированного парсера — **false positive** (см. находку #1) |
| TDD-семантика (принцип 5, слой 2) | pass | 4 активных пары `tdd_pairs` ↔ 4 `.bats`-файла; bats-тесты семантически проверяют поведение скриптов; planned-секция согласована с `testing.md` §3.1 |
| Memom-консистентность (Волна 2) | pass | Записи Волны 2 (14–17) и правка принципа 1 присутствуют; `CLAUDE.md` после правки изменений не получал |
| README плагина (принцип 16) | warn | Счётчики и инвентарь синхронны со структурой; **но**: README пишет «v0.2.1», CHANGELOG последний `[0.2.1]` ✓; внутренние расхождения в `operations.md` (см. находку #4) |
| README систем внимания (принцип 17) | warn | `README.sdlc.md` `focus_count: 1`; `system-context.md` для того же slug `focus_count: 2`; рассинхрон после возврата фокуса 2026-04-19 |

## 3. Найденные расхождения

### Находка #1 — false positive парсера ≤15 слов

- **Критичность:** note
- **Локация:**
  - `.claude/sdlc/phases/deployment/deployment.md:64` — «Формат — Keep a Changelog с секциями Added / Changed / Fixed / Removed.» (8 слов)
  - `.claude/sdlc/phases/development/development.md:108` — «Резолюция 2026-04-19: системный пакетный менеджер через `bootstrap-dev-env.sh`.» (7 слов)
- **Описание:** Регулярка `validate-artifact.sh` склеивает строку буллета с предыдущей строкой при отсутствии терминальной точки на верхнеуровневом пункте. Семантически каждое утверждение укладывается в 15 слов.
- **Подтверждение:** ручная подсчётом — 8 и 7 слов соответственно.

### Находка #2 — пустая фикстура `tests/fixture/minimal-target/`

- **Критичность:** important
- **Локация:** `tests/fixture/minimal-target/`
- **Описание:** `testing.md` §8 фиксирует резолюцию: «`tests/fixture/minimal-target/` — валидный минимальный каркас». Фактически каталог содержит только пустую `.claude/` без артефактов. Integration-сценарии из §3.3 не имеют материала для прогона. Это противоречит fitness `alpha-evidence-consistency`.

### Находка #3 — типизация подсистемы `hooks` несогласована

- **Критичность:** note
- **Локация:**
  - `.claude/sdlc/phases/architecture/architecture.md:57` — секция «3.2. Подсистемы плагина (materialized)» включает `hooks/`.
  - `.claude/sdlc/system-context.md:20` — `hooks | subsystem | logical`.
  - `.claude/sdlc/external-systems/hooks.md:4` — `kind: logical`.
- **Описание:** В architecture-фазе `hooks` отнесена к materialized-подсистемам; в реестре систем внимания и в её system-readme — к logical. Категория «materialized vs logical» — ключевая для принципа 17.

### Находка #4 — рассинхрон `focus_count`

- **Критичность:** note
- **Локация:**
  - `.claude/sdlc/system-context.md:19` — `ai-driven-sdlc-plugin | … | 2`.
  - `README.sdlc.md:7` и §2 (строка 24) — `focus_count: 1`.
- **Описание:** После возврата фокуса (журнал §«2026-04-19 — возврат внимания на ai-driven-sdlc-plugin») счётчик в реестре стал 2, но в sidecar-README остался 1. Принцип 17 требует консистентности описания системы внимания.

### Находка #5 — внутреннее противоречие `operations.md` (3 vs 4 templates)

- **Критичность:** note
- **Локация:** `.claude/sdlc/phases/operations/operations.md`
  - §3.2 перечисляет 4 шаблона (bug, feature, question, **work-unit**).
  - §3.5 / §5 DoD ссылаются на «3 issue templates созданы».
  - `CHANGELOG.md` `[0.2.0]` упоминает в Added только bug/feature/question.
- **Описание:** `work-unit.yml` фактически существует (`.github/ISSUE_TEMPLATE/`) и упомянут в README. Но `operations.md` и `CHANGELOG` зафиксировали меньшее число. Также `decisions.md` 2026-04-19+ должен иметь решение о добавлении 4-го шаблона.

### Находка #6 — alpha-evidence Software System ссылается на старый релиз

- **Критичность:** note
- **Локация:** `.claude/sdlc/alphas.md:20` — `Software System | Usable | CHANGELOG.md#0.2.0 (release v0.2.0)`.
- **Описание:** Текущий релиз — `v0.2.1` (см. `CHANGELOG.md` и `README.md` строка 9). Альфа продвинулась до Usable на 0.2.0; v0.2.1 — patch без изменения состояния альфы. Формально evidence остаётся валидным, но удобнее обновить ссылку на актуальный релиз.

### Находка #7 — потенциальное расхождение AC-05.2 ↔ реализация hook

- **Критичность:** note
- **Локация:**
  - `.claude/sdlc/phases/requirements/requirements.md:171-176` — AC-05.2: «PostToolUse триггер … блокирует противоречивые записи».
  - `external-systems/hooks.md:53-54` — «`sdlc-consistency-auditor` — LLM-агент, вызываемый PostToolUse async».
- **Описание:** AC требует блокировки; описание подсистемы говорит о async-вызове (без блокировки). PostToolUse семантически не может блокировать (запись уже произошла). AC-05.2 нужно переформулировать или явно отметить как «soft»-блокировку через follow-up audit.

## 4. Предложенные фиксы

### Находка #1 — false positive парсера

1. **Улучшить regex в `validate-artifact.sh`** — учитывать markdown-буллеты как самостоятельные предложения, не склеивать с предыдущей строкой без точки.
2. **Добавить точку в конце «Открытые вопросы» буллетов** в `deployment.md` и `development.md` — обходной путь без правки скрипта.
3. **Документировать known-limitation в `plugin-config.md`** — добавить whitelist строк или fenced-блоков, отступаемых парсером.

### Находка #2 — пустая фикстура

1. **Заполнить `tests/fixture/minimal-target/.claude/sdlc/`** — минимальный набор: `profile.md`, `plugin-config.md`, `alphas.md`, `decisions.md`, `roles.md`, `system-context.md` + один артефакт фазы; добавить bats integration-тест, который запускает все детерминированные скрипты на фикстуре.
2. **Удалить упоминание фикстуры** из `testing.md` §8 и пометить «отложено до Волны 3» с записью в `decisions.md`.
3. **Сгенерировать фикстуру скриптом `bootstrap-target.sh`** в init-time, запуская его на временный каталог в bats-тесте `setup()`; не хранить материализованную фикстуру.

### Находка #3 — типизация hooks

1. **Обновить `architecture.md` §3.2** — переименовать секцию в «Подсистемы (структурные)» и добавить колонку `kind`; явно пометить hooks как logical.
2. **Поднять `hooks` до materialized**: обернуть в собственный пакет/директорию верхнего уровня и зарегистрировать как materialized; обновить `system-context.md`.
3. **Уточнить определение materialized vs logical** в `meta-templates/system-readme.meta.md` и сослаться из `architecture.md` §3.2 на эту таксономию.

### Находка #4 — `focus_count`

1. **Автоматизировать обновление `focus_count`** в `/sdlc-focus`: skill инкрементирует одновременно в `system-context.md` и в `README.sdlc.md` (или `external-systems/<slug>.md`).
2. **Убрать дубль** — хранить `focus_count` только в `system-context.md`; из system-readme выпилить поле; обновить `system-readme.meta.md`.
3. **Добавить детерминированный скрипт `check-system-readmes.sh` режим `--sync-focus-count`** — сверяет счётчики и блокирует расхождение в pre-commit.

### Находка #5 — 3 vs 4 templates

1. **Привести `operations.md` § 3.5 / DoD к 4 templates** и добавить `work-unit.yml` в перечень; обновить `CHANGELOG.md` `[0.2.0]` Added (или `[Unreleased]`/новый патч).
2. **Перенести `work-unit.yml` в раздел Backlog** (вне operations) — этот шаблон обслуживает альфу Work, а не channel feedback; обновить cross-ref в `development.md` §3.3.
3. **Принять текущее как факт**: оставить 4 templates в `operations.md`, добавить запись в `decisions.md` с обоснованием расширения.

### Находка #6 — evidence v0.2.0

1. **Обновить `alphas.md`** на `CHANGELOG.md#0.2.1 (release v0.2.1)` — без перехода состояния (Usable не двигалась).
2. **Оставить evidence на 0.2.0** как «момент перехода»; добавить отдельную колонку `last_release` для текущей версии.
3. **Запустить `sdlc-alpha-tracker`** с подтверждением, что 0.2.1 — patch и не требует обновления evidence; запись в `decisions.md`.

### Находка #7 — AC-05.2 vs async

1. **Переформулировать AC-05.2**: «`PostToolUse триггер срабатывает асинхронно; противоречивые записи помечаются в audit.md и блокируют merge через CI`».
2. **Добавить второй уровень**: PreToolUse-блокировку для критичных артефактов (`alphas.md`, `profile.md`); зафиксировать в `hooks.json` и в `external-systems/hooks.md`.
3. **Принять текущее поведение**: пометить AC-05.2 как «реализовано через CI gate»; добавить трассировку на `.github/workflows/ci.yml` job, запускающий `/sdlc-audit`.

## 5. Привязка к альфам

Состояние на момент аудита (через `sdlc-alpha-tracker`):

| Альфа | Состояние | Артефакт-свидетельство | Замечание |
|---|---|---|---|
| Opportunity | Value Established | `phases/vision/vision.md` | свидетельство существует |
| Stakeholders | Involved | `phases/requirements/requirements.md` | свидетельство существует |
| Requirements | Acceptable | `phases/architecture/architecture.md` | свидетельство существует |
| Software System | Usable | `CHANGELOG.md#0.2.0` (release v0.2.0) | факт релиз `v0.2.1` — см. находку #6 |
| Work | Under Control | `tests/unit/validate-artifact.bats` | свидетельство существует |
| Team | Seeded | `roles.md` | свидетельство существует |
| Way of Working | In Use | `phases/testing/testing.md` | свидетельство существует |

Все 7 свидетельств физически присутствуют; одна ссылка устарела (находка #6).

## 6. Финальный статус

**pass** — все 7 находок устранены или закрыты как false positive 2026-04-30.

### Применённые фиксы

| # | Уровень | Действие | Артефакт |
|---|---|---|---|
| #1 | note | Парсер `validate-artifact.sh` улучшен; добавлен bats-тест на numbered heading | `scripts/validate-artifact.sh`, `tests/unit/validate-artifact.bats` |
| #2 | important | Закрыто как false positive аудитора; фикстура уже заполнена 8 артефактами | `tests/fixture/minimal-target/` |
| #3 | note | §3.2 переименована в «Структурные подсистемы»; колонка `kind`, hooks=logical | `phases/architecture/architecture.md` |
| #4 | note | `focus_count: 2` обновлён в frontmatter и §2 | `README.sdlc.md` |
| #5 | note | DoD приведён к 4 templates; frontmatter `updated: 2026-04-30` | `phases/operations/operations.md` |
| #6 | note | Evidence Software System → CHANGELOG.md#0.2.1, дата 2026-04-21 | `.claude/sdlc/alphas.md` |
| #7 | note | AC-05.2 переформулирован: помечается в audit.md, merge блокируется CI gate | `phases/requirements/requirements.md` |

Дополнительно: историческая запись в `decisions.md` (rationale 23 слова) разбита на 3 утверждения для соблюдения принципа 4.

Открытый бэклог (work-unit candidates):

- Integration bats-тест на `tests/fixture/minimal-target/` (последствие #2).
- Детерминированная синхронизация `focus_count` через `/sdlc-focus` или `check-system-readmes.sh` (последствие #4).
- Расширение `tdd_pairs` на оставшиеся 7 скриптов.
- Уточнение валидатора 15-слов для inline-bold AC-разделителей (отложено как known-limitation).

Все решения зафиксированы в `decisions.md` 2026-04-30.
