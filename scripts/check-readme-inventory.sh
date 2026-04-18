#!/usr/bin/env bash
set -euo pipefail

plugin_root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
readme="${plugin_root}/README.md"

if [ ! -f "$readme" ]; then
  printf 'check-readme-inventory: README.md отсутствует.\n' >&2
  exit 2
fi

python3 - "$plugin_root" "$readme" <<'PY'
import os
import re
import sys

plugin_root = sys.argv[1]
readme_path = sys.argv[2]

def list_dirs(sub):
    p = os.path.join(plugin_root, sub)
    if not os.path.isdir(p):
        return set()
    return {d for d in os.listdir(p) if os.path.isdir(os.path.join(p, d))}

def list_files(sub, ext):
    p = os.path.join(plugin_root, sub)
    if not os.path.isdir(p):
        return set()
    return {f for f in os.listdir(p) if f.endswith(ext) and f != ".gitkeep"}

skills = list_dirs("skills")
commands = {f[:-3] for f in list_files("commands", ".md")}
agents = {f[:-3] for f in list_files("agents", ".md")}
scripts = list_files("scripts", ".sh")
meta = list_files("meta-templates", ".md")

with open(readme_path, encoding="utf-8") as f:
    text = f.read()

def find_section(title):
    m = re.search(r"^### " + re.escape(title) + r".*?\n(.*?)(?=^### |\Z)", text, re.M | re.S)
    return m.group(1) if m else ""

skills_readme = set(re.findall(r"`(sdlc-[a-z-]+)`", find_section("Skills")))
commands_readme = set(re.findall(r"/(sdlc-[a-z-]+)", find_section("Commands")))
agents_readme = set(re.findall(r"`(sdlc-[a-z-]+)`", find_section("Agents")))
scripts_readme = set(re.findall(r"`([a-z][a-z0-9-]*\.sh)`", find_section("Scripts")))
meta_readme = set(re.findall(r"`([a-z][a-z0-9-]*\.meta\.md)`", find_section("Meta-templates")))

errors = 0

def check(label, actual, readme_set):
    global errors
    only_actual = actual - readme_set
    only_readme = readme_set - actual
    if only_actual:
        print(f"{label}: отсутствуют в README: {sorted(only_actual)}", file=sys.stderr)
        errors += 1
    if only_readme:
        print(f"{label}: в README, но нет на диске: {sorted(only_readme)}", file=sys.stderr)
        errors += 1

check("skills", skills, skills_readme)
check("commands", commands, commands_readme)
check("agents", agents, agents_readme)
check("scripts", scripts, scripts_readme)
check("meta-templates", meta, meta_readme)

if errors:
    print(f"check-readme-inventory: {errors} расхождений. Обновите README.md.", file=sys.stderr)
    sys.exit(2)
print("check-readme-inventory: OK")
PY
