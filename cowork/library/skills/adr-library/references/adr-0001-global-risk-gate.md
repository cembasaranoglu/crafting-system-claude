# ADR-0001 — Add Global Risk Gate

## Status

Accepted

## Context

The prompt system already has staged prompts for analysis, architecture, repository creation/planning, code, testing, and Kubernetes/runtime operations. However, direct user requests can still skip stage readiness and move too quickly into execution.

## Decision

Add `prompts/01_global_risk_gate.md` as a required gate for every non-trivial request.

The gate classifies:

- intent
- required evidence
- missing evidence
- contradictions
- research need
- process risk
- execution risk candidate
- final action mode

## Consequences

Positive:

- Prevents silent assumptions.
- Prevents premature stage execution.
- Makes risk visible.
- Routes broad requests to planning instead of implementation.

Negative:

- Adds upfront ceremony for complex tasks.
- Requires runtime/plugin integration to be most effective.

## Alternatives rejected

- Ask questions before every task: rejected because it slows down low-risk tasks and creates bad UX.
- Trust stage prompts only: rejected because execution risk crosses stage boundaries.
