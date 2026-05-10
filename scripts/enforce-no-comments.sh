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

plugin_root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
case "$file_path" in
  "$plugin_root"/*) exit 0 ;;
esac

case "$file_path" in
  *.md | *.yml | *.yaml | *.json | */.gitignore | */.env.example | */.env) exit 0 ;;
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
whitelist+=('^\s*// @ts-')
whitelist+=('^\s*// eslint-')
whitelist+=('^\s*/\* eslint-')
whitelist+=('^\s*// biome-ignore')
whitelist+=('^\s*# shellcheck')

if [ -f "$config" ]; then
  while IFS= read -r pat; do
    pat_clean="$(printf '%s' "$pat" | sed -E "s/^\s*-\s*'//; s/'\s*$//")"
    [ -z "$pat_clean" ] && continue
    whitelist+=("$pat_clean")
  done < <(awk '/^no_comments_whitelist:/{flag=1;next} flag&&/^[^[:space:]-]/{flag=0} flag' "$config" | grep -E "^\s*-")
fi

whitelist_joined="$(printf '%s\n' "${whitelist[@]}")"
SCAN_FILE="$file_path" SCAN_WHITELIST="$whitelist_joined" python3 - <<'PY'
import os
import re
import sys

file_path = os.environ['SCAN_FILE']
whitelist_raw = os.environ.get('SCAN_WHITELIST', '')
whitelist = [re.compile(p) for p in whitelist_raw.splitlines() if p.strip()]

with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
    lines = f.readlines()

heredoc_re = re.compile(r"<<-?\s*['\"]?([A-Za-z_][A-Za-z0-9_]*)['\"]?")
in_heredoc = False
delimiter = None
allow_indent = False

violations = []
for idx, line in enumerate(lines, start=1):
    if in_heredoc:
        stripped = line.rstrip('\n')
        check = stripped.lstrip() if allow_indent else stripped
        if check == delimiter:
            in_heredoc = False
            delimiter = None
            allow_indent = False
        continue
    m = heredoc_re.search(line)
    if m:
        delimiter = m.group(1)
        allow_indent = '<<-' in line[: m.start() + 3]
        in_heredoc = True
        continue
    if not re.match(r'^\s*(//|#|/\*|\*/)', line):
        continue
    if line.strip() == '':
        continue
    matched_white = False
    for pat in whitelist:
        if pat.search(line):
            matched_white = True
            break
    if matched_white:
        continue
    if re.match(r'^\s*//', line) or re.match(r'^\s*#', line) or re.match(r'^\s*/\*', line) or re.match(r'^\s*\*/\s*$', line):
        violations.append(idx)

for ln in violations:
    sys.stderr.write(f'no-comments: {file_path}:{ln} содержит комментарий.\n')

if violations:
    sys.stderr.write(f'Принцип 4a: код без комментариев. Уберите {len(violations)} комментариев.\n')
    sys.exit(2)
sys.exit(0)
PY
