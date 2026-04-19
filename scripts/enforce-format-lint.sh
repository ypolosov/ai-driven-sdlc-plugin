#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"

FMT_PAYLOAD="$payload" python3 - <<'PY'
import json
import os
import re
import subprocess
import sys

payload = json.loads(os.environ.get("FMT_PAYLOAD", "{}"))
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input") or {}
file_path = tool_input.get("file_path", "")
cwd = payload.get("cwd", "")

if tool_name not in ("Write", "Edit"):
    sys.exit(0)

exempt_suffixes = (".md", ".yml", ".yaml", ".json", ".toml", ".txt")
exempt_basenames = (".gitignore", ".env.example", "LICENSE", "CHANGELOG")
base = os.path.basename(file_path)
if file_path.endswith(exempt_suffixes) or base in exempt_basenames:
    sys.exit(0)

config_path = os.path.join(cwd, ".claude/sdlc/plugin-config.md")
if not os.path.isfile(config_path):
    sys.exit(0)

with open(config_path, encoding="utf-8") as f:
    text = f.read()

def extract_section(name, source):
    out, inside = [], False
    for line in source.splitlines():
        if re.match(rf"^{name}:\s*$", line):
            inside = True
            continue
        if inside:
            if re.match(r"^\S", line):
                break
            out.append(line)
    return "\n".join(out)

def extract_field(section_text, key):
    for line in section_text.splitlines():
        m = re.match(rf"\s*{key}:\s*(.+)$", line)
        if m:
            return m.group(1).strip()
    return ""

def extract_globs(section_text, key="scope_globs"):
    val = extract_field(section_text, key)
    if not val:
        return []
    m = re.match(r"\[([^\]]*)\]", val)
    if not m:
        return []
    return [x.strip().strip("'\"") for x in m.group(1).split(",") if x.strip()]

def glob_to_regex(pattern):
    parts = pattern.split("/")
    pieces = []
    for part in parts:
        if part == "**":
            pieces.append("__DS__")
        else:
            o = ""
            for ch in part:
                if ch == "*":
                    o += "[^/]*"
                elif ch == "?":
                    o += "[^/]"
                elif ch in ".+()^$|{}[]\\":
                    o += re.escape(ch)
                else:
                    o += ch
            pieces.append(o)
    joined = "/".join(pieces)
    joined = re.sub(r"^__DS__/", "(?:[^/]+/)*", joined)
    joined = re.sub(r"/__DS__$", "(?:/[^/]+)*", joined)
    joined = re.sub(r"/__DS__/", "/(?:[^/]+/)*", joined)
    joined = joined.replace("__DS__", ".*")
    return re.compile("^" + joined + "$")

def in_scope(rel, patterns):
    if not patterns:
        return True
    return any(glob_to_regex(p).match(rel) for p in patterns)

fmt_section = extract_section("formatter", text)
lint_section = extract_section("linter", text)
formatter_cmd = extract_field(fmt_section, "command")
linter_cmd = extract_field(lint_section, "command")
fmt_globs = extract_globs(fmt_section)
lint_globs = extract_globs(lint_section)

profile_path = os.path.join(cwd, ".claude/sdlc/profile.md")
development_done = False
if os.path.isfile(profile_path):
    with open(profile_path, encoding="utf-8") as f:
        for line in f:
            if re.match(r"^\|\s*development\s*\|", line) and "—" not in line:
                development_done = True
                break

if not formatter_cmd and not linter_cmd:
    if development_done:
        print(
            f"format/lint hook: фаза development пройдена, но форматер/линтер не настроены.\n"
            f"Настройте formatter и linter в {config_path}.",
            file=sys.stderr,
        )
        sys.exit(2)
    sys.exit(0)

rel_path = os.path.relpath(file_path, cwd) if file_path.startswith(cwd) else file_path

def run(cmd, rel):
    return subprocess.run(
        f"{cmd} {rel}", shell=True, cwd=cwd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    ).returncode

if formatter_cmd and in_scope(rel_path, fmt_globs):
    if run(formatter_cmd, rel_path) != 0:
        print(f"Форматер не проходит для {rel_path}. Запустите форматер и повторите.", file=sys.stderr)
        sys.exit(2)

if linter_cmd and in_scope(rel_path, lint_globs):
    if run(linter_cmd, rel_path) != 0:
        print(f"Линтер не проходит для {rel_path}. Исправьте нарушения.", file=sys.stderr)
        sys.exit(2)

sys.exit(0)
PY
