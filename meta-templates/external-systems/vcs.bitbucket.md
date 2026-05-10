---
name: vcs.bitbucket
type: external-system-reference
category: vcs
tool: bitbucket
mcp_options:
  - name: atlassian-rovo
    package: '@atlassian/mcp-rovo'
    auth: oauth2
    notes: Official, единый сервер с Jira+Confluence+Bitbucket
  - name: bitbucket-mcp-community
    package: 'bitbucket-mcp-server'
    auth: app_password
    notes: Community standalone Bitbucket MCP
env_vars: [BITBUCKET_WORKSPACE, BITBUCKET_USERNAME, BITBUCKET_APP_PASSWORD]
capabilities: [pr.create, pr.review, pr.merge, branch.create, commit.read, tag.create, file.read]
source: ADR-013, ADR-016, Wave 7 Gap-3
---

# Reference: Bitbucket как vcs

Подключение Bitbucket Cloud как MCP-сервера для категории `vcs`.

## Установка

### Atlassian Rovo

См. `issue-tracker.jira.md` — единый Rovo-сервер.

### Community Bitbucket MCP

```bash
npm install -g bitbucket-mcp-server
```

В `<target>/.mcp.json`:

```json
"bitbucket": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "bitbucket-mcp-server"]
}
```

## Env переменные

Bitbucket app passwords создаются в Personal Settings → App passwords:

```bash
BITBUCKET_WORKSPACE=your-org
BITBUCKET_USERNAME=your-username
BITBUCKET_APP_PASSWORD=<app-password>
```

App password требует scopes: `repository:write`, `pullrequest:write`.

## Установка для team (Bitbucket Cloud)

1. Admin создаёт API token / app passwords.
2. Каждый разработчик ставит свои credentials в локальный `.env`.
3. CI/CD pipelines используют bot account credentials.

## Привязка в `tool-bindings.md`

```yaml
- category: vcs
  mcp_server: bitbucket
  env_keys: [BITBUCKET_WORKSPACE, BITBUCKET_USERNAME, BITBUCKET_APP_PASSWORD]
  capabilities: [pr.create, pr.review, pr.merge, branch.create, commit.read]
```

## Use в плагине

- Фаза development → создание feature branches, PR review.
- Фаза deployment → release tags.
- `sdlc-context-aggregator` опрашивает для diff'ов и commit history.

## Связь с альфой

`Software System` — отслеживается через теги релизов.
