---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-04-19
---

# Технический конфиг фикстуры

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

## system_readme_ttl_days

```yaml
system_readme_ttl_days: 30
```
