#!/usr/bin/env bash
set -euo pipefail

if [ "${SDLC_PHASE_ENFORCE:-}" = "skip" ]; then
  exit 0
fi

payload="$(cat)"

result="$(
  SDLC_PAYLOAD="$payload" python3 - <<'PY'
import json
import os
import re
import shlex
import sys
from datetime import datetime, timezone, timedelta

payload = json.loads(os.environ.get("SDLC_PAYLOAD", "{}"))
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input") or {}
cwd = payload.get("cwd", "")

if tool_name not in ("Bash", "Write", "Edit"):
  print("OK")
  sys.exit(0)

if not cwd:
  print("OK")
  sys.exit(0)

session_path = os.path.join(cwd, ".claude/sdlc/autonomy.session.md")
if os.path.isfile(session_path):
  try:
    with open(session_path, encoding="utf-8") as f:
      session_text = f.read()
    mode_match = re.search(r"^mode:\s*(\S+)", session_text, flags=re.MULTILINE)
    expires_match = re.search(r"^expires_at:\s*(\S+)", session_text, flags=re.MULTILINE)
    if mode_match and mode_match.group(1) == "hootl" and expires_match:
      expires = datetime.fromisoformat(expires_match.group(1).replace("Z", "+00:00"))
      now = datetime.now(timezone.utc)
      if expires > now:
        print("OK")
        sys.exit(0)
  except Exception:
    pass

WHITELIST_PATHS = [
  ".claude/sdlc/",
  ".claude/CLAUDE.md",
  ".gitignore",
  ".env.example",
  "README.sdlc.md",
]

def in_whitelist_path(rel):
  for prefix in WHITELIST_PATHS:
    if rel == prefix or rel.startswith(prefix):
      return True
  return False

if tool_name in ("Write", "Edit"):
  file_path = tool_input.get("file_path", "")
  if not file_path:
    print("OK")
    sys.exit(0)
  rel = os.path.relpath(file_path, cwd) if file_path.startswith(cwd) else file_path
  if in_whitelist_path(rel):
    print("OK")
    sys.exit(0)
  needs_phase = True
elif tool_name == "Bash":
  command = tool_input.get("command", "")
  if not command:
    print("OK")
    sys.exit(0)
  try:
    parts = shlex.split(command, posix=True)
  except ValueError:
    parts = command.split()
  needs_phase = False
  i = 0
  while i < len(parts):
    head = parts[i]
    sub = parts[i + 1] if i + 1 < len(parts) else ""
    if head == "git":
      if sub in ("status", "diff", "log", "show", "branch", "remote", "config", "version", "--help", "-h", "describe", "blame", "rev-parse"):
        pass
      elif sub in ("commit", "push", "tag", "rebase", "reset", "checkout", "rm", "merge", "cherry-pick", "revert", "clean", "stash"):
        needs_phase = True
        break
      i += 2
      while i < len(parts) and parts[i] not in ("&&", "||", ";", "|"):
        i += 1
      continue
    if head == "gh":
      if sub in ("auth", "status", "version", "--help", "-h", "api"):
        pass
      elif sub in ("pr", "release", "repo", "issue", "workflow"):
        action = parts[i + 2] if i + 2 < len(parts) else ""
        if action in ("view", "list", "checks", "diff", "ready"):
          pass
        elif action in ("create", "merge", "edit", "close", "reopen", "delete", "comment"):
          needs_phase = True
          break
      i += 2
      while i < len(parts) and parts[i] not in ("&&", "||", ";", "|"):
        i += 1
      continue
    if head == "npm":
      if sub in ("view", "search", "whoami", "test", "run", "install", "ci", "audit", "outdated", "ls", "config"):
        pass
      elif sub in ("publish", "unpublish", "deprecate"):
        needs_phase = True
        break
      i += 2
      while i < len(parts) and parts[i] not in ("&&", "||", ";", "|"):
        i += 1
      continue
    i += 1
  if not needs_phase:
    print("OK")
    sys.exit(0)
else:
  print("OK")
  sys.exit(0)

profile_path = os.path.join(cwd, ".claude/sdlc/profile.md")
if not os.path.isfile(profile_path):
  print("BLOCK:enforce-sdlc-phase: целевой проект не инициализирован. Выполните /sdlc-init.")
  sys.exit(0)

with open(profile_path, encoding="utf-8") as f:
  profile_text = f.read()

front_match = re.search(r"^---\n(.*?)\n---", profile_text, flags=re.DOTALL)
if not front_match:
  print("BLOCK:enforce-sdlc-phase: profile.md не содержит frontmatter. Выполните /sdlc-init.")
  sys.exit(0)

frontmatter = front_match.group(1)
active_phase_match = re.search(r"^active_phase:\s*(\S+)", frontmatter, flags=re.MULTILINE)
if not active_phase_match or active_phase_match.group(1) in ("", "null", "none"):
  print("BLOCK:enforce-sdlc-phase: активная фаза не задана. Выполните /sdlc-phase <name>.")
  sys.exit(0)

ttl_hours_env = os.environ.get("SDLC_PHASE_TTL_HOURS")
ttl_hours = int(ttl_hours_env) if ttl_hours_env and ttl_hours_env.isdigit() else 24

set_at_match = re.search(r"^active_phase_set_at:\s*(\S+)", frontmatter, flags=re.MULTILINE)
if set_at_match:
  try:
    set_at = datetime.fromisoformat(set_at_match.group(1).replace("Z", "+00:00"))
    now = datetime.now(timezone.utc)
    if (now - set_at) > timedelta(hours=ttl_hours):
      print(f"BLOCK:enforce-sdlc-phase: фаза {active_phase_match.group(1)} устарела (>{ttl_hours} ч). Обновите через /sdlc-phase или /sdlc-autonomy --task hootl.")
      sys.exit(0)
  except (ValueError, TypeError):
    pass

print("OK")
PY
)"

case "$result" in
  OK) exit 0 ;;
  BLOCK:*)
    msg="${result#BLOCK:}"
    printf '%s\n' "$msg" >&2
    exit 2
    ;;
  *) exit 0 ;;
esac
