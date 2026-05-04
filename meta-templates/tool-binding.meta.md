---
name: tool-binding.meta
type: meta-template
scope: схема tool-bindings.md — реестр привязок «категория → конкретный MCP-сервер» в целевом
location_in_target: .claude/sdlc/tool-bindings.md
source: ADR-013 (категории как агностический интерфейс); принципы 3, 18
---

# Мета-шаблон `tool-bindings.md`

Реестр привязок категорий инструментов к конкретным MCP-серверам в целевом проекте.
Категории определены в `catalogs/tool-categories.md` плагина (7 категорий).
В pet-целевом тот же реестр может быть встроен inline в `plugin-config.md`.

## Обязательный frontmatter

```yaml
---
name: tool-bindings
type: tool-binding-registry
project: <slug>
version: 1
updated: <YYYY-MM-DD>
---
```

## Обязательная схема записи привязки

```yaml
bindings:
  - category: <id из catalogs/tool-categories.md>
    mcp_server: <имя сервера в .mcp.json>
    base_url: <https://...>          # опционально, для документации
    env_keys: [<KEY>, ...]           # ключи окружения, без значений
    rate_limit_per_min: <число>      # опционально
    notes: <свободный текст>         # опционально
```

## Поля записи

- `category` — slug категории (issue-tracker, knowledge-base, vcs, chat, observability, cd-platform, test-management).
- `mcp_server` — имя MCP-сервера, как он зарегистрирован в `.mcp.json`.
- `base_url` — URL экземпляра инструмента (документация, не credentials).
- `env_keys` — список ключей окружения, которые читает сервер (значения только в `.env`).
- `rate_limit_per_min` — оценочный лимит запросов в минуту.
- `notes` — свободный комментарий о настройке.

## Правила

- Одна категория может иметь до одной привязки в пределах целевого.
- `env_keys` обязателен, если сервер требует токен; значения — только в `.env`.
- Запрет на добавление свободных категорий: используются только id из плагина.
- Изменение `tool-bindings.md` требует записи в `decisions.md` с альтернативами.
- При отсутствии файла `sdlc-tool-router` отказывается выполнять запросы.

## Пример (mid-целевой)

```yaml
---
name: tool-bindings
type: tool-binding-registry
project: my-target
version: 1
updated: 2026-05-05
---

bindings:
  - category: issue-tracker
    mcp_server: github
    base_url: https://github.com/org/repo
    env_keys: [GITHUB_TOKEN]
    rate_limit_per_min: 30
  - category: vcs
    mcp_server: github
    env_keys: [GITHUB_TOKEN]
  - category: chat
    mcp_server: slack
    env_keys: [SLACK_BOT_TOKEN]
    rate_limit_per_min: 60
```

## Связь с другими артефактами

- `tool-categories.md` плагина — допустимые id категорий.
- `target-roles.meta.md` целевого — поле `tool_categories` ролей.
- `plugin-config.meta.md` целевого — секция `tool_bindings` (inline для pet).
- `.env` целевого — значения ключей `env_keys`.
- `.mcp.json` целевого — регистрация серверов под именами `mcp_server`.

## Валидация

`scripts/check-tool-binding.sh <target-dir>` проверяет:
- Наличие файла `tool-bindings.md`.
- Каждая категория — из `catalogs/tool-categories.md`.
- Каждая запись содержит и `category`, и `mcp_server`.

`scripts/detect-credentials.sh <target-dir>` проверяет:
- `.env` существует и в `.gitignore`.
- Все `env_keys` из `tool-bindings.md` присутствуют в `.env`.
