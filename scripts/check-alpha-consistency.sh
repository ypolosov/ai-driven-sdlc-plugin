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

cmd="${SDLC_STATE_RAG_VALIDATE_CMD:-sdlc-state-rag validate}"
log_file="$(mktemp)"
trap 'rm -f "$log_file"' EXIT

dsn="${SDLC_STATE_RAG_DSN:-postgresql://localhost/${cwd##*/}}"

if ! SDLC_STATE_RAG_DSN="$dsn" $cmd >"$log_file" 2>&1; then
  printf 'check-alpha-consistency: state machine не консистентна:\n' >&2
  cat "$log_file" >&2
  exit 2
fi

exit 0
