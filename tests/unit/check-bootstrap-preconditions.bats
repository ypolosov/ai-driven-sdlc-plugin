#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/check-bootstrap-preconditions.sh"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "B0.5: скрипт существует и исполняем" {
  [ -x "$SCRIPT" ]
}

@test "B0.5: без аргумента — usage exit 2" {
  run bash "$SCRIPT"
  [ "$status" -eq 2 ]
}

@test "B0.5: чистый git-репо без .env — OK exit 0" {
  git -C "$TMP_DIR" init -q
  run bash "$SCRIPT" "$TMP_DIR"
  [ "$status" -eq 0 ]
}

@test "B0.5: .env уже в git tracking — блокирует (exit 1)" {
  git -C "$TMP_DIR" init -q
  git -C "$TMP_DIR" config user.email t@t.t
  git -C "$TMP_DIR" config user.name t
  printf 'SECRET=x\n' >"$TMP_DIR/.env"
  git -C "$TMP_DIR" add -f .env
  git -C "$TMP_DIR" commit -qm init
  run bash "$SCRIPT" "$TMP_DIR"
  [ "$status" -eq 1 ]
  [[ "$output" == *".env"* ]]
}

@test "B0.5: не git-репо — предупреждение, не блокер" {
  run bash "$SCRIPT" "$TMP_DIR"
  [[ "$output" == *"git"* ]]
}

@test "B0.5: существующий .mcp.json — info про backup" {
  git -C "$TMP_DIR" init -q
  printf '{"mcpServers":{}}\n' >"$TMP_DIR/.mcp.json"
  run bash "$SCRIPT" "$TMP_DIR"
  [[ "$output" == *".mcp.json"* ]]
}

@test "B0.5: существующий .claude/sdlc — info про режим merge/force" {
  git -C "$TMP_DIR" init -q
  mkdir -p "$TMP_DIR/.claude/sdlc"
  run bash "$SCRIPT" "$TMP_DIR"
  [[ "$output" == *".claude/sdlc"* ]]
}
