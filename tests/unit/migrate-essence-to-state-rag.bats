#!/usr/bin/env bats

setup() {
  ROOT="$(git rev-parse --show-toplevel)"
  SCRIPT="$ROOT/scripts/migrate-essence-to-state-rag.sh"
  TMP_DIR="$(mktemp -d)"
  TARGET_DIR="$TMP_DIR/target"
  mkdir -p "$TARGET_DIR/.claude/sdlc"
  printf 'Альфы\n\n- **opportunity**: Identified\n- **work**: Started\n' \
    >"$TARGET_DIR/.claude/sdlc/alphas.md"
  export SDLC_TARGET_ROOT="$TARGET_DIR"
  export PATH="$TMP_DIR/bin:$PATH"
  mkdir -p "$TMP_DIR/bin"
  cat >"$TMP_DIR/bin/npx" <<'EOF'
#!/usr/bin/env bash
echo "npx-mock invoked: $*"
exit 0
EOF
  chmod +x "$TMP_DIR/bin/npx"
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "script exists and is executable" {
  [ -x "$SCRIPT" ]
}

@test "fails on missing source" {
  run env SDLC_TARGET_ROOT="$TMP_DIR/empty" bash "$SCRIPT" --source "$TMP_DIR/missing.md"
  [ "$status" -eq 2 ]
}

@test "dry-run mode invokes npx without backup" {
  run bash "$SCRIPT" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"--dry-run"* ]]
}

@test "exec mode creates backup before invoking npx" {
  run bash "$SCRIPT" --exec
  [ "$status" -eq 0 ]
  [ -f "$TARGET_DIR/.claude/sdlc/alphas.md.backup-$(date +%Y-%m-%d)" ]
  [[ "$output" == *"--source"* ]]
}

@test "exec mode is idempotent on backup" {
  bash "$SCRIPT" --exec >/dev/null
  run bash "$SCRIPT" --exec
  [ "$status" -eq 0 ]
  [[ "$output" == *"already exists"* ]]
}

@test "verify mode invokes npx without backup write" {
  run bash "$SCRIPT" --verify
  [ "$status" -eq 0 ]
  [[ "$output" == *"--verify"* ]]
  [ ! -f "$TARGET_DIR/.claude/sdlc/alphas.md.backup-$(date +%Y-%m-%d)" ]
}

@test "help flag prints usage" {
  run bash "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Использование"* ]]
}
