#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
printf '{"tool_input":{"command":"git status"}}' | "$root/hooks/pretooluse-block-dangerous-git.sh"
printf '{"tool_input":{"command":"git diff -- README.md"}}' | "$root/hooks/pretooluse-block-dangerous-git.sh"
if printf '{"tool_input":{"command":"git reset --hard HEAD"}}' | "$root/hooks/pretooluse-block-dangerous-git.sh" 2>/tmp/ck_git.err; then echo expected block >&2; exit 1; fi
if printf '{"tool_input":{"command":"git push --force origin main"}}' | "$root/hooks/pretooluse-block-dangerous-git.sh" 2>/tmp/ck_git.err; then echo expected block >&2; exit 1; fi
printf '{"tool_input":{"command":"echo ok"}}' | "$root/hooks/pretooluse-secret-guard.sh"
if printf '{"tool_input":{"command":"cat .env"}}' | "$root/hooks/pretooluse-secret-guard.sh" 2>/tmp/ck_secret.err; then echo expected block >&2; exit 1; fi
echo hook tests passed
