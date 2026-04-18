---
name: memom
type: plugin-evolution-journal
scope: журнал эволюции принципов плагина (принцип 15)
source_of_truth_for_principles: CLAUDE.md
---

# Memom плагина `ai-driven-sdlc`

Журнал изменений принципов плагина как системы.
**Источник истины о текущих принципах — `CLAUDE.md`**.
Этот файл — только история; не читается hooks для решения о текущем состоянии.

## Формат записи

Одна секция `##` на каждое изменение.

```markdown
## <YYYY-MM-DD> — <краткий заголовок>
- principle: <номер, например 17>
- action: add | modify | remove
- before: <предыдущая формулировка или null>
- after: <новая формулировка или null>
- motive: <причина изменения>
- consequences: <что меняется в артефактах, скриптах, командах>
- related_commits: [<хеши>]
```

## Журнал

## 2026-04-17 — Волна 2: введены принципы 14–17
- principle: 14, 15, 16, 17
- action: add
- before: null
- after:
  - 14: Конвенция пути артефактов `<target>/.claude/sdlc/`; bootstrap-режимы.
  - 15: `CLAUDE.md` — источник истины; `memom.md` — журнал; hook блокирует изменение принципа без записи.
  - 16: README плагина как живой артефакт со сверкой имён (не только счётчиков).
  - 17: README per система внимания в целевом проекте; kind materialized/logical; флаги --transient и --retire.
- motive: завершение плана MVP; переход от Волны 1 (каркас) к Волне 2 (dogfooding-зрелость).
- consequences:
  - Добавлены мета-шаблон `system-readme.meta.md` и 3 скрипта.
  - Расширены `system-context.meta.md`, `plugin-config.meta.md`.
  - Расширена команда `/sdlc-focus` флагами.
  - Добавлена таблица привязки принципов 1–17 + 4a к главам Левенчука.
- related_commits: []

## Правила ведения

- Запись создаётся **до** или **вместе** с изменением `CLAUDE.md`.
- Hook `check-memom-consistency.sh` блокирует коммит, где изменён `CLAUDE.md` без новой записи.
- Откат принципа — новая запись с `action: remove` или `action: modify`.
- `memom.md` не источник истины; он о прошлом, не о настоящем.
