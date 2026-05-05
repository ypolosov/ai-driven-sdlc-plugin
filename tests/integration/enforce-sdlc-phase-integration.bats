#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/enforce-sdlc-phase.sh"
  TMP_DIR="$(mktemp -d)"
  TARGET_DIR="$TMP_DIR/target"
  mkdir -p "$TARGET_DIR/.claude/sdlc"
  unset SDLC_PHASE_ENFORCE
}

teardown() {
  rm -rf "$TMP_DIR"
}

write_profile() {
  local phase="$1" set_at="$2"
  cat >"$TARGET_DIR/.claude/sdlc/profile.md" <<EOF
---
name: profile
type: sdlc-profile
project: test
created: 2026-04-19
updated: 2026-05-05
active_phase: $phase
active_phase_set_at: $set_at
---
EOF
}

payload() {
  printf '{"tool_name":"%s","tool_input":%s,"cwd":"%s"}' "$1" "$2" "$TARGET_DIR"
}

@test "npm publish blocked without active_phase" {
  run bash -c "printf '%s' '$(payload Bash '{"command":"npm publish --access public"}')' | '$SCRIPT'"
  [ "$status" -eq 2 ]
}

@test "git push blocked without active_phase" {
  run bash -c "printf '%s' '$(payload Bash '{"command":"git push origin main"}')' | '$SCRIPT'"
  [ "$status" -eq 2 ]
}

@test "git push allowed after active_phase set" {
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  write_profile "deployment" "$now"
  run bash -c "printf '%s' '$(payload Bash '{"command":"git push origin main"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "active_phase TTL expired blocks again" {
  past=$(date -u -d '-2 days' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-2d +%Y-%m-%dT%H:%M:%SZ)
  write_profile "development" "$past"
  run bash -c "printf '%s' '$(payload Bash '{"command":"git commit -m \"x\""}')' | '$SCRIPT'"
  [ "$status" -eq 2 ]
  [[ "$output" == *"устарела"* ]]
}
