# Example User Messages and Correct Routing

## 1. “Write the code now”

Routing:

```yaml
primary_stage: code
execution_required: yes
first_action: inspect_repository
possible_mode: EXECUTE_NOW only if task is bounded and evidence exists
```

If task is unbounded:

```yaml
mode: PLAN_ONLY
reason: direct code request is too broad
```

## 2. “Make this production ready”

Routing:

```yaml
primary_stage: analyze_or_readiness_review
mode: PLAN_ONLY
reason: readiness is multi-surface and cannot be implemented blindly
```

## 3. “Create repo skeleton and zip it”

Routing:

```yaml
primary_stage: repository
execution_required: yes
execution_classes:
 - LOCAL_FILE_WRITE_EXECUTION
 - PACKAGE_EXECUTION
required_preflight:
 - target root or artifact output root known
 - architecture handoff present or safe skeleton scope explicit
```

## 4. “Run tests and fix failures”

Routing:

```yaml
primary_stage: testing_then_code
execution_required: yes
execution_classes:
 - LOCAL_COMMAND_EXECUTION
 - LOCAL_FILE_WRITE_EXECUTION
rules:
 - inspect test runner first
 - classify command
 - do not weaken tests to pass
```

## 5. “Commit and push”

Routing:

```yaml
execution_classes:
 - GIT_LOCAL_EXECUTION
 - GIT_REMOTE_EXECUTION
mode: REQUIRE_APPROVAL
reason: local and remote git mutation
```

## 6. “Apply these Kubernetes manifests”

Routing:

```yaml
primary_stage: kubernetes
execution_class: DEPLOYMENT_EXECUTION
mode: REQUIRE_APPROVAL or STOP_BLOCKED
reason: cluster mutation
```

## 7. “Search docs and update prompt system”

Routing:

```yaml
primary_stage: runner_or_artifact_generation
execution_classes:
 - RESEARCH_EXECUTION
 - LOCAL_FILE_WRITE_EXECUTION
 - PACKAGE_EXECUTION
mode: RESEARCH_FIRST then EXECUTE_NOW if risk acceptable
```
