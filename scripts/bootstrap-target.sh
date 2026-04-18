#!/usr/bin/env bash
set -euo pipefail

target="${1:-$PWD}"
mode="${2:-fail-if-exists}"

plugin_root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
templates_root="${plugin_root}/meta-templates"
sdlc_dir="${target}/.claude/sdlc"

case "$mode" in
  fail-if-exists|merge|force) ;;
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

write_if_absent() {
  local dest="$1"
  local source="$2"
  if [ -e "$dest" ] && [ "$mode" = "merge" ]; then
    return 0
  fi
  if [ -e "$dest" ] && [ "$mode" = "fail-if-exists" ]; then
    return 0
  fi
  cp "$source" "$dest"
}

target_claude_md="${target}/.claude/CLAUDE.md"
mkdir -p "${target}/.claude"
if [ ! -f "$target_claude_md" ]; then
  cat > "$target_claude_md" <<'EOF'
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

for f in profile plugin-config alphas system-context roles decisions; do
  dest="${sdlc_dir}/${f}.md"
  if [ -f "$dest" ]; then continue; fi
  cat > "$dest" <<EOF
---
name: ${f}
type: placeholder
project: $(basename "$target")
created: $(date +%Y-%m-%d)
updated: $(date +%Y-%m-%d)
---

# ${f}

Placeholder. Заполняется skill \`sdlc-bootstrap\` через /sdlc-init.
EOF
done

env_example="${target}/.env.example"
if [ ! -f "$env_example" ]; then
  cat > "$env_example" <<'EOF'
# Пример .env.example — значения не коммитить в git.
# Скопируйте в .env и заполните по ходу фаз.
EOF
fi

gitignore="${target}/.gitignore"
touch "$gitignore"
if ! grep -qE '^\.env$' "$gitignore"; then
  cat >> "$gitignore" <<'EOF'

# ai-driven-sdlc: credentials (принцип 10)
.env
.env.local
.env.*.local
EOF
fi

printf 'bootstrap-target: %s инициализирован в режиме %s.\n' "$sdlc_dir" "$mode"
exit 0
