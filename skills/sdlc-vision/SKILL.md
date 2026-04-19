---
name: sdlc-vision
description: Фаза Vision — выявление ценности, стейкхолдеров и целей. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Запускается командой /sdlc-phase vision.
phase: vision
scope: phase
disciplines: [product-discovery, stakeholder-analysis]
alphas: [Opportunity, Stakeholders]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Одностраничное описание проблемы и цели без формализации стейкхолдеров"}
  mid: {method_abstract: "Структурированная модель ценности с явными стейкхолдерами и метрикой успеха"}
  enterprise: {method_abstract: "Формальное моделирование мотивации, стратегии и потока ценности"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Vision

## Назначение фазы

Выявить ценность целевой системы и ключевых стейкхолдеров.
Сформулировать цель и не-цели проекта.
Зафиксировать интересы акторов (Левенчук Том 1 гл. 6).

## Альфы, которые продвигает

- **Opportunity** — от Identified до Value Established (pet) или Viable (mid+).
- **Stakeholders** — от Recognized до Represented.

## Дисциплины

- Product discovery.
- Stakeholder analysis.

## Обязательный интерактивный опрос (принцип 1)

**Skill ведёт пользователя по фазе; не заменяет его решения автогенерацией.**

Шаг 0 — ДО записи любых артефактов:
1. Вызвать `AskUserQuestion` с вопросами ниже.
2. Показать 2–3 альтернативы по каждому выбору.
3. Дождаться ответа пользователя; не угадывать.
4. Auto mode среды не отменяет интерактивность.
5. Только `/sdlc-autonomy --task hootl` разрешает пропуск опроса.
6. Если `AskUserQuestion` недоступна — остановиться и сообщить пользователю.

### Вопросы фазы Vision

Сначала SME-опрос делегируется `sdlc-method-engineering` с `phase: vision`.
Дополнительно задаются:
1. Кто основной бенефициар целевой системы?
2. Какую проблему решает система; что происходит без неё?
3. Какие альтернативные решения уже существуют?
4. Какие стейкхолдеры имеют противоречивые интересы?

## Протокол инстанцирования

1. **Обязательно:** вызвать `AskUserQuestion` с блоком выше и дождаться ответов.
2. Вызвать `sdlc-method-engineering` с `phase: vision`.
3. Получить выбранный уровень SME и инструмент.
4. Через `context7` получить референсную структуру инструмента.
5. Инстанцировать артефакт в `<target>/.claude/sdlc/phases/vision/<artifact>.md`.
6. Обновить `alphas.md` через `sdlc-alpha-tracker` (продвижение Opportunity и Stakeholders).
7. Записать решение в `decisions.md` (принцип 1).

## Критерии готовности

- Артефакт фазы существует и валиден (`validate-artifact.sh`).
- Альфа Opportunity достигла минимум Value Established.
- Альфа Stakeholders достигла минимум Recognized.
- `check-cross-refs.sh` не находит осиротевших ссылок.

## Следующие шаги по ролям

- product-owner → `/sdlc-phase requirements`.
- architect → `/sdlc-phase requirements` (если vision уточнена).
- systems-thinker → `/sdlc-focus` на надсистему для проверки границ.
