# 01 — Claude Prompt Best Practices

## 1. Start with success criteria, not wording

Before changing or writing a prompt, define what success looks like. A good Claude prompt is not simply detailed; it is testable. For each prompt, document:

- user goal
- required output
- unacceptable output
- source material Claude must inspect
- allowed assumptions
- blocked assumptions
- tools Claude may use
- validation criteria
- examples of pass/fail behavior

Without success criteria, prompt tuning becomes subjective and unstable.

## 2. Separate fixed instructions from variable input

Use a prompt template mindset:

```xml
<system_contract>
Stable instructions here.
</system_contract>

<context>
Stable or cached context here.
</context>

<task>
{{user_task}}
</task>

<input_material>
{{source_documents_or_repo_context}}
</input_material>

<output_contract>
Required format and artifact names here.
</output_contract>
```

Fixed content should include identity, role, safety, output format, operating modes, validation rules, and tool-use policy. Variable content should include the user request, source excerpts, runtime facts, environment-specific information, and task-specific examples.

## 3. Be explicit about scope

Claude follows explicit scope better than implied scope. State:

- what is in scope
- what is out of scope
- what must not be done
- what may be assumed
- what must be verified
- what must trigger a stop

Avoid vague instructions such as “make it production-ready” unless you define a readiness gate. Use exact criteria instead.

## 4. Use roles, but do not rely on role alone

A role focuses behavior, but it does not replace task contracts. A strong role looks like this:

```text
You are a Principal Prompt Architect, Claude Code Plugin Reviewer, Context Engineering Specialist, Evaluation Designer, and Delivery Gatekeeper.
```

Then define exact responsibilities and forbidden responsibilities.

## 5. Use XML tags for structure

Claude handles complex instructions better when different content types are separated. Recommended tags:

```xml
<objective>...</objective>
<context>...</context>
<sources>...</sources>
<constraints>...</constraints>
<tools>...</tools>
<risk_policy>...</risk_policy>
<workflow>...</workflow>
<output_schema>...</output_schema>
<examples>...</examples>
<non_goals>...</non_goals>
```

Keep tag names stable across prompts. Nest tags only when there is a real hierarchy.

## 6. Use examples deliberately

Examples are one of the strongest ways to tune output shape and behavior. Good examples are:

- close to the real task
- diverse enough to cover edge cases
- structured with the same schema you expect in output
- not accidentally teaching unwanted patterns

Use 3–5 examples for important reusable prompts. Include at least one edge case and one blocked/high-risk example.

Example structure:

```xml
<examples>
 <example name="blocked_destructive_request">
 <input>Delete all branches and force-push cleanup.</input>
 <expected_behavior>Stop and ask for explicit confirmation because the operation is destructive and hard to reverse.</expected_behavior>
 </example>
</examples>
```

## 7. Prefer positive instructions over negative-only instructions

Instead of only saying what not to do, say what to do. For example:

Bad:

```text
Do not be vague.
```

Better:

```text
State facts, assumptions, unknowns, blockers, and recommendations in separate sections. For every claim about source material, cite the inspected file path or source label.
```

## 8. Use output schemas for repeatability

For prompts that drive artifacts, use named output files and schemas. Example:

```yaml
risk_assessment:
 overall_risk: "low | medium | high | critical"
 blockers:
 - id: "BLOCKER-001"
 description: ""
 minimum_user_input: ""
 allowed_next_action: "answer | ask | inspect_sources | create_artifacts | execute | refuse"
```

Schemas reduce drift and make prompts easier to evaluate.

## 9. Add source-first rules

A source-first Claude prompt should say:

```text
Inspect available source material before asking the user to repeat it. Do not make claims about files, repository behavior, prompt behavior, test results, plugin behavior, or runtime behavior unless those claims are grounded in inspected source material or explicitly marked as assumptions.
```

This is especially important for repository analysis, code review, plugin review, prompt migration, and documentation generation.

## 10. Add readiness gates before execution

For every non-trivial prompt, include a gate like:

```yaml
readiness_gate:
 required_inputs:
 - latest_user_instruction
 - source_material_or_clear_task
 - output_format
 - risk_tolerance
 - validation_expectation
 classify_each_as: "present | missing | partial | uncertain"
 if_blocking_gap: "stop and request minimum missing input"
```

The model should not jump into implementation when key facts are missing and the risk is high.

## 11. Control verbosity and update cadence

Specify the expected communication style. For long Claude Code runs:

```text
For simple tasks, answer directly. For multi-step tasks, provide a concise upfront plan. During long tool-use or file-inspection work, provide short progress updates only when they materially help the user understand progress. Do not spam operational details.
```

## 12. Tune tool-use behavior explicitly

Claude may suggest instead of act if the action requirement is not explicit. Decide whether your prompt should be action-oriented or conservative.

Action-oriented:

```xml
<default_action_policy>
When the user explicitly asks for files, artifacts, edits, or a plugin skeleton, create the requested outputs. Use tools to inspect sources and generate files. Do not merely describe what could be done.
</default_action_policy>
```

Conservative:

```xml
<conservative_action_policy>
Do not modify files, send messages, run destructive commands, push commits, or change shared systems unless the user explicitly asks for that action and the risk gate allows it.
</conservative_action_policy>
```

## 13. Ask only the minimum question

When blocked, ask for the smallest missing input. Do not ask the user to restate information already available in attached files or prior context.

## 14. Treat validation as evidence-based

Prompts should force Claude to separate:

- validated
- not run
- failed
- blocked
- assumed
- not applicable

Never allow “should work” to become “validated.”

## 15. Use a living prompt changelog

Prompt systems should be versioned like code. Record:

- prompt version
- change summary
- reason for change
- expected behavior improvement
- eval cases affected
- regressions observed
- rollout decision
