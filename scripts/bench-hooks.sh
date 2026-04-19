#!/usr/bin/env bash
set -euo pipefail

root="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
threshold_ms="${BENCH_THRESHOLD_MS:-200}"
runs="${BENCH_RUNS:-5}"

declare -A scripts=(
  [validate-artifact]="$root/scripts/validate-artifact.sh"
  [check-cross-refs]="$root/scripts/check-cross-refs.sh"
  [check-system-readmes]="$root/scripts/check-system-readmes.sh"
  [check-memom-consistency]="$root/scripts/check-memom-consistency.sh"
  [check-readme-inventory]="$root/scripts/check-readme-inventory.sh"
)

sample_artifact="$root/.claude/sdlc/phases/testing/testing.md"
if [ ! -f "$sample_artifact" ]; then
  echo "bench-hooks: sample artifact not found: $sample_artifact" >&2
  exit 1
fi

avg_ms() {
  local total=0 i=0 cmd="$1"
  for ((i=0; i<runs; i++)); do
    local start=$(date +%s%N)
    eval "$cmd" >/dev/null 2>&1 || true
    local end=$(date +%s%N)
    total=$(( total + (end - start) / 1000000 ))
  done
  echo $(( total / runs ))
}

exit_code=0
printf '%-28s %-10s %-10s %s\n' "hook" "avg_ms" "threshold" "status"
printf '%-28s %-10s %-10s %s\n' "----" "------" "---------" "------"

for name in "${!scripts[@]}"; do
  path="${scripts[$name]}"
  [ -x "$path" ] || { echo "skip $name (not executable)" >&2; continue; }
  case "$name" in
    validate-artifact)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$sample_artifact")
      cmd="printf '%s' '$payload' | bash '$path'"
      ;;
    check-cross-refs)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$sample_artifact")
      cmd="printf '%s' '$payload' | bash '$path'"
      ;;
    *)
      cmd="bash '$path' '$root'"
      ;;
  esac
  ms=$(avg_ms "$cmd")
  status="ok"
  if [ "$ms" -gt "$threshold_ms" ]; then
    status="FAIL"
    exit_code=1
  fi
  printf '%-28s %-10s %-10s %s\n' "$name" "$ms" "$threshold_ms" "$status"
done

exit "$exit_code"
