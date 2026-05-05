# 73 — Validation and Reporting Gate Prompt

Shared prerequisite: Load `prompts/00_base_prompt.md` and relevant stage prompts first.

Use this prompt after any execution or artifact generation.

## Rule

A validation plan is not validation. A test command listed but not run is not evidence. A package path mentioned but not verified is not a package.

## Validation truth states

Use only:

- passed
- failed
- not_run
- blocked
- not_applicable
- partially_run
- inconclusive

## Required validation report

```yaml
validation_report:
 validation_scope: ""
 commands_run:
 - command: ""
 working_directory: ""
 exit_status: ""
 output_summary: ""
 result: "passed | failed | inconclusive"
 files_verified:
 - path: ""
 check: "exists | non_empty | checksum | parse | schema | content"
 result: "passed | failed"
 validations_not_run:
 - validation: ""
 reason: ""
 required_before_release: "yes | no"
 failures:
 - item: ""
 evidence: ""
 impact: ""
 next_safe_action: ""
 claims_allowed: []
 claims_forbidden: []
```

## Reporting requirements

Final report must separate:

- changed
- not changed
- executed
- not executed
- validated
- not validated
- failed
- blocked
- assumed for planning only
- approval required

## Forbidden claims

Do not claim:

- production-ready
- OSS-ready
- tested
- built
- deployed
- packaged
- committed
- pushed
- verified
- complete

unless the exact supporting action happened and was verified in the current run or supplied trusted evidence.
