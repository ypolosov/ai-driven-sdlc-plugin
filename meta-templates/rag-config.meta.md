---
name: rag-config.meta
type: meta-template
scope: схема rag-config.md — конфигурация RAG-домена и worker'ов целевого
location_in_target: .claude/sdlc/rag-config.md
source: ADR-011 (sdlc-state-rag); ADR-012 (worker pattern); принципы 19, 19a, 20
---

# Мета-шаблон `rag-config.md`

Конфигурация RAG-индексации и worker'ов синхронизации в целевом проекте.
RAG-домен реализуется через MCP-сервер `sdlc-state-rag` (ADR-011).
Worker-паттерн выбирается по уровню SME проекта (ADR-012).

## Обязательный frontmatter

```yaml
---
name: rag-config
type: rag-configuration
project: <slug>
version: 1
updated: <YYYY-MM-DD>
---
```

## Обязательные поля

### enabled

```yaml
enabled: true | false
```

При `enabled: false` `sdlc-context-aggregator` опрашивает MCP-серверы (принцип 19a).
При `enabled: true` aggregator делает RAG-запросы перед опросом MCP.

### data_classification

```yaml
data_classification: public | internal | regulated | unknown
```

Классификация индексируемых данных. Для `regulated` (PII, KYC/AML, платёжные,
медицинские, gambling-license данные) RAG-индексация в неконтролируемый
backend — регуляторный/GDPR риск.

### compliance_signoff

```yaml
compliance_signoff: <DPA/ticket reference>
```

Обязателен при `data_classification: regulated` И `enabled: true`.
Без него `check-rag-config.sh` блокирует конфигурацию (compliance-gate).

### sources

Источники для индексации; категории берутся из `tool-categories.md`.

```yaml
sources:
  - kind: filesystem
    paths: [.claude/sdlc/, README.md]
    glob: '**/*.md'
  - kind: mcp
    category: knowledge-base
    capability: page.search
  - kind: mcp
    category: vcs
    capability: file.read
```

### embedder

Имя embedder'а из `catalogs/method-tool-matrix.md` раздел 12.

```yaml
embedder:
  level: pet | mid | enterprise
  name: <slug из матрицы>
  dimensions: <int>
```

### ttl_days

TTL индексации (RAG-чанков), после которого `rag_purge_by_ttl` удаляет.

```yaml
ttl_days: 30
```

### worker (опционально)

Конфигурация worker'а синхронизации. Уровень SME определяет тип:
- pet → `null` (нет worker'а; on-demand запросы).
- mid → `cron` (детерминированный workflow).
- enterprise → `cron + webhooks` (cron как baseline + webhooks для ивентов).

```yaml
worker:
  kind: null | cron | cron+webhooks
  cron:
    enabled: false
    schedule: '0 * * * *'
    runner: <команда>
  webhooks:
    enabled: false
    endpoints: []
```

## Правила

- При `enabled: true` обязательны `sources` и `embedder`.
- При `data_classification: regulated` и `enabled: true` обязателен `compliance_signoff`.
- Для regulated-целевых рекомендуется `enabled: false` по умолчанию до compliance-review.
- При `enabled: false` остальные поля опциональны.
- `worker.kind` должно соответствовать SME-уровню `profile.md` (валидируется).
- DSN на `sdlc-state-rag` живёт в `<target>/.env` (`SDLC_STATE_RAG_DSN`).

## Пример (mid-целевой с RAG)

```yaml
---
name: rag-config
type: rag-configuration
project: my-target
version: 1
updated: 2026-05-05
---

enabled: true

sources:
  - kind: filesystem
    paths: [.claude/sdlc/, docs/]
    glob: '**/*.md'
  - kind: mcp
    category: knowledge-base
    capability: page.search

embedder:
  level: mid
  name: openai-text-embedding-3-small
  dimensions: 1536

ttl_days: 30

worker:
  kind: cron
  cron:
    enabled: true
    schedule: '0 */4 * * *'
    runner: 'sdlc-state-rag sync'
  webhooks:
    enabled: false
    endpoints: []
```

## Связь с другими артефактами

- `plugin-config.md` целевого — секция `rag_ref` указывает путь сюда.
- `tool-bindings.md` целевого — `sources.kind: mcp` ссылается на `category`.
- `.env` целевого — `SDLC_STATE_RAG_DSN`.
- `sdlc-state-rag-contract.meta.md` — описание MCP-сервера.

## Валидация

`scripts/check-rag-config.sh <target-dir>` проверяет:
- Наличие frontmatter с обязательными полями.
- При `enabled: true` — `sources` и `embedder` присутствуют.
- `worker.kind` соответствует уровню SME из `profile.md`.
- `embedder.name` присутствует в `catalogs/method-tool-matrix.md` раздел 12.
