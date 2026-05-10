#!/usr/bin/env bats

setup() {
  ROOT="$(git rev-parse --show-toplevel)"
  SCRIPT="$ROOT/scripts/bootstrap-target.sh"
  TMP_DIR="$(mktemp -d)"
  TARGET_DIR="$TMP_DIR/target"
  mkdir -p "$TARGET_DIR"
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "greenfield: creates .mcp.json with sdlc-state-rag entry" {
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  [ -f "$TARGET_DIR/.mcp.json" ]
  python3 -c "
import json
d = json.load(open('$TARGET_DIR/.mcp.json'))
assert 'mcpServers' in d, 'mcpServers missing'
assert 'sdlc-state-rag' in d['mcpServers'], 'sdlc-state-rag missing'
entry = d['mcpServers']['sdlc-state-rag']
assert entry['command'] == 'bash', f'expected bash, got {entry[\"command\"]}'
assert 'launch-sdlc-state-rag.sh' in ' '.join(entry['args']), 'launcher missing'
"
}

@test "existing .mcp.json without sdlc-state-rag: adds entry, preserves others" {
  cat >"$TARGET_DIR/.mcp.json" <<'EOF'
{"mcpServers": {"github": {"command": "gh-mcp", "args": ["serve"]}}}
EOF
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  python3 -c "
import json
d = json.load(open('$TARGET_DIR/.mcp.json'))
assert 'github' in d['mcpServers'], 'github entry lost'
assert 'sdlc-state-rag' in d['mcpServers'], 'sdlc-state-rag not added'
assert d['mcpServers']['github']['command'] == 'gh-mcp', 'github command changed'
"
}

@test "existing .mcp.json with sdlc-state-rag overwrite=yes: replaces entry" {
  cat >"$TARGET_DIR/.mcp.json" <<'EOF'
{"mcpServers": {"sdlc-state-rag": {"command": "old-binary", "args": []}}}
EOF
  run env MCP_OVERWRITE_SDLC_RAG=yes bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  python3 -c "
import json
d = json.load(open('$TARGET_DIR/.mcp.json'))
entry = d['mcpServers']['sdlc-state-rag']
assert entry['command'] == 'bash', f'expected bash overwrite, got {entry[\"command\"]}'
"
}

@test "existing .mcp.json with sdlc-state-rag default (keep): preserves entry" {
  cat >"$TARGET_DIR/.mcp.json" <<'EOF'
{"mcpServers": {"sdlc-state-rag": {"command": "old-binary", "args": []}}}
EOF
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 0 ]
  python3 -c "
import json
d = json.load(open('$TARGET_DIR/.mcp.json'))
entry = d['mcpServers']['sdlc-state-rag']
assert entry['command'] == 'old-binary', f'expected preserved, got {entry[\"command\"]}'
"
}

@test "existing .mcp.json with invalid JSON: fails with exit 2" {
  echo "{ this is not valid json" >"$TARGET_DIR/.mcp.json"
  run bash "$SCRIPT" "$TARGET_DIR" fail-if-exists
  [ "$status" -eq 2 ]
  [[ "$output" == *"invalid"* ]] || [[ "$output" == *"некорректн"* ]] || [[ "$output" == *".mcp.json"* ]]
}
