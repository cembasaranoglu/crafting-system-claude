# ADR-0004 — Enforce Tool Permissions Outside the Prompt

## Status

Accepted

## Context

Prompt instructions alone cannot reliably prevent unsafe tool calls. Shell commands can bypass file-tool restrictions, package managers can run lifecycle scripts, and remote commands can mutate external systems.

## Decision

Add `prompts/71_tool_permission_policy.md` and `policies/tool_permission_policy.yaml`.

The plugin/runtime should enforce:

- default deny unless classified
- path allowlist
- protected path denylist
- command classification
- approval for git/dependency/database/deployment/destructive actions
- secret read denial by default
- audit logging

## Consequences

Positive:

- Safer than prompt-only control.
- Makes approvals auditable.
- Prevents unsafe action even if model proposes it.

Negative:

- Requires runtime engineering.
- Command classification may need platform-specific handling.
