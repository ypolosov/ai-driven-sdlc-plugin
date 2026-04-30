#!/usr/bin/env bash
set -euo pipefail

cmd="${ESSENCE_ALPHA_CMD:-npx -y @ypolosov/essence-alpha-mcp}"
repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
dry_run=0

if [ "${1:-}" = "--dry-run" ]; then
  dry_run=1
fi

declare -A evidence
evidence["opportunity"]=".claude/sdlc/phases/vision/vision.md"
evidence["stakeholders"]=".claude/sdlc/phases/requirements/requirements.md"
evidence["requirements"]=".claude/sdlc/phases/architecture/architecture.md"
evidence["software-system"]="CHANGELOG.md"
evidence["work"]="tests/unit/validate-artifact.bats"
evidence["team"]=".claude/sdlc/roles.md"
evidence["way-of-working"]=".claude/sdlc/phases/testing/testing.md"

advance_chain() {
  local alpha="$1"
  shift
  local -a chain=("$@")
  local uri="file://${repo_root}/${evidence[$alpha]}"
  local final="${chain[-1]}"

  if [ "$dry_run" -eq 1 ]; then
    for s in "${chain[@]}"; do
      printf 'plan: advance %s -> %s\n' "$alpha" "$s"
    done
    return 0
  fi

  local current
  current="$($cmd get "$alpha" 2>/dev/null || true)"

  local start_idx=0
  local i
  for i in "${!chain[@]}"; do
    if printf '%s' "$current" | grep -qF -- "${chain[$i]}"; then
      start_idx=$((i + 1))
    fi
  done

  if [ "$start_idx" -ge "${#chain[@]}" ]; then
    printf 'skip: %s already in %s\n' "$alpha" "$final"
    return 0
  fi

  for ((i = start_idx; i < ${#chain[@]}; i++)); do
    local state="${chain[$i]}"
    printf 'advance: %s -> %s\n' "$alpha" "$state"
    $cmd advance "$alpha" "$state" "$uri"
  done
}

advance_chain opportunity "Identified" "Solution Needed" "Value Established"
advance_chain stakeholders "Recognized" "Represented" "Involved"
advance_chain requirements "Conceived" "Bounded" "Coherent" "Acceptable"
advance_chain software-system "Architecture Selected" "Demonstrable" "Usable"
advance_chain work "Initiated" "Prepared" "Started" "Under Control"
advance_chain team "Seeded"
advance_chain way-of-working "Principles Established" "Foundation Established" "In Use"

if [ "$dry_run" -eq 1 ]; then
  printf 'dry-run summary: 7 alphas, 21 transitions planned\n'
  exit 0
fi

$cmd validate
