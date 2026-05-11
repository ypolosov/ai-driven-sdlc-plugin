# ai-driven-sdlc

Методологический каркас на Claude Code для ведения разработки любой IT-системы.
Плагин technology-agnostic; выбор уровня сложности и инструментов — за пользователем.
Решения фиксируются как артефакты Claude Code в целевом проекте, не в плагине.

## Статус

Текущая версия: **v0.11.0** (май 2026).
Волны 1–8 закрыты; Wave 4 multi-agent extension; Wave 5 sdlc-state-rag; Wave 6 pre-validation fixes; Wave 7 closed 5 issues (#54-#58); Wave 8 closed 4 P2 issues (#59, #60, #61, #69).
Альфа Software System: **Usable** — плагин устанавливается через marketplace.
Альфа Way of Working: **Working Well** — fitness 9 hooks <200ms; самоприменение SDLC.
Конституция плагина: 22 принципа + 4a + 19a (24 секции в [CLAUDE.md](CLAUDE.md): 1–22 пронумерованы, 4a и 19a как sub-clauses).

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
- `@ypolosov/sdlc-state-rag` — единый backend альф + RAG + decisions + audit + sync (см. ADR-011, Волна 5). **Установка обязательна:** `npm install -g @ypolosov/sdlc-state-rag` (минимум v0.1.1; npx-cold-fetch медленнее MCP health-check таймаута).

Плагин не ship'ит собственный `context7` — используйте dedicated плагин.
Плагин ship'ит минимальный `github` MCP в `.mcp.json` как fallback.
Плагин ship'ит запись `sdlc-state-rag` в `.mcp.json`; backend per-target через `${SDLC_STATE_RAG_DSN}` из `<target>/.env`.

Логика OMG Essence 1.2 state machine реализована **внутри** `sdlc-state-rag` (TypeScript).

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

### Scripts (19)
- `validate-artifact.sh` — frontmatter, секции, ≤15 слов, русский.
- `enforce-tdd.sh` — мягкая блокировка записи кода без парного теста.
- `enforce-format-lint.sh` — диспетчер форматера и линтера из `plugin-config.md`.
- `enforce-no-comments.sh` — запрет комментариев в коде.
- `check-cross-refs.sh` — детерминированная проверка осиротевших ссылок.
- `check-readme-inventory.sh` — сверка имён в README плагина со структурой (Волна 2).
- `check-system-readmes.sh` — инвентарь описаний систем внимания в целевом (Волна 2).
- `check-memom-consistency.sh` — блокирует изменение принципов без записи в memom (Волна 2).
- `check-alpha-consistency.sh` — валидирует БД sdlc-state-rag при записи snapshot (Волна 5).
- `bootstrap-target.sh` — инициализация целевого, режимы `--fail-if-exists` / `--merge` / `--force`.
- `bench-hooks.sh` — бенчмарк 9 детерминированных hooks (NFR hooks-performance).
- `bootstrap-dev-env.sh` — детектит pkg-manager и выводит команду установки bats/shellcheck/shfmt.
- `check-tool-binding.sh` — валидирует категории `tool-bindings.md` целевого (Волна 4).
- `detect-credentials.sh` — проверяет `.env` и обязательные ключи привязок (Волна 4).
- `check-rag-config.sh` — валидирует `rag-config.md` целевого и worker.kind ↔ SME (Волна 5, ADR-012).
- `migrate-essence-to-state-rag.sh` — разовая миграция dogfooding с `--dry-run` / `--verify` / `--exec` (Волна 5, PR-H).
- `enforce-sdlc-phase.sh` — PreToolUse hook принципа 22; блокирует git/gh/npm write-команды и Edit/Write без `active_phase` (Волна 5, v0.5.0).
- `launch-sdlc-state-rag.sh` — launcher MCP-сервера sdlc-state-rag с fallback PATH→nvm→standard locations→npx (v0.5.2).
- `check-adr-paths.sh` — валидирует `adr_paths` в `plugin-config.md` целевого (Волна 6, v0.6.0).

### Meta-templates (26: 21 top + 5 external-systems)
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
- `work-unit.jira.meta.md` — схема work-unit для Jira-managed целевых (Волна 7, v0.9.0, Gap-6).
- `work-unit.linear.meta.md` — схема work-unit для Linear-managed целевых (Волна 7, v0.9.0, Gap-6).
- `work-unit.github.meta.md` — схема work-unit для GitHub Issues-managed целевых (Волна 7, v0.9.0, Gap-6).
- `iteration.meta.md` — схема итерации (kanban-style) для группировки work-units (Wave 8, #61, Gap-8).
- `c4-diagram.meta.md` — схема C4-диаграммы (Context/Container/Component/Code) с поддержкой PlantUML/Structurizr/Mermaid (Wave 8, #60, Gap-7).

#### External-system references (`meta-templates/external-systems/`, Волна 7 v0.10.0)
- `issue-tracker.jira.md` — Atlassian Rovo / sooperset/mcp-atlassian.
- `knowledge-base.confluence.md` — единый Atlassian-сервер для Confluence.
- `vcs.bitbucket.md` — Atlassian Rovo / community Bitbucket MCP.
- `observability.grafana.md` — official mcp-grafana (Loki/Prometheus/Tempo).
- `cd-platform.argocd.md` — community argocd-mcp.

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

- Unit (bats-core) — `tests/unit/` (20 файлов, 159 кейсов):
  - `validate-artifact.bats` — 7 кейсов на поведение валидатора.
  - `check-cross-refs.bats` — 6 кейсов на детектор осиротевших ссылок.
  - `enforce-no-comments.bats` — 13 кейсов (TypeScript whitelist Wave 5 + heredoc detection Wave 7).
  - `bootstrap-dev-env.bats` — 3 кейса на детектор пакетного менеджера.
  - `check-alpha-consistency.bats` — 8 кейсов на валидатор БД (DSN/pglite mode discrimination, Wave 8 #69).
  - `check-tool-binding.bats` — 9 кейсов на проверку категорий tool-bindings (Волна 4).
  - `target-roles-schema.bats` — 14 кейсов на схему ролей и target-roles (Волна 4).
  - `detect-credentials.bats` — 6 кейсов на проверку `.env` и обязательных ключей (Волна 4).
  - `check-rag-config.bats` — 8 кейсов на схему rag-config и worker.kind ↔ SME (Волна 5).
  - `migrate-essence-to-state-rag.bats` — 7 кейсов на разовую утилиту миграции (PR-H, Волна 5).
  - `enforce-sdlc-phase.bats` — 12 кейсов на PreToolUse hook принципа 22 (Волна 5 v0.5.0 + realpath fix Wave 7).
  - `init-mcp-json.bats` — 5 кейсов на авто-создание/мердж `.mcp.json` в target (Волна 6, v0.6.0).
  - `plugin-config-adr-paths.bats` — 5 кейсов на валидацию `adr_paths` в plugin-config (Волна 6, v0.6.0).
  - `bootstrap-role-extensions.bats` — 4 кейса на создание `role-extensions.md` placeholder при /sdlc-init (Волна 7, v0.8.0).
  - `work-unit-templates.bats` — 7 кейсов на 3 work-unit meta-templates (Jira/Linear/GitHub) (Волна 7, v0.9.0).
  - `external-systems-references.bats` — 10 кейсов на 5 reference MCP-серверов (Волна 7, v0.10.0).
  - `iteration-template.bats` — 10 кейсов на iteration meta-template (Wave 8, #61, Gap-8).
  - `c4-diagram-template.bats` — 12 кейсов на c4-diagram meta-template + matrix references (Wave 8, #60, Gap-7).
  - `bootstrap-valid-frontmatter.bats` — 8 кейсов на валидные frontmatter из bootstrap (Wave 8, #59, Gap-5).
  - `mcp-json-no-nested-fallback.bats` — 5 кейсов regression на CLAUDE_PLUGIN_ROOT resolve (v0.11.1).
- Integration (bats-core) — `tests/integration/` (3 файла, 47 кейсов):
  - `context-aggregator-mid.bats` — 20 кейсов на топологию aggregator+router и фикстуру `mid-target/` (Волна 4, ADR-010).
  - `sdlc-state-rag-contract.bats` — 23 кейса на контракт sdlc-state-rag, переключение трекера, bash-wrapper для launcher (Волна 5, ADR-011, v0.5.3).
  - `enforce-sdlc-phase-integration.bats` — 4 кейса на e2e блокировку write-команд при отсутствии `active_phase` (Волна 5, принцип 22).
- Фикстуры — `tests/fixture/minimal-target/`, `tests/fixture/mid-target/` (валидные каркасы).
- Статика — `shellcheck` на все скрипты; `shfmt -i 2 -ci` как форматёр.
- CI — `.github/workflows/ci.yml` запускает всё на push/PR.
- Покрыто тестами 11 из 19 скриптов; расширение — backlog Wave 8.

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

- `CLAUDE.md` — конституция плагина (22 принципа + 4a + 19a, 24 секции).
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
