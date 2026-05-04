---
name: ADR-009
type: adr
title: Авторитативный backend альф через essence-alpha-mcp
status: Accepted
date: 2026-04-30
nfr: [reliability, maintainability]
principles: [6, 13]
---

# ADR-009: Авторитативный backend альф через essence-alpha-mcp

## Контекст

Принцип 13 формализован вокруг markdown-источника `alphas.md`.
Markdown не даёт детерминированной валидации переходов state machine.
OMG Essence — формальная state machine 7 альф SDLC.
Класс багов: «agent забыл состояние», «evidence_uri ссылается в никуда», «журнал рассинхронизирован».
Опубликован npm-пакет `@ypolosov/essence-alpha-mcp` v0.1.1 (минимальная поддерживаемая; v0.1.0 имел баг ранний-exit stdio).

## Решение

`@ypolosov/essence-alpha-mcp` становится авторитативным backend трекера альф.
MCP-сервер регистрируется в `.mcp.json` под именем `essence-alpha`.
Tools агенту: `essence_get_alpha_state`, `essence_advance_alpha`, `essence_regress_alpha`.
Также `essence_list_transitions`, `essence_validate_consistency`, `essence_describe_alpha`.
`alphas.md` сжимается до snapshot-таблицы текущих состояний альф.
Журнал переходов делегируется БД SQLite через `essence_list_transitions`.
Markdown остаётся в git как PR-видимый снимок после успешного MCP-вызова.

## Последствия

- Детерминизм state machine OMG Essence закрыл класс багов трекера.
- Переиспользуемость npm-пакета между проектами без копирования каталога.
- Устранено дублирование журнала переходов markdown vs БД.
- PR-видимость состояний сохранена через snapshot.
- Зависимость от npm registry при первом `npx`-запуске сервера.
- Дополнительный артефакт `.db` исключается через `.gitignore`.
- Bats-тесты мокают MCP-вызовы через `ESSENCE_ALPHA_VALIDATE_CMD`.
- Миграция исторических переходов в БД — out of scope MVP.

## Альтернативы

1. Inline state machine в bash-скрипте плагина — велосипед.
2. JSON-schema в `catalogs/alphas.md` — state machine тяжелее json-schema.
3. Удалить `alphas.md` полностью — теряется PR-видимость состояний.
4. Markdown-журнал как зеркало БД — избыточность и риск рассинхрона.
