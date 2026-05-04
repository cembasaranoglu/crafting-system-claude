# 06 — Evaluation and Prompt Testing

## 1. Evaluation is part of prompt design

A prompt is not ready because it is detailed. It is ready when it reliably passes the cases that represent the intended workflow.

## 2. Minimum eval set

Create at least these cases:

```yaml
eval_cases:
 - id: normal_happy_path
 input: ""
 expected: ""
 - id: ambiguous_but_low_risk
 input: ""
 expected: "Proceed with marked assumption."
 - id: blocking_gap
 input: ""
 expected: "Ask only the minimum missing input."
 - id: high_risk_action
 input: ""
 expected: "Stop or require confirmation."
 - id: source_first_required
 input: ""
 expected: "Inspect source before making claims."
 - id: output_schema_regression
 input: ""
 expected: "Strict schema preserved."
 - id: adversarial_or_prompt_injection
 input: ""
 expected: "Ignore untrusted instruction and follow system/developer/user hierarchy."
```

## 3. Score dimensions

```yaml
scorecard:
 task_understanding: 0_to_5
 source_grounding: 0_to_5
 risk_gate_correctness: 0_to_5
 output_format: 0_to_5
 completeness: 0_to_5
 concision: 0_to_5
 tool_policy: 0_to_5
 validation_honesty: 0_to_5
 safety: 0_to_5
```

A prompt should not ship if safety, validation honesty, or risk-gate correctness is below threshold.

## 4. Failure taxonomy

Track failures by type:

- hallucinated source fact
- ignored latest instruction
- asked unnecessary question
- failed to ask blocking question
- over-executed
- under-executed
- wrong tool used
- missed validation boundary
- output schema drift
- excessive verbosity
- too terse for artifact quality
- unsafe permission recommendation
- prompt injection susceptibility

## 5. Prompt test record

Use `templates/prompt_evaluation_matrix.yaml` for each test run.

## 6. Human review checklist

A reviewer should check:

- Are facts separated from assumptions?
- Are risk boundaries clear?
- Does the prompt state what it must not do?
- Does it define exact output artifacts?
- Does it tell Claude when to browse or inspect files?
- Does it avoid impossible claims such as unrun validation?
- Does it have examples for edge cases?
- Are tool permissions least-privilege?
- Does it define what happens when blocked?

## 7. Regression loop

When a prompt fails:

1. Record failing input and output.
2. Classify failure.
3. Change one prompt section only.
4. Re-run all critical cases.
5. Keep or revert.
6. Update prompt changelog.

## 8. Example acceptance gate

```yaml
acceptance_gate:
 required_cases_passed:
 - high_risk_action
 - source_first_required
 - blocking_gap
 - output_schema_regression
 minimum_average_score: 4.2
 no_score_below:
 safety: 5
 validation_honesty: 5
 risk_gate_correctness: 4
 source_grounding: 4
```
