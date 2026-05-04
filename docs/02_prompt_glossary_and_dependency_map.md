# Prompt Glossary and Dependency Map

This catalog explains what each Crafting Kit prompt does, what it depends on, and whether its order is strict, recommended, optional, or conditional.

| Prompt | Purpose | Category | Depends on | Order |
|---|---|---|---|---|
| `00_claude_base_prompt.md` | 00 — Claude Base Prompt for Staged Repository Intelligence | base contract | none | strict first |
| `00_claude_base_prompt_execution_addendum.md` | 00A — Base Prompt Execution Addendum | base contract | none | strict first |
| `01_source_analysis_to_artifact_pack.md` | 01 — Source Analysis to Development-Ready Artifact Pack | analysis and context | 00_claude_base_prompt.md | stage order recommended |
| `02_project_context_glossary_memory_builder.md` | 02 — Project Context, Glossary, and Claude/Cursor Knowledge Pack Builder | analysis and context | 00_claude_base_prompt.md | stage order recommended |
| `03_feature_inventory_and_readiness_audit.md` | 03 — Feature Inventory and Feature Readiness Audit | analysis and context | 00_claude_base_prompt.md | stage order recommended |
| `04_product_vision_and_problem_solution_analysis.md` | 04 — Product-Minded Problem, Solution, and Vision Analysis from Code | analysis and context | 00_claude_base_prompt.md | stage order recommended |
| `05_nontechnical_code_explainer.md` | 05 — Non-Technical Codebase Explainer | analysis and context | 00_claude_base_prompt.md | stage order recommended |
| `06_high_level_low_level_technical_design.md` | 06 — High-Level and Low-Level Technical Design Explainer | analysis and context | 00_claude_base_prompt.md | stage order recommended |
| `07_architecture_design.md` | 07 — Architecture Design Prompt for Claude | architecture and design | 00_claude_base_prompt.md | stage order recommended |
| `08_repository_ai_ready_and_skeleton.md` | 08 — Repository AI-Ready Structure, Claude Context, Cursor Rules, and Skeleton Prompt | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `09_readme_and_oss_docs_writer.md` | 09 — README and OSS Documentation Writer Prompt | documentation and product | 00_claude_base_prompt.md | stage order recommended |
| `100_architecture_fitness_functions.md` | 100 — Architecture Fitness Functions | architecture and design | 00_claude_base_prompt.md | stage order recommended |
| `101_dependency_boundary_enforcer.md` | 101 — Dependency Boundary Enforcer | architecture and design | 00_claude_base_prompt.md | stage order recommended |
| `102_runtime_surface_drift_detector.md` | 102 — Runtime Surface Drift Detector | architecture and design | 00_claude_base_prompt.md | stage order recommended |
| `103_ai_context_compiler_claude_agents_cursor_llms.md` | 103 — AI Context Compiler | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `104_claude_md_generator.md` | 104 — CLAUDE.md Generator | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `105_agents_md_generator.md` | 105 — AGENTS.md Generator | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `106_cursor_rules_generator.md` | 106 — Cursor Rules Generator | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `107_llms_txt_generator.md` | 107 — llms.txt Generator | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `108_repo_intelligence_database_builder.md` | 108 — Repository Intelligence Database Builder | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `109_repo_qa_knowledge_base_builder.md` | 109 — Repository Q&A Knowledge Base Builder | AI context and knowledge base | 00_claude_base_prompt.md | stage order recommended |
| `10_refactoring_strategy_and_plan.md` | 10 — Refactoring Strategy, Safety Plan, and Wave Design Prompt | refactoring and patch control | 00_claude_base_prompt.md | stage order recommended |
| `110_source_cited_repo_answerer.md` | 110 — Source-Cited Repository Answerer | AI context and knowledge base | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `111_safe_refactoring_inventory.md` | 111 — Safe Refactoring Inventory | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `112_strangler_fig_refactoring_plan.md` | 112 — Strangler Fig Refactoring Plan | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `113_modular_monolith_decomposition.md` | 113 — Modular Monolith Decomposition | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `114_package_boundary_refactor.md` | 114 — Package Boundary Refactor | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `115_dead_code_removal_gate.md` | 115 — Dead Code Removal Gate | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `116_dependency_inversion_refactor.md` | 116 — Dependency Inversion Refactor | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `117_error_model_refactor.md` | 117 — Error Model Refactor | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `118_config_model_refactor.md` | 118 — Config Model Refactor | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `119_test_seam_refactor.md` | 119 — Test Seam Refactor | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `11_refactoring_execution_bounded.md` | 11 — Bounded Refactoring Execution Prompt | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `120_legacy_to_clean_architecture_migration.md` | 120 — Legacy to Clean Architecture Migration | refactoring and patch control | 00_claude_base_prompt.md | optional or task-triggered |
| `121_security_code_review_persona.md` | 121 — Security Code Review Persona | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `122_performance_code_review_persona.md` | 122 — Performance Code Review Persona | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `123_concurrency_code_review_persona.md` | 123 — Concurrency Code Review Persona | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `124_api_compatibility_code_review_persona.md` | 124 — API Compatibility Code Review Persona | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `125_database_code_review_persona.md` | 125 — Database Code Review Persona | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `126_dx_docs_code_review_persona.md` | 126 — DX and Docs Code Review Persona | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `127_supply_chain_release_reviewer.md` | 127 — Supply Chain and Release Reviewer | review personas | 00_claude_base_prompt.md | optional or task-triggered |
| `128_git_branch_strategy_generator.md` | 128 — Git Branch Strategy Generator | git and release safety | 00_claude_base_prompt.md | optional or task-triggered |
| `129_semantic_commit_atomic_commit_planner.md` | 129 — Semantic Commit and Atomic Commit Planner | git and release safety | 00_claude_base_prompt.md | optional or task-triggered |
| `12_competitor_analysis.md` | 12 — Competitor and Alternatives Analysis Prompt | other | 00_claude_base_prompt.md | optional or task-triggered |
| `130_protected_branch_signed_release_git_gate.md` | 130 — Protected Branch, Signed Commit, and Push Gate | git and release safety | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | optional or task-triggered |
| `131_product_problem_solution_narrative.md` | 131 — Product Problem/Solution Narrative | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `132_technical_product_one_pager.md` | 132 — Technical Product One-Pager | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `133_technical_session_30_min.md` | 133 — 30-Minute Technical Session | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `134_demo_script_generator.md` | 134 — Demo Script Generator | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `135_executive_summary_generator.md` | 135 — Executive Summary Generator | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `136_non_technical_architecture_story.md` | 136 — Non-Technical Architecture Story | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `137_faq_generator.md` | 137 — FAQ Generator | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `138_sales_engineering_enablement.md` | 138 — Sales Engineering Enablement | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `139_compliance_evidence_collector.md` | 139 — Compliance Evidence Collector | compliance and MCP | 00_claude_base_prompt.md | optional or task-triggered |
| `13_codebase_search_and_answer_prompt.md` | 13 — Codebase Search, Q&A, and Evidence Answer Prompt | other | 00_claude_base_prompt.md | optional or task-triggered |
| `140_soc2_iso27001_control_mapper.md` | 140 — SOC 2 / ISO 27001 Control Mapper | engineering workflow | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `141_gdpr_kvkk_privacy_evidence.md` | 141 — GDPR / KVKK Privacy Evidence | engineering workflow | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `142_mcp_tool_permission_model.md` | 142 — MCP Tool Permission Model | engineering workflow | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `143_mcp_write_action_gate.md` | 143 — MCP Write Action Gate | engineering workflow | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `144_diff_only_code_authoring.md` | 144 — Diff-Only Code Authoring | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `145_minimal_patch_mode.md` | 145 — Minimal Patch Mode | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `146_large_diff_reduction.md` | 146 — Large Diff Reduction | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `147_patch_risk_classifier.md` | 147 — Patch Risk Classifier | refactoring and patch control | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `148_adr_generator.md` | 148 — Architecture Decision Record (ADR) Generator | architecture and design | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md, 01_source_analysis_to_artifact_pack.md or validated source artifacts | stage order recommended |
| `149_rfc_generator.md` | 149 — Request for Comments (RFC) Generator | architecture and design | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md, 01_source_analysis_to_artifact_pack.md or validated source artifacts | stage order recommended |
| `14_bounded_code_authoring.md` | 14 — Bounded Code Authoring Prompt for Claude | engineering workflow | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | stage order recommended |
| `150_design_doc_format_converter.md` | 150 — Design Document Format Converter | risk and execution | 00_claude_base_prompt.md | recommended before any non-trivial stage |
| `150_global_risk_gate.md` | 01 — Global Risk Gate Prompt | risk and execution | 00_claude_base_prompt.md | recommended before any non-trivial stage |
| `151_decision_log_adr_index.md` | 151 — Decision Log and ADR Index | risk and execution | 00_claude_base_prompt.md | recommended before any non-trivial stage |
| `151_intent_stage_router.md` | 02 — Intent and Stage Router Prompt | risk and execution | 00_claude_base_prompt.md | recommended before any non-trivial stage |
| `152_api_rfc_review_gate.md` | 152 — API RFC Review Gate | risk and execution | 00_claude_base_prompt.md | conditional before research |
| `152_research_need_gate.md` | 03 — Research Need Gate Prompt | risk and execution | 00_claude_base_prompt.md | conditional before research |
| `153_assumption_ban_contract.md` | 04 — No-Assumption Execution Contract | risk and execution | 00_claude_base_prompt.md | recommended before any non-trivial stage |
| `154_execution_control.md` | 70 — Global Execution Control Prompt | risk and execution | 00_claude_base_prompt.md, 150_global_risk_gate.md, 151_intent_stage_router.md, 153_assumption_ban_contract.md | strict before/after side-effect execution as applicable |
| `155_tool_permission_policy.md` | 71 — Tool Permission Policy Prompt | risk and execution | 00_claude_base_prompt.md, 150_global_risk_gate.md, 151_intent_stage_router.md, 153_assumption_ban_contract.md | strict before/after side-effect execution as applicable |
| `156_human_approval_protocol.md` | 72 — Human Approval Protocol Prompt | risk and execution | 00_claude_base_prompt.md, 150_global_risk_gate.md, 151_intent_stage_router.md, 153_assumption_ban_contract.md | strict before/after side-effect execution as applicable |
| `157_validation_and_reporting_gate.md` | 73 — Validation and Reporting Gate Prompt | risk and execution | 00_claude_base_prompt.md, 150_global_risk_gate.md, 151_intent_stage_router.md, 153_assumption_ban_contract.md | strict before/after side-effect execution as applicable |
| `158_secret_and_runtime_credentials.md` | 158 — Secret and Runtime Credential Handling Prompt | secret and credentials | 00_claude_base_prompt.md, 150_global_risk_gate.md, 154_execution_control.md when execution is in scope | conditional before/inside any secret-sensitive stage |
| `159_prompt_glossary_catalog_maintainer.md` | 159 — Prompt Glossary and Dependency Catalog Maintainer | AI context and knowledge base | 00_claude_base_prompt.md, current package or repository source material | optional or task-triggered |
| `15_go_specific_addon.md` | 15 — Go-Specific Addon for Claude | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `160_claude_tuning_playbook_prompt.md` | 160 — Claude Tuning Playbook Prompt | engineering workflow | 00_claude_base_prompt.md, current package or repository source material | optional or task-triggered |
| `161_cursor_advanced_rules_prompt.md` | 161 — Cursor Advanced Rules and Agent Workflow Prompt | AI context and knowledge base | 00_claude_base_prompt.md, current package or repository source material | optional or task-triggered |
| `162_oss_ready_packager.md` | 162 — OSS-Ready Package Authoring Prompt | documentation and product | 00_claude_base_prompt.md, current package or repository source material | optional or task-triggered |
| `16_testing_pyramid_and_unit_tests.md` | 16 — Testing Pyramid and Unit Test Prompt for Claude | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `17_kubernetes_runtime_operations.md` | 17 — Kubernetes Runtime, Graceful Shutdown, and Operational Readiness Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `18_cursor_integration_prompt.md` | 18 — Cursor Integration and Repository Rules Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `19_claude_code_context_install_prompt.md` | 19 — Claude Code Context Installation and Maintenance Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `20_documentation_map_and_docs_content_prompt.md` | 20 — Documentation Map and Complete Docs Content Prompt | documentation and product | 00_claude_base_prompt.md | optional or task-triggered |
| `21_security_privacy_secrets_audit.md` | 21 — Security, Privacy, and Secrets Audit Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `22_oss_readiness_and_release_packaging.md` | 22 — OSS Readiness and Release Packaging Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `23_wave_planning_and_closure_prompt.md` | 23 — Feature Closure Wave Planning Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `24_api_cli_docs_contract_audit.md` | 24 — API, CLI, Config, and Contract Audit Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `25_changelog_migration_release_notes_prompt.md` | 25 — Changelog, Migration Notes, and Release Notes Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `26_code_review_quality_gate.md` | 26 — Strict Code Review and Code Quality Gate Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `27_git_commit_branch_push_workflow.md` | 27 — Git Branch, Commit Message, Add/Commit/Push Workflow Prompt | engineering workflow | 00_claude_base_prompt.md, 154_execution_control.md, 155_tool_permission_policy.md | optional or task-triggered |
| `28_high_level_design_strict.md` | 28 — Strict High-Level Design Prompt | architecture and design | 00_claude_base_prompt.md, 01_source_analysis_to_artifact_pack.md or validated source artifacts | optional or task-triggered |
| `29_low_level_design_strict.md` | 29 — Strict Low-Level Design Prompt | architecture and design | 00_claude_base_prompt.md, 01_source_analysis_to_artifact_pack.md or validated source artifacts | optional or task-triggered |
| `30_code_quality_engineering_bar.md` | 30 — Universal Code Quality Engineering Bar Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `31_pull_request_review_and_merge_gate.md` | 31 — Pull Request Review, PR Body, and Merge Gate Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `34_claude_plugin_packager_prompt.md` | 34 — Claude Code Plugin Packager Prompt | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `40_full_chain_runner_prompts.md` | 40 — Ready-to-Copy Full Chain Prompts for Claude | engineering workflow | 00_claude_base_prompt.md | optional or task-triggered |
| `70_security_appsec_readiness.md` | 70 — Security and Application Security Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `71_supply_chain_release_integrity_readiness.md` | 71 — Supply Chain and Release Integrity Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `72_oss_governance_license_community_readiness.md` | 72 — OSS Governance, License, Community, and OpenSSF Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `73_observability_incident_sre_readiness.md` | 73 — Observability, Incident, and SRE Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `74_performance_scalability_capacity_readiness.md` | 74 — Performance, Scalability, and Capacity Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `75_documentation_dx_support_readiness.md` | 75 — Documentation, Developer Experience, and Support Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `76_compliance_privacy_audit_readiness.md` | 76 — Compliance, Privacy, and Audit Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `77_api_contract_compatibility_readiness.md` | 77 — API, CLI, Event, and Contract Compatibility Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `78_data_schema_migration_quality_readiness.md` | 78 — Data, Schema, Migration, and Quality Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `79_ai_ready_repository_context_readiness.md` | 79 — AI-Ready Repository Context Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `80_product_vision_market_readiness.md` | 80 — Product Vision, Competitor, and Market Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `81_well_architected_cost_sustainability_readiness.md` | 81 — Well-Architected, Cost, and Sustainability Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `82_readiness_gate_orchestrator.md` | 82 — Readiness Gate Orchestrator Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `83_release_launch_deployment_readiness.md` | 83 — Release, Launch, and Deployment Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `84_mcp_tooling_and_agent_integration_readiness.md` | 84 — MCP, Tooling, and Agent Integration Readiness Prompt | readiness gates | 00_claude_base_prompt.md | conditional readiness gate |
| `85_readiness_gate_aggregator.md` | 85 — Readiness Gate Aggregator and Final Go/No-Go Board | readiness gates | 00_claude_base_prompt.md, relevant readiness gate outputs from 70-84 | after gate-specific reports |
| `86_release_go_no_go_board.md` | 86 — Release Go/No-Go Board | readiness gates | 00_claude_base_prompt.md, relevant readiness gate outputs from 70-84 | after gate-specific reports |
| `87_executive_readiness_summary.md` | 87 — Executive Readiness Summary | readiness gates | 00_claude_base_prompt.md, relevant readiness gate outputs from 70-84 | after gate-specific reports |
| `88_engineering_risk_register.md` | 88 — Engineering Risk Register | readiness gates | 00_claude_base_prompt.md, relevant readiness gate outputs from 70-84 | after gate-specific reports |
| `89_remediation_wave_planner.md` | 89 — Remediation Wave Planner | readiness gates | 00_claude_base_prompt.md, relevant readiness gate outputs from 70-84 | after gate-specific reports |
| `90_copy_ready_master_prompt_risk_execution.md` | 90 — Copy-Ready Master Prompt for Claude Plugin Sessions | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `90_prompt_system_audit.md` | 90 — Prompt System Audit | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `91_prompt_conflict_detector.md` | 91 — Prompt Conflict Detector | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `92_prompt_compression_without_weakening.md` | 92 — Prompt Compression Without Weakening | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `93_prompt_upgrade_from_run_failures.md` | 93 — Prompt Upgrade From Run Failures | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `94_evidence_ledger_traceability.md` | 94 — Evidence Ledger and Traceability | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `95_source_to_claim_map.md` | 95 — Source-to-Claim Map | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `96_unsupported_claim_detector.md` | 96 — Unsupported Claim Detector | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `97_prompt_test_harness.md` | 97 — Prompt Test Harness | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `98_prompt_regression_suite.md` | 98 — Prompt Regression Suite | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |
| `99_golden_output_validation.md` | 99 — Golden Output Validation | prompt system quality | 00_claude_base_prompt.md | optional or task-triggered |

## Mandatory routing summary

- `00_claude_base_prompt.md` is strict-first for every workflow.
- `150_global_risk_gate.md`, `151_intent_stage_router.md`, and `153_assumption_ban_contract.md` are recommended before every non-trivial stage.
- `158_secret_and_runtime_credentials.md` is mandatory when secrets, credentials, env vars, CI secrets, DB URLs, tokens, certificates, cloud credentials, Kubernetes secrets, or runtime config are in scope.
- `154_execution_control.md` and `155_tool_permission_policy.md` are mandatory before file mutation, commands, Git, deployment, packaging, external-system writes, or other side effects.
- `156_human_approval_protocol.md` is mandatory when risk classification requires explicit approval.
- `157_validation_and_reporting_gate.md` is mandatory before claiming validation, build, test, package, deploy, push, or readiness status.
