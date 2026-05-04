# Decision Tree

```text
Start
 |
 |-- Is the request trivial and no stage/tool/external fact is needed?
 | |-- yes -> Answer directly
 | |-- no -> Run Global Risk Gate
 |
 |-- Is source material required and missing?
 | |-- yes -> ASK_MINIMUM_INPUT or STOP_BLOCKED
 | |-- no -> Continue
 |
 |-- Is information externally knowable and current/niche/risky?
 | |-- yes -> RESEARCH_FIRST
 | |-- no -> Continue
 |
 |-- Is the task broad/multi-stage/unbounded?
 | |-- yes -> PLAN_ONLY
 | |-- no -> Continue
 |
 |-- Does the task require execution/tool action?
 | |-- no -> Run selected stage without mutation
 | |-- yes -> Run Execution Control
 |
 |-- Execution risk >= 80 or hard stop?
 | |-- yes -> STOP_BLOCKED or SAFE_REDIRECT
 | |-- no -> Continue
 |
 |-- Execution risk >= 60 or approval-required class?
 | |-- yes -> REQUIRE_APPROVAL
 | |-- no -> Continue
 |
 |-- Process risk >= 40?
 | |-- yes -> RESEARCH_FIRST or ASK_MINIMUM_INPUT or PLAN_ONLY
 | |-- no -> EXECUTE_NOW
 |
 |-- Execute smallest safe action
 |
 |-- Validate truthfully
 |
 |-- Report exact result
```
