---
name: audit
type: audit-report
project: ai-driven-sdlc-plugin
run_at: 2026-05-10T23:30:00Z
auditor: sdlc-consistency-auditor
status: warn
issues_count: 5
fail: 0
warn: 2
note: 3
plugin_version: 0.10.1
wave_scope: Wave 7 closure post v0.10.1 docs drift cleanup
previous_status: warn (0/6/3 @ 2026-05-10T22:35:00Z)
---

# Audit Report — ai-driven-sdlc-plugin (post v0.10.1)

## 1. Резюме

Wave 7 closure drift cleanup (v0.10.1, PR #66 + #67 merged 2026-05-10) выполнен корректно. Все 6 warn предыдущего аудита (W-1..W-6) закрыты. Из 3 note: N-2 закрыт переносом release-notes в `docs/release-notes/`; N-1 и N-3 остаются acceptable open per spec.

Остаточный drift минимальный — README не отражает свежий patch v0.10.1 и actualization после Wave 4-7. Это докум-drift второго порядка, не функциональный.

**Финальный статус — warn**: 0 fail, 2 warn, 3 note (с 9 → 5 issues). Merge не блокируется. PR #68 (chore alphas-sync) open и приемлем.

## 2. Проверки

| Проверка | Статус | Детали |
|---|---|---|
| Детерминированный `check-cross-refs.sh` (с hook payload) | pass | EXIT=0; битых ссылок 0 |
| Детерминированный `check-readme-inventory.sh` | pass | OK |
| Детерминированный `check-memom-consistency.sh` | pass | (silent OK) |
| Детерминированный `check-system-readmes.sh` | pass | (silent OK) |
| Трассируемость phases ↔ ADR ↔ alphas (W-1) | pass | §5а добавлена; ADR-010..016 видны на line 117-127 architecture.md |
| CLAUDE.md ↔ memom.md (W-2) | pass | 2 записи 2026-05-10: «Wave 6-7 cleanup» + «принцип 13 ratify»; принципы 14/18/22/4a clarify зафиксированы |
| README inventory актуальность (W-3) | warn | counters обновлены (v0.10.0, 24 секции, 9 hooks, 24 meta-templates, 17 unit-bats); НО patch v0.10.1 не отражён в `## Статус`; backlog «Wave 3 (идёт)» устарел |
| system-context ↔ architecture (W-4) | pass | `essence_validate_consistency` → `state_validate_consistency` на line 88; npm pkg `@ypolosov/sdlc-state-rag` на line 89 |
| profile.md ↔ ADR (W-5) | pass | +6 history records 2026-05-04..2026-05-10 (Wave 4-7 + integrations out-of-band) |
| Альфы БД ↔ markdown snapshot (W-6) | pass | software-system evidence `CHANGELOG.md#0.10.1`; журнал MCP-продвижений `state_regress + state_advance` 2026-05-10T20:22Z; commit aea5c5e PR #68 sync БД→markdown |
| Wave 7 closure (issues #54-#58 + releases v0.7.0..v0.10.1) | pass | gh issue list: 5 CLOSED 2026-05-10; gh release list: v0.7.0..v0.10.1 published 18:34-20:12Z |
| release-notes layout (N-2) | pass | 13 файлов в `docs/release-notes/` (v0.3.0..v0.10.1); `.gitignore` `/release-notes-v*.md` root-only |
| active_phase TTL (принцип 22) | pass | `deployment` set at 2026-05-10T20:06:57Z (<3.5h, в TTL 24h) |

## 3. Найденные расхождения

### W-3-residual (warn): README статус не отражает v0.10.1

**Локация:** `README.md` line 9 «Текущая версия: **v0.10.0**».
**Описание:** v0.10.1 published 2026-05-10T20:12Z (patch docs-only). README статус остался на v0.10.0. Backlog-секция упоминает «Wave 3 (идёт), Wave 4, Wave 5» — устарело после закрытия Wave 4/5/6/7.
**Критичность:** important (видимый drift в публичной поверхности через 0 дней после релиза).

### W-7 (warn): README «Покрыто тестами 6 из 13 скриптов» устарело

**Локация:** `README.md` секция Tests & CI, последняя строка.
**Описание:** После Wave 6-7 добавлены `check-adr-paths.bats`, `work-unit-templates.bats`, `external-systems-references.bats`, `bootstrap-role-extensions.bats`, `init-mcp-json.bats`. Фактически покрыто 11+ скриптов (точный count требует пересчёта).
**Критичность:** important (frame для backlog Волны 3 неактуален).

### N-1 (note): alphas.md evidence без `file://` prefix

**Локация:** `.claude/sdlc/alphas.md` колонка «Артефакт-свидетельство».
**Описание:** Markdown-путь без URI scheme. БД хранит `file:///...`, snapshot strips. По спецификации acceptable; не блокирует.
**Критичность:** note.

### N-3 (note): `.sdlc-db/` artifact tracked-state vs gitignore

**Локация:** `.gitignore` line 11 / `.sdlc-db/` directory.
**Описание:** `.sdlc-db/` в `.gitignore` (line 11), pglite БД живёт локально. Acceptable per design (per-target БД, принцип 21). Note для напоминания о backup-policy.
**Критичность:** note.

### N-4 (note): alphas.md frontmatter `updated: 2026-05-10` без timestamp

**Локация:** `.claude/sdlc/alphas.md` frontmatter line 5.
**Описание:** Журнал внутри содержит `2026-05-10T20:22Z`, но frontmatter только дата. Минорный desync.
**Критичность:** note.

## 4. Предложенные фиксы

### W-3-residual фиксы

1. **Single-line patch:** `Текущая версия: **v0.10.0**` → `**v0.10.1**` в README.md строка 9.
2. **Auto-fill через скрипт:** `check-readme-inventory.sh --rewrite-version` синхронизирует с git tag latest.
3. **Inventory-block:** `<!-- version:start -->...<!-- version:end -->` авто-генерируемый CI-шагом.
4. **Backlog-обновление:** «Wave 1-7 закрыты, Wave 8 backlog» взамен текущей строки.

**Рекомендуемая комбинация:** (1) + (4) одним PR.

### W-7 фиксы

1. **Recount:** скрипт `count-test-coverage.sh` пересчитать и обновить вручную («X из 13 скриптов»).
2. **Drop the metric:** убрать строку как малополезную; покрытие видимо через CI.
3. **Move to CHANGELOG:** перенести в Unreleased секцию как Wave 3 backlog-метрику.

**Рекомендуемая:** (2) — метрика дублирует CI-отчёт.

### N-1 фикс (опционально)

1. Авто-нормализация при snapshot-rewrite (markdown ↔ БД).
2. Принять `markdown-path` как канон для PR-readability.
3. Two-format: внутри backticks markdown, в БД URI.

**Рекомендуемая:** (2) — статус-кво.

### N-3 фикс (опционально)

1. Документировать backup-policy в `external-systems/sdlc-state-rag.md`.
2. Принять текущее состояние (БД восстанавливается из markdown snapshot + journal).

**Рекомендуемая:** (2) — markdown является source of truth для restore.

### N-4 фикс (опционально)

1. Авто-обновление frontmatter `updated` через `mcp-write` PostToolUse hook на полный ISO timestamp.
2. Принять дату-only для daily-granular freshness.

**Рекомендуемая:** (1) для будущей Wave 8 enhancement.

## 5. Привязка к альфам

Состояние на 2026-05-10T23:30:00Z (через snapshot `.claude/sdlc/alphas.md` + журнал MCP-продвижений; БД проверка делегирована `sdlc-alpha-tracker`):

| Альфа | Состояние | Свидетельство | Проверка |
|---|---|---|---|
| Opportunity | Value Established | `phases/vision/vision.md` | pass |
| Stakeholders | Involved | `phases/requirements/requirements.md` | pass |
| Requirements | Acceptable | `phases/architecture/architecture.md` | pass |
| Software System | Usable | `CHANGELOG.md#0.10.1` | pass (W-6 sync via state_regress+state_advance 2026-05-10T20:22Z) |
| Work | Under Control | `tests/unit/validate-artifact.bats` | pass |
| Team | Seeded | `roles.md` | pass |
| Way of Working | Working Well | `phases/testing/testing.md` §7a (9 hooks <200ms) | pass |

Ready criteria для Software System (uplift на Ready) не достигнуты: 3 P2 issues #59-#61 остаются open (per release-notes-v0.10.1 acceptable).

## 6. Сравнение с предыдущим audit

| Issue | Prev (22:35Z) | Current (23:30Z) | Закрыто чем |
|---|---|---|---|
| W-1 architecture ADR-010..016 | warn | **pass** | PR #66 §5а |
| W-2 memom Wave 6-7 | warn | **pass** | PR #66 +2 записи |
| W-3 README counters | warn | warn (residual) | PR #66 counters; статус-строка осталась |
| W-4 essence-alpha-mcp deprecated refs | warn | **pass** | PR #66 replace |
| W-5 profile.md history Wave 4-7 | warn | **pass** | PR #66 +6 records |
| W-6 alphas.md evidence stale | warn | **pass** | PR #67 + PR #68 commit aea5c5e |
| N-1 evidence URI prefix | note | note | accepted per spec |
| N-2 release-notes layout | note | **pass** | PR #66 docs/release-notes/ + .gitignore /root-only |
| N-3 .sdlc-db/ gitignore | note | note | accepted per spec |

**Дельта:** 6 warn closed, 1 warn residual, 1 new warn (W-7 derivative), 1 note resolved, 2 notes accepted.

## Финальный статус

**warn** (0 fail / 2 warn / 3 note). Снижение с 9 → 5 issues. Merge не блокируется. Wave 7 closure корректен; v0.10.1 patch успешен; PR #68 acceptable open для финального sync БД snapshot.
