---
name: sdlc-integrations
description: Сквозная фаза подключения внешних SDLC-инструментов целевого. Опрашивает пользователя через AskUserQuestion, привязывает категории из catalogs/tool-categories.md к конкретным MCP-серверам, фиксирует выбор в tool-bindings.md и decisions.md. Делегирует тесту через sdlc-tool-router.
scope: cross-cutting
disciplines: [continuous-delivery, situational-method-engineering]
alphas: [Way of Working, Software System]
default_autonomy: hitl
source: ADR-013 (категории как агностический интерфейс); принципы 1, 3, 18
meta_templates: [tool-binding.meta.md, plugin-config.meta.md, credentials.meta.md]
---

# Skill: подключение внешних инструментов SDLC

## Назначение фазы

Установить связь «категория → MCP-сервер» для каждой категории, релевантной проекту.
Не навязывать продукты; только запросить у пользователя.
Зафиксировать выбор в `<target>/.claude/sdlc/tool-bindings.md`.
Подготовить ключи окружения через `.env.example` (принцип 10).

## Альфы, которые продвигает

- **Way of Working** — уточнение интеграционного слоя.
- **Software System** — расширение знаний о среде эксплуатации.

## Дисциплины

- Continuous Delivery (`catalogs/disciplines.md`).
- Situational Method Engineering — выбор инструмента по уровню SME.

## Обязательный интерактивный опрос (принцип 1)

**Шаг 0 — ДО любой записи:**
1. Вызвать `AskUserQuestion` с абстрактными мета-вопросами.
2. Показать 2–3 альтернативы (категория, MCP-сервер, уровень).
3. Дождаться ответа пользователя; не угадывать имена продуктов.
4. В HOOTL — выбрать дефолт по уровню SME, записать альтернативы в `decisions.md`.
5. При недоступности `AskUserQuestion` в HITL/HOTL — остановиться.

## Мета-вопросы (без имён продуктов)

1. Какие категории SDLC-инструментов используются в проекте?
2. Какова форма state-артефакта для альфы Work? (плоский файл / трекер / PM)
3. Где живут спецификации и runbooks? (репо / wiki / корпоративная база)
4. Какие observability-сигналы критичны? (метрики / логи / трейсы / алерты)
5. Какова стратегия выкатов? (ручной / blue-green / canary / GitOps)
6. Сколько каналов коммуникации обязательны? (один / несколько / DLP-aware)
7. Каков уровень SME проекта? (pet / mid / enterprise)

## Варианты по уровню SME

- **pet** — инлайн-привязки в `plugin-config.md`; одна-две категории.
- **mid** — отдельный `tool-bindings.md`; 3–5 категорий через MCP-серверы.
- **enterprise** — полный `tool-bindings.md` + `webhooks.md` (Wave 5).

## Протокол инстанцирования

1. Прочитать `catalogs/tool-categories.md` для списка допустимых категорий.
2. Прочитать `<target>/.claude/sdlc/profile.md` для уровня SME.
3. **Обязательно** в HITL/HOTL вызвать `AskUserQuestion` для каждой категории.
4. Для каждой выбранной категории зафиксировать запись в `tool-bindings.md`.
5. Если категория требует токен — добавить ключи в `.env.example` (без значений).
6. Записать запись в `decisions.md` с альтернативами и мотивом.
7. Запустить `scripts/check-tool-binding.sh <target>`; при ошибке остановиться.
8. Запустить `scripts/detect-credentials.sh <target>`; вывести отчёт.

## Критерии готовности

- `tool-bindings.md` существует и проходит `check-tool-binding.sh`.
- `.env.example` содержит все ключи `env_keys` без значений.
- `.gitignore` содержит `.env` (`detect-credentials.sh` зелёный).
- `decisions.md` содержит запись с ≥2 альтернативами.

## Следующие шаги по ролям

- developer / devops → продолжить через `/sdlc-tools test` для верификации стека.
- method-engineer → пересмотр привязок через `/sdlc-tools bind` или `/sdlc-tools unbind`.
- security-engineer → ревью `env_keys` и rate-limit'ов.

## Связи

- Команда — `/sdlc-tools` (list/bind/test/unbind).
- Агент исполнения — `sdlc-tool-router`.
- Категории — `catalogs/tool-categories.md` (ADR-013).
- Закрывает epic #3 (dev-time vs runtime MCP), epic #13 (верификация стека).
