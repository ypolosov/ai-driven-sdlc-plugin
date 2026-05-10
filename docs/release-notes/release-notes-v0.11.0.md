# Release v0.11.0 — Wave 8 closure: 4 P2 issues + meta-templates

**Type:** minor (Added meta-templates + Fixed hook/bootstrap behavioral changes).
**Date:** 2026-05-11.
**Closes:** Wave 8 (4 PR: #70, #71, #72, #73; 4 issues: #59, #60, #61, #69).
**Tests:** 121 → **154** unit bats (+33 кейса).

## Added (новые meta-templates)

### `meta-templates/iteration.meta.md` (#61, Gap-8)

Kanban-style meta-template для группировки work-units в итерации (sprint/milestone).

- `iteration_id`, `sprint_or_milestone`, `status` (planned/in-progress/completed)
- `work_units` — массив ссылок на work-unit-артефакты
- `start_date`, `end_date`
- Опциональные kanban-метрики: `wip_limit`, `cycle_time_avg`, `velocity`
- Pet/mid/enterprise scope таблица

### `meta-templates/c4-diagram.meta.md` (#60, Gap-7)

Meta-template для C4-диаграмм (Simon Brown).

- `level` enum: Context / Container / Component / Code
- `format` enum: plantuml / structurizr / mermaid
- `file_path` или inline diagram
- `alphas: [Software System]`
- Pet (Mermaid) / mid (PlantUML) / enterprise (Structurizr workspace) scope

### `catalogs/method-tool-matrix.md` Architecture расширено

- mid: `C4 Level 1-2 (PlantUML / Structurizr / Mermaid)`
- enterprise: `C4 Level 1-3 + Structurizr workspace`

## Fixed (поведенческие фиксы)

### `#69` — `check-alpha-consistency.sh` pglite support

PostToolUse hook на Edit `.claude/sdlc/alphas.md` использовал TCP `postgresql://localhost:5432/<project>` fallback по умолчанию. На pet-target с embedded pglite (`<target>/.sdlc-db/`) это вызывало `ECONNREFUSED 5432` в логах.

Логика fix:
- Pet (no DSN, `.sdlc-db/` exists) → exit 0 (trust MCP server).
- No DSN, no pglite → exit 2 + helpful error.
- DSN set → validate как раньше.

### `#59` — `bootstrap-target.sh` valid frontmatter

После `/sdlc-init` 6 артефактов имели `type: placeholder`, что отклонялось `validate-artifact.sh`. Любой immediate Edit на этих файлах блокировался hook'ом.

Теперь bootstrap создаёт валидные минимально-полные артефакты:
- `profile.md` → `type: sdlc-profile`
- `plugin-config.md` → `type: hooks-config`
- `alphas.md` → `type: alpha-snapshot`
- `system-context.md` → `type: attention-context`
- `roles.md` → `type: role-journal`
- `decisions.md` → `type: decision-journal`

Также добавлены минимальные обязательные поля (`project`, `created`, `updated`; type-специфичные дополнительные).

## Changed

- `scripts/bootstrap-target.sh`: удалён pre-existing мёртвый код (unused `write_if_absent` function, unused `templates_root` variable). shellcheck + shfmt clean.
- `tests/unit/`: 121 → **154 кейсов** (+33).

## Test plan executed

```
bats tests/unit/ — 154/154 green
shellcheck scripts/*.sh — clean
shfmt -i 2 -ci -d — no diff
bash scripts/check-readme-inventory.sh — OK
```

## Plugin tools used (принцип 12 dogfooding)

| Tool | Использование |
|---|---|
| skill `/sdlc-phase development` | ×4 (по одному per PR Wave 8) |
| skill `/sdlc-phase deployment` | release v0.11.0 |
| `AskUserQuestion` | Принцип 1 опрос ДО каждой правки |
| `mcp__sdlc-state-rag__decisions_record` | ×5 (id 34-38: 4 PR planning + deployment scope) |
| `mcp__sdlc-state-rag__state_advance_alpha` | Software System evidence на CHANGELOG#0.11.0 |
| TDD-first (принцип 5) | red → fix → green в каждом PR |

Принципы применены: **1** (AskUserQuestion ДО write), **4a** (no comments), **5** (TDD-first), **12** (dogfooding), **20/21** (pet → pglite), **22** (active_phase enforce).

## Установка / обновление

```bash
/plugin marketplace update ypolosov
/plugin update ai-driven-sdlc
```

После update — verify: версия v0.11.0 в settings.

## Counters update

| Метрика | До (v0.10.1) | После (v0.11.0) |
|---|---|---|
| Unit bats files | 16 | **19** (+3) |
| Unit bats cases | 121 | **154** (+33) |
| Meta-templates total | 25 (20 + 5) | **26** (21 + 5) |
| Wave 8 issues closed | 0 | **4** (#59, #60, #61, #69) |

## Backlog после Wave 8 closure

- Pet smoke-test на todo-list app (canonical pet scenario).
- RAG implementation в sdlc-state-rag (когда явная необходимость).
- Wave 9 — пока не определена; зависит от feedback пользователей.

## Audit re-run

После squash merge release/v0.11.0 в main — рекомендуется `/sdlc-audit` для верификации.
