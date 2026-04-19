#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/enforce-no-comments.sh"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_DIR"
}

payload() {
  local tool="$1" path="$2" cwd="$3"
  printf '{"tool_name":"%s","tool_input":{"file_path":"%s"},"cwd":"%s"}' "$tool" "$path" "$cwd"
}

@test "non-Write/Edit tool is skipped" {
  run bash -c "printf '%s' '$(payload Read "$TMP_DIR/f.py" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "markdown file is exempt" {
  printf '# heading\n' > "$TMP_DIR/doc.md"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/doc.md" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "yaml file is exempt" {
  printf 'key: value\n' > "$TMP_DIR/conf.yaml"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/conf.yaml" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "shebang line is whitelisted" {
  printf '#!/usr/bin/env bash\nx=1\n' > "$TMP_DIR/clean.sh"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/clean.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "comment in code is flagged" {
  printf '#!/usr/bin/env bash\n# comment here\nx=1\n' > "$TMP_DIR/dirty.sh"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/dirty.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -ne 0 ]
}

@test "non-existent file is skipped" {
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/missing.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}
