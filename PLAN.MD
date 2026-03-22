# AI-driven SDLC Plugin · Plan создания

## Целевая система

**Что создаётся:**
Claude Code Plugin — система создания IT-продуктов
по методу AI-driven SDLC / Continuous Everything.

**Надсистема:**
Claude Code runtime + экосистема разработчиков.

**Лабораторная модель:**
Plugin создаётся с его же помощью
и тестируется на iGaming Platform.

---

## Первые принципы плагина (инварианты)

| ID | Принцип | Нарушение выглядит как |
|---|---|---|
| **P-A** | Система создания определяет качество ЦС | SKILL.md написан «наугад», без метода |
| **P-B** | Каждый SKILL.md = viewpoint по ISO 42010 | SKILL без явного concern и viewpoint |
| **P-C** | Метод соразмерен сложности | Один SKILL для pet и enterprise |
| **P-D** | Каждое изменение плагина — умная мутация мемома | Правка SKILL без DRR и git-коммита |
| **P-E** | Агент выполняет роль по методу, не по интуиции | Агент без загруженного SKILL работает |

---

## Структура репозитория плагина
```
ai-sdlc-plugin/
├── .claude-plugin/
│   └── plugin.json              # манифест плагина
├── skills/
│   ├── fpf-thinking/
│   │   └── SKILL.md
│   ├── systems-thinking/
│   │   └── SKILL.md
│   ├── add3-workflow/
│   │   └── SKILL.md
│   ├── tdd-workflow/
│   │   └── SKILL.md
│   ├── ce-workflow/
│   │   └── SKILL.md
│   └── adaptive-context/
│       └── SKILL.md
├── agents/
│   ├── architect.md
│   ├── adr-reviewer.md
│   └── tdd-subagent.md
├── commands/
│   ├── vision.md
│   ├── arch.md
│   ├── adr.md
│   ├── tdd.md
│   ├── deploy.md
│   └── ff.md
├── hooks/
│   └── settings.json            # pre-commit fitness gate
├── adr/
│   ├── adr-001-skill-loading-order.md
│   ├── adr-002-adaptive-context-logic.md
│   └── adr-003-human-loop-matrix.md
├── CLAUDE.md                    # мемом системы создания плагина
└── README.md
```

---

## Шаг 0 · Подготовка · Принцип почтальона

**Цель:** точно адресовать ЦС до начала разработки.

**Артефакт:** `adr/adr-000-target-system.md`
```markdown
# ADR-000 · Целевая система плагина

**Concern:** что именно создаётся
**Decision:** Claude Code Plugin для AI-driven SDLC
**Полное имя ЦС:**
  Multi-phase adaptive Claude Code Plugin
  для AI-driven SDLC / Continuous Everything,
  покрывающий Vision → Ops → Evo-time,
  адаптирующийся под pet / mid / enterprise,
  с настраиваемым human in/on/out of the loop.
**Надсистема:** процесс разработки команды
  использующей Claude Code
**Fitness condition:**
  плагин используется командой автора
  для создания iGaming Platform
  и производит рабочие артефакты (ADR, тесты, код)
```

**Результат:** адрес ЦС однозначен.
Можно двигаться дальше.

---

## Шаг 1 · CLAUDE.md · Мемом системы создания

**Цель:** зафиксировать инварианты разработки плагина.
Это первый детерминированный артефакт —
загружается в каждую сессию автоматически.

**Файл:** `CLAUDE.md`
```markdown
# AI-driven SDLC Plugin · System Context

## Target System
Multi-phase adaptive Claude Code Plugin
для AI-driven SDLC / Continuous Everything.

## Invariants (всегда соблюдаются)
- Каждый SKILL.md = viewpoint по ISO 42010
- Каждое изменение SKILL = умная мутация мемома + DRR
- ADR создаётся до кода, не после
- Тест создаётся до реализации (TDD)
- Принцип почтальона: ЦС названа точно

## Plugin Architecture
- skills/ — viewpoints (SKILL.md)
- agents/ — subagent definitions
- commands/ — slash command entry points
- hooks/ — deterministic fitness gates
- adr/ — all architectural decisions

## Working Method
1. Перед любым изменением — создай DRR
2. Перед любым SKILL — определи concern и viewpoint
3. Перед любым кодом — создай тест (RED)
4. После изменения — обнови ADR если нужно
```

**Fitness:** CLAUDE.md зафиксирован в git
→ мемом СС существует.

---

## Шаг 2 · Utility Tree плагина · ADD 3.0

**Цель:** определить quality attributes плагина
до начала проектирования SKILL.md.

**Сессия:** `/arch` + `add3-workflow` SKILL
```markdown
# Utility Tree · AI-driven SDLC Plugin

## Usability (Human-loop friendliness)
- scenario: разработчик запускает /vision
  и получает системную модель за < 5 мин
  без предварительного изучения документации
- метрика: time-to-first-ADR < 10 мин
  для нового пользователя

## Adaptability (SME-матрица)
- scenario: плагин определяет уровень сложности
  проекта и активирует правильный набор методов
  без ручной настройки
- метрика: 0 manual config steps
  для смены pet → mid → enterprise

## Auditability (трейсинг)
- scenario: для любого ADR в проекте
  можно восстановить concern → decision → код
- метрика: 100% ADR содержат
  problem frame + rationale + consequences

## Evolvability (CE)
- scenario: новый SKILL.md добавляется
  по DRR-процессу без изменения
  существующих SKILL.md
- метрика: добавление нового SKILL
  не ломает существующие тесты плагина
```

**Артефакт:** `adr/adr-001-utility-tree.md`

---

## Шаг 3 · Архитектурные решения · ADR

**Цель:** принять 3 ключевых архитектурных решения
до написания первого SKILL.md.

### ADR-002 · Порядок загрузки SKILL.md
```markdown
# ADR-002 · SKILL Loading Order

**Concern:** в каком порядке агент загружает SKILL.md
**Quality attribute:** Auditability (P2W chain)

**Decision:**
fpf-thinking → systems-thinking → add3-workflow
→ tdd-workflow → ce-workflow → adaptive-context

**Rationale:**
Каждый следующий SKILL использует понятия
предыдущего. Нарушение порядка = нарушение P2W.
fpf-thinking задаёт first principles —
должен быть первым.

**Consequences:**
adaptive-context всегда последний —
знает все методы и выбирает подходящий.
```

### ADR-003 · Human loop матрица
```markdown
# ADR-003 · Human Loop Matrix

**Concern:** когда агент автономен, когда нет
**Quality attribute:** Safety + Usability

**Decision:**
Vision, Architecture: всегда in the loop
Development: on the loop (subagents мониторятся)
Testing (auto): out of the loop
Fitness нарушена: in the loop
Умная мутация мемома: всегда in the loop

**Rationale:**
Стоимость ошибки определяет human loop.
Архитектурные решения необратимы → in.
Авто-тесты обратимы → out.

**Consequences:**
Hooks блокируют деплой при нарушении fitness.
Slash команды = явная передача управления.
```

### ADR-004 · Adaptive context logic
```markdown
# ADR-004 · Adaptive Context Detection

**Concern:** как определять уровень сложности проекта
**Quality attribute:** Adaptability

**Decision:**
adaptive-context SKILL анализирует:
- наличие существующей кодовой базы
- количество стейкхолдеров в системной модели
- наличие compliance требований
- размер команды (из CLAUDE.md)
→ возвращает: pet | mid | enterprise

**Consequences:**
enterprise → ADD 3.0 + TOGAF + ATAM
mid → C4 + arc42 + ADR
pet → napkin sketch + минимальные тесты
```

---

## Шаг 4 · SKILL.md · Порядок создания

**Правило:** каждый SKILL.md создаётся по шаблону DRR.
**Порядок создания = порядок P2W стека.**

---

### SKILL 1 · fpf-thinking

**Concern:** агент нуждается в first principles
перед любой декомпозицией

**Файл:** `skills/fpf-thinking/SKILL.md`
```yaml
---
name: fpf-thinking
description: >
  Use before any architectural decision, system
  decomposition, or SDLC phase transition.
  Activates when user asks 'why', 'what first',
  'from first principles', or starts a new project.
---
```

**Содержимое SKILL:**
```markdown
# FPF Thinking · First Principles Framework

## When activated
Before any decision: build P2W chain first.
P-A..E are invariants — check against them.

## P2W Chain (always explicit)
1. First principle (P-A..E или бизнес-инвариант)
2. Method of thinking (ST / FPF)
3. Method of description (ISO 42010 / ADD 3.0)
4. Tool (SKILL.md / Claude Code)
5. Work (конкретная сессия)
6. Artifact (ADR / тест / код)

## Checks before any decision
- [ ] Целевая система названа по принципу почтальона?
- [ ] Какой first principle здесь задействован?
- [ ] Это решение или наблюдение?
- [ ] Если решение — нужен DRR?

## DRR template (для каждого изменения мемома)
Problem frame: [почему это важно]
Decision: [что именно]
Rationale: [проверка против P-A..E]
Consequences: [что изменится]
```

---

### SKILL 2 · systems-thinking

**Concern:** агент нуждается в онтологии систем
для фаз Vision и Requirements

**Файл:** `skills/systems-thinking/SKILL.md`
```yaml
---
name: systems-thinking
description: >
  Use for Vision, Requirements, stakeholder analysis.
  Activates when user mentions 'system', 'stakeholders',
  'what are we building', 'context', 'надсистема'.
---
```

**Содержимое SKILL:**
```markdown
# Systems Thinking · Levenchuk Ontology

## Core questions (задай последовательно)
1. Что является целевой системой?
   (принцип почтальона — уровень за уровнем)
2. Кто стейкхолдеры и каковы их concerns?
3. Что является надсистемой?
4. Что является системой создания?
5. Каковы DVS и OVS?

## Мемом / Феном
- Мемом: git-репозиторий, ADR, SRS, тесты
- Феном: working system in production
- Architectural drift = мемом ≠ феном

## Three times CE
- Ops-time: феном в production
- Dev-time: мемом → феном
- Evo-time: умные мутации мемома

## Artifacts
- system-context.md: ЦС + надсистема + СС
- stakeholder-map.md: роли + concerns + preferences
- bounded-context.md: границы системы
```

---

### SKILL 3 · add3-workflow

**Concern:** агент нуждается в методе принятия
архитектурных решений с трейсингом

**Файл:** `skills/add3-workflow/SKILL.md`
```yaml
---
name: add3-workflow
description: >
  Use for Architecture phase, design decisions,
  quality attributes. Activates when user mentions
  'architecture', 'ADR', 'quality attributes',
  'design decision', 'trade-off'.
---
```

**Содержимое SKILL:**
```markdown
# ADD 3.0 · Attribute-Driven Design Workflow

## Process (итерация ADD 3.0)
1. Build Utility Tree
   бизнес-цель → QA → scenario → метрика
2. Identify architectural drivers
   (high importance + high difficulty)
3. Choose design concept
   generate 2-3 alternatives + trade-off table
4. Create ADR (DRR structure)
5. Sketch views (C4 / arc42 as appropriate)
6. Review: all drivers addressed?
   If no → next iteration

## ADR Template
```
# ADR-NNN · [title]

**Concern:** [QA scenario из Utility Tree]
**Quality attribute:** [performance/security/etc]

**Decision:** [что именно]

**Rationale:**
- Alternative A: [pros/cons]
- Alternative B: [pros/cons]
- Chosen because: [аргумент]
- Checks: P-A [ ] P-B [ ] P-C [ ] P-D [ ] P-E [ ]

**Consequences:**
- Positive: [что улучшится]
- Negative: [что усложнится]
- Fitness function: [как проверить автоматически]
```

## ISO 42010 mapping
- Concern → Stakeholder interest
- Viewpoint → этот SKILL.md
- View → созданный ADR
```

---

### SKILL 4 · tdd-workflow

**Concern:** агент нуждается в методе реализации
с тестом как спецификацией

**Файл:** `skills/tdd-workflow/SKILL.md`
```yaml
---
name: tdd-workflow
description: >
  Use for Development phase. Activates when user
  mentions 'implement', 'code', 'write', 'build',
  'feature', 'test'. Always Red before Green.
---
```

**Содержимое SKILL:**
```markdown
# TDD Workflow · Test-Driven Development

## Mandatory sequence (no exceptions)
1. READ the ADR for this feature
2. WRITE test from acceptance criteria (RED)
3. VERIFY test fails (if passes → wrong test)
4. IMPLEMENT minimum code to pass (GREEN)
5. REFACTOR (tests stay green)
6. COMMIT with ADR reference

## Test = Formalized functional object (IEC)
- Test name = functional object name
- Given/When/Then = system behavior spec
- Test suite = мемом поведения системы

## Subagent pattern
- One subagent = one task from ADR
- Subagent reads: ADR + acceptance criteria
- Subagent produces: test + implementation
- Human: on the loop, monitors ADR drift

## Red → ADR drift check
If test is hard to write →
probably acceptance criteria are wrong →
go back to ADR, not forward to code
```

---

### SKILL 5 · ce-workflow

**Concern:** агент нуждается в методе
Continuous Everything для фаз Deployment и Ops

**Файл:** `skills/ce-workflow/SKILL.md`
```yaml
---
name: ce-workflow
description: >
  Use for Deployment, Operations, evolution.
  Activates when user mentions 'deploy', 'production',
  'fitness', 'drift', 'mutation', 'ops', 'monitor'.
---
```

**Содержимое SKILL:**
```markdown
# Continuous Everything · Canonical Evolution Loop

## Three times
- Ops-time: observe феном (metrics, incidents)
- Evo-time: smart mutation of мемом (DRR → new ADR)
- Dev-time: мемом → new феном

## Fitness Function generation
For each ADR:
1. Extract the key constraint
2. Write automated check
3. Register as Hook (PreToolUse or CI step)
4. Document: ADR-NNN → fitness-NNN.test

## Canonical Evolution Loop trigger
Signal: fitness function failure OR new opportunity
→ Create DRR (not hotfix)
→ New ADR or update existing
→ New SKILL.md if method changes
→ Dev-time cycle
→ Back to Ops-time

## Hotfix policy
Hotfix без DRR = нарушение P-D
Всегда: hotfix + DRR + ADR update в одном PR
```

---

### SKILL 6 · adaptive-context

**Concern:** агент нуждается в выборе правильного
метода под сложность системы

**Файл:** `skills/adaptive-context/SKILL.md`
```yaml
---
name: adaptive-context
description: >
  Always loaded last. Determines project complexity
  and selects appropriate methods from SME matrix.
  Activates automatically at session start.
---
```

**Содержимое SKILL:**
```markdown
# Adaptive Context · Situational Method Engineering

## Complexity detection
Analyze project context:
- Existing codebase? (brownfield signals)
- Stakeholder count in system-context.md?
- Compliance requirements? (GDPR, PCI, etc)
- Team size from CLAUDE.md?

→ pet: 1 developer, no compliance, greenfield
→ mid: 2-10 developers, some NFR, existing code
→ enterprise: 10+ / compliance / multi-tenant

## Method matrix (select per phase)

| Phase | Pet | Mid | Enterprise |
|---|---|---|---|
| Vision | napkin sketch | Lean Canvas | TOGAF BA |
| Requirements | user stories | BDD + MoSCoW | QAW + Utility Tree |
| Architecture | patterns | C4 + ADR | ADD 3.0 + arc42 |
| Development | just code | TDD + BDD | TDD + Contract Testing |
| Testing | smoke | unit/integration/E2E | ATAM + Chaos |
| Deployment | manual | CI/CD + Blue-Green | GitOps + Canary |
| Ops | fix when broken | SLO + Grafana | SRE + AIOps |

## Human loop matrix (select per phase + complexity)

| Phase | Pet | Mid | Enterprise |
|---|---|---|---|
| Vision | in | in | in |
| Requirements | in | in/on | in |
| Architecture | in | in | in |
| Development | out | on | on |
| Testing | out | out | on/in |
| Deployment | out | out/on | in/on |
| Ops & Evo | out | on | on/in |
```

---

## Шаг 5 · Slash Commands · Точки входа в фазы

**Правило:** каждая команда = явная передача
управления от человека агенту.

**Файл:** `commands/vision.md`
```markdown
---
description: Start Vision phase.
  Activates systems-thinking + fpf-thinking skills.
  Creates system-context.md and stakeholder-map.md.
---

# /vision

Запускаю фазу Vision.

1. Активирую fpf-thinking — строю P2W chain
2. Задаю вопросы по принципу почтальона:
   - Что является целевой системой?
   - Кто надсистема?
   - Кто стейкхолдеры и их concerns?
3. Создаю system-context.md
4. Создаю stakeholder-map.md
5. Запрашиваю подтверждение у человека
   (Human in the loop — решение необратимо)
```

**Аналогично создаются:**
- `commands/arch.md` → запуск ADD 3.0 сессии
- `commands/adr.md` → создание одного ADR
- `commands/tdd.md` → запуск TDD-цикла через subagent
- `commands/deploy.md` → подготовка deployment strategy
- `commands/ff.md` → генерация fitness function из ADR

---

## Шаг 6 · Hooks · Детерминированные quality gates

**Правило:** hooks = fitness functions.
Правила безопасности — только через hooks,
не через SKILL.md (SKILL вероятностный, hook — нет).

**Файл:** `.claude/settings.json`
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(git commit*)",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/pre-commit-fitness.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-edit-lint.sh"
          }
        ]
      }
    ]
  }
}
```

**Файл:** `.claude/hooks/pre-commit-fitness.sh`
```bash
#!/bin/bash
# Fitness gate: блокирует коммит если тесты красные
# Exit code 2 = PreToolUse block (Claude Code protocol)

echo "Running fitness checks..."

# Run all fitness functions linked to ADRs
pytest tests/fitness/ -q

if [ $? -ne 0 ]; then
  echo "BLOCKED: Fitness functions failed."
  echo "Fix tests before committing."
  echo "ADR drift detected — review your changes."
  exit 2
fi

echo "All fitness checks passed. Proceeding."
exit 0
```

**DRR для каждого hook:**
```markdown
# DRR · pre-commit-fitness hook

Problem: код может нарушить архитектурные инварианты
         без автоматической проверки
Decision: PreToolUse hook блокирует коммит
          при красных fitness tests
Rationale: Hooks детерминированы — гарантия 100%.
           SKILL.md вероятностен — гарантии нет (P-B).
Consequences: нельзя закоммитить сломанный код,
              но и нельзя закоммитить без тестов
```

---

## Шаг 7 · Agents · Субагенты для параллельной работы

**Файл:** `agents/tdd-subagent.md`
```markdown
---
name: tdd-subagent
description: >
  Specialized agent for TDD implementation.
  Use when a single task from ADR needs
  test + implementation in isolated context.
agent: general-purpose
---

# TDD Subagent

## Input required
- ADR reference (e.g. adr/adr-003.md)
- Single acceptance criteria (one scenario)
- Target file path

## Process
1. Read ADR and extract acceptance criteria
2. Write test file (RED — must fail)
3. Report: "Test written. Waiting for approval."
4. After human approval: implement (GREEN)
5. Refactor if needed
6. Report: "Implementation complete. Tests green."

## Constraints
- One task at a time
- Never modify other test files
- Never skip RED phase
- If ADR is unclear → report back, don't assume
```

---

## Шаг 8 · plugin.json · Манифест

**Файл:** `.claude-plugin/plugin.json`
```json
{
  "name": "ai-sdlc-plugin",
  "description": "AI-driven SDLC / Continuous Everything. From Vision to Ops-time. Adaptive: pet project → enterprise. Human in/on/out of the loop per phase.",
  "version": "0.1.0",
  "author": {
    "name": "Полосов Юрий",
    "github": "github.com/[username]"
  },
  "homepage": "github.com/[username]/ai-sdlc-plugin",
  "license": "MIT"
}
```

---

## Шаг 9 · Hello-world smoke test · iGaming Platform

**Цель:** проверить что плагин работает
на реальном проекте end-to-end.

**Сценарий:** создать минимальный iGaming Platform
tenant с одним ADR и одной fitness function.
```bash
# 1. Установка плагина
claude /plugin install ai-sdlc-plugin

# 2. Инициализация проекта
mkdir igaming-platform && cd igaming-platform
claude

# 3. Запуск Vision фазы
/vision
# → агент задаёт вопросы по принципу почтальона
# → человек подтверждает системную модель
# → создаётся system-context.md

# 4. Запуск Architecture фазы
/arch
# → агент строит Utility Tree
# → предлагает ADR-001: multi-tenant isolation
# → человек sign-off

# 5. Создание fitness function
/ff adr-001
# → агент генерирует test_tenant_isolation.py
# → регистрирует hook

# 6. TDD-цикл
/tdd adr-001
# → subagent: RED → реализация → GREEN

# 7. Проверка fitness gate
git add . && git commit -m "feat: tenant isolation"
# → hook запускает fitness tests
# → если GREEN: коммит проходит
# → если RED: коммит заблокирован
```

**Fitness condition demo пройдено:**
- Принцип почтальона: ЦС названа точно ✓
- ADR создан до кода ✓
- Тест создан до реализации ✓
- Fitness hook зарегистрирован ✓
- Полный P2W виден в git history ✓

---

## Шаг 10 · Canonical Evolution Loop плагина

**Цель:** первая умная мутация мемома
после реального использования на iGaming Platform.
```markdown
# DRR · первая умная мутация плагина

Problem frame:
  При работе с iGaming Platform выявлено:
  add3-workflow не покрывает compliance concerns
  (GDPR, gambling regulations)
  как отдельный quality attribute.

Decision:
  Добавить iGaming-compliance concern
  в Utility Tree template в add3-workflow SKILL.

Rationale:
  ISO 42010: compliance — отдельный concern
  с отдельным viewpoint (regulatory frameworks).
  Без него ADR по compliance создаются
  без явного трейса до concern (P-B нарушен).

Consequences:
  Обновляется skills/add3-workflow/SKILL.md.
  Добавляется compliance section в ADR template.
  Существующие ADR не ломаются (backward compatible).
```

**Артефакт:** обновлённый `add3-workflow/SKILL.md`
+ новый `adr/adr-005-compliance-concern.md`
+ git commit с DRR reference

---

## Альфы плагина · текущие состояния

| Альфа | Текущее состояние | Следующее |
|---|---|---|
| Целевая система плагина | ✅ концепция ясна | → спроектирована |
| Utility Tree | ✅ создан (Шаг 2) | → ADR покрывают все drivers |
| SKILL.md library | 🔄 создаются (Шаги 4-6) | → стабильны |
| Hooks / fitness gates | ⬜ не создан | → зарегистрированы |
| Hello-world iGaming demo | ⬜ не запущен | → smoke test пройден |
| Первая умная мутация | ⬜ не выполнена | → DRR + обновление SKILL |
| Опубликован в marketplace | ⬜ | → установлен другими |

---

## Definition of Done · плагин готов когда

- [ ] Все 6 SKILL.md написаны по DRR + viewpoint шаблону
- [ ] Все 6 slash commands работают
- [ ] pre-commit fitness hook блокирует красные тесты
- [ ] iGaming Platform hello-world: полный P2W за < 15 мин
- [ ] Первая умная мутация выполнена через реальный опыт
- [ ] README содержит: install → first session → P2W example
- [ ] Все ADR в git с полным трейсингом
- [ ] plugin.json опубликован в Claude marketplace