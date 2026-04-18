---
name: method-tool-matrix
type: catalog
scope: матрица «метод (абстрактно) × примеры инструментов» для всех фаз SDLC
source: доклад talk-ai-driven-sdlc; Левенчук «Методология 2025» (SME)
warning: единственное место в плагине, где допустимы имена конкретных инструментов
---

# Матрица методов и примеров инструментов

Метод остаётся абстрактным (дисциплина).
Инструменты — сменные конструктивы, реализующие метод.
Пользователь выбирает уровень SME и инструмент; плагин фиксирует выбор в целевом.

## Расширение матрицы

Пользователь может добавить инструмент в `target/.claude/sdlc/method-tool-extensions.md`.
Skill `sdlc-method-engineering` объединяет матрицу плагина и расширение целевого.

## 1. Vision

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Одностраничное описание проблемы и цели без формализации стейкхолдеров | README-as-vision • Elevator Pitch • Mission Statement |
| mid | Структурированная модель ценности с явными стейкхолдерами и метрикой успеха | Lean Canvas • Product Vision Board (Pichler) • OKR |
| enterprise | Формальное моделирование мотивации, стратегии и потока ценности организации | Business Model Canvas • ArchiMate Motivation • Wardley Mapping |

## 2. Requirements

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Свободный список желаемого поведения без критериев приёмки | Плоский TODO-список • Бэклог заметок • Freeform user stories |
| mid | Декомпозиция на проверяемые единицы работы с явными критериями готовности и приёмки | User Stories + Gherkin AC • Impact Mapping • Story Mapping |
| enterprise | Формальная спецификация с трассируемостью, верификацией и управлением изменениями | IEEE 830 SRS • Use Case 2.0 (Jacobson) • Jobs-To-Be-Done framework |

## 3. Architecture

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Одностраничное описание структуры системы с одной диаграммой | ASCII box-and-arrow • Mermaid-диаграмма • draw.io sketch |
| mid | Фиксация значимых архитектурных решений и многоуровневое визуальное моделирование | ADR (Nygard) • C4 Level 1-2 • arc42 |
| enterprise | Формальная оценка качественных атрибутов и моделирование системной архитектуры | ATAM/QAW • ArchiMate/TOGAF • SEI Views-and-Beyond |

## 4. Development

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Линейная история изменений в одной основной ветке | Trunk-based на main • Conventional Commits • Semantic Versioning |
| mid | Короткоживущие ветки с обязательным независимым ревью и автоматическими проверками кода | GitHub Flow + PR review • Pre-commit hooks • Линтеры (ESLint/RuboCop) |
| enterprise | Формализованные ветки релизов с управлением правами, безопасностью и цепочкой поставки | GitFlow/Release-flow • CODEOWNERS + SAST • SBOM (SPDX/CycloneDX) |

### Форматеры и линтеры (принцип 6)

| Уровень | Метод | Примеры инструментов |
|---|---|---|
| pet | Встроенный форматер редактора, минимальный линт | gofmt • Prettier default • Black default |
| mid | Форматер + линтер с конфигом под проект | Prettier + ESLint • Black + Ruff • gofmt + golangci-lint |
| enterprise | Форматер + линтер + статический анализ + security scan | Prettier + ESLint + SonarQube • Black + Ruff + Semgrep • gofmt + golangci-lint + CodeQL |

## 5. Testing

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Ручная проверка основного сценария и редкие автотесты | Smoke test manually • 1-2 unit test • Assertion-based scripts |
| mid | Пирамида автоматизированных тестов с покрытием как пороговым критерием | Unit + Integration + E2E • Coverage gate • Consumer-Driven Contract Tests |
| enterprise | Исполняемые инварианты архитектуры и проверка устойчивости под нагрузкой | Fitness Functions as Code • Mutation Testing • Chaos Engineering |

## 6. Deployment

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Ручное развёртывание в одну среду одной командой | deploy.sh скрипт • rsync/scp • docker-compose на VPS |
| mid | Автоматизированный конвейер с несколькими средами и обратимой стратегией | GitHub Actions CI/CD • Staging + Prod • Blue-Green Deployment |
| enterprise | Декларативная доставка с прогрессивным выкатом, флагами и мультирегионом | GitOps (ArgoCD/Flux) • Canary + Feature Flags • Progressive Delivery |

## 7. Operations

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Пассивный сбор логов и внешняя проверка доступности | Stdout logs • Uptime-мониторинг • Health-check endpoint |
| mid | Метрики, журналирование, оповещения с задокументированной процедурой реагирования | Prometheus + Grafana • Alertmanager • Runbook + Postmortem template |
| enterprise | Полная наблюдаемость и управление инцидентами по SLO с бюджетом ошибок | SLO/SLI + Error Budget • On-call ротация (PagerDuty) • FinOps / Observability stack |

## State-артефакт (принцип 9)

| Уровень | Метод | Примеры реализации |
|---|---|---|
| pet | Плоский текстовый файл состояния | TODO.md в корне • NOTES.md • одиночный Markdown |
| mid | Трекер задач с историей и ссылками | GitHub Issues через MCP • BACKLOG.md с frontmatter-ссылками • Linear |
| enterprise | Полнофункциональный PM-инструмент с интеграциями | Jira • Azure DevOps Boards • ClickUp |

## Правила использования

Skill `sdlc-method-engineering` рендерит варианты из этого файла.
Без выбора пользователя ни один инструмент не попадает в целевой проект.
Имена инструментов встречаются ТОЛЬКО в этом файле (проверяется grep'ом).
