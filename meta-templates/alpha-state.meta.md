---
name: alpha-state.meta
type: meta-template
scope: схема alphas.md — состояния альф SDLC
location_in_target: .claude/sdlc/alphas.md
---

# Мета-шаблон `alphas.md`

Состояние альф SDLC в целевом проекте.
Единственный источник истины — агент `sdlc-alpha-tracker`.
Другие агенты не читают этот файл напрямую; только через трекер.

## Два режима артефакта

Поддерживаются два режима ведения, выбор фиксируется в frontmatter `type`.

- `alpha-journal` — markdown ведёт и snapshot, и журнал переходов.
- `alpha-snapshot` — markdown содержит только snapshot; журнал делегирован MCP-backend (см. ADR-009 целевого).

## Обязательный frontmatter

### Режим alpha-journal

```yaml
---
name: alphas
type: alpha-journal
project: <slug>
updated: <YYYY-MM-DD>
---
```

### Режим alpha-snapshot

```yaml
---
name: alphas
type: alpha-snapshot
project: <slug>
updated: <YYYY-MM-DD>
source_of_truth: <mcp://server-name>
snapshot_role: pr-visible-mirror
generated_after: mcp-write
---
```

Поле `source_of_truth` указывает на авторитативный backend.
Поле `snapshot_role` фиксирует назначение markdown-файла.
Поле `generated_after` фиксирует условие обновления snapshot.

## Обязательные секции

### 1. Текущее состояние альф

Таблица: альфа, текущее состояние, артефакт-свидетельство, дата.

| Альфа | Состояние | Артефакт-свидетельство | Дата |
|---|---|---|---|
| Opportunity | <из alphas-catalog> | <ссылка на артефакт> | <YYYY-MM-DD> |
| Stakeholders | … | … | … |
| Requirements | … | … | … |
| Software System | … | … | … |
| Work | … | … | … |
| Team | … | … | … |
| Way of Working | … | … | … |

### 2. Журнал переходов (alpha-journal)

Запись на каждое продвижение альфы: дата, альфа, было/стало, артефакт.

### 2. Журнал переходов (alpha-snapshot)

Журнал делегирован MCP-серверу через `essence_list_transitions`.
Markdown содержит только указатель на источник журнала.

## Правила

- Переход в новое состояние требует подтверждающего артефакта.
- Без артефакта продвижение отклоняется `sdlc-consistency-auditor`.
- Откат в предыдущее состояние возможен с записью в журнале.
- Набор альф расширяется через `catalogs/alphas.md` (не здесь).
- Snapshot обновляется атомарно после успешного MCP-вызова.
- При ошибке MCP markdown не трогается (см. ADR-009).
