---
id: prompt.163_scheduled_scoring_system
stage: scheduled_scoring
status: active
title: Scheduled Repository Scoring System
---

# Scheduled Repository Scoring System

## Purpose

Define a **single score catalog** that runs across three schedule surfaces — GitHub Actions scheduled workflows, GitLab scheduled pipelines, and Claude/project scheduled orchestrators — and produce a normalized, comparable, evidence-backed report on every run.

## Hard boundary (read this first)

| Surface | Role | Allowed |
|---|---|---|
| GitHub Actions / GitLab Pipelines | **Measurement** | Run scanners (lint, tests, coverage, SAST, dependency, secret, scorecard, benchmarks). Produce raw report artifacts. |
| Claude / project scheduled orchestrator | **Interpretation** | Read CI artifacts, normalize to score schema, compute weighted total, compare with previous run, write report and recommended actions. |
| Claude in a scheduled job | **Not a scanner** | Do not run heavy scanners, do not clone-and-build target repos, do not execute network-side scanning. |

Stated as a contract: **CI measures, Claude interprets.** Never collapse this boundary.

## Score catalog (21 scores)

| Score | What it measures | Source / measurement |
|---|---|---|
| `repository_health_score` | Overall technical health | Weighted sum of sub-scores below |
| `code_quality_score` | Maintainability, reliability, complexity, duplication, lint/code smell | SonarQube / SonarCloud, language linters, static analysis, complexity (cyclomatic / cognitive) |
| `test_score` | Test quality beyond coverage: unit weight, negative cases, regression tests, flaky risk | `go test`, `pytest`, `npm test`, JUnit XML, runtime, failed/skipped, test:source ratio |
| `coverage_score` | Project coverage, patch coverage, changed-code coverage regression | Codecov project status (base vs current), patch/project thresholds |
| `security_score` | Source-level vulns, insecure patterns, unsafe configs, injection / auth risk | CodeQL, GitLab SAST, Semgrep, Bandit, Gosec, npm audit, osv-scanner |
| `dependency_risk_score` | Vulnerable, outdated, unpinned, abandoned, license-risk dependencies | Dependabot / Renovate, GitLab Dependency Scanning, OSV, npm/yarn/pnpm audit, `govulncheck`, lockfile diff |
| `supply_chain_score` | Branch protection, signed releases, pinned actions, token permissions, provenance | OpenSSF Scorecard checks (0–10 per check) |
| `ci_cd_health_score` | Pipeline pass rate, flaky jobs, duration, stale workflows, cache/artifact health | GitHub workflow runs, GitLab pipeline history, failed/retried/skipped jobs |
| `architecture_drift_score` | Deviation from target architecture: dependency direction, boundary violation, public/internal breach | Repo tree diff, import graph, package dependency graph, forbidden-dependency rules, architecture docs |
| `repository_hygiene_score` | README, LICENSE, SECURITY, CONTRIBUTING, CODEOWNERS, examples, changelog, `.gitignore` | File presence + content quality + stale-docs check |
| `documentation_freshness_score` | Docs/code coherence, README commands work, config/example currency | README command smoke test, OpenAPI/config/schema diff, docs last-modified vs source-changed areas |
| `api_contract_score` | OpenAPI, GraphQL, CLI help, event schema, config schema parity | Schema validation, generated docs diff, contract tests, breaking-change detector |
| `config_safety_score` | Env/config validation, unsafe defaults, missing sample configs, secret leakage | `.env.example`, config schema, secret scanner, required env vars, default-value audit |
| `secret_hygiene_score` | Secrets, tokens, private keys, local paths, credential leaks | Gitleaks, TruffleHog, GitHub secret scanning, GitLab secret detection |
| `runtime_readiness_score` | Health/readiness probes, graceful shutdown, logging, metrics, timeouts, retries | Kubernetes manifests, Dockerfile, app config, health endpoints, signal-handling tests |
| `performance_risk_score` | Hot-path risk, slow tests, unbounded query/loop, memory/CPU growth | Benchmarks, profiling artifacts, static pattern scan, query scan, load-test summaries |
| `data_migration_safety_score` | Migration reversibility, idempotency, transactional safety, destructive-change risk | Migration files, schema diff, rollback notes, migration test output |
| `ai_readiness_score` | Repository's analyzability and safe AI working boundaries | `CLAUDE.md`, `AGENTS.md`, prompt docs, task boundaries, generated-artifact policy, no personal AI workspace files |
| `oss_readiness_score` | Open-source distribution readiness | LICENSE, SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, SBOM, release notes, governance, dependency/license scan |
| `production_readiness_score` | Prod-shipping readiness: observability, security, rollback, runbook, SLO, deployment safety | Runbooks, dashboards, alerts, deployment manifests, smoke tests, incident docs, backup/restore docs |
| `trend_score` | Is health degrading or improving? | Diff vs previous scheduled report: score delta, new risks, closed risks |

## Schedule routing matrix

| Job | GitHub Actions | GitLab Pipelines | Claude / project scheduler |
|---|---|---|---|
| Lint + static analysis | Excellent fit | Excellent fit | Trigger only |
| Test + coverage | Excellent fit | Excellent fit | Trigger only |
| SAST / secret scan | Excellent fit | Excellent fit | Interpret report only |
| Dependency scan | Excellent fit | Excellent fit | Trend summary |
| OpenSSF Scorecard | Excellent fit | OK | Interpret result |
| Architecture drift review | OK | OK | Excellent fit |
| Weekly quality report | OK | OK | Excellent fit |
| Issue/recommendation generation | OK | OK | Excellent fit |
| Code modification | Off by default | Off by default | Off without manual approval |
| Production-runtime repo clone/test | Not recommended | Not recommended | Not recommended |

GitLab note: emit `gl-code-quality-report.json` so the report is rendered in MR widgets and diff annotations.

## Recommended cadence

| Cadence | Content |
|---|---|
| **Daily quick scan** | Lint, tests, coverage delta, new dependency / security risks |
| **Weekly deep scan** | Architecture drift, docs/config/schema parity, test pyramid, refactor candidates |
| **Monthly readiness scan** | OSS readiness, production readiness, supply-chain posture, runbook / deployment gaps |
| **On-demand manual scan** | Large PRs, pre-release, major dependency upgrades, pre-migration |

## Weighted total (default profile)

The exact weights are in [`policies/scheduled_scoring_policy.yaml`](../policies/scheduled_scoring_policy.yaml). Default profile (sums to 100):

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

Profiles can be overridden per repo (e.g. an OSS-first repo bumps `oss_readiness`, a DB-heavy repo bumps `data_migration_safety`).

## Run output contract

Every scheduled run must emit a report that conforms to [`schemas/scheduled_run_report.schema.yaml`](../schemas/scheduled_run_report.schema.yaml). Minimum shape:

```yaml
run:
  source: github_actions | gitlab_pipeline | project_scheduler | claude_routine
  repo: <owner/name>
  branch: <branch>
  commit: <sha>
  started_at: <iso8601>
  finished_at: <iso8601>
scores:
  - name: code_quality_score
    value: 0..100
    confidence: low | medium | high
    evidence:
      - command: <exact command>
      - report_file: <path>
      - finding_count: <int>
    not_run:
      - reason: <string>
    blockers:
      - item: <string>
    top_risks:
      - severity: critical | high | medium | low
        path: <file:line>
        reason: <string>
        suggested_action: <string>
trend:
  previous_total_score: <int>
  current_total_score: <int>
  delta: <int>
  degraded_areas: []
  improved_areas: []
recommended_actions:
  immediate: []
  this_week: []
  later: []
```

Rules:

- Every score must record either `evidence` (with at least one of `command`, `report_file`, `finding_count`) or `not_run` (with a reason). No silent zeros.
- `confidence: low` requires `not_run` or partial evidence.
- Real secrets must not appear in `evidence`, `top_risks`, or any other field.
- `trend` is only present when a previous report exists.

## Operating instructions for Claude

When the user asks for a scheduled-scoring run or report:

1. **Identify the surface.** Is the request asking Claude to *trigger* a scheduled run, *interpret* a CI artifact, or *summarize* historical reports? If unclear, ask once.
2. **Refuse scanner work** if the request asks Claude to run scanners directly inside a scheduled task. Redirect to GitHub Actions / GitLab Pipelines.
3. **Read CI artifacts.** When given a CI artifact (JUnit XML, Sonar report, Codecov status, Scorecard JSON, Semgrep SARIF, Gitleaks report, JSON dependency report), parse it and map findings into the score catalog.
4. **Normalize to schema.** Output must conform to `scheduled_run_report.schema.yaml`. Use `not_run` for any score whose source artifact wasn't provided.
5. **Compute the weighted total** using the active profile from `scheduled_scoring_policy.yaml`. Show inputs.
6. **Compute trend** if a prior report is provided. Mark degraded/improved areas with score deltas.
7. **Recommend actions** in three buckets: `immediate`, `this_week`, `later`. Each action must reference at least one finding's `path` or `report_file`.
8. **Do not modify code.** Recommendations only. Code changes go through the normal risk/execution gates (`prompts/154`, `155`, `156`).
9. **Apply secret-aware behavior** (`prompts/158`): no real credentials in evidence or examples.

## Required inputs

Before producing a report, Claude needs:

- The repo identity (`owner/name`, `branch`, `commit`).
- One or more CI report artifacts (any of: JUnit, Sonar, Codecov, Scorecard, SAST/SCA, secret-scan, code-quality JSON).
- (Optional) the previous run's report for trend analysis.
- The active scoring profile (defaults to the policy's `default` profile).

If a required input is missing, return a `minimum_input_request` (see `prompts/152_research_need_gate.md` and the schema in `schemas/minimum_input_request.schema.yaml`) instead of guessing.

## Stop conditions

Stop and ask for human input when:

- A score would have to be inferred without source evidence.
- A `recommended_actions` item would require destructive change (rollback, migration redo, dependency major bump) — escalate via `prompts/156_human_approval_protocol.md`.
- A potential secret is found in the evidence — switch to `prompts/158_secret_and_runtime_credentials.md`.

## Related prompts

- `prompts/70_security_appsec_readiness.md`
- `prompts/71_supply_chain_release_integrity_readiness.md`
- `prompts/74_performance_scalability_capacity_readiness.md`
- `prompts/75_documentation_dx_support_readiness.md`
- `prompts/82_readiness_gate_orchestrator.md`
- `prompts/85_readiness_gate_aggregator.md`
- `prompts/86_release_go_no_go_board.md`
- `prompts/88_engineering_risk_register.md`
- `prompts/89_remediation_wave_planner.md`
