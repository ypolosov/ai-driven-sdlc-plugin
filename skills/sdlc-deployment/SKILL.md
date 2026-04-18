---
name: sdlc-deployment
description: Фаза Deployment — автоматизированная доставка изменений в среды. Выбор уровня SME и инструмента делегируется sdlc-method-engineering. Запускается командой /sdlc-phase deployment.
phase: deployment
scope: phase
disciplines: [continuous-delivery]
alphas: [Software System]
default_autonomy: hitl
levels:
  pet: {method_abstract: "Ручное развёртывание в одну среду одной командой"}
  mid: {method_abstract: "Автоматизированный конвейер с несколькими средами и обратимой стратегией"}
  enterprise: {method_abstract: "Декларативная доставка с прогрессивным выкатом, флагами и мультирегионом"}
meta_template: meta-templates/phase-artifact.meta.md
---

# Skill: фаза Deployment

## Назначение фазы

Настроить доставку изменений в среды с нужным уровнем автоматизации.
Определить стратегию отката и обратимость выката.
Зафиксировать окружения и процесс релизов.

## Альфы, которые продвигает

- **Software System** — от Usable до Ready, далее Operational.

## Дисциплины

- Continuous delivery.

## Мета-вопросы

Опрос делегируется `sdlc-method-engineering` с контекстом `phase: deployment`.
Дополнительно:
1. Сколько сред нужно? (pet: одна; mid: staging+prod; enterprise: multi-region)
2. Какая стратегия релиза? (manual / blue-green / canary / progressive)
3. Где хранятся секреты сред? (связь с `.env` и принципом 10)
4. Как откатывать релиз? (ручной rollback / автоматический по метрикам)

## Протокол инстанцирования

1. Вызвать `sdlc-method-engineering` с `phase: deployment`.
2. Получить уровень SME и инструмент CI/CD.
3. Через `context7` получить референс выбранного инструмента.
4. Инстанцировать артефакт описания pipeline в `phases/deployment/`.
5. Обеспечить trace-ссылки на testing (фазы не разворачиваются без тестов).
6. Обновить `alphas.md`.

## Критерии готовности

- Артефакт фазы валиден.
- `traces_from` указывает на testing.
- Альфа Software System достигла минимум Ready.
- `.env.example` согласован с потребностями сред.
- `check-cross-refs.sh` проходит.

## Следующие шаги по ролям

- devops → запуск первого релиза; мониторинг.
- sre → `/sdlc-phase operations`.
- product-owner → переоткрыть `/sdlc-phase vision` при новых инсайтах.
