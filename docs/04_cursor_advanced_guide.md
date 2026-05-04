# Cursor Advanced Guide

Crafting Kit treats Cursor as an agent harness with instructions, tools, model selection, context, plan mode, rules, skills, and review workflow.

## Recommended Cursor assets

For target repositories, generate:

```text
AGENTS.md
.cursor/rules/00-crafting-kit-core.mdc
.cursor/rules/10-source-first-analysis.mdc
.cursor/rules/20-code-quality.mdc
.cursor/rules/30-secret-aware-execution.mdc
.cursor/rules/40-git-safety.mdc
.cursor/rules/50-validation-reporting.mdc
docs/ai/context-map.md
docs/ai/validation-command-catalog.md
docs/ai/repository-map.md
```

Use `161_cursor_advanced_rules_prompt.md` to generate these from real repository evidence.

## Rule placement

- Put cross-agent setup commands and test commands in `AGENTS.md`.
- Put always-on minimal operating constraints in `00-crafting-kit-core.mdc`.
- Put file-specific conventions in `.mdc` files with globs.
- Put long explanations in `docs/ai/*`, then reference them from rules.
- Avoid duplicating the same instruction in every rule.

## Plan mode guidance

Use planning for:

- multi-file changes
- refactors
- data migrations
- deployment changes
- security-sensitive changes
- Git/release operations
- changes touching public APIs or schemas

A good plan should include source findings, affected paths, non-scope, validation commands, risk level, rollback notes, and approval points.

## Cursor safety defaults

Rules should block or require explicit approval for:

- real secret access
- `.env` reads
- destructive Git commands
- force pushes
- database deletes/truncates/migrations
- deployment and production actions
- dependency upgrades without review
- generated file edits without generator source changes
- large rewrites without diff/risk review

## Agent review pattern

Use Cursor for iteration, but require human review for:

- security controls
- auth/authz
- persistence changes
- migrations
- public contracts
- production config
- release artifacts
- destructive actions
- high-risk refactors

## Crafting Kit prompts for Cursor

- `103_ai_context_compiler_claude_agents_cursor_llms.md`
- `105_agents_md_generator.md`
- `106_cursor_rules_generator.md`
- `107_llms_txt_generator.md`
- `161_cursor_advanced_rules_prompt.md`
- `158_secret_and_runtime_credentials.md`
- `27_git_commit_branch_push_workflow.md`
