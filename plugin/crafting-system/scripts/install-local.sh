#!/usr/bin/env bash
set -euo pipefail
[ "$#" -eq 1 ] || { echo "Usage: $0 <destination-plugin-directory>" >&2; exit 2; }
mkdir -p "$1"
cp -R "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"/. "$1"/
echo "Copied crafting-system plugin to $1"
