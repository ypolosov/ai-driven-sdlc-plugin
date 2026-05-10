#!/usr/bin/env bats

setup() {
  ROOT="$(git rev-parse --show-toplevel)"
  EXT_DIR="$ROOT/meta-templates/external-systems"
}

@test "external-systems directory exists" {
  [ -d "$EXT_DIR" ]
}

@test "issue-tracker.jira.md reference exists" {
  [ -f "$EXT_DIR/issue-tracker.jira.md" ]
}

@test "knowledge-base.confluence.md reference exists" {
  [ -f "$EXT_DIR/knowledge-base.confluence.md" ]
}

@test "vcs.bitbucket.md reference exists" {
  [ -f "$EXT_DIR/vcs.bitbucket.md" ]
}

@test "observability.grafana.md reference exists" {
  [ -f "$EXT_DIR/observability.grafana.md" ]
}

@test "cd-platform.argocd.md reference exists" {
  [ -f "$EXT_DIR/cd-platform.argocd.md" ]
}

@test "all references have correct frontmatter type" {
  for f in "$EXT_DIR"/*.md; do
    grep -q '^type: external-system-reference' "$f" || {
      echo "missing frontmatter type in: $f"
      false
    }
  done
}

@test "all references declare category and tool" {
  for f in "$EXT_DIR"/*.md; do
    grep -q '^category:' "$f"
    grep -q '^tool:' "$f"
  done
}

@test "all references declare install_command and env_vars sections" {
  for f in "$EXT_DIR"/*.md; do
    grep -qE '^## (Установка|Install)' "$f"
    grep -qE '^## (Env|Переменные)' "$f"
  done
}

@test "method-tool-matrix references at least 3 external-systems files" {
  count=$(grep -cE 'external-systems/[a-z][a-z0-9.\-]+\.md' "$ROOT/catalogs/method-tool-matrix.md" || true)
  [ "$count" -ge 3 ]
}
