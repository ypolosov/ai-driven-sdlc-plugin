---
name: webhooks.meta
type: meta-template
scope: схема webhooks.md — конфигурация webhook-эндпоинтов целевого (enterprise)
location_in_target: .claude/sdlc/webhooks.md
source: ADR-014 (enterprise dogfooding); принцип 20 (worker по SME)
---

# Мета-шаблон `webhooks.md`

Конфигурация webhook-эндпоинтов для real-time синхронизации в enterprise-целевом.
Применимо только при `worker.kind: cron+webhooks` в `rag-config.md`.
Каждый webhook привязан к одной категории из `tool-categories.md`.

## Обязательный frontmatter

```yaml
---
name: webhooks
type: webhooks-config
project: <slug>
version: 1
updated: <YYYY-MM-DD>
---
```

## Обязательная схема записи endpoint'а

```yaml
endpoints:
  - id: <slug>
    category: <id из catalogs/tool-categories.md>
    event_types: [<event-id>...]
    url: <https://...>
    auth:
      kind: hmac | bearer | mtls
      secret_env_key: <KEY>
    handler: <команда обработчик>
    notes: <свободный текст>
```

## Поля

- `id` — уникальный slug endpoint'а в проекте.
- `category` — slug из `tool-categories.md` (issue-tracker / vcs / chat / observability / cd-platform / knowledge-base / test-management).
- `event_types` — список ID событий, которые принимает endpoint.
- `url` — публичный URL endpoint'а (для регистрации в источнике).
- `auth.kind` — метод аутентификации (`hmac`, `bearer`, `mtls`).
- `auth.secret_env_key` — имя ключа в `.env` (значение хранится только там).
- `handler` — команда обработчик; обычно `sdlc-state-rag webhook handle <id>`.

## Правила

- При наличии `webhooks.md` в `rag-config.md` обязателен `worker.kind: cron+webhooks`.
- Каждый endpoint работает с одной категорией.
- HMAC — обязателен для public endpoints без VPN.
- При получении события handler вызывает `mcp__sdlc_state_rag__sync_emit`.
- Запись `sync_emit` триггерит downstream RAG-обновление через worker'а.

## Пример (enterprise issue-tracker webhook)

```yaml
---
name: webhooks
type: webhooks-config
project: my-target
version: 1
updated: 2026-05-05
---

endpoints:
  - id: tracker-issue-events
    category: issue-tracker
    event_types: [issue.created, issue.updated, issue.closed]
    url: https://my-target.example.com/webhooks/tracker
    auth:
      kind: hmac
      secret_env_key: TRACKER_WEBHOOK_SECRET
    handler: 'sdlc-state-rag webhook handle tracker-issue-events'

  - id: vcs-pr-events
    category: vcs
    event_types: [pull_request.opened, pull_request.merged]
    url: https://my-target.example.com/webhooks/vcs
    auth:
      kind: hmac
      secret_env_key: VCS_WEBHOOK_SECRET
    handler: 'sdlc-state-rag webhook handle vcs-pr-events'
```

## Связь с другими артефактами

- `rag-config.md` целевого — поле `worker.kind: cron+webhooks`.
- `tool-bindings.md` целевого — категории должны совпадать с `endpoints[].category`.
- `.env` целевого — секреты по `auth.secret_env_key`.
- `sdlc-state-rag-contract.meta.md` — tools `sync_emit`, `sync_query`.
