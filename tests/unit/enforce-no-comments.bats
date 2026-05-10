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

@test "TypeScript file with @ts-ignore is whitelisted (Wave 5)" {
  printf 'const x = 1;\n// @ts-ignore\nexport { x };\n' > "$TMP_DIR/file.ts"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/file.ts" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "TypeScript file with eslint-disable is whitelisted (Wave 5)" {
  printf 'const x = 1;\n// eslint-disable-next-line no-unused-vars\nexport { x };\n' > "$TMP_DIR/file.ts"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/file.ts" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "TypeScript file with regular comment is still flagged (Wave 5)" {
  printf 'const x = 1;\n// just a comment\nexport { x };\n' > "$TMP_DIR/file.ts"
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/file.ts" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -ne 0 ]
}

@test "heredoc with markdown headers does not trigger (Gap-2 fix)" {
  cat >"$TMP_DIR/with-heredoc.sh" <<'OUTER'
#!/usr/bin/env bash
cat >"$1" <<'EOF'
# Markdown Header
## Section
EOF
OUTER
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/with-heredoc.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "heredoc with bash-style hash comments inside is not flagged (Gap-2 fix)" {
  cat >"$TMP_DIR/heredoc-hash.sh" <<'OUTER'
#!/usr/bin/env bash
cat >"$1" <<EOF
# This is content of generated file
.env
.env.local
EOF
OUTER
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/heredoc-hash.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}

@test "comment OUTSIDE heredoc is still flagged (Gap-2 fix)" {
  cat >"$TMP_DIR/mixed.sh" <<'OUTER'
#!/usr/bin/env bash
# this is a real bash comment
cat >"$1" <<'EOF'
# This is heredoc content
EOF
OUTER
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/mixed.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -ne 0 ]
}

@test "multiple heredocs all ignored (Gap-2 fix)" {
  cat >"$TMP_DIR/multi.sh" <<'OUTER'
#!/usr/bin/env bash
cat >"$1" <<EOF
# First heredoc content
EOF
cat >"$2" <<EOF
# Second heredoc content
EOF
OUTER
  run bash -c "printf '%s' '$(payload Write "$TMP_DIR/multi.sh" "$TMP_DIR")' | '$SCRIPT'"
  [ "$status" -eq 0 ]
}
