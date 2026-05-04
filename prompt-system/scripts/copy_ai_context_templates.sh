#!/usr/bin/env bash
set -euo pipefail

# Copy Claude/Cursor AI-ready templates into a target repository.
# Usage:
# ./scripts/copy_ai_context_templates.sh /absolute/path/to/repo
#
# Review all copied files before committing.

if [ "$#" -ne 1 ]; then
 echo "usage: $0 /absolute/path/to/repo" >&2
 exit 2
fi

target="$1"
if [ ! -d "$target" ]; then
 echo "target repo does not exist: $target" >&2
 exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pack_root="$(cd "$script_dir/.." && pwd)"

copy_file() {
 src="$1"
 dst="$2"
 mkdir -p "$(dirname "$dst")"
 if [ -e "$dst" ]; then
 echo "skip existing: $dst"
 else
 cp "$src" "$dst"
 echo "created: $dst"
 fi
}

copy_file "$pack_root/templates/CLAUDE.md.template" "$target/CLAUDE.md"
copy_file "$pack_root/templates/docs/AI_CONTEXT.md.template" "$target/docs/AI_CONTEXT.md"
copy_file "$pack_root/templates/docs/PROJECT_GLOSSARY.md.template" "$target/docs/PROJECT_GLOSSARY.md"
copy_file "$pack_root/templates/docs/FEATURE_INVENTORY.md.template" "$target/docs/FEATURE_INVENTORY.md"
copy_file "$pack_root/templates/docs/QUESTION_ROUTING_MAP.md.template" "$target/docs/QUESTION_ROUTING_MAP.md"

# Claude templates
for src in "$pack_root"/templates/.claude/skills/*/SKILL.md; do
 rel="${src#"$pack_root/templates/"}"
 copy_file "$src" "$target/$rel"
done
for src in "$pack_root"/templates/.claude/agents/*.md "$pack_root"/templates/.claude/settings.example.json; do
 rel="${src#"$pack_root/templates/"}"
 copy_file "$src" "$target/$rel"
done

# Cursor templates
for src in "$pack_root"/templates/.cursor/rules/*.mdc; do
 rel="${src#"$pack_root/templates/"}"
 copy_file "$src" "$target/$rel"
done

cat <<'NOTE'

Next steps:
1. Review every copied file.
2. Replace placeholders with repository-specific facts.
3. Do not commit secrets or personal AI chat/session artifacts.
4. Run your normal docs/test checks.
NOTE
