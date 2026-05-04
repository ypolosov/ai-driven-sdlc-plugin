---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-05-05
---

# Технический конфиг фикстуры mid-target

## state_artifact

```yaml
state_artifact:
  kind: file
  ref: .claude/sdlc/decisions.md
```

## tdd_scope

```yaml
tdd_scope:
  include: []
  exclude: []
```

## tdd_pairs

```yaml
tdd_pairs: []
```

## formatter

```yaml
formatter:
  command:
  exit_code_ok: 0
  scope_globs: []
```

## linter

```yaml
linter:
  command:
  exit_code_ok: 0
  scope_globs: []
```

## no_comments_whitelist

```yaml
no_comments_whitelist: []
```

## system_readme_ttl_days

```yaml
system_readme_ttl_days: 30
```

## tool_bindings

```yaml
tool_bindings:
  ref: .claude/sdlc/tool-bindings.md
```

## rag_ref

```yaml
rag_ref:
  enabled: false
  config_path: .claude/sdlc/rag-config.md
```

## workers

```yaml
workers:
  cron:
    enabled: false
    schedule: '0 * * * *'
  webhooks:
    enabled: false
    endpoints: []
```
