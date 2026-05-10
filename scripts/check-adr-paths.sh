#!/usr/bin/env bash
set -euo pipefail

target="${1:-$PWD}"
config="${target}/.claude/sdlc/plugin-config.md"

if [ ! -f "$config" ]; then
  exit 0
fi

result="$(
  TARGET_CONFIG="$config" python3 - <<'PY'
import os
import re
import sys

config_path = os.environ['TARGET_CONFIG']
with open(config_path, 'r', encoding='utf-8') as f:
    content = f.read()

flow = re.search(r'^adr_paths:\s*\[([^\]]*)\]', content, re.MULTILINE)
block = re.search(r'^adr_paths:\s*\n((?:[ \t]+-[ \t]*\S.*\n)+)', content, re.MULTILINE)

paths = []
if flow:
    raw = flow.group(1)
    paths = [p.strip().strip("'").strip('"') for p in raw.split(',') if p.strip()]
elif block:
    for line in block.group(1).split('\n'):
        m = re.match(r'\s*-\s*(.+)', line)
        if m:
            v = m.group(1).strip().strip("'").strip('"')
            if v:
                paths.append(v)

if not paths:
    print("DEFAULT")
else:
    print("|".join(paths))
PY
)"

if [ "$result" = "DEFAULT" ]; then
  paths=("phases/architecture/adr/")
else
  IFS='|' read -ra paths <<<"$result"
fi

errors=0
for p in "${paths[@]}"; do
  full_path="${target}/${p}"
  if [ ! -d "$full_path" ]; then
    printf 'check-adr-paths: путь не существует: %s\n' "$full_path" >&2
    errors=$((errors + 1))
  fi
done

if [ "$errors" -gt 0 ]; then
  printf 'Найдено %s несуществующих ADR-путей.\n' "$errors" >&2
  exit 2
fi

exit 0
