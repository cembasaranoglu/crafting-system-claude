# Example Prompt Sequence — Refactoring

1. Run feature inventory.
2. Run code health/refactoring strategy.
3. Add characterization tests for risky behavior if needed.
4. Execute only one wave with bounded refactoring execution.
5. Validate and update docs/context.
6. Repeat with the next wave.

Copy prompt:

```text
Use the uploaded Claude advanced prompt system.

Load:
- prompts/00_claude_base_prompt.md
- prompts/10_refactoring_strategy_and_plan.md

Task:
Inspect the uploaded repository and produce a strict behavior-preserving refactoring wave plan.

Requirements:
- Do not modify source code.
- Identify behavior surfaces.
- Identify safety net tests.
- Split into small waves.
- Produce next bounded prompt for Wave 1 only.
- Package outputs into a zip.
```
