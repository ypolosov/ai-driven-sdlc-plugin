#!/usr/bin/env bats

setup() {
  PLUGIN_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")"/../.. && pwd)"
  CATALOG="$PLUGIN_ROOT/catalogs/tool-categories.md"
  TMPDIR_TARGET="$(mktemp -d)"
  mkdir -p "$TMPDIR_TARGET/.claude/sdlc"
}

teardown() {
  rm -rf "$TMPDIR_TARGET"
}

@test "tool-categories catalog file exists" {
  [ -f "$CATALOG" ]
}

@test "tool-categories catalog declares 7 categories" {
  run grep -E '^### (issue-tracker|knowledge-base|vcs|chat|observability|cd-platform|test-management)$' "$CATALOG"
  [ "$status" -eq 0 ]
  [ "$(echo "$output" | wc -l)" -eq 7 ]
}

@test "tool-categories catalog has no concrete product names in body" {
  run grep -iE '\b(jira|confluence|bitbucket|slack|discord|grafana|argocd|jenkins|datadog|notion|linear)\b' "$CATALOG"
  [ "$status" -ne 0 ]
}

@test "check-tool-binding script exists and is executable" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  if [ -f "$SCRIPT" ]; then
    [ -x "$SCRIPT" ]
  else
    skip "check-tool-binding.sh not yet implemented (PR-C)"
  fi
}

@test "check-tool-binding rejects unknown category id" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  [ -f "$SCRIPT" ] || skip "check-tool-binding.sh not yet implemented (PR-C)"

  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-04
---

bindings:
  - category: nonexistent-category
    mcp_server: any-mcp
EOF

  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
}

@test "check-tool-binding accepts valid category id" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  [ -f "$SCRIPT" ] || skip "check-tool-binding.sh not yet implemented (PR-C)"

  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-04
---

bindings:
  - category: issue-tracker
    mcp_server: any-mcp
EOF

  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}
