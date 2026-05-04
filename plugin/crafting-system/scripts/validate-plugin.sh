#!/usr/bin/env bash
set -euo pipefail
plugin_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
jq empty "$plugin_root/.claude-plugin/plugin.json"
jq empty "$plugin_root/.mcp.example.json"
jq empty "$plugin_root/hooks/hooks.json.example"
for f in "$plugin_root"/hooks/*.sh "$plugin_root"/scripts/*.sh; do
  [ -x "$f" ] || { echo "$f is not executable" >&2; exit 1; }
done
for f in "$plugin_root"/skills/*/SKILL.md "$plugin_root"/agents/*.md; do
  [ -f "$f" ] || continue
  first="$(sed -n '1p' "$f")"
  second_delim_count="$(sed -n '2,20p' "$f" | grep -c '^---$' || true)"
  if [ "$first" != "---" ] || [ "$second_delim_count" -lt 1 ]; then
    echo "invalid frontmatter: ${f#$plugin_root/}" >&2
    exit 1
  fi
done
echo "plugin validation passed"
