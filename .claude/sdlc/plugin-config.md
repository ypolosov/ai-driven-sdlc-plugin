---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-04-19
---

# Технический конфиг hooks

Параметры для hooks и скриптов плагина. Не SME-решения.

## state_artifact

```yaml
state_artifact:
  kind: mcp
  ref: github://ypolosov/ai-driven-sdlc-plugin/issues
```

Состояние работ хранится в GitHub Issues репозитория.
Доступ обеспечивает MCP-сервер `github` из `.mcp.json`.

## tdd_scope

```yaml
tdd_scope:
  include: []
  exclude: []
```

Scope задаётся на фазе development через `/sdlc-phase development`.

## tdd_pairs

```yaml
tdd_pairs: []
```

Пары `source↔test` конфигурируются на фазе development.

## formatter

```yaml
formatter:
  command: ""
  exit_code_ok: 0
  scope_globs: []
```

Форматер не выбран; фиксация — на фазе development (принцип 6).

## linter

```yaml
linter:
  command: ""
  exit_code_ok: 0
  scope_globs: []
```

Линтер не выбран; фиксация — на фазе development.

## no_comments_whitelist

```yaml
no_comments_whitelist:
  - '^#!'
  - '^// SPDX-License-Identifier:'
  - '^/\*\* @'
  - '^# type: ignore'
  - '^//go:build'
  - '^# pylint: disable'
  - '^/// <reference'
```

Whitelist технических директив для `enforce-no-comments.sh` (принцип 4a).

## system_readme_ttl_days

```yaml
system_readme_ttl_days: 30
```

TTL описаний систем внимания (принцип 17).
