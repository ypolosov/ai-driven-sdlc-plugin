---
name: adr-index
type: adr-index
project: ai-driven-sdlc-plugin
updated: 2026-04-19
---

# Индекс Architecture Decision Records

Каждый ADR фиксирует одно значимое решение с контекстом и последствиями.
Формат Nygard: Context → Decision → Status → Consequences.

## Таблица ADR

| ID | Заголовок | Статус | NFR |
|---|---|---|---|
| ADR-001 | Методологический каркас, не технология | Accepted | extensibility |
| ADR-002 | Альфы Essence как единицы отслеживания | Accepted | determinism |
| ADR-003 | SME по фазам независимо | Accepted | extensibility |
| ADR-004 | State-артефакт вне плагина | Accepted | extensibility |
| ADR-005 | TDD в три слоя проверки | Accepted | determinism |
| ADR-006 | Детерминированное приоритетнее LLM | Accepted | determinism, hooks-performance |
| ADR-007 | Артефакты в .claude/sdlc/ | Accepted | reversibility |
| ADR-008 | Секреты целевого проекта вне git | Accepted | security |

## Правила ведения

- Новый ADR получает следующий номер по возрастанию.
- Статусы: Proposed → Accepted → Deprecated → Superseded.
- Замена решения — новый ADR со ссылкой `Supersedes: ADR-NNN`.
- Ранее принятые ADR не переписываются; только меняется статус.
