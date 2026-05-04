# Source Basis and Scope

This pack was built from two source categories.

## Official / current Claude sources consulted

Access date: 2026-05-04.

- Anthropic / Claude prompt engineering overview: `https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview`
- Anthropic / Claude prompting best practices: `https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices`
- Anthropic / Console prompting tools: `https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-tools`
- Anthropic / Tool use with Claude: `https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview`
- Anthropic / Prompt caching: `https://platform.claude.com/docs/en/build-with-claude/prompt-caching`
- Anthropic / Extended thinking: `https://platform.claude.com/docs/en/build-with-claude/extended-thinking`
- Claude Code / Skills: `https://code.claude.com/docs/en/skills`
- Claude Code / Plugins: `https://code.claude.com/docs/en/plugins`
- Claude Code / MCP: `https://code.claude.com/docs/en/mcp`
- Claude Code / Subagents: `https://code.claude.com/docs/en/sub-agents`
- Claude Code / Cost and context: `https://code.claude.com/docs/en/costs`

## Local project prompt sources used as design inputs

The current project prompt pack already includes a staged delivery model with base, analyze, architecture, repository, code, Go, testing, Kubernetes, and runner stages. It also includes truthfulness, source-first, no fabricated validation, no wrapper-root, repository discipline, code quality, and test pyramid rules. This artifact pack adapts that discipline to Claude prompt and plugin design.

Local sources inspected from the current project upload include:

- `00_base_prompt.md`
- `00_analyze_to_artifact_pack.md`
- `10_architecture_design.md`
- `20_repository_create_or_plan.md`
- `30_code_authoring.md`
- `31_go_specific_addon.md`
- `40_full_chain_runner_prompts.md`
- `50_testing_pyramid_and_unit_tests.md`
- `60_kubernetes_runtime_operations.md`
- `stage_manifest.yaml`
- `code_architecture_repository_rules_do_not_modify.md`
- `go_specific_rules_do_not_modify.md`
- `minimum_user_input_request.md`

## Scope of this pack

This pack focuses on prompt engineering, prompt operations, Claude Code skills, Claude Code plugins, Claude Code subagents, MCP-facing strategy, risk gates, and prompt tuning/evaluation. It does not implement an MCP server, ship a production plugin marketplace, or validate behavior inside a live Claude Code runtime.

## Known limitations

- Claude documentation changes frequently. Re-check official docs before distributing this pack outside your own workflow.
- The plugin skeleton intentionally avoids broad `allowed-tools` defaults. Tool permissions should be added only after review.
- The pack is not an official Anthropic artifact.
- Runtime validation of Claude Code commands was not performed in this environment.
