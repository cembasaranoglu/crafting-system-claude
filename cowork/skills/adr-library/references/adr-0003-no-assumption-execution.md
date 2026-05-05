# ADR-0003 — No Execution from Assumptions

## Status

Accepted

## Context

The user requested a stricter policy: the system must not assume when executing. Existing prompt rules distinguish facts, assumptions, recommendations, unknowns, blockers, and validation states, but do not explicitly forbid assumption-driven execution across every stage.

## Decision

Add `prompts/04_assumption_ban_contract.md`.

Assumptions may be used only for:

- planning hypotheses
- risk notes
- research hypotheses
- user questions
- not-executed recommendations

Assumptions must not be used for:

- file mutation
- command execution
- git mutation
- dependency mutation
- database action
- deployment
- public contract creation
- validation claims

## Consequences

Positive:

- Strongly reduces hallucinated implementation and repository layout.
- Forces minimum-input requests when project-specific information is missing.
- Keeps validation claims honest.

Negative:

- Some requests will stop earlier.
- Users may need to provide explicit source material or target paths for high-impact tasks.
