# Release v0.10.1 — Wave 7 closure docs drift cleanup

**Type:** patch (docs-only).
**Date:** 2026-05-10.
**Closes:** Wave 7 closure (PR #66 merged).
**Audit baseline:** `/sdlc-audit` warn 0/6/3 → expected pass after this release.

## Что изменилось

Patch-релиз без поведенческих изменений. Только синхронизация документации после быстрой череды релизов v0.6.0..v0.10.0 (Wave 6-7).

### README counters (W-3)

- Версия: v0.3.1 → **v0.10.0** (uplifted после Wave 6-7).
- Принципы: «23 принципа» → **«22 принципа + 4a + 19a, 24 секции»** (разрешено противоречие).
- Bench-hooks: **8 → 9** (после Wave 5 enforce-sdlc-phase).
- Meta-templates: **19 → 24** (19 top + 5 external-systems в subdir).
- Финальная фраза «Как читать плагин»: «17 принципов + 4a» → актуальная формулировка.

### memom.md (W-2)

Добавлены 2 записи:

- **2026-05-10 — Wave 6-7 cleanup**: агрегированная запись закрытия 5 issues (#54-#58), 4 PR (#62-#65), 5 релизов (v0.6.0..v0.10.0). Уточнения принципов 14, 18, 22, 4a без формальных правок.
- **2026-05-10 — принцип 13 ratify**: подтверждение что `essence-alpha-mcp` полностью удалён в Wave 5; ADR-009 Deprecated; все ссылки на `essence_validate_consistency` заменены на `state_validate_consistency`.

### architecture.md (W-1, W-4)

- §5а с таблицей ADR-010..016 (Wave 4-5 snapshot).
- Строки 88-89: `essence_validate_consistency` → `state_validate_consistency`; npm pkg name `@ypolosov/sdlc-state-rag`.

### profile.md (W-5)

- +6 history-записей: Wave 4 (PR-A..G), Wave 5 v0.5.0/v0.5.1..v0.5.4, Wave 6 v0.6.0, Wave 7 v0.7.0..v0.10.0, фаза-активации.
- `sdlc-integrations` skill помечен как **out-of-band** cross-cutting (не SDLC-фаза в SME-таблице).

### alphas.md (W-6)

- Software System evidence: `CHANGELOG.md#0.3.0` → **`CHANGELOG.md#0.10.0`**; date 2026-05-02 → 2026-05-10.
- +3 строки журнала: software-system evidence refresh; way-of-working evidence refresh с bench-hooks 9.
- Зафиксировано через `mcp__sdlc-state-rag__decisions_record` ×3 (id 1, 2, 3).

### release-notes layout (N-2)

- 12 файлов `release-notes-v*.md` (v0.3.0..v0.10.0) перенесены из root в `docs/release-notes/`.
- `.gitignore`: паттерн `release-notes-v*.md` → `/release-notes-v*.md` (root only).
- Committed-копии теперь tracked в git; root остаётся для temp-файлов `gh release create --notes-file`.

## Plugin tools used (принцип 12 dogfooding)

| Tool | Назначение |
|---|---|
| skill `/sdlc-phase development` | Активация фазы для drift cleanup |
| skill `/sdlc-phase deployment` | Активация фазы для release |
| `AskUserQuestion` ×2 | Принцип 1 опрос ДО правок и ДО release |
| `mcp__sdlc-state-rag__state_get_alpha` ×2 | Чтение Work, Software System |
| `mcp__sdlc-state-rag__decisions_record` ×4 | id 1: phase activation; id 2: software-system evidence; id 3: way-of-working evidence; id 4: deployment scope |
| `scripts/check-readme-inventory.sh` | Inventory consistency check |
| `scripts/check-memom-consistency.sh` | Memom-принципы consistency |

Принципы применены: **1** (AskUserQuestion ДО write), **13** (decisions через MCP), **15** (memom-запись Wave 6-7), **16** (README обновлён), **22** (active_phase через skill).

## Установка / обновление

```bash
/plugin marketplace update ypolosov
/plugin update ai-driven-sdlc
```

После update — verify в settings: версия v0.10.1.

## Known issue (Wave 8 candidate)

`scripts/check-alpha-consistency.sh` использует TCP `postgresql://localhost:5432` fallback вместо pglite mode → ECONNREFUSED при PostToolUse hook на pet-target (embedded pglite). Edit'ы применяются (postoolUse не откатывает), но hook ругается. Issue будет открыт отдельно.

## Audit re-run после merge

После squash merge release/v0.10.1 в main — рекомендуется `/sdlc-audit` для верификации `warn → pass`.
