#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/check-cross-refs.sh"
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
  run bash -c "printf '%s' '$(payload Read "$TMP_DIR/.claude/sdlc/x.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "path outside .claude/sdlc is skipped" {
  echo "body" > "$TMP_DIR/random.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/random.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "missing .claude/sdlc directory is skipped" {
  local other="$(mktemp -d)"
  run bash -c "printf '%s' '$(payload Write "$other/.claude/sdlc/x.md" "$other")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  rm -rf "$other"
}

@test "valid internal link passes" {
  printf 'target\n' > "$TMP_DIR/.claude/sdlc/target.md"
  printf '[link](./target.md)\n' > "$TMP_DIR/.claude/sdlc/source.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/source.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "broken internal link is detected" {
  printf '[link](./missing.md)\n' > "$TMP_DIR/.claude/sdlc/source.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/source.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -ne 0 ]
}

@test "external http link is ignored" {
  printf '[link](https://example.com/path)\n' > "$TMP_DIR/.claude/sdlc/source.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/source.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}
