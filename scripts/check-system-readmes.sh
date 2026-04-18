#!/usr/bin/env bash
set -euo pipefail

target="${1:-$PWD}"
sdlc_dir="${target}/.claude/sdlc"
context="${sdlc_dir}/system-context.md"

if [ ! -f "$context" ]; then
  exit 0
fi

errors=0

python3 - "$target" "$context" <<'PY'
import os
import re
import sys
from datetime import date, datetime

target = sys.argv[1]
context_path = sys.argv[2]

with open(context_path, encoding="utf-8") as f:
    text = f.read()

table_rows = []
in_table = False
for line in text.splitlines():
    if re.match(r"\s*\|\s*slug\s*\|", line):
        in_table = True
        continue
    if in_table:
        if re.match(r"\s*\|[-\s|]+\|", line):
            continue
        if not line.strip().startswith("|"):
            in_table = False
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) >= 3 and cells[0] and cells[0] != "slug":
            table_rows.append(cells)

errors = 0
for row in table_rows:
    slug = row[0]
    role = row[1] if len(row) > 1 else ""
    kind = row[2] if len(row) > 2 else ""
    if not slug:
        continue
    if kind not in ("materialized", "logical"):
        print(f"check-system-readmes: неизвестный kind для {slug}: {kind}", file=sys.stderr)
        errors += 1
        continue
    if kind == "materialized":
        path_hint = os.path.join(target, "paths-of-materialized-systems-are-recorded-in-context")
        candidates = [
            os.path.join(target, slug, "README.sdlc.md"),
            os.path.join(target, "packages", slug, "README.sdlc.md"),
            os.path.join(target, "services", slug, "README.sdlc.md"),
            os.path.join(target, "README.sdlc.md") if slug in ("root", "target") else None,
        ]
        candidates = [c for c in candidates if c]
        if not any(os.path.exists(c) for c in candidates):
            print(f"check-system-readmes: для materialized {slug} не найден README.sdlc.md", file=sys.stderr)
            errors += 1
    else:
        logical_path = os.path.join(target, ".claude/sdlc/external-systems", slug + ".md")
        if not os.path.exists(logical_path):
            print(f"check-system-readmes: для logical {slug} не найден {logical_path}", file=sys.stderr)
            errors += 1

if errors > 0:
    print(f"check-system-readmes: {errors} расхождений.", file=sys.stderr)
    sys.exit(2)
PY

exit 0
