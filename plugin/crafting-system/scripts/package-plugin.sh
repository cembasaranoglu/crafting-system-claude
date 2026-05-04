#!/usr/bin/env bash
set -euo pipefail
out="${1:-/tmp/crafting-system-plugin.zip}"; root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; rm -f "$out"
(cd "$root" && zip -qr "$out" . -x '*.zip' '*/.DS_Store' '*/__MACOSX/*' '.git/*' '*.log' '.env' '.env.*' '*.pem' '*.key' '*.p12' '*.pfx' 'secrets/*' 'tmp/*' 'cache/*')
unzip -t "$out" >/dev/null
printf 'created %s
' "$out"
