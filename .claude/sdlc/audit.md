---
name: audit
type: audit-report
project: ai-driven-sdlc-plugin
run_at: 2026-04-19 16:45
auditor: sdlc-consistency-auditor
status: pass
issues_count: 3
---

# Отчёт сквозного аудита консистентности

## 1. Резюме

Полный прогон по каркасу `bootstrap + vision + requirements + architecture (8 ADR)` после завершения фазы architecture.

**Положительные итоги.** Детерминированная проверка осиротевших ссылок (эквивалент `check-cross-refs.sh`) нарушений не обнаружила: 12 относительных markdown-ссылок из `requirements.md` и `architecture.md` разрешаются в существующие файлы. Трассируемость `vision → requirements → architecture` замкнута во frontmatter: `vision.traces_to → requirements.md`, `requirements.traces_from → vision.md`, `requirements.traces_to → architecture.md`, `architecture.traces_from → [requirements.md, vision.md]`. Уровни SME всех трёх фаз в артефактах побайтово совпадают со строками `profile.md` (vision=pet, requirements=mid, architecture=mid). Все 8 ADR имеют корректный frontmatter (`name`, `type: adr`, `status: Accepted`, `date`, `nfr`, `principles`), ссылаются на принципы из `CLAUDE.md` плагина; индекс `adr/README.md` перечисляет все восемь ADR с теми же заголовками и статусами, что и таблица `architecture.md §5`. Пять NFR (`extensibility`, `reversibility`, `determinism`, `hooks-performance`, `security`) покрыты восемью ADR на уровне frontmatter без пробелов. Записи в `decisions.md` 16:30–16:33 фиксируют четыре значимых выбора фазы architecture (уровень SME, инструмент, множественный выбор NFR, кандидат подсистемы для `/sdlc-focus`), каждая — с 2–4 альтернативами (принцип 1). Роли `method-engineer` (активна) и `systems-thinker` (неактивна) согласованы с использованиями в `requirements.md` (US-04, US-07) и `architecture.md`. Продвижения альф `Software System → Architecture Selected` и `Requirements → Acceptable` имеют evidence-артефакты (`architecture.md` + `adr/`, `architecture.md §4`).

**Найденные расхождения.** Три расхождения уровня **note** — все несущественные, связанные с рассинхроном текстовых секций §4 тел артефактов относительно машинно-читаемого frontmatter и с двумя мелкими текстовыми несоответствиями (формулировка `method` в `requirements.md` vs `profile.md` и перечень ADR в `architecture.md §4` vs `decisions.md#16:32`). Ни одно из них не нарушает трассируемость и не блокирует альфы. Блокеров и расхождений уровня `important` не обнаружено.

**Итоговый статус: pass** — переход к фазе development разблокирован.

## 2. Проверки

| Проверка | Статус | Детали |
|---|---|---|
| Трассируемость фаз (vision → requirements → architecture) | pass | Frontmatter всех трёх артефактов формирует связную цепочку. Тело `requirements.md §4` ссылается на `vision.md` через markdown-ссылку (строка 239); тело `architecture.md §6` ссылается на `requirements.md` и `vision.md` (строка 104). `architecture.traces_to` пустой — корректно, следующая фаза ещё не начата. |
| Соответствие уровню SME | pass-with-note | `vision.md` (`sme_level: pet`), `requirements.md` (`sme_level: mid`), `architecture.md` (`sme_level: mid`) соответствуют `profile.md`. Поля `method` и `tool` во frontmatter `vision.md` и `architecture.md` побайтово совпадают с соответствующими строками `profile.md`. Для `requirements.md` формулировка `method` отличается от `profile.md` на одно слово — см. note-03. |
| Альфы ↔ артефакты (через sdlc-alpha-tracker) | pass | Логический запрос к `sdlc-alpha-tracker.get_all()` возвращает 7 продвинутых альф. Каждое продвижение сопровождается evidence-артефактом, указанным в `alphas.md` и подтверждаемым присутствием файла. `Software System` и `Requirements` — новые продвижения фазы architecture — имеют evidence-артефакты `architecture.md` + `adr/` (для первой) и `architecture.md §4` (для второй). См. §5. |
| System-context ↔ архитектура | pass | `system-context.md` регистрирует единственную систему внимания `ai-driven-sdlc-plugin` (`target`, `materialized`). Функциональная декомпозиция `architecture.md §3.1–3.3` описывает 8 функций, 7 подсистем и граф создания — всё относительно той же системы. `README.sdlc.md §4` перечисляет все обязательные SDLC-файлы и ссылается на `alphas.md` (без дублирования таблицы альф, принцип 13). |
| 8 ADR: frontmatter, статус, принципы, индекс | pass | Все 8 ADR имеют обязательные поля frontmatter (`name`, `type: adr`, `title`, `status: Accepted`, `date: 2026-04-19`, `nfr`, `principles`). Поле `principles` каждого ADR ссылается на номера принципов из `CLAUDE.md` плагина: ADR-001→[3], ADR-002→[13], ADR-003→[2], ADR-004→[9], ADR-005→[5], ADR-006→[6], ADR-007→[14], ADR-008→[10]. Индекс `adr/README.md` перечисляет все восемь ADR; заголовки и статусы совпадают с таблицей `architecture.md §5` побайтово. |
| NFR раскрыты в ADR | pass-with-note | Пять NFR фазы architecture покрыты восемью ADR на уровне frontmatter.nfr: `extensibility` → ADR-001, ADR-003, ADR-004; `reversibility` → ADR-004, ADR-007; `determinism` → ADR-002, ADR-005, ADR-006; `hooks-performance` → ADR-006; `security` → ADR-008. Текстовый список ADR в `architecture.md §4` («ADR-004, ADR-005, ADR-006, ADR-007, ADR-008») неполон относительно этой фактической раскладки — см. note-02. |
| Decisions-покрытие (принцип 1) | pass | `decisions.md` содержит 23 записи (5 bootstrap + 7 vision + 4 requirements + 5 audit-фиксов + 4 architecture). Четыре архитектурные записи 16:30–16:33 покрывают все значимые выборы architecture: SME-уровень, инструмент (ADR Nygard), множественный выбор пяти NFR и кандидат подсистемы для `/sdlc-focus`. Каждая запись содержит 2–4 альтернативы с выбранным вариантом и `traces_to`. Хронология корректна. |
| Роли: roles.md ↔ profile.md ↔ vision/requirements/architecture | pass | `roles.md` целевого регистрирует `method-engineer` (активна, sквозная) и `systems-thinker` (неактивна). `profile.md` указывает активную роль `method-engineer`. Frontmatter всех трёх фазовых артефактов: `role: method-engineer`. US-04 и US-07 в `requirements.md` используют `systems-thinker` как Роль истории — висячих указателей нет, поля совместимы с `catalogs/roles.md`. |
| Осиротевшие ссылки (эквивалент check-cross-refs.sh) | pass | Скрипт-эквивалент отработал без нарушений. Ручная проверка: 12 относительных markdown-ссылок в `requirements.md` и `architecture.md` разрешаются; ссылка на `adr/README.md` из `architecture.md §5` разрешается в существующий индекс; все 8 ссылок на ADR-файлы из таблицы §5 разрешаются; ссылки `../vision/vision.md` и `../requirements/requirements.md` разрешаются из соответствующих мест. |
| TDD-семантика (второй слой принципа 5) | n/a | Фаза development не начата; исходники не изменялись. |
| Memom-консистентность (Волна 2) | pass | `memom.md` присутствует в корне плагина. `CLAUDE.md` плагина в этом прогоне не правился; новых записей memom не требуется. |

## 3. Найденные расхождения

### note-01 — текстовые секции §4 `vision.md` и `requirements.md` и `architecture.md` отстают от frontmatter

- **Критичность**: note.
- **Локации**: `phases/vision/vision.md:87`, `phases/requirements/requirements.md:240`, `phases/architecture/architecture.md:105`.
- **Описание**: машинно-читаемый `traces_to` во frontmatter всех трёх артефактов актуален и корректно разрешается (или явно пуст, как в `architecture.md`). Человекочитаемые строки §4 тел отстают:
  - `vision.md §4` говорит `(создан — см. frontmatter)` — формально допустимо, но форма отличается от двух других артефактов;
  - `requirements.md §4` говорит `(будет создан)` — на момент аудита артефакт уже создан;
  - `architecture.md §6` говорит `traces_to: .claude/sdlc/phases/testing/ (будет создан по принципу 5)` — содержит путь, которого нет во frontmatter (там `traces_to: []`).
- **Последствие**: расхождение между двумя представлениями одной информации. Не влияет на трассировку и на работу скриптов; заметно только читателю.

### note-02 — `architecture.md §4` неполно перечисляет ADR по NFR

- **Критичность**: note.
- **Локация**: `phases/architecture/architecture.md:85`.
- **Описание**: строка «Подробности — в ADR-004, ADR-005, ADR-006, ADR-007, ADR-008.» перечисляет пять ADR, но фактически NFR `extensibility` покрывается также ADR-001 и ADR-003, а NFR `determinism` — также ADR-002. Запись `decisions.md#16:32` (поле `traces_to`) указывает другой набор: «ADR-003, ADR-007, ADR-006, ADR-005, ADR-008». Оба списка неполны относительно `frontmatter.nfr` восьми ADR.
- **Последствие**: читатель §4 не увидит, что ADR-001, ADR-002, ADR-003 вносят вклад в NFR. Трассировка NFR → ADR в машинно-читаемом слое (frontmatter) корректна и полна; расходится только текстовая сводка.

### note-03 — формулировка `method` в `requirements.md` отличается от `profile.md`

- **Критичность**: note.
- **Локация**: `phases/requirements/requirements.md:6` vs `.claude/sdlc/profile.md:19`.
- **Описание**: `requirements.md` frontmatter: `method: Декомпозиция на проверяемые единицы с критериями готовности`. `profile.md` таблица: `Декомпозиция на проверяемые единицы с AC`. Семантически идентично («критерии готовности» ≈ «AC», acceptance criteria), но не побайтово. Для `vision` и `architecture` побайтовое совпадение достигнуто (в том числе после фикса issue-05). Правило трактовки строки `method` в `catalogs/` не требует побайтового совпадения, поэтому расхождение классифицировано как note, не important.
- **Последствие**: разный поиск по двум строкам вернёт разные попадания; валидатор по префиксу/подстроке не сработает.

## 4. Предложенные фиксы

### note-01 — синхронизация текстовых секций §4 с frontmatter

1. Обновить тексты §4 во всех трёх артефактах под единый шаблон: `traces_to: <путь> (см. frontmatter)` либо `traces_to: — (следующая фаза не начата)`. Плюсы: единая форма, минимальный diff. Минусы: придётся касаться при каждом переходе фазы.
2. Сократить §4 тела до одной строки `Трассируемость — во frontmatter` во всех трёх артефактах. Плюсы: единый источник истины (frontmatter); исключает класс рассинхрона. Минусы: теряется человекочитаемый контекст о продолжении цепочки.
3. Добавить в `sdlc-artifact-validator` правило-проверку: «если §4 тела содержит путь, отсутствующий во `frontmatter.traces_to` — warn». Плюсы: класс проблем ловится автоматом. Минусы: overengineering для note-уровня; требует кода скрипта.

**Рекомендация**: вариант 2 при ближайшей правке любого из артефактов — полностью убирает класс расхождений.

### note-02 — полнота списка ADR в `architecture.md §4`

1. Расширить строку 85 до полного перечня по NFR: `Подробности — в ADR-001, ADR-002, ADR-003, ADR-004, ADR-005, ADR-006, ADR-007, ADR-008` (все восемь). Плюсы: максимальная явность. Минусы: список длиннее, нагружает §4.
2. Заменить одну общую строку на поле таблицы §4 «ADR» — в каждой строке NFR перечислить релевантные ADR. Плюсы: точная трассировка каждого NFR. Минусы: ширина таблицы растёт; риск снова отстать при добавлении ADR.
3. Убрать строку-перечень из §4, ограничившись ссылкой на индекс `adr/README.md` (где NFR уже колонкой). Плюсы: единственный источник правды — индекс. Минусы: читатель §4 теряет быстрый указатель.

**Рекомендация**: вариант 2 — точнее трассировка NFR → ADR, а индекс `adr/README.md` остаётся навигационным.

### note-03 — нормализация формулировки `method` для requirements

1. Изменить `requirements.md:6` на `method: Декомпозиция на проверяемые единицы с AC` — побайтовая копия `profile.md`. Плюсы: побайтовое совпадение, как у двух других фаз; минимальный diff. Минусы: небольшая потеря читаемости (аббревиатура AC).
2. Изменить `profile.md:19` на `Декомпозиция на проверяемые единицы с критериями готовности`. Плюсы: полная форма в центральном артефакте. Минусы: правка `profile.md` ради косметики; влечёт каскад в историю изменений.
3. Зафиксировать в `meta-templates/phase-artifact.meta.md` правило: `method` в артефакте фазы должен быть строго равен строке из `profile.md`; добавить проверку в `validate-artifact.sh`. Плюсы: класс расхождений ловится автоматически. Минусы: требует кода; для note-уровня избыточно.

**Рекомендация**: вариант 1 при ближайшем касании `requirements.md` — аналогично фиксу issue-05 для `vision.md`.

## 5. Привязка к альфам

Получено через логический запрос к `sdlc-alpha-tracker.get_all()`:

| Альфа | Состояние | Evidence | Консистентность |
|---|---|---|---|
| Opportunity | Value Established | `phases/vision/vision.md §3.1–3.6` | ok |
| Stakeholders | Involved | `phases/requirements/requirements.md` (AC каждой US) | ok |
| Requirements | Acceptable | `phases/architecture/architecture.md §4` (5 NFR) | ok |
| Software System | Architecture Selected | `phases/architecture/architecture.md` + `adr/` (8 ADR) | ok |
| Work | Initiated | `decisions.md#bootstrap` | ok |
| Team | Seeded | `roles.md` | ok |
| Way of Working | Foundation Established | `plugin-config.md` + `profile.md` | ok |

Все продвинутые альфы имеют evidence-артефакты согласно правилам `sdlc-alpha-tracker.advance`. Два новых продвижения с предыдущего прогона (`Software System → Architecture Selected`, `Requirements → Bounded → Acceptable`) зафиксированы в `alphas.md` и сопровождаются артефактами фазы architecture.

## 6. Изменения с предыдущего прогона (2026-04-19 16:20)

| Объект | Изменение | Проверка |
|---|---|---|
| Фаза architecture | создана: `architecture.md` (9 разделов) + `adr/` (8 ADR + index) | Все файлы присутствуют; frontmatter валиден; ссылки разрешаются. |
| `alphas.md` | продвижения `Software System → Architecture Selected`, `Requirements → Bounded → Acceptable` | Evidence-артефакты существуют; записи в журнале переходов корректны. |
| `profile.md` | строка `architecture` заполнена: `mid, ADR (Nygard), hitl` | Соответствует `architecture.md` frontmatter. |
| `requirements.md` | `traces_to` обновлён на `../architecture/architecture.md` | Ссылка разрешается в существующий файл. |
| `decisions.md` | +4 записи 16:30–16:33 по фазе architecture | Каждая с 2–4 альтернативами, `traces_to`, выбором; хронология корректна. |
| `audit.md` | перезаписан по новому прогону (issues_count: 1 → 3 note) | Прошлый note-01 (§4 vision.md) переклассифицирован и обобщён в новый note-01 (три артефакта вместе). |

## 7. Следующие шаги

- Три note-расхождения устранять при ближайшей правке соответствующих артефактов; блокировать merge не нужно.
- При запуске фазы development: обновить `architecture.traces_to` на артефакт testing и/или `decisions.md`, добавить `role: developer` в `roles.md` при активации.
- Для note-02 приоритетен вариант 2 — расширить таблицу §4 колонкой ADR; повысит точность трассировки NFR.
- После фазы development перезапустить `/sdlc-audit` — появится проверка TDD-семантики (второй слой принципа 5) и цепочка трассируемости расширится до четырёх фаз.
