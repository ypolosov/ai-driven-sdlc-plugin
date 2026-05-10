#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  TEMPLATE="$REPO_ROOT/meta-templates/iteration.meta.md"
}

@test "iteration.meta.md exists" {
  [ -f "$TEMPLATE" ]
}

@test "iteration.meta.md has correct frontmatter type meta-template" {
  run grep -E "^type: meta-template$" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "iteration.meta.md extends work-product.meta.md" {
  run grep -E "^extends: work-product\.meta\.md$" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "iteration.meta.md frontmatter declares iteration_id field" {
  run grep -E "iteration_id" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "iteration.meta.md frontmatter declares status field with kanban states" {
  grep -q "status" "$TEMPLATE"
  grep -q "planned" "$TEMPLATE"
  grep -q "in-progress" "$TEMPLATE"
  grep -q "completed" "$TEMPLATE"
}

@test "iteration.meta.md frontmatter declares work_units field" {
  run grep -E "work_units" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "iteration.meta.md declares start_date and end_date" {
  grep -q "start_date" "$TEMPLATE"
  grep -q "end_date" "$TEMPLATE"
}

@test "iteration.meta.md declares alphas Work" {
  run grep -E "alphas:.*Work" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "iteration.meta.md mentions sprint or milestone" {
  grep -qE "sprint|milestone" "$TEMPLATE"
}

@test "README.md mentions iteration.meta.md" {
  run grep -E "iteration\.meta\.md" "$REPO_ROOT/README.md"
  [ "$status" -eq 0 ]
}
