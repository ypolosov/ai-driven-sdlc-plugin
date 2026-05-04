#!/usr/bin/env bats

setup() {
  PLUGIN_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")"/../.. && pwd)"
  SCRIPT="$PLUGIN_ROOT/scripts/detect-credentials.sh"
  TMPDIR_TARGET="$(mktemp -d)"
  mkdir -p "$TMPDIR_TARGET/.claude/sdlc"
}

teardown() {
  rm -rf "$TMPDIR_TARGET"
}

@test "detect-credentials script exists and is executable" {
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

@test "warns when .env missing in target" {
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
  echo "$output" | grep -qi 'env'
}

@test "warns when .env not in .gitignore" {
  : > "$TMPDIR_TARGET/.env"
  : > "$TMPDIR_TARGET/.gitignore"
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
  echo "$output" | grep -qi 'gitignore'
}

@test "passes when .env exists and is in .gitignore" {
  : > "$TMPDIR_TARGET/.env"
  echo ".env" > "$TMPDIR_TARGET/.gitignore"
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}

@test "detects required env keys mentioned in tool-bindings" {
  : > "$TMPDIR_TARGET/.env"
  echo ".env" > "$TMPDIR_TARGET/.gitignore"
  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-05
---

bindings:
  - category: issue-tracker
    mcp_server: any-mcp
    env_keys: [TRACKER_TOKEN]
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
  echo "$output" | grep -q 'TRACKER_TOKEN'
}

@test "passes when required env keys are set" {
  echo "TRACKER_TOKEN=xyz" > "$TMPDIR_TARGET/.env"
  echo ".env" > "$TMPDIR_TARGET/.gitignore"
  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-05
---

bindings:
  - category: issue-tracker
    mcp_server: any-mcp
    env_keys: [TRACKER_TOKEN]
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}
