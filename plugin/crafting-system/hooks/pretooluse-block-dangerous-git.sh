#!/usr/bin/env bash
set -euo pipefail
input="$(cat || true)"
cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
if [ -z "${cmd}" ] && [ "${1:-}" ]; then cmd="$*"; fi
norm="$(printf '%s' "$cmd" | tr '\n\r\t' '   ')"
case "$norm" in
  *"git reset --hard"*|*"git clean -fd"*|*"git clean -xdf"*|*"git push --force"*|*"git push -f"*|*"git push --mirror"*)
    echo "Blocked by Crafting Kit git guard: destructive or force-push git command requires explicit human approval outside this hook." >&2
    exit 2;;
esac
exit 0
