#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/validate-artifact.sh"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_DIR"
}

payload() {
  local tool="$1" path="$2"
  printf '{"tool_name":"%s","tool_input":{"file_path":"%s"}}' "$tool" "$path"
}

@test "non-Write/Edit tool is skipped" {
  run bash -c "printf '%s' '$(payload Read /tmp/any.md)' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "path outside .claude/sdlc is skipped" {
  echo "plain content" > "$TMP_DIR/random.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/random.md")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "audit.md in .claude/sdlc is skipped" {
  mkdir -p "$TMP_DIR/.claude/sdlc"
  echo "no frontmatter" > "$TMP_DIR/.claude/sdlc/audit.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/audit.md")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "non-existent file is skipped" {
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/missing.md")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "valid artifact with frontmatter passes" {
  mkdir -p "$TMP_DIR/.claude/sdlc"
  {
    printf -- '---\n'
    printf 'name: sample\n'
    printf 'type: test\n'
    printf -- '---\n\n'
    printf 'Короткое утверждение до пятнадцати слов в одном предложении.\n'
  } > "$TMP_DIR/.claude/sdlc/sample.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/sample.md")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "missing frontmatter is flagged" {
  mkdir -p "$TMP_DIR/.claude/sdlc"
  echo "no yaml here just body" > "$TMP_DIR/.claude/sdlc/broken.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/.claude/sdlc/broken.md")' | '$SCRIPT'"
  [ "$status" -ne 0 ]
  [[ "$output" == *"frontmatter"* ]] || [[ "$stderr" == *"frontmatter"* ]] || [ -n "$output$stderr" ]
}
