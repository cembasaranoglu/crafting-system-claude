# Claude Tuning Playbook

This playbook translates current Claude and Claude Code guidance into Crafting Kit conventions.

## Tune only after defining success criteria

Before editing a prompt, define:

- target task
- desired output format
- unacceptable outputs
- source material required
- tool permissions
- validation commands
- eval fixtures
- golden outputs or review checklist

Prompt engineering is not the right fix for every failure. Some failures are caused by model choice, missing context, unavailable tools, missing tests, or unsafe permissions.

## Claude-specific prompt practices

Use:

- clear task boundaries
- stable role and objective sections
- XML-style sections for complex prompts
- concrete output schemas
- examples for style and structure
- explicit source precedence
- explicit uncertainty handling
- self-check criteria before final output
- tool-use instructions that say whether Claude should suggest, edit, run, or only plan

Avoid:

- mixing analysis, architecture, code, and release in one prompt
- asking for broad work without success criteria
- burying stop conditions in prose
- requesting validation claims without commands
- overloading `CLAUDE.md` with every instruction
- storing secrets or local runtime values in prompts

## Effort, thinking, and task shape

For complex coding, repo analysis, multi-step architecture, long-horizon agentic work, and tool-heavy tasks, use higher reasoning/effort settings where the interface supports them. For small latency-sensitive edits, use scoped prompts and smaller context.

The prompt should not force excessive step-by-step reasoning for every task. Use stage gates, output schemas, and self-checks to focus reasoning. For source-heavy work, ask Claude to inspect source material before answering and to separate facts from assumptions.

## Context strategy

Treat context as finite. Keep reusable, stable instructions in:

- `CLAUDE.md`
- plugin skills
- subagents
- `AGENTS.md`
- `.cursor/rules/*.mdc`
- `docs/ai/context-map.md`
- generated repository intelligence artifacts

Avoid sending the full prompt pack for every request. Load only the base, risk/secret/execution prompts when needed, and the one stage prompt relevant to the current task.

## Tool strategy

Be explicit about whether Claude should:

- analyze only
- create files
- edit repository files
- run commands
- package artifacts
- create commits
- push branches
- create PRs
- deploy

Execution is not implied by a high-level outcome. Execution must pass risk and permission gates.

## Prompt testing strategy

Every important prompt should have:

- minimum positive fixture
- complex positive fixture
- missing-input fixture
- contradiction fixture
- unsafe request fixture
- secret-bearing fixture
- output-schema golden file
- validation-claim negative test

Use `97_prompt_test_harness.md`, `98_prompt_regression_suite.md`, and `99_golden_output_validation.md` for this work.

## Skill design strategy

Skills should be small, discoverable, and scoped. The description should explain when to use the skill because Claude uses it for skill selection. Put heavy reference material in supporting docs and keep `SKILL.md` focused.

## Source basis

This playbook is aligned with current Claude documentation on prompt best practices, Claude Code skills, plugins, subagents, MCP, GitHub Actions, and cost/context management. See `docs/source_basis.md` for URLs and source notes.
