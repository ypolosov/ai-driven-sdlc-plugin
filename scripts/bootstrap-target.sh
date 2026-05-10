#!/usr/bin/env bash
set -euo pipefail

target="${1:-$PWD}"
mode="${2:-fail-if-exists}"

sdlc_dir="${target}/.claude/sdlc"

case "$mode" in
  fail-if-exists | merge | force) ;;
  *)
    printf 'bootstrap-target: неизвестный режим %s\n' "$mode" >&2
    exit 2
    ;;
esac

if [ -d "$sdlc_dir" ]; then
  case "$mode" in
    fail-if-exists)
      printf 'bootstrap-target: %s уже существует. Используйте --merge или --force.\n' "$sdlc_dir" >&2
      exit 2
      ;;
    force)
      printf 'bootstrap-target: режим --force требует интерактивного подтверждения.\n' >&2
      printf 'Запустите через /sdlc-init с autonomy=hitl.\n' >&2
      exit 2
      ;;
    merge) ;;
  esac
fi

mkdir -p "$sdlc_dir"

target_claude_md="${target}/.claude/CLAUDE.md"
mkdir -p "${target}/.claude"
if [ ! -f "$target_claude_md" ]; then
  cat >"$target_claude_md" <<'EOF'
---
name: target-project-constitution
type: project-constitution
language: ru
---

# Конституция целевого проекта

Управляется плагином ai-driven-sdlc. Не редактируйте руками без согласования.

## Наследуемые правила плагина

- Язык артефактов: русский.
- Каждое утверждение: не более 15 слов.
- Код без комментариев.
- TDD по умолчанию; форматер и линтер обязательны на фазе development.
- Секреты только в .env; .env добавлен в .gitignore.

## Следующий шаг

Запустите /sdlc-continue — плагин предложит фазу по вашей роли.
EOF
fi

project_name="$(basename "$target")"
today="$(date +%Y-%m-%d)"

if [ ! -f "${sdlc_dir}/profile.md" ]; then
  cat >"${sdlc_dir}/profile.md" <<EOF
---
name: profile
type: sdlc-profile
project: ${project_name}
created: ${today}
updated: ${today}
---

# SME-профиль проекта

Заполняется skill \`sdlc-bootstrap\` через /sdlc-init.
EOF
fi

if [ ! -f "${sdlc_dir}/plugin-config.md" ]; then
  cat >"${sdlc_dir}/plugin-config.md" <<EOF
---
name: plugin-config
type: hooks-config
project: ${project_name}
version: 1
created: ${today}
updated: ${today}
---

# Технический конфиг hooks

Заполняется skill \`sdlc-bootstrap\` через /sdlc-init.
EOF
fi

if [ ! -f "${sdlc_dir}/alphas.md" ]; then
  cat >"${sdlc_dir}/alphas.md" <<EOF
---
name: alphas
type: alpha-snapshot
project: ${project_name}
source_of_truth: mcp://sdlc-state-rag
snapshot_role: pr-visible-mirror
created: ${today}
updated: ${today}
---

# Snapshot состояний альф

Заполняется skill \`sdlc-bootstrap\` через /sdlc-init.
EOF
fi

if [ ! -f "${sdlc_dir}/system-context.md" ]; then
  cat >"${sdlc_dir}/system-context.md" <<EOF
---
name: system-context
type: attention-context
project: ${project_name}
current_focus: ${project_name}
created: ${today}
updated: ${today}
---

# Реестр систем внимания

Заполняется skill \`sdlc-focus\` через /sdlc-focus.
EOF
fi

if [ ! -f "${sdlc_dir}/roles.md" ]; then
  cat >"${sdlc_dir}/roles.md" <<EOF
---
name: roles
type: role-journal
project: ${project_name}
active_roles: []
created: ${today}
updated: ${today}
---

# Журнал играемых ролей

Заполняется skill \`sdlc-bootstrap\` через /sdlc-init.
EOF
fi

if [ ! -f "${sdlc_dir}/decisions.md" ]; then
  cat >"${sdlc_dir}/decisions.md" <<EOF
---
name: decisions
type: decision-journal
project: ${project_name}
created: ${today}
updated: ${today}
---

# Журнал альтернатив и решений

Заполняется skills фаз через AskUserQuestion и MCP \`decisions_record\`.
EOF
fi

role_ext_dest="${sdlc_dir}/role-extensions.md"
if [ ! -f "$role_ext_dest" ]; then
  cat >"$role_ext_dest" <<EOF
---
name: role-extensions
type: target-role-mapping
project: $(basename "$target")
created: $(date +%Y-%m-%d)
updated: $(date +%Y-%m-%d)
---

# Role extensions целевого проекта

Маппинг конкретных ролей команды на 9 абстрактных ролей плагина (см. \`catalogs/roles.md\`).

Для greenfield-проектов начните с одной записи; расширяйте по мере роста команды.

## Запись роли

\`\`\`yaml
- id: <slug>
  title: <human-readable>
  extends: [<abstract-role>, ...]
  agent_kind: human | ai | both
  tool_categories: [<id>, ...]
  phases: [<phase>, ...]
  alphas: [<alpha>, ...]
\`\`\`

## Пример (pet, solo developer)

- id: solo-developer
  title: Solo Developer
  extends: [product-owner, architect, developer, tester, devops]
  agent_kind: human
  tool_categories: [vcs]
  phases: [vision, requirements, architecture, development, testing, deployment, operations]
  alphas: [Opportunity, Requirements, Software System, Work, Stakeholders, Way of Working, Team]
EOF
fi

env_example="${target}/.env.example"
if [ ! -f "$env_example" ]; then
  cat >"$env_example" <<'EOF'
# Пример .env.example — значения не коммитить в git.
# Скопируйте в .env и заполните по ходу фаз.
EOF
fi

gitignore="${target}/.gitignore"
touch "$gitignore"
if ! grep -qE '^\.env$' "$gitignore"; then
  cat >>"$gitignore" <<'EOF'

# ai-driven-sdlc: credentials (принцип 10)
.env
.env.local
.env.*.local
EOF
fi

mcp_json="${target}/.mcp.json"
overwrite_mode="${MCP_OVERWRITE_SDLC_RAG:-no}"
TARGET_MCP_JSON="$mcp_json" OVERWRITE_MODE="$overwrite_mode" python3 - <<'PY'
import json
import os
import sys

target_path = os.environ['TARGET_MCP_JSON']
overwrite = os.environ.get('OVERWRITE_MODE', 'no')

new_entry = {
    "type": "stdio",
    "command": "bash",
    "args": [
        "-c",
        'exec "${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$PWD}}/scripts/launch-sdlc-state-rag.sh"',
    ],
    "env": {"SDLC_STATE_RAG_DSN": "${SDLC_STATE_RAG_DSN}"},
}

if os.path.exists(target_path):
    try:
        with open(target_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except json.JSONDecodeError as exc:
        sys.stderr.write(f'bootstrap-target: некорректный JSON в {target_path}: {exc}\n')
        sys.exit(2)
    if not isinstance(data, dict):
        sys.stderr.write(f'bootstrap-target: {target_path} не объект JSON\n')
        sys.exit(2)
    servers = data.setdefault('mcpServers', {})
    if not isinstance(servers, dict):
        sys.stderr.write(f'bootstrap-target: mcpServers не объект в {target_path}\n')
        sys.exit(2)
    if 'sdlc-state-rag' in servers and overwrite != 'yes':
        pass
    else:
        servers['sdlc-state-rag'] = new_entry
    with open(target_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
else:
    data = {'mcpServers': {'sdlc-state-rag': new_entry}}
    with open(target_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
PY

printf 'bootstrap-target: %s инициализирован в режиме %s.\n' "$sdlc_dir" "$mode"
exit 0
