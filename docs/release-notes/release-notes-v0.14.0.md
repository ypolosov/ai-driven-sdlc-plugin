# Release v0.14.0 — Wave 11: brownfield-seeding + Этап-0 preconditions

**Тип:** minor (semver) — новый script + изменение протокола `sdlc-bootstrap`.

## Контекст

Wave 11 закрывает 2 находки 3-раундового критического аудита issue [#82](https://github.com/ypolosov/ai-driven-sdlc-plugin/issues/82):

- **B0.4** — методологический корень (A2/A3/A8 из Essence + Левенчук): bootstrap не различал greenfield и brownfield. Для GromTech (live лицензированная gambling-платформа) это привело бы к ложной модели — зрелый продукт зафиксирован как стартап с нуля; все последующие фазы наследуют кривую базу.
- **B0.5** — дешёвый read-only guard перед созданием артефактов (C2).

## Изменено

| Fix | Что |
|---|---|
| **B0.4** | `sdlc-bootstrap/SKILL.md`: вопрос #2 (зрелость greenfield/brownfield); секция альф разделена — greenfield стартует в начальных состояниях, brownfield отражает реальность (запрет регресса ниже фактического — Essence); шаг 5 протокола больше не предписывает безусловно «все альфы в начальном состоянии» |
| **B0.5** | новый `scripts/check-bootstrap-preconditions.sh` — Этап-0 gate: BLOCK если `.env` в git tracking; INFO про существующий `.mcp.json`/`.claude/sdlc`; WARN если не git-репо. Интегрирован в SKILL как Шаг -1 |

## Применение к brownfield (GromTech)

Перед `/sdlc-init` в `/workspaces/gt`:

```bash
bash <plugin>/scripts/check-bootstrap-preconditions.sh /workspaces/gt
```

При bootstrap на вопрос #2 ответить **brownfield** → skill оценит фактическое состояние каждой альфы (опрос/RAG), а не сбросит в начальное. Way of Working live-системы с 25+ ADR — обычно In Use / In Place, не Principles Established.

## Качество

- 243 bats-теста зелёные, 0 регрессий (196 unit + 47 integration); +12 новых кейсов (TDD red→green).
- `shellcheck` CLEAN; `shfmt -i 2 -ci` CLEAN; `check-readme-inventory: OK`.
- Принцип 16: README (Scripts 21, тесты 25 файлов/196), CHANGELOG обновлены.

## Остаток backlog #82

B3.4 (provenance при отключённых MCP), B6.1 (функц/констр декомпозиция), B2.5 (team-agreement gate), B1.2 (tool-bindings skeleton), B1.3 (.env.example enterprise) — следующие Wave.
