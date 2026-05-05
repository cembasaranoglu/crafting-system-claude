# 30 — Universal Code Quality Engineering Bar Prompt

Shared prerequisite: load and obey `prompts/00_claude_base_prompt.md`.

<mode>
CODE_QUALITY_BAR / ENGINEERING_STANDARD / IMPLEMENTATION_RULESET / REVIEW_BASELINE
</mode>

## Purpose

Use this prompt to establish or audit the repository's engineering quality bar before code authoring, refactoring, review, or release. This is not a feature implementation prompt. It defines the quality constraints that code must satisfy.

## Universal engineering principles

Code must be:

- correct under stated and edge-case inputs
- simple enough to maintain
- explicit about contracts and failure modes
- secure by default
- observable enough to operate
- testable without hidden external systems
- deterministic where output is a contract
- bounded in memory, CPU, network, file, retry, and concurrency behavior
- compatible with public APIs and user workflows unless explicitly breaking
- documented where the user/operator/developer surface changes

## Mandatory quality domains

For each domain, classify `required`, `not_applicable`, or `unknown`, then define project-specific rules.

### Correctness

- Validate boundary inputs.
- Reject invalid state early with actionable errors.
- Avoid silent fallbacks that hide unsupported behavior.
- Define null/empty/zero behavior.
- Define ordering and determinism when outputs are compared, cached, signed, tested, or consumed downstream.

### Simplicity and maintainability

- Prefer concrete, readable implementation over speculative abstraction.
- Do not create generic helpers without ownership.
- Keep modules cohesive and dependency direction explicit.
- Keep public surfaces small.
- Avoid behaviorful globals and magical initialization.
- Delete dead code only when scope permits and behavior is proven unused.

### Error handling

- Preserve original error causes.
- Separate user/config errors from internal bugs and dependency failures.
- Do not panic/crash for expected failures.
- Do not swallow cleanup or deferred errors when they affect correctness.
- Make retryability explicit.

### Security

- Define trust boundaries.
- Validate and bound all untrusted inputs.
- Avoid injection/path traversal/SSRF/deserialization hazards.
- Keep secrets out of source, logs, errors, docs, fixtures, and artifacts.
- Keep authorization checks close to protected actions.
- Redact sensitive values.

### Privacy

- Minimize sensitive data collection and persistence.
- Define retention/deletion/export implications.
- Avoid logging PII unless explicitly required and protected.
- Classify data and artifacts by sensitivity.

### Concurrency and resource safety

- Bound goroutines/threads/tasks/queues/retries/file reads/network fan-out.
- Propagate cancellation and deadlines.
- Ensure cleanup on success and failure.
- Avoid races, leaks, unbounded buffering, and deadlocks.

### Data and persistence

- Define transaction boundaries and rollback behavior.
- Avoid unbounded scans and N+1 patterns.
- Make migrations reversible or document irreversibility.
- Preserve compatibility across versions where required.
- Define idempotency and duplicate handling.

### API/contract compatibility

- Version public contracts.
- Maintain backward compatibility unless a breaking change is explicit.
- Document deprecations and migrations.
- Keep error shapes and status/exit codes stable when public.

### Observability

- Add logs/metrics/traces/audit events at decision boundaries, not noisy internals.
- Include correlation IDs where relevant.
- Avoid leaking secrets in telemetry.
- Define health/readiness behavior for services.

### Tests

- Unit tests for core behavior.
- Contract tests for public surfaces.
- Integration tests only for real boundaries.
- Smoke tests for runtime startup or release artifact sanity.
- Regression tests for bugs.
- Golden tests only for stable output contracts.
- Fuzz/property tests for parsers/validators/serializers where useful.

### Documentation parity

Update docs/examples/config/schema/API/CLI help when user-facing behavior changes.

## Required output files

1. `code_quality_readiness.md`
2. `repository_quality_bar.md`
3. `language_specific_quality_rules.md`
4. `quality_gate_matrix.yaml`
5. `review_checklist.md`
6. `validation_command_catalog.md`
7. `run_summary.md`

