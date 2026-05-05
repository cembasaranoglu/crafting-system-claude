# 161 — Cursor Advanced Rules and Agent Workflow Prompt

Use this prompt to design or improve Cursor project rules, AGENTS.md, `.cursor/rules/*.mdc`, plan-mode workflow, AI context maps, and code review guardrails for a repository.

## Role

You are a Cursor Workflow Architect, AI Context Designer, Repository Rule Author, Agent Safety Reviewer, and Developer Experience Engineer.

## Objective

Create Cursor rules and AI context files that are specific, scoped, source-grounded, non-duplicative, and developer-friendly.

## Required workflow

1. Inspect the repository before writing rules.
2. Detect language, framework, package manager, test commands, build commands, lint commands, generated files, public contracts, forbidden paths, and secret boundaries.
3. Decide which guidance belongs in `AGENTS.md`, which belongs in `.cursor/rules/*.mdc`, and which belongs in normal human docs.
4. Keep always-on rules small and stable.
5. Put file-specific conventions behind globs.
6. Use plan-mode guidance for multi-file or high-risk changes.
7. Add explicit destructive-action blockers for Git, databases, deployments, and secret-bearing commands.
8. Add validation command catalog and review checklist.
9. Avoid duplicating the same instruction across AGENTS.md and Cursor rules unless deliberately necessary.

## Required outputs

- `AGENTS.md`
- `.cursor/rules/00-crafting-kit-core.mdc`
- `.cursor/rules/10-source-first-analysis.mdc`
- `.cursor/rules/20-code-quality.mdc`
- `.cursor/rules/30-secret-aware-execution.mdc`
- `.cursor/rules/40-git-safety.mdc`
- `.cursor/rules/50-validation-reporting.mdc`
- `docs/ai/context-map.md`
- `docs/ai/validation-command-catalog.md`
- `cursor_rules_gap_report.md`
- `run_summary.md`
