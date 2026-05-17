#!/usr/bin/env bash
set -euo pipefail

target_dir="${1:-}"
if [ -z "$target_dir" ]; then
  echo "check-bootstrap-preconditions: usage: $0 <target-dir>" >&2
  exit 2
fi

if [ ! -d "$target_dir" ]; then
  echo "check-bootstrap-preconditions: каталог $target_dir не существует" >&2
  exit 2
fi

errors=0

if ! git -C "$target_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "check-bootstrap-preconditions: WARN: $target_dir не git-репо; рекомендуется git init до bootstrap"
else
  tracked_env="$(git -C "$target_dir" ls-files -- .env 2>/dev/null || true)"
  if [ -n "$tracked_env" ]; then
    echo "check-bootstrap-preconditions: BLOCK: .env уже в git tracking — утечка credentials; выполните git rm --cached .env" >&2
    errors=$((errors + 1))
  fi
fi

if [ -f "$target_dir/.mcp.json" ]; then
  echo "check-bootstrap-preconditions: INFO: существующий .mcp.json будет сохранён в .mcp.json.bak перед merge"
fi

if [ -d "$target_dir/.claude/sdlc" ]; then
  echo "check-bootstrap-preconditions: INFO: .claude/sdlc уже существует — выберите режим --merge или --force"
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "check-bootstrap-preconditions: OK"
exit 0
