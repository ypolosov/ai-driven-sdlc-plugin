---
name: deployment
type: deployment
phase: deployment
sme_level: mid
method: Стратегия релизов с semver и CHANGELOG
tool: semver + CHANGELOG + GitHub Releases + Claude Code marketplace
alphas: [Software System]
disciplines: [release-engineering]
role: method-engineer
traces_from:
  - ../development/development.md
  - ../testing/testing.md
traces_to:
  - ../operations/operations.md
system_of_attention: ai-driven-sdlc-plugin
created: 2026-04-19
updated: 2026-04-19
---

# Стратегия фазы deployment плагина ai-driven-sdlc

## 1. Назначение

Продвинуть альфу Software System от Demonstrable к Usable.
Метод — semver + CHANGELOG + GitHub Releases + Claude Code marketplace.
Канал распространения — marketplace Claude Code.

## 2. Привязка к фазе и методу

- Фаза: deployment.
- Уровень SME: mid.
- Дисциплина: release-engineering.
- Инструменты: semver (версионирование), CHANGELOG.md (журнал), GitHub Releases (артефакты), marketplace.json.

## 3. Содержание

### 3.1. Семантика версий (semver)

- MAJOR — несовместимые изменения публичной поверхности.
- MINOR — обратно-совместимые фичи (новые skills, commands, принципы).
- PATCH — фиксы без изменения поверхности.
- Источник версии — `.claude-plugin/plugin.json` поле `version`.

### 3.2. Процесс релиза

1. Обновить CHANGELOG.md с секцией новой версии.
2. Обновить `.claude-plugin/plugin.json` поле `version`.
3. Коммит `chore(release): bump to vX.Y.Z`.
4. Создать git tag `vX.Y.Z`.
5. Push коммита и тега на main.
6. GitHub Release через `gh release create` с CHANGELOG-фрагментом.
7. Проверить видимость в marketplace.

### 3.3. Распространение через marketplace

- Файл `.claude-plugin/marketplace.json` — метаданные для marketplace.
- Пользователи устанавливают через `/plugin marketplace add ypolosov/ai-driven-sdlc-plugin`.
- После `/plugin install` плагин активируется на уровне пользователя.
- Обновления — через `/plugin update` (pull последнего релиза).

### 3.4. CHANGELOG.md

- Формат — Keep a Changelog с секциями Added / Changed / Fixed / Removed.
- Язык — русский для описаний; английский для commit-ссылок.
- Каждая версия имеет дату и ссылку на diff на GitHub.
- Исторические версии 0.1.0 → 0.1.1 → 0.1.2 восстанавливаются из git log.

### 3.5. Предрелизная проверка (release gate)

Перед каждым релизом:

1. CI зелёный (bats + shellcheck + shfmt + check-readme-inventory).
2. `/sdlc-audit` статус pass.
3. CHANGELOG обновлён на новую версию.
4. Принципы 15 и 16 соблюдены (memom, README-синхронизация).

### 3.6. Откат (rollback)

- Marketplace не поддерживает auto-rollback; ответственность пользователя.
- Плагин остаётся обратно-совместимым внутри MAJOR.
- При критическом баге — hotfix PATCH с описанием в CHANGELOG §Fixed.

## 4. Трассируемость

- `traces_from`:
  - [`development.md`](../development/development.md) — backlog и покрытие тестами.
  - [`testing.md`](../testing/testing.md) — green-build как release gate.
- `traces_to`: [`operations.md`](../operations/operations.md) — канал feedback после релиза.

## 5. Критерии готовности фазы

- Артефакт `deployment.md` валиден.
- CHANGELOG.md создан и восстанавливает 0.1.0 → 0.1.1 → 0.1.2.
- Release gate зафиксирован (§3.5).
- Готов к первому релизу через процесс §3.2.
- Альфа Software System может достичь Usable после первого успешного релиза.

## 6. Открытые вопросы

- Automation semantic-release — отложить до необходимости (enterprise).
- Matrix-CI (ubuntu + macos) — добавить при росте пользовательской базы.
- Политика deprecation — сформулировать при первом breaking change.
