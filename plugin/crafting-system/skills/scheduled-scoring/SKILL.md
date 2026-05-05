---
name: scheduled-scoring
description: Runs the Crafting Kit scheduled scoring contract across GitHub Actions, GitLab Pipelines, and Claude / project scheduled orchestrators. Use when interpreting CI report artifacts (JUnit, Sonar, Codecov, Scorecard, SAST/SCA, secret-scan, GitLab code-quality JSON), normalizing them into the 21-score catalog, computing the weighted repository health score, comparing against a prior report for trend, and producing recommended actions. Use also when reviewing whether a scheduled job should run on CI or in Claude.
disable-model-invocation: true
---

# Scheduled Scoring

Apply the boundary first: **CI measures, Claude interprets.** Refuse to run scanners or clone-and-build target repos inside a scheduled task; redirect that work to GitHub Actions or GitLab Pipelines.

Primary references:

- `prompts/163_scheduled_scoring_system.md` — score catalog, schedule routing, cadence, output contract, operating rules.
- `policies/scheduled_scoring_policy.yaml` — weighted profiles, bucket membership, routing matrix, cadence definitions, hard rules.
- `schemas/scheduled_run_report.schema.yaml` — output schema every run must conform to.
- `adrs/adr-0005-scheduled-scoring-boundary.md` — boundary rationale.

Workflow:

1. Identify the surface: trigger / interpret / summarize.
2. Confirm required inputs (repo identity, CI artifacts, optional previous report, optional profile).
3. If inputs are missing, return a `minimum_input_request`.
4. Parse provided CI artifacts and map findings into the score catalog.
5. For any score without an artifact, set `not_run` with a reason — never a silent zero.
6. Compute the weighted total per the active profile.
7. If a previous report is provided, compute trend (`degraded_areas`, `improved_areas`, `delta`).
8. Produce `recommended_actions` in `immediate`, `this_week`, `later` buckets, each linked to evidence.
9. Validate the output against `schedules/scheduled_run_report.schema.yaml`.

Hard stops:

- Apparent secret in evidence -> switch to `prompts/158_secret_and_runtime_credentials.md`.
- Recommended action implies destructive change -> escalate via `prompts/156_human_approval_protocol.md`.
- Request asks Claude to run scanners directly -> refuse and redirect to CI.
