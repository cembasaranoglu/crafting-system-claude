#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v claude >/dev/null 2>&1; then
 echo "claude CLI not found. Install Claude Code first, then run:" >&2
 echo " claude --plugin-dir ./plugin/crafting-system" >&2
 exit 1
fi
exec claude --plugin-dir ./plugin/crafting-system

