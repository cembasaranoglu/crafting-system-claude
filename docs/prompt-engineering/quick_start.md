# 00 — Quick Start

Use this sequence when designing a Claude prompt, Claude Code skill, or Claude Code plugin.

## A. For a new prompt system

1. Open `templates/prompt_spec.yaml` and fill the task type, user, desired output, risks, inputs, tools, and validation criteria.
2. Paste `prompts/00_claude_base_operating_contract.md` into Claude as the base operating contract.
3. Paste `prompts/01_prompt_system_designer.md` and provide the filled prompt spec.
4. Ask Claude to produce a versioned prompt package with:
 - operating contract
 - mode definitions
 - risk gate
 - source-first rules
 - output schemas
 - examples
 - evaluation plan
5. Run `prompts/04_prompt_tuning_and_eval_runner.md` against sample cases before using the prompt in production-like workflows.

## B. For a Claude Code plugin

1. Fill `templates/plugin_spec.yaml`.
2. Read `docs/03_claude_code_plugin_best_practices.md`.
3. Use `prompts/02_plugin_architect.md` to design the plugin structure.
4. Start with standalone `.claude/skills/` if it is project-only or experimental.
5. Convert to plugin when it must be shared, versioned, reused across projects, or distributed.
6. Test locally with `claude --plugin-dir ./plugin-name` before sharing.

## C. For tuning an existing prompt

1. Define success criteria and failure examples before editing the prompt.
2. Create a small eval set with normal, edge, adversarial, and regression cases.
3. Run the current prompt and record failures.
4. Tune one dimension at a time: clarity, examples, XML structure, output schema, tool-use rules, effort/thinking, context layout, or safety gates.
5. Re-run the eval matrix.
6. Keep a changelog of prompt revisions.

## D. For high-risk tasks

Use `prompts/03_risk_gate_controller.md` and `docs/05_risk_gate_and_boundary_strategy.md`.

High-risk tasks include:

- destructive repository or filesystem operations
- credential, auth, or security-sensitive work
- production deployment or shared infrastructure
- medical, legal, financial, or compliance-sensitive decisions
- actions visible to other people, such as messages, PR comments, releases, or push operations
- ambiguous requests where a wrong assumption would cause material harm

The default behavior for high-risk tasks is: inspect sources, classify risk, stop or ask for the minimum missing input, and never claim validation that was not run.
