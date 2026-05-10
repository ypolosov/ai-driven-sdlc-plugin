# v0.5.0 — Принцип 22: enforce-sdlc-phase (физическое принуждение dogfooding)

Дата: 2026-05-05.

## ⚠️ ACTION REQUIRED

После установки v0.5.0 необходимо **перезагрузить Claude Code** или выполнить `/plugin reload ai-driven-sdlc`, чтобы новый PreToolUse hook стал активен в текущей сессии.

## Что нового

**Принцип 22 «Обязательное использование плагина для write-операций»** делает методологию плагина физически принудительной через PreToolUse hook.

Без `active_phase` в `<target>/.claude/sdlc/profile.md` блокируются:

- **Bash**: `git commit/push/tag/rebase/reset/checkout/rm/merge/cherry-pick/revert/clean/stash`, `gh pr (create|merge|edit|close|reopen)|release|repo (delete|create)`, `npm publish/unpublish/deprecate`.
- **Edit/Write**: пути ВНЕ whitelist (`.claude/sdlc/**`, `.claude/CLAUDE.md`, `.gitignore`, `.env.example`, `README.sdlc.md`).

Read-операции (`git status|diff|log|show`, `gh auth|status`, `npm view|test`) — всегда разрешены.

## Активация active_phase

```bash
/sdlc-init                              # bootstrap — создаёт profile.md
/sdlc-phase development                 # сетит active_phase + active_phase_set_at
git commit -m "feat: ..."               # теперь разрешено
```

TTL по умолчанию 24 ч на `active_phase_set_at`. После — нужно повторить `/sdlc-phase` или продлить через `/sdlc-autonomy`.

## Override механизмы

- **Эфемерный HOOTL:** `/sdlc-autonomy --task hootl --duration 1h` пишет gitignored `.claude/sdlc/autonomy.session.md`.
- **CI escape:** `SDLC_PHASE_ENFORCE=skip` env var (рекомендуется только для GitHub Actions).
- **TTL override:** `SDLC_PHASE_TTL_HOURS=<N>` env var.

## Изменения

- `scripts/enforce-sdlc-phase.sh` — новый PreToolUse hook (Python heredoc внутри bash).
- `tests/unit/enforce-sdlc-phase.bats` — 10 кейсов.
- `tests/integration/enforce-sdlc-phase-integration.bats` — 4 кейса.
- `meta-templates/profile.meta.md` — добавлены поля `active_phase`, `active_phase_set_at`.
- `meta-templates/plugin-config.meta.md` — добавлена секция `phase_enforcement`.
- `hooks/hooks.json` — расширен PreToolUse matcher `Bash|Write|Edit`.
- `scripts/bench-hooks.sh` — добавлен entry `enforce-sdlc-phase` (avg 26ms локально).
- `.gitignore` — добавлен `.claude/sdlc/autonomy.session.md` (ephemeral).
- `CLAUDE.md` — принцип 22 + источник в таблице принципов.
- `memom.md` — запись add 2026-05-05.

## Итоговые числа

- Принципы: 22 → 23 (1–17 + 4a + 18, 19, 19a + 20, 21, 22).
- Скрипты: 16 → 17.
- Bats unit: 74 → 84 кейса (10 файлов → 11 файлов).
- Bats integration: 40 → 44 кейса (2 файла → 3 файла).
- Hooks в bench: 8 → 9.

## Мотив

После релиза v0.4.0 агент сделал 9+ PR подряд напрямую через git/gh/npm/Edit, **ни разу** не вызвав skills плагина (`/sdlc-continue`, `/sdlc-phase`, `/sdlc-status`). Принципы 1, 6, 12 нарушались без enforcement. Hook делает методологию обязательной.

## Совместимость

- Существующие `profile.md` без `active_phase`/`active_phase_set_at` будут блокироваться. Нужно один раз вызвать `/sdlc-phase <name>` для активации фазы.
- Skills `/sdlc-phase` пока не пишут `active_phase` автоматически (TODO в следующем минорном релизе). Временно заполняйте поле вручную или используйте `SDLC_PHASE_ENFORCE=skip`.

## Связанные релизы

- v0.4.0 (2026-05-05) — multi-agent extension + sdlc-state-rag.
- `@ypolosov/sdlc-state-rag@0.1.1` — backend трекера альф.
