#!/usr/bin/env bats

setup() {
  ROOT="$(git rev-parse --show-toplevel)"
  META_DIR="$ROOT/meta-templates"
}

@test "work-unit.jira.meta.md exists" {
  [ -f "$META_DIR/work-unit.jira.meta.md" ]
}

@test "work-unit.linear.meta.md exists" {
  [ -f "$META_DIR/work-unit.linear.meta.md" ]
}

@test "work-unit.github.meta.md exists" {
  [ -f "$META_DIR/work-unit.github.meta.md" ]
}

@test "all 3 templates have correct frontmatter" {
  for tracker in jira linear github; do
    f="$META_DIR/work-unit.$tracker.meta.md"
    grep -q "^name: work-unit.$tracker.meta" "$f"
    grep -q "^type: meta-template" "$f"
    grep -q "^tracker_category: issue-tracker" "$f"
    grep -q "^tracker_tool: $tracker" "$f"
  done
}

@test "all 3 templates extend work-product.meta.md" {
  for tracker in jira linear github; do
    grep -q "^extends: work-product.meta.md" "$META_DIR/work-unit.$tracker.meta.md"
  done
}

@test "plugin-config.meta.md declares work_unit_template field" {
  grep -q "work_unit_template" "$META_DIR/plugin-config.meta.md"
}

@test "all 3 templates declare alphas Work and Requirements" {
  for tracker in jira linear github; do
    grep -qE "alphas:.*Work" "$META_DIR/work-unit.$tracker.meta.md"
    grep -qE "alphas:.*Requirements" "$META_DIR/work-unit.$tracker.meta.md"
  done
}
