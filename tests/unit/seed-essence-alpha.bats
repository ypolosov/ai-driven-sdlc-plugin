#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/seed-essence-alpha.sh"
  TMP_DIR="$(mktemp -d)"
  MOCK_LOG="$TMP_DIR/mock.log"
  : > "$MOCK_LOG"
}

teardown() {
  rm -rf "$TMP_DIR"
}

make_mock() {
  local mode="$1"
  cat > "$TMP_DIR/mock.sh" <<MOCK
#!/usr/bin/env bash
echo "\$@" >> "$MOCK_LOG"
case "\$1" in
  get)
    if [ "$mode" = "already" ]; then
      echo "Value Established | Involved | Acceptable | Usable | Under Control | Seeded | In Use"
    else
      echo "null"
    fi
    ;;
  advance)
    if [ "$mode" = "advance-fail" ]; then
      echo "MockAdvanceError" >&2
      exit 1
    fi
    echo "advanced"
    ;;
  validate)
    echo "ok"
    ;;
esac
MOCK
  chmod +x "$TMP_DIR/mock.sh"
}

@test "dry-run prints plan without calling CLI" {
  make_mock "fresh"
  run bash -c "ESSENCE_ALPHA_CMD='$TMP_DIR/mock.sh' '$SCRIPT' --dry-run"
  [ "$status" -eq 0 ]
  [[ "$output" == *"opportunity"* ]]
  [[ "$output" == *"software-system"* ]]
  [[ "$output" == *"way-of-working"* ]]
  [ ! -s "$MOCK_LOG" ]
}

@test "skips alphas already in target state" {
  make_mock "already"
  run bash -c "ESSENCE_ALPHA_CMD='$TMP_DIR/mock.sh' '$SCRIPT'"
  [ "$status" -eq 0 ]
  ! grep -q "^advance " "$MOCK_LOG"
  [ "$(grep -c "^get " "$MOCK_LOG")" -eq 7 ]
}

@test "advances each fresh alpha through full chain and validates" {
  make_mock "fresh"
  run bash -c "ESSENCE_ALPHA_CMD='$TMP_DIR/mock.sh' '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$(grep -c "^advance " "$MOCK_LOG")" -eq 21 ]
  grep -q "^validate" "$MOCK_LOG"
}

@test "fails with non-zero exit when advance returns error" {
  make_mock "advance-fail"
  run bash -c "ESSENCE_ALPHA_CMD='$TMP_DIR/mock.sh' '$SCRIPT'"
  [ "$status" -ne 0 ]
}
