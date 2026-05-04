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
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

@test "check-tool-binding rejects unknown category id" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-05
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
  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-05
---

bindings:
  - category: issue-tracker
    mcp_server: any-mcp
EOF

  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}

@test "check-tool-binding accepts all 7 valid categories" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-05
---

bindings:
  - category: issue-tracker
    mcp_server: any-mcp
  - category: knowledge-base
    mcp_server: any-mcp
  - category: vcs
    mcp_server: any-mcp
  - category: chat
    mcp_server: any-mcp
  - category: observability
    mcp_server: any-mcp
  - category: cd-platform
    mcp_server: any-mcp
  - category: test-management
    mcp_server: any-mcp
EOF

  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}

@test "check-tool-binding rejects when file missing" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
}

@test "check-tool-binding rejects when category line is malformed" {
  SCRIPT="$PLUGIN_ROOT/scripts/check-tool-binding.sh"
  cat >"$TMPDIR_TARGET/.claude/sdlc/tool-bindings.md" <<'EOF'
---
name: tool-bindings
type: tool-binding-registry
version: 1
updated: 2026-05-05
---

bindings:
  - mcp_server: any-mcp
EOF

  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
}
