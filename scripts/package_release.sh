#!/usr/bin/env bash
set -euo pipefail
out="/tmp/crafting-kit-release.zip"; if [ "${1:-}" = "--out" ]; then out="$2"; shift 2; fi
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$root"; rm -f "$out"
zip -qr "$out" . -x '*.zip' '*/.DS_Store' '*/__MACOSX/*' '.git/*' '*.log' '.env' '.env.*' '*.pem' '*.key' '*.p12' '*.pfx' 'secrets/*' 'tmp/*' 'cache/*' 'artifact_inventory.json'
unzip -t "$out" >/dev/null
sha256sum "$out" > /tmp/crafting-kit-release.zip.sha256
printf 'created %s
' "$out"
