# What OSS-ready means

OSS-ready means that a repository is prepared for public visibility, external review and contributor interaction at a responsible baseline level.

It is not the same thing as `production-ready`. A repository can be OSS-ready while still missing release automation, package publishing, deployment validation, runtime hardening or full security review.

The practical question is not “is this repository perfect?”. The practical question is: can a new reader, contributor, maintainer or security reporter understand the project, work with it safely, and see what is validated versus what is still unknown?

## Practical maturity model

### L0 — Repo hygiene baseline

The public repository view should be free from local noise, generated run artifacts, secrets and personal workspace state.

Review areas:

- `.gitignore`
- `.gitattributes`
- `.editorconfig`
- local env files and secret files
- build outputs and cache directories
- personal AI/editor workspace files
- assistant/run output directories

### L1 — Community profile baseline

A reader or contributor should be able to answer the basic project questions from the repository itself.

Review areas:

- `README.md`
- `LICENSE`
- `CONTRIBUTING.md`
- `CODE_OF_CONDUCT.md`
- `SECURITY.md`
- issue templates
- pull/merge request templates
- support boundaries

### L2 — Contributor-ready

The repository should be workable for outside contributors or for a wider internal engineering group.

Review areas:

- local setup instructions
- development workflow
- PR/MR checklist
- validation expectations
- code review expectations
- accepted contribution scope
- non-goals
- docs/examples update expectations

### L3 — Maintainer-ready

The repository should not depend on one person’s memory to stay healthy.

Review areas:

- maintainer list
- governance model
- ownership boundaries
- triage policy
- escalation path
- release responsibility
- maintainer handoff
- bus factor risk

### L4 — Validation-ready

Build, test, lint, security and release checks should be named, repeatable and reportable.

Review areas:

- build command
- unit test command
- integration/contract test boundary
- lint/format command
- dependency/security scan command
- CI workflow
- validation matrix
- explicit not-run explanations

### L5 — Release-ready

Release generation, versioning and artifact policy should be clear before publishing packages or binaries.

Review areas:

- semantic versioning or an explicit alternative version policy
- changelog discipline
- release tag policy
- artifact signing
- package publishing
- rollback/deprecation notes
- release ownership

### L6 — Security and supply-chain-ready

Dependency intake, build provenance, secret handling, vulnerability disclosure and platform controls should be visible and reviewable.

Review areas:

- Dependabot or Renovate policy
- OpenSSF Scorecard posture
- GitHub Actions permissions
- branch protection / rulesets
- secret scanning / push protection
- SBOM policy
- provenance policy
- SLSA target
- REUSE/SPDX policy
- security response process

## How this pack approaches OSS readiness

This pack scaffolds L0-L3 material and makes L4-L6 follow-up work visible through policies, checklists, suggestions and maturity snapshots.

The script does not invent language-specific build/test commands. It detects repository signals and turns them into suggestions only.
