# Release v0.3.0 — essence-alpha-mcp authoritative backend

Release date: 2026-05-01

## Highlights

- **MCP integration:** `@ypolosov/essence-alpha-mcp` теперь authoritative backend трекера альф. Markdown `alphas.md` — PR-видимый snapshot; журнал переходов в SQLite-БД через MCP.
- **Bootstrap script:** `scripts/seed-essence-alpha.sh` инициализирует БД 21 переходом по цепочке OMG Essence (idempotent, dry-run support).
- **Fitness coverage:** `bench-hooks.sh` теперь покрывает 8 hooks (+3 новых); все <200ms на NFR `hooks-performance`.
- **Way of Working** продвинут через MCP до состояния `Working Well` — fitness-метрики 8 hooks подтверждают зрелость практики.

## Breaking changes

Нет. Изменение `alphas.md` (snapshot вместо journal) не ломает консьюмеров — `sdlc-alpha-tracker` остаётся единственной точкой доступа (Принцип 13).

## Установка / обновление

```
/plugin install ai-driven-sdlc@ypolosov/ai-driven-sdlc-plugin
```

После обновления — для существующих проектов запустить bootstrap БД:

```
bash scripts/seed-essence-alpha.sh
```

Идемпотентен: повторный запуск не трогает уже заселённые альфы.

## Новые возможности

### Authoritative backend трекера

`agents/sdlc-alpha-tracker.md` использует 6 MCP-tools:

- `essence_get_alpha_state` — текущее состояние.
- `essence_advance_alpha` / `essence_regress_alpha` — переходы с обязательным `evidence_uri`.
- `essence_list_transitions` — журнал из БД.
- `essence_validate_consistency` — 4 инварианта.
- `essence_describe_alpha` / `essence_get_state_chart` — справочные.

### PostToolUse валидация

`scripts/check-alpha-consistency.sh` (6-й PostToolUse hook) автоматически проверяет БД при записи `alphas.md`.

### Расширенный bench

`scripts/bench-hooks.sh` теперь меряет 8 hooks (было 5):

- check-memom-consistency: 12ms
- check-cross-refs: 113ms
- enforce-no-comments: 167ms
- check-readme-inventory: 40ms
- check-system-readmes: 36ms
- validate-artifact: 116ms
- check-alpha-consistency: 117ms (новый)
- enforce-format-lint: 191ms (новый)

## Артефакты SDLC

- ADR-009 — формальное решение интеграции (Nygard).
- `external-systems/essence-alpha-mcp.md` — sidecar logical-системы (Принцип 17).
- `meta-templates/alpha-state.meta.md` — два режима `alpha-journal` и `alpha-snapshot`.
- `memom.md` — запись о расширении принципа 13.

## Внешние зависимости

- `@ypolosov/essence-alpha-mcp` v0.1.0+ через `npx -y` (требует интернет на cold-start).
- БД `.claude/sdlc/essence-alpha.db` — в `.gitignore`.

## Тесты и CI

- 31/31 bats-кейсов зелёные.
- `essence_validate_consistency` ok=true (23 перехода).
- 8/8 hooks <200ms.

## Авторы

- @ypolosov

## Ссылки

- ADR-009: [.claude/sdlc/phases/architecture/adr/ADR-009-essence-alpha-mcp-integration.md](.claude/sdlc/phases/architecture/adr/ADR-009-essence-alpha-mcp-integration.md)
- Diff: https://github.com/ypolosov/ai-driven-sdlc-plugin/compare/v0.2.1...v0.3.0
- Package essence-alpha-mcp: https://www.npmjs.com/package/@ypolosov/essence-alpha-mcp
