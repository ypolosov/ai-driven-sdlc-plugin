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

@test "B1.2: bootstrap создаёт tool-bindings.md" {
  run_bootstrap
  [ -f "$TMP_DIR/.claude/sdlc/tool-bindings.md" ]
}

@test "B1.2: tool-bindings.md имеет type tool-binding-registry" {
  run_bootstrap
  run grep -E "^type: tool-binding-registry$" "$TMP_DIR/.claude/sdlc/tool-bindings.md"
  [ "$status" -eq 0 ]
}

@test "B1.2: tool-bindings.md содержит 7 категорий" {
  run_bootstrap
  for c in issue-tracker knowledge-base vcs chat observability cd-platform test-management; do
    grep -qF "$c" "$TMP_DIR/.claude/sdlc/tool-bindings.md"
  done
}

@test "B1.2: tool-bindings.md skeleton помечен verified: false" {
  run_bootstrap
  run grep -F "verified: false" "$TMP_DIR/.claude/sdlc/tool-bindings.md"
  [ "$status" -eq 0 ]
}

@test "B1.3: .env.example содержит SDLC_STATE_RAG_DSN placeholder" {
  run_bootstrap
  run grep -E "^SDLC_STATE_RAG_DSN=" "$TMP_DIR/.env.example"
  [ "$status" -eq 0 ]
}

@test "B1.3: .env.example не пустой комментарий (несколько ключей)" {
  run_bootstrap
  count="$(grep -cE '^[A-Z_]+=' "$TMP_DIR/.env.example" || true)"
  [ "$count" -ge 2 ]
}
