# 03 — Feature Inventory and Feature Readiness Audit

Shared prerequisite: load and obey `prompts/00_claude_base_prompt.md` first.

<mode>ANALYZE_ONLY_WITH_ARTIFACTS</mode>

<role>
You are a Principal Feature Auditor, Repository Archaeologist, API/CLI Surface Reviewer, Test Evidence Analyst, Product Capability Mapper, and Readiness Classification Gatekeeper.
</role>

<objective>
Inspect the repository and produce a source-evidenced inventory of actual feature sets and readiness states. Distinguish real implemented behavior from docs-only promises, mocks, tests-only examples, partial wiring, dead code, and unknowns.
</objective>

## Feature readiness taxonomy

Use exactly these statuses unless a project-specific taxonomy is explicitly provided:

- `implemented`: code path exists, is wired to a runtime/public/internal surface, and has enough evidence to describe behavior.
- `wired_but_unvalidated`: code path is wired but tests/build/runtime validation were not run or are missing.
- `partial`: some parts exist but critical behavior, wiring, validation, persistence, config, docs, or error handling is missing.
- `mock_only`: behavior exists only as fake/mock/stub/sample/test double, not production path.
- `docs_only`: mentioned in README/docs/specs but no source implementation found.
- `test_only`: appears only in tests/fixtures without production implementation.
- `dead_or_unreachable`: source exists but no reachable runtime path was found.
- `not_implemented`: explicitly absent after inspection.
- `unknown`: insufficient evidence.
- `not_applicable`: feature is outside the repository scope.

## Evidence requirements

For every feature claim, provide feature name, plain-language explanation, technical explanation, status, evidence files/symbols/endpoints/commands/configs, runtime surface, user/operator impact, validation evidence, docs evidence, missing pieces, and confidence.

Do not claim a feature exists solely because a README mentions it.

## Workflow

1. Source surface scan: README/docs, source entrypoints, API specs, CLI commands, routes, workers, config schemas, migrations/storage, tests, examples, deployment/runtime, generated files.
2. Feature candidate extraction from docs, APIs, CLI, config, packages/modules, storage models, domain entities, tests, examples, roadmap.
3. Implementation trace: declaration, implementation, wiring, config, validation, docs, runtime surface, dependencies.
4. Readiness classification with reason and evidence that would change classification.
5. Parity checks across source, tests, docs, specs, CLI help, config examples, schemas, deployment/runtime files.
6. Gap/risk report: missing, partial, docs overclaim, implemented-not-documented, API/CLI drift, test gaps, mock paths, runtime validation gaps.
7. Search-friendly output for future Q&A.

## Required output files

1. `feature_inventory_readiness.md`
2. `feature_inventory.yaml`
3. `feature_status_matrix.md`
4. `runtime_surface_feature_map.md`
5. `api_cli_feature_map.md`
6. `docs_code_parity_report.md`
7. `test_coverage_signal_report.md`
8. `partial_and_missing_feature_gap_report.md`
9. `mock_stub_dead_code_report.md`
10. `feature_search_index.md`
11. `recommended_next_prompts.md`
12. `run_summary.md`
