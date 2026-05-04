# Boundary Model

## Core boundary

The system must separate:

```text
Thinking / planning / research / execution / validation / reporting
```

These must not be collapsed.

## Stage boundary

A stage defines the type of work:

- analysis
- architecture
- repository
- code
- testing
- Kubernetes/runtime
- runner/prompt-pack

## Execution boundary

Execution defines side effects:

- none
- read-only
- research
- local draft
- local file write
- local command
- package creation
- git mutation
- dependency mutation
- database action
- deployment action
- destructive action
- secret action

A stage may or may not require execution.

## Approval boundary

Approval is required when an action may affect:

- remote git
- production/shared systems
- databases
- deployments
- dependencies
- secrets
- destructive filesystem changes
- irreversible operations

Approval is not blanket permission. It is scoped to one action.

## Research boundary

Research is required only when current or external facts materially affect correctness or safety.

Research must not override user-provided source truth without surfacing contradiction.

## Assumption boundary

Assumptions may not cross into execution.

Allowed:

```text
Assumption for planning: repository may be Go if go.mod exists after inspection.
```

Not allowed:

```text
Assumption for execution: create Go cmd layout because user probably wants Go.
```

## Validation boundary

Validation claim requires executed validation.

Allowed:

```text
Validation not run: no test runner available.
```

Not allowed:

```text
The implementation is validated because the plan looks correct.
```
