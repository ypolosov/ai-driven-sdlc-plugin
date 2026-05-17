#!/usr/bin/env bash
set -euo pipefail

target_dir="${1:-}"
if [ -z "$target_dir" ]; then
  echo "check-rag-config: usage: $0 <target-dir>" >&2
  exit 2
fi

config_file="$target_dir/.claude/sdlc/rag-config.md"
if [ ! -f "$config_file" ]; then
  echo "check-rag-config: rag-config.md не найден; RAG не сконфигурирован (OK для pet)"
  exit 0
fi

errors=0

if ! head -10 "$config_file" | grep -qE '^---'; then
  echo "check-rag-config: отсутствует frontmatter в $config_file" >&2
  errors=$((errors + 1))
fi

enabled_line="$(grep -E '^enabled:[[:space:]]*(true|false)' "$config_file" | head -1 || true)"
if [ -z "$enabled_line" ]; then
  echo "check-rag-config: поле 'enabled' отсутствует или некорректно" >&2
  errors=$((errors + 1))
fi

if echo "$enabled_line" | grep -qE 'enabled:[[:space:]]*true'; then
  data_class="$(grep -E '^data_classification:[[:space:]]*' "$config_file" | head -1 | sed -E 's/.*data_classification:[[:space:]]*//; s/[[:space:]]*$//' || true)"
  if [ "$data_class" = "regulated" ]; then
    if ! grep -qE '^compliance_signoff:[[:space:]]*\S' "$config_file"; then
      echo "check-rag-config: data_classification=regulated при enabled=true требует 'compliance_signoff' (compliance-gate)" >&2
      errors=$((errors + 1))
    fi
  fi
  if ! grep -qE '^sources:' "$config_file"; then
    echo "check-rag-config: при enabled=true обязателен 'sources'" >&2
    errors=$((errors + 1))
  fi
  if ! grep -qE '^embedder:' "$config_file"; then
    echo "check-rag-config: при enabled=true обязателен 'embedder'" >&2
    errors=$((errors + 1))
  fi

  matrix="$(cd "$(dirname "$0")"/.. && pwd)/catalogs/method-tool-matrix.md"
  embedder_name="$(grep -A2 '^embedder:' "$config_file" | grep -E '^[[:space:]]*name:' | head -1 | sed -E 's/.*name:[[:space:]]*//; s/[[:space:]]*$//' || true)"
  if [ -n "$embedder_name" ] && [ -f "$matrix" ]; then
    embedder_normalized="$(echo "$embedder_name" | tr '[:upper:]' '[:lower:]' | tr -d ' -_')"
    matrix_normalized="$(tr '[:upper:]' '[:lower:]' <"$matrix" | tr -d ' -_')"
    if ! echo "$matrix_normalized" | grep -qF "$embedder_normalized"; then
      echo "check-rag-config: embedder '$embedder_name' не найден в method-tool-matrix.md раздел 12" >&2
      errors=$((errors + 1))
    fi
  fi
fi

profile="$target_dir/.claude/sdlc/profile.md"
worker_kind="$(grep -E '^[[:space:]]*kind:' "$config_file" | head -1 | sed -E 's/.*kind:[[:space:]]*//; s/[[:space:]]*$//' || true)"
if [ -n "$worker_kind" ] && [ -f "$profile" ]; then
  sme_level="$(grep -iE 'level:[[:space:]]*(pet|mid|enterprise)' "$profile" | head -1 | sed -E 's/.*level:[[:space:]]*//; s/[[:space:]]*$//' || true)"
  case "$sme_level:$worker_kind" in
    pet:null | mid:cron | enterprise:cron+webhooks | enterprise:cron) ;;
    pet:cron* | pet:webhooks*)
      echo "check-rag-config: worker.kind '$worker_kind' избыточен для pet" >&2
      errors=$((errors + 1))
      ;;
    *) ;;
  esac
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "check-rag-config: OK"
exit 0
