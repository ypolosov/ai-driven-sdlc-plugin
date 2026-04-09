#!/bin/bash
set -euo pipefail

input=$(cat)
project_dir="${CLAUDE_PROJECT_DIR:-.}"

has_vision=false
has_requirements=false
has_architecture=false

[ -f "$project_dir/docs/vision.md" ] || [ -f "$project_dir/VISION.md" ] && has_vision=true
[ -f "$project_dir/docs/requirements.md" ] || [ -f "$project_dir/REQUIREMENTS.md" ] && has_requirements=true
[ -f "$project_dir/docs/architecture.md" ] || [ -f "$project_dir/ARCHITECTURE.md" ] && has_architecture=true

echo "{\"vision\": $has_vision, \"requirements\": $has_requirements, \"architecture\": $has_architecture}"
exit 0
