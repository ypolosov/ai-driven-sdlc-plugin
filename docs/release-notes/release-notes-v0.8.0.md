# v0.8.0 — Wave 7 PR-2: Gap-4 (bootstrap создаёт role-extensions.md)

Дата: 2026-05-10.

## TL;DR

Закрывает #57 (Gap-4, P1) из Wave 6 backlog. `scripts/bootstrap-target.sh` теперь создаёт `<target>/.claude/sdlc/role-extensions.md` placeholder при инициализации.

## Что добавлено

- `bootstrap-target.sh` после создания 6 placeholder артефактов (profile/plugin-config/alphas/system-context/roles/decisions) дополнительно создаёт `role-extensions.md` с правильной схемой:
  - frontmatter `type: target-role-mapping` (соответствует ADR-015 / `target-roles.meta.md`).
  - человекочитаемая инструкция формата записи роли.
  - пример pet-роли `solo-developer extends [product-owner, architect, developer, tester, devops]`.

- 4 новых bats-кейса в `tests/unit/bootstrap-role-extensions.bats`:
  - file created.
  - frontmatter type correct.
  - name + project fields.
  - merge-mode preserves existing.

## Тесты

- Unit total: 100 → 104 кейсов.
- Все 104 unit + 47 integration GREEN.
- bench-hooks все <200ms.

## ⚠️ ACTION REQUIRED

После merge — `/plugin update ai-driven-sdlc` или перезагрузка Claude Code. Существующие таргеты не затронуты (bootstrap не запускается повторно).

## Wave 7 прогресс

| Issue | Severity | Статус |
|---|---|---|
| #55 Gap-0 (realpath) | P1 | ✅ v0.7.0 |
| #56 Gap-2 (heredoc) | P1 | ✅ v0.7.0 |
| #57 Gap-4 (role-extensions) | P1 | ✅ v0.8.0 |
| #58 Gap-6 (work-unit templates) | P1 | pending |
| #54 Gap-3 (external-systems) | P0 | pending |

## Self-application

PR создан через активную фазу development в плагине; release v0.8.0 — через deployment.
