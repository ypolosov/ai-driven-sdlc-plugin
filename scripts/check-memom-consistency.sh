#!/usr/bin/env bash
set -euo pipefail

plugin_root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
claude_md="${plugin_root}/CLAUDE.md"
memom_md="${plugin_root}/memom.md"

if [ ! -f "$claude_md" ] || [ ! -f "$memom_md" ]; then
  exit 0
fi

if ! git -C "$plugin_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

staged="$(git -C "$plugin_root" diff --cached --name-only 2>/dev/null || true)"

claude_staged=0
memom_staged=0
case "$staged" in
  *CLAUDE.md*) claude_staged=1 ;;
esac
case "$staged" in
  *memom.md*) memom_staged=1 ;;
esac

if [ "$claude_staged" = "0" ]; then
  exit 0
fi

principle_diff="$(git -C "$plugin_root" diff --cached -- CLAUDE.md 2>/dev/null | grep -E '^[+-]### [0-9]+[a-z]?\.' || true)"

if [ -z "$principle_diff" ]; then
  exit 0
fi

if [ "$memom_staged" = "0" ]; then
  printf 'check-memom-consistency: CLAUDE.md меняет принципы, но memom.md не обновлён.\n' >&2
  printf 'Принцип 15: добавьте запись в memom.md в том же коммите.\n' >&2
  exit 2
fi

exit 0
