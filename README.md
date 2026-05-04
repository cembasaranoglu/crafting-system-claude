# Crafting Kit

Source-first prompt and plugin system for Claude, Claude Code, Cursor, and other coding agents.

- **Author:** Cem Basaranoglu
- **License:** MIT (see [`LICENSE`](LICENSE))
- **Version:** see [`VERSION`](VERSION) and [`CHANGELOG.md`](CHANGELOG.md)
- **Plugin namespace:** `crafting-system`

Crafting Kit is a developer toolkit for repository analysis, design, code review, refactoring, documentation, release readiness, OSS preparation, and controlled execution. It is built around two principles:

1. **Source-first.** Claims must be backed by real source paths, real diffs, real commands, or real artifacts in the target repository.
2. **No fabricated validation.** Every prompt separates `fact`, `assumption`, `recommendation`, `unknown`, `blocker`, `not run`, `failed`, `validated`, `not applicable`, and `deferred`.

## Repository layout

```text
.
├── README.md                       # This file
├── GUIDE.md                        # Operating model and common workflows
├── CHANGELOG.md                    # Versioned changes
├── CONTRIBUTING.md                 # Contribution rules
├── CODE_OF_CONDUCT.md              # Project conduct expectations
├── GOVERNANCE.md                   # Maintainership and decision process
├── SECURITY.md                     # Vulnerability reporting + secret policy
├── SUPPORT.md                      # Where to get help
├── LICENSE                         # MIT
├── NOTICE                          # Attribution notice
├── VERSION                         # Plain-text version string
├── Makefile                        # validate / package-plugin / package-release
├── .claude-plugin/
│   └── marketplace.json            # Local Claude Code plugin marketplace
├── prompt-system/                  # Prompts, schemas, policies, templates
├── plugin/crafting-system/         # Claude Code plugin (skills, agents, hooks)
├── docs/                           # Developer docs (getting started, playbooks)
├── examples/                       # Example outputs
├── reference-packs/                # OSS-readiness reference material
├── release/                        # Release checklist
├── schemas/                        # Top-level scorecard schema
├── scorecards/                     # Filled scorecards
├── scripts/                        # Validation and packaging scripts
├── templates/                      # CLAUDE.md, AGENTS.md, Cursor rules
└── stage_manifest.yaml             # Stage routing manifest
```

The repo is intentionally organized as two usable layers:

- [`prompt-system/`](prompt-system/) — copy-ready prompts, readiness gates, policies, schemas, templates, and prompt tests.
- [`plugin/crafting-system/`](plugin/crafting-system/) — Claude Code plugin skeleton with namespaced skills, subagents, hook examples, MCP/LSP examples, and local validation scripts.

## What's inside (today)

These counts reflect the working tree at the current `VERSION`:

- **133 prompts** under `prompt-system/prompts/` (see [`prompt-system/PROMPT_INDEX.md`](prompt-system/PROMPT_INDEX.md)).
- **41 skills** under `plugin/crafting-system/skills/<skill-name>/SKILL.md`.
- **28 subagents** under `plugin/crafting-system/agents/*.md`.
- **5 policies** (`execution_class_matrix`, `hard_stop_triggers`, `research_policy`, `risk_scoring_model`, `tool_permission_policy`) under `prompt-system/policies/`.
- **4 schemas** (`approval_request`, `execution_gate`, `minimum_input_request`, `risk_score`) under `prompt-system/schemas/`.
- **Templates** for `CLAUDE.md`, `AGENTS.md`, ADR (Nygard, Enterprise), RFC, glossary, feature inventory, AI context, and Cursor rules.
- **Validation scripts** under `scripts/` and `plugin/crafting-system/scripts/` (see [Validation](#validation)).

## What this kit does

Crafting Kit covers, end to end:

- source-first repository analysis and glossary/context generation
- feature inventory and implementation-readiness audit
- high-level and low-level design (strict format)
- ADR and RFC generation
- strict code review and code-quality gates
- safe refactoring plans and bounded code-authoring prompts
- readiness gates for security, supply chain, OSS governance, observability, performance, documentation, compliance, API contract, data/schema, AI-readiness, product-market, well-architected/cost, MCP tooling, and release/launch
- readiness aggregation and go/no-go decisions
- prompt tuning, evaluation harnesses, regression suites, and golden output validation
- Claude Code plugin packaging and local validation
- Cursor rules and `AGENTS.md` generation
- secret-aware runtime credential behavior
- Git branch, commit, PR, push, and release safety gates

## What this kit does not do

- It is **not** an official Anthropic, Cursor, or OpenAI artifact.
- It does **not** guarantee a repository is production-ready or OSS-ready — it provides gates and evidence collection, not a stamp.
- It does **not** install itself into Claude Code or Cursor automatically.
- It does **not** authorize destructive commands, production deploys, secret access, or `git push` — those require explicit human approval.
- It does **not** replace human review for security, legal, compliance, release, or operational decisions.

## Quick start

```bash
# 0. One-time: create venv and install Python deps (PyYAML).
make setup

# 1. Validate the static contract (manifests, frontmatter, schemas, hooks).
make validate
# or, with a custom interpreter:
PYTHON_BIN=$(which python3) bash scripts/validate_all.sh

# 2. Validate the Claude Code plugin and run the local smoke test.
bash plugin/crafting-system/scripts/validate-plugin.sh
bash plugin/crafting-system/scripts/smoke-test.sh

# 3. (Optional) Load the plugin in Claude Code from the package root.
claude --plugin-dir ./plugin/crafting-system
```

`make setup` creates `./.venv` (if missing) and installs the dependencies in [`requirements.txt`](requirements.txt) (currently just `PyYAML`). After that, `make validate` automatically uses `./.venv/bin/python3` unless you override `PYTHON_BIN`.

Then read, in order:

1. [`docs/01_getting_started.md`](docs/01_getting_started.md)
2. [`docs/02_prompt_glossary_and_dependency_map.md`](docs/02_prompt_glossary_and_dependency_map.md)
3. [`docs/03_claude_tuning_playbook.md`](docs/03_claude_tuning_playbook.md)
4. [`docs/04_cursor_advanced_guide.md`](docs/04_cursor_advanced_guide.md)
5. [`docs/05_secret_aware_prompt_behavior.md`](docs/05_secret_aware_prompt_behavior.md)
6. [`plugin/crafting-system/README.md`](plugin/crafting-system/README.md)

## Recommended default flow

```text
00 Base contract
 ├─ 150 Global Risk Gate
 ├─ 151 Intent / Stage Router
 ├─ 153 No-Assumption Contract
 ├─ <stage prompt>          # e.g. 01, 02, 03, 26, 28, 29, 148, 149
 ├─ 158 Secret/Runtime Credentials   (when credentials/runtime config are in scope)
 ├─ 154 Execution Control            (before any tool/side-effect action)
 ├─ 155 Tool Permission Policy       (when tools are used)
 ├─ 156 Human Approval Protocol      (when required)
 └─ 157 Validation and Reporting Gate (before any claim)
```

For standard repository work, start with:

```text
prompt-system/prompts/00_claude_base_prompt.md
prompt-system/prompts/150_global_risk_gate.md
prompt-system/prompts/151_intent_stage_router.md
prompt-system/prompts/153_assumption_ban_contract.md
prompt-system/prompts/01_source_analysis_to_artifact_pack.md
```

Then continue based on the task:

| Goal | Prompt |
|---|---|
| Glossary / project memory | `02_project_context_glossary_memory_builder.md` |
| Feature inventory + readiness audit | `03_feature_inventory_and_readiness_audit.md` |
| Product narrative | `04_product_vision_and_problem_solution_analysis.md` |
| HLD / LLD (strict) | `28_high_level_design_strict.md`, `29_low_level_design_strict.md` |
| ADR / RFC | `148_adr_generator.md`, `149_rfc_generator.md` |
| AI-ready repo context | `08_repository_ai_ready_and_skeleton.md`, `103_ai_context_compiler_claude_agents_cursor_llms.md` |
| Refactor (plan, then bounded execution) | `10_refactoring_strategy_and_plan.md` → `11_refactoring_execution_bounded.md` |
| Strict code review | `26_code_review_quality_gate.md` (+ persona prompts `121`–`127`) |
| Safe Git workflow | `27_git_commit_branch_push_workflow.md` |
| Readiness gates | `70`–`84`, then `85_readiness_gate_aggregator.md` |
| Secret / runtime credentials | `158_secret_and_runtime_credentials.md` |
| OSS packaging | `162_oss_ready_packager.md` |

The full list with stages and statuses is in [`prompt-system/PROMPT_INDEX.md`](prompt-system/PROMPT_INDEX.md). The stage manifest (the source of truth for ordering) is [`stage_manifest.yaml`](stage_manifest.yaml) and [`prompt-system/stage_manifest.yaml`](prompt-system/stage_manifest.yaml).

## Claude Code plugin

The plugin skeleton is at [`plugin/crafting-system/`](plugin/crafting-system/). Local test:

```bash
bash plugin/crafting-system/scripts/validate-plugin.sh
bash plugin/crafting-system/scripts/smoke-test.sh
claude --plugin-dir ./plugin/crafting-system
```

Example skill invocations after loading the plugin (full list under `plugin/crafting-system/skills/`):

```text
/crafting-system:prompt-audit
/crafting-system:risk-execution-control
/crafting-system:secret-aware-runtime-credentials
/crafting-system:code-review-quality-gate
/crafting-system:adr-rfc-writer
/crafting-system:readiness-aggregator
/crafting-system:cursor-rules-compiler
```

See [`plugin/crafting-system/README.md`](plugin/crafting-system/README.md) for skill/agent inventory, hook examples, MCP/LSP examples, and packaging.

The local Claude Code marketplace descriptor lives at [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json).

## Validation

`make validate` (or `bash scripts/validate_all.sh`) runs:

1. `python3 scripts/validate_all.py` — drives the per-domain validators below.
2. `bash plugin/crafting-system/scripts/test-hooks.sh` — checks hook scripts behave as documented.
3. `bash plugin/crafting-system/scripts/test-secret-scan.sh` — runs the secret scan against `plugin/crafting-system/tests/fixtures/secrets/`.

The Python validators exercised by `validate_all.py` include:

```text
scripts/validate_yaml.py
scripts/validate_frontmatter.py
scripts/validate_prompt_manifest.py
scripts/validate_prompt_to_skill_map.py
scripts/validate_skill_policy.py
scripts/validate_mcp_policy.py
scripts/validate_execution_matrix.py
scripts/validate_stage_manifest.py
scripts/validate_eval_scenarios.py
scripts/validate_scorecard.py
scripts/validate_agents.py
scripts/check_skill_size.py
scripts/check_duplicate_prompt_ids.py
scripts/check_inventory_consistency.py
scripts/lint_prompt_contracts.py
```

Set `PYTHON_BIN` to override the interpreter. Example:

```bash
PYTHON_BIN=/opt/pyvenv/bin/python3 bash scripts/validate_all.sh
```

`validate_all.sh` exits non-zero on first failure and prints the failing step.

## Packaging

```bash
make package-plugin    # plugin zip → /tmp/crafting-system-plugin.zip
make package-release   # full release zip → /tmp/crafting-kit-release.zip
```

Both targets call into shell scripts that exclude `.git`, `*.zip`, log/temp files, and obvious credential filenames (`.env`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `secrets/`). Review the exclude list in [`scripts/package_release.sh`](scripts/package_release.sh) and [`plugin/crafting-system/scripts/package-plugin.sh`](plugin/crafting-system/scripts/package-plugin.sh) before publishing.

The release checklist (with what was validated locally and what was deferred) is at [`release/RELEASE_CHECKLIST.md`](release/RELEASE_CHECKLIST.md).

## OSS / community files

This repo ships:

- [`LICENSE`](LICENSE) — MIT
- [`NOTICE`](NOTICE)
- [`CONTRIBUTING.md`](CONTRIBUTING.md)
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)
- [`SECURITY.md`](SECURITY.md)
- [`SUPPORT.md`](SUPPORT.md)
- [`GOVERNANCE.md`](GOVERNANCE.md)
- [`CHANGELOG.md`](CHANGELOG.md)

GitHub issue and PR templates are not included by default. If you fork or vendor this repo, generate them with `prompt-system/prompts/162_oss_ready_packager.md` and reference [`reference-packs/oss_ready_organized_enhanced_pack_en/`](reference-packs/oss_ready_organized_enhanced_pack_en/) for tested content.

## Validation status of this checkout

The version recorded in [`release/RELEASE_CHECKLIST.md`](release/RELEASE_CHECKLIST.md) was validated locally with:

- `scripts/validate_all.sh`
- `plugin/crafting-system/scripts/validate-plugin.sh`
- `plugin/crafting-system/scripts/smoke-test.sh`
- `plugin/crafting-system/scripts/test-hooks.sh`
- `plugin/crafting-system/scripts/test-secret-scan.sh`
- packaging via `scripts/package_release.sh` and `plugin/crafting-system/scripts/package-plugin.sh`

External gates that were **not** run in that environment (Claude Code CLI runtime load, marketplace publication) are listed as `not run` in the same file. Re-run the static gates before claiming readiness from this checkout.

## Support and contact

- File issues / feature requests in your fork's tracker. See [`SUPPORT.md`](SUPPORT.md).
- Security reports: see [`SECURITY.md`](SECURITY.md). Do **not** file public issues for suspected vulnerabilities or exposed secrets.
- Contributions: see [`CONTRIBUTING.md`](CONTRIBUTING.md) — keep changes scoped, preserve evidence-based reporting, and don't weaken security or execution gates to make tests pass.
