#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [ -z "$file_path" ]; then
  exit 0
fi

if echo "$file_path" | grep -qE '(test|spec)\.(ts|py|js|go|rs)$'; then
  exit 0
fi

if echo "$file_path" | grep -qE '\.(ts|py|js|go|rs)$'; then
  dir=$(dirname "$file_path")
  base=$(basename "$file_path" | sed 's/\.[^.]*$//')
  ext="${file_path##*.}"

  for test_file in "${dir}/${base}.test.${ext}" "${dir}/${base}.spec.${ext}" "${dir}/__tests__/${base}.test.${ext}"; do
    if [ -f "$test_file" ]; then
      exit 0
    fi
  done

  echo "{\"decision\": \"deny\", \"reason\": \"TDD: напиши тест для $base перед реализацией.\"}" >&2
  exit 2
fi

exit 0
