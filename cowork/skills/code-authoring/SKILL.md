---
name: code-authoring
description: Bounded code authoring and editing with source-first analysis, risk and execution gates, and validation truth. Use when the user asks to write, edit, refactor, or fix code in a repository.
---

# code-authoring

Apply this skill for any explicit code-writing or code-editing request.

Required gate sequence before any file mutation:

1. Risk classification.
2. Intent and stage routing.
3. No-assumption contract.
4. Execution control.
5. Tool permission policy.
6. Human approval when the change is destructive.
7. Secret-aware behavior when credentials may be touched.

Authoring contract:

- Inspect the actual repository, language, framework, conventions, and existing tests before writing.
- Stay inside the requested scope. Do not silently refactor unrelated code, change deps, or touch generated files.
- Prefer minimal diffs unless a refactor is explicitly authorized.
- Write or update tests when behavior changes.
- Cite the source paths you read and the diffs you produced.
- Run validators that exist in the repo (lint, test, build, type-check); report each command and pass or fail.
- Never claim validation that did not actually run.

Diff-mode and patch-mode:

- Surgical edits → minimal-patch mode.
- Large changes → reduce diff first, classify risk, then proceed in slices.

Refactor flows:

- Pair with refactor-strict for planning. Execute only the bounded slice that was approved.

Hard stops:

- Destructive Git or release operation requested → escalate for human approval.
- Apparent secret value in code or input → switch to secret-aware credential handling.
- Implementation cannot be done without source the user did not provide → return a minimum-input request instead of guessing.

Output:

- Exact file paths changed.
- Behavior changed.
- Tests added or updated.
- Validation run (exact commands and exit status).
- Validation not run (with reason).
- Assumptions, blockers, and rollback notes.
