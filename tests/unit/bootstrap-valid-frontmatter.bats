#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/bootstrap-target.sh"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_DIR"
}

run_bootstrap() {
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$SCRIPT" "$TMP_DIR" fail-if-exists >/dev/null 2>&1 || true
}

@test "bootstrap creates profile.md with type sdlc-profile (not placeholder)" {
  run_bootstrap
  run grep -E "^type: sdlc-profile$" "$TMP_DIR/.claude/sdlc/profile.md"
  [ "$status" -eq 0 ]
}

@test "bootstrap creates plugin-config.md with type hooks-config" {
  run_bootstrap
  run grep -E "^type: hooks-config$" "$TMP_DIR/.claude/sdlc/plugin-config.md"
  [ "$status" -eq 0 ]
}

@test "bootstrap creates alphas.md with type alpha-snapshot" {
  run_bootstrap
  run grep -E "^type: alpha-snapshot$" "$TMP_DIR/.claude/sdlc/alphas.md"
  [ "$status" -eq 0 ]
}

@test "bootstrap creates system-context.md with type attention-context" {
  run_bootstrap
  run grep -E "^type: attention-context$" "$TMP_DIR/.claude/sdlc/system-context.md"
  [ "$status" -eq 0 ]
}

@test "bootstrap creates roles.md with type role-journal" {
  run_bootstrap
  run grep -E "^type: role-journal$" "$TMP_DIR/.claude/sdlc/roles.md"
  [ "$status" -eq 0 ]
}

@test "bootstrap creates decisions.md with type decision-journal" {
  run_bootstrap
  run grep -E "^type: decision-journal$" "$TMP_DIR/.claude/sdlc/decisions.md"
  [ "$status" -eq 0 ]
}

@test "no artifact has type placeholder after bootstrap" {
  run_bootstrap
  run grep -rE "^type: placeholder$" "$TMP_DIR/.claude/sdlc/"
  [ "$status" -ne 0 ]
}

@test "all 6 artifacts have project field matching target basename" {
  run_bootstrap
  expected="$(basename "$TMP_DIR")"
  for f in profile plugin-config alphas system-context roles decisions; do
    grep -qE "^project: ${expected}$" "$TMP_DIR/.claude/sdlc/${f}.md"
  done
}
