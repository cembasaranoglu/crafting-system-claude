# 10 — Prompt Patterns Catalog

## Pattern: Source-first answer

```xml
<source_first>
Inspect available source material before making claims. If a claim is not grounded in inspected material, mark it as an assumption or unknown.
</source_first>
```

## Pattern: Minimum missing input

```xml
<blocked_run>
If a blocking gap remains, stop the main task and request only the minimum missing input. Do not ask for information already present in the attached files or source material.
</blocked_run>
```

## Pattern: Conservative action

```xml
<action_boundary>
Do not modify files, run destructive commands, send messages, push commits, deploy, or change shared systems unless the user explicitly asks and the risk gate allows it.
</action_boundary>
```

## Pattern: Default to artifact creation

```xml
<artifact_creation>
When the user requests files, docs, templates, plugins, or a zip, create the requested artifacts rather than only describing them. Verify that generated files exist before reporting success.
</artifact_creation>
```

## Pattern: Validation honesty

```xml
<validation_honesty>
Separate validated, failed, not run, blocked, assumed, and not applicable. Do not claim any command, test, build, install, plugin load, deployment, or runtime behavior succeeded unless it actually ran in this session or is evidenced by source material.
</validation_honesty>
```

## Pattern: Risk gate result

```yaml
risk_gate_result:
 risk: "low | medium | high | critical"
 decision: "proceed | inspect_sources | ask | plan_only | stop | refuse"
 blockers: []
 assumptions: []
 allowed_actions: []
 forbidden_actions: []
```

## Pattern: Prompt tuning changelog

```yaml
prompt_change:
 version: ""
 date: ""
 changed_sections: []
 reason: ""
 expected_improvement: ""
 eval_cases_run: []
 regressions: []
 rollout_decision: "keep | revert | needs_more_testing"
```

## Pattern: Plugin review finding

```yaml
finding:
 severity: "critical | high | medium | low | info"
 area: "manifest | skill | agent | hook | mcp | lsp | monitor | docs | security | packaging"
 evidence: ""
 impact: ""
 recommendation: ""
```
