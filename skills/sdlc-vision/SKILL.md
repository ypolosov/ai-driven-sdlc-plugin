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

## Мета-вопросы

Опрос делегируется `sdlc-method-engineering` с контекстом `phase: vision`.
Дополнительно в фазе Vision задаются:
1. Кто основной бенефициар целевой системы?
2. Какую проблему решает система; что происходит без неё?
3. Какие альтернативные решения уже существуют?
4. Какие стейкхолдеры имеют противоречивые интересы?

## Протокол инстанцирования

1. Вызвать `sdlc-method-engineering` с `phase: vision`.
2. Получить выбранный уровень SME и инструмент.
3. Через `context7` получить референсную структуру инструмента.
4. Инстанцировать артефакт в `<target>/.claude/sdlc/phases/vision/<artifact>.md`.
5. Обновить `alphas.md` через `sdlc-alpha-tracker` (продвижение Opportunity и Stakeholders).
6. Записать решение в `decisions.md` (принцип 1).

## Критерии готовности

- Артефакт фазы существует и валиден (`validate-artifact.sh`).
- Альфа Opportunity достигла минимум Value Established.
- Альфа Stakeholders достигла минимум Recognized.
- `check-cross-refs.sh` не находит осиротевших ссылок.

## Следующие шаги по ролям

- product-owner → `/sdlc-phase requirements`.
- architect → `/sdlc-phase requirements` (если vision уточнена).
- systems-thinker → `/sdlc-focus` на надсистему для проверки границ.
