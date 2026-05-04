## Code prompt rules

* Detect the actual language, framework, runtime, package manager, build system, formatter, linter, type checker, test runner, generated-code system, and deployment target before applying implementation rules.
* Do not assume any ecosystem-specific rule unless source material, repository state, or explicit user instruction proves it.
* Follow the idioms of the detected language and framework.
* Preserve existing project conventions unless they are unsafe, broken, or conflict with explicit requirements.
* Inspect current code, tests, configs, schemas, docs, examples, CI, scripts, and build metadata before editing.
* Keep changes scoped to the active deliverable or wave.
* Do not silently implement unrelated features, broad refactors, speculative abstractions, or cleanup.
* Prefer correctness, clarity, maintainability, testability, operability, and security over cleverness.
* Prefer simple concrete implementation over framework-heavy or abstract design.
* Prefer standard library and existing dependencies first.
* Add dependencies only with clear justification, maintenance confidence, license compatibility, and security awareness.
* Keep dependency versions reproducible.
* Preserve lockfiles unless dependency changes require lockfile updates.
* Treat generated files as generated; update the source generator input instead of hand-editing when applicable.
* Define explicit contracts for inputs, outputs, errors, side effects, ordering, compatibility, timeouts, retries, cancellation, and persistence.
* Validate all boundary inputs: user input, API payloads, CLI flags, config, env vars, files, database rows, queue messages, external service responses, and generated artifacts.
* Never hide invalid input or failed integrations behind silent fallbacks.
* Return actionable errors for expected failures.
* Never panic or crash for expected user, runtime, config, parsing, network, storage, authorization, or integration failures.
* Preserve original error causes while adding useful context.
* Keep secrets and sensitive values out of source, tests, fixtures, generated artifacts, logs, errors, telemetry, reports, and bundles.
* Use explicit authentication, authorization, validation, and trust-boundary checks.
* Keep authorization checks close to protected operations.
* Make time handling explicit: timezone, clock source, monotonic time, test clock, serialization format, and timeout behavior.
* Make numeric handling explicit: precision, rounding, overflow, currency, units, and decimal behavior.
* Make file handling safe: path traversal protection, size limits, permissions, atomic writes, cleanup, encoding, and temporary file lifecycle.
* Make serialization contracts explicit: schema version, nullability, defaults, unknown fields, ordering, compatibility, and migration.
* Keep concurrency bounded, cancellable, race-safe, observable, and leak-resistant.
* Avoid unbounded goroutines, threads, workers, queues, retries, scans, memory growth, file reads, batch sizes, or network fan-out.
* Define lifecycle and shutdown for background work.
* Prefer explicit dependency wiring over hidden globals, ambient state, service locators, or magic initialization.
* Keep global mutable state out of core logic.
* Keep transport, framework, SDK, database, file system, and infrastructure concerns at edges.
* Keep domain logic testable without real network, real credentials, real cloud resources, or local machine assumptions.
* Keep outputs deterministic where contracts, tests, reports, serialization, or generated files depend on ordering.
* Preserve backward compatibility unless a breaking change is explicitly requested.
* When breaking changes are required, include migration notes, compatibility impact, and versioning implications.
* Update tests for changed behavior.
* Add negative-path, edge-case, and regression tests, not only happy-path tests.
* Add contract tests for public APIs, CLIs, SDKs, events, schemas, plugins, generated artifacts, or file formats.
* Add golden/snapshot tests when output contracts matter.
* Add fuzz/property tests for parsers, decoders, validators, normalizers, serializers, and boundary-heavy logic when relevant.
* Add integration/e2e tests only where lower-level tests cannot prove the contract.
* Avoid hidden network calls in unit tests.
* Avoid flaky sleeps; use fake clocks, synchronization, polling with deadlines, or deterministic hooks.
* Clean up temporary files, sockets, processes, containers, databases, fixtures, and test resources.
* Keep tests readable, deterministic, isolated, and named by behavior.
* Keep performance-sensitive code benchmarkable.
* Avoid N+1 queries, unsafe transactions, unbounded queries, and full scans without explicit reason.
* Define transaction boundaries, isolation expectations, and rollback behavior.
* Update docs, examples, sample configs, config schemas, API specs, CLI help, runbooks, migration notes, and release notes when user-facing surfaces change.
* Do not disable lint, type, security, or test failures without explicit justification.
* Do not weaken security checks to make tests pass.
* Do not introduce behavior that depends on local machine state, global writable paths, hidden credentials, internet access, daemons, or cloud access unless explicitly required.
* Do not present pseudocode, TODO-only code, placeholders, fake implementations, or mock-only critical paths as complete.
* Before finalizing, run the narrowest truthful validation first, then widen only when required.
* Tie every validation claim to exact commands, paths, outputs, and results.
* State what changed, what did not change, what was tested, what was not tested, what is assumed, what is blocked, and what is deferred.

## Architecture prompt rules

* Establish current state before target state.
* Separate facts, assumptions, recommendations, unknowns, blockers, and validation status.
* Define objective, user/business problem, primary users, operators, desired outcome, success criteria, and non-goals before structure.
* Detect project type: library, CLI, service, API, UI app, mobile app, desktop app, worker, scheduler, batch job, data pipeline, SDK, plugin system, infrastructure module, platform component, embedded system, or mixed system.
* Define architecture at the correct scale: package, component, application, service, system, platform, or organization boundary.
* Define functional requirements separately from non-functional requirements.
* Define quality attributes explicitly: reliability, security, maintainability, scalability, performance, usability, accessibility, portability, observability, operability, compliance, and cost.
* Define constraints from existing systems, team topology, budget, latency, compliance, data residency, runtime environment, deployment model, tooling, and organizational standards.
* Do not invent runtime surfaces, integrations, storage, queues, APIs, auth systems, cloud services, or deployment targets.
* Define each runtime surface explicitly: CLI, HTTP API, RPC API, worker, scheduler, batch, webhook, event consumer, admin surface, debug surface, library, UI, plugin, or SDK.
* For each runtime surface, define responsibility, input contract, output contract, error contract, lifecycle, config, security, observability, and ownership.
* Define what each runtime surface must not own.
* Define bounded contexts and feature boundaries using domain language.
* Define modules, packages, components, services, deployable units, and ownership boundaries.
* Define dependency direction and forbidden dependencies.
* Define public contracts separately from internal implementation.
* Default to internal/private implementation unless a stable public contract is explicitly required.
* Define API, CLI, config, event, schema, artifact, storage, and plugin contracts when relevant.
* Define compatibility policy, versioning policy, deprecation policy, and migration policy for public surfaces.
* Define data ownership, schema ownership, migration ownership, retention, backup/restore, privacy, and classification when data exists.
* Define consistency model: strong, eventual, read-your-writes, transactional, append-only, idempotent, or best-effort.
* Define trust boundaries, tenant boundaries, privilege boundaries, and threat model posture.
* Define authentication, authorization, audit, redaction, and least-privilege posture.
* Define external integration boundaries, failure modes, timeout policy, retry policy, rate limits, circuit breakers, idempotency, partial failure, and rollback behavior.
* Define sync vs async communication boundaries.
* For event systems, define event ownership, schema evolution, ordering, deduplication, replay, dead-letter handling, poison-message handling, and consumer idempotency.
* Define background job semantics: uniqueness, scheduling, timeout, cancellation, retry, visibility, idempotency, and recovery.
* Define observability acceptance criteria: logs, metrics, traces, health checks, readiness checks, diagnostics, correlation IDs, alert signals, and redaction.
* Define SLO/SLA/error-budget posture where reliability matters.
* Define capacity assumptions, scaling model, resource limits, and cost constraints where relevant.
* Define deployment topology: single process, multi-process, container, serverless, edge, desktop, mobile, on-prem, cloud, hybrid, or embedded.
* Define environment model and environment parity expectations.
* Define rollout, rollback, feature-flag, migration, disaster recovery, and support expectations where relevant.
* Define build-vs-buy decisions and rejected alternatives.
* Define ADR-worthy decisions.
* Define frontend-specific architecture when UI exists: routing, state management, design system, accessibility, browser/device support, client-side error handling, asset strategy, and performance budgets.
* Define library/SDK-specific architecture when applicable: public API boundaries, semantic versioning, examples, compatibility tests, extension points, and documentation.
* Define data-pipeline architecture when applicable: raw/intermediate/curated zones, schema contracts, reproducibility, lineage, idempotency, checkpoints, backfills, and artifact retention.
* Define infrastructure architecture when applicable: environments, state handling, secret handling, drift detection, plan/apply workflow, module boundaries, and rollback.
* Define test strategy by boundary: unit, integration, contract, smoke, e2e, golden, fuzz/property, benchmark, load, security, accessibility, migration, and deployment validation.
* Define release-readiness and operational-readiness gates.
* Decompose work into deliverables, not vague phases.
* A deliverable must be the smallest meaningful functionality slice that can be coded, tested, built, and deployment-prepared or deployment-validated.
* Split oversized deliverables before execution.
* Each wave must define objective, scope, non-scope, prerequisites, touched paths, runtime surfaces touched, validation scope, build scope, deployability scope, risks, assumptions, exit criteria, and immediate next step.
* Preserve mode isolation: architecture planning is not implementation, implementation is not release review, and validation claims require evidence.
* Do not call the architecture production-ready unless implementation, validation, packaging, deployment, documentation, and operations evidence exists or is explicitly not applicable.

## Repository prompt rules

* Detect repository strategy first: single repo, monorepo, multi-repo, package repo, infrastructure repo, documentation repo, data repo, app repo, service repo, or mixed repo.
* Detect project ecosystems before choosing layout.
* Do not force one repository layout across all languages or project types.
* Preserve existing repository conventions unless they are unsafe, contradictory, or unsupported.
* Treat the target repository root as the final shipped repository from the start.
* Do not create assistant-only wrapper directories such as `source_code/`, `artifacts/`, `output/`, `workspace/`, `generated_repo/`, or `final/` inside the shipped repository unless explicitly required.
* Keep assistant run outputs, command logs, reports, manifests, scratch files, temporary files, and bundles outside the shipped repository by default.
* Create the final repository layout directly at the target root.
* Use temporary staging only outside the target repo and copy verified changes back before claiming success.
* Keep repository root focused on whole-repo control-plane concerns.
* Root-level files must be justified: README, license, changelog, security policy, contribution guide, code of conduct, code owners, gitignore, editorconfig, package/workspace metadata, CI metadata, release metadata, build orchestration, and top-level documentation.
* Do not place business logic, runtime internals, generated dumps, command logs, local configs, secrets, or temporary outputs at repository root.
* Distinguish required paths from optional paths.
* Every material path must have purpose, owner, source basis, lifecycle, and validation relevance.
* Every material path must map to at least one deliverable, runtime surface, deployable unit, package, validation scope, packaging concern, documentation concern, operations concern, or governance concern.
* Do not create orphan paths.
* Do not create placeholder-only directories.
* Do not create vague dumping-ground directories.
* Separate application source, library source, tests, fixtures, testdata, docs, examples, schemas, configs, migrations, scripts, generated code, deployment assets, observability assets, release assets, and assistant execution artifacts.
* Keep testdata and fixtures at the narrowest justified scope.
* Keep docs and examples separate from runtime code unless co-location is explicitly justified.
* Use ecosystem-native root files at the correct package or workspace boundary.
* Keep package-manager files at the correct package boundary.
* Keep lockfiles committed or ignored according to ecosystem and project policy.
* Do not ignore files required for reproducible builds.
* Add `.gitignore` for build outputs, caches, local env files, secrets, logs, temporary files, and tool artifacts.
* Add `.gitattributes` when line endings, generated files, linguist classification, or binary handling matter.
* Add `.editorconfig` when cross-editor consistency matters.
* Keep generated artifacts policy explicit: generator source, generated paths, committed vs uncommitted, regeneration command, and validation.
* Keep vendored dependency policy explicit.
* Keep binary and large-file policy explicit.
* Keep secrets and private environment values out of repository-controlled files.
* Provide safe sample configs only.
* Include README with project status, purpose, install/build/test/run usage, configuration, examples, support boundaries, and contribution basics.
* Include LICENSE when distribution or OSS use is expected.
* Include SECURITY.md when vulnerability reporting matters.
* Include CONTRIBUTING.md when multi-person or external contribution is expected.
* Include CODEOWNERS when ownership and review routing matter.
* Include issue/PR templates when collaboration workflow matters.
* Include CHANGELOG or release notes policy when releases matter.
* Include docs index when docs exceed one page.
* Include ADRs when architecture decisions need history.
* Include CI workflows only when commands are known or can be truthfully defined.
* Include release workflows only when packaging and versioning are known.
* Include examples only when they are accurate, maintained, and runnable or clearly marked.
* Include sample configs that match real config schema.
* Include migrations only when persistence schema changes exist.
* Include deployment/infrastructure files only when deployment target is validated.
* In monorepos, define apps/packages/services ownership, workspace tooling, dependency boundaries, build graph, shared package policy, and affected-test strategy.
* In libraries, define public API surface, compatibility policy, package metadata, examples, docs, and release packaging.
* In services, define runtime entrypoint, config, health/readiness, deployment, observability, runbooks, and operational docs.
* In CLIs, define command structure, help output, config behavior, shell completion, examples, and binary release path.
* In UI apps, define app root, routing, components, state, assets, accessibility tests, build output, and deployment target.
* In data projects, define pipeline stages, schemas, notebooks policy, reproducibility, raw/intermediate/output data policy, and artifact storage.
* In infrastructure repos, define environments, modules, state handling, secret handling, plan/apply workflow, and drift detection.
* Verify repository tree against required runtime surfaces and deliverables.
* Verify no required path is missing.
* Verify no created path is unjustified.
* Verify no path violates final-root policy.
* Verify no secrets, private values, build outputs, caches, or assistant artifacts were introduced.
* State what was created versus planned.
* State what remains missing before coding, validation, packaging, or release can start.
