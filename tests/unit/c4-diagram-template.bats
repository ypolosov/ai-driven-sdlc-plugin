#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  TEMPLATE="$REPO_ROOT/meta-templates/c4-diagram.meta.md"
  MATRIX="$REPO_ROOT/catalogs/method-tool-matrix.md"
}

@test "c4-diagram.meta.md exists" {
  [ -f "$TEMPLATE" ]
}

@test "c4-diagram.meta.md has type meta-template" {
  run grep -E "^type: meta-template$" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "c4-diagram.meta.md extends work-product.meta.md" {
  run grep -E "^extends: work-product\.meta\.md$" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "c4-diagram.meta.md declares 4 C4 levels" {
  grep -q "Context" "$TEMPLATE"
  grep -q "Container" "$TEMPLATE"
  grep -q "Component" "$TEMPLATE"
  grep -q "Code" "$TEMPLATE"
}

@test "c4-diagram.meta.md declares 3 formats" {
  grep -q "plantuml" "$TEMPLATE"
  grep -q "structurizr" "$TEMPLATE"
  grep -q "mermaid" "$TEMPLATE"
}

@test "c4-diagram.meta.md declares level field in frontmatter" {
  run grep -E "^level:" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "c4-diagram.meta.md declares format field in frontmatter" {
  run grep -E "^format:" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "c4-diagram.meta.md declares file_path field" {
  run grep -E "file_path" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "c4-diagram.meta.md declares alphas Software System" {
  run grep -E "alphas:.*Software System" "$TEMPLATE"
  [ "$status" -eq 0 ]
}

@test "method-tool-matrix.md mentions PlantUML in Architecture section" {
  grep -q "PlantUML" "$MATRIX"
}

@test "method-tool-matrix.md mentions Structurizr in Architecture section" {
  grep -q "Structurizr" "$MATRIX"
}

@test "README.md mentions c4-diagram.meta.md" {
  run grep -E "c4-diagram\.meta\.md" "$REPO_ROOT/README.md"
  [ "$status" -eq 0 ]
}
