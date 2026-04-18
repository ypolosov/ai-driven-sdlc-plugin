---
name: audit-report.meta
type: meta-template
scope: схема audit.md — отчёт /sdlc-audit
location_in_target: .claude/sdlc/audit.md
exempt_from_15_words: true
---

# Мета-шаблон `audit.md`

Отчёт сквозной проверки консистентности артефактов.
**Исключение из правила ≤15 слов** (принцип 4.б) — отчёт требует свободных формулировок.

## Обязательный frontmatter

```yaml
---
name: audit
type: audit-report
project: <slug>
run_at: <YYYY-MM-DD HH:MM>
auditor: sdlc-consistency-auditor
status: pass | warn | fail
issues_count: <число>
---
```

## Обязательные секции

### 1. Резюме
Короткий вывод: всё согласовано / найдены расхождения.

### 2. Проверки

Таблица: проверка, статус, детали.

| Проверка | Статус | Детали |
|---|---|---|
| Трассируемость фаз | pass|warn|fail | … |
| Соответствие уровню SME | pass|warn|fail | … |
| Альфы ↔ артефакты | pass|warn|fail | … |
| System-context ↔ архитектура | pass|warn|fail | … |
| Осиротевшие ссылки | pass|warn|fail | … |
| TDD-семантика | pass|warn|fail | … |
| Memom-консистентность (Волна 2) | pass|warn|fail | … |

### 3. Найденные расхождения
Список с категорией критичности (blocker / important / note), локацией и описанием.

### 4. Предложенные фиксы
Для каждого расхождения — 2–3 альтернативы (принцип 1).
Пользователь выбирает через `/sdlc-audit --apply` (в HOOTL выбор логируется в `decisions.md`).

### 5. Привязка к альфам
Состояние ключевых альф на момент аудита (через `sdlc-alpha-tracker`).

## Правила

- Отчёт перезаписывается при каждом запуске `/sdlc-audit`.
- История прогонов хранится в git-истории, не в файле.
- Статус `fail` блокирует merge в main (через pre-commit / CI).
- Статус `warn` не блокирует, но подсвечивается в `/sdlc-status`.
