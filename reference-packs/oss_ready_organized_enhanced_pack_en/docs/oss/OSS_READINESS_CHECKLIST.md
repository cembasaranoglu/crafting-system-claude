# Advanced OSS readiness checklist

This checklist is a review tool, not a certification claim. Each item should be marked as `done`, `partial`, `blocked`, `not applicable` or `not reviewed`.

## L0 — Repo hygiene baseline

- [ ] `.gitignore` excludes local env files, secrets, logs, caches and build outputs
- [ ] `.gitattributes` defines text and binary handling
- [ ] `.editorconfig` defines cross-editor baseline formatting
- [ ] No local AI/editor workspace state is committed
- [ ] No assistant run artifacts are committed
- [ ] No generated zip/output/workspace directories are committed
- [ ] No private hostnames, customer data or credentials appear in examples

## L1 — Community profile baseline

- [ ] `README.md` explains purpose, audience and project status
- [ ] `README.md` explains install/build/test/run usage or states that it is not ready yet
- [ ] `LICENSE` exists and has been intentionally selected
- [ ] `SECURITY.md` provides a private vulnerability disclosure channel
- [ ] `CONTRIBUTING.md` explains contribution flow and validation expectations
- [ ] `CODE_OF_CONDUCT.md` exists if public contributions are expected
- [ ] Issue templates exist
- [ ] PR/MR template exists

## L2 — Contributor-ready

- [ ] Local setup instructions are usable
- [ ] Required tools and versions are documented
- [ ] Validation commands are documented
- [ ] PR/MR checklist separates run and not-run validation
- [ ] Contribution scope and non-goals are documented
- [ ] Docs/examples update expectations are documented
- [ ] Breaking-change expectations are documented

## L3 — Maintainer-ready

- [ ] Maintainers are listed
- [ ] Ownership areas are clear
- [ ] Governance and decision process are documented
- [ ] Security contact ownership has backup coverage
- [ ] Release ownership is documented
- [ ] Handoff checklist exists
- [ ] Triage process exists

## L4 — Validation-ready

- [ ] Build command is known
- [ ] Unit test command is known
- [ ] Integration/contract test boundary is known
- [ ] Lint command is known
- [ ] Format command is known
- [ ] Security/dependency scan command is known
- [ ] CI workflow exists and matches actual commands
- [ ] Validation not-run states are documented

## L5 — Release-ready

- [ ] Versioning policy exists
- [ ] Changelog or release notes policy exists
- [ ] Release tag policy exists
- [ ] Artifact generation command exists
- [ ] Artifact signing policy exists or is explicitly not applicable
- [ ] Package publishing owner is known
- [ ] Rollback/deprecation notes exist where relevant

## L6 — Security and supply-chain-ready

- [ ] Dependency update bot is selected
- [ ] Lockfile policy is documented
- [ ] Dependency review process exists
- [ ] Vulnerability triage policy exists
- [ ] SBOM policy exists
- [ ] Provenance policy exists
- [ ] CI permissions are least-privilege
- [ ] Branch protection/rulesets are reviewed
- [ ] Secret scanning/push protection settings are reviewed
- [ ] REUSE/SPDX policy is documented
