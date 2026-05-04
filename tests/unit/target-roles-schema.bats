#!/usr/bin/env bats

setup() {
  PLUGIN_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")"/../.. && pwd)"
  ROLES_CATALOG="$PLUGIN_ROOT/catalogs/roles.md"
  TARGET_ROLES_META="$PLUGIN_ROOT/meta-templates/target-roles.meta.md"
  TOOL_CATEGORIES="$PLUGIN_ROOT/catalogs/tool-categories.md"
}

@test "roles catalog exists and has security-engineer role" {
  [ -f "$ROLES_CATALOG" ]
  run grep -E '^### security-engineer$' "$ROLES_CATALOG"
  [ "$status" -eq 0 ]
}

@test "roles catalog declares 9 abstract roles" {
  run grep -cE '^### (product-owner|architect|developer|tester|devops|sre|security-engineer|method-engineer|systems-thinker)$' "$ROLES_CATALOG"
  [ "$status" -eq 0 ]
  [ "$output" -eq 9 ]
}

@test "roles schema declares tool_categories field" {
  run grep -E '^tool_categories:' "$ROLES_CATALOG"
  [ "$status" -eq 0 ]
}

@test "roles schema declares agent_kind field" {
  run grep -E '^agent_kind:' "$ROLES_CATALOG"
  [ "$status" -eq 0 ]
}

@test "every role record has tool_categories line" {
  count=$(grep -cE '^tool_categories: \[' "$ROLES_CATALOG")
  [ "$count" -ge 9 ]
}

@test "every role record has agent_kind line" {
  count=$(grep -cE '^agent_kind: (human|ai|both)' "$ROLES_CATALOG")
  [ "$count" -ge 9 ]
}

@test "target-roles meta-template exists" {
  [ -f "$TARGET_ROLES_META" ]
}

@test "target-roles meta-template has frontmatter" {
  run head -1 "$TARGET_ROLES_META"
  [ "$output" = "---" ]
}

@test "target-roles meta-template references catalogs/tool-categories" {
  run grep -E 'tool-categories' "$TARGET_ROLES_META"
  [ "$status" -eq 0 ]
}

@test "target-roles meta-template specifies extends field" {
  run grep -E '^[[:space:]]*extends:' "$TARGET_ROLES_META"
  [ "$status" -eq 0 ]
}

@test "target-roles meta-template specifies agent_kind field" {
  run grep -E 'agent_kind:' "$TARGET_ROLES_META"
  [ "$status" -eq 0 ]
}

@test "target-roles meta-template references abstract roles via extends" {
  run grep -iE 'abstract' "$TARGET_ROLES_META"
  [ "$status" -eq 0 ]
}

@test "target-roles meta-template has location_in_target" {
  run grep -E 'location_in_target:' "$TARGET_ROLES_META"
  [ "$status" -eq 0 ]
}

@test "target-roles meta-template forbids concrete role names in plugin" {
  run grep -iE '\b(business[- ]owner|frontend[- ]developer|qa[- ]engineer|release[- ]manager|consistency[- ]auditor|delivery[- ]lead)\b' "$ROLES_CATALOG"
  [ "$status" -ne 0 ]
}
