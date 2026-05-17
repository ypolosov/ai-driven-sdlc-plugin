# Release v0.13.0 — GT enterprise bootstrap-блокеры (Wave 10)

**Тип:** minor (semver) — новый дефолт `alpha-journal` + новые schema-поля `rag-config`.

## Контекст

Первое реальное enterprise-применение плагина к **GromTech** (лицензированный gambling-оператор, brownfield, 25+ ADR, команда 10-15) выявило истинные bootstrap-блокеры из issue [#82](https://github.com/ypolosov/ai-driven-sdlc-plugin/issues/82). 3-раундовый критический аудит (self-review + Левенчук + Essence + жёсткий мета-аудит) подтвердил **C1 как единственный необратимый блокер** — регуляторная RAG-утечка.

Реализованы 5 истинных блокеров — без которых bootstrap нельзя выполнить или он деструктивен.

## Исправлено

| Fix | Что | Почему блокер |
|---|---|---|
| **B0.1** | `bootstrap-target.sh` пишет `active_phase: null`+`active_phase_set_at: null` явно; success message с next-step (`/sdlc-phase`,`/sdlc-tools`) + предупреждение про `enforce-sdlc-phase` | hook блокировал любой write после bootstrap |
| **B0.2** | дефолт `alphas.md` → `type: alpha-journal` по schema `alpha-state.meta.md` (без `source_of_truth`/plugin-refs); `check-alpha-consistency.sh` early-exit для journal | без рабочего MCP альфы были стейтлесс |
| **B0.3** | `.gitignore` блок: `.sdlc-db/`, `.sdlc-worker/`, `autonomy.session.md`, `external-systems/*.local.md` | утечка embeddings/decisions/PII в git |
| **B0.6/C3** | backup `.mcp.json`→`.mcp.json.bak` перед merge | деструктивно для brownfield MCP-конфигурации команды |
| **B4.4/C1** | `rag-config.meta.md`: поля `data_classification`+`compliance_signoff`; `check-rag-config.sh` gate блокирует `regulated`+`enabled` без sign-off | регуляторная gambling/GDPR утечка (необратимая) |

## Migration / Upgrade существующих targets

**Important:** дефолт `alphas.md` изменён только для **НОВЫХ** bootstrap. Существующие targets НЕ трогаются.

- Если ваш target использует `type: alpha-snapshot` с рабочим MCP — ничего делать не нужно.
- Если хотите перейти с `alpha-snapshot` (без рабочего MCP) на `alpha-journal`:
  - вручную в `<target>/.claude/sdlc/alphas.md`: заменить `type: alpha-snapshot` на `type: alpha-journal`, удалить поля `source_of_truth:`/`snapshot_role:`/`generated_after:`;
  - привести тело к schema `alpha-state.meta.md` (Section 1 таблица альф + Section 2 журнал).
- Для regulated-таргетов (gambling/PII/KYC): добавить `data_classification: regulated` в `rag-config.md`; при `enabled: true` обязателен `compliance_signoff: <DPA reference>`, иначе `check-rag-config.sh` блокирует.

## Качество

- 231 bats-теста зелёные, 0 регрессий (184 unit + 47 integration); +27 новых кейсов (TDD red→green).
- `shellcheck` CLEAN; `shfmt -i 2 -ci` CLEAN; `check-readme-inventory: OK`; bench-hooks ok.
- Принцип 3: шаблон `alphas.md` без plugin-internal references; migration-инфо — здесь (plugin-side doc), не в target-артефакте.

## Следующие Wave

Остаток issue #82 (P1/P2) + новые из 3-раундового аудита: B0.4 (greenfield/brownfield seeding), B0.5 (Этап-0 верификация), B3.4 (provenance), B6.1 (функц/констр декомпозиция), B2.5 (team-agreement gate), B1.2/B1.3 (tool-bindings/.env.example).
