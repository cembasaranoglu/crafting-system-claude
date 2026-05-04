# Crafting Kit Integration Guide

This guide explains how to integrate the global risk gate and execution control layer into the existing staged prompt system.

## Objective

The goal is to prevent premature execution across all workflows, not only coding. The system must gate analysis, architecture, repository creation, code authoring, testing, Kubernetes/runtime work, prompt-pack generation, packaging, git operations, database actions, deployment actions, and external system actions.

## Integration order

Load prompts in this order:

1. `prompts/00_base_prompt.md`
2. `prompts/01_global_risk_gate.md`
3. `prompts/02_intent_stage_router.md`
4. `prompts/04_assumption_ban_contract.md`
5. selected stage prompt
6. `prompts/03_research_need_gate.md` if required
7. `prompts/70_execution_control.md` if execution/tool action is required
8. `prompts/71_tool_permission_policy.md` before tool use
9. `prompts/72_human_approval_protocol.md` if approval required
10. `prompts/73_validation_and_reporting_gate.md` after execution or when validation claims are made

## Runtime placement

The execution stage must not be placed only after the code stage. It is a global mandatory gate used by any stage that wants to act.

Examples:

- Architecture stage uses execution only when creating files/zips.
- Repository stage uses execution when creating skeleton files.
- Code stage uses execution for file edits, commands, dependency changes, git actions.
- Testing stage uses execution when writing tests or running test commands.
- Kubernetes stage uses execution when generating or applying manifests.
- Runner stage uses execution when creating prompt-pack files or zips.

## Plugin runtime components

Implement these components in the plugin/runtime layer:

```text
User Request
 -> Intent Router
 -> Source/Evidence Intake
 -> Assumption Ban Gate
 -> Research Gate
 -> Process Risk Scorer
 -> Stage Selector
 -> Execution Classifier
 -> Execution Risk Scorer
 -> Tool Permission Layer
 -> Approval Layer
 -> Execution Runner
 -> Validation Reporter
```

## Permission model

Do not rely only on prompt instructions.

The plugin should enforce:

- path allowlist
- protected path denylist
- command classifier
- network access checks
- secret scanning
- destructive command blocking
- approval enforcement
- sandbox/dry-run where possible
- audit log of actions and decisions

## Recommended default behavior

```yaml
default_mode: PLAN_AND_GATE
execution_default: deny_unless_classified
assumption_policy: no_execution_from_assumption
risk_threshold_for_auto_execution: execution_risk < 40 and process_risk < 40
high_risk_policy: require_explicit_approval
critical_risk_policy: stop
research_policy: source_first_official_docs_first
minimum_input_policy: ask_only_blocking_fields
validation_policy: claim_only_what_was_verified
```

## Human approval integration

Support either:

1. Text approval using the exact phrase from the approval request.
2. UI approval event that records the approved action, target, risk, and timestamp.

Approval must be scoped. It should expire if the command/action/path/resource changes.

## Audit log recommendation

Record for every execution decision:

```yaml
audit_event:
 request_id: ""
 timestamp: ""
 user_intent: ""
 active_stage: ""
 execution_class: ""
 process_risk_score: 0
 execution_risk_score: 0
 decision: ""
 approval_required: "yes | no"
 approval_received: "yes | no | not_required"
 tools_called: []
 affected_paths_or_resources: []
 validations_run: []
 final_status: ""
```

## Safe failure mode

When uncertain, the system should choose the safest of:

1. read-only inspection
2. research first
3. ask minimum input
4. plan only
5. approval request
6. stop blocked

It should not choose blind execution.
