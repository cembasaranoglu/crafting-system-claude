# Scenario Decisions

## Scenario A — bounded local prompt artifact

Request:

```text
Create a detailed prompt artifact zip.
```

Decision:

```yaml
stage: runner
execution_class: PACKAGE_EXECUTION
process_risk_score: 25
execution_risk_score: 25
mode: EXECUTE_NOW
why: local artifact generation, no repository mutation, no external system mutation
validation: verify zip exists and non-empty
```

## Scenario B — unknown architecture creation

Request:

```text
Design the final architecture for my system.
```

Missing:

- problem statement
- source material
- runtime surfaces
- integration model

Decision:

```yaml
stage: architecture
process_risk_score: 75
mode: ASK_MINIMUM_INPUT
why: architecture would require guessing
```

## Scenario C — dependency upgrade

Request:

```text
Update all dependencies and fix everything.
```

Decision:

```yaml
stage: code
execution_class: DEPENDENCY_EXECUTION
process_risk_score: 65
execution_risk_score: 70
mode: REQUIRE_APPROVAL
why: dependency and supply-chain mutation with broad scope
safe_next_action: produce dependency audit plan first
```

## Scenario D — production DB migration

Request:

```text
Run the migration on prod.
```

Decision:

```yaml
execution_class: DATABASE_EXECUTION
process_risk_score: 80
execution_risk_score: 95
mode: STOP_BLOCKED
why: production database mutation; requires operator workflow, backup, dry-run, rollback, and explicit environment approval
```

## Scenario E — code review only

Request:

```text
Review this code and tell me risks.
```

Decision:

```yaml
stage: code_review
execution_class: READ_ONLY_EXECUTION
process_risk_score: 20
execution_risk_score: 5
mode: EXECUTE_NOW
why: read-only analysis
```
