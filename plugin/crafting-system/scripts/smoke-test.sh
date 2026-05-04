#!/usr/bin/env bash
set -euo pipefail
plugin_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$plugin_root/scripts/validate-plugin.sh"
bash "$plugin_root/scripts/test-hooks.sh"
bash "$plugin_root/scripts/test-secret-scan.sh"
bash "$plugin_root/scripts/package-plugin.sh" /tmp/crafting-system-plugin.zip >/tmp/crafting_plugin_package.log
unzip -t /tmp/crafting-system-plugin.zip >/dev/null
echo "plugin smoke test passed"
