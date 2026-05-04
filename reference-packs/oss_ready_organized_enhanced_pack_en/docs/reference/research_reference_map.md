# Research reference map

This document maps the pack content to the external reference families that informed it. The goal is not to maintain a link dump. The goal is to make the reasoning behind each review area visible.

| Area | Reference family | How it is used |
|---|---|---|
| Community health files | GitHub Community Profile | README, LICENSE, CONTRIBUTING, SECURITY and template expectations |
| Security disclosure | GitHub Security Policy, OpenSSF Best Practices | Private vulnerability reporting and supported-version policy |
| Supply-chain review | OpenSSF Scorecard | Dependency management, CI permission and branch protection suggestions |
| Dependency automation | GitHub Dependabot, Renovate docs | Optional dependency update bot scaffold |
| Licensing metadata | SPDX, REUSE | License identifiers, file-level licensing and cautious metadata policy |
| Build provenance | SLSA | Provenance policy, artifact generation questions and compliance boundary |
| Hosting controls | GitHub/GitLab platform docs | Settings that cannot be fully represented as repository files |

## Important boundary

The pack includes scaffold and review material only. It does not prove compliance with any external program. Compliance, badge or security claims require running the relevant tools, reviewing results and fixing blockers.
