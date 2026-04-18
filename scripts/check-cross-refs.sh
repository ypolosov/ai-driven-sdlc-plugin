#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"
tool_name="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("tool_name",""))')"
file_path="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("file_path",""))')"
cwd="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("cwd",""))')"

case "$tool_name" in
  Write|Edit) ;;
  *) exit 0 ;;
esac

sdlc_root="${cwd}/.claude/sdlc"
[ -d "$sdlc_root" ] || exit 0

case "$file_path" in
  */.claude/sdlc/*) ;;
  *) exit 0 ;;
esac

broken=0
while IFS= read -r ref_line; do
  f="${ref_line%%:*}"
  rest="${ref_line#*:}"
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    case "$ref" in
      http*|#*|mailto:*) continue ;;
    esac
    resolved="$(cd "$(dirname "$f")" 2>/dev/null && readlink -f -- "$ref" 2>/dev/null || true)"
    if [ -z "$resolved" ] || [ ! -e "$resolved" ]; then
      printf 'check-cross-refs: битая ссылка в %s: %s\n' "$f" "$ref" >&2
      broken=$((broken+1))
    fi
  done < <(printf '%s\n' "$rest" | grep -oE '\]\([^)]+\)' | sed -E 's/^\]\(([^)]+)\)$/\1/')
done < <(grep -rnE '\]\([^)]+\)' "$sdlc_root" 2>/dev/null || true)

if [ "$broken" -gt 0 ]; then
  printf 'Найдено %s осиротевших ссылок в .claude/sdlc/.\n' "$broken" >&2
  exit 2
fi

exit 0
