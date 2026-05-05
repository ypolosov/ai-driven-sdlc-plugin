# ai-driven-sdlc

Методологический каркас на Claude Code для ведения разработки любой IT-системы.
Плагин technology-agnostic; выбор уровня сложности и инструментов — за пользователем.
Решения фиксируются как артефакты Claude Code в целевом проекте, не в плагине.

## Статус

Текущая версия: **v0.3.1** (май 2026).
Волны 1–2 закрыты; Волна 3 идёт; Волна 4 (multi-agent extension) развёртывается через PR-цепочку A→G.
Альфа Software System: **Usable** — плагин устанавливается через marketplace.
Альфа Way of Working: **Working Well** — fitness 8 hooks <200ms; самоприменение SDLC.
Конституция плагина: 22 принципа (1–17 + 4a + 18/19/19a Волны 4 + 20/21 Волны 5), см. [CLAUDE.md](CLAUDE.md).

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
Последние релизы — [GitHub Releases](https://github.com/ypolosov/ai-driven-sdlc-plugin/releases).
История версий — [CHANGELOG.md](CHANGELOG.md).

## Рекомендуемые MCP-плагины

Плагин использует внешние MCP-серверы для полного функционала:

- `context7@claude-plugins-official` — референсная документация инструментов (обязательно для SME-опроса).
- `github@claude-plugins-official` — GitHub Issues как state_artifact для альфы Work (опционально, mid+).
- `@ypolosov/sdlc-state-rag` — единый backend альф + RAG + decisions + audit + sync (см. ADR-011, Волна 5).

Плагин не ship'ит собственный `context7` — используйте dedicated плагин.
Плагин ship'ит минимальный `github` MCP в `.mcp.json` как fallback.
Плагин ship'ит запись `sdlc-state-rag` в `.mcp.json`; backend per-target через `${SDLC_STATE_RAG_DSN}` из `<target>/.env`.

`@ypolosov/essence-alpha-mcp` (ADR-009) **deprecated** в Волне 5; superseded by ADR-011.
Логика OMG Essence 1.2 state machine реализована **внутри** `sdlc-state-rag` (TypeScript).
`essence-alpha-mcp` удалён из `.mcp.json` плагина и не рекомендуется новым targets.

## Быстрый старт

1. Открыть целевой проект в Claude Code.
2. Запустить `/sdlc-init` — плагин создаст каркас в `<target>/.claude/sdlc/`.
3. Выбрать роль через `/sdlc-continue` — плагин предложит фазу.
4. Пройти фазу через `/sdlc-phase <name>` — инструменты выбираются интерактивно.
5. Проверить согласованность артефактов через `/sdlc-audit`.

## Инвентарь

### Skills (13)
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
- `sdlc-integrations` — подключение внешних SDLC-инструментов целевого (Волна 4).

### Commands (10)
- `/sdlc-init` — bootstrap в целевом проекте.
- `/sdlc-continue` — спросить роль, предложить фазу.
- `/sdlc-focus` — сменить целевую систему внимания.
- `/sdlc-phase` — запустить фазу SDLC.
- `/sdlc-autonomy` — установить HITL / HOTL / HOOTL.
- `/sdlc-status` — показать альфы и профиль.
- `/sdlc-audit` — сквозная проверка консистентности.
- `/sdlc-artifact` — **internal**, вызывается skills, не пользователем.
- `/sdlc-tools` — управление привязками категорий инструментов (Волна 4).
- `/sdlc-rag` — управление RAG-индексом через sdlc-state-rag (Волна 5).

### Agents (7)
- `sdlc-method-engineer` — подбор метода и инструментов под проект.
- `sdlc-state-reader` — чтение state-артефакта целевого.
- `sdlc-artifact-validator` — механическая валидация одного артефакта.
- `sdlc-consistency-auditor` — сквозная согласованность артефактов.
- `sdlc-alpha-tracker` — единственный источник истины о состоянии альф.
- `sdlc-tool-router` — маршрутизация запросов по категориям к MCP-серверам (Волна 4).
- `sdlc-context-aggregator` — фасад консолидации контекста с провенансом (Волна 4, ADR-010).

### Scripts (17)
- `validate-artifact.sh` — frontmatter, секции, ≤15 слов, русский.
- `enforce-tdd.sh` — мягкая блокировка записи кода без парного теста.
- `enforce-format-lint.sh` — диспетчер форматера и линтера из `plugin-config.md`.
- `enforce-no-comments.sh` — запрет комментариев в коде.
- `check-cross-refs.sh` — детерминированная проверка осиротевших ссылок.
- `check-readme-inventory.sh` — сверка имён в README плагина со структурой (Волна 2).
- `check-system-readmes.sh` — инвентарь описаний систем внимания в целевом (Волна 2).
- `check-memom-consistency.sh` — блокирует изменение принципов без записи в memom (Волна 2).
- `check-alpha-consistency.sh` — валидирует БД sdlc-state-rag при записи snapshot (Волна 5).
- `seed-essence-alpha.sh` — bootstrap БД essence-alpha-mcp (legacy, deprecated).
- `bootstrap-target.sh` — инициализация целевого, режимы `--fail-if-exists` / `--merge` / `--force`.
- `bench-hooks.sh` — бенчмарк 8 детерминированных hooks (NFR hooks-performance).
- `bootstrap-dev-env.sh` — детектит pkg-manager и выводит команду установки bats/shellcheck/shfmt.
- `check-tool-binding.sh` — валидирует категории `tool-bindings.md` целевого (Волна 4).
- `detect-credentials.sh` — проверяет `.env` и обязательные ключи привязок (Волна 4).
- `check-rag-config.sh` — валидирует `rag-config.md` целевого и worker.kind ↔ SME (Волна 5, ADR-012).
- `migrate-essence-to-state-rag.sh` — разовая миграция dogfooding с `--dry-run` / `--verify` / `--exec` (Волна 5, PR-H).

### Meta-templates (16)
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
- `target-roles.meta.md` — схема `role-extensions.md` целевого (Волна 4, ADR-015).
- `tool-binding.meta.md` — схема `tool-bindings.md` целевого (Волна 4, ADR-013).
- `sdlc-state-rag-contract.meta.md` — контракт MCP-сервера sdlc-state-rag (Волна 5, ADR-011).
- `rag-config.meta.md` — схема `rag-config.md` целевого и worker'ов (Волна 5, ADR-012).
- `webhooks.meta.md` — схема `webhooks.md` целевого для enterprise (Волна 5, ADR-014).

### Catalogs (5)
- `catalogs/alphas.md` — определения альф SDLC.
- `catalogs/disciplines.md` — дисциплины, закреплённые за фазами.
- `catalogs/roles.md` — роли и их методы, интересы.
- `catalogs/method-tool-matrix.md` — матрица «метод → примеры инструментов».
- `catalogs/tool-categories.md` — 7 агностических категорий инструментов SDLC (Волна 4, ADR-013).

### Hooks (1 файл)
- `hooks/hooks.json` — PreToolUse TDD (soft); PostToolUse порядок: validator → check-cross-refs → format/lint → no-comments → check-system-readmes → check-alpha-consistency.

### Memom (Волна 2)
- `memom.md` — журнал эволюции принципов плагина (принцип 15).

### GitHub Issue Templates (4)
- `.github/ISSUE_TEMPLATE/bug.yml` — сообщение о баге.
- `.github/ISSUE_TEMPLATE/feature.yml` — предложение функциональности.
- `.github/ISSUE_TEMPLATE/question.yml` — вопрос или уточнение.
- `.github/ISSUE_TEMPLATE/work-unit.yml` — единица работы для альфы Work.

### CI и корневые документы
- `.github/workflows/ci.yml` — один job: bats + shellcheck + shfmt + детерминированные проверки.
- `CHANGELOG.md` — история версий по Keep a Changelog + SemVer.
- `SUPPORT.md` — канал обратной связи и политика ответа.

## Tests & CI

Пирамида автотестов по фазе testing (уровень mid).

- Unit (bats-core) — `tests/unit/` (10 файлов, 73 кейса):
  - `validate-artifact.bats` — 7 кейсов на поведение валидатора.
  - `check-cross-refs.bats` — 6 кейсов на детектор осиротевших ссылок.
  - `enforce-no-comments.bats` — 9 кейсов (включая TypeScript whitelist Wave 5).
  - `bootstrap-dev-env.bats` — 3 кейса на детектор пакетного менеджера.
  - `check-alpha-consistency.bats` — 7 кейсов на валидатор БД (Wave 5: +SDLC_STATE_RAG_VALIDATE_CMD и deprecation).
  - `seed-essence-alpha.bats` — 4 кейса на bootstrap БД через цепочки.
  - `check-tool-binding.bats` — 9 кейсов на проверку категорий tool-bindings (Волна 4).
  - `target-roles-schema.bats` — 14 кейсов на схему ролей и target-roles (Волна 4).
  - `detect-credentials.bats` — 6 кейсов на проверку `.env` и обязательных ключей (Волна 4).
  - `check-rag-config.bats` — 8 кейсов на схему rag-config и worker.kind ↔ SME (Волна 5).
- Integration (bats-core) — `tests/integration/` (2 файла, 40 кейсов):
  - `context-aggregator-mid.bats` — 20 кейсов на топологию aggregator+router и фикстуру `mid-target/` (Волна 4, ADR-010).
  - `sdlc-state-rag-contract.bats` — 20 кейсов на контракт sdlc-state-rag, deprecation ADR-009, переключение трекера (Волна 5, ADR-011).
- Фикстуры — `tests/fixture/minimal-target/`, `tests/fixture/mid-target/` (валидные каркасы).
- Статика — `shellcheck` на все скрипты; `shfmt -i 2 -ci` как форматёр.
- CI — `.github/workflows/ci.yml` запускает всё на push/PR.
- Покрыто тестами 6 из 13 скриптов; расширение — backlog Волны 3.

Подготовка dev-окружения — `bash scripts/bootstrap-dev-env.sh`.

## Backlog и работа

Единица работы — альфа **Work** (Essence).
State-артефакт Work — **GitHub Issues** (решение принципа 9, см. `decisions.md`).

- Шаблон — `.github/ISSUE_TEMPLATE/work-unit.yml`.
- Labels — `work-unit`, `wave-1..5`, `documentation`, `bug`, `feature`, `question`, `epic`, `investigation`.
- Milestones — по волнам: Wave 1 (закрыта), Wave 2 (закрыта), Wave 3 (идёт), Wave 4, Wave 5.
- Backlog — [открытые issues](https://github.com/ypolosov/ai-driven-sdlc-plugin/issues).

Продвижение альфы фиксирует `sdlc-alpha-tracker` с artifact-evidence.

## Поддержка и обратная связь

- Канал 1 — [GitHub Issues](https://github.com/ypolosov/ai-driven-sdlc-plugin/issues) со структурированными yml-шаблонами.
- Канал 2 — email для чувствительных сообщений, см. [SUPPORT.md](SUPPORT.md).
- Политика ответа и SLA — `SUPPORT.md`.
- Известные ограничения и планы — `CHANGELOG.md` секция Unreleased.

## Демо-сценарии

Живут отдельно в проекте доклада: `/home/ypolosov/DEV/GITS/talk-ai-driven-sdlc/demo/`.
- `01-target-todo-list.md` — плагин применяется к стороннему проекту `todo-list`.
- `02-dogfooding-extend-plugin.md` — плагин применяется к самому себе (dogfooding).

Примеры в репозитории плагина:
- `examples/wave-5-enterprise/` — enterprise-target с PgVector + cron + webhooks (Волна 5, ADR-014).

## Как читать плагин

- `CLAUDE.md` — конституция плагина (17 принципов + 4a).
- `catalogs/**` — терминологический каркас.
- `meta-templates/**` — схемы рабочих продуктов.
- `skills/**/SKILL.md` — методические инструкции фаз и сквозных дисциплин.
- `commands/**.md` — точки входа для пользователя.
- `agents/**.md` — субагенты с изолированным контекстом.
- `scripts/**.sh` — детерминированные проверки.
- `hooks/hooks.json` — порядок срабатывания проверок.
- `.claude/sdlc/**` — артефакты SDLC самого плагина (dogfooding, принцип 12).

## Правила работы над плагином

- GitHub Flow: feature-ветка → PR → review → merge в main.
- Код без комментариев (принцип 4a).
- Артефакты на русском, каждое утверждение ≤ 15 слов.
- Плагин — не место для конкретных шаблонов инструментов.
- Изменение принципа в `CLAUDE.md` требует записи в `memom.md` (принцип 15).
- Изменение публичной поверхности требует обновления README в том же коммите (принцип 16).

## Лицензия

MIT. См. `.claude-plugin/plugin.json`.
