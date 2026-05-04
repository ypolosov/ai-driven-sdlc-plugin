---
name: adr-index
type: adr-index
project: ai-driven-sdlc-plugin
updated: 2026-05-05
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
| ADR-009 | Авторитативный backend альф через essence-alpha-mcp | Deprecated (superseded by ADR-011) | reliability, maintainability |
| ADR-015 | Security-engineer как абстрактная роль и поля agent_kind/tool_categories | Accepted | security, maintainability |
| ADR-016 | Маршрутизатор инструментов и реестр привязок tool-bindings | Accepted | security, maintainability, extensibility |
| ADR-010 | Multi-agent topology — aggregator-фасад поверх tool-router'а | Accepted | reliability, maintainability, security |
| ADR-011 | Единый sdlc-state-rag backend (PostgreSQL+pgvector + embedded OMG Essence) | Accepted | reliability, maintainability, security, performance |

## Правила ведения

- Новый ADR получает следующий номер по возрастанию.
- Статусы: Proposed → Accepted → Deprecated → Superseded.
- Замена решения — новый ADR со ссылкой `Supersedes: ADR-NNN`.
- Ранее принятые ADR не переписываются; только меняется статус.
