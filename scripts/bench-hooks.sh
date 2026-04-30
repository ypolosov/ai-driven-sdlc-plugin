#!/usr/bin/env bash
set -euo pipefail

root="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
threshold_ms="${BENCH_THRESHOLD_MS:-200}"
runs="${BENCH_RUNS:-5}"

declare -A scripts
scripts["validate-artifact"]="$root/scripts/validate-artifact.sh"
scripts["check-cross-refs"]="$root/scripts/check-cross-refs.sh"
scripts["check-system-readmes"]="$root/scripts/check-system-readmes.sh"
scripts["check-memom-consistency"]="$root/scripts/check-memom-consistency.sh"
scripts["check-readme-inventory"]="$root/scripts/check-readme-inventory.sh"
scripts["check-alpha-consistency"]="$root/scripts/check-alpha-consistency.sh"
scripts["enforce-no-comments"]="$root/scripts/enforce-no-comments.sh"
scripts["enforce-format-lint"]="$root/scripts/enforce-format-lint.sh"

sample_artifact="$root/.claude/sdlc/phases/testing/testing.md"
sample_alphas="$root/.claude/sdlc/alphas.md"
sample_script="$root/scripts/validate-artifact.sh"
if [ ! -f "$sample_artifact" ]; then
  echo "bench-hooks: sample artifact not found: $sample_artifact" >&2
  exit 1
fi

avg_ms() {
  local total=0 i=0 cmd="$1"
  local start end
  for ((i = 0; i < runs; i++)); do
    start=$(date +%s%N)
    eval "$cmd" >/dev/null 2>&1 || true
    end=$(date +%s%N)
    total=$((total + (end - start) / 1000000))
  done
  echo $((total / runs))
}

exit_code=0
printf '%-28s %-10s %-10s %s\n' "hook" "avg_ms" "threshold" "status"
printf '%-28s %-10s %-10s %s\n' "----" "------" "---------" "------"

for name in "${!scripts[@]}"; do
  path="${scripts[$name]}"
  [ -x "$path" ] || {
    echo "skip $name (not executable)" >&2
    continue
  }
  case "$name" in
    validate-artifact)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$sample_artifact")
      cmd="printf '%s' '$payload' | bash '$path'"
      ;;
    check-cross-refs)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$sample_artifact")
      cmd="printf '%s' '$payload' | bash '$path'"
      ;;
    check-alpha-consistency)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"},"cwd":"%s"}' "$sample_alphas" "$root")
      cmd="printf '%s' '$payload' | ESSENCE_ALPHA_VALIDATE_CMD='true' bash '$path'"
      ;;
    enforce-no-comments)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s","content":"#!/usr/bin/env bash\necho ok"}}' "$sample_script")
      cmd="printf '%s' '$payload' | bash '$path'"
      ;;
    enforce-format-lint)
      payload=$(printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"},"cwd":"%s"}' "$sample_script" "$root")
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
