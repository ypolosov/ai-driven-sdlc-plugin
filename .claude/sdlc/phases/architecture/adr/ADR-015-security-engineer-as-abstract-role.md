---
name: ADR-015
type: adr
title: Security-engineer как абстрактная роль и поля agent_kind/tool_categories
status: Accepted
date: 2026-05-05
nfr: [security, maintainability]
principles: [3, 11]
---

# ADR-015: Security-engineer как абстрактная роль и поля `agent_kind`/`tool_categories`

## Контекст

Каталог абстрактных ролей до Wave 4 содержал 8 ролей.
Безопасность инкапсулировалась внутри `devops` и `architect`.
Роли стейкхолдеров (BO, BD, FD, QE, CR, CA, RM) специфичны для целевого проекта.
Принцип 3 запрещает конкретные роли в плагине; их место — в целевом.
Wave 4 multi-agent extension вводит коллаборацию `human` + `ai` ролей.

## Решение

Каталог `catalogs/roles.md` расширяется одной новой абстрактной ролью.
Новая роль — `security-engineer` (отдельно от `sre`).
Конкретные роли (BO, BD, FD, QE, CR, CA, RM) остаются в `role-extensions.md` целевого.
Схема записи роли расширяется двумя полями: `tool_categories`, `agent_kind`.
Поле `tool_categories` ссылается на категории `catalogs/tool-categories.md` (ADR-013).
Поле `agent_kind` принимает значения `human`, `ai`, `both`.
Создаётся `meta-templates/target-roles.meta.md` с примерами по уровню SME.

## Альтернативы

- A1. Не вводить `security-engineer`, оставить в `devops`.
  Отказ: нарушает принцип разделения интересов, скрывает SE-метрики.
- A2. Ввести роли BO/BD/FD/QE/CR/CA/RM/UX-UI в плагин.
  Отказ: нарушает принцип 3; роли специфичны для проекта.
- A3. Вместо поля `agent_kind` создать отдельный каталог AI-агентов.
  Отказ: дублирует `agents/` плагина; усложняет ролевую модель.

## Последствия

- Закрытие epic #6: переключение ролей по фазам поддержано формально.
- Закрытие epic #21: альфы Work и Team получают роль через `agent_kind: ai`.
- Каталог абстрактных ролей: 9 ролей вместо 8.
- Конкретные роли проекта живут в `<target>/.claude/sdlc/role-extensions.md`.
- Категории инструментов привязаны к ролям через `tool_categories`.
- AI-агенты явно отмечены через `agent_kind`; не путаются с человеческими.
- Bats `target-roles-schema.bats` валидирует схему.
- README плагина обновляется: `Catalogs` остаётся 5; +1 meta-template.

## Связь

- Реализует принцип 3 (абстрактное в плагине).
- Подкрепляет принцип 11 (ролевая навигация).
- Использует ADR-013 (tool-categories как агностический интерфейс).
- Закрывает epic #6 (обязательность переключения ролей по фазам).
- Закрывает epic #21 (alphas Work и Team без роли-владельца).
