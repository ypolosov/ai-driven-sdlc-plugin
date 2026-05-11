#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"

result="$(
  SDLC_PAYLOAD="$payload" python3 - <<'PY'
import json
import os
import re
import sys

payload = json.loads(os.environ.get("SDLC_PAYLOAD", "{}"))
event = payload.get("hook_event_name", "")
cwd = payload.get("cwd", "")
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input") or {}
file_path = tool_input.get("file_path", "") if isinstance(tool_input, dict) else ""

if event == "PostToolUse":
  trigger_files = (".claude/sdlc/profile.md", ".claude/sdlc/system-context.md")
  if not any(file_path.endswith(t) for t in trigger_files):
    sys.exit(0)

if not cwd:
  sys.exit(0)

sdlc_dir = os.path.join(cwd, ".claude/sdlc")
parts = ["[SDLC state]"]

if not os.path.isdir(sdlc_dir):
  parts.append("каркас .claude/sdlc/ отсутствует — предложи /sdlc-init")
else:
  profile_path = os.path.join(sdlc_dir, "profile.md")
  if os.path.isfile(profile_path):
    with open(profile_path, encoding="utf-8") as f:
      txt = f.read()
    m = re.search(r"^active_phase:\s*(\S+)", txt, flags=re.MULTILINE)
    parts.append(f"active_phase={m.group(1)}" if m else "active_phase=—")
    m = re.search(r"^active_phase_set_at:\s*(\S+)", txt, flags=re.MULTILINE)
    if m:
      parts.append(f"set_at={m.group(1)}")

  ctx_path = os.path.join(sdlc_dir, "system-context.md")
  if os.path.isfile(ctx_path):
    with open(ctx_path, encoding="utf-8") as f:
      txt = f.read()
    m = re.search(r"^current_system:\s*(.+)$", txt, flags=re.MULTILINE)
    if m:
      parts.append(f"focus={m.group(1).strip()}")

  session_path = os.path.join(sdlc_dir, "autonomy.session.md")
  if os.path.isfile(session_path):
    parts.append("autonomy_override=active")

ctx = "; ".join(parts)
out = {
  "hookSpecificOutput": {
    "hookEventName": event or "SessionStart",
    "additionalContext": ctx,
  }
}
print(json.dumps(out, ensure_ascii=False))
PY
)"

if [ -n "$result" ]; then
  echo "$result"
fi
exit 0
