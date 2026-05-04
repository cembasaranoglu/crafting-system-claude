# Prompt Usage Sequence

## Default sequence for any non-trivial request

```text
Load prompts/00_base_prompt.md
Load prompts/01_global_risk_gate.md
Load prompts/02_intent_stage_router.md
Load prompts/04_assumption_ban_contract.md
Route to stage-specific prompt
If current/external facts matter, load prompts/03_research_need_gate.md
If any execution/tool action is needed, load prompts/70_execution_control.md
If any tool call is needed, load prompts/71_tool_permission_policy.md
If approval is required, load prompts/72_human_approval_protocol.md
After execution or validation claim, load prompts/73_validation_and_reporting_gate.md
```

## Code task sequence

```text
00_base_prompt.md
01_global_risk_gate.md
02_intent_stage_router.md
04_assumption_ban_contract.md
30_code_authoring.md
31_go_specific_addon.md only if Go is detected or explicit
50_testing_pyramid_and_unit_tests.md if tests are in scope
70_execution_control.md before editing/running commands
71_tool_permission_policy.md before tools
73_validation_and_reporting_gate.md after edits/commands
```

## Repository creation sequence

```text
00_base_prompt.md
01_global_risk_gate.md
02_intent_stage_router.md
04_assumption_ban_contract.md
20_repository_create_or_plan.md
70_execution_control.md if CREATE_FILES or zip requested
71_tool_permission_policy.md before file writes or packaging
73_validation_and_reporting_gate.md after package verification
```

## Kubernetes sequence

```text
00_base_prompt.md
01_global_risk_gate.md
02_intent_stage_router.md
04_assumption_ban_contract.md
60_kubernetes_runtime_operations.md
03_research_need_gate.md if current Kubernetes/cloud behavior matters
70_execution_control.md before rendering/applying/running commands
72_human_approval_protocol.md before cluster mutation
73_validation_and_reporting_gate.md after render/dry-run/apply claim
```
