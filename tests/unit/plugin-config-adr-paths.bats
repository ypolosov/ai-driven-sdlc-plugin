#!/usr/bin/env bats

setup() {
  ROOT="$(git rev-parse --show-toplevel)"
  SCRIPT="$ROOT/scripts/check-adr-paths.sh"
  TMP_DIR="$(mktemp -d)"
  TARGET_DIR="$TMP_DIR/target"
  mkdir -p "$TARGET_DIR/.claude/sdlc"
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "script exists and is executable" {
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

@test "missing adr_paths field: uses default phases/architecture/adr/, exit 0" {
  cat >"$TARGET_DIR/.claude/sdlc/plugin-config.md" <<'EOF'
---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-05-10
---

state_artifact:
  kind: file
  ref: TODO.md
EOF
  mkdir -p "$TARGET_DIR/phases/architecture/adr"
  run "$SCRIPT" "$TARGET_DIR"
  [ "$status" -eq 0 ]
}

@test "adr_paths block-style array with valid paths: exit 0" {
  mkdir -p "$TARGET_DIR/docs/adrs"
  mkdir -p "$TARGET_DIR/devops/configuration/decisions"
  cat >"$TARGET_DIR/.claude/sdlc/plugin-config.md" <<'EOF'
---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-05-10
---

adr_paths:
  - docs/adrs/
  - devops/configuration/decisions/
EOF
  run "$SCRIPT" "$TARGET_DIR"
  [ "$status" -eq 0 ]
}

@test "adr_paths flow-style with valid path: exit 0" {
  mkdir -p "$TARGET_DIR/docs/adrs"
  cat >"$TARGET_DIR/.claude/sdlc/plugin-config.md" <<'EOF'
---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-05-10
---

adr_paths: [docs/adrs/]
EOF
  run "$SCRIPT" "$TARGET_DIR"
  [ "$status" -eq 0 ]
}

@test "adr_paths with non-existent path: exit 2" {
  cat >"$TARGET_DIR/.claude/sdlc/plugin-config.md" <<'EOF'
---
name: plugin-config
type: hooks-config
version: 1
updated: 2026-05-10
---

adr_paths:
  - missing/path/
EOF
  run "$SCRIPT" "$TARGET_DIR"
  [ "$status" -eq 2 ]
  [[ "$output" == *"missing/path"* ]]
}
