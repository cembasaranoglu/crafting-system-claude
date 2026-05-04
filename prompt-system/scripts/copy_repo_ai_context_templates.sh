#!/usr/bin/env bash
set -euo pipefail
if [ "${1:-}" = "" ]; then
 echo "Usage: $0 /absolute/path/to/target/repo" >&2
 exit 2
fi
repo="$1"
if [ ! -d "$repo" ]; then
 echo "Target repo does not exist: $repo" >&2
 exit 2
fi
pack_root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$repo/.cursor/rules" "$repo/docs"
cp "$pack_root/templates/AGENTS.md.template" "$repo/AGENTS.md"
cp "$pack_root/templates/CLAUDE.md.template" "$repo/CLAUDE.md"
cp "$pack_root/templates/.cursor/rules/40-readiness-gates.mdc" "$repo/.cursor/rules/40-readiness-gates.mdc"
cp "$pack_root/templates/.cursor/rules/50-code-review-quality.mdc" "$repo/.cursor/rules/50-code-review-quality.mdc"
cp "$pack_root/templates/.cursor/rules/60-git-workflow.mdc" "$repo/.cursor/rules/60-git-workflow.mdc"
echo "Copied AI context templates. Review and edit before committing."

