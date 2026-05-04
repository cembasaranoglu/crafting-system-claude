# ADR and RFC Style Guide

## ADR purpose

Use ADRs for durable architecture decisions that affect structure, dependencies, operations, security, compatibility, or long-term maintenance.

Required sections:

```text
# ADR-NNNN: Title
Status
Date
Owner
Context
Decision
Consequences
Alternatives considered
Evidence
Validation
Rollback / reversal path
Related RFCs / issues / PRs
```

Use `148_adr_generator.md` and `151_decision_log_adr_index.md`.

## RFC purpose

Use RFCs for proposals that need review before implementation.

Required sections:

```text
# RFC-NNNN: Title
Status
Authors
Reviewers
Problem statement
Goals
Non-goals
Current state
Proposed design
API / CLI / config / data contract changes
Security and privacy
Operational impact
Compatibility and migration
Test and validation plan
Rollout and rollback
Open questions
Decision log
```

Use `149_rfc_generator.md` and `152_api_rfc_review_gate.md`.

## Acceptance criteria

An ADR/RFC is not accepted unless it separates facts, assumptions, tradeoffs, rejected alternatives, risks, and validation requirements.
