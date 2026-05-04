# Getting Started

Crafting Kit is used in three modes:

1. **Prompt pack mode** — copy a prompt from `prompt-system/prompts/` into Claude or another agent.
2. **Plugin mode** — load `plugin/crafting-system` in Claude Code and invoke namespaced skills.
3. **Repository context mode** — generate `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `docs/ai/*`, and validation catalogs for a target repository.

## Minimum recommended setup

```text
1. Read README.md and GUIDE.md.
2. Open docs/02_prompt_glossary_and_dependency_map.md.
3. Choose the current task stage.
4. Load 00_claude_base_prompt.md.
5. Load the relevant risk/execution/secret prompts when applicable.
6. Load one stage prompt.
7. Ask for named artifacts and validation truth.
```

## Stage routing shortcut

| User goal | Start with |
|---|---|
| Understand a repository | `01_source_analysis_to_artifact_pack.md` |
| Build project glossary/context | `02_project_context_glossary_memory_builder.md` |
| Find actual implemented features | `03_feature_inventory_and_readiness_audit.md` |
| Explain product/problem/solution | `04_product_vision_and_problem_solution_analysis.md` |
| Explain code to non-technical audience | `05_nontechnical_code_explainer.md` |
| Create HLD/LLD | `28_high_level_design_strict.md`, `29_low_level_design_strict.md` |
| Create ADR/RFC | `148_adr_generator.md`, `149_rfc_generator.md` |
| Review code | `26_code_review_quality_gate.md` |
| Plan safe refactor | `10_refactoring_strategy_and_plan.md` |
| Execute bounded refactor | `11_refactoring_execution_bounded.md` |
| Commit safely | `27_git_commit_branch_push_workflow.md` |
| Prepare OSS docs | `09_readme_and_oss_docs_writer.md`, `162_oss_ready_packager.md` |
| Handle secrets/runtime credentials | `158_secret_and_runtime_credentials.md` |
| Aggregate readiness | `85_readiness_gate_aggregator.md` |

## Output discipline

Prefer named artifacts over long chat-only answers. Every durable run should include a `run_summary.md` or equivalent summary stating:

- inputs inspected
- artifacts created
- validation run
- validation not run
- assumptions
- blockers
- next recommended prompt
