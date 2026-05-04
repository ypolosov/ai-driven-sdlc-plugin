---
name: essence-alpha-mcp
type: system-readme
kind: logical
role_vs_target: in_environment
project: ai-driven-sdlc-plugin
last_focused_at: 2026-04-30
focus_count: 1
updated: 2026-04-30
---

# Описание системы essence-alpha-mcp

## 1. Назначение и границы

Внешний npm-пакет `@ypolosov/essence-alpha-mcp` v0.1.1+.
Предоставляет детерминированную state machine 7 альф OMG Essence 1.2.
Устанавливается глобально (`npm install -g`) и запускается как `essence-alpha-mcp serve` (stdio MCP) либо CLI.
Граница — npm-пакет; код в репо `github.com/ypolosov/essence-alpha-mcp`.

В v0.1.0 был баг ранний-exit stdio-сервера (исправлен в v0.1.1) — минимальная поддерживаемая версия v0.1.1.

## 2. Текущий фокус

- Роль относительно целевой (плагина): in_environment (внешняя зависимость).
- last_focused_at: 2026-04-30 (момент интеграции, см. PR #22).
- focus_count: 1.

## 3. Состояние альф относительно системы

Данные запрашиваются через `sdlc-alpha-tracker` (принцип 13).

| Альфа | Состояние | Артефакт-свидетельство |
|---|---|---|
| Software System | Usable | `CHANGELOG.md#0.2.1`; пакет публикуется в npm |
| Requirements | Acceptable | ADR-009 §Decision; контракт MCP-tools |
| Way of Working | In Use | `agents/sdlc-alpha-tracker.md` §3 advance |

## 4. Связанные артефакты SDLC

- `phases/architecture/adr/ADR-009-essence-alpha-mcp-integration.md` — решение интеграции.
- `phases/architecture/architecture.md` §3.1 — строка про MCP-валидацию альф.
- `phases/architecture/architecture.md` §4 — NFR reliability и maintainability.
- `agents/sdlc-alpha-tracker.md` — контракт вызовов MCP-tools.
- `scripts/check-alpha-consistency.sh` — PostToolUse hook на snapshot.
- `meta-templates/alpha-state.meta.md` — режим alpha-snapshot.
- `.mcp.json` — регистрация stdio-сервера `essence-alpha`.
- `.gitignore` — исключение SQLite-БД и WAL-файлов.

## 5. Роли, активные в системе

- `method-engineer` — задаёт правила продвижения альф через MCP.
- `sdlc-alpha-tracker` — единственный клиент MCP-tools в плагине.
- `sdlc-consistency-auditor` — потребитель `essence_validate_consistency`.

Определения ролей — `catalogs/roles.md` плагина.

## 6. Контракт MCP

### 6.1. Зарегистрированные tools

| Tool | Назначение |
|---|---|
| essence_get_alpha_state | текущее состояние альфы по kebab-id |
| essence_advance_alpha | продвижение с обязательным evidence_uri |
| essence_regress_alpha | откат с обязательным rationale |
| essence_list_transitions | журнал переходов из БД |
| essence_validate_consistency | 4 инварианта БД |
| essence_describe_alpha | формальное описание альфы |
| essence_get_state_chart | граф состояний альфы |

### 6.2. Соглашения о именах

- Имя сервера в `.mcp.json` — kebab `essence-alpha`.
- Tools в frontmatter agent'а — snake `mcp__essence_alpha__essence_*`.
- Альфы snake-id: `opportunity`, `software-system`, `way-of-working`.
- Маппинг PascalCase ↔ kebab делает агент.

### 6.3. Схема evidence_uri

- Допустимые схемы — `file://` и `https://`.
- `file://` адрес — абсолютный путь к артефакту в репо.
- Прочие схемы отклоняются с EvidenceRequiredError.

## 7. Известные ограничения

- Cold-start `npx -y` требует интернет на первый запуск.
- Кэш npm после первого вызова делает повторы offline-friendly.
- Batch-операция seed не поддерживается; нужен skript-обёртка.
- Миграция исторического журнала markdown→БД отложена (ADR-009 Out of scope).

## 8. Приоритет при аудите

TTL системы из `plugin-config.md` — 30 дней.
Фокус свежий (2026-04-30); расхождения получают полный приоритет.
