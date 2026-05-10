---
name: knowledge-base.confluence
type: external-system-reference
category: knowledge-base
tool: confluence
mcp_options:
  - name: atlassian-rovo
    package: '@atlassian/mcp-rovo'
    auth: oauth2
    notes: Official, bundled с Cloud Premium
  - name: sooperset-mcp-atlassian
    package: 'sooperset/mcp-atlassian'
    auth: api_token
    notes: Community, единый сервер для Jira+Confluence
env_vars: [CONFLUENCE_URL, CONFLUENCE_EMAIL, CONFLUENCE_API_TOKEN]
capabilities: [page.create, page.update, page.search, page.read, attachment.upload]
source: ADR-013, ADR-016, Wave 7 Gap-3
---

# Reference: Confluence как knowledge-base

Подключение Confluence как MCP-сервера для категории `knowledge-base`.

## Установка

### Atlassian Rovo (recommended если Atlassian Cloud Premium)

См. `issue-tracker.jira.md` — единый Rovo-сервер покрывает Jira + Confluence + Bitbucket.

### sooperset/mcp-atlassian

Тот же сервер, что и для Jira:

```bash
pip install mcp-atlassian
```

В `<target>/.mcp.json`:

```json
"atlassian": {
  "type": "stdio",
  "command": "uvx",
  "args": ["mcp-atlassian"]
}
```

## Env переменные

Если используется один Atlassian Cloud аккаунт, переменные те же что для Jira (см. `issue-tracker.jira.md`). Иначе:

```bash
CONFLUENCE_URL=https://your-org.atlassian.net/wiki
CONFLUENCE_EMAIL=your-email@example.com
CONFLUENCE_API_TOKEN=<atlassian-api-token>
```

## Привязка в `tool-bindings.md`

```yaml
- category: knowledge-base
  mcp_server: atlassian
  env_keys: [CONFLUENCE_URL, CONFLUENCE_EMAIL, CONFLUENCE_API_TOKEN]
  capabilities: [page.create, page.update, page.search, page.read]
```

## Use в плагине

`sdlc-context-aggregator` (категория knowledge-base) опрашивает Confluence для:
- Architecture-документов на фазе architecture.
- Runbooks на фазе operations.
- Спецификаций требований на фазе requirements.

## Связь с альфами

`Requirements`, `Way of Working`.
