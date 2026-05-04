#!/usr/bin/env bats

setup() {
  PLUGIN_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")"/../.. && pwd)"
  FIXTURE="$PLUGIN_ROOT/tests/fixture/mid-target"
  cat >"$FIXTURE/.env" <<'EOF'
TRACKER_TOKEN=mock-tracker-token
VCS_TOKEN=mock-vcs-token
CHAT_TOKEN=mock-chat-token
EOF
}

teardown() {
  rm -f "$FIXTURE/.env"
}

@test "mid-target fixture has plugin-config with tool_bindings.ref" {
  [ -f "$FIXTURE/.claude/sdlc/plugin-config.md" ]
  run grep -E '^\s*ref:\s*\.claude/sdlc/tool-bindings\.md' "$FIXTURE/.claude/sdlc/plugin-config.md"
  [ "$status" -eq 0 ]
}

@test "mid-target fixture has rag_ref.enabled=false" {
  run grep -E '^\s*enabled:\s*false' "$FIXTURE/.claude/sdlc/plugin-config.md"
  [ "$status" -eq 0 ]
}

@test "mid-target tool-bindings.md passes check-tool-binding.sh" {
  run "$PLUGIN_ROOT/scripts/check-tool-binding.sh" "$FIXTURE"
  [ "$status" -eq 0 ]
}

@test "mid-target .env passes detect-credentials.sh" {
  run "$PLUGIN_ROOT/scripts/detect-credentials.sh" "$FIXTURE"
  [ "$status" -eq 0 ]
}

@test "mid-target role-extensions has 3 records" {
  count=$(grep -cE '^- id:' "$FIXTURE/.claude/sdlc/role-extensions.md")
  [ "$count" -eq 3 ]
}

@test "mid-target role-extensions includes ai role" {
  run grep -E 'agent_kind:\s*ai' "$FIXTURE/.claude/sdlc/role-extensions.md"
  [ "$status" -eq 0 ]
}

@test "mid-target tool-bindings has 3 categories" {
  count=$(grep -cE '^\s*-\s+category:' "$FIXTURE/.claude/sdlc/tool-bindings.md")
  [ "$count" -eq 3 ]
}

@test "context-aggregator agent file exists" {
  [ -f "$PLUGIN_ROOT/agents/sdlc-context-aggregator.md" ]
}

@test "context-aggregator declares principle 19a invariant" {
  run grep -E '19a' "$PLUGIN_ROOT/agents/sdlc-context-aggregator.md"
  [ "$status" -eq 0 ]
}

@test "context-aggregator declares no-alpha-bypass invariant" {
  run grep -iE 'не читать.*alphas\.md|не открывать.*alphas\.md' "$PLUGIN_ROOT/agents/sdlc-context-aggregator.md"
  [ "$status" -eq 0 ]
}

@test "context-aggregator declares AskUserQuestion on conflict" {
  run grep -E 'AskUserQuestion' "$PLUGIN_ROOT/agents/sdlc-context-aggregator.md"
  [ "$status" -eq 0 ]
}

@test "context-aggregator returns provenance per fragment" {
  run grep -E 'provenance' "$PLUGIN_ROOT/agents/sdlc-context-aggregator.md"
  [ "$status" -eq 0 ]
}

@test "ADR-010 exists and references aggregator topology" {
  ADR="$PLUGIN_ROOT/.claude/sdlc/phases/architecture/adr/ADR-010-multi-agent-topology-aggregator-router.md"
  [ -f "$ADR" ]
  run grep -E 'aggregator' "$ADR"
  [ "$status" -eq 0 ]
}

@test "plugin-config.meta.md declares tool_bindings section" {
  run grep -E '^### tool_bindings' "$PLUGIN_ROOT/meta-templates/plugin-config.meta.md"
  [ "$status" -eq 0 ]
}

@test "plugin-config.meta.md declares rag_ref section" {
  run grep -E '^### rag_ref' "$PLUGIN_ROOT/meta-templates/plugin-config.meta.md"
  [ "$status" -eq 0 ]
}

@test "plugin-config.meta.md declares workers section" {
  run grep -E '^### workers' "$PLUGIN_ROOT/meta-templates/plugin-config.meta.md"
  [ "$status" -eq 0 ]
}

@test "CLAUDE.md declares principle 18" {
  run grep -E '^### 18\.' "$PLUGIN_ROOT/CLAUDE.md"
  [ "$status" -eq 0 ]
}

@test "CLAUDE.md declares principle 19" {
  run grep -E '^### 19\.' "$PLUGIN_ROOT/CLAUDE.md"
  [ "$status" -eq 0 ]
}

@test "CLAUDE.md declares principle 19a" {
  run grep -E '^### 19a\.' "$PLUGIN_ROOT/CLAUDE.md"
  [ "$status" -eq 0 ]
}

@test "memom.md has entries for principles 18, 19, 19a" {
  count=$(grep -cE 'principle: (18|19|19a)' "$PLUGIN_ROOT/memom.md")
  [ "$count" -ge 3 ]
}
