# Contributing

Thanks for your interest in Crafting Kit. This is a strict, source-first prompt and plugin system, so contributions are reviewed against the same rules the prompts enforce on Claude.

## Non-negotiable rules

Every contribution must preserve:

- **Truth over apparent completeness.** If something wasn't run or wasn't validated, mark it `not run` or `failed`, not "done".
- **Source-first analysis.** Claims about behavior must reference real files, real diffs, real commands, or real artifact paths.
- **Explicit stage boundaries.** Don't merge analysis, design, code authoring, and execution into a single prompt or skill.
- **No fabricated validation.** Don't claim the suite passed unless it actually passed in the PR's run.
- **No real secrets** in prompts, tests, fixtures, docs, logs, artifacts, or commits. Use the placeholders in `plugin/crafting-system/tests/fixtures/secrets/allowed_placeholders.txt` style.
- **Execution gated by risk and approval.** Don't relax `154_execution_control.md`, `155_tool_permission_policy.md`, `156_human_approval_protocol.md`, or `158_secret_and_runtime_credentials.md` to make a flow easier.
- **Developer-friendly documentation.** Prefer concrete commands, exact paths, and observable behavior over marketing language.

## Workflow

1. Open an issue or proposal for substantial changes (new prompts, new skills/agents, new gates, breaking changes to manifests or schemas).
2. Branch from `main` with a descriptive name, e.g. `feat/prompt-160-claude-tuning` or `fix/plugin-frontmatter`.
3. Keep the change scoped and reviewable. Avoid bundling unrelated refactors.
4. Update the relevant manifests when prompts, skills, or agents change:
   - `prompt-system/prompt_manifest.yaml`
   - `prompt-system/skill_manifest.yaml`
   - `prompt-system/agent_manifest.yaml`
   - `prompt-system/prompt_to_skill_map.yaml`
   - `prompt-system/stage_manifest.yaml`
   - `prompt-system/PROMPT_INDEX.md` (regenerate via `scripts/render_prompt_index.py`)
5. Update `prompt-system/prompt_aliases.yaml` if you rename anything.
6. Update `docs/02_prompt_glossary_and_dependency_map.md` and `docs/08_developer_workflows.md` if user-facing flow changes.
7. Run validation locally — see below — and paste the truthful result into the PR.

## Local validation (required before PR)

```bash
# Static contract for prompts, manifests, frontmatter, schemas, hooks.
make validate
# or:
bash scripts/validate_all.sh

# Plugin-side gates.
bash plugin/crafting-system/scripts/validate-plugin.sh
bash plugin/crafting-system/scripts/smoke-test.sh
bash plugin/crafting-system/scripts/test-hooks.sh
bash plugin/crafting-system/scripts/test-secret-scan.sh
```

In the PR, report each command with its exit status. If something is `not run` (e.g. you don't have the Claude Code CLI installed and didn't run `claude --plugin-dir`), say so explicitly. Don't say "should pass".

## What changes need extra review

| Area | Required review |
|---|---|
| `prompts/150`–`158` (risk, execution, approval, secrets) | Maintainer review. Do not weaken gates to fix flakiness. |
| `policies/*.yaml`, `schemas/*.yaml` | Maintainer review. These are contracts. |
| `plugin/crafting-system/policies/secret_tool_policy.yaml` | Maintainer review. Adding allowlist entries needs justification. |
| `plugin/crafting-system/hooks/*.sh` | Maintainer review. Hooks must remain disabled-by-default. |
| `scripts/validate_*.py`, `scripts/check_*.py` | Maintainer review. Validators must not silently weaken. |
| Anything renaming a prompt ID | Update aliases, manifests, and `PROMPT_INDEX.md` together. |

## Adding a new prompt

1. Pick the next free ID (see `prompt-system/PROMPT_INDEX.md`). Avoid reusing IDs.
2. Place the file under `prompt-system/prompts/<id>_<short_name>.md`.
3. Follow the frontmatter and section conventions used in nearby prompts (`scripts/validate_frontmatter.py` and `scripts/lint_prompt_contracts.py` will check structure).
4. Add the entry to `prompt_manifest.yaml` with stage, status, and dependencies.
5. If the prompt is intended to be invoked as a Claude Code skill, also add it to `skill_manifest.yaml` and `prompt_to_skill_map.yaml`, and create the skill folder under `plugin/crafting-system/skills/<skill-name>/SKILL.md`.
6. Run `make validate`.

## Adding a new skill or agent

1. Skill: create `plugin/crafting-system/skills/<skill-name>/SKILL.md` with valid YAML frontmatter (title, description, invocation policy). The first line must be `---` — see `scripts/validate-plugin.sh` and `scripts/validate_frontmatter.py`.
2. Agent: create `plugin/crafting-system/agents/<agent-name>.md` with valid frontmatter and register it in `plugin/crafting-system/.claude-plugin/plugin.json` under `agents`.
3. Register the skill in `prompt-system/skill_manifest.yaml` and the agent in `prompt-system/agent_manifest.yaml`.
4. Run `bash plugin/crafting-system/scripts/validate-plugin.sh`.

## Commit style

Use Conventional Commits where practical:

```text
feat(prompt): add 160 claude tuning playbook prompt
fix(plugin): normalize skill frontmatter for code-quality-bar
chore(docs): refresh PROMPT_INDEX from manifest
docs(readme): reflect actual script and counts
```

## Pull request expectations

A PR description should include, at minimum:

- **Summary** — what changed and why, in plain English.
- **Changed files** — list with one-line per-file rationale.
- **Behavior changed** — observable change, or "none (docs/structural only)".
- **Tests / validation run** — exact commands and pass/fail.
- **Validation not run** — anything you couldn't run locally and why.
- **Assumptions** — anything that wasn't directly verified.
- **Blockers** — anything you need from a maintainer.
- **Rollback notes** — how to revert if something breaks.

## Reporting issues

Use GitHub issues (in your fork) for bug reports, feature requests, documentation gaps, and prompt/plugin improvement proposals. Do not include secrets, private repository contents, production logs, credentials, or customer data in public issues. For suspected vulnerabilities or exposed secrets, follow [`SECURITY.md`](SECURITY.md) instead of opening a public issue.
