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

@test "B0.1: profile.md содержит active_phase: null явно" {
  run_bootstrap
  run grep -E "^active_phase: null$" "$TMP_DIR/.claude/sdlc/profile.md"
  [ "$status" -eq 0 ]
}

@test "B0.1: profile.md содержит active_phase_set_at: null" {
  run_bootstrap
  run grep -E "^active_phase_set_at: null$" "$TMP_DIR/.claude/sdlc/profile.md"
  [ "$status" -eq 0 ]
}

@test "B0.1: success message содержит next-step /sdlc-phase" {
  run env CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$SCRIPT" "$TMP_DIR" fail-if-exists
  [[ "$output" == *"/sdlc-phase"* ]]
}

@test "B0.1: success message содержит /sdlc-tools" {
  run env CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$SCRIPT" "$TMP_DIR" fail-if-exists
  [[ "$output" == *"/sdlc-tools"* ]]
}

@test "B0.1: success message предупреждает про enforce-sdlc-phase" {
  run env CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$SCRIPT" "$TMP_DIR" fail-if-exists
  [[ "$output" == *"enforce-sdlc-phase"* ]]
}

@test "B0.2: alphas.md имеет type: alpha-journal (не snapshot)" {
  run_bootstrap
  run grep -E "^type: alpha-journal$" "$TMP_DIR/.claude/sdlc/alphas.md"
  [ "$status" -eq 0 ]
}

@test "B0.2: alphas.md НЕ содержит source_of_truth mcp" {
  run_bootstrap
  run grep -E "^source_of_truth:" "$TMP_DIR/.claude/sdlc/alphas.md"
  [ "$status" -ne 0 ]
}

@test "B0.2: alphas.md НЕ содержит snapshot_role" {
  run_bootstrap
  run grep -E "^snapshot_role:" "$TMP_DIR/.claude/sdlc/alphas.md"
  [ "$status" -ne 0 ]
}

@test "B0.2: alphas.md содержит таблицу альф (Section 1 schema)" {
  run_bootstrap
  run grep -F "Way of Working" "$TMP_DIR/.claude/sdlc/alphas.md"
  [ "$status" -eq 0 ]
}

@test "B0.2: alphas.md НЕ содержит plugin-internal references" {
  run_bootstrap
  run grep -E "migrate-essence-to-state-rag|npx |mcp://" "$TMP_DIR/.claude/sdlc/alphas.md"
  [ "$status" -ne 0 ]
}

@test "B0.3: .gitignore содержит .sdlc-db/" {
  run_bootstrap
  run grep -E "^\.sdlc-db/$" "$TMP_DIR/.gitignore"
  [ "$status" -eq 0 ]
}

@test "B0.3: .gitignore содержит .sdlc-worker/" {
  run_bootstrap
  run grep -E "^\.sdlc-worker/" "$TMP_DIR/.gitignore"
  [ "$status" -eq 0 ]
}

@test "B0.3: .gitignore содержит autonomy.session.md" {
  run_bootstrap
  run grep -F ".claude/sdlc/autonomy.session.md" "$TMP_DIR/.gitignore"
  [ "$status" -eq 0 ]
}

@test "B0.3: .gitignore содержит external-systems local override" {
  run_bootstrap
  run grep -F ".claude/sdlc/external-systems/" "$TMP_DIR/.gitignore"
  [ "$status" -eq 0 ]
}
