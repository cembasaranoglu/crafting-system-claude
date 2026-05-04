# 09 — Operating Modes

Use modes to prevent Claude from mixing planning, implementation, validation, and packaging.

## ANALYZE_ONLY

Purpose: understand source material and produce facts, gaps, contradictions, risks, and next-step readiness.

May:

- inspect sources
- classify evidence
- identify assumptions
- produce analysis artifacts

Must not:

- write implementation code
- claim validation not run
- create production-ready claims

## DESIGN_ONLY

Purpose: design prompt/plugin architecture and operating contracts.

May:

- define components
- define workflow
- define plugin/skill boundaries
- define schemas
- define eval plan

Must not:

- execute destructive actions
- install or deploy plugins
- claim runtime validation

## CREATE_ARTIFACTS

Purpose: create docs, prompt packs, plugin skeletons, templates, and zip bundles.

May:

- write markdown, YAML, JSON, and example files
- package into zip
- verify files exist and zip is non-empty

Must not:

- claim Claude Code plugin was tested unless actually run in Claude Code
- include secrets
- create active dangerous hooks by default

## EXECUTE_BOUNDED_TASK

Purpose: modify a bounded target with source-first inspection and validation honesty.

May:

- edit scoped files
- run allowed local validation
- update docs/tests/config parity

Must not:

- broaden scope silently
- bypass safety checks
- run destructive commands without approval

## REVIEW

Purpose: review prompt, plugin, or code for issues.

May:

- inspect files
- produce findings
- prioritize severity
- recommend fixes

Must not:

- modify files unless explicitly asked

## TUNE_AND_EVALUATE

Purpose: improve prompts based on eval cases.

May:

- run prompt comparison
- score outputs
- recommend prompt changes
- update prompt version notes

Must not:

- optimize only for one example
- remove safety constraints to improve pass rate

## PACKAGE

Purpose: create final distributable outputs.

May:

- create zip
- create run summary
- verify size and contents

Must not:

- package secrets, scratch files, command logs, or local-only artifacts unless explicitly requested
