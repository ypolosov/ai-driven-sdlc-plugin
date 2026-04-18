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

case "$file_path" in
  *.md|*.yml|*.yaml|*.json|*/.gitignore|*/.env.example) exit 0 ;;
esac

config="${cwd}/.claude/sdlc/plugin-config.md"
if [ ! -f "$config" ]; then
  exit 0
fi

development_done="$(grep -E '^\|\s*development\s*\|' "${cwd}/.claude/sdlc/profile.md" 2>/dev/null | grep -v 'development\s*|\s*—' || true)"

formatter_cmd="$(awk '/^formatter:/{flag=1;next} flag&&/^\s*command:/{gsub(/^\s*command:\s*/,""); print; exit}' "$config" 2>/dev/null || true)"
linter_cmd="$(awk '/^linter:/{flag=1;next} flag&&/^\s*command:/{gsub(/^\s*command:\s*/,""); print; exit}' "$config" 2>/dev/null || true)"

if [ -z "$formatter_cmd" ] && [ -z "$linter_cmd" ]; then
  if [ -n "$development_done" ]; then
    printf 'format/lint hook: фаза development пройдена, но форматер/линтер не настроены.\n' >&2
    printf 'Настройте formatter и linter в %s.\n' "$config" >&2
    exit 2
  fi
  exit 0
fi

if [ -n "$formatter_cmd" ]; then
  if ! (cd "$cwd" && eval "$formatter_cmd $file_path") >/dev/null 2>&1; then
    printf 'Форматер не проходит для %s. Запустите форматер и повторите.\n' "$file_path" >&2
    exit 2
  fi
fi

if [ -n "$linter_cmd" ]; then
  if ! (cd "$cwd" && eval "$linter_cmd $file_path") >/dev/null 2>&1; then
    printf 'Линтер не проходит для %s. Исправьте нарушения.\n' "$file_path" >&2
    exit 2
  fi
fi

exit 0
