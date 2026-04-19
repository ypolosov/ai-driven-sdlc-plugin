# ai-driven-sdlc

Методологический каркас на Claude Code для ведения разработки любой IT-системы.
Плагин technology-agnostic; выбор уровня сложности и инструментов — за пользователем.
Решения фиксируются как артефакты Claude Code в целевом проекте, не в плагине.

## Статус: Волна 2 (dogfooding-ready)

Принципы 1–17 + 4a.
Волна 1 — каркас для сценария 1 (todo-list).
Волна 2 — memom, README систем внимания, сценарий 2 (dogfooding).

## Опорные источники

- А. Левенчук, «Системное мышление 2024», Том 1 и Том 2 (`~/DEV/BOOKS/`).
- А. Левенчук, «Методология 2025».
- OMG Essence / SEMAT.
- Доклад «AI-driven SDLC» (`/home/ypolosov/DEV/GITS/talk-ai-driven-sdlc`).

## Установка

```bash
/plugin install ai-driven-sdlc@ypolosov/ai-driven-sdlc-plugin
```

Или через локальный marketplace в настройках Claude Code.

## Рекомендуемые MCP-плагины

Плагин использует внешние MCP-серверы для полного функционала:

- `context7@claude-plugins-official` — референсная документация инструментов (обязательно для SME-опроса).
- `github@claude-plugins-official` — GitHub Issues как state_artifact для альфы Work (опционально, mid+).

Плагин не ship'ит собственный `context7` — используйте dedicated плагин.
Плагин ship'ит минимальный `github` MCP в `.mcp.json` как fallback.

## Быстрый старт

1. Открыть целевой проект в Claude Code.
2. Запустить `/sdlc-init` — плагин создаст каркас в `<target>/.claude/sdlc/`.
3. Выбрать роль через `/sdlc-continue` — плагин предложит фазу.
4. Пройти фазу через `/sdlc-phase <name>` — инструменты выбираются интерактивно.
5. Проверить согласованность артефактов через `/sdlc-audit`.

## Инвентарь

### Skills (12)
- `sdlc-bootstrap` — инициализация целевого проекта, выбор профиля.
- `sdlc-focus` — перенос внимания: над/под/окружение/создание.
- `sdlc-autonomy` — установка уровня автономности на задачу/фазу.
- `sdlc-method-engineering` — сквозной SME-опрос для всех фаз.
- `sdlc-audit` — сквозной аудит консистентности артефактов.
- `sdlc-vision` — фаза Vision.
- `sdlc-requirements` — фаза Requirements.
- `sdlc-architecture` — фаза Architecture.
- `sdlc-development` — фаза Development (TDD-first).
- `sdlc-testing` — фаза Testing.
- `sdlc-deployment` — фаза Deployment.
- `sdlc-operations` — фаза Operations.

### Commands (8)
- `/sdlc-init` — bootstrap в целевом проекте.
- `/sdlc-continue` — спросить роль, предложить фазу.
- `/sdlc-focus` — сменить целевую систему внимания.
- `/sdlc-phase` — запустить фазу SDLC.
- `/sdlc-autonomy` — установить HITL / HOTL / HOOTL.
- `/sdlc-status` — показать альфы и профиль.
- `/sdlc-audit` — сквозная проверка консистентности.
- `/sdlc-artifact` — **internal**, вызывается skills, не пользователем.

### Agents (5)
- `sdlc-method-engineer` — подбор метода и инструментов под проект.
- `sdlc-state-reader` — чтение state-артефакта целевого.
- `sdlc-artifact-validator` — механическая валидация одного артефакта.
- `sdlc-consistency-auditor` — сквозная согласованность артефактов.
- `sdlc-alpha-tracker` — единственный источник истины о состоянии альф.

### Scripts (11)
- `validate-artifact.sh` — frontmatter, секции, ≤15 слов, русский.
- `enforce-tdd.sh` — мягкая блокировка записи кода без парного теста.
- `enforce-format-lint.sh` — диспетчер форматера и линтера из `plugin-config.md`.
- `enforce-no-comments.sh` — запрет комментариев в коде.
- `check-cross-refs.sh` — детерминированная проверка осиротевших ссылок.
- `check-readme-inventory.sh` — сверка имён в README плагина со структурой (Волна 2).
- `check-system-readmes.sh` — инвентарь описаний систем внимания в целевом (Волна 2).
- `check-memom-consistency.sh` — блокирует изменение принципов без записи в memom (Волна 2).
- `bootstrap-target.sh` — инициализация целевого, режимы `--fail-if-exists` / `--merge` / `--force`.
- `bench-hooks.sh` — бенчмарк 5 детерминированных hooks (NFR hooks-performance).
- `bootstrap-dev-env.sh` — детектит pkg-manager и выводит команду установки bats/shellcheck/shfmt.

### Meta-templates (11)
- `work-product.meta.md` — базовая схема рабочего продукта.
- `phase-artifact.meta.md` — схема любого артефакта фазы.
- `profile.meta.md` — схема SME-выбора целевого.
- `plugin-config.meta.md` — схема конфига hooks (+TTL в Волне 2).
- `alpha-state.meta.md` — схема журнала альф.
- `system-context.meta.md` — схема фокуса внимания (kind, role_vs_target).
- `roles-state.meta.md` — схема журнала ролей.
- `decisions.meta.md` — схема журнала альтернатив (HOOTL-лог).
- `audit-report.meta.md` — схема отчёта `/sdlc-audit`.
- `system-readme.meta.md` — схема описания системы внимания (Волна 2).
- `credentials.meta.md` — схема `.env.example` + правила `.gitignore`.

### Catalogs (4)
- `catalogs/alphas.md` — определения альф SDLC.
- `catalogs/disciplines.md` — дисциплины, закреплённые за фазами.
- `catalogs/roles.md` — роли и их методы, интересы.
- `catalogs/method-tool-matrix.md` — матрица «метод → примеры инструментов».

### Hooks (1 файл)
- `hooks/hooks.json` — PreToolUse TDD (soft); PostToolUse порядок: validator → check-cross-refs → format/lint → no-comments → check-system-readmes.

### Memom (Волна 2)
- `memom.md` — журнал эволюции принципов плагина (принцип 15).

## Демо-сценарии

Живут отдельно в проекте доклада: `/home/ypolosov/DEV/GITS/talk-ai-driven-sdlc/demo/`.
- `01-target-todo-list.md` — плагин применяется к стороннему проекту `todo-list`.
- `02-dogfooding-extend-plugin.md` — плагин применяется к самому себе (dogfooding).

## Как читать плагин

- `CLAUDE.md` — конституция плагина (13 принципов + 4a).
- `catalogs/**` — терминологический каркас.
- `meta-templates/**` — схемы рабочих продуктов.
- `skills/**/SKILL.md` — методические инструкции фаз и сквозных дисциплин.
- `commands/**.md` — точки входа для пользователя.
- `agents/**.md` — субагенты с изолированным контекстом.
- `scripts/**.sh` — детерминированные проверки.
- `hooks/hooks.json` — порядок срабатывания проверок.

## Правила работы над плагином

- GitHub Flow: feature-ветка → PR → review → merge в main.
- Код без комментариев (принцип 4a).
- Артефакты на русском, каждое утверждение ≤ 15 слов.
- Плагин — не место для конкретных шаблонов инструментов.

## Лицензия

MIT. См. `.claude-plugin/plugin.json`.
