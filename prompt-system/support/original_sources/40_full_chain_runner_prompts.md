> Shared prerequisite: Before using this prompt, load and obey `prompts/00_base_prompt.md`. This stage-specific prompt adds narrower instructions and must not weaken the base contract.

# 40 — Ready-to-Copy Full Chain Prompts

Use these prompt blocks in order.

## A — Analyze

```text
Use the attached revised prompt set.
Run `prompts/00_analyze_to_artifact_pack.md`.

Mode: ANALYZE_TO_ARTIFACT_PACK
Research mode: SOURCE_ONLY unless explicitly allowed otherwise.
File creation: CREATE_FILES if possible.

Use:
- Input A: attached analysis document / domain artifact / RFC / product brief / discovery note / source archive.
- Input B: latest explicit user instruction.
- Optional Input C: attached examples, repository zip, schemas, logs, screenshots, tickets, or prior artifacts.

Requirements:
- Inspect all attached source material first.
- Treat examples as examples unless explicitly binding.
- Separate facts, assumptions, recommendations, unknowns, contradictions, non-goals, and blockers.
- Produce corrected analysis artifacts only.
- Do not design final architecture.
- Do not create repository structure.
- Do not write code.
- Package outputs into a zip if file creation is possible.
```

## B — Architecture

```text
Use the attached revised prompt set.
Run `prompts/10_architecture_design.md`.

Mode: ARCHITECTURE_DESIGN
Research mode: SOURCE_ONLY unless explicitly allowed otherwise.
File creation: CREATE_FILES if possible.

Use:
- Input A: attached `project_context.md`.
- Input B: attached `corrected_analysis_artifact.md`.
- Input C: attached `gap_register.yaml`.
- Input D: attached `contradiction_register.yaml`.
- Input E: attached `runtime_surface_register.yaml`.
- Input F: attached `data_integration_register.yaml`.
- Input G: attached `deliverable_candidate_register.md`.
- Optional Input H: original source document for traceability.

Requirements:
- Design architecture only from validated artifacts and explicit assumptions.
- Define runtime surfaces, components, boundaries, dependency direction, data/contracts/state, integrations, quality attributes, security, observability, deployment assumptions, validation strategy, and repository handoff.
- Do not create repository files.
- Do not write implementation code.
- Package outputs into a zip if file creation is possible.
```

## C — Repository

```text
Use the attached revised prompt set.
Run `prompts/20_repository_create_or_plan.md`.

Mode: REPOSITORY_CREATE_OR_PLAN
Research mode: SOURCE_ONLY.
Execution style: CREATE_FILES or PLAN_ONLY as instructed.

Use:
- Input A: attached `project_context.md`.
- Input B: attached `corrected_analysis_artifact.md`.
- Input C: attached `architecture_to_repository_handoff.yaml`.
- Input D: attached `deliverable_to_architecture_map.yaml`.
- Optional Input E: current repository state or uploaded repository zip if any.

Repository materialization, if CREATE_FILES:
- target_repo_root: `<absolute final shipped repo root>`
- execution_artifacts_root: `<absolute path outside repo>`
- temporary_staging_root: `<absolute path outside repo>`
- bundle_output_root: `<absolute path outside repo>`
- command_log_root: `<absolute path outside repo>`
- create_shipped_layout_at_target_root: yes
- allow_wrapper_dirs_in_target_repo: no

Requirements:
- Create or plan the skeleton only.
- Do not implement feature code.
- Keep run artifacts outside the shipped repository.
- Package outputs into a zip if file creation is possible.
```

## D — Code

```text
Use the attached revised prompt set.
Run `prompts/30_code_authoring.md`.

Mode: BOUNDED_CODE_AUTHORING
Research mode: SOURCE_ONLY unless explicitly allowed otherwise.
Execution style: EXECUTE_BOUNDED_TASK.

Use:
- Input A: current target repository.
- Input B: bounded task description below.
- Input C: attached architecture artifacts.
- Input D: attached repository artifacts: `repository_tree.md`, `path_manifest.yaml`, `deliverable_to_path_map.yaml` if available.
- Optional Input E: specs, schemas, configs, examples, tests, logs, API contracts, or bug report.
- Optional Input F: `prompts/31_go_specific_addon.md` only if Go is in scope.

Bounded task:
<write exactly one bounded implementation task here>

Requirements:
- Inspect repository before editing.
- Execute only this bounded task.
- Update tests/docs/configs/schemas when changed surfaces require it.
- Do not perform unrelated refactors.
- Do not redesign architecture or repository layout unless explicitly required by this task.
- Validate with exact commands when validation is allowed.
- Report what changed, what ran, what did not run, what remains assumed or blocked.
```
