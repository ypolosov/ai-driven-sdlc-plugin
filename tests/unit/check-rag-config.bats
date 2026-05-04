#!/usr/bin/env bats

setup() {
  PLUGIN_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")"/../.. && pwd)"
  SCRIPT="$PLUGIN_ROOT/scripts/check-rag-config.sh"
  TMPDIR_TARGET="$(mktemp -d)"
  mkdir -p "$TMPDIR_TARGET/.claude/sdlc"
}

teardown() {
  rm -rf "$TMPDIR_TARGET"
}

@test "script exists and is executable" {
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

@test "passes when rag-config.md missing (pet default)" {
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}

@test "fails on missing frontmatter" {
  echo "no frontmatter" > "$TMPDIR_TARGET/.claude/sdlc/rag-config.md"
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
}

@test "passes when enabled=false (no sources required)" {
  cat >"$TMPDIR_TARGET/.claude/sdlc/rag-config.md" <<'EOF'
---
name: rag-config
type: rag-configuration
version: 1
updated: 2026-05-05
---

enabled: false
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}

@test "fails when enabled=true without sources" {
  cat >"$TMPDIR_TARGET/.claude/sdlc/rag-config.md" <<'EOF'
---
name: rag-config
type: rag-configuration
version: 1
updated: 2026-05-05
---

enabled: true
embedder:
  level: mid
  name: openai-text-embedding-3-small
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
  echo "$output" | grep -qi 'sources'
}

@test "fails when enabled=true without embedder" {
  cat >"$TMPDIR_TARGET/.claude/sdlc/rag-config.md" <<'EOF'
---
name: rag-config
type: rag-configuration
version: 1
updated: 2026-05-05
---

enabled: true
sources:
  - kind: filesystem
    paths: [docs/]
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
  echo "$output" | grep -qi 'embedder'
}

@test "passes valid mid config" {
  cat >"$TMPDIR_TARGET/.claude/sdlc/rag-config.md" <<'EOF'
---
name: rag-config
type: rag-configuration
version: 1
updated: 2026-05-05
---

enabled: true

sources:
  - kind: filesystem
    paths: [.claude/sdlc/, docs/]

embedder:
  level: mid
  name: openai-text-embedding-3-small
  dimensions: 1536

ttl_days: 30
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -eq 0 ]
}

@test "fails when embedder name missing in matrix" {
  cat >"$TMPDIR_TARGET/.claude/sdlc/rag-config.md" <<'EOF'
---
name: rag-config
type: rag-configuration
version: 1
updated: 2026-05-05
---

enabled: true

sources:
  - kind: filesystem
    paths: [docs/]

embedder:
  level: mid
  name: nonexistent-embedder-xyz-12345
EOF
  run "$SCRIPT" "$TMPDIR_TARGET"
  [ "$status" -ne 0 ]
  echo "$output" | grep -qi 'embedder'
}
