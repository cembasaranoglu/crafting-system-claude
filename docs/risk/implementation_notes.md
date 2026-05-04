# Implementation Notes

## Runtime enforcement checklist

Implement these checks in the plugin runtime, not only in prompts.

### Before a tool call

- Parse the active stage.
- Verify a global risk gate exists.
- Verify an execution gate exists if the tool has side effects.
- Verify the tool execution class matches the gate.
- Verify approval exists if required.
- Verify path scope for file tools.
- Verify command safety for shell tools.
- Verify no protected path or secret pattern is touched.

### File tools

- Require allowed root.
- Deny parent traversal.
- Deny protected files by default.
- Require diff preview for edits.
- Require approval for delete/overwrite of existing files outside bounded scope.
- Keep generated artifacts outside shipped repo unless explicitly part of repo.

### Shell tools

- Classify commands before running.
- Deny remote script execution by default.
- Require approval for dependency changes.
- Require approval for git mutations.
- Require approval for DB/deployment/cloud actions.
- Log working directory, command, exit status, and output summary.

### Package manager tools

- Treat installs/upgrades/tidy/audit-fix as dependency execution.
- Require approval.
- Preserve lockfiles unless the dependency change is approved.
- Record package manager output.

### Git tools

- Read-only git status/log/diff is allowed if scoped.
- `git add`, `commit`, `branch`, `checkout`, `merge`, `rebase`, `reset` require approval.
- Remote actions require high-risk approval.
- Force push and branch deletion require extra explicit approval.

### Deployment tools

- Render/validate manifests may be allowed when scoped.
- Apply/upgrade/delete/scale/restart requires approval.
- Production mutations should default to stop unless the operator explicitly approves with target environment.

## Recommended runtime pseudo-code

```pseudo
handle_request(request):
 gate = run_global_risk_gate(request)
 route = run_intent_stage_router(request, gate)

 if gate.action_mode == RESEARCH_FIRST:
 research = run_research_gate(request)
 gate = recompute_risk(gate, research)

 if route.execution_required:
 exec_gate = run_execution_control(request, route, gate)
 if exec_gate.decision == REQUIRE_APPROVAL:
 return approval_request(exec_gate)
 if exec_gate.decision in [STOP_BLOCKED, REFUSE_OR_SAFE_REDIRECT]:
 return stop_response(exec_gate)

 result = run_selected_stage(route)
 if result.needs_tool:
 permission = check_tool_permission(result.tool_call, exec_gate)
 if not permission.allowed:
 return denied_or_approval(permission)
 tool_result = run_tool(result.tool_call)
 validation = run_validation_gate(tool_result)
 return final_report(result, tool_result, validation)

 return final_report(result)
```
