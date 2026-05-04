#!/usr/bin/env bash
set -euo pipefail

target_dir="${1:-}"
if [ -z "$target_dir" ]; then
  echo "check-tool-binding: usage: $0 <target-dir>" >&2
  exit 2
fi

bindings_file="$target_dir/.claude/sdlc/tool-bindings.md"
if [ ! -f "$bindings_file" ]; then
  echo "check-tool-binding: tool-bindings.md not found at $bindings_file" >&2
  exit 1
fi

plugin_root="$(cd "$(dirname "$0")"/.. && pwd)"
catalog="$plugin_root/catalogs/tool-categories.md"
if [ ! -f "$catalog" ]; then
  echo "check-tool-binding: catalog not found at $catalog" >&2
  exit 2
fi

valid_ids="$(grep -oE '^### [a-z][a-z0-9-]+' "$catalog" | awk '{print $2}' | sort -u)"

errors=0

mapfile -t binding_lines < <(grep -nE '^[[:space:]]*-[[:space:]]+(category|mcp_server):' "$bindings_file" || true)

seen_category=0
for line in "${binding_lines[@]}"; do
  content="${line#*:}"
  content="$(echo "$content" | sed -E 's/^[[:space:]]*-?[[:space:]]*//')"
  case "$content" in
    category:*)
      cat_value="$(echo "$content" | sed -E 's/^category:[[:space:]]*//')"
      if ! echo "$valid_ids" | grep -qx "$cat_value"; then
        echo "check-tool-binding: неизвестная категория '$cat_value'" >&2
        errors=$((errors + 1))
      fi
      seen_category=1
      ;;
    mcp_server:*)
      if [ "$seen_category" -eq 0 ]; then
        echo "check-tool-binding: mcp_server без category: $line" >&2
        errors=$((errors + 1))
      fi
      seen_category=0
      ;;
  esac
done

if ! grep -qE '^[[:space:]]*-[[:space:]]+category:' "$bindings_file"; then
  echo "check-tool-binding: ни одной записи с category в $bindings_file" >&2
  errors=$((errors + 1))
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "check-tool-binding: OK"
exit 0
