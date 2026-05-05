# 72 — Human Approval Protocol Prompt

Shared prerequisite: Load `prompts/70_execution_control.md` first.

Use this prompt whenever execution requires explicit human approval.

## Approval must be explicit

Do not treat vague consent as approval.

Accepted examples:

- `Approve this execution.`
- `I approve the described git push.`
- `I approve running the listed migration against staging.`

Rejected examples:

- `ok`
- `sure`
- `go on`
- `do it`
- `continue`

Unless the plugin explicitly maps a UI approval button to a verified approval event.

## Approval request content

Approval request must include:

- exact action
- execution class
- target root/resource
- affected files/resources
- expected side effects
- risk score
- rollback/recovery plan
- validation plan
- what will not be done
- exact approval phrase

## Approval scope

Approval is scoped. It does not grant blanket permission.

Approval expires when:

- the requested action changes
- target paths/resources change
- new risk appears
- command changes
- external system changes
- validation plan changes
- more than one stage boundary is crossed

## Approval request template

```yaml
approval_request:
 action_requiring_approval: ""
 execution_class: ""
 active_stage: ""
 target_root_or_resource: ""
 affected_paths_or_resources: []
 expected_side_effects: []
 process_risk_score: 0
 execution_risk_score: 0
 why_approval_is_required: ""
 rollback_or_recovery_plan: ""
 validation_plan_after_approval: []
 not_in_scope: []
 exact_approval_phrase: "Approve this execution."
```
