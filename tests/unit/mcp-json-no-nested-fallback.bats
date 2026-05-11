#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  MCP_JSON="$REPO_ROOT/.mcp.json"
}

@test ".mcp.json exists" {
  [ -f "$MCP_JSON" ]
}

@test ".mcp.json is valid JSON" {
  run python3 -c "import json,sys;json.load(open('$MCP_JSON'))"
  [ "$status" -eq 0 ]
}

@test ".mcp.json does not contain nested CLAUDE_PLUGIN_ROOT fallback (regression v0.11.1)" {
  run grep -F "CLAUDE_PLUGIN_ROOT:-" "$MCP_JSON"
  [ "$status" -ne 0 ]
}

@test ".mcp.json does not use \${CLAUDE_PLUGIN_ROOT} (regression v0.11.2: Claude Code не expands в command field)" {
  run grep -F 'CLAUDE_PLUGIN_ROOT' "$MCP_JSON"
  [ "$status" -ne 0 ]
}

@test ".mcp.json sdlc-state-rag uses npx command (v0.11.3 real fix)" {
  run python3 -c "
import json
d = json.load(open('$MCP_JSON'))
entry = d['mcpServers']['sdlc-state-rag']
assert entry['command'] == 'npx', f'expected command=npx, got: {entry[\"command\"]}'
args = entry['args']
joined = ' '.join(args)
assert '@ypolosov/sdlc-state-rag' in joined, f'expected package in args, got: {joined}'
"
  [ "$status" -eq 0 ]
}
