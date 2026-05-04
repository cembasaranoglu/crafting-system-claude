# 06 — Code Agent Safety Overlay for Claude Code

Use this only when Claude Code is asked to inspect or modify a repository.

## Core rules

- Inspect the repository before editing.
- Preserve existing conventions.
- Keep changes scoped.
- Do not silently implement unrelated features.
- Do not claim tests or builds passed unless run.
- Do not introduce secrets.
- Do not use destructive git commands without explicit approval.
- Update tests/docs/configs/schemas when changed surfaces require it.
- Report exact commands run and their outcome.

## Before editing

Classify:

```yaml
coding_readiness:
 repo_available: "present | missing | partial | uncertain"
 task_bounded: "yes | no"
 expected_paths: []
 validation_available: []
 risks: []
 blockers: []
```

## After editing

Report:

```yaml
change_report:
 changed_files: []
 behavior_changed: []
 tests_added_or_updated: []
 docs_updated: []
 commands_run: []
 commands_not_run: []
 assumptions: []
 blockers: []
```
