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

write_profile_with_active_phase() {
  local phase="$1"
  local set_at="${2:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
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
SME profile body.
EOF
}

write_profile_without_active_phase() {
  cat >"$TARGET_DIR/.claude/sdlc/profile.md" <<'EOF'
---
name: profile
type: sdlc-profile
project: test
created: 2026-04-19
updated: 2026-05-05
---
SME profile body.
EOF
}

payload() {
  local tool="$1" args="$2"
  printf '{"tool_name":"%s","tool_input":%s,"cwd":"%s"}' "$tool" "$args" "$TARGET_DIR"
}

@test "non-Bash/Edit tool (Read) is skipped" {
  run bash -c "printf '%s' '$(payload Read '{"file_path":"foo"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "SDLC_PHASE_ENFORCE=skip env var bypasses check" {
  run bash -c "SDLC_PHASE_ENFORCE=skip printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/src/foo.ts"}')' | SDLC_PHASE_ENFORCE=skip '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "ephemeral autonomy.session.md hootl bypasses check" {
  future=$(date -u -d '+1 hour' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v+1H +%Y-%m-%dT%H:%M:%SZ)
  cat >"$TARGET_DIR/.claude/sdlc/autonomy.session.md" <<EOF
---
mode: hootl
expires_at: $future
---
EOF
  run bash -c "printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/src/foo.ts"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "Edit on .claude/sdlc/** is whitelisted" {
  run bash -c "printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/.claude/sdlc/alphas.md"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "Edit on .gitignore is whitelisted" {
  run bash -c "printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/.gitignore"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "Edit on src/foo.ts without profile.md fails" {
  run bash -c "printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/src/foo.ts"}')' | '$SCRIPT'"
  [ "$status" -eq 2 ]
  [[ "$output" == *"sdlc-init"* ]]
}

@test "Edit on src/foo.ts without active_phase fails" {
  write_profile_without_active_phase
  run bash -c "printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/src/foo.ts"}')' | '$SCRIPT'"
  [ "$status" -eq 2 ]
  [[ "$output" == *"sdlc-phase"* ]]
}

@test "Edit on src/foo.ts with fresh active_phase passes" {
  write_profile_with_active_phase "development"
  run bash -c "printf '%s' '$(payload Edit '{"file_path":"'"$TARGET_DIR"'/src/foo.ts"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "Bash git status without active_phase passes (whitelist)" {
  run bash -c "printf '%s' '$(payload Bash '{"command":"git status"}')' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "Bash git commit without active_phase fails" {
  run bash -c "printf '%s' '$(payload Bash '{"command":"git commit -m \"x\""}')' | '$SCRIPT'"
  [ "$status" -eq 2 ]
  [[ "$output" == *"sdlc"* ]]
}
