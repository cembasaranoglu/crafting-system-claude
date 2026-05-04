# Prompt System Evaluation

Crafting Kit prompt changes should be tested like code changes.

## Minimum eval suite

For each critical prompt, include:

- happy-path fixture
- missing-input fixture
- contradiction fixture
- unsafe execution fixture
- secret-bearing fixture
- fabricated-validation fixture
- output-schema fixture
- regression fixture from a known failure

## Expected checks

- required artifacts are named
- stage boundary is respected
- blockers stop the run
- assumptions are labeled
- validation claims require evidence
- secret values are not repeated
- output schema is parseable when structured output is requested
- next prompt is recommended accurately

Use:

- `97_prompt_test_harness.md`
- `98_prompt_regression_suite.md`
- `99_golden_output_validation.md`
- `160_claude_tuning_playbook_prompt.md`
