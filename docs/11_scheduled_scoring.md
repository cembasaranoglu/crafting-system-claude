# Scheduled Repository Scoring

Crafting Kit ships a scheduled-scoring system that runs across three schedule surfaces and produces a single normalized report on every run:

1. **GitHub Actions** scheduled workflows (`on.schedule` with POSIX cron).
2. **GitLab** scheduled pipelines.
3. **Claude / project scheduled orchestrator** (Claude routines, project schedulers, scheduled tasks).

The boundary is non-negotiable: **CI measures, Claude interprets.**

| Surface | Role |
|---|---|
| GitHub Actions / GitLab Pipelines | Run scanners, emit raw report artifacts. |
| Claude / project scheduler | Read CI artifacts, normalize into the score catalog, compute the weighted total, compare against the previous report, and produce recommended actions. |

Claude is **not** a scanner. Do not clone target repos, do not run SAST/SCA/secret scanners or test suites inside a scheduled Claude task — that work belongs in CI.

## Where the contract lives

| Artifact | Path |
|---|---|
| Prompt | [`prompt-system/prompts/163_scheduled_scoring_system.md`](../prompt-system/prompts/163_scheduled_scoring_system.md) |
| Policy (weights, profiles, routing matrix, cadence, hard rules) | [`prompt-system/policies/scheduled_scoring_policy.yaml`](../prompt-system/policies/scheduled_scoring_policy.yaml) |
| Output schema (every run conforms to this) | [`prompt-system/schemas/scheduled_run_report.schema.yaml`](../prompt-system/schemas/scheduled_run_report.schema.yaml) |
| ADR rationale | [`prompt-system/adrs/adr-0005-scheduled-scoring-boundary.md`](../prompt-system/adrs/adr-0005-scheduled-scoring-boundary.md) |
| Plugin skill | `plugin/crafting-system/skills/scheduled-scoring/SKILL.md` |
| Cowork skill | `cowork/skills/scheduled-scoring/{SKILL.md,references/}` |

## Score catalog (21 scores, 10 buckets)

The full table — what each score measures and the recommended source — is in `prompts/163_scheduled_scoring_system.md`. The 10 weighted buckets the catalog collapses into are defined in `policies/scheduled_scoring_policy.yaml` under `bucket_membership`.

Default profile (`standard`, sums to 100):

| Bucket | Weight |
|---|---|
| `code_quality` | 16 |
| `test_quality` | 16 |
| `security` | 16 |
| `dependency_supply_chain` | 12 |
| `architecture_maintainability` | 12 |
| `ci_cd_health` | 8 |
| `repository_hygiene` | 6 |
| `runtime_readiness` | 6 |
| `documentation_contracts` | 5 |
| `ai_readiness` | 3 |

The policy ships two additional profiles — `oss_first` and `data_heavy` — and you can add per-repo profiles by extending `profiles:` in the policy.

## Recommended cadence

| Cadence | Includes |
|---|---|
| Daily quick scan | Lint, tests, coverage delta, new dependency / security risks |
| Weekly deep scan | Architecture drift, docs/config/schema parity, refactor candidates |
| Monthly readiness scan | OSS readiness, production readiness, supply-chain posture, runbook / deployment gaps |
| On-demand | Large PR, pre-release, major dependency upgrade, pre-migration |

The cadence-to-job mapping is in the policy under `cadence:`.

## Run output

Every scheduled run must emit a `scheduled_run_report` that conforms to `schemas/scheduled_run_report.schema.yaml`. Minimum shape:

```yaml
run:
  source: github_actions | gitlab_pipeline | project_scheduler | claude_routine
  repo: <owner/name>
  branch: <branch>
  commit: <sha>
  started_at: <iso8601>
  finished_at: <iso8601>
  profile: standard
scores:
  - name: code_quality_score
    value: 0..100
    confidence: low | medium | high
    evidence:
      - command: <exact command>
      - report_file: <path>
      - finding_count: <int>
    not_run: []
    blockers: []
    top_risks: []
trend:
  previous_total_score: ...
  current_total_score: ...
  delta: ...
  degraded_areas: []
  improved_areas: []
recommended_actions:
  immediate: []
  this_week: []
  later: []
```

Hard rules (enforced by the policy):

- Every score records either `evidence` or `not_run`. No silent zeros.
- Real secrets must not appear anywhere in the report.
- `trend` is required when a previous report exists.
- Code modification in a scheduled run is **off** without explicit human approval.

## Workflow examples

### A) Trigger a daily quick scan from CI, then ask Claude to interpret

GitHub Actions or GitLab Pipelines runs the scanners on cron and uploads:

- `junit.xml` (tests)
- `coverage.json` (Codecov / lcov)
- `sonar-report.json` (SonarQube/Cloud)
- `scorecard.json` (OpenSSF Scorecard)
- `semgrep.sarif`, `gitleaks.json`, `osv-scanner.json` (security/SCA/secrets)
- `gl-code-quality-report.json` (GitLab Code Quality, if applicable)

Then in Claude / Cowork:

```text
/crafting-system:scheduled-scoring
```

Provide the artifact paths. The skill walks through the workflow in prompt `163`: parse → map to the score catalog → mark `not_run` for any missing artifact → compute weighted total → trend (if a prior report is supplied) → recommended actions.

### B) Weekly architecture drift scan

```text
Load 00 → 150 → 151 → 153, then /crafting-system:scheduled-scoring.
Provide previous week's report and the current architecture-drift artifact.
Ask for: trend on `architecture_drift_score`, top 3 boundary violations,
and recommended_actions in `this_week` bucket.
```

### C) Monthly readiness scan (release-gate context)

Combine `scheduled-scoring` with the readiness gates (`prompts/70`–`84`) and the aggregator (`prompts/85`). The scheduled scan provides current evidence; the readiness gates produce go/no-go decisions.

## What Claude refuses inside a scheduled task

- Running scanners directly (lint/test/SAST/SCA/secret/scorecard/benchmarks).
- Cloning, building, or testing target repositories.
- Modifying source code, manifests, deployment configs, or release artifacts.
- Pushing, releasing, or deploying.
- Reading credential paths or printing secret values (`prompts/158` enforces this).

Recommendations are the only output; code changes go through the regular risk/execution gates (`prompts/154`, `155`, `156`).

## See also

- ADR-0005 — boundary rationale
- `prompts/82_readiness_gate_orchestrator.md`
- `prompts/85_readiness_gate_aggregator.md`
- `prompts/86_release_go_no_go_board.md`
- `prompts/88_engineering_risk_register.md`
- `prompts/89_remediation_wave_planner.md`
