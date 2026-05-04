#!/usr/bin/env bash
set -euo pipefail
input="$(cat || true)"
cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
if [ -z "${cmd}" ] && [ "${1:-}" ]; then cmd="$*"; fi
norm="$(printf '%s' "$cmd" | tr '\n\r\t' '   ')"
case "$norm" in
  *"cat .env"*|*"cat .env."*|*"printenv"*|*"kubectl get secret"*|*"aws configure list"*|*"security find-generic-password"*)
    echo "Blocked by Crafting Kit secret guard: command may expose secrets." >&2
    exit 2;;
esac
if printf '%s' "$norm" | grep -Eiq '(grep|rg|awk|sed).*(PASSWORD|TOKEN|DATABASE_URL|SECRET|PRIVATE_KEY|API[_-]?KEY)'; then
  echo "Blocked by Crafting Kit secret guard: search command may expose secret values." >&2
  exit 2
fi
exit 0
