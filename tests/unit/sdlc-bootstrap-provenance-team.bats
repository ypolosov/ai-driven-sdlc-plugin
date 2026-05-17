#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SKILL="$REPO_ROOT/skills/sdlc-bootstrap/SKILL.md"
}

@test "B3.4: SKILL требует provenance для seed-значений при отключённых MCP" {
  run grep -iE 'provenance|провенанс' "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B3.4: SKILL ссылается на принцип 19a при недоступном MCP/RAG" {
  run grep -E '19a' "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B3.4: SKILL описывает источник provenance (catalog/user/TODO-no-provenance)" {
  run grep -iE 'TODO-no-provenance|catalog.*user|источник.* реш' "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B2.5: SKILL фиксирует enterprise SME-выбор как proposal требующий team-review" {
  run grep -iE 'proposal|подтвержд.* команд|team-review|требует согласия команды' "$SKILL"
  [ "$status" -eq 0 ]
}

@test "B2.5: SKILL ссылается на Stakeholders In Agreement (Essence)" {
  run grep -iE 'In Agreement|согласие стейкхолдеров|Stakeholders.* agree' "$SKILL"
  [ "$status" -eq 0 ]
}
