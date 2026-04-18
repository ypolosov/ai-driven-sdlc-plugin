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

config="${cwd}/.claude/sdlc/plugin-config.md"
[ -f "$config" ] || exit 0

scope_line="$(grep -E '^\s*include:' "$config" | head -1 || true)"
pairs_block="$(awk '/^tdd_pairs:/{flag=1;next} flag&&/^[^[:space:]-]/{flag=0} flag' "$config" || true)"

in_scope=0
while IFS= read -r pat; do
  pat_clean="$(printf '%s' "$pat" | sed -E 's/^\s*-?\s*//; s/\s*$//; s/,$//')"
  [ -z "$pat_clean" ] && continue
  case "$file_path" in
    *${pat_clean%%\**}*) in_scope=1 ;;
  esac
done < <(printf '%s' "$scope_line" | grep -oE '\[[^]]+\]' | tr -d '[]' | tr ',' '\n')

if [ "$in_scope" = "0" ]; then
  exit 0
fi

has_pair="false"
while IFS= read -r line; do
  source_rx="$(printf '%s' "$line" | grep -oE "source: '[^']+'" | sed -E "s/source: '([^']+)'/\1/")"
  test_tpl="$(printf '%s' "$line" | grep -oE "test:[[:space:]]+'[^']+'" | sed -E "s/test:[[:space:]]+'([^']+)'/\1/")"
  [ -z "$source_rx" ] && continue
  if [[ "$file_path" =~ $source_rx ]]; then
    test_path="$(printf '%s' "$file_path" | sed -E "s#${source_rx}#${test_tpl}#")"
    if [ -f "${cwd}/${test_path}" ] || [ -f "${test_path}" ]; then
      has_pair="true"
    fi
  fi
done < <(printf '%s\n' "$pairs_block" | grep -E "source:|test:")

if [ "$has_pair" = "true" ]; then
  exit 0
fi

printf 'TDD hook: для %s не найден парный тест.\n' "$file_path" >&2
printf 'Принцип 5: создайте тест перед кодом либо подтвердите запись.\n' >&2
exit 2
