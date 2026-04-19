---
name: sdlc-operations
description: Фаза Operations — эксплуатация и эволюция системы в продакшне. Мониторинг, инциденты, обратная связь. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Запускается командой /sdlc-phase operations.
phase: operations
scope: phase
disciplines: [site-reliability-engineering]
alphas: [Software System, Opportunity]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Пассивный сбор логов и внешняя проверка доступности"}
  mid: {method_abstract: "Метрики, журналирование, оповещения с задокументированной процедурой реагирования"}
  enterprise: {method_abstract: "Полная наблюдаемость и управление инцидентами по SLO с бюджетом ошибок"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Operations

## Назначение фазы

Настроить наблюдаемость и реакцию на инциденты.
Запустить цикл обратной связи от пользователей к Vision.
Зафиксировать SLO/SLI (для mid+).

## Альфы, которые продвигает

- **Software System** — Operational; при выводе — Retired.
- **Opportunity** — переход к Benefit Accrued при наличии измеримой ценности.

## Дисциплины

- Site reliability engineering.

## Обязательный интерактивный опрос (принцип 1)

**Skill ведёт пользователя по фазе; не заменяет его решения автогенерацией.**

Шаг 0 — ДО записи любых артефактов:
1. Вызвать `AskUserQuestion` с вопросами ниже.
2. Показать 2–3 альтернативы по каждому выбору.
3. Дождаться ответа пользователя; не угадывать.
4. Auto mode среды не отменяет интерактивность.
5. Только `/sdlc-autonomy --task hootl` разрешает пропуск опроса.
6. Если `AskUserQuestion` недоступна — остановиться и сообщить пользователю.

### Вопросы фазы Operations

Сначала SME-опрос делегируется `sdlc-method-engineering` с `phase: operations`.
Дополнительно:
1. Какие ключевые сигналы наблюдаемости? (логи, метрики, трассировка)
2. Какие SLO/SLI определены? (mid+)
3. Кто в on-call? (связь с `catalogs/roles.md`)
4. Как инциденты возвращаются в цикл Vision? (postmortem → новые требования)

## Протокол инстанцирования

1. **Обязательно:** вызвать `AskUserQuestion` с блоком выше и дождаться ответов.
2. Вызвать `sdlc-method-engineering` с `phase: operations`.
3. Получить уровень SME и инструмент наблюдаемости.
4. Через `context7` получить референс выбранного инструмента.
5. Инстанцировать артефакт runbook/мониторинга в `phases/operations/`.
6. Обеспечить trace-ссылки на deployment и vision.
7. Обновить `alphas.md` — Opportunity и Software System.

## Критерии готовности

- Артефакт фазы валиден.
- `traces_from` указывает на deployment.
- Альфа Software System в Operational.
- Сигналы наблюдаемости запущены (минимум: логи и health-check).
- `check-cross-refs.sh` проходит.

## Следующие шаги по ролям

- sre → мониторить; при инциденте — postmortem, возврат в vision/requirements.
- product-owner → анализ метрик успеха; переоткрыть vision.
- method-engineer → пересмотр SME-уровней на основе операционного опыта.
