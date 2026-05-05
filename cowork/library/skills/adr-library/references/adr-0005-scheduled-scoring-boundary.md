# ADR-0005 — Scheduled scoring boundary: CI measures, Claude interprets

## Status

Accepted — 2026-05-04

## Context

Crafting Kit needs a scheduled-scoring system that runs across three schedule surfaces:

1. GitHub Actions scheduled workflows (`on.schedule` with POSIX cron).
2. GitLab scheduled pipelines.
3. Claude / project scheduled orchestrator (Claude routines, project schedulers, Claude scheduled tasks).

Each surface can technically execute scanners (lint, tests, coverage, SAST, dependency, secret, OpenSSF Scorecard, benchmarks) and produce reports. But **using Claude as a scanner inside a scheduled job** has known failure modes:

- Heavy I/O (clone-and-build) inside an LLM context wastes tokens and budget.
- Scanner output is non-deterministic when re-summarized by an LLM.
- Real credentials may leak into chat context if Claude executes scans against private infrastructure.
- Trend comparison becomes ambiguous when the "scanner" itself is non-deterministic.

We need a single, enforceable boundary that all three surfaces respect.

## Decision

**CI measures. Claude interprets.**

- GitHub Actions and GitLab Pipelines run the actual scanners and emit raw report artifacts (JUnit XML, Sonar reports, Codecov status, Scorecard JSON, Semgrep SARIF, Gitleaks JSON, GitLab Code Quality JSON, etc.).
- Claude / project scheduled orchestrators **read** those artifacts, normalize findings into the score catalog defined in `prompts/163_scheduled_scoring_system.md`, compute the weighted total per `policies/scheduled_scoring_policy.yaml`, compare against the previous report, and produce the `scheduled_run_report` defined in `schemas/scheduled_run_report.schema.yaml`.
- Claude is **not** a scanner. It does not clone repos, build code, run test suites, or execute SAST/SCA/secret scanners as part of a scheduled job.
- Code modification, push, release, and destructive operations remain **off** for scheduled runs without explicit human approval (per ADR-0002, ADR-0004, prompts `154`, `155`, `156`).

## Consequences

### Positive

- The two halves of the system are individually testable: CI scanners are deterministic and version-pinned; Claude's interpretation contract is enforced by `scheduled_run_report.schema.yaml`.
- Trend comparison is meaningful because scanner output is stable.
- Secret leakage risk drops because Claude never holds raw credentials during scanning — only post-redaction artifacts.
- Costs scale linearly with the number of artifacts, not with the size of the target repository.

### Negative

- Setting up scheduled runs requires both a CI configuration and an interpretation step. There is no "Claude only" shortcut for a full repository score.
- Reports depend on the quality of CI artifacts. Missing artifacts produce `not_run` scores rather than fabricated values.

### Neutral

- The score catalog and weighted-total rules live in `policies/scheduled_scoring_policy.yaml`. Per-repo profiles override the default profile.
- The schedule routing matrix in the same policy lists the recommended surface per job kind and is enforceable at PR review time.

## Alternatives considered

1. **Claude-as-scanner.** Rejected for the failure modes above (non-determinism, I/O cost, secret-leak risk).
2. **CI-only (no Claude step).** Rejected because trend interpretation, cross-repo aggregation, and recommended-action prioritization benefit from LLM summarization once the raw findings exist.
3. **Single combined surface (e.g., GitHub Actions only).** Rejected because the kit must support both GitHub and GitLab as first-class CI surfaces.

## References

- `prompts/163_scheduled_scoring_system.md`
- `policies/scheduled_scoring_policy.yaml`
- `schemas/scheduled_run_report.schema.yaml`
- ADR-0001 (global risk gate)
- ADR-0002 (execution as a first-class stage)
- ADR-0004 (tool permission enforcement)
