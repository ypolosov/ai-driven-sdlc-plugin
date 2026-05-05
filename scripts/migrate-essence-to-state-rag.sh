#!/usr/bin/env bash
set -euo pipefail

mode="exec"
source_path=""
backup_path=""
target_root="${SDLC_TARGET_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

usage() {
  cat <<'EOF'
migrate-essence-to-state-rag — разовая миграция dogfooding-target

Использование:
  migrate-essence-to-state-rag.sh [--dry-run|--verify|--exec] [--source <path>] [--backup <path>]

Режимы:
  --dry-run   Показать план без изменений (default).
  --verify    Сравнить snapshot с состоянием sdlc-state-rag.
  --exec      Выполнить миграцию (с обязательным backup).

Параметры:
  --source <path>  Snapshot alphas.md (default: <target>/.claude/sdlc/alphas.md).
  --backup <path>  Куда сохранить backup (default: <source>.backup-<date>).

ENV:
  SDLC_STATE_RAG_DSN          Connection string для PostgreSQL (опционально).
  SDLC_STATE_RAG_PGLITE_DIR   Путь pglite-БД (если без DSN).
  SDLC_TARGET_ROOT            Корень целевого (default: git root).
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      mode="dry-run"
      shift
      ;;
    --verify)
      mode="verify"
      shift
      ;;
    --exec)
      mode="exec"
      shift
      ;;
    --source)
      source_path="$2"
      shift 2
      ;;
    --backup)
      backup_path="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "$source_path" ]; then
  source_path="${target_root}/.claude/sdlc/alphas.md"
fi

if [ ! -f "$source_path" ]; then
  echo "migrate-essence: source not found: $source_path" >&2
  exit 2
fi

if [ -z "$backup_path" ]; then
  backup_path="${source_path}.backup-$(date +%Y-%m-%d)"
fi

case "$mode" in
  dry-run)
    npx -y --package="@ypolosov/sdlc-state-rag" sdlc-state-rag-migrate-essence --source "$source_path" --dry-run
    ;;
  verify)
    npx -y --package="@ypolosov/sdlc-state-rag" sdlc-state-rag-migrate-essence --source "$source_path" --verify
    ;;
  exec)
    if [ ! -f "$backup_path" ]; then
      cp -p "$source_path" "$backup_path"
      echo "migrate-essence: backup written to $backup_path"
    else
      echo "migrate-essence: backup already exists at $backup_path (idempotent)" >&2
    fi
    npx -y --package="@ypolosov/sdlc-state-rag" sdlc-state-rag-migrate-essence --source "$source_path" --backup "$backup_path"
    ;;
esac
