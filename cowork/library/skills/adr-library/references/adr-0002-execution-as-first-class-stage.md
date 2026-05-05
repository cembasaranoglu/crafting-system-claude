# ADR-0002 — Treat Execution as a First-Class Stage

## Status

Accepted

## Context

The previous staged model had analysis, architecture, repository, code, testing, Kubernetes, and runner stages. Execution was implicit inside those stages.

Implicit execution is unsafe because the same stage can have very different side effects. Repository planning is low risk; repository file creation is medium risk; overwriting an existing repository is high risk; git push is higher risk.

## Decision

Add `prompts/70_execution_control.md` and include an `execution` stage in the stage manifest.

Execution control is required before:

- tool calls
- file writes
- command execution
- package generation
- git mutation
- dependency mutation
- database action
- deployment action
- external system mutation
- secret handling

## Consequences

Positive:

- Separates what should be done from how it is executed.
- Allows stage-specific planning with global safety control.
- Enables approval gates.
- Enables tool-level policy enforcement.

Negative:

- Requires more runtime state.
- Requires the plugin to track active stage, execution class, and approvals.
