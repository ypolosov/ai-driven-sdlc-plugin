#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/check-rag-config.sh"
  META="$REPO_ROOT/meta-templates/rag-config.meta.md"
  TMP_DIR="$(mktemp -d)"
  mkdir -p "$TMP_DIR/.claude/sdlc"
}

teardown() {
  rm -rf "$TMP_DIR"
}

write_config() {
  cat >"$TMP_DIR/.claude/sdlc/rag-config.md"
}

@test "B4.4/C1: meta-template документирует поле data_classification" {
  run grep -E "^### data_classification$" "$META"
  [ "$status" -eq 0 ]
}

@test "B4.4/C1: meta-template документирует compliance_signoff gate" {
  run grep -F "compliance_signoff" "$META"
  [ "$status" -eq 0 ]
}

@test "B4.4/C1: regulated + enabled:true без compliance_signoff → ошибка" {
  write_config <<'EOF'
---
name: rag-config
type: rag-configuration
project: gt
version: 1
updated: 2026-05-17
---

enabled: true
data_classification: regulated

sources:
  - kind: mcp
    category: knowledge-base
    capability: page.search

embedder:
  level: enterprise
  name: openai-text-embedding-3-small
  dimensions: 1536

ttl_days: 30
EOF
  run bash "$SCRIPT" "$TMP_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"compliance"* ]]
}

@test "B4.4/C1: regulated + enabled:true + compliance_signoff → OK" {
  write_config <<'EOF'
---
name: rag-config
type: rag-configuration
project: gt
version: 1
updated: 2026-05-17
---

enabled: true
data_classification: regulated
compliance_signoff: DPA-2026-014

sources:
  - kind: mcp
    category: knowledge-base
    capability: page.search

embedder:
  level: enterprise
  name: openai-text-embedding-3-small
  dimensions: 1536

ttl_days: 30
EOF
  run bash "$SCRIPT" "$TMP_DIR"
  [ "$status" -eq 0 ]
}

@test "B4.4/C1: regulated + enabled:false → OK (gate не блокирует disabled)" {
  write_config <<'EOF'
---
name: rag-config
type: rag-configuration
project: gt
version: 1
updated: 2026-05-17
---

enabled: false
data_classification: regulated
EOF
  run bash "$SCRIPT" "$TMP_DIR"
  [ "$status" -eq 0 ]
}

@test "B4.4/C1: public data + enabled:true без signoff → OK (gate только для regulated)" {
  write_config <<'EOF'
---
name: rag-config
type: rag-configuration
project: my-target
version: 1
updated: 2026-05-17
---

enabled: true
data_classification: public

sources:
  - kind: filesystem
    paths: [.claude/sdlc/]
    glob: '**/*.md'

embedder:
  level: mid
  name: openai-text-embedding-3-small
  dimensions: 1536

ttl_days: 30
EOF
  run bash "$SCRIPT" "$TMP_DIR"
  [ "$status" -eq 0 ]
}
