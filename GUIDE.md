# Crafting Kit Operating Guide

This guide is for developers, maintainers, and reviewers who want repeatable Claude/Cursor workflows without hidden assumptions. It explains the operating model, when to load which prompt, and how the gates fit together.

For a high-level overview of the repository, read [`README.md`](README.md) first. For the canonical list of prompts, see [`prompt-system/PROMPT_INDEX.md`](prompt-system/PROMPT_INDEX.md).

## Operating model

Crafting Kit uses **stage boundaries**. Each stage has one job and must not silently become another stage:

```text
Understand source truth        →  prompts/01, 02, 13, 110
 ↓
Build context and glossary     →  prompts/02, 104, 105, 106, 107, 108, 109
 ↓
Inventory features             →  prompts/03
 ↓
Design (HLD / LLD / ADR / RFC) →  prompts/07, 28, 29, 148, 149
 ↓
Plan repository / AI context   →  prompts/08, 103
 ↓
Review or refactor safely      →  prompts/26, 30, 121–127, 10, 111–120
 ↓
Execute bounded code           →  prompts/14 (only after risk/exec gates)
 ↓
Validate and report evidence   →  prompts/157, 94
 ↓
Aggregate readiness gates      →  prompts/85, 86, 87
```

The stage manifest at [`stage_manifest.yaml`](stage_manifest.yaml) and [`prompt-system/stage_manifest.yaml`](prompt-system/stage_manifest.yaml) is the source of truth for ordering.

## Required first load

Always begin with:

```text
prompt-system/prompts/00_claude_base_prompt.md
```

For anything non-trivial, also load:

```text
prompt-system/prompts/150_global_risk_gate.md
prompt-system/prompts/151_intent_stage_router.md
prompt-system/prompts/153_assumption_ban_contract.md
```

For any side effect (command execution, Git mutation, file write, dependency change, DB operation, deployment, external write), also load:

```text
prompt-system/prompts/154_execution_control.md
prompt-system/prompts/155_tool_permission_policy.md
```

If the work might require human approval (push, release, destructive change):

```text
prompt-system/prompts/156_human_approval_protocol.md
```

If credentials or runtime config are in scope:

```text
prompt-system/prompts/158_secret_and_runtime_credentials.md
```

Before any final claim ("validated", "passing", "deployed"):

```text
prompt-system/prompts/157_validation_and_reporting_gate.md
```

## Common workflows

### Analyze a repository

```text
Load 00, 150, 151, 153, then 01.
Ask Claude to inspect the repo and produce the analysis artifacts named by 01.
Don't ask for architecture or code in the same turn.
```

### Build a searchable project knowledge base

```text
Load 00, 02, 108, 109, 110.
Output: glossary, runtime surfaces, feature map, technical Q&A,
non-technical Q&A, and source-cited answers.
```

### Create HLD / LLD / ADR / RFC

```text
HLD       → load 00, then 07 or 28 (strict).
LLD       → load 29 (strict).
ADR       → load 148 (use templates under prompt-system/templates/adr/).
RFC       → load 149 (use prompt-system/templates/rfc/).
If any execution or source mutation is requested, also load 150–157.
```

### Review code or PRs

```text
Load 00, 26, 30, plus the relevant persona prompts from 121–127:
  121 security, 122 performance, 123 concurrency,
  124 API compatibility, 125 database, 126 DX/docs, 127 supply chain.
Require: source evidence, diff references, risk classification,
suggested changes, and validation truth.
For PR-merge gating, also load 31.
```

### Refactor safely

```text
Plan       → 10_refactoring_strategy_and_plan.md
Inventory  → 111_safe_refactoring_inventory.md
Pattern    → pick from 112 (strangler fig), 113 (modular monolith decomposition),
             114 (package boundary), 115 (dead code), 116 (DI),
             117 (error model), 118 (config model), 119 (test seam),
             120 (legacy → clean architecture).
Execute    → 11_refactoring_execution_bounded.md ONLY after 154/155.
```

### Commit and push safely

```text
Load 00, 27, 128, 129, 130, 154, 155.
Add 158 if secrets may be present.
Use git status, scoped add, staged diff review, commit message generation,
and explicit push approval.
Plugin: bash plugin/crafting-system/scripts/git-safety-preflight.sh
```

### Prepare OSS release material

```text
Load 00, 09, 22, 72, 162.
Generate or review: README, LICENSE, CONTRIBUTING, SECURITY, SUPPORT,
GOVERNANCE, CODE_OF_CONDUCT, templates, examples, docs, and release hygiene.
Reference content: reference-packs/oss_ready_organized_enhanced_pack_en/
```

### Run scheduled scoring (CI artifacts → score report)

```text
Boundary: CI measures, Claude interprets.

Trigger scanners on GitHub Actions / GitLab Pipelines (lint, tests, coverage,
SAST, dependency, secret, OpenSSF Scorecard, code-quality JSON).

Then in Claude / Cowork:
  Load 00, 150, 151, 153, then 163_scheduled_scoring_system.md
  (or /crafting-system:scheduled-scoring).
Provide:
  - repo identity (owner/name, branch, commit)
  - CI report artifacts
  - (optional) previous run report for trend
  - (optional) profile name from policies/scheduled_scoring_policy.yaml

Claude returns a scheduled_run_report (per
schemas/scheduled_run_report.schema.yaml) with:
  - normalized scores + evidence (or not_run)
  - weighted total (per active profile)
  - trend vs previous run
  - recommended_actions in immediate / this_week / later buckets
```

See [`docs/11_scheduled_scoring.md`](docs/11_scheduled_scoring.md).

### Run readiness gates

```text
Per-domain gates: 70 (security), 71 (supply chain), 72 (OSS governance),
  73 (observability/SRE), 74 (performance), 75 (docs/DX),
  76 (compliance/privacy), 77 (API contract), 78 (data/schema),
  79 (AI-ready repo), 80 (product/market), 81 (well-architected/cost),
  83 (release/launch), 84 (MCP tooling).
Aggregate: 82 (orchestrator), 85 (aggregator), 86 (go/no-go board),
  87 (executive summary), 88 (risk register), 89 (remediation plan).
```

### Use the Claude Code plugin

```bash
cd <repo-root>
bash plugin/crafting-system/scripts/validate-plugin.sh
bash plugin/crafting-system/scripts/smoke-test.sh
claude --plugin-dir ./plugin/crafting-system
```

Then invoke namespaced skills with `/crafting-system:<skill-name>`. The skill list is in `plugin/crafting-system/skills/` and registered in `prompt-system/skill_manifest.yaml`.

## Output discipline

Prefer named artifacts over chat-only answers. Every durable run should produce a `run_summary.md` (or equivalent) stating:

- inputs inspected
- artifacts created (with paths)
- validation run (with exact commands and exit status)
- validation not run (with reason)
- assumptions
- blockers
- next recommended prompt

The repo-level [`run_summary.md`](run_summary.md) is an example output.

## Developer rules

- Ask for **exact** source paths, diffs, commands, or artifact names when possible.
- Require a plan for broad or risky tasks before any execution.
- Require evidence for implementation/readiness claims.
- Keep secrets out of prompts, files, logs, artifacts, and commits — see [`SECURITY.md`](SECURITY.md) and `prompts/158`.
- Don't allow destructive Git, database, or deployment actions without explicit approval — see `prompts/156`.
- Keep reusable context in `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `docs/`, skills, or generated artifact files. Templates are under [`templates/`](templates/) and [`prompt-system/templates/`](prompt-system/templates/).
- Treat manifests (`prompt_manifest.yaml`, `skill_manifest.yaml`, `agent_manifest.yaml`, `stage_manifest.yaml`) as the source of truth for what exists. The repo intentionally rejects fabricated entries in CI via `scripts/check_inventory_consistency.py`.

## Related docs

- [`docs/01_getting_started.md`](docs/01_getting_started.md)
- [`docs/02_prompt_glossary_and_dependency_map.md`](docs/02_prompt_glossary_and_dependency_map.md)
- [`docs/03_claude_tuning_playbook.md`](docs/03_claude_tuning_playbook.md)
- [`docs/04_cursor_advanced_guide.md`](docs/04_cursor_advanced_guide.md)
- [`docs/05_secret_aware_prompt_behavior.md`](docs/05_secret_aware_prompt_behavior.md)
- [`docs/06_plugin_install_test_guide.md`](docs/06_plugin_install_test_guide.md)
- [`docs/07_oss_readiness.md`](docs/07_oss_readiness.md)
- [`docs/08_developer_workflows.md`](docs/08_developer_workflows.md)
- [`docs/09_adr_rfc_style_guide.md`](docs/09_adr_rfc_style_guide.md)
- [`docs/10_prompt_system_evaluation.md`](docs/10_prompt_system_evaluation.md)
- [`docs/11_scheduled_scoring.md`](docs/11_scheduled_scoring.md)
