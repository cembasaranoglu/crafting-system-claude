#!/usr/bin/env bash
set -euo pipefail
input="$(cat || true)"
path="$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
if [ -z "$path" ]; then path="$(printf '%s' "$input" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"; fi
[ -z "$path" ] && exit 0
case "$path" in *.env|*.env.*|*.pem|*.key|*.p12|*.pfx|secrets/*)
  echo "Blocked by Crafting Kit post-write guard: protected secret-bearing path." >&2; exit 2;; esac
[ -f "$path" ] || exit 0
if grep -Eiq -- '-----BEGIN [A-Z0-9 ]*PRIVATE KEY-----' "$path"; then
  echo "Blocked by Crafting Kit post-write guard: private key material detected." >&2; exit 2
fi
if grep -Eiq -- '(^|[^A-Za-z0-9_])(postgres|postgresql|mysql|mongodb(\+srv)?|redis)://[^[:space:]/:@]+:[^[:space:]@]+@' "$path"; then
  echo "Blocked by Crafting Kit post-write guard: credentialed connection string detected." >&2; exit 2
fi
matches="$(grep -Eini -- '(^|[^A-Za-z0-9_])(api[_-]?key|token|secret|password|private[_-]?key|database_url|aws_access_key_id)[[:space:]]*[:=][[:space:]]*[^[:space:]#]{6,}' "$path" || true)"
if [ -n "$matches" ] && ! printf '%s\n' "$matches" | grep -Eiq -- '(<[^>]*(KEY|TOKEN|SECRET|PASSWORD|DSN|URL)[^>]*>|\$\{[^}]+\}|changeme|change[-_ ]?me|example|dummy|placeholder|redacted|xxxx|\*\*\*)'; then
  echo "Blocked by Crafting Kit post-write guard: key/value secret pattern detected." >&2; exit 2
fi
exit 0
