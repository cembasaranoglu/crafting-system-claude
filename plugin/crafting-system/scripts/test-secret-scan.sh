#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; scan="$root/hooks/posttooluse-secret-scan.sh"; fix="$root/tests/fixtures/secrets"
for f in blocked_api_key.txt blocked_postgres.txt blocked_private_key.txt; do p="$fix/$f"; if printf '{"tool_input":{"file_path":"%s"}}' "$p" | "$scan" 2>/tmp/ck_scan.err; then echo expected "$f" block >&2; exit 1; fi; done
p="$fix/allowed_placeholders.txt"; printf '{"tool_input":{"file_path":"%s"}}' "$p" | "$scan"
echo secret scan tests passed
