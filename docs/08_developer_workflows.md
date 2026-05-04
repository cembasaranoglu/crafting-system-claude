# Developer Workflows

## Source analysis workflow

```text
Load 00 + 150 + 151 + 153 + 01.
Output source intake, evidence classification, problem understanding, gaps, contradictions, runtime surfaces, and next prompt pack.
```

## Design workflow

```text
Load 00 + 07 or 28.
For implementation-ready details, load 29.
For durable decisions, load 148 and 149.
```

## Review workflow

```text
Load 00 + 26 + 30 + one or more review persona prompts.
Require source-cited findings, severity, evidence, suggested fix, and validation truth.
```

## Refactor workflow

```text
Load 00 + 10 for planning.
Load 11 only when bounded execution is explicitly requested.
Use 144-147 for diff-only and patch risk control.
```

## Git workflow

```text
Load 00 + 27 + 128 + 129 + 130 + 154 + 155.
Run status, diff, staged diff, commit message generation, and push approval gates.
```

## Readiness workflow

```text
Run relevant gates from 70-84.
Then run 85 aggregator.
Use 86 go/no-go board and 89 remediation wave planner for execution planning.
```
