# CLAUDE.md

This repository uses Crafting Kit conventions for Claude Code work.

## Required behavior

- Inspect source before claims.
- Keep changes scoped.
- Separate facts, assumptions, blockers, and validation truth.
- Do not access or expose real secrets.
- Do not run destructive commands without explicit approval.
- Update tests/docs/config/schema when user-facing behavior changes.

## Validation commands

Replace with repository-specific commands.

```bash
# lint
# test
# build
```

## Forbidden paths and actions

- `.env`, `.env.*`, private keys, local credentials, generated secrets
- destructive Git without explicit approval
- production deployment without explicit approval
