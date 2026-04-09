#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [ -z "$file_path" ]; then
  exit 0
fi

project_dir="${CLAUDE_PROJECT_DIR:-.}"
missing=""

if [ ! -d "$project_dir/docs" ] && [ ! -f "$project_dir/README.md" ]; then
  missing="requirements"
fi

if echo "$file_path" | grep -qE '\.(ts|py|js|go|rs)$'; then
  if ! echo "$file_path" | grep -qE '(test|spec)'; then
    dir=$(dirname "$file_path")
    base=$(basename "$file_path" | sed 's/\.[^.]*$//')
    has_test=false
    for pattern in "${dir}/${base}.test."* "${dir}/${base}.spec."* "${dir}/__tests__/${base}."*; do
      if ls "$pattern" 2>/dev/null | head -1 > /dev/null 2>&1; then
        has_test=true
        break
      fi
    done
    if [ "$has_test" = false ]; then
      missing="${missing:+$missing, }test for $base"
    fi
  fi
fi

if [ -n "$missing" ]; then
  echo "{\"systemMessage\": \"Прослеживаемость: отсутствует $missing. Цепочка требование-тест-код неполна.\"}"
  exit 2
fi

exit 0
