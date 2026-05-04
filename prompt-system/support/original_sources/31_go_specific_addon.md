> Shared prerequisite: Before using this prompt, load and obey `prompts/00_base_prompt.md`. This stage-specific prompt adds narrower instructions and must not weaken the base contract.

# 31 — Go-Specific Addon

Use this addon only when Go is explicitly selected, strongly implied by source material, or already present in the repository. Do not apply these rules to non-Go projects.

## Detection

Before applying Go-specific behavior, inspect:

- `go.mod`
- `go.sum`
- `go.work`
- Go version/toolchain directive
- `cmd/`, `internal/`, `pkg/`
- existing package names and dependency direction
- CI/test/build scripts
- Makefile/Taskfile/justfile
- Dockerfile/release config if present

## Repository layout

- Prefer one `go.mod` at repository root for single-module repositories.
- Do not create `go.work` unless multi-module workspace is explicitly justified.
- Use `cmd/<binary-name>/` for executable entrypoints.
- Keep `main` packages thin.
- Put non-public implementation under `internal/`.
- Use `pkg/` only when stable public imports are intentionally required.
- Do not blindly apply community “standard Go layout”; derive layout from runtime surfaces, deployable units, and ownership.
- Keep package names short, lowercase, and responsibility-focused.
- Avoid `utils`, `helpers`, `common`, `base`, and `shared` unless ownership and purpose are explicit.
- Avoid import cycles by design.

## API and package design

- Keep exported identifiers minimal.
- Export only what external packages actually need.
- Document exported packages, types, functions, constants, variables, and interfaces.
- Prefer concrete types by default.
- Define interfaces at consumer boundaries unless a public provider contract is intentional.
- Keep interfaces small.
- Do not create interfaces only for mockability if a concrete dependency can be tested cleanly.
- Use constructors for dependencies and invariants.
- Avoid mutable package-level state.
- Avoid behaviorful `init()` functions.
- Avoid overusing `interface{}` / `any`.
- Prefer explicit structs over untyped maps for stable contracts.
- Use generics only when they reduce duplication without hiding important domain behavior.
- Avoid reflection-heavy designs unless materially justified.

## Context, errors, and process behavior

- Pass `context.Context` as the first parameter for request-scoped, I/O, network, storage, subprocess, worker, and long-running operations.
- Do not store `context.Context` in structs except for narrowly justified lifecycle types.
- Respect cancellation and deadlines.
- Wrap errors with `%w` when callers may inspect them.
- Use `errors.Is` and `errors.As` compatible error contracts.
- Avoid panics for expected failures.
- Avoid `log.Fatal` outside `main`.
- Return errors from libraries instead of exiting the process.
- Keep CLI/process exit handling in `cmd/` or `main`.

## Resource handling and concurrency

- Use `defer` for cleanup where ownership is clear.
- Always close response bodies, files, rows, statements, and cancellable resources.
- Check `rows.Err()`.
- Bound goroutines, worker pools, channel buffers, retries, scans, result sets, and memory growth.
- Define goroutine ownership and shutdown.
- Avoid goroutine leaks on early return.
- Use `sync`, channels, and mutexes with explicit ownership rules.
- Avoid accidental sharing through maps, slices, pointers, and closures.
- Make map iteration output deterministic when output matters.

## HTTP, CLI, workers, and database

- For HTTP servers, set explicit `ReadTimeout`, `ReadHeaderTimeout`, `WriteTimeout`, and `IdleTimeout` unless there is a justified exception.
- For HTTP clients, set explicit timeout or require context deadlines.
- Do not use `http.DefaultClient` for production integrations without explicit reason.
- Do not use `http.ListenAndServe` directly in production server code without configured server timeouts.
- Validate and bound request bodies.
- Use structured error responses when HTTP API contracts exist.
- Keep handlers thin; delegate domain behavior to internal packages.
- For CLIs, keep command parsing separate from business logic.
- For Cobra CLIs, prefer `RunE` returning errors; do not panic or exit deep inside logic.
- For workers, define polling, batching, retry, backoff, idempotency, shutdown, and poison-message behavior.
- For database code, pass context to queries.
- Keep transactions explicit.
- Avoid hidden global DB handles.
- Avoid N+1 queries and unbounded result loading.

## Data, config, serialization, and time

- For JSON/YAML, define unknown-field behavior explicitly where config/API contracts matter.
- Use `json.Decoder.DisallowUnknownFields` for strict config/API decoding when appropriate.
- Keep config structs explicit and validated.
- Avoid silently accepting zero values when zero is invalid.
- Use typed durations, URLs, paths, and sizes where it improves correctness.
- Use `time.Time` and `time.Duration` deliberately.
- Avoid timezone ambiguity.
- Inject clock behavior for time-sensitive tests when needed.

## Generation and assets

- Keep generated Go code clearly marked and reproducible.
- Prefer `go generate` when Go code generation is required.
- Do not hand-edit generated `.go` files.
- Keep `//go:generate` commands stable and documented when used.
- Do not commit build outputs unless repository contract requires them.
- Keep binaries out of source paths.
- Use `embed` only for intentional static assets with clear ownership and size awareness.

## Tests and validation

- Use table-driven tests for behavior matrices.
- Use `t.Run` subtests when cases need names or isolation.
- Use `t.Helper()` in test helpers.
- Use `t.Cleanup()` for test resource cleanup.
- Use `testing/fstest`, `httptest`, `iotest`, fake clocks, and temp dirs where relevant.
- Use fuzz tests for parsers, decoders, validators, normalizers, serializers, and protocol boundaries.
- Use golden tests when CLI output, generated files, reports, or serialized artifacts are contracts.
- Keep examples under `Example...` tests when they should compile and appear in docs.
- Use benchmarks for performance-sensitive code.
- Avoid allocation-heavy hot paths when performance is a stated requirement.
- Run `gofmt` on all touched Go files.
- Use `goimports` when project tooling includes it.
- Run `go test ./...` when test/build validation is in scope.
- Run `go vet ./...` when validation is in scope.
- Run `go test -race ./...` when concurrency is touched and feasible.
- Keep `go.mod` and `go.sum` reproducible.
- Do not edit `go.sum` manually.
- Use `go mod tidy` only when dependency graph changes or validation requires it.

## Dependency rules

- Prefer standard library before third-party dependencies.
- Justify every non-standard dependency.
- Avoid large frameworks unless the project already uses them or requirements clearly justify them.
- Keep public API compatibility visible for exported Go packages.
- Add migration notes when exported Go APIs change.

## Reporting

- Validate with exact commands and disclose not-run commands separately.
- Do not claim `go test`, `go vet`, race tests, lint, or builds passed unless actually run.
