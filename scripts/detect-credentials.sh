#!/usr/bin/env bash
set -euo pipefail

target_dir="${1:-}"
if [ -z "$target_dir" ]; then
  echo "detect-credentials: usage: $0 <target-dir>" >&2
  exit 2
fi

errors=0

env_file="$target_dir/.env"
gitignore_file="$target_dir/.gitignore"

if [ ! -f "$env_file" ]; then
  echo "detect-credentials: .env отсутствует в $target_dir" >&2
  errors=$((errors + 1))
fi

if [ -f "$env_file" ] && [ -f "$gitignore_file" ]; then
  if ! grep -qE '^(\.env|/\.env)\s*$' "$gitignore_file"; then
    echo "detect-credentials: .env не указан в .gitignore" >&2
    errors=$((errors + 1))
  fi
fi

if [ -f "$env_file" ] && [ ! -f "$gitignore_file" ]; then
  echo "detect-credentials: .gitignore отсутствует" >&2
  errors=$((errors + 1))
fi

bindings_file="$target_dir/.claude/sdlc/tool-bindings.md"
if [ -f "$bindings_file" ] && [ -f "$env_file" ]; then
  required_keys="$(grep -oE 'env_keys:[[:space:]]*\[[^]]+\]' "$bindings_file" |
    sed -E 's/env_keys:[[:space:]]*\[//; s/\][[:space:]]*$//; s/[[:space:]]//g; s/,/\n/g' |
    sort -u | grep -v '^$' || true)"

  for key in $required_keys; do
    if ! grep -qE "^${key}=" "$env_file"; then
      echo "detect-credentials: отсутствует ключ $key в .env" >&2
      errors=$((errors + 1))
    fi
  done
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "detect-credentials: OK"
exit 0
