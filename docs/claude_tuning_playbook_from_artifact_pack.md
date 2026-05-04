# 04 — Claude Tuning Playbook

## 1. Tune in this order

Do not start by adding more instructions. Tune in this order:

1. Success criteria and eval set.
2. Task clarity and scope.
3. Output schema.
4. Examples.
5. Source/context layout.
6. Tool-use policy.
7. Reasoning/effort/thinking settings.
8. Context caching and cost strategy.
9. Subagent or plugin decomposition.
10. Safety and risk gates.

## 2. Common symptom → tuning lever

| Symptom | Likely cause | First tuning lever |
| --- | --- | --- |
| Claude answers vaguely | task/output not specific | add explicit output contract and examples |
| Claude asks too many questions | prompt over-emphasizes uncertainty | define blocking vs non-blocking gaps |
| Claude assumes too much | no source-first/risk gate | add source inspection and assumption rules |
| Claude overuses tools | aggressive `always use tool` wording | replace with conditional trigger policy |
| Claude underuses tools | tool purpose unclear | describe when and why to use tool |
| Claude creates too many files | over-autonomous coding prompt | constrain scope and temp file cleanup |
| Claude over-engineers | vague “robust/advanced” requirement | define minimum sufficient solution and non-scope |
| Output format drifts | weak schema/examples | add XML/YAML schema and few-shot examples |
| Long-context answers miss key facts | poor context order | put long docs first, query/instructions after, ask for quote grounding |
| Cost too high | too much context/tool/schema | cache stable prefixes, reduce tools, lower effort for easy tasks |
| Reasoning too shallow | effort too low or task underspecified | raise effort or add targeted reasoning guidance |

## 3. Model and effort policy

Use a task-based policy instead of one model/effort for everything.

```yaml
model_effort_policy:
 simple_lookup_or_formatting:
 effort: low
 notes: "Use concise prompts and no unnecessary tool use."
 ordinary_coding_or_prompt_edit:
 effort: medium_or_high
 notes: "Use source-first inspection and bounded validation."
 complex_architecture_or_agentic_coding:
 effort: high_or_xhigh
 notes: "Allow deeper reasoning, multiple file reads, and structured progress tracking."
 high_stakes_security_or_release:
 effort: high_or_xhigh
 notes: "Use strict gates, evidence ledger, and review pass."
```

Do not compensate for low effort with massive prompt verbosity. If the task genuinely needs reasoning, use the appropriate model/effort setting.

## 4. Adaptive thinking guidance

Use thinking for complex multi-step reasoning, tool-result reflection, and long-horizon tasks. Do not force deep thinking for trivial tasks.

Prompt snippet:

```xml
<thinking_policy>
Use deeper reasoning only when it will materially improve correctness: multi-step design, ambiguous source synthesis, codebase-wide changes, tool-result reflection, or high-risk decisions. For simple tasks, respond directly.
</thinking_policy>
```

## 5. Prompt caching strategy

Cache stable content:

- system instructions
- reusable project context
- long static references
- stable tool definitions
- stable plugin conventions

Do not place changing content before cache breakpoints. Put stable prefixes first, variable user input later.

Recommended layout:

```text
[stable base contract]
[stable plugin/prompt rules]
[stable source context]
[CACHE BREAKPOINT]
[task-specific user input]
[current source excerpts]
[tool results]
```

## 6. Context layout for long documents

For long context:

1. Put long documents near the top.
2. Use XML document tags and metadata.
3. Put the user query after the documents.
4. Ask Claude to extract relevant quotes/facts before synthesizing.
5. Require an evidence ledger if factual accuracy matters.

## 7. Tool-use tuning

Write tool rules as conditional triggers.

Bad:

```text
Always use web search.
```

Better:

```text
Use web search when the answer depends on current facts, official docs, prices, laws, product behavior, or anything likely to have changed. Do not browse for pure rewriting of user-provided text unless the user requests external research.
```

Bad:

```text
Always edit files directly.
```

Better:

```text
Edit files only when the user explicitly requests file changes or artifact creation. For high-risk or destructive changes, stop and ask for confirmation.
```

## 8. Subagent tuning

Use subagents when work is independent, parallelizable, or noisy. Avoid subagents for single-file edits or tightly coupled reasoning.

Prompt snippet:

```text
Use subagents for independent research, large file exploration, or parallel review streams. Work directly for single-file edits, sequential reasoning, or tasks where shared context must be preserved.
```

## 9. Verbosity tuning

Define verbosity by mode:

```yaml
verbosity_policy:
 chat_answer: concise
 artifact_docs: detailed
 high_risk_report: detailed_but_structured
 code_review: findings_first
 execution_update: short_progress_only
```

Use positive examples of the desired style.

## 10. Evaluation-driven tuning loop

For every prompt version:

```text
Define cases -> Run current prompt -> Score outputs -> Identify failure class -> Make one prompt change -> Re-run -> Compare -> Keep or revert -> Update changelog
```

Failure classes:

- misunderstanding task
- hallucinating source facts
- missing constraints
- wrong format
- unsafe action
- under-action
- over-action
- insufficient validation
- excessive cost/latency
- poor style

## 11. Regression protection

Keep a small regression set of prompts that previously failed. A prompt change is not safe if it fixes the current problem but breaks old critical cases.

## 12. Tuning anti-patterns

Avoid:

- adding broad “be better” instructions
- layering contradictions instead of resolving them
- using many all-caps MUST rules without priority
- making all gaps blocking
- making no gaps blocking
- hiding risky autonomy under “do what is best”
- ignoring evaluation because output “looks good”
