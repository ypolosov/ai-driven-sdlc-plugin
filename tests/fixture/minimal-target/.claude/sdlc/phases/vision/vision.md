---
name: vision
type: vision
phase: vision
sme_level: pet
method: Одностраничное описание проблемы и цели
tool: README-as-vision
alphas: [Opportunity, Stakeholders]
disciplines: [product-discovery]
role: method-engineer
traces_from: []
traces_to: []
system_of_attention: minimal-target
created: 2026-04-19
updated: 2026-04-19
---

# Vision фикстуры minimal-target

## 1. Назначение

Фикстура — минимальный валидный целевой проект для integration-тестов плагина.
Проверяет прохождение всех скриптов на свежем каркасе.

## 2. Бенефициар

- Разработчик плагина ai-driven-sdlc.
- CI-пайплайн плагина при прогоне fitness-функций.

## 3. Проблема

Без фикстуры тесты hooks и скриптов требуют ручного создания каркаса.
Фикстура даёт воспроизводимую точку входа для integration-сценариев.

## 4. Решение

Готовый каркас `.claude/sdlc/` с валидными артефактами фазы vision.
Используется bats integration-тестами через переменную `FIXTURE_DIR`.

## 5. Критерии готовности

- Все артефакты фикстуры проходят `validate-artifact.sh`.
- `check-cross-refs.sh` на фикстуре возвращает 0 расхождений.
- `check-system-readmes.sh` проходит без ошибок.
