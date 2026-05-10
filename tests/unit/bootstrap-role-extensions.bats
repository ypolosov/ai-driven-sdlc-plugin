#!/usr/bin/env bats

setup() {
  ROOT="$(git rev-parse --show-toplevel)"
  SCRIPT="$ROOT/scripts/bootstrap-target.sh"
  TMP_DIR="$(mktemp -d)"
  TARGET_DIR="$TMP_DIR/target"
  mkdir -p "$TARGET_DIR"
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "bootstrap creates role-extensions.md in .claude/sdlc/" {
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  [ -f "$TARGET_DIR/.claude/sdlc/role-extensions.md" ]
}

@test "role-extensions.md has correct frontmatter type" {
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  grep -q '^type: target-role-mapping' "$TARGET_DIR/.claude/sdlc/role-extensions.md"
}

@test "role-extensions.md has frontmatter with name and project" {
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  grep -q '^name: role-extensions' "$TARGET_DIR/.claude/sdlc/role-extensions.md"
  grep -q "^project: $(basename "$TARGET_DIR")" "$TARGET_DIR/.claude/sdlc/role-extensions.md"
}

@test "existing role-extensions.md not overwritten in fail-if-exists mode" {
  mkdir -p "$TARGET_DIR/.claude/sdlc"
  echo "preserved" >"$TARGET_DIR/.claude/sdlc/role-extensions.md"
  rm -rf "$TARGET_DIR/.claude/sdlc"
  mkdir -p "$TARGET_DIR/.claude/sdlc"
  echo "preserved-content" >"$TARGET_DIR/.claude/sdlc/role-extensions.md"
  run bash "$SCRIPT" "$TARGET_DIR" merge
  [ "$status" -eq 0 ]
  grep -q 'preserved-content' "$TARGET_DIR/.claude/sdlc/role-extensions.md"
}
