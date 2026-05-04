---
name: sdlc-tools
description: Управление привязками категорий инструментов SDLC к конкретным MCP-серверам в целевом проекте. Подкоманды list, bind, test, unbind. Все mutating действия через AskUserQuestion (принцип 1). Делегирует skill sdlc-integrations.
---

# `/sdlc-tools <subcommand>`

Управление реестром `tool-bindings.md` целевого проекта.

## Подкоманды

### `/sdlc-tools list`

Показать текущие привязки категорий.

- Прочитать `<target>/.claude/sdlc/tool-bindings.md`.
- Если файл отсутствует — сообщить и предложить `bind`.
- Вывести таблицу: `category` → `mcp_server` → `env_keys` → `rate_limit`.

### `/sdlc-tools bind <category>`

Добавить или обновить привязку для категории.

1. Проверить, что `<category>` есть в `catalogs/tool-categories.md`.
2. Через `AskUserQuestion` спросить у пользователя:
   - Имя MCP-сервера (из `.mcp.json` целевого).
   - `env_keys` (без значений, только имена).
   - Опциональный `rate_limit_per_min`.
3. Показать 2–3 альтернативы (или подтвердить выбор пользователя).
4. После подтверждения — записать запись в `tool-bindings.md`.
5. Запустить `scripts/check-tool-binding.sh <target>`; при ошибке откатить.
6. Записать альтернативы в `decisions.md` (принцип 1).

### `/sdlc-tools test [<category>]`

Верифицировать, что привязки рабочие.

1. Прочитать `tool-bindings.md`.
2. Запустить `detect-credentials.sh <target>`; вернуть отчёт.
3. Для каждой `<category>` (или указанной) выполнить read-only ping через `sdlc-tool-router`.
4. Вывести отчёт `category` → `status` → `latency_ms` → `provenance`.

### `/sdlc-tools unbind <category>`

Удалить привязку.

1. Через `AskUserQuestion` подтвердить намерение.
2. Удалить запись из `tool-bindings.md`.
3. Записать решение в `decisions.md`.

## Поведение в HOOTL

В HOOTL `AskUserQuestion` пропускается; альтернативы логируются в `decisions.md`.
Деструктивные действия (`unbind`) требуют явного флага `--force` в HOOTL.

## Связи

- Делегирует основной поток skill `sdlc-integrations`.
- Использует агент `sdlc-tool-router` для `test`.
- Вызывает скрипты `check-tool-binding.sh` и `detect-credentials.sh`.
- Закрывает epic #3 (dev-time vs runtime MCP), epic #13 (верификация стека).

## Ограничения

- Команда не редактирует `.mcp.json` напрямую; пользователь вносит изменения сам.
- Команда не сохраняет значения секретов; только имена ключей.
- Не упоминает имена конкретных продуктов в коде; только slugs категорий.
