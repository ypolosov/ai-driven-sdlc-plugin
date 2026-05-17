#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/bootstrap-target.sh"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_DIR"
}

run_bootstrap() {
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$SCRIPT" "$TMP_DIR" fail-if-exists >/dev/null 2>&1 || true
}

@test "B0.6/C3: существующий .mcp.json бэкапится перед записью" {
  printf '{"mcpServers":{"team-custom":{"command":"foo"}}}\n' >"$TMP_DIR/.mcp.json"
  run_bootstrap
  [ -f "$TMP_DIR/.mcp.json.bak" ]
}

@test "B0.6/C3: backup сохраняет оригинальное содержимое команды" {
  printf '{"mcpServers":{"team-custom":{"command":"foo"}}}\n' >"$TMP_DIR/.mcp.json"
  run_bootstrap
  run grep -F "team-custom" "$TMP_DIR/.mcp.json.bak"
  [ "$status" -eq 0 ]
}

@test "B0.6/C3: существующие mcpServers команды сохраняются после merge" {
  printf '{"mcpServers":{"team-custom":{"command":"foo"}}}\n' >"$TMP_DIR/.mcp.json"
  run_bootstrap
  run grep -F "team-custom" "$TMP_DIR/.mcp.json"
  [ "$status" -eq 0 ]
}

@test "B0.6/C3: sdlc-state-rag добавлен к существующим серверам" {
  printf '{"mcpServers":{"team-custom":{"command":"foo"}}}\n' >"$TMP_DIR/.mcp.json"
  run_bootstrap
  run grep -F "sdlc-state-rag" "$TMP_DIR/.mcp.json"
  [ "$status" -eq 0 ]
}

@test "B0.6/C3: greenfield (нет .mcp.json) не создаёт пустой .bak" {
  run_bootstrap
  [ ! -f "$TMP_DIR/.mcp.json.bak" ]
}
