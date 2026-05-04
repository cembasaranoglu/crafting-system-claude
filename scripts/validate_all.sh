#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
PYTHON_BIN="${PYTHON_BIN:-python3}"
"$PYTHON_BIN" scripts/validate_all.py
bash plugin/crafting-system/scripts/test-hooks.sh
bash plugin/crafting-system/scripts/test-secret-scan.sh
echo "validate_all passed"
