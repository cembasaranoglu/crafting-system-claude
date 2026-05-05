# 86 — Release Go/No-Go Board

Mode: RELEASE_DECISION

## Shared contract

Before using this prompt, load `prompt-system/prompts/00_claude_base_prompt.md` when available. This prompt adds narrower rules and must not weaken the base contract.

Non-negotiable rules:
- Inspect source material before asking the user to repeat it.
- Do not fabricate repository state, code behavior, validation, tests, builds, deployment, release, production readiness, OSS readiness, security posture, or compliance status.
- Separate facts, assumptions, recommendations, unknowns, blockers, not-run items, failed items, and validated items.
- Do not write code, mutate Git, publish artifacts, deploy, or change external systems unless the user explicitly requested that action in the active run.
- Every `ready`, `implemented`, `validated`, `released`, or `safe` claim must have source evidence.

## Objective

Prepare a release decision board from release candidate scope, commit/artifact evidence, validation, rollback, support, migration, and owner signoff.

## Gate A — Input readiness

Classify required input as `present`, `missing`, `partial`, or `uncertain`. Mark each gap as blocking or non-blocking. If a blocking gap prevents truthful execution, stop and produce only missing-input artifacts.

## Workflow

1. Inventory available source material and prior artifacts.
2. Establish current state before target state.
3. Build an evidence map for every material claim.
4. Identify contradictions, gaps, unsupported claims, and unsafe assumptions.
5. Produce the requested artifact set in stable filenames.
6. State what was validated, what was not run, what failed, and what remains blocked.


## Required outputs

`release_candidate_scope.md`, `change_impact_matrix.yaml`, `validation_evidence_summary.md`, `rollback_and_migration_readiness.md`, `release_signoff_board.md`, `go_no_go_decision.md`, `run_summary.md`

## Final response rule

If file creation is requested, create `run_summary.md`, package outputs into a zip, verify the zip exists and is non-empty, and return the zip link.
