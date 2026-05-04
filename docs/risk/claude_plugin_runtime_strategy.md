# Claude Plugin Runtime Strategy

## Problem

Prompt systems often fail when a user says “just do it”, “write code”, “fix everything”, “commit and push”, “deploy”, or “make it production ready”. The model may treat the outcome as permission to perform risky intermediate actions.

The runtime strategy must split the problem into separate concerns:

- What does the user want?
- Which stage is appropriate?
- What evidence is available?
- What is unknown?
- Is research required?
- Is execution required?
- What is the execution class?
- What risk does execution carry?
- Does a tool call need approval?
- What validation can truthfully be claimed?

## Strategy

Use a layered architecture:

```text
Prompt Policy Layer
 Defines stage rules, assumption ban, risk scoring, approval protocol, and reporting discipline.

Runtime Policy Layer
 Enforces allowed/denied execution classes, approval requirements, path policies, protected files, and command classification.

Tool Adapter Layer
 Wraps file, shell, git, package, DB, deployment, and external tools with preflight checks.

Audit Layer
 Records decisions, approvals, actions, validations, and failures.
```

## Why prompt-only is insufficient

Prompt instructions are necessary but not enough. Tool enforcement is required because:

- shell commands can bypass file-tool path restrictions
- scripts can perform hidden network or file mutations
- package managers can run lifecycle scripts
- generated commands may include destructive flags
- model intent classification can be wrong
- approval must be scoped and auditable

## Recommended plugin-side guards

- Allowlist target root.
- Deny parent traversal.
- Deny secret file patterns.
- Deny or approve generated-file edits.
- Parse shell command before execution.
- Deny remote script execution by default.
- Require approval for git mutation.
- Require approval for dependency mutation.
- Require approval for DB/deployment/cloud mutation.
- Deny secret reads by default.
- Run validation in a controlled working directory.
- Persist execution reports.

## Execution classes and actions

Each tool should declare its execution class and required preconditions. The plugin should reject a tool call if the prompt did not produce a compatible execution gate decision.

Example:

```yaml
tool_call:
 tool: run_command
 command: "go test ./..."
 expected_execution_class: LOCAL_COMMAND_EXECUTION
required_gate:
 decision: EXECUTE_NOW
 execution_risk_score_less_than: 40
 command_classifier_result: allowed
```

## Approval UX

A good approval prompt should not ask “continue?” It should ask for approval of one exact action.

Bad:

```text
Should I continue?
```

Good:

```text
I need approval to run `git push origin feature/risk-gate`.
This mutates the remote repository. Rollback requires a revert commit or remote branch reset.
Approve by replying: Approve this execution.
```

## Long-running execution

For long-running tasks, persist state:

- current stage
- risk scores
- approvals
- pending tool calls
- command logs
- validation results
- failure state

Do not resume with stale approval if the action changed.
