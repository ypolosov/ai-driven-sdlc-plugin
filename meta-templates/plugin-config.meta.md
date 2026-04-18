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

```yaml
tdd_pairs:
  - source: 'src/(.+)\.ts$'
    test:   'tests/$1.test.ts'
  - source: 'src/(.+)\.py$'
    test:   'tests/test_$1.py'
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

## Правила

- Без `state_artifact` агент `sdlc-state-reader` падает с понятным сообщением.
- Без `formatter`/`linter` после прохождения фазы development — запись кода блокируется.
- Без `tdd_pairs` — TDD hook пропускает правки (с предупреждением).
- Путь state-артефакта может быть вне `.claude/` (например, корневой `TODO.md`).

## Валидация

`validate-artifact.sh` проверяет наличие обязательных полей и корректность YAML.
