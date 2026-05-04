---
name: ai-context-builder
description: Build Claude/Cursor/AGENTS.md AI-ready repository context, glossary,
  feature inventory, and routing artifacts.
---

# ai-context-builder

Use this skill when the user requests: Build Claude/Cursor/AGENTS.md AI-ready repository context, glossary, feature inventory, and routing artifacts.

## Source prompt references

Primary prompt-system reference: `prompts/79_ai_ready_repository_context_readiness.md plus prompts/02_project_context_glossary_memory_builder.md`.

## Operating contract

1. Inspect repository/source material before making claims.
2. Separate facts, assumptions, recommendations, unknowns, blockers, failed validation, and not-run validation.
3. Do not claim implementation, readiness, tests, builds, deployments, pushes, or packaging unless actually evidenced.
4. If code or Git write actions are requested, apply the safe mutation gates from the base prompt.
5. Produce durable artifacts when the user asks for files or reusable output.
6. Use `$ARGUMENTS` as the user-supplied scope, branch, feature, component, or question when provided.

## Task argument

```text
$ARGUMENTS
```

## Required behavior

Load the relevant prompt-system file from the repository or plugin package if available. If it is not available, follow the summarized contract above and produce the same named artifacts defined by the referenced prompt.

