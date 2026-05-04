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

## 8. Knowledge-base (категория)

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | README и плоские markdown файлы в репозитории | README.md • docs/ • GitHub Wiki |
| mid | Структурированная база с разделами и ссылками между страницами | Confluence • Notion • Outline |
| enterprise | Корпоративная база с контролем доступа и версионированием контента | Confluence Cloud Premium • Bloomfire • Document360 |

## 9. Chat (категория)

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Один канал переписки без формальной структуры | Telegram • Direct messages • Email-thread |
| mid | Каналы и треды с интеграциями уведомлений от инструментов | Slack • Discord • Microsoft Teams |
| enterprise | Корпоративные коммуникации с DLP, аудитом и compliance | Slack Enterprise Grid • Microsoft Teams + Purview • Mattermost |

## 10. Observability (категория)

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Логи в stdout и внешний uptime-монитор | Stdout logs • UptimeRobot • Health-check endpoint |
| mid | Метрики, логи и алерты с задокументированной процедурой реагирования | Prometheus + Grafana + Loki • Alertmanager + runbook • Better Stack |
| enterprise | Полная наблюдаемость SLO/SLI с распределёнными трейсами и FinOps | Datadog • New Relic • Honeycomb + Tempo |

## 11. CD-platform (категория)

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Ручное развёртывание одной командой в одну среду | deploy.sh • docker-compose up • rsync |
| mid | Автоматизированный конвейер с несколькими средами и blue-green | GitHub Actions deploy job • Octopus Deploy • Spinnaker |
| enterprise | Декларативная доставка с прогрессивным выкатом и feature-флагами | ArgoCD • Flux • Harness Progressive Delivery |

## 12. Embedders для RAG (Wave 5)

| Уровень | Метод (абстрактно) | Примеры инструментов |
|---|---|---|
| pet | Локальный embedder без сетевого вызова | sentence-transformers all-MiniLM-L6-v2 • bge-small-en • nomic-embed-text |
| mid | Облачный embedder с приемлемой ценой и стабильным качеством | OpenAI text-embedding-3-small • Voyage voyage-3-lite • Cohere embed-english-light-v3 |
| enterprise | Высокоточный или мультимодальный embedder для compliance-данных | OpenAI text-embedding-3-large • Voyage voyage-3-large • Cohere embed-multilingual-v3 |

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
