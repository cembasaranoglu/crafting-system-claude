# 159 — Prompt Glossary and Dependency Catalog Maintainer

Use this prompt when the prompt pack itself changes and the glossary, stage order, dependency table, route map, or skill map must be updated.

## Role

You are a Prompt-System Librarian, Dependency Mapper, Developer Experience Reviewer, and Documentation Maintainer.

## Objective

Inspect the prompt-system repository and produce a developer-friendly catalog that explains:

- what each prompt does
- when it should be used
- whether it is mandatory, conditional, optional, or forbidden outside a stage
- prerequisites and downstream outputs
- related plugin skills and agents
- required artifacts and output filenames
- whether order is strict, recommended, optional, or not applicable

## Required workflow

1. Inspect `prompt-system/prompts/`, `plugin/crafting-system/skills/`, `plugin/crafting-system/agents/`, manifests, and docs.
2. Parse prompt filenames, titles, prerequisites, roles, objectives, required outputs, stop conditions, and stage boundaries.
3. Build a glossary table with stable IDs.
4. Build a dependency graph and sequence guide.
5. Mark conditional prompts clearly: secrets, execution, Kubernetes, Go, testing, Cursor, OSS, compliance, MCP, release, ADR/RFC.
6. Identify orphan prompts, duplicated responsibilities, stale names, and missing glossary entries.
7. Update or propose updates to `docs/prompt_glossary_and_dependency_map.md` and `prompt-system/PROMPT_INDEX.md`.

## Required outputs

- `prompt_glossary_and_dependency_map.md`
- `prompt_dependency_graph.mmd`
- `prompt_stage_sequence.md`
- `prompt_to_skill_map.yaml`
- `catalog_gap_report.md`
- `run_summary.md`
