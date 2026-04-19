---
name: requirements
type: requirements
phase: requirements
sme_level: mid
method: Декомпозиция на проверяемые единицы с критериями готовности
tool: User Stories + Gherkin AC
alphas: [Requirements, Stakeholders]
disciplines: [requirements-engineering, stakeholder-analysis]
role: method-engineer
traces_from:
  - ../vision/vision.md
traces_to:
  - ../architecture/architecture.md
system_of_attention: ai-driven-sdlc-plugin
backlog_store: github-issues
volatility: high
created: 2026-04-19
updated: 2026-04-19
---

# Требования плагина ai-driven-sdlc

## 1. Назначение

Продвинуть альфу Requirements в состояние Bounded.
Продвинуть альфу Stakeholders в состояние Involved.
Метод — декомпозиция vision в проверяемые единицы с AC.

## 2. Привязка к фазе и методу

- Фаза: requirements.
- Уровень SME: mid.
- Дисциплины: requirements-engineering, stakeholder-analysis.
- Инструмент: User Stories + Gherkin AC.
- Backlog: GitHub Issues с label `requirement`.
- Volatility: high — dogfooding итерации уточняют требования.

## 3. User Stories MVP Волны 2

### US-01: Инициализация SDLC-каркаса

- Роль: method-engineer.
- Цель: инициализировать SDLC-каркас в целевом проекте.
- Польза: начать методологическую работу с фиксацией альф.

**AC-01.1** — создание каркаса:

```gherkin
Given .claude/sdlc/ отсутствует в целевом
When запускаю /sdlc-init
Then создаются 7 обязательных файлов и .env.example
And .env добавляется в .gitignore
And запись bootstrap появляется в decisions.md
```

**AC-01.2** — блокировка дубля:

```gherkin
Given .claude/sdlc/ уже существует
When запускаю /sdlc-init без аргументов
Then команда отказывает с подсказкой --merge или --force
```

Трассировка: vision.md §3.2; принцип 14.

### US-02: Выбор метода на фазу через SME-опрос

- Роль: method-engineer.
- Цель: выбирать уровень и инструмент на каждой фазе отдельно.
- Польза: подбирать метод ситуативно под контекст.

**AC-02.1** — опрос до артефактов:

```gherkin
Given запущен /sdlc-phase <name>
When skill фазы начинает работу
Then вызов AskUserQuestion происходит до записи артефактов
And предложены 2–3 альтернативы уровня и инструмента
```

**AC-02.2** — фиксация выбора:

```gherkin
Given пользователь выбрал уровень и инструмент
When skill сохраняет ответ
Then строка фазы в profile.md обновляется
And запись альтернатив появляется в decisions.md
```

Трассировка: vision.md §3.7 (скорость↔методичность); принципы 1, 2.

### US-03: Состояние альф как источник истины

- Роль: method-engineer.
- Цель: видеть и продвигать альфы только через агента-трекера.
- Польза: избежать рассинхронизации состояний между агентами.

**AC-03.1** — evidence-gate:

```gherkin
Given альфа готова к переходу
When агент-трекер получает запрос на продвижение
Then он требует evidence-артефакт
And отказывает при его отсутствии
```

**AC-03.2** — единый источник истины:

```gherkin
Given другие агенты хотят узнать состояние альфы
When они обращаются к данным
Then они запрашивают sdlc-alpha-tracker
And не читают alphas.md напрямую
```

Трассировка: принцип 13.

### US-04: Перенос фокуса внимания

- Роль: systems-thinker.
- Цель: менять целевую систему между уровнями иерархии.
- Польза: переносить анализ на надсистему, подсистемы, окружение.

**AC-04.1** — смена фокуса:

```gherkin
Given выбрана новая целевая система
When запускаю /sdlc-focus <slug>
Then system-context.md обновляет current_focus
And прежняя целевая получает другую роль
```

**AC-04.2** — описание по kind=materialized:

```gherkin
Given система kind=materialized
When /sdlc-focus её регистрирует без --transient
Then создаётся README.sdlc.md рядом с корнем системы
And корневой README.md целевого не изменяется
```

**AC-04.3** — описание по kind=logical:

```gherkin
Given система kind=logical
When /sdlc-focus её регистрирует без --transient
Then создаётся .claude/sdlc/external-systems/<slug>.md
```

Трассировка: vision.md §3.3; принципы 7, 17.

### US-05: Аудит консистентности артефактов

- Роль: method-engineer.
- Цель: находить расхождения между артефактами автоматически и вручную.
- Польза: поддерживать сквозную согласованность SDLC.

**AC-05.1** — ручной запуск:

```gherkin
Given артефакты SDLC существуют в .claude/sdlc/
When запускаю /sdlc-audit
Then sdlc-consistency-auditor формирует audit.md
And каждое расхождение сопровождается 2-3 альтернативами фикса
```

**AC-05.2** — PostToolUse hook:

```gherkin
Given произошла запись в .claude/sdlc/**
When PostToolUse триггер срабатывает
Then аудитор запускается асинхронно
And блокирует противоречивые записи
```

Трассировка: принципы 1, 13.

### US-06: Журнал эволюции принципов через memom

- Роль: method-engineer.
- Цель: вести журнал изменений принципов плагина.
- Польза: отслеживать эволюцию метода с мотивами.

**AC-06.1** — pre-commit блокировка:

```gherkin
Given правка CLAUDE.md плагина
When отсутствует соответствующая запись в memom.md
Then pre-commit hook блокирует коммит
And выдаёт сообщение с требуемым форматом записи
```

Трассировка: принцип 15.

### US-07: README per система внимания

- Роль: systems-thinker.
- Цель: иметь описание каждой системы внимания.
- Польза: видеть границы, роли, связанные альфы.

**AC-07.1** — TTL и понижение приоритета:

```gherkin
Given last_focused_at системы старше system_readme_ttl_days
When sdlc-consistency-auditor проверяет артефакты
Then расхождения по системе получают пониженный приоритет
```

**AC-07.2** — архивирование:

```gherkin
Given пользователь запускает /sdlc-focus --retire <slug>
When система попадает в архив
Then её описание перемещается в retired-systems/<slug>.md
```

Трассировка: принцип 17.

### US-08: Инвентарь публичной поверхности плагина

- Роль: method-engineer.
- Цель: держать README плагина синхронным с инвентарём.
- Польза: переименования skills/commands/agents не теряются.

**AC-08.1** — проверка инвентаря:

```gherkin
Given изменение структуры skills/commands/agents/scripts
When выполняется check-readme-inventory.sh
Then имена в README сверяются с файлами
And расхождение блокирует pre-commit
```

Трассировка: принцип 16.

## 4. Трассируемость

- `traces_from`: [`vision.md`](../vision/vision.md).
- `traces_to`: `.claude/sdlc/phases/architecture/` (будет создан).
- Backlog: GitHub Issues с label `requirement`.
- Синхронизация backlog: через MCP github.
- Каждая US привязана к принципам из CLAUDE.md плагина.

## 5. Критерии готовности фазы

- Минимум 5 US покрывают MVP Волны 2.
- Каждая US содержит роль/цель/пользу и минимум одно AC.
- Каждая US имеет трассировку на vision или принцип.
- Альфа Requirements достигла состояния Bounded.
- Альфа Stakeholders достигла состояния Involved.
- Backlog-стратегия зафиксирована здесь и в plugin-config.md.

## 6. Открытые вопросы

- Перенос US-01…US-08 в GitHub Issues — отдельная задача.
- Non-functional requirements не зафиксированы явно.
- Приоритеты MVP Волны 2 против беклога Волны 3 нужно решить.
