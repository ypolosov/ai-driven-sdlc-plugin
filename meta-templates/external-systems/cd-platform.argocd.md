---
name: cd-platform.argocd
type: external-system-reference
category: cd-platform
tool: argocd
mcp_options:
  - name: argocd-mcp
    package: 'argoproj-labs/argocd-mcp'
    auth: api_token
    notes: Community ArgoCD MCP, GitOps-native
env_vars: [ARGOCD_SERVER, ARGOCD_AUTH_TOKEN]
capabilities: [app.list, app.sync, app.rollback, env.list, deploy.history]
source: ADR-013, ADR-016, Wave 7 Gap-3
---

# Reference: ArgoCD как cd-platform

Подключение ArgoCD как MCP-сервера для категории `cd-platform`. GitOps-native CD для Kubernetes.

## Установка

### argocd-mcp (community)

```bash
npm install -g argocd-mcp-server
```

Или сборка из исходников:

```bash
git clone https://github.com/argoproj-labs/argocd-mcp
cd argocd-mcp && go build
```

В `<target>/.mcp.json`:

```json
"argocd": {
  "type": "stdio",
  "command": "argocd-mcp",
  "args": []
}
```

## Env переменные

```bash
ARGOCD_SERVER=argocd.your-org.com:443
ARGOCD_AUTH_TOKEN=<account-jwt-token>
```

JWT token получается через ArgoCD CLI:

```bash
argocd account generate-token --account <bot-account>
```

## Capabilities mapping

| Capability | ArgoCD действие |
|---|---|
| app.list | List Applications в proj/ns |
| app.sync | Trigger sync (manual или auto) |
| app.rollback | Rollback to previous Git revision |
| env.list | Cluster + namespace mappings |
| deploy.history | Sync history per app |

## Привязка в `tool-bindings.md`

```yaml
- category: cd-platform
  mcp_server: argocd
  env_keys: [ARGOCD_SERVER, ARGOCD_AUTH_TOKEN]
  capabilities: [app.list, app.sync, deploy.history]
```

## Use в плагине

- Фаза deployment → trigger sync через `sdlc-tool-router` (write требует `AskUserQuestion` per принцип 1).
- Фаза operations → проверка состояния deployments.
- Альфа `Software System` продвигается в `Operational` после успешного sync.

## Безопасность

- Bot account с минимальным RBAC (read + sync, без admin).
- Token rotation через ArgoCD CLI.
- `.env` обязательно gitignored (принцип 10).

## Связь с другими категориями

- `vcs` (Bitbucket/GitHub) — source-of-truth для манифестов.
- `observability` (Grafana) — health-check после sync.
