# 02 — Advanced Claude Prompt Techniques

## 1. Staged delivery prompts

Use staged prompts when tasks are complex, risky, or artifact-heavy. Each stage should have a boundary and produce handoff artifacts.

Recommended stages:

```text
Analyze source material -> Design prompt/plugin architecture -> Create or plan artifact/plugin skeleton -> Author bounded content/code -> Test/evaluate -> Package -> Report validation truth
```

Each stage must define what it may do and what it must not do. This prevents Claude from mixing analysis, architecture, implementation, and validation claims in one uncontrolled response.

## 2. Risk-scored autonomy

Define autonomy by risk. Example:

```yaml
autonomy_policy:
 low_risk:
 default: proceed
 examples: formatting, summarization, small local docs
 medium_risk:
 default: inspect_sources_then_proceed_with_assumptions_marked
 examples: prompt rewrites, plugin skeletons, non-destructive repo docs
 high_risk:
 default: stop_or_ask_minimum_input
 examples: production deployments, destructive file operations, credentials, security policy changes
 critical_risk:
 default: refuse_or_require_explicit_authorization
 examples: irreversible data deletion, credential exfiltration, harmful instructions
```

The prompt should say which actions are local and reversible versus shared, destructive, or externally visible.

## 3. Source-evidence ledger

For research, code review, and repository-aware tasks, require a ledger:

```yaml
source_evidence:
 - claim: ""
 source_type: "file | doc | command_output | web | user_instruction"
 source_ref: ""
 confidence: "high | medium | low"
 limitation: ""
```

This reduces hallucination and makes the final answer auditable.

## 4. Contradiction register

When source material conflicts, do not smooth over it. Require a contradiction register:

```yaml
contradictions:
 - id: "CON-001"
 area: ""
 statement_a: ""
 statement_b: ""
 impact: ""
 blocking: "yes | no"
 proposed_resolution: ""
```

## 5. Prompt routing by mode

Instead of one prompt doing everything, use mode-specific rules:

```yaml
modes:
 ANALYZE_ONLY:
 may: [inspect, classify, summarize, identify gaps]
 must_not: [modify files, implement code, claim validation]
 DESIGN_ONLY:
 may: [architecture, boundaries, contracts, templates]
 must_not: [write production code]
 CREATE_ARTIFACTS:
 may: [write docs, templates, zip]
 must_not: [claim runtime validation unless run]
 EXECUTE_BOUNDED_TASK:
 may: [modify scoped files, run allowed validation]
 must_not: [scope creep, destructive commands]
```

Mode routing is especially useful for Claude Code, where the model may otherwise over-act.

## 6. XML prompt sections with schemas

For complex prompts, combine XML and YAML:

```xml
<objective>
Create a Claude Code plugin skeleton for prompt auditing and tuning.
</objective>

<risk_policy>
Use the risk gate in docs/05_risk_gate_and_boundary_strategy.md.
</risk_policy>

<output_contract>
```yaml
required_files:
 - README.md
 - .claude-plugin/plugin.json
 - skills/prompt-audit/SKILL.md
validation:
 - verify_json_parse: true
 - verify_zip_non_empty: true
```
</output_contract>
```

XML separates conceptual sections; YAML makes output machine-checkable.

## 7. Multi-pass refinement chain

Use a chain when you need auditability:

```text
Pass 1: Extract requirements and constraints.
Pass 2: Identify gaps, contradictions, risks, and assumptions.
Pass 3: Draft output.
Pass 4: Review draft against checklist.
Pass 5: Revise only failed sections.
Pass 6: Produce validation report.
```

This can be done in one Claude turn for low/medium risk, or as separate calls for high-stakes work.

## 8. Self-check gates

At the end of generation, require:

```text
Before finalizing, check whether every required artifact exists, no unsupported claim was made, no high-risk action was taken without permission, and validation claims match actual validation.
```

For code, add:

```text
Do not optimize for passing visible tests only. Implement the general behavior required by the task.
```

## 9. Tool-use contracts

For tools, write exact trigger rules:

```yaml
tool_policy:
 browse_web:
 use_when:
 - current facts may have changed
 - official docs are needed
 - user asks for latest/current/research
 do_not_use_when:
 - task is only rewriting provided text
 file_tools:
 use_when:
 - user asks about uploaded files
 - source-first inspection is required
 must:
 - cite inspected sources when making claims
 shell:
 use_when:
 - local validation or packaging is explicitly allowed
 must_not:
 - run destructive commands without explicit approval
```

## 10. Context-budget aware prompting

For long tasks, instruct Claude how to persist state:

```text
Track progress in `progress.md` and structured status in `task_state.json` when the task spans many files or multiple context windows. Before compaction or handoff, update these files with completed work, open blockers, commands run, and next actions.
```

Do not make every prompt create state files. Use this only for long-running Claude Code sessions.

## 11. Few-shot reasoning patterns without leaking private reasoning

You can show reasoning style in examples without requiring hidden chain-of-thought disclosure. Use concise rationale fields:

```xml
<example>
 <input>...</input>
 <decision>ask_minimum_question</decision>
 <brief_rationale>The task requires credentials and production target is unknown.</brief_rationale>
 <output>...</output>
</example>
```

This teaches decision logic while keeping final outputs concise.

## 12. Progressive disclosure for skills

For Claude Code skills, keep `SKILL.md` focused. Move long references to supporting files and tell Claude when to load them.

Pattern:

```text
Use this skill to run the gate. For detailed scoring rubric, read `support/risk_rubric.md` only when the user asks for a full audit or the task is high-risk.
```

## 13. “Ask vs act” boundary

A robust prompt does not ask questions reflexively. It asks only when:

- the missing information is blocking
- the risk of assuming is high
- available sources cannot answer it
- continuing would cause irreversible or externally visible impact

Otherwise it proceeds with clearly marked assumptions.

## 14. Prompt-debt detection

A prompt may need refactoring when it contains:

- conflicting instructions
- repeated rules in multiple places
- too many `MUST` rules without priority
- tool-trigger overuse language
- vague words like robust, advanced, production-ready without gates
- output schemas that do not match user needs
- examples that teach the wrong behavior
- hidden assumptions about runtime, tools, or environment

## 15. Prompt anti-patterns

Avoid:

- “Do everything perfectly” prompts.
- Huge undifferentiated rule dumps.
- Telling Claude to always ask questions.
- Telling Claude to never ask questions.
- Aggressive tool-use instructions without risk boundaries.
- Claiming production readiness from docs-only artifacts.
- Treating a plugin skill as a security control. Permissions and hooks must enforce critical policies deterministically.
