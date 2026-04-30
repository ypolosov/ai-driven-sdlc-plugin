#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"
tool_name="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("tool_name",""))')"
file_path="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("file_path",""))')"
cwd="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("cwd",""))')"

case "$tool_name" in
  Write | Edit) ;;
  *) exit 0 ;;
esac

case "$file_path" in
  */.claude/sdlc/alphas.md) ;;
  *) exit 0 ;;
esac

cmd="${ESSENCE_ALPHA_VALIDATE_CMD:-npx -y @ypolosov/essence-alpha-mcp validate}"
log_file="$(mktemp)"
trap 'rm -f "$log_file"' EXIT

if ! ESSENCE_ALPHA_DB="${cwd}/.claude/sdlc/essence-alpha.db" $cmd >"$log_file" 2>&1; then
  printf 'check-alpha-consistency: state machine не консистентна:\n' >&2
  cat "$log_file" >&2
  exit 2
fi

exit 0
