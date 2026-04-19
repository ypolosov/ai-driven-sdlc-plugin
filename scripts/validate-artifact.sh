#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"
tool_name="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("tool_name",""))')"
file_path="$(printf '%s' "$payload" | python3 -c 'import sys,json;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("file_path",""))')"

case "$tool_name" in
  Write | Edit) ;;
  *) exit 0 ;;
esac

case "$file_path" in
  */.claude/sdlc/*) ;;
  *) exit 0 ;;
esac

case "$file_path" in
  */audit.md) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0

errors=()

frontmatter="$(awk 'BEGIN{inside=0} /^---[[:space:]]*$/{inside++; next} inside==1{print} inside==2{exit}' "$file_path")"
if [ -z "$frontmatter" ]; then
  errors+=("Отсутствует YAML frontmatter")
fi

python3 - "$file_path" <<'PY' || true
import re
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    text = f.read()

parts = text.split("---", 2)
body = parts[2] if len(parts) >= 3 else text

body = re.sub(r"```.*?```", "", body, flags=re.DOTALL)
body = re.sub(r"`[^`]*`", "", body)
body = "\n".join(
    line for line in body.splitlines() if not line.lstrip().startswith("|")
)

sentences = re.split(r"(?<=[\.!\?])\s+", body)
violations = []
for s in sentences:
    s_clean = s.strip()
    if not s_clean:
        continue
    if s_clean.startswith("#") or s_clean.startswith("-") or s_clean.startswith("*"):
        continue
    words = re.findall(r"\S+", s_clean)
    if len(words) > 15:
        violations.append((len(words), s_clean[:80]))

if violations:
    print("VIOLATIONS_15W", file=sys.stderr)
    for n, txt in violations[:5]:
        print(f"  {n} слов: {txt}", file=sys.stderr)
PY

if [ ${#errors[@]} -gt 0 ]; then
  printf 'validate-artifact: ошибки в %s\n' "$file_path" >&2
  for e in "${errors[@]}"; do
    printf '  %s\n' "$e" >&2
  done
  exit 2
fi

exit 0
