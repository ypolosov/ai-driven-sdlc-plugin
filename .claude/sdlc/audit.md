---
name: audit
type: audit-report
project: ai-driven-sdlc-plugin
run_at: 2026-05-10T22:35:00Z
auditor: sdlc-consistency-auditor
status: warn
issues_count: 9
fail: 0
warn: 6
note: 3
plugin_version: 0.10.0
wave_scope: Wave 7 (gt-validation backlog closure)
---

# Audit Report — ai-driven-sdlc-plugin (after Wave 7)

## Резюме

Wave 7 закрыт корректно: 5 issues (#54-#58) в state CLOSED, 4 PR merged (#62-#65), 4 release published (v0.7.0..v0.10.0), артефакты Wave 7 присутствуют, frontmatter валиден.

Однако накоплен дрейф документации после Wave 4-7: счётчики README устарели, memom не отражает Wave 6-7, architecture.md фиксирует только ADR-001..009, profile.md не содержит фазу integrations Wave 4. Это типичный drift «code shipped, docs lag», не функциональные дефекты.

**Финальный статус — warn**: 0 fail, 6 warn, 3 note. Merge не блокируется.

## Сводка по проверкам

| Проверка | Статус |
|---|---|
| Детерминированный validate-artifact.sh (на 27+ артефактов) | pass |
| check-cross-refs.sh | pass |
| check-readme-inventory.sh | pass |
| check-memom-consistency.sh | pass |
| check-system-readmes.sh | pass |
| Трассируемость phases ↔ ADR ↔ alphas | warn |
| CLAUDE.md ↔ memom.md консистентность | warn |
| README inventory актуальность | warn |
| system-context ↔ architecture | pass |
| profile.md ↔ ADR | warn |
| alphas через `sdlc-state-rag` | warn |
| Wave 7 closure (issues + releases) | pass |
| Wave 7 артефакты валидны | pass |

## Находки

### W-1 (warn): architecture.md перечисляет только ADR-001..009

Реально 16 ADR в `adr/`. Wave 4/5 ADR (010-016) не отражены. **Альтернативы:** (1) добавить §5а с ADR-010..016 как Wave 4-5 snapshot; (2) перегенерировать §5 как сводную таблицу всех 16; (3) превратить §5 в ссылку на `adr/README.md` (DRY).

### W-2 (warn): memom.md не отражает Wave 6-7

Последняя запись 2026-05-05 (Wave 5). Wave 6 (A1+A2) и Wave 7 (4 PR) изменили поведение принципов 14/16/22/4a без записи в memom (нарушение принципа 15). **Альтернативы:** (1) 4 записи `action: clarify`; (2) **одна агрегированная запись `2026-05-10 — Wave 6-7 cleanup`**; (3) расширить определение принципа 15.

### W-3 (warn): счётчики README устарели

- Meta-templates (19) → **24** на диске (включая 3 work-unit + 5 external-systems в subdir).
- Tests «16 файлов» → **17** unit-bats файлов.
- «Текущая версия v0.3.1» → **v0.10.0**.
- «23 принципа» vs «17 + 4a» — противоречие; реально **24 секции** (1-22 + 4a + 19a).

**Альтернативы:** (1) auto-fill через `check-readme-inventory.sh --rewrite`; (2) **вручную выровнять 5 строк в одном PR**; (3) auto-generated `<!-- inventory:start -->...<!-- inventory:end -->` блок.

### W-4 (warn): architecture.md упоминает deprecated essence-alpha-mcp

§3.1 строка 50 и §4 ссылается на `essence-alpha-mcp` и `essence_validate_consistency`. Заменены на `sdlc-state-rag` + `state_validate_consistency` (ADR-011 deprecated ADR-009). **Альтернативы:** (1) **replace globally**; (2) добавить аннотацию «Wave 1-2 snapshot»; (3) переписать как architecture-v2.md.

### W-5 (warn): profile.md не отражает integrations и Wave 5-7

Skill `sdlc-integrations` (Wave 4) предполагает фазу `integrations` — отсутствует в profile.md. История изменений обрывается на 2026-04-19. **Альтернативы:** (1) **строка integrations + 5 записей истории Wave 4-7**; (2) отдельный `profile-history.md`; (3) пометить integrations как out-of-band.

### W-6 (warn): alphas snapshot устарел

Software System evidence: `CHANGELOG.md#0.3.0` — но реально v0.10.0. Журнал MCP-продвижений обрывается 2026-05-02. **Альтернативы:** (1) **`state_advance_with_decision` → CHANGELOG#0.10.0**; (2) альфа Way of Working цикл `Retired+Restarted` per Волну; (3) evidence-history секция.

### N-1 (note): alphas.md теряет evidence_uri prefix

Поле «Артефакт-свидетельство» — markdown-путь без `file://` URI prefix. БД хранит uri, snapshot strips. При reverse-sync теряется тип.

### N-2 (note): release-notes-v*.md в репо vs .gitignore

11 файлов release-notes в корне; .gitignore содержит `release-notes-v*.md`. Несогласованность. **Альтернативы:** (1) убрать паттерн; (2) `git rm --cached`; (3) **перенести в `docs/release-notes/`**.

### N-3 (note): `.sdlc-db/` в корне

Pglite data dir в репо. Принцип 21 «pet — embedded pglite» допускает, но БД-файлы могут попасть в git. Проверить .gitignore.

## Wave 7 closure verification

| Issue | State | Закрыт в |
|---|---|---|
| #54 Gap-3 (P0 external-systems) | CLOSED | v0.10.0 |
| #55 Gap-0 (P1 realpath) | CLOSED | v0.7.0 |
| #56 Gap-2 (P1 heredoc) | CLOSED | v0.7.0 |
| #57 Gap-4 (P1 role-extensions) | CLOSED | v0.8.0 |
| #58 Gap-6 (P1 work-unit templates) | CLOSED | v0.9.0 |

Все 5 closed.

## Привязка к альфам

| Альфа | Snapshot state | Реальное состояние |
|---|---|---|
| Opportunity | Value Established | актуально |
| Stakeholders | Involved | актуально |
| Requirements | Acceptable | актуально (Wave 7 расширил work-unit) |
| Software System | Usable (#0.3.0) | устарел, реально v0.10.0 |
| Work | Under Control | актуально |
| Team | Seeded | актуально |
| Way of Working | Working Well | возможно re-evidence (bench-hooks 8→9) |

## Рекомендация

Открыть PR `docs(wave-7-closure): refresh README + memom + alphas + architecture` с фиксами:
- W-1 alt (1), W-2 alt (2), W-3 alt (2), W-4 alt (1), W-5 alt (1), W-6 alt (1), N-2 alt (3).

**Overall: warn (0 fail / 6 warn / 3 note).**
