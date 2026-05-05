# 31 — Pull Request Review, PR Body, and Merge Gate Prompt

Shared prerequisite: load and obey `prompts/00_claude_base_prompt.md`.

Use this prompt after code review or before opening/merging a PR. It produces a PR-ready summary, risk register, validation truth, reviewer notes, and merge/no-merge gate.

## Required workflow

1. Inspect branch/diff/status.
2. Identify user-facing changes.
3. Identify compatibility, migration, security, docs, and ops impacts.
4. Check tests/validation evidence.
5. Produce PR title/body using the repository convention if present.
6. Produce merge gate decision.

## PR body format

```md
## Summary

## Why

## What changed

## Validation

## Risk and rollback

## Compatibility / migration impact

## Security / privacy impact

## Docs / examples impact

## Reviewer checklist
```

## Merge gate labels

- `ready_for_review`
- `ready_to_merge`
- `merge_with_accepted_risk`
- `needs_changes`
- `blocked`

## Required output files

1. `pr_readiness.md`
2. `pr_title_options.md`
3. `pr_body.md`
4. `merge_gate.md`
5. `reviewer_checklist.md`
6. `run_summary.md`

