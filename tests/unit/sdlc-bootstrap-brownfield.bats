#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SKILL="$REPO_ROOT/skills/sdlc-bootstrap/SKILL.md"
}

@test "B0.4: SKILL.md упоминает greenfield/brownfield различие" {
  run grep -iE 'greenfield|brownfield' "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B0.4: SKILL.md НЕ предписывает безусловно 'все альфы в начальном состоянии'" {
  run grep -F "все альфы в начальном состоянии" "$SKILL"
  [ "$status" -ne 0 ]
}

@test "B0.4: SKILL.md требует оценку фактического состояния альф для brownfield" {
  run grep -iE 'фактическ|реальн.* состояни|отражают реальность|не регресс' "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B0.4: SKILL.md ссылается на Этап-0 preconditions (B0.5 интеграция)" {
  run grep -F "check-bootstrap-preconditions" "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B0.4: вопросы bootstrap включают maturity/brownfield вопрос" {
  run grep -iE 'greenfield.*brownfield|brownfield.*greenfield|новый проект.*существующ|live|в проде|эксплуатиру' "$SKILL"
  [ "$status" -eq 0 ]
}
