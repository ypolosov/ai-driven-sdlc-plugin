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

@test ".mcp.json sdlc-state-rag command uses bare CLAUDE_PLUGIN_ROOT" {
  run python3 -c "
import json
d = json.load(open('$MCP_JSON'))
cmd = d['mcpServers']['sdlc-state-rag']['command']
assert '\${CLAUDE_PLUGIN_ROOT}' in cmd, f'expected bare CLAUDE_PLUGIN_ROOT in command, got: {cmd}'
assert ':-' not in cmd, f'nested fallback :- detected in command: {cmd}'
"
  [ "$status" -eq 0 ]
}

@test ".mcp.json sdlc-state-rag command points to launch script" {
  run python3 -c "
import json
d = json.load(open('$MCP_JSON'))
cmd = d['mcpServers']['sdlc-state-rag']['command']
assert cmd.endswith('scripts/launch-sdlc-state-rag.sh'), f'expected launch script path, got: {cmd}'
"
  [ "$status" -eq 0 ]
}
