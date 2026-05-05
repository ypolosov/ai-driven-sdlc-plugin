#!/usr/bin/env bats

setup() {
  PLUGIN_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")"/../.. && pwd)"
  CONTRACT="$PLUGIN_ROOT/meta-templates/sdlc-state-rag-contract.meta.md"
  ADR011="$PLUGIN_ROOT/.claude/sdlc/phases/architecture/adr/ADR-011-sdlc-state-rag-unified-backend.md"
  ADR009="$PLUGIN_ROOT/.claude/sdlc/phases/architecture/adr/ADR-009-essence-alpha-mcp-integration.md"
  MCP_JSON="$PLUGIN_ROOT/.mcp.json"
  TRACKER="$PLUGIN_ROOT/agents/sdlc-alpha-tracker.md"
}

@test "contract meta-template exists" {
  [ -f "$CONTRACT" ]
}

@test "contract declares 5 domains" {
  for d in "Alpha state machine" "RAG vectors" "Decisions journal" "Audit log" "Sync events"; do
    grep -q "$d" "$CONTRACT" || (echo "missing domain: $d"; false)
  done
}

@test "contract declares state_* tools" {
  for t in state_get_alpha state_advance_alpha state_regress_alpha state_list_transitions state_validate_consistency state_describe_alpha; do
    grep -q "$t" "$CONTRACT" || (echo "missing tool: $t"; false)
  done
}

@test "contract declares composite tools" {
  for t in state_advance_with_decision state_regress_with_audit rag_upsert_with_sync_event; do
    grep -q "$t" "$CONTRACT" || (echo "missing composite: $t"; false)
  done
}

@test "contract declares rag_* tools" {
  for t in rag_upsert_documents rag_query_chunks rag_purge_by_ttl rag_stats; do
    grep -q "$t" "$CONTRACT" || (echo "missing rag tool: $t"; false)
  done
}

@test "contract mentions SERIALIZABLE isolation" {
  grep -q 'SERIALIZABLE' "$CONTRACT"
}

@test "contract mentions per-target backend" {
  grep -qE 'per-target' "$CONTRACT"
}

@test "ADR-011 exists and is Accepted" {
  [ -f "$ADR011" ]
  run grep -E '^status: Accepted' "$ADR011"
  [ "$status" -eq 0 ]
}

@test "ADR-011 supersedes ADR-009" {
  run grep -E 'supersedes:.*ADR-009' "$ADR011"
  [ "$status" -eq 0 ]
}

@test "ADR-009 status is Deprecated" {
  run grep -E '^status: Deprecated' "$ADR009"
  [ "$status" -eq 0 ]
}

@test "ADR-009 has superseded_by ADR-011" {
  run grep -E 'superseded_by:.*ADR-011' "$ADR009"
  [ "$status" -eq 0 ]
}

@test ".mcp.json registers sdlc-state-rag" {
  run grep -E 'sdlc-state-rag' "$MCP_JSON"
  [ "$status" -eq 0 ]
}

@test ".mcp.json does NOT register essence-alpha" {
  run grep -E 'essence-alpha' "$MCP_JSON"
  [ "$status" -ne 0 ]
}

@test ".mcp.json uses SDLC_STATE_RAG_DSN" {
  run grep -E 'SDLC_STATE_RAG_DSN' "$MCP_JSON"
  [ "$status" -eq 0 ]
}

@test ".mcp.json uses direct binary not npx for sdlc-state-rag (v0.5.1 fix)" {
  command_value=$(python3 -c 'import json; d=json.load(open("'"$MCP_JSON"'")); print(d["mcpServers"]["sdlc-state-rag"]["command"])')
  [ "$command_value" = "sdlc-state-rag" ]
}

@test "alpha-tracker uses state_* MCP tools" {
  run grep -E 'mcp__sdlc_state_rag__state_' "$TRACKER"
  [ "$status" -eq 0 ]
}

@test "alpha-tracker does NOT reference essence_* tools" {
  run grep -E 'mcp__essence_alpha__essence_' "$TRACKER"
  [ "$status" -ne 0 ]
}

@test "CLAUDE.md declares principle 20" {
  run grep -E '^### 20\.' "$PLUGIN_ROOT/CLAUDE.md"
  [ "$status" -eq 0 ]
}

@test "CLAUDE.md declares principle 21" {
  run grep -E '^### 21\.' "$PLUGIN_ROOT/CLAUDE.md"
  [ "$status" -eq 0 ]
}

@test "memom.md has entries for principles 20 and 21" {
  count=$(grep -cE 'principle: (20|21)' "$PLUGIN_ROOT/memom.md")
  [ "$count" -ge 2 ]
}

@test "principle 13 in CLAUDE.md mentions sdlc-state-rag" {
  run grep -E 'sdlc-state-rag' "$PLUGIN_ROOT/CLAUDE.md"
  [ "$status" -eq 0 ]
}
