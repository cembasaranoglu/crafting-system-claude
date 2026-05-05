> Claude compatibility: This prompt is designed for Claude Code and Claude chat. It uses explicit stage boundaries, XML-style sections, artifact names, truth labels, and command-safe repository behavior. Load `prompts/00_claude_base_prompt.md` before this prompt unless this file is used as a standalone emergency prompt.


# 40 — Ready-to-Copy Full Chain Prompts for Claude

Use these prompt blocks in order. Replace placeholders before running.

---

## 0 — Install Base / Read Rules

```text
Use the uploaded Claude advanced prompt system.

First load and obey:
- prompts/00_claude_base_prompt.md

Task:
Confirm the operating contract, source-first behavior, truth labels, stage boundaries, artifact discipline, repository root discipline, validation honesty, and Claude context rules.

Do not inspect the repository yet unless I attach one in this same message.
```

---

## 1 — Analyze Source Material

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/01_source_analysis_to_artifact_pack.md

Mode: ANALYZE_TO_ARTIFACT_PACK
Research mode: SOURCE_ONLY unless I explicitly allow external research.
File creation: CREATE_FILES if possible.

Inputs:
- attached repository/source/document/artifact
- latest instruction below

Task:
Run source analysis and produce the complete analysis artifact pack.

Do not design final architecture.
Do not create repository structure.
Do not write code.
Package outputs into a zip if file creation is possible.
```

---

## 2 — Build Project Glossary and Claude Context

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/02_project_context_glossary_memory_builder.md

Mode: PROJECT_CONTEXT_GLOSSARY_AND_QA_MEMORY
File creation: CREATE_FILES if possible.

Inputs:
- repository/source artifacts
- prior analysis artifacts if available

Task:
Create a detailed glossary, AI context document, question routing map, feature knowledge index, and Claude-ready context artifacts so future technical and non-technical questions can be answered from source evidence.

Do not modify source code.
Package outputs into a zip if file creation is possible.
```

---

## 3 — Feature Inventory

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/03_feature_inventory_and_readiness_audit.md

Mode: FEATURE_INVENTORY_AND_READINESS_AUDIT
File creation: CREATE_FILES if possible.

Task:
Inspect the repository and produce an evidence-backed feature inventory. Classify each feature as implemented, partial, docs-only, mock-only, test-only, not found, or unknown.

Do not implement fixes.
Do not modify source code.
Package outputs into a zip if possible.
```

---

## 4 — Product Vision / Problem-Solution

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/04_product_vision_and_problem_solution_analysis.md

Mode: PRODUCT_VISION_FROM_CODEBASE
File creation: CREATE_FILES if possible.

Task:
Analyze the codebase and docs to explain the problem, solution, users, workflows, feature set, differentiators, limitations, and product vision in clear product-minded language.

Do not overclaim feature readiness.
Package outputs into a zip if possible.
```

---

## 5 — Architecture

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/07_architecture_design.md

Mode: ARCHITECTURE_DESIGN
File creation: CREATE_FILES if possible.

Inputs:
- project_context.md
- corrected_analysis_artifact.md
- gap_register.yaml
- contradiction_register.yaml
- runtime_surface_register.yaml
- data_integration_register.yaml
- deliverable_candidate_register.md
- feature inventory if available

Task:
Design architecture from validated artifacts only and produce the architecture artifact pack.

Do not write implementation code.
Package outputs into a zip if possible.
```

---

## 6 — AI-Ready Repository / Claude + Cursor Context

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/08_repository_ai_ready_and_skeleton.md
- prompts/18_cursor_integration_prompt.md
- prompts/19_claude_code_context_install_prompt.md

Mode: AI_READY_REPOSITORY_CONTEXT
Execution style: CREATE_OR_UPDATE_ASSETS if I explicitly allow repository modifications; otherwise PLAN_ONLY.

Task:
Make or plan the repository AI-ready for Claude Code and Cursor. Add/update only stable repository-owned AI context files, docs, Claude skills/agents templates, Cursor rules, and ignore policies. Do not commit personal AI workspace or session artifacts.

Do not implement product features.
Package outputs into a zip if possible.
```

---

## 7 — README and OSS Docs

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/09_readme_and_oss_docs_writer.md
- prompts/20_documentation_map_and_docs_content_prompt.md
- prompts/22_oss_readiness_and_release_packaging.md

Mode: README_AND_OSS_DOCS
File creation: CREATE_FILES if possible.

Task:
Create or update README and OSS documentation based on source truth. Include docs map, content requirements, OSS readiness gaps, and safe claims only.

Package outputs into a zip if possible.
```

---

## 8 — Refactoring Plan

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/10_refactoring_strategy_and_plan.md

Mode: REFACTORING_PLAN_ONLY
File creation: CREATE_FILES if possible.

Task:
Inspect the repository and create a robust, strict, behavior-preserving refactoring wave plan with safety tests, risks, rollback strategy, and next bounded prompt.

Do not modify source code.
Package outputs into a zip if possible.
```

---

## 9 — Bounded Code or Refactoring Execution

```text
Use the uploaded Claude advanced prompt system.

Load and obey:
- prompts/00_claude_base_prompt.md
- prompts/14_bounded_code_authoring.md
- prompts/15_go_specific_addon.md only if Go is in scope
- prompts/16_testing_pyramid_and_unit_tests.md if tests are in scope

Mode: BOUNDED_CODE_AUTHORING
Execution style: EXECUTE_BOUNDED_TASK

Bounded task:
<write exactly one bounded task or one selected wave id here>

Requirements:
- Inspect repository before editing.
- Keep changes scoped.
- Update tests/docs/config/schema parity.
- Validate truthfully.
- Produce change set, validation report, and run summary.
```
