# v0.7.0 — Wave 7 PR-1: hook fixes из gt-validation backlog

Дата: 2026-05-10.

## TL;DR

Закрывает 2 P1 hook-issues (#55 + #56) обнаруженных при gt-validation Wave 6. Оба фикса разблокируют dogfooding-разработку плагина.

## Что исправлено

### Gap-0 (#55): `enforce-sdlc-phase.sh` использует realpath

`scripts/enforce-sdlc-phase.sh` теперь:
1. Получает `realpath(file_path)` относительно `cwd`.
2. Если файл **вне CWD-tree** (например `~/.claude/plans/foo.md` при `cwd=/home/user/project`) — exit 0.
3. Иначе — текущая логика проверки `active_phase` TTL.

Снимает workaround: больше не нужен HOOTL-override `/sdlc-autonomy --task hootl --duration 1h` для редактирования plan-файлов или memory-файлов вне target.

### Gap-2 (#56): `enforce-no-comments.sh` распознаёт heredoc-блоки

`scripts/enforce-no-comments.sh` теперь:
1. Парсит файл line-by-line, отслеживая heredoc-state.
2. Определяет открытие heredoc: `<<EOF`, `<<-EOF`, `<<'EOF'`, `<<"EOF"`.
3. Внутри heredoc-блока **не применяет** comment-detection.
4. Закрытие heredoc — line с одним делимитером (или с leading whitespace для `<<-`).
5. Поддерживает множественные heredocs в одном файле.

Снимает false-positive: editing `bootstrap-target.sh` (с heredocs для CLAUDE.md/.gitignore/.env.example шаблонов) больше не триггерит ложные нарушения.

## Тесты

| Категория | Было | Стало |
|---|---|---|
| Unit total | 94 | 100 (+6) |
| `enforce-sdlc-phase.bats` | 10 | 12 (+2) |
| `enforce-no-comments.bats` | 9 | 13 (+4) |

Новые TDD-кейсы:
- `enforce-sdlc-phase.bats`:
  - `Edit on file outside CWD-tree passes (Gap-0 fix)`
  - `Edit on absolute path inside CWD still requires active_phase`
- `enforce-no-comments.bats`:
  - `heredoc with markdown headers does not trigger (Gap-2 fix)`
  - `heredoc with bash-style hash comments inside is not flagged (Gap-2 fix)`
  - `comment OUTSIDE heredoc is still flagged (Gap-2 fix)`
  - `multiple heredocs all ignored (Gap-2 fix)`

## ⚠️ ACTION REQUIRED

1. После merge — обновите cached версию плагина: `/plugin update ai-driven-sdlc` или перезагрузка Claude Code.
2. Проверьте: `cat ~/.claude/plugins/cache/ypolosov/ai-driven-sdlc/0.7.0/scripts/enforce-no-comments.sh | grep heredoc_re` — должно найтись.

## Что НЕ делается в v0.7.0

- ❌ #54 (Gap-3, P0): reference external-systems/*.md для enterprise MCPs — отдельный PR (большой scope).
- ❌ #57 (Gap-4, P1): bootstrap создаёт role-extensions.md — отдельный PR.
- ❌ #58 (Gap-6, P1): templated work-unit format — отдельный PR.
- ❌ Wave 8 P2 issues (#59, #60, #61) — отложены.

## Wave 7 backlog

После v0.7.0:
- v0.8.0: #54 (P0 — реальные интеграции MCP-серверов).
- v0.8.x: #57, #58 (P1 — bootstrap + work-unit templates).
- v0.9.0+: Wave 8 P2 issues.

## Self-application proof

PR #?? создан через `/sdlc-phase development` (active_phase обновлён в плагине). Release v0.7.0 — через `/sdlc-phase deployment`.
