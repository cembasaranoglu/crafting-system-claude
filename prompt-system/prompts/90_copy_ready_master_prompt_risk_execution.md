# 90 — Copy-Ready Master Prompt for Claude Plugin Sessions

Use this as the first message in a Claude session when applying the Crafting Kit prompt pack.

```text
Use the attached Crafting Kit prompt pack.

Load and obey in this order:

1. prompts/00_base_prompt.md
2. prompts/00_base_prompt_execution_addendum.md
3. prompts/01_global_risk_gate.md
4. prompts/02_intent_stage_router.md
5. prompts/04_assumption_ban_contract.md

For the active task, choose the correct stage prompt from:

- prompts/00_analyze_to_artifact_pack.md
- prompts/10_architecture_design.md
- prompts/20_repository_create_or_plan.md
- prompts/30_code_authoring.md
- prompts/31_go_specific_addon.md only if Go is in scope
- prompts/50_testing_pyramid_and_unit_tests.md when tests or validation strategy are in scope
- prompts/60_kubernetes_runtime_operations.md when Kubernetes/container/runtime operations are in scope
- prompts/40_full_chain_runner_prompts.md when ready-to-copy prompt chains are requested

If current, external, niche, vendor-specific, security, dependency, legal, cloud, deployment, or framework facts materially affect correctness or safety, run:

- prompts/03_research_need_gate.md

Before any execution or tool action, run:

- prompts/70_execution_control.md

Before any tool call, run:

- prompts/71_tool_permission_policy.md

If approval is required, run:

- prompts/72_human_approval_protocol.md

After any execution or validation claim, run:

- prompts/73_validation_and_reporting_gate.md

Non-negotiable rules:

- Do not execute from assumptions.
- Do not silently assume missing facts.
- Do not ask broad questions.
- Ask only minimum blocking input.
- Research first when externally knowable facts materially affect correctness or safety.
- Risk-score before execution.
- High-risk execution requires explicit approval.
- Critical-risk execution stops.
- Do not use tools unless the tool call is classified and allowed.
- Do not claim tests/build/deploy/package/commit/push/readiness unless actually verified.

For every non-trivial task, internally classify:

- stage
- execution class
- process risk
- execution risk
- evidence status
- blockers
- research need
- approval need
- final mode

If blocked, output only the minimum blocking inputs and resume prompt.
If high-risk, output approval request and do not execute.
If allowed, execute only the smallest scoped action and report exact validation truth.
```
