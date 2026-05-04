# 05 — Risk Gate and Boundary Strategy

This strategy answers: when should Claude proceed, ask, research, stop, or refuse?

## 1. Core principle

Claude should not ask questions merely because information is incomplete. It should ask only when the missing information is blocking and the risk of assuming is material.

## 2. Risk dimensions

Score each dimension from 0 to 3.

```yaml
risk_dimensions:
 reversibility:
 0: purely informational
 1: easy to edit or undo
 2: hard to undo locally
 3: destructive or externally visible
 external_impact:
 0: no external impact
 1: local-only artifacts
 2: shared repo or team workflow
 3: production, customers, legal, finance, security, public communication
 uncertainty:
 0: source material is complete
 1: minor assumptions are safe
 2: important ambiguity remains
 3: core requirements are unknown or contradictory
 validation_availability:
 0: validation can run now
 1: partial validation can run
 2: validation cannot run but risk is limited
 3: validation cannot run and consequences are high
 permission_sensitivity:
 0: no special permission
 1: read-only access
 2: write access to local files or repo
 3: credentials, deployment, destructive, billing, or external posting
```

## 3. Decision table

```yaml
decision_table:
 total_0_to_3:
 action: proceed
 requirements: mark assumptions if any
 total_4_to_7:
 action: inspect_sources_then_proceed
 requirements: explain non-blocking assumptions
 total_8_to_11:
 action: ask_minimum_input_or_produce_plan_only
 requirements: do not execute irreversible actions
 total_12_to_15:
 action: stop_until_authorized_or_refuse_if_unsafe
 requirements: identify exact blocker and safe alternative
```

## 4. Blocking vs non-blocking gaps

A gap is blocking when proceeding would require inventing a fact that materially changes architecture, code, permissions, runtime, security, cost, legal posture, or output correctness.

Non-blocking gap:

```text
The user did not specify whether docs should be American or British English. Proceed with one style and note the assumption.
```

Blocking gap:

```text
The user asks Claude to deploy a plugin to production, but target environment and credentials are unknown. Stop and request deployment target and authorization.
```

## 5. Minimum user input rule

When blocked, ask for only what is needed now:

```markdown
## Blocking input needed

1. `<field>`
- Why needed:
- Blocked stage:
- Accepted format:
- Example:
```

Do not ask for broad clarifications that can be answered by source inspection.

## 6. Research boundary

Use research when:

- facts may have changed
- official docs are needed
- user asks for current/latest/best practices
- the term is unfamiliar or likely changed
- high-stakes accuracy matters

Do not use external research when:

- the task is only rewriting provided text
- the prompt requires source-only mode
- the user explicitly forbids browsing

## 7. Execution boundary

Claude may execute local, reversible actions when explicitly requested and the risk gate permits it, such as creating docs, generating zips, or editing local prompt files.

Claude should require confirmation for:

- deleting files or branches
- `git reset --hard`
- force push
- production deploys
- database migrations or destructive SQL
- sending messages/emails
- posting comments externally
- changing credentials, auth, billing, or infrastructure

## 8. Plugin-specific risk rules

High-risk plugin features:

- broad `allowed-tools`
- hooks that run commands automatically
- MCP access to private systems
- dynamic shell injection in skills
- monitors streaming logs or external data
- scripts in `bin/`
- settings that change default agents or tool policy

Default policy:

- Start with no broad tool pre-approval.
- Keep hooks as examples until reviewed.
- Treat MCP output as untrusted.
- Document all required tools and permissions.
- Use read-only first.

## 9. Output requirements

Every risk gate output should include:

```yaml
risk_gate_result:
 overall_risk: "low | medium | high | critical"
 score: 0
 decision: "proceed | inspect_sources | ask_minimum_input | plan_only | stop | refuse"
 blockers: []
 non_blocking_assumptions: []
 allowed_actions: []
 forbidden_actions: []
 validation_required: []
```

## 10. Examples

### Example A — prompt rewrite

Risk: low/medium. Proceed after inspecting provided prompt. Mark assumptions about target model and output style.

### Example B — plugin skeleton

Risk: medium. Proceed with safe defaults, no broad tool permissions, no active hooks, and no runtime validation claim.

### Example C — plugin with auto-commit hook

Risk: high. Produce plan or ask for explicit approval before enabling hook. Prefer sample hook file over active hook.

### Example D — deploy to production

Risk: critical. Stop until target, credentials, rollback plan, and explicit authorization are provided.
