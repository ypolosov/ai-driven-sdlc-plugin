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

Пустой include означает «применимо ко всем файлам»; фильтрация идёт через `tdd_pairs`.
Расширение scope — по мере покрытия скриптов bats-тестами.

## tdd_pairs

```yaml
tdd_pairs:
  - source: '^scripts/validate-artifact\.sh$'
    test: 'tests/unit/validate-artifact.bats'
  - source: '^scripts/check-cross-refs\.sh$'
    test: 'tests/unit/check-cross-refs.bats'
  - source: '^scripts/enforce-no-comments\.sh$'
    test: 'tests/unit/enforce-no-comments.bats'
  - source: '^scripts/bootstrap-dev-env\.sh$'
    test: 'tests/unit/bootstrap-dev-env.bats'
```

Активные пары — 4 скрипта: validate-artifact, check-cross-refs, enforce-no-comments, bootstrap-dev-env.
Остальные 7 скриптов — out of scope до написания их тестов.

### Планируемые пары (не активны, документация)

Следующая конфигурация будет активирована после реализации bats-тестов:

```yaml
tdd_pairs_planned:
  - source: '^scripts/([a-z0-9-]+)\.sh$'
    test: 'tests/unit/$1.bats'
  - source: '^hooks/([a-z0-9-]+)\.json$'
    test: 'tests/integration/hooks-$1.bats'
```

Формула: файл `scripts/check-foo.sh` требует `tests/unit/check-foo.bats`.
Шаблон совпадает со структурой `testing.md` §3.1.

## formatter

```yaml
formatter:
  command: 'shfmt -d -i 2 -ci'
  exit_code_ok: 0
  scope_globs: ['scripts/validate-artifact.sh']
```

Выбран shfmt; scope сужен до покрытых bats-тестами скриптов.
Установка shfmt — задача bootstrap-dev-env скрипта целевого проекта.
Расширение scope — по мере добавления bats-тестов.

## linter

```yaml
linter:
  command: 'shellcheck'
  exit_code_ok: 0
  scope_globs: ['scripts/validate-artifact.sh']
```

Выбран shellcheck; scope совпадает с формateром.
Установка shellcheck — задача bootstrap-dev-env скрипта целевого проекта.

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
