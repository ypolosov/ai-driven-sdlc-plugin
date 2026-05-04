---
name: plugin-config.meta
type: meta-template
scope: технический конфиг hooks в целевом проекте
location_in_target: .claude/sdlc/plugin-config.md
audience: hooks и скрипты плагина (не пользователь)
---

# Мета-шаблон `plugin-config.md`

Технический конфиг hooks.
Механический слой; не SME-решения (это `profile.md`).
Читается скриптами; пользователем правится через `/sdlc-phase development` и подобные.

## Обязательный frontmatter

```yaml
---
name: plugin-config
type: hooks-config
version: 1
updated: <YYYY-MM-DD>
---
```

## Обязательные поля

### state_artifact
Тип и путь state-артефакта проекта (принцип 9).

```yaml
state_artifact:
  kind: file | dir | mcp
  ref: <путь или endpoint>
```

### tdd_scope
Пути, на которые распространяется TDD hook (принцип 5).

```yaml
tdd_scope:
  include: [src/**, lib/**]
  exclude: [src/**/*.d.ts, lib/**/fixtures/**]
```

### tdd_pairs
Регулярные выражения пар source↔test.
Backreference — `\1` (Python/sed-стиль); `$1` также поддерживается.
Поддерживаются block-style и flow-style YAML.

```yaml
tdd_pairs:
  - source: 'src/(.+)\.ts$'
    test:   'tests/\1.test.ts'
  - source: 'src/(.+)\.py$'
    test:   'tests/test_\1.py'
  - { source: 'lib/(.+)\.go$', test: 'lib/\1_test.go' }
```

### formatter
Команда форматера и сигнал неудачи.

```yaml
formatter:
  command: <shell command>
  exit_code_ok: 0
  scope_globs: [src/**, lib/**]
```

### linter
Команда линтера.

```yaml
linter:
  command: <shell command>
  exit_code_ok: 0
  scope_globs: [src/**, lib/**]
```

### no_comments_whitelist
Whitelist технических директив для `enforce-no-comments.sh` (принцип 4a).

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

### system_readme_ttl_days
TTL для описаний систем внимания (принцип 17, Волна 2).

```yaml
system_readme_ttl_days: 30
```

Если `last_focused_at` старше N дней, `sdlc-consistency-auditor` понижает приоритет расхождений по системе.
Значение по умолчанию — 30 дней.

### tool_bindings (Волна 4, опционально)

Реестр привязок «категория → MCP-сервер».
В pet — inline; в mid+ — ссылка на отдельный `tool-bindings.md`.

```yaml
tool_bindings:
  inline:
    - category: vcs
      mcp_server: github
      env_keys: [GITHUB_TOKEN]
  ref: .claude/sdlc/tool-bindings.md
```

Поля `inline` и `ref` взаимоисключающие.
В pet `inline` несёт 1–2 категории; в mid+ `ref` указывает на файл по `tool-binding.meta.md`.

### rag_ref (Волна 4 каркас, активно в Волне 5)

Ссылка на конфиг RAG-системы целевого.

```yaml
rag_ref:
  enabled: true | false
  config_path: .claude/sdlc/rag-config.md
```

При `enabled: false` агент `sdlc-context-aggregator` обязан опросить MCP-серверы по `tool-bindings` (принцип 19a).
При `enabled: true` aggregator делает RAG-запросы перед опросом MCP.
Дефолт — `enabled: false` (применимо к большинству mid и всем pet).

### workers (Волна 5, опционально)

Конфигурация worker'ов синхронизации.

```yaml
workers:
  cron:
    enabled: false
    schedule: '0 * * * *'
  webhooks:
    enabled: false
    endpoints: []
```

Подробности — в `meta-templates/rag-config.meta.md` (Волна 5).

## Правила

- Без `state_artifact` агент `sdlc-state-reader` падает с понятным сообщением.
- Без `formatter`/`linter` после прохождения фазы development — запись кода блокируется.
- Без `tdd_pairs` — TDD hook пропускает правки (с предупреждением).
- Путь state-артефакта может быть вне `.claude/` (например, корневой `TODO.md`).

## Валидация

`validate-artifact.sh` проверяет наличие обязательных полей и корректность YAML.
