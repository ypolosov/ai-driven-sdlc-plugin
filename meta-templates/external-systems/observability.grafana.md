---
name: observability.grafana
type: external-system-reference
category: observability
tool: grafana
mcp_options:
  - name: mcp-grafana
    package: 'grafana/mcp-grafana'
    auth: api_key
    notes: Official Grafana Labs, supports Loki/Prometheus/Tempo/Alerting
env_vars: [GRAFANA_URL, GRAFANA_API_KEY]
capabilities: [metric.query, log.search, alert.list, trace.read, dashboard.read]
source: ADR-013, ADR-016, Wave 7 Gap-3
---

# Reference: Grafana как observability

Подключение Grafana как MCP-сервера для категории `observability`. Покрывает Prometheus (metrics), Loki (logs), Tempo (traces), Grafana Alerting.

## Установка

### mcp-grafana (official Grafana Labs)

```bash
git clone https://github.com/grafana/mcp-grafana
cd mcp-grafana
go build
```

Или через Docker:

```bash
docker pull grafana/mcp-grafana:latest
```

В `<target>/.mcp.json`:

```json
"grafana": {
  "type": "stdio",
  "command": "mcp-grafana",
  "args": []
}
```

## Env переменные

```bash
GRAFANA_URL=https://grafana.your-org.com
GRAFANA_API_KEY=<service-account-token>
```

API key создаётся в Grafana Admin → Service Accounts → Token.

## Capabilities mapping

| Capability | Grafana механизм |
|---|---|
| metric.query | PromQL via Prometheus datasource |
| log.search | LogQL via Loki datasource |
| alert.list | Grafana Alerting rules + active alerts |
| trace.read | TraceQL via Tempo datasource |
| dashboard.read | Grafana Dashboards API |

## Привязка в `tool-bindings.md`

```yaml
- category: observability
  mcp_server: grafana
  env_keys: [GRAFANA_URL, GRAFANA_API_KEY]
  capabilities: [metric.query, log.search, alert.list, dashboard.read]
```

## Use в плагине

- Фаза operations → инцидент-мониторинг через `sdlc-context-aggregator`.
- Фаза deployment → проверка здоровья после rollout.
- Альфа `Software System` → продвижение в `In Use` подтверждается через uptime metrics.

## Self-hosted vs Grafana Cloud

- Self-hosted: API key через ваш Grafana instance.
- Grafana Cloud: API key через cloud admin console.
- Stack Tokens (Cloud) поддерживают per-stack scoping.
