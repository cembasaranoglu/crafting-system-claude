# OSS readiness score model

This model is not an automatic certification. It is a shared language for maturity discussions.

| Level | Name | Meaning |
|---|---|---|
| L0 | Repo hygiene baseline | Repository is clean enough to review or share |
| L1 | Community profile baseline | External readers can understand the project basics |
| L2 | Contributor-ready | Contribution workflow is clear |
| L3 | Maintainer-ready | Ownership, governance and handoff are clear |
| L4 | Validation-ready | Build/test/lint/security commands are known and reportable |
| L5 | Release-ready | Versioning, changelog, artifact and package release policy are clear |
| L6 | Security/supply-chain-ready | Dependency, provenance, SBOM, platform security and disclosure posture are clear |

## Status vocabulary

Use consistent review states:

- `validated`: evidence exists and has been reviewed
- `present`: file or configuration exists, but it has not been fully reviewed
- `partial`: part of the requirement is present
- `blocked`: missing input, access, ownership or tooling prevents completion
- `not applicable`: explicitly out of scope
- `not reviewed`: no review has been done yet

Use `validated` only when exact command output, platform setting evidence or human approval evidence exists.
