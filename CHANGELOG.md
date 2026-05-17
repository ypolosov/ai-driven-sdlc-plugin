# Changelog

Формат соответствует [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/).
Версионирование следует [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

## [0.15.0] — 2026-05-17

### Added

- **B1.2** (#82) — `bootstrap-target.sh` создаёт `tool-bindings.md` skeleton (7 категорий из `catalogs/tool-categories.md`, все `verified: false`, `mcp_server: TODO`). Устраняет orphan-ссылку `plugin-config.md → tool-bindings.md`; `sdlc-tool-router` больше не refuse сразу после bootstrap.
- **B1.3** (#82) — `bootstrap-target.sh` `.env.example` содержит `SDLC_STATE_RAG_DSN` + category-level placeholder'ы (`TOOL_*_TOKEN`) вместо одного комментария.

### Changed

- **B6.1** (#82) — `system-context.meta.md` вводит ось `axis: functional | constructive` (Левенчук Том 2 гл.7); явное предупреждение «`backend`/`frontend`/`devops` — конструктивы, не функциональные подсистемы»; `subsystem` обязан объявить `axis`. Устраняет аудит-находку A1.
- **B3.4** (#82) — `sdlc-bootstrap/SKILL.md` шаг 10: provenance-маркировка seed-значений (`catalog:<файл:строка>` / `user-decision` / `TODO-no-provenance`); запрет выдумывать значения при недоступном MCP/RAG (принцип 19a, A5).
- **B2.5** (#82) — `sdlc-bootstrap/SKILL.md`: enterprise SME-выбор фиксируется как `proposal` со статусом «требует подтверждения команды»; Stakeholders не достигает `In Agreement` без team-review (Essence, A7).

### Rationale

Wave 12 закрывает оставшиеся 5 находок #82 (B1.2/B1.3/B6.1/B3.4/B2.5) — bootstrap-полнота + методологическая корректность. После Wave 10-12 закрыто 12 пунктов; bootstrap для GromTech enterprise полностью готов. TDD-first: 15 новых bats-кейсов (red→green), 0 регрессий из 258.

## [0.14.0] — 2026-05-17

### Added

- **B0.5** (#82) — `scripts/check-bootstrap-preconditions.sh` (21-й script) — Этап-0 read-only gate: блокирует `.env` уже в git tracking (утечка credentials), info про существующий `.mcp.json` (backup B0.6) и `.claude/sdlc` (выбор режима), WARN если не git-репо. Ссылка из `sdlc-bootstrap/SKILL.md` как Шаг -1.

### Changed

- **B0.4** (#82) — `skills/sdlc-bootstrap/SKILL.md` дифференцирует greenfield/brownfield: добавлен вопрос #2 (зрелость), секция «Альфы которые продвигает» разделена (greenfield — начальные состояния; brownfield — фактические по опросу/RAG, запрет регресса ниже реальности — Essence), шаг 5 протокола больше не предписывает безусловно «все альфы в начальном состоянии». Устраняет методологический корень аудита A2/A3/A8 (live-продукт seed как стартап).

### Rationale

Wave 11 закрывает 2 находки 3-раундового аудита #82: B0.4 (методологический корень — bootstrap не различал greenfield/brownfield) + B0.5 (дешёвый Этап-0 guard перед созданием артефактов). Без B0.4 bootstrap GromTech (live gambling-платформа) зафиксировал бы ложную модель зрелого продукта как стартапа, наследуемую всеми фазами. TDD-first: 12 новых bats-кейсов (red→green), 0 регрессий из 243.

## [0.13.0] — 2026-05-17

### Fixed

- **B0.1** (#82) — `bootstrap-target.sh` пишет `active_phase: null` + `active_phase_set_at: null` явно в `profile.md`; success message инструктирует next-step (`/sdlc-phase`, `/sdlc-tools`) и предупреждает про `enforce-sdlc-phase` hook. Раньше отсутствие `active_phase` блокировало любой write после bootstrap.
- **B0.2** (#82) — дефолт `alphas.md` теперь `type: alpha-journal` (markdown — source of truth), без `source_of_truth: mcp://`/`snapshot_role`; тело следует schema `alpha-state.meta.md` (Section 1 таблица альф + Section 2 журнал). `check-alpha-consistency.sh` early-exit для `alpha-journal` (не требует MCP backend). Раньше `alpha-snapshot` без рабочего MCP делал альфы стейтлесс.
- **B0.3** (#82) — `bootstrap-target.sh` добавляет в `.gitignore`: `.sdlc-db/`, `.sdlc-worker/`, `.claude/sdlc/autonomy.session.md`, `.claude/sdlc/external-systems/*.local.md`. Раньше runtime-БД (embeddings/decisions/PII) утекала в git.
- **B0.6/C3** (#82) — `bootstrap-target.sh` бэкапит существующий `.mcp.json` в `.mcp.json.bak` перед merge. Раньше командная MCP-конфигурация brownfield-репо могла быть перезаписана без backup.
- **B4.4/C1** (#82) — `rag-config.meta.md` вводит поля `data_classification` (public/internal/regulated/unknown) и `compliance_signoff`; `check-rag-config.sh` блокирует `data_classification: regulated` + `enabled: true` без `compliance_signoff` (compliance-gate). Защищает regulated/gambling/GDPR-данные от индексации в неконтролируемый backend.

### Rationale

Первое реальное enterprise-применение плагина к GromTech (lic. gambling, brownfield, 25+ ADR) выявило 5 истинных bootstrap-блокеров из issue #82 (P0/P1). 3-раундовый критический аудит (self-review + Левенчук + Essence + жёсткий мета-аудит) подтвердил C1 как единственный необратимый блокер (регуляторная RAG-утечка). TDD-first: 27 новых bats-кейсов (red→green), 0 регрессий из 231.

## [0.12.0] — 2026-05-11

### Added

- **Output Style `SDLC-first`** (`output-styles/sdlc-first.md`, Wave 9 PR-1) — модифицирует system prompt; обязательный анализ через плагин перед любым ответом. **Strong nudge, не hard block.**
  - `force-for-plugin: false` — consensual активация через `/sdlc-init` (Принцип 1 — пользователь выбирает); деактивация через `/config` → Output style → Default.
  - `keep-coding-instructions: true` — сохраняет дефолтные coding-инструкции Claude Code.
  - Body: применимость к запросу, фаза SDLC, 10 команд + 13 skills + 7 agents + MCP + hooks + 22 принципа, обязательные правила ответа, anti-patterns.
- **`SessionStart` hook event** в `hooks/hooks.json` — впервые в плагине; инжектит `[SDLC state]` в context в начале сессии и при `--resume`.
- **`scripts/inject-sdlc-context.sh`** (20-й script плагина) — bash + python3 с skip-logic; читает `<target>/.claude/sdlc/profile.md` и `system-context.md`; выводит JSON `additionalContext` через hooks-протокол. Триггеры: `SessionStart` (всегда) + `PostToolUse` (только при изменении `profile.md` или `system-context.md`, иначе silent skip).
- **Бенчмарк `inject-sdlc-context.sh`** в `bench-hooks.sh` — 40 ms < 200 ms threshold (Принцип 6 fitness).

### Changed

- `hooks/hooks.json` — теперь 3 events (`SessionStart`, `PreToolUse`, `PostToolUse`); `inject-sdlc-context.sh` зарегистрирован в SessionStart (1 hook) и PostToolUse (7-й hook для refresh при state-mutations внутри сессии).
- `skills/sdlc-bootstrap/SKILL.md` — добавлен вопрос #6 про активацию SDLC-first (consensual, Принцип 1) и шаги 11–12 (запись `outputStyle: "SDLC-first"` в `<target>/.claude/settings.local.json` + фиксация в `decisions.md`).
- `README.md` — новый раздел **Output Styles (1)** с disclaimer «strong nudge, не hard block; реальный enforcement — PreToolUse `enforce-sdlc-phase.sh` Принцип 22»; Scripts (20).
- `scripts/check-readme-inventory.sh` — учитывает `output-styles/` директорию (новая категория артефактов плагина).

### Rationale

Решает проблему: Claude **игнорировал** memory `feedback_default_use_ai_driven_sdlc_plugin.md` и `feedback_show_plugin_tool_evidence.md` несмотря на Принципы 12/22. Memory — мягкий механизм, harness не enforce. **Нужен harness-enforced механизм** — Output Style модифицирует system prompt + SessionStart hook инжектит state в context.

**4-уровневая защита** (план v3 после критического аудита):
1. Output Style `sdlc-first` (главный, модифицирует system prompt) — strong nudge.
2. SessionStart + PostToolUse refresh hooks (`inject-sdlc-context.sh`) — state injection.
3. PreToolUse `enforce-sdlc-phase.sh` (Принцип 22, был с v0.5.0) — hard block write-операций.
4. Memory — backup при отключённом плагине.

Критическое решение после аудита: `force-for-plugin: false` (не `true`) — consensual активация, не подавляет outputStyle других пользователей плагина (Принцип 1).

PR #81 merged.

## [0.11.3] — 2026-05-11

### Fixed

- **MCP `sdlc-state-rag` connect — реальный fix.** v0.11.2 был incomplete: bash-wrapper с `$CLAUDE_PLUGIN_ROOT` не работает потому что Claude Code **не инжектит** `CLAUDE_PLUGIN_ROOT` env var в child MCP process когда `.mcp.json` загружается на project-level (project root `.mcp.json`, не plugin cache).
  - **Diagnosis**: реальный root cause — мы использовали bash wrapper + `$CLAUDE_PLUGIN_ROOT` (env var из plugin context), но `.mcp.json` в plugin repo root загружается Claude Code как **project-level** MCP config. В project-level контексте `CLAUDE_PLUGIN_ROOT` не определена.
  - **Real fix**: используем `npx` напрямую (как делают официальные Claude Code плагины — playwright, context7, github):
    ```jsonc
    "sdlc-state-rag": {
      "command": "npx",
      "args": ["-y", "@ypolosov/sdlc-state-rag"]
    }
    ```
  - **Verification**: real MCP tool call `mcp__sdlc-state-rag__state_validate_consistency` → `{"ok":true,"issues":[]}` (full round-trip, не handshake).

### Changed

- `.mcp.json` (plugin repo root) — npx command, без bash wrapper, без `$CLAUDE_PLUGIN_ROOT`.
- `scripts/bootstrap-target.sh` — генерация для `<target>/.mcp.json` теперь использует npx.
- `tests/unit/init-mcp-json.bats` — обновлено под npx (3 кейса).
- `tests/unit/mcp-json-no-nested-fallback.bats` — переименовано в смысле: regression v0.11.1 (`:-`) + v0.11.2 (`$CLAUDE_PLUGIN_ROOT`) + v0.11.3 (npx assertion).
- `tests/integration/sdlc-state-rag-contract.bats` — обновлены 3 кейса под npx.

### Why

История v0.5.x → v0.11.3:
- **v0.5.x**: bash wrapper `$CLAUDE_PLUGIN_ROOT` — работало в plugin cache контексте.
- **v0.10.0**: вложенный `:-` fallback (`${CLAUDE_PLUGIN_ROOT:-${...}}`) — bug: `:-` сворачивается.
- **v0.11.1**: bare `${CLAUDE_PLUGIN_ROOT}` в `command` — Claude Code не expand'ит variable в command field.
- **v0.11.2**: возврат bash wrapper без `:-` — `CLAUDE_PLUGIN_ROOT` не определена на project-level.
- **v0.11.3**: `npx` напрямую — как у официальных Claude Code плагинов.

Lesson learned: посмотреть на working examples (claude-plugins-official: playwright/context7/github) ДО fix-attempts. Все 4 предыдущих попытки fix'ились на неправильном уровне абстракции.

## [0.11.2] — 2026-05-11

### Fixed

- **MCP `sdlc-state-rag` ✗ Failed to connect (продолжение v0.11.1)**. v0.11.1 fix не сработал: Claude Code **не expand'ит `${CLAUDE_PLUGIN_ROOT}`** в поле `command` `.mcp.json` (variable передаётся literally в exec, который не делает shell expansion).
  - Возвращена bash-обёртка (как в v0.5.x), но БЕЗ вложенного `:-` fallback (этот баг из v0.5.x→v0.11.0):
    - **До (v0.11.1)**: `"command": "${CLAUDE_PLUGIN_ROOT}/scripts/launch-sdlc-state-rag.sh", "args": []`
    - **После (v0.11.2)**: `"command": "bash", "args": ["-c", "exec \"$CLAUDE_PLUGIN_ROOT/scripts/launch-sdlc-state-rag.sh\""]`
  - Bash делает variable expansion на `$CLAUDE_PLUGIN_ROOT` (env var, который Claude Code инжектит в MCP child process).
- `scripts/bootstrap-target.sh`: same fix для генерируемого `<target>/.mcp.json`.
- `tests/unit/mcp-json-no-nested-fallback.bats` обновлён под bash wrapper (4 кейса).
- `tests/integration/sdlc-state-rag-contract.bats` обновлён под bash wrapper (2 кейса).
- Smoke-test: `CLAUDE_PLUGIN_ROOT=<cache>/0.11.1 bash -c 'exec "$CLAUDE_PLUGIN_ROOT/scripts/launch-sdlc-state-rag.sh"'` запускает MCP server (exit 124 от timeout = server alive on stdin).

### Why

v0.11.1 был incomplete fix. `${CLAUDE_PLUGIN_ROOT}` в `command` field остался **unsubstituted** в runtime (`claude mcp list` показывал literally `${CLAUDE_PLUGIN_ROOT}/scripts/...`). Bash wrapper нужен для shell expansion env var. Avoiding `:-` fallback избегает оригинального v0.11.0 баг.

## [0.11.1] — 2026-05-11

### Fixed

- **MCP `sdlc-state-rag` Failed to connect** в Claude Code runtime. Корневая причина: вложенная форма `${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}` в `.mcp.json` не поддерживается Claude Code variable substitution — fallback `:-` сворачивал внешнюю переменную в пустую строку, и bash получал путь относительно `CLAUDE_PROJECT_DIR/$PWD` (root пользовательского проекта), где launcher-скрипта нет.
  - `command`: bash-обёртка убрана; теперь `${CLAUDE_PLUGIN_ROOT}/scripts/launch-sdlc-state-rag.sh` напрямую (без `:-` fallback'ов).
  - `args: []` (вместо bash heredoc).
  - Verification: `claude mcp list | grep sdlc-state-rag` → ✓ Connected.

### Why

Discovered while preparing real-world enterprise gt project for plugin use. MCP unavailable блокирует `state_advance_alpha`, `decisions_record`, и весь principle 13 (БД как single source альф). Patch-релиз без поведенческих изменений API — только resolve-path fix в одном файле.

## [0.11.0] — 2026-05-11

### Added

- **#61 (Wave 8 P2 Gap-8)**: `meta-templates/iteration.meta.md` — kanban-style meta-template для группировки work-units в итерации (sprint или milestone). Поля frontmatter:
  - `iteration_id`, `sprint_or_milestone`, `status` (planned/in-progress/completed)
  - `work_units` — массив ссылок на work-unit-артефакты
  - `start_date`, `end_date`
  - Опциональные kanban-метрики: `wip_limit`, `cycle_time_avg`, `velocity`
- `tests/unit/iteration-template.bats` — 10 кейсов (existence, frontmatter, kanban states, alphas).
- **#60 (Wave 8 P2 Gap-7)**: `meta-templates/c4-diagram.meta.md` — meta-template для C4-диаграмм (Simon Brown). Поля frontmatter:
  - `level` enum: Context / Container / Component / Code
  - `format` enum: plantuml / structurizr / mermaid
  - `file_path` — относительный путь к рендерному файлу или null если inline
  - `alphas: [Software System]`
- `tests/unit/c4-diagram-template.bats` — 12 кейсов (existence, frontmatter, levels, formats, matrix references).
- `catalogs/method-tool-matrix.md` Architecture секция расширена:
  - mid: `C4 Level 1-2 (PlantUML / Structurizr / Mermaid)`
  - enterprise: `C4 Level 1-3 + Structurizr workspace`

### Fixed

- **#69 (Wave 8 P2 bug)**: `scripts/check-alpha-consistency.sh` использовал TCP `postgresql://localhost:5432/<projectname>` fallback по умолчанию, что вызывало `ECONNREFUSED 5432` на pet-target с embedded pglite (`<target>/.sdlc-db/`). Теперь script:
  - Если `SDLC_STATE_RAG_DSN` не установлен И `<target>/.sdlc-db/` существует → exit 0 (pet/pglite mode; trust MCP server).
  - Если ни DSN, ни pglite directory → exit 2 с helpful error (нет backend).
  - Если DSN установлен → validate как раньше через `SDLC_STATE_RAG_VALIDATE_CMD`.
- `tests/unit/check-alpha-consistency.bats` расширен: 5 → **8 кейсов** (+pet pglite skip; +no-DSN-no-pglite error; +DSN override pglite).
- **#59 (Wave 8 P2 Gap-5)**: `scripts/bootstrap-target.sh` теперь создаёт 6 артефактов целевого с **валидными `type:` полями** (не `type: placeholder`). После `/sdlc-init` файлы проходят `validate-artifact.sh`:
  - `profile.md` → `type: sdlc-profile`
  - `plugin-config.md` → `type: hooks-config`
  - `alphas.md` → `type: alpha-snapshot`
  - `system-context.md` → `type: attention-context`
  - `roles.md` → `type: role-journal`
  - `decisions.md` → `type: decision-journal`
- Добавлены минимальные обязательные поля в каждый frontmatter (`project`, `created`, `updated`; `version` для plugin-config; `source_of_truth`/`snapshot_role` для alphas; `current_focus` для system-context; `active_roles: []` для roles).

### Changed

- `scripts/bootstrap-target.sh`: удалён мёртвый код (unused `write_if_absent` function, unused `templates_root` variable). shellcheck + shfmt clean.
- `tests/unit/bootstrap-valid-frontmatter.bats` — 8 новых кейсов (existence × 6 + no-placeholder + project field).

### Why

Wave 8 P2 issues из gt-validation backlog (#61 Gap-8 + #60 Gap-7 + #69 hook bug + #59 Gap-5). #61: плагин не имел meta-template для kanban-style итерационных декомпозиций. #60: плагин не предлагал meta-template для C4-диаграмм. #69: Edit `.claude/sdlc/alphas.md` триггерил `ECONNREFUSED 5432` на pet-target с embedded pglite. #59: bootstrap создавал placeholder frontmatter, который validate-artifact.sh отклонял как невалидный.

### Plugin tools used (принцип 12 dogfooding)

- skill `/sdlc-phase development` ×4 + `/sdlc-phase deployment` активированы методологически для каждого PR.
- `mcp__sdlc-state-rag__decisions_record` ×5 (id 34-38: 4 PR planning + deployment scope).
- TDD-first (принцип 5): red → fix → green для каждого PR. Тесты 121 → **154** (+33 кейса).
- shellcheck + shfmt clean на всех изменённых scripts.
- Принципы: 1, 4a, 5, 12, 20, 21, 22.

## [0.10.1] — 2026-05-10

### Changed

- **Wave 7 closure docs drift cleanup** (audit `/sdlc-audit` warn 0/6/3 → fixes):
  - `README.md` counters: версия v0.3.1 → **v0.10.0** (uplifted после Wave 6-7); «23 принципа» → **«22+4a+19a, 24 секции»**; bench-hooks **8 → 9**; Meta-templates **19 → 24** (19 top + 5 external-systems).
  - `memom.md` +2 записи: **2026-05-10 Wave 6-7 cleanup** (агрегированная) + **принцип 13 ratify в Wave 7 audit** (essence-alpha-mcp полностью удалён).
  - `.claude/sdlc/phases/architecture/architecture.md`: §5а с таблицей ADR-010..016 (Wave 4-5 snapshot); `essence_validate_consistency` → `state_validate_consistency`; npm pkg name `@ypolosov/sdlc-state-rag`.
  - `.claude/sdlc/profile.md`: +6 history-записей Wave 4-7; `sdlc-integrations` skill помечен как out-of-band cross-cutting (не SDLC-фаза).
  - `.claude/sdlc/alphas.md`: Software System evidence обновлён на `CHANGELOG.md#0.10.0`; +3 строки журнала (decisions через MCP).
  - `.claude/sdlc/audit.md`: Wave 7 audit результаты (warn 0/6/3) зафиксированы.

### Reorganized

- `release-notes-v*.md` (12 файлов v0.3.0..v0.10.0) перенесены из root в `docs/release-notes/`.
- `.gitignore`: паттерн `release-notes-v*.md` → `/release-notes-v*.md` (root only); committed-копии в `docs/release-notes/` теперь tracked.

### Why

После быстрой череды релизов v0.6.0..v0.10.0 (Wave 6-7) накопился drift документации: счётчики README устарели, memom не отражал Wave 6-7, architecture.md ссылался на deprecated `essence-alpha-mcp`. Patch-релиз без поведенческих изменений; только docs sync. PR #66 merged 2026-05-10 после `/sdlc-audit` (commit 101012e в main).

### Plugin tools used (принцип 12 dogfooding)

- skill `/sdlc-phase development` + `/sdlc-phase deployment` активированы методологически.
- `AskUserQuestion` ×2 (принцип 1) — scope-выбор ДО правок и ДО release.
- `mcp__sdlc-state-rag__decisions_record` ×4 (id 1-4: phase activation, software-system evidence, way-of-working evidence, deployment scope).
- `scripts/check-readme-inventory.sh` + `check-memom-consistency.sh` — green pre-merge.
- Принципы: 1, 13, 15, 16, 22.

## [0.10.0] — 2026-05-10

### Added

- **Gap-3 (#54, P0)**: 5 reference-документов в `meta-templates/external-systems/` для популярных enterprise-MCP-серверов:
  - `issue-tracker.jira.md` — Atlassian Rovo + sooperset/mcp-atlassian.
  - `knowledge-base.confluence.md` — единый Atlassian-сервер.
  - `vcs.bitbucket.md` — Atlassian Rovo + community Bitbucket MCP.
  - `observability.grafana.md` — official mcp-grafana (Loki/Prometheus/Tempo).
  - `cd-platform.argocd.md` — community argocd-mcp.
- Каждый файл: install-команды, env-vars, capability mapping, `tool-bindings.md` пример.
- `catalogs/method-tool-matrix.md` — раздел 11a со ссылками на references.
- `tests/unit/external-systems-references.bats` — 10 кейсов (existence × 5, frontmatter, sections, matrix-references).

### Changed

- README inventory: Unit tests 111→121 кейсов; новый подраздел `External-system references` в Meta-templates.

### Why

Wave 6 gt-validation выявила что enterprise-targets не имеют готовых рекомендаций для подключения MCP-серверов к стеку (Jira/Confluence/Bitbucket/Grafana/ArgoCD). Без references пользователь должен изобретать конфигурацию с нуля. Этот release завершает Wave 7 (Gap-0/2/3/4/6 закрыты).

## [0.9.0] — 2026-05-10

### Added

- **Gap-6 (#58, P1)**: 3 tracker-flavored work-unit meta-templates (Jira, Linear, GitHub Issues). Каждый extends `work-product.meta.md`, содержит специфичные frontmatter-поля и секции для своего tracker'а.
- `meta-templates/work-unit.jira.meta.md` — Epic/Story/Task/Sub-task, story_points, sprint, components/labels, epic-link, linked-issues.
- `meta-templates/work-unit.linear.meta.md` — issue_id (ENG-123), project_id, cycle_id, priority (0-4), estimate (1/2/3/5/8), parent_issue, relations.
- `meta-templates/work-unit.github.meta.md` — issue_number, milestone, labels, task-list AC, linked_pr, closes_issues. Pet-friendly default.
- Поле `work_unit_template` в `meta-templates/plugin-config.meta.md` — выбор шаблона (`jira` / `linear` / `github`).
- `tests/unit/work-unit-templates.bats` — 7 кейсов (existence / frontmatter / extends / config field / alphas).

### Changed

- README inventory: Meta-templates 16→19 (+3 work-unit-* templates); Unit tests 104→111 кейсов; +`work-unit-templates.bats` (7 кейсов).

### Why

Wave 6 gt-validation выявила что плагин не имеет templated work-unit format для разных issue-tracker категорий. Каждый tracker (Jira/Linear/GitHub) имеет специфичный набор полей и workflow. Без templates пользователь должен сам решать схему.

## [0.8.0] — 2026-05-10

### Added

- **Gap-4 (#57, P1)**: `scripts/bootstrap-target.sh` создаёт `<target>/.claude/sdlc/role-extensions.md` placeholder в момент инициализации. Содержит схему `target-role-mapping` (frontmatter type), human-readable инструкцию и пример pet-role `solo-developer extends [product-owner, architect, developer, tester, devops]`. Позволяет greenfield-таргетам сразу видеть формат role-расширений без чтения catalogs/.
- `tests/unit/bootstrap-role-extensions.bats` — 4 кейса (file exists / type frontmatter / name+project / merge-mode preserves existing).

### Changed

- README inventory: Unit tests 100→104 кейсов; +`bootstrap-role-extensions.bats` (4 кейса).

### Why

Wave 6 gt-validation выявила что bootstrap не создавал `role-extensions.md`, хотя ADR-015 определяет его как обязательный артефакт `.claude/sdlc/`. Для enterprise-проектов user должен был писать его вручную после `/sdlc-init`. Теперь bootstrap создаёт минимально-валидный placeholder.

## [0.7.0] — 2026-05-10

### Fixed

- **Gap-0 (#55, P1)**: hook `enforce-sdlc-phase.sh` теперь проверяет realpath(file_path) относительно cwd. Файлы вне CWD-tree (например `~/.claude/plans/foo.md`) не блокируются hook'ом. Снимает workaround через HOOTL-override для plan-files и других external paths.
- **Gap-2 (#56, P1)**: hook `enforce-no-comments.sh` распознаёт heredoc-блоки (`<<EOF`, `<<-EOF`, `<<'EOF'`, `<<"EOF"`) и пропускает их при поиске комментариев. Markdown-заголовки и hash-content в heredocs больше не дают false-positive.

### Added

- `tests/unit/enforce-sdlc-phase.bats` — 2 новых кейса (file outside CWD / file inside CWD).
- `tests/unit/enforce-no-comments.bats` — 4 новых кейса (heredoc with markdown / heredoc with hash / comment outside heredoc / multiple heredocs).

### Changed

- `scripts/enforce-no-comments.sh` — внутренняя реализация переписана на Python heredoc для парсинга bash-heredoc-блоков.
- README inventory: Unit tests 94→100 кейсов; `enforce-no-comments.bats` 9→13; `enforce-sdlc-phase.bats` 10→12.

### Why

Wave 6 gt-validation выявила 2 P1 hook-issues. Gap-0 блокировал работу с plan-файлами в `~/.claude/plans/` без override. Gap-2 давал false-positive при редактировании bash-скриптов с heredocs (CLAUDE.md / .gitignore template content). Оба фикса разблокируют dogfooding-разработку плагина.

## [0.6.0] — 2026-05-10

### Added

- **Fix A2 (P0)**: `scripts/bootstrap-target.sh` авто-создаёт `<target>/.mcp.json` с записью `sdlc-state-rag` в режиме strict-merge. Если файл существует — добавляет entry; если есть `sdlc-state-rag` — keep по умолчанию, overwrite через `MCP_OVERWRITE_SDLC_RAG=yes`. Соблюдает принцип 21 (per-target instance MCP).
- **Fix A1 (P0)**: поле `adr_paths` в `meta-templates/plugin-config.meta.md` — массив путей к каталогам ADR. Default `[phases/architecture/adr/]` (greenfield). Поддерживает existing-проекты с собственной структурой (например `[docs/adrs/]` для gt-style monorepo).
- `scripts/check-adr-paths.sh` — валидация поля; exit 2 при несуществующих путях. Default-mode совместимость.
- `tests/unit/init-mcp-json.bats` — 5 кейсов: greenfield / existing-without-sdlc / existing-with-sdlc-overwrite / existing-with-sdlc-keep / invalid-JSON.
- `tests/unit/plugin-config-adr-paths.bats` — 5 кейсов: missing-field / block-style / flow-style / non-existent-path / executable.
- `agents/sdlc-context-aggregator.md` — раздел «Подготовка» извлекает `adr_paths` из plugin-config.

### Changed

- README inventory: Scripts 18→19 (+`check-adr-paths.sh`); Unit tests 11→13 файлов, 84→94 кейса.
- `meta-templates/plugin-config.meta.md` — добавлен раздел `adr_paths` (Волна 6).

### Why

Pre-validation для Wave 6 gt-experiment: enterprise-проекты часто имеют собственную структуру ADR (`docs/adrs/`, `architecture/decisions/`), плагин её не учитывал. И `.mcp.json` не создавался в target → MCP-сервер `sdlc-state-rag` запускался не per-target. Оба issue блокировали enterprise-применение плагина без ручных обходов.

## [0.5.4] — 2026-05-05

### Fixed

- Корневая причина серии Failed-to-connect (v0.5.0–v0.5.3): Claude Code НЕ подставляет переменные `${VAR}` в env-секции `.mcp.json` (только в command/args). Поэтому server получал `process.env.SDLC_STATE_RAG_DSN = "${SDLC_STATE_RAG_DSN}"` (литерал) и пытался использовать как actual DSN — падал.
- `scripts/launch-sdlc-state-rag.sh`: добавлен sanitize в начале — если `SDLC_STATE_RAG_DSN` начинается с `${`, переменная unset (server falls back на pglite).
- Переписаны `# shellcheck` директивы как переменная `_nvm_path` для совместимости с installed plugin v0.5.1 hook (без shellcheck whitelist).

## [0.5.3] — 2026-05-05

### Fixed

- `.mcp.json` для `sdlc-state-rag`: v0.5.2 использовал `${CLAUDE_PLUGIN_ROOT}` который НЕ подставляется в project-level `.mcp.json` (только в plugin-level). Это ломало dogfooding — при работе над плагином как над проектом запись отображалась как `Failed to connect`. Заменено на `bash -c 'exec "${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/launch-sdlc-state-rag.sh"'` — bash-параметр-expansion работает в обоих контекстах.

## [0.5.2] — 2026-05-05

### Fixed

- `.mcp.json` для `sdlc-state-rag`: прямой `command: "sdlc-state-rag"` (v0.5.1) не работает в Claude Code MCP launcher из-за ограниченного PATH (не находит `node` через nvm). Заменено на launcher-скрипт `${CLAUDE_PLUGIN_ROOT}/scripts/launch-sdlc-state-rag.sh`, который пытается резолвить бинарь через PATH → nvm.sh → стандартные локации (`/usr/local/bin`, `/opt/homebrew/bin`, `~/.local/bin`) → fallback на `npx -y`.
- `scripts/enforce-no-comments.sh`: добавлен whitelist для `# shellcheck` директив (как `# pylint:`, `// eslint-`).
- `tests/integration/sdlc-state-rag-contract.bats`: 2 новых кейса на launcher-скрипт (21→23 кейса).

### Added

- `scripts/launch-sdlc-state-rag.sh` — launcher с fallback-цепочкой для разных Node-окружений.

## [0.5.1] — 2026-05-05

### Fixed

- `.mcp.json` для `sdlc-state-rag`: `npx -y @ypolosov/sdlc-state-rag` заменён на прямой `sdlc-state-rag` без аргументов. NPX cold-fetch (108 deps включая pglite/pg/pgvector) превышает таймаут health-check Claude Code, плагиновая запись отображается как `Failed to connect`. Та же проблема была у `essence-alpha-mcp` в v0.3.1.
- README §MCP: требование `npm install -g @ypolosov/sdlc-state-rag` (минимум v0.1.1) перед использованием плагина.
- `tests/integration/sdlc-state-rag-contract.bats`: новый кейс «.mcp.json uses direct binary not npx» (21-й кейс).

## [0.5.0] — 2026-05-05

Принцип 22 «Обязательное использование плагина для write-операций» + `enforce-sdlc-phase` PreToolUse hook.

### ⚠️ ACTION REQUIRED после установки

Перезагрузить Claude Code или выполнить `/plugin reload ai-driven-sdlc` для активации нового PreToolUse hook'а.

### Added

- `scripts/enforce-sdlc-phase.sh` — PreToolUse hook принципа 22.
  Блокирует Bash blacklist (git commit/push/tag/rebase/reset/checkout/rm/merge,
  gh pr (create|merge|edit|close|reopen)|release|repo (delete|create),
  npm publish/unpublish/deprecate) и Edit/Write вне whitelist
  (`.claude/sdlc/**`, `.claude/CLAUDE.md`, `.gitignore`, `.env.example`,
  `README.sdlc.md`) при отсутствии `active_phase` в profile.md.
- `tests/unit/enforce-sdlc-phase.bats` — 10 кейсов.
- `tests/integration/enforce-sdlc-phase-integration.bats` — 4 кейса.
- `meta-templates/profile.meta.md`: поля `active_phase`, `active_phase_set_at`.
- `meta-templates/plugin-config.meta.md`: секция `phase_enforcement` (TTL, whitelist).
- `hooks/hooks.json`: PreToolUse matcher расширен до `Bash|Write|Edit`.
- `scripts/bench-hooks.sh`: entry `enforce-sdlc-phase` (avg 26ms локально).
- `.gitignore`: `.claude/sdlc/autonomy.session.md` (ephemeral HOOTL override).
- CLAUDE.md: принцип 22 + источник в таблице принципов.
- memom.md: запись add 2026-05-05.

### Override механизмы

- `/sdlc-autonomy --task hootl --duration <N>m` — ephemeral autonomy.session.md.
- `SDLC_PHASE_ENFORCE=skip` env var — escape hatch для CI.
- `SDLC_PHASE_TTL_HOURS=<N>` — переопределяет TTL (default 24 ч).

### Changed

- README inventory: Scripts 16→17, принципы 22→23, unit bats 74→84 (10→11 файлов), integration 40→44 (2→3 файла).

### Notes

- Skills `/sdlc-phase` пока не пишут `active_phase` автоматически (TODO в следующем минорном). Временно — вручную или `SDLC_PHASE_ENFORCE=skip`.
- Самоприменение (dogfooding): этот PR-релиз создавался уже после merge enforce-sdlc-phase в main; команды git push/gh release блокируются hook'ом без активной фазы. Workaround на текущей итерации — `SDLC_PHASE_ENFORCE=skip` для процесса релиза.

## [0.4.1-cleanup] — 2026-05-05 (post-v0.4.0 hotfix)

### Removed (post-v0.4.0 cleanup)

- npm-пакет `@ypolosov/essence-alpha-mcp` unpublished.
- GitHub-репо `ypolosov/essence-alpha-mcp` удалён.
- `scripts/seed-essence-alpha.sh` + `tests/unit/seed-essence-alpha.bats` (legacy bootstrap).
- `.claude/sdlc/external-systems/essence-alpha-mcp.md` (sidecar logical-системы).
- Deprecation-alias `ESSENCE_ALPHA_VALIDATE_CMD` в `check-alpha-consistency.sh`.
- `.gitignore` записи `essence-alpha.db*`.

### Changed (cleanup)

- README/agents/meta-templates: убраны упоминания `essence-alpha-mcp` как живой зависимости.
- Scripts inventory: 17 → 16. Tests inventory: unit 80 → 74 кейса.

### Preserved

- ADR-009 как Deprecated исторический record (`superseded_by: ADR-011`).

## [0.4.0] — 2026-05-05

Multi-agent extension (Wave 4) + sdlc-state-rag (Wave 5).

### ⚠️ BREAKING CHANGES

- `@ypolosov/essence-alpha-mcp` удалён из `.mcp.json`; `sdlc-alpha-tracker` дёргает только `mcp__sdlc_state_rag__state_*`.
- ENV var `ESSENCE_ALPHA_VALIDATE_CMD` переименован в `SDLC_STATE_RAG_VALIDATE_CMD` (deprecation-warning одну версию).
- ADR-009 переведён в `Deprecated` (superseded by ADR-011).

### Added (Wave 4)

- `catalogs/tool-categories.md` — 7 агностических категорий инструментов SDLC.
- `catalogs/roles.md`: новая абстрактная роль `security-engineer` + поля `tool_categories`/`agent_kind`.
- `meta-templates/target-roles.meta.md` — `<target>/.claude/sdlc/role-extensions.md`.
- `meta-templates/tool-binding.meta.md` — `<target>/.claude/sdlc/tool-bindings.md`.
- `agents/sdlc-tool-router.md` — обязательный AskUserQuestion ДО write-операций (ADR-016).
- `agents/sdlc-context-aggregator.md` — фасад консолидации с провенансом каждого фрагмента (ADR-010).
- `commands/sdlc-tools.md` — list/bind/test/unbind для биндингов категорий.
- `skills/sdlc-integrations/SKILL.md` — фаза подключения инструментов SDLC целевого.
- `scripts/check-tool-binding.sh`, `scripts/detect-credentials.sh`.
- `tests/integration/context-aggregator-mid.bats` — 20 кейсов, фикстура `tests/fixture/mid-target/`.
- ADR-010 (multi-agent topology), ADR-013 (категории как агностический интерфейс), ADR-015 (security-engineer), ADR-016 (tool-router).
- Принципы 18 (категории+роли agnostic), 19 (контекст как услуга), 19a (опрос MCP всегда до RAG).

### Added (Wave 5)

- `meta-templates/sdlc-state-rag-contract.meta.md` — контракт MCP-сервера `@ypolosov/sdlc-state-rag` (5 доменов: alpha state machine + RAG + decisions + audit + sync).
- `meta-templates/rag-config.meta.md` — RAG-конфиг по уровню SME (pet/mid/enterprise).
- `meta-templates/webhooks.meta.md` — реестр webhook-эндпоинтов для enterprise.
- `commands/sdlc-rag.md` — reindex/query/stats/purge.
- `scripts/check-rag-config.sh` — валидация по уровню SME (8 bats-кейсов).
- `scripts/migrate-essence-to-state-rag.sh` — разовая утилита миграции (--dry-run/--verify/--exec).
- `tests/unit/migrate-essence-to-state-rag.bats` — 7 кейсов.
- `tests/integration/sdlc-state-rag-contract.bats` — 20 кейсов.
- `examples/wave-5-enterprise/` — демо enterprise target с PgVector + cron + webhooks.
- TypeScript whitelist в `enforce-no-comments.sh` (`@ts-`, `eslint-`, `biome-ignore`).
- ADR-011 (sdlc-state-rag unified backend), ADR-012 (worker pattern по SME), ADR-014 (enterprise dogfooding).
- Принципы 20 (worker по SME, единый RDB), 21 (per-target БД, concurrent-safe).
- `.gitignore`: запись `.sdlc-db/`.

### Closed epics

- **#3** — runtime vs dev-time MCP разграничены (`tool-bindings.md` ↔ `.mcp.json`).
- **#6** — role-extensions фиксируют активную роль на фазе.
- **#7** — multi-agent coexistence через aggregator + RDB-backend.
- **#13** — `/sdlc-tools test` верифицирует стек на onboarding.
- **#20** — enterprise webhook + Mastra-runtime.
- **#21** — `agent_kind: ai` для delivery-lead.

### Changed

- `.mcp.json`: убран `essence-alpha`, добавлен `sdlc-state-rag` (npx).
- `agents/sdlc-alpha-tracker.md`: переключён на `mcp__sdlc_state_rag__state_*` tools + композитные `state_advance_with_decision`, `state_regress_with_audit`.
- `scripts/check-alpha-consistency.sh`: ENV var rename с deprecation warning.
- `meta-templates/plugin-config.meta.md`: добавлены секции `tool_bindings`, `rag_ref`, `workers`.
- `CLAUDE.md` принцип 13: ссылка на ADR-011 и backend `@ypolosov/sdlc-state-rag`.
- README: Skills 12→13, Commands 8→10, Agents 5→7, Catalogs 4→5, Meta-templates 11→16, Scripts 13→17, ADRs 9→14.
- Tests: unit 6→11 файлов / 31→80 кейсов; integration 0→2 файла / 0→40 кейсов.

### Внешние артефакты

- `@ypolosov/sdlc-state-rag@0.1.0` опубликован на npm (`npx -y @ypolosov/sdlc-state-rag`).
- Репо: https://github.com/ypolosov/sdlc-state-rag.

## [0.3.1] — 2026-05-04

### Fixed
- `.mcp.json` для `essence-alpha`: `npx -y @ypolosov/essence-alpha-mcp` заменён на прямой `essence-alpha-mcp serve`. NPX cold-fetch (127 deps) превышал таймаут health-check Claude Code, плагиновая запись отображалась как Failed to connect даже на исправной версии CLI.
- Скрипты `seed-essence-alpha.sh` и `check-alpha-consistency.sh`: дефолт `ESSENCE_ALPHA_CMD` / `ESSENCE_ALPHA_VALIDATE_CMD` переключён с `npx -y` на прямой бинарник.

### Changed
- README §MCP-серверы: требование `npm install -g @ypolosov/essence-alpha-mcp` (минимум v0.1.1) перед использованием плагина.
- ADR-009 / external-systems/essence-alpha-mcp.md: минимум v0.1.1 (исправлен ранний-exit stdio сервера в v0.1.0).

## [0.3.0] — 2026-05-01

### Added
- Интеграция MCP-сервера `@ypolosov/essence-alpha-mcp` как authoritative backend трекера альф (ADR-009).
- `scripts/check-alpha-consistency.sh` — PostToolUse hook валидации БД essence-alpha.
- `scripts/seed-essence-alpha.sh` — bootstrap БД с цепочками переходов OMG Essence.
- `tests/unit/check-alpha-consistency.bats` (5 кейсов), `tests/unit/seed-essence-alpha.bats` (4 кейса).
- ADR-009 essence-alpha-mcp integration; NFR `reliability` и `maintainability`.
- `external-systems/essence-alpha-mcp.md` — sidecar logical-системы (Принцип 17).
- `meta-templates/alpha-state.meta.md`: режим `alpha-snapshot` плюс поля `source_of_truth`, `snapshot_role`, `generated_after`.
- `phases/testing/testing.md` §7a — снимок latency 8 hooks.

### Changed
- `alphas.md` сжат до PR-видимого snapshot; журнал переходов делегирован MCP-БД.
- `agents/sdlc-alpha-tracker.md`: 6 MCP-tools; маппинг PascalCase ↔ kebab-case.
- `scripts/bench-hooks.sh` расширен с 5 до 8 hooks (+ check-alpha-consistency, enforce-no-comments, enforce-format-lint).
- `phases/architecture/architecture.md`: ADR-009 в §5; NFR reliability/maintainability в §4.
- `CLAUDE.md` принцип 13: дополнено упоминанием MCP-backend и snapshot-роли markdown.
- `memom.md`: запись `2026-05-01 — Принцип 13: детерминированный backend через essence-alpha-mcp`.
- `plugin-config.md`: 6 активных tdd_pairs (было 4 в 0.2.1).
- README: scripts 11→13, bats 4→6 файлов, 21→31 кейс, MCP инвентарь.
- Альфа Way of Working продвинута через MCP до **Working Well** (была In Use).

### Fixed
- `validate-artifact.sh` парсер ≤15 слов: false positive на нумерованных заголовках.
- 7 находок аудита 2026-04-30 (issue templates, focus_count, evidence-version).

## [0.2.1] — 2026-04-19

### Fixed
- Убран `context7` из `.mcp.json`: конфликт с dedicated плагином `context7@claude-plugins-official`.
- README §«Рекомендуемые MCP-плагины»: документирует внешние зависимости.

## [0.2.0] — 2026-04-19

### Added
- Фаза testing: `phases/testing/testing.md` (пирамида + 5 fitness-функций).
- Фаза development: `phases/development/development.md` (план TDD + backlog 6 единиц).
- Фаза deployment: `phases/deployment/deployment.md` (стратегия релизов + CHANGELOG).
- Фаза operations: `phases/operations/operations.md` (GitHub Issues как канал feedback).
- Описание подсистемы hooks: `external-systems/hooks.md` (материализованный анализ §8 architecture).
- Скрипт `scripts/bootstrap-dev-env.sh` — детектит pkg-manager, выводит команду установки.
- Скрипт `scripts/bench-hooks.sh` — бенчмарк 5 детерминированных hooks (NFR hooks-performance).
- Bats-тесты: `tests/unit/validate-artifact.bats` (6), `tests/unit/check-cross-refs.bats` (6), `tests/unit/enforce-no-comments.bats` (6), `tests/unit/bootstrap-dev-env.bats` (3).
- CI workflow `.github/workflows/ci.yml` — bats + shellcheck + shfmt + deterministic checks.
- Фикстура `tests/fixture/minimal-target/` — минимальный валидный каркас для integration-тестов.
- GitHub Issue templates: `.github/ISSUE_TEMPLATE/bug.yml`, `feature.yml`, `question.yml`.
- `SUPPORT.md` в корне — канал обратной связи и политика reply.
- `CHANGELOG.md` восстанавливает версии 0.1.0 → 0.1.2 + текущая 0.2.0.
- README плагина §Scripts расширен до 11 скриптов.

### Changed
- `plugin-config.md`: активированы `tdd_pairs` для 4 скриптов; formatter=`shfmt -i 2 -ci`, linter=`shellcheck`.
- `profile.md`: testing=mid, development=mid, deployment=mid, operations=pet.
- `alphas.md`: Software System → Demonstrable; Work → Under Control; Way of Working → In Use.
- Убрана неиспользуемая переменная `body` в `scripts/validate-artifact.sh` (SC2034).
- `scripts/check-cross-refs.sh`: рефактор SC2015 (паттерн `A && B || C` → explicit if-then-else).
- Трассировки `traces_to` заполнены между всеми соседними фазами (двунаправленная цепочка).

### Fixed
- `plugin-config.md`: формат `command:` без пустой строки (парсер hook игнорирует).
- Интерпретация `scope_globs` hook-ом: inline-массив YAML вместо multi-line списка.

## [0.1.2] — 2026-04-17

### Fixed
- Интерактивность skills фаз: обязательный вызов `AskUserQuestion` до записи артефактов.
- 6 hook-багов: шедбанг, экранирование, парсинг YAML, обработка stdin.

## [0.1.1] — 2026-04-15

### Changed
- Release bump; подготовка к публикации в marketplace.

## [0.1.0] — 2026-04-10

### Added
- Первый релиз плагина: каркас SDLC, catalogs, мета-шаблоны, 12 skills, 8 commands, 5 agents, 8 скриптов.
- Принципы Волны 1 (1-13 + 4a).
- Демо-сценарий на todo-list.

[Unreleased]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.4...HEAD
[0.5.4]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.3...v0.5.4
[0.5.3]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.2...v0.5.3
[0.5.2]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/ypolosov/ai-driven-sdlc-plugin/releases/tag/v0.1.0
