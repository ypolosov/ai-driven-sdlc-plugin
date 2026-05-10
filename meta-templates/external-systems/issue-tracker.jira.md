---
name: issue-tracker.jira
type: external-system-reference
category: issue-tracker
tool: jira
mcp_options:
  - name: atlassian-rovo
    package: '@atlassian/mcp-rovo'
    auth: oauth2
    notes: Official Atlassian (GA Feb 2026), bundled with Cloud Premium
  - name: sooperset-mcp-atlassian
    package: 'sooperset/mcp-atlassian'
    auth: api_token
    notes: Community, 72+ tools, supports both Jira+Confluence
env_vars: [JIRA_URL, JIRA_EMAIL, JIRA_API_TOKEN]
capabilities: [issue.create, issue.update, issue.search, comment.add, label.set, status.set]
source: ADR-013, ADR-016, Wave 7 Gap-3
---

# Reference: Jira как issue-tracker

Подключение Jira как MCP-сервера для категории `issue-tracker`.

## Альтернативы (выбирается пользователем)

### Atlassian Rovo MCP (official)

- Package: `@atlassian/mcp-rovo` (или через Atlassian Cloud admin).
- Auth: OAuth2 через Atlassian admin console.
- Bundled с Atlassian Cloud Premium ($10.50+/user/mo).
- Pros: official, deep integration с Jira+Confluence+Bitbucket.
- Cons: requires Atlassian Cloud Premium subscription.

### sooperset/mcp-atlassian (community)

- Package: `sooperset/mcp-atlassian` (Python).
- Auth: API token (Atlassian → My Account → API tokens).
- 72+ tools для Jira+Confluence (combined).
- Pros: free, self-hosted, broad coverage.
- Cons: community-maintained, varies by version.

## Установка

### Atlassian Rovo

1. Включить Rovo в Atlassian admin console.
2. Получить OAuth credentials.
3. В `<target>/.mcp.json` добавить:
   ```json
   "jira-rovo": {
     "type": "stdio",
     "command": "npx",
     "args": ["-y", "@atlassian/mcp-rovo"]
   }
   ```

### sooperset/mcp-atlassian

1. Установить Python 3.10+.
2. `pip install mcp-atlassian` или Docker pull.
3. В `<target>/.mcp.json`:
   ```json
   "atlassian": {
     "type": "stdio",
     "command": "uvx",
     "args": ["mcp-atlassian"]
   }
   ```

## Env переменные (в `<target>/.env`)

```bash
JIRA_URL=https://your-org.atlassian.net
JIRA_EMAIL=your-email@example.com
JIRA_API_TOKEN=<token-from-atlassian-id>
```

`<target>/.gitignore` обязательно содержит `.env` (принцип 10).

## Проверка подключения

```bash
claude mcp list | grep -E 'jira|atlassian'
```

Ожидается `✓ Connected`.

## Привязка в `tool-bindings.md` целевого

```yaml
- category: issue-tracker
  mcp_server: atlassian
  env_keys: [JIRA_URL, JIRA_EMAIL, JIRA_API_TOKEN]
  capabilities: [issue.create, issue.update, issue.search]
```

## Связь с work-unit template

Для Jira-managed targets — `work_unit_template: jira` в `plugin-config.md`.
Использует `meta-templates/work-unit.jira.meta.md` (Wave 7, v0.9.0).
