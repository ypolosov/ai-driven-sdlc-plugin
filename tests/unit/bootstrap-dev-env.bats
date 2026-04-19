#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/bootstrap-dev-env.sh"
}

@test "script is executable" {
  [ -x "$SCRIPT" ]
}

@test "script reports OK when all tools installed" {
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"dev env OK"* ]]
}

@test "script detects apt package manager" {
  run bash -c "source '$SCRIPT' 2>/dev/null; detect_pkg_manager"
  [ -n "$output" ]
}
