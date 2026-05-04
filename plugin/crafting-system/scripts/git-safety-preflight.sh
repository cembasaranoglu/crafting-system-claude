#!/usr/bin/env bash
set -euo pipefail
git status --short
git diff --stat || true
git status --short | awk '{print $2}' | grep -E '(^\.env|\.pem$|secret|token|credential|\.log$|tmp/)' || true
