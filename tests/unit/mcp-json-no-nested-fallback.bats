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

@test ".mcp.json sdlc-state-rag uses bash wrapper (Claude Code не expands \${CLAUDE_PLUGIN_ROOT} в command field, v0.11.2)" {
  run python3 -c "
import json
d = json.load(open('$MCP_JSON'))
entry = d['mcpServers']['sdlc-state-rag']
assert entry['command'] == 'bash', f'expected command=bash, got: {entry[\"command\"]}'
args = entry['args']
assert args[0] == '-c', f'expected first arg=-c, got: {args[0]}'
assert 'CLAUDE_PLUGIN_ROOT' in args[1], f'expected CLAUDE_PLUGIN_ROOT in bash script, got: {args[1]}'
assert ':-' not in args[1], f'nested fallback :- detected: {args[1]}'
"
  [ "$status" -eq 0 ]
}

@test ".mcp.json sdlc-state-rag args reference launch-sdlc-state-rag.sh" {
  run python3 -c "
import json
d = json.load(open('$MCP_JSON'))
args = d['mcpServers']['sdlc-state-rag']['args']
joined = ' '.join(args)
assert 'launch-sdlc-state-rag.sh' in joined, f'expected launch script in args, got: {joined}'
"
  [ "$status" -eq 0 ]
}
