# OSS-ready Advanced Tool Pack

This pack provides a language-independent OSS readiness scaffold for repositories that need to be easier to publish, review, maintain and accept contributions for.

The pack separates two concerns:

1. `docs/` contains the standards explanation, usage guide, policy material and review checklists.
2. `scripts/oss-ready-bootstrap-advanced.sh` produces safe scaffold files and audit reports for a target repository.

The script is intentionally conservative. It does not edit application source code, package manifests, lockfiles, generated code, vendored dependencies, Dockerfiles, Kubernetes manifests or existing CI workflows. Its job is to make repository governance, community health, security disclosure, dependency policy, release posture and supply-chain readiness visible.

## Quick start

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /path/to/repo --audit-only
sh scripts/oss-ready-bootstrap-advanced.sh --target /path/to/repo --dry-run
sh scripts/oss-ready-bootstrap-advanced.sh --target /path/to/repo --dependency-bot dependabot --scorecard
```

## Package layout

```text
README.md
scripts/
 oss-ready-bootstrap-advanced.sh
docs/
 OSS_READY_OVERVIEW.md
 USAGE.md
 PACKAGE_STRUCTURE.md
 reference/
 research_reference_map.md
 oss/
 README.md
 OSS_READINESS_CHECKLIST.md
 OSS_READINESS_SCORE.md
 VALIDATION_MATRIX.md
 DEPENDENCY_POLICY.md
 SUPPLY_CHAIN_POLICY.md
 SBOM_POLICY.md
 PROVENANCE_POLICY.md
 HOSTING_PLATFORM_SETTINGS.md
 SECURITY_RESPONSE_PROCESS.md
 RELEASE_PROCESS.md
 GOVERNANCE_MODEL.md
 MAINTAINER_HANDOFF.md
 RUNTIME_OPERATIONS_REVIEW.md
 AI_TOOLING_POLICY.md
 OPEN_SOURCE_RELEASE_GATE.md
 REUSE_SPDX_POLICY.md
 CONTRIBUTOR_EXPERIENCE.md
templates/
 github/
 gitlab/
 renovate/
 reuse/
examples/
 run_summary.example.md
 suggestions.example.md
 oss_readiness_snapshot.example.md
artifacts_manifest.yaml
run_summary.md
```

## Truth boundary

- This pack does not claim that a repository is `production-ready`.
- This pack does not claim that a repository is `secure`, `fully tested`, `release-ready`, `SLSA-compliant`, `REUSE-compliant` or that it has earned an OpenSSF badge.
- The script produces evidence-based findings, warnings, suggestions and a maturity snapshot.
- Real validation must be defined and run with repository-specific build, test, lint, security and release commands.

## Recommended workflow

1. Run `--audit-only` first to see the current state without creating files.
2. Review `suggestions.md` and `oss_readiness_snapshot.md`.
3. Run `--dry-run` to inspect the scaffold plan.
4. Run the scaffold mode only after the team agrees on the desired repository governance files.
5. Fill all TODO values before making public OSS-readiness claims.
