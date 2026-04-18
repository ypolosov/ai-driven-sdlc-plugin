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

case "$file_path" in
  *.md|*.yml|*.yaml|*.json|*/.gitignore|*/.env.example|*/.env) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0

config="${cwd}/.claude/sdlc/plugin-config.md"
whitelist=()
whitelist+=('^\s*#!')
whitelist+=('^\s*// SPDX')
whitelist+=('^\s*/\*\* @')
whitelist+=('^\s*# type: ignore')
whitelist+=('^\s*//go:build')
whitelist+=('^\s*# pylint: disable')
whitelist+=('^\s*/// <reference')

if [ -f "$config" ]; then
  while IFS= read -r pat; do
    pat_clean="$(printf '%s' "$pat" | sed -E "s/^\s*-\s*'//; s/'\s*$//")"
    [ -z "$pat_clean" ] && continue
    whitelist+=("$pat_clean")
  done < <(awk '/^no_comments_whitelist:/{flag=1;next} flag&&/^[^[:space:]-]/{flag=0} flag' "$config" | grep -E "^\s*-")
fi

violations=0
while IFS= read -r line_raw; do
  ln=${line_raw%%:*}
  rest=${line_raw#*:}

  if [[ "$rest" =~ ^[[:space:]]*$ ]]; then continue; fi

  allowed=0
  for pat in "${whitelist[@]}"; do
    if [[ "$rest" =~ $pat ]]; then
      allowed=1
      break
    fi
  done
  [ "$allowed" = "1" ] && continue

  if [[ "$rest" =~ ^[[:space:]]*// ]] || [[ "$rest" =~ ^[[:space:]]*# ]] || [[ "$rest" =~ ^[[:space:]]*/\* ]] || [[ "$rest" =~ ^[[:space:]]*\*/ ]]; then
    printf 'no-comments: %s:%s содержит комментарий.\n' "$file_path" "$ln" >&2
    violations=$((violations+1))
  fi
done < <(grep -nE '^\s*(//|#|/\*|\*/)' "$file_path" || true)

if [ "$violations" -gt 0 ]; then
  printf 'Принцип 4a: код без комментариев. Уберите %s комментариев.\n' "$violations" >&2
  exit 2
fi

exit 0
