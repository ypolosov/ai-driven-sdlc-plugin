#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/check-alpha-consistency.sh"
  TMP_DIR="$(mktemp -d)"
  mkdir -p "$TMP_DIR/.claude/sdlc"
}

teardown() {
  rm -rf "$TMP_DIR"
}

payload() {
  local tool="$1" path="$2" cwd="$3"
  printf '{"tool_name":"%s","tool_input":{"file_path":"%s"},"cwd":"%s"}' "$tool" "$path" "$cwd"
}

@test "non-Write/Edit tool is skipped" {
  run bash -c "printf '%s' '$(payload Read "$TMP_DIR/.claude/sdlc/alphas.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "path outside alphas.md is skipped" {
  echo "body" > "$TMP_DIR/.claude/sdlc/other.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/other.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "alphas.md outside .claude/sdlc is skipped" {
  echo "body" > "$TMP_DIR/alphas.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/alphas.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "alphas.md with mock validate ok=true passes (DSN set)" {
  echo "snapshot" > "$TMP_DIR/.claude/sdlc/alphas.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/alphas.md" "$TMP_DIR")' | SDLC_STATE_RAG_DSN='postgresql://test/db' SDLC_STATE_RAG_VALIDATE_CMD='true' '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "alphas.md with mock validate ok=false fails with exit 2 (DSN set)" {
  echo "snapshot" > "$TMP_DIR/.claude/sdlc/alphas.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/alphas.md" "$TMP_DIR")' | SDLC_STATE_RAG_DSN='postgresql://test/db' SDLC_STATE_RAG_VALIDATE_CMD='false' '$SCRIPT'"
  [ "$status" -eq 2 ]
}

@test "pet mode (pglite dir exists, no DSN) skips validation with exit 0" {
  echo "snapshot" > "$TMP_DIR/.claude/sdlc/alphas.md"
  mkdir -p "$TMP_DIR/.sdlc-db"
  run bash -c "unset SDLC_STATE_RAG_DSN; printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/alphas.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "no DSN and no pglite dir fails with exit 2 and helpful error" {
  echo "snapshot" > "$TMP_DIR/.claude/sdlc/alphas.md"
  run bash -c "unset SDLC_STATE_RAG_DSN; printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/alphas.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 2 ]
  [[ "$output" =~ SDLC_STATE_RAG_DSN ]] || [[ "$output" =~ pglite ]] || [[ "$output" =~ \.sdlc-db ]]
}

@test "DSN env var overrides pglite mode (mid/enterprise)" {
  echo "snapshot" > "$TMP_DIR/.claude/sdlc/alphas.md"
  mkdir -p "$TMP_DIR/.sdlc-db"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/alphas.md" "$TMP_DIR")' | SDLC_STATE_RAG_DSN='postgresql://test/db' SDLC_STATE_RAG_VALIDATE_CMD='true' '$SCRIPT'"
  [ "$status" -eq 0 ]
}

