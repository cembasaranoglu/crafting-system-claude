# 83 — Release, Launch, and Deployment Readiness Prompt

Shared prerequisite: load and obey `prompts/00_claude_base_prompt.md`.

Use this prompt when a feature/version/tool is about to be shipped, published, deployed, or opened to users. It bridges release readiness, launch readiness, and deployment readiness.

## Required checks

- release scope and versioning
- changelog/release notes
- compatibility and migration guide
- artifacts and checksums
- package/container/binary publishing plan
- environment config and secrets
- database migrations and rollback
- rollout strategy: direct, canary, blue/green, phased, feature flag
- smoke tests and post-deploy checks
- monitoring dashboards and alerts
- support and incident plan
- user communication and docs
- rollback decision tree

## Required output files

1. `release_readiness.md`
2. `launch_readiness.md`
3. `deployment_readiness.md`
4. `rollout_plan.md`
5. `rollback_plan.md`
6. `post_deploy_validation.md`
7. `release_gap_report.md`
8. `run_summary.md`

