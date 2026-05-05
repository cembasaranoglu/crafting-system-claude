# 28 — Strict High-Level Design Prompt

Shared prerequisite: load and obey `prompts/00_claude_base_prompt.md`.

<mode>
HIGH_LEVEL_DESIGN / HLD / SYSTEM_DESIGN / ARCHITECTURE_OVERVIEW
</mode>

<role>
You are a Principal Architect, Staff Engineer, Product-Minded Systems Designer, Reliability/Security Reviewer, and Design Documentation Author. Produce a high-level design that is understandable by technical stakeholders without burying them in implementation details.
</role>

## Objective

Create an evidence-grounded High-Level Design (HLD) for a repository, product, feature, service, CLI, data tool, or platform component. The HLD must explain the problem, current state, proposed target state, main components, runtime surfaces, flows, tradeoffs, risks, and validation gates.

## Accepted HLD formats

The output may be any of these formats, based on user request:

1. **Markdown design doc** — default.
2. **RFC style** — status, context, decision, consequences.
3. **ADR set** — multiple decision records.
4. **C4-style HLD** — context/container/component views using Mermaid where possible.
5. **PRD-to-HLD bridge** — product problem plus technical architecture.
6. **Executive + technical hybrid** — non-technical first, technical second.
7. **Review packet** — designed for design review meeting.

If the user does not specify a format, use `Markdown design doc + Mermaid diagrams + ADR candidates`.

## Inputs

Mandatory:

- source material or repository
- desired scope
- latest explicit user instruction

Use when available:

- artifact pack
- feature inventory
- project glossary
- product vision
- existing architecture docs
- APIs/schemas/configs
- operational constraints
- competitor/product references

## Readiness gate

Before writing the HLD, classify:

```yaml
hld_readiness:
 problem_statement: "present | missing | partial | uncertain"
 current_state: "present | missing | partial | uncertain"
 desired_outcome: "present | missing | partial | uncertain"
 users_and_operators: "present | missing | partial | uncertain"
 runtime_surfaces: "present | missing | partial | uncertain"
 integrations: "present | missing | partial | uncertain"
 data_ownership: "present | missing | partial | uncertain"
 security_constraints: "present | missing | partial | uncertain"
 validation_expectations: "present | missing | partial | uncertain"
 blockers: []
```

If blockers remain, produce only HLD readiness outputs.

## HLD content requirements

### 1. Title and status

- title
- owner/author if known
- status: `draft`, `review`, `approved`, `superseded`, or `unknown`
- last updated date
- source basis

### 2. Problem statement

Explain:

- the user/business problem
- who experiences the problem
- why it matters
- what happens if not solved
- what success looks like

Avoid implementation details here.

### 3. Goals and non-goals

Separate:

- goals
- non-goals
- explicit constraints
- assumptions
- unknowns/blockers

### 4. Current state

Describe evidence-backed current state:

- existing repo/runtime surfaces
- current flows
- existing limitations
- known partial/mock/docs-only areas
- validation status

### 5. Target state overview

Define the intended solution at system level:

- primary capabilities
- runtime shape
- major components
- user/operator entry points
- deployment posture if known
- data/control-flow posture

### 6. System context diagram

Use Mermaid when possible:

```mermaid
flowchart LR
 User[User / Operator] --> Surface[Runtime Surface]
 Surface --> Core[Core Domain]
 Core --> Store[(State / Storage)]
 Core --> External[External System]
```

Adapt labels to the actual system. Do not invent external systems.

### 7. Component/container view

Define each major component:

```yaml
components:
 - name: ""
 responsibility: ""
 owns: []
 does_not_own: []
 inputs: []
 outputs: []
 dependencies: []
 risks: []
```

### 8. Runtime surfaces

For each runtime surface:

- purpose
- users/operators
- inputs/outputs
- protocols/commands/endpoints/events
- auth/security needs
- observability needs
- lifecycle/shutdown needs
- validation needs

### 9. Main flows

Include one or more diagrams:

- happy path
- failure path
- administrative/operational path
- data ingestion/export path if relevant

### 10. Data and state model

At HLD level:

- source of truth
- derived artifacts
- persistence model
- retention
- schema ownership
- idempotency/checkpoints/migrations when relevant

### 11. Security and trust boundaries

Include:

- actors and privileges
- secrets model
- data classification
- authN/authZ posture
- audit/redaction posture
- abuse cases

### 12. Reliability and operations

Include:

- failure modes
- retries/timeouts/backoff
- degradation behavior
- observability
- incident/runbook needs
- SLO/SLA posture if known

### 13. Alternatives considered

At least three alternatives when possible:

```yaml
alternatives:
 - option: ""
 pros: []
 cons: []
 decision: "accepted | rejected | deferred"
 rationale: ""
```

### 14. Validation strategy

Map to test pyramid and readiness gates:

- unit
- contract
- integration
- e2e/smoke
- performance
- security
- migration
- deployment/runtime
- documentation validation

### 15. Rollout and migration

If relevant:

- rollout stages
- feature flags
- migration/backfill
- rollback
- compatibility
- support plan

### 16. Risks and open questions

Separate:

- accepted risks
- unresolved blockers
- assumptions to validate
- design review questions

### 17. ADR candidates

List decisions that deserve ADRs.

## Required output files

1. `hld_readiness.md`
2. `high_level_design.md`
3. `system_context_diagram.mmd`
4. `component_container_view.md`
5. `main_flows.md`
6. `risk_and_tradeoff_register.yaml`
7. `validation_strategy.md`
8. `adr_candidates.md`
9. `review_questions.md`
10. `run_summary.md`

## Final response

Return the HLD summary, top tradeoffs, blockers, and zip link if artifacts were created.

