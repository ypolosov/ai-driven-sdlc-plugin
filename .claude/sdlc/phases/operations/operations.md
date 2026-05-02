---
name: operations
type: operations
phase: operations
sme_level: pet
method: GitHub Issues как единственный канал обратной связи
tool: Issue templates + SUPPORT.md
alphas: [Software System, Opportunity]
disciplines: [user-support, feedback-management]
role: method-engineer
traces_from:
  - ../deployment/deployment.md
  - ../vision/vision.md
traces_to: []
system_of_attention: ai-driven-sdlc-plugin
created: 2026-04-19
updated: 2026-05-02
---

# Стратегия фазы operations плагина ai-driven-sdlc

## 1. Назначение

Обеспечить работу плагина в продуктиве после релиза.
Поддержка пользователей: баги, фичи, вопросы.
Метод — GitHub Issues с темплейтами как единственный канал.

## 2. Привязка к фазе и методу

- Фаза: operations.
- Уровень SME: pet (solo-разработчик, без SLA).
- Дисциплина: user-support, feedback-management.
- Инструменты: GitHub Issues, Issue templates, SUPPORT.md.

## 3. Содержание

### 3.1. Каналы обратной связи

| Канал | Назначение | Ожидаемое время ответа |
|---|---|---|
| GitHub Issues (bug) | Репорт о баге с воспроизведением | best-effort |
| GitHub Issues (feature) | Предложение новой функциональности | best-effort |
| GitHub Issues (question) | Вопрос по использованию | best-effort |
| Email автора | Сенситивные вопросы | best-effort |

### 3.2. Issue templates

- `.github/ISSUE_TEMPLATE/bug.yml` — обязательные поля: версия, команда, ожидаемое, фактическое.
- `.github/ISSUE_TEMPLATE/feature.yml` — мотивация, альтернативы, scope.
- `.github/ISSUE_TEMPLATE/question.yml` — контекст, попытки решения.
- `.github/ISSUE_TEMPLATE/work-unit.yml` — scope, альфа, фаза, AC, DoD, трассировки.

Labels: `bug`, `feature`, `question`, `work-unit`, `wave-1`, `wave-2`, `wave-3`, `good-first-issue`, `wontfix`.
Milestones: `Wave 1` (closed), `Wave 2` (closed), `Wave 3` (текущий backlog).

### 3.3. Triage процесс

Еженедельный triage issues автором:

1. Присвоить label.
2. Оценить приоритет (P0-blocker / P1-important / P2-nice-to-have).
3. Перенести P0 в backlog фазы development.
4. Закрыть дубликаты и невалидные.

### 3.4. Incident response

- P0-баг → hotfix PATCH в течение best-effort.
- Regression → автоматизировать как bats-тест.
- Security issue → приватный контакт через SUPPORT.md, patch, CVE-запись.

### 3.5. Документация для пользователей

- `README.md` — установка, quickstart, философия.
- `SUPPORT.md` — где и как сообщать проблемы.
- `CHANGELOG.md` — история изменений.
- `CLAUDE.md` плагина — принципы и конституция.

### 3.6. Метрики (opt-out)

- Плагин не собирает телеметрию.
- Метрики использования — только через marketplace (если предоставит).
- Пользовательский feedback — через Issues.

## 4. Трассируемость

- `traces_from`:
  - [`deployment.md`](../deployment/deployment.md) — процесс релизов.
  - [`vision.md`](../vision/vision.md) — ценность для стейкхолдеров (Opportunity).
- `traces_to`: пуст; operations — последняя фаза SDLC.

## 5. Критерии готовности фазы

- Артефакт `operations.md` валиден.
- 4 issue templates созданы и работают: bug, feature, question, work-unit.
- `SUPPORT.md` в корне репозитория.
- `CHANGELOG.md` процесс (из deployment.md) согласован с issue triage.
- Альфа Opportunity может достичь Addressed при первом внешнем пользователе.

## 5a. Soak-периоды релизов

### Soak v0.3.0 (2026-05-02 → 2026-05-09)

- Релиз: v0.3.0 essence-alpha-mcp authoritative backend.
- Канал feedback: GitHub Issues label `essence-alpha-feedback`.
- Метрики soak (manual weekly):
  - Внешние установки v0.3.0 через GitHub Insights.
  - Issue с label `essence-alpha-feedback`.
  - `essence_validate_consistency` ok-стабильность.
  - `bench-hooks.sh` latency 8 hooks <200ms.
- Цель soak — ≥1 external feedback подтверждающего value.
- При успехе: продвинуть Software System Usable → Ready через MCP.
- При успехе: продвинуть Opportunity Value Established → Addressed через MCP.
- При critical issue: patch v0.3.1 через `/sdlc-phase deployment`.
- Финальный аудит: `/sdlc-audit` после soak; запись итогов в decisions.md.

## 6. Открытые вопросы

- GitHub Discussions — активировать при росте сообщества.
- Автоматизация triage (bots, labels) — при росте потока issues.
- Telemetry opt-in — отложено до clarity от marketplace Claude Code.
