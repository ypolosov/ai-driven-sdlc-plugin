#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"

decision="$(TDD_PAYLOAD="$payload" python3 - <<'PY'
import json
import os
import re
import sys

payload = json.loads(os.environ.get("TDD_PAYLOAD", "{}"))

def glob_to_regex(pattern):
    parts = pattern.split("/")
    pieces = []
    for i, part in enumerate(parts):
        if part == "**":
            pieces.append("__DS__")
        else:
            out = ""
            for ch in part:
                if ch == "*":
                    out += "[^/]*"
                elif ch == "?":
                    out += "[^/]"
                elif ch in ".+()^$|{}[]\\":
                    out += re.escape(ch)
                else:
                    out += ch
            pieces.append(out)
    joined = "/".join(pieces)
    joined = re.sub(r"^__DS__/", "(?:[^/]+/)*", joined)
    joined = re.sub(r"/__DS__$", "(?:/[^/]+)*", joined)
    joined = re.sub(r"/__DS__/", "/(?:[^/]+/)*", joined)
    joined = joined.replace("__DS__", ".*")
    return re.compile("^" + joined + "$")

def fnmatch(path, pattern):
    return bool(glob_to_regex(pattern).match(path))
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input") or {}
file_path = tool_input.get("file_path", "")
cwd = payload.get("cwd", "")

if tool_name not in ("Write", "Edit"):
    print("OK")
    sys.exit(0)

if not file_path or not cwd:
    print("OK")
    sys.exit(0)

config_path = os.path.join(cwd, ".claude/sdlc/plugin-config.md")
if not os.path.isfile(config_path):
    print("OK")
    sys.exit(0)

with open(config_path, encoding="utf-8") as f:
    text = f.read()

def extract_list(field, source):
    m = re.search(rf"^\s*{field}:\s*\[([^\]]*)\]", source, flags=re.MULTILINE)
    if not m:
        return []
    return [x.strip().strip("'\"") for x in m.group(1).split(",") if x.strip()]

def extract_block(field, source):
    lines = source.splitlines()
    out = []
    inside = False
    for line in lines:
        if re.match(rf"^{field}:\s*$", line):
            inside = True
            continue
        if inside:
            if re.match(r"^\S", line):
                break
            out.append(line)
    return out

def extract_scope(source):
    lines = source.splitlines()
    include, exclude = [], []
    inside = False
    for line in lines:
        if re.match(r"^tdd_scope:\s*$", line):
            inside = True
            continue
        if inside:
            if re.match(r"^\S", line):
                break
            m_inc = re.match(r"\s*include:\s*\[([^\]]*)\]", line)
            m_exc = re.match(r"\s*exclude:\s*\[([^\]]*)\]", line)
            if m_inc:
                include = [x.strip().strip("'\"") for x in m_inc.group(1).split(",") if x.strip()]
            elif m_exc:
                exclude = [x.strip().strip("'\"") for x in m_exc.group(1).split(",") if x.strip()]
    return include, exclude

def parse_pairs(source):
    block_lines = extract_block("tdd_pairs", source)
    pairs = []
    current = {}

    def flush():
        if current.get("source"):
            pairs.append(dict(current))

    for raw in block_lines:
        line = raw.rstrip()
        if not line.strip():
            continue
        stripped = line.lstrip()
        if stripped.startswith("- "):
            flush()
            current.clear()
            rest = stripped[2:].strip()
            if rest.startswith("{") and rest.endswith("}"):
                inner = rest[1:-1]
                for part in re.split(r",\s*(?=[a-zA-Z_]+:)", inner):
                    m = re.match(r"\s*([a-zA-Z_]+)\s*:\s*(.+)\s*$", part)
                    if m:
                        current[m.group(1)] = m.group(2).strip().strip("'\"")
                flush()
                current.clear()
                continue
            m = re.match(r"([a-zA-Z_]+)\s*:\s*(.+)$", rest)
            if m:
                current[m.group(1)] = m.group(2).strip().strip("'\"")
            continue
        m = re.match(r"\s*([a-zA-Z_]+)\s*:\s*(.+)$", line)
        if m:
            current[m.group(1)] = m.group(2).strip().strip("'\"")
    flush()
    return pairs

include_scope, exclude_scope = extract_scope(text)
pairs = parse_pairs(text)

rel_path = os.path.relpath(file_path, cwd) if file_path.startswith(cwd) else file_path

def in_scope(rel, patterns):
    for pat in patterns:
        if fnmatch(rel, pat):
            return True
    return False

if include_scope and not in_scope(rel_path, include_scope):
    print("OK")
    sys.exit(0)

if exclude_scope and in_scope(rel_path, exclude_scope):
    print("OK")
    sys.exit(0)

def normalize_template(tpl):
    return re.sub(r"\$(\d+)", r"\\\1", tpl)

has_pair = False
any_match = False
for pair in pairs:
    src_rx = pair.get("source")
    tpl = pair.get("test")
    if not src_rx or not tpl:
        continue
    try:
        pattern = re.compile(src_rx)
    except re.error:
        continue
    m = pattern.search(rel_path)
    if not m:
        continue
    any_match = True
    test_rel = pattern.sub(normalize_template(tpl), rel_path, count=1)
    test_abs = os.path.join(cwd, test_rel)
    if os.path.isfile(test_abs) or os.path.isfile(test_rel):
        has_pair = True
        break

if not any_match:
    print("OK")
    sys.exit(0)

if has_pair:
    print("OK")
    sys.exit(0)

print(f"BLOCK:{rel_path}")
PY
)"

case "$decision" in
  OK) exit 0 ;;
  BLOCK:*)
    rel="${decision#BLOCK:}"
    printf 'TDD hook: для %s не найден парный тест.\n' "$rel" >&2
    printf 'Принцип 5: создайте тест перед кодом либо подтвердите запись.\n' >&2
    exit 2
    ;;
  *) exit 0 ;;
esac
