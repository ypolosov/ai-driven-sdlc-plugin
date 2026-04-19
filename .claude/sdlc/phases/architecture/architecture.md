---
name: architecture
type: architecture
phase: architecture
sme_level: mid
method: Фиксация значимых решений и многоуровневое моделирование
tool: ADR (Nygard)
alphas: [Software System, Requirements]
disciplines: [software-architecture, functional-decomposition]
role: method-engineer
traces_from:
  - ../requirements/requirements.md
  - ../vision/vision.md
traces_to:
  - ../testing/testing.md
system_of_attention: ai-driven-sdlc-plugin
nfr: [extensibility, reversibility, determinism, hooks-performance, security]
created: 2026-04-19
updated: 2026-04-19
---

# Архитектура плагина ai-driven-sdlc

## 1. Назначение

Продвинуть альфу Software System в состояние Architecture Selected.
Уточнить альфу Requirements до Acceptable через фиксацию NFR.
Метод — ADR (Architecture Decision Records) по файлу на значимое решение.

## 2. Привязка к фазе и методу

- Фаза: architecture.
- Уровень SME: mid.
- Дисциплины: software-architecture, functional-decomposition.
- Инструмент: ADR (Nygard).
- Формат: один ADR = один файл в `phases/architecture/adr/ADR-NNN.md`.

## 3. Функциональная декомпозиция

Метод функциональной декомпозиции по Левенчуку Том 2 гл. 10.
Функции описаны через роли и альфы, не через имплементацию.

### 3.1. Функции плагина

| Функция | Роль-исполнитель | Продвигаемые альфы |
|---|---|---|
| Интерактивный опрос пользователя | skills фаз | Way of Working |
| Выбор метода и инструмента (SME) | sdlc-method-engineer | Way of Working |
| Хранение состояния альф | sdlc-alpha-tracker | все альфы |
| Перенос фокуса внимания | sdlc-focus | Software System |
| Аудит консистентности | sdlc-consistency-auditor | Way of Working |
| Валидация артефактов | scripts hooks | Way of Working |
| Чтение состояния | sdlc-state-reader | Work |
| Документация систем внимания | system-readme.meta | Software System |

### 3.2. Подсистемы плагина (materialized)

| Подсистема | Назначение | Входит в |
|---|---|---|
| `skills/` | Интерактивные фазы SDLC | Плагин |
| `commands/` | Точки входа `/sdlc-*` | Плагин |
| `agents/` | LLM-агенты (tracker, auditor, reader, method-engineer, validator) | Плагин |
| `scripts/` | Детерминированные проверки и bootstrap | Плагин |
| `hooks/` | Регистрация PreToolUse/PostToolUse | Плагин |
| `catalogs/` | alphas, disciplines, roles, method-tool-matrix | Плагин |
| `meta-templates/` | Схемы артефактов | Плагин |

### 3.3. Граф создания (Том 2 гл. 8)

- Система создания: пользователь (method-engineer) + Claude Code + MCP github.
- Создаваемая система: целевая IT-система (в dogfooding — сам плагин).
- Плагин — инструмент системы создания; не часть целевой системы.

## 4. Качественные атрибуты (NFR)

Пять атрибутов зафиксированы на фазе; каждый раскрыт в ADR.

| NFR | Описание | Фитнес-функция |
|---|---|---|
| extensibility | Пользователь добавляет инструменты в `method-tool-extensions.md` | matrix + extension объединяются runtime |
| reversibility | Действия обратимы или требуют подтверждения | `/sdlc-init --fail-if-exists` default |
| determinism | Проверяемые задачи выполняют скрипты, не LLM | принцип 6 |
| hooks-performance | Hooks не замедляют пользователя ощутимо | exit <200ms на средний артефакт |
| security | Секреты целевого проекта не утекают в git | `.env` в `.gitignore`, нет токенов в артефактах |

Покрытие NFR по ADR (поле `frontmatter.nfr`):

- extensibility → ADR-001, ADR-003, ADR-004.
- reversibility → ADR-004, ADR-007.
- determinism → ADR-002, ADR-005, ADR-006.
- hooks-performance → ADR-006.
- security → ADR-008.

## 5. Ключевые Architecture Decision Records

Полный индекс ADR — в [adr/README.md](adr/README.md).

| ADR | Заголовок | Статус |
|---|---|---|
| [ADR-001](adr/ADR-001-methodology-framework-not-technology.md) | Методологический каркас, не технология | Accepted |
| [ADR-002](adr/ADR-002-alphas-as-tracking-units.md) | Альфы Essence как единицы отслеживания | Accepted |
| [ADR-003](adr/ADR-003-situational-method-engineering.md) | SME по фазам независимо | Accepted |
| [ADR-004](adr/ADR-004-state-artifact-external.md) | State-артефакт вне плагина | Accepted |
| [ADR-005](adr/ADR-005-tdd-three-layers.md) | TDD в три слоя проверки | Accepted |
| [ADR-006](adr/ADR-006-deterministic-over-llm.md) | Детерминированное приоритетнее LLM | Accepted |
| [ADR-007](adr/ADR-007-artifact-path-convention.md) | Артефакты в `.claude/sdlc/` | Accepted |
| [ADR-008](adr/ADR-008-secrets-outside-git.md) | Секреты целевого проекта вне git | Accepted |

## 6. Трассируемость

- `traces_from`: [`requirements.md`](../requirements/requirements.md) (US-01…US-08), [`vision.md`](../vision/vision.md).
- `traces_to`: [`testing.md`](../testing/testing.md) — fitness-функции §4 покрывают 4 из 5 NFR.
- Подсистема `hooks` — кандидат на отдельный `/sdlc-focus` после фазы.

## 7. Критерии готовности фазы

- Главный артефакт `architecture.md` валиден.
- Минимум 5 ADR зафиксированы в `adr/`.
- Все NFR раскрыты в соответствующих ADR.
- `traces_from` ссылается на artefact requirements и vision.
- Альфа Software System достигла Architecture Selected.
- Функциональная декомпозиция согласована с `system-context.md`.

## 8. Открытые вопросы

- Границы подсистемы `hooks` требуют отдельного `/sdlc-focus`.
- NFR `hooks-performance` не имеет метрик; нужен бенчмарк-скрипт.
- ADR для Волны 3 (memom-эволюция принципов) пока не выделены.
