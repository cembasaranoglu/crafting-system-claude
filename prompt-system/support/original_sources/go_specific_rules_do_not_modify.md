## Go-specific prompt rules

* Detect Go version from `go.mod`, `go env`, toolchain files, CI, or repository docs before applying Go-specific behavior.
* Prefer one `go.mod` at repository root for single-module repositories.
* Do not create `go.work` unless a real multi-module workspace is explicitly justified.
* Use `cmd/<binary-name>/` for executable entrypoints.
* Keep `main` packages thin.
* Put non-public implementation under `internal/`.
* Use `pkg/` only when a stable public import surface is intentionally required.
* Do not blindly apply community “standard Go layout”; derive layout from runtime surfaces and ownership.
* Keep package names short, lowercase, and responsibility-focused.
* Avoid package names like `utils`, `helpers`, `common`, `base`, or `shared` unless purpose and ownership are explicit.
* Prefer small packages with clear dependency direction.
* Avoid import cycles by design, not by hacks.
* Keep exported identifiers minimal.
* Export only what external packages actually need.
* Document exported packages, types, funcs, constants, vars, and interfaces.
* Prefer concrete types by default.
* Define interfaces at consumer boundaries, not producer boundaries, unless a public contract requires otherwise.
* Keep interfaces small.
* Do not introduce interfaces only for “mockability” if a concrete dependency can be tested cleanly.
* Use constructor functions for dependencies and invariants.
* Avoid mutable package-level state.
* Avoid `init()` for behaviorful wiring.
* Pass `context.Context` as the first parameter for request-scoped, I/O, network, storage, subprocess, and long-running operations.
* Do not store `context.Context` in structs except for narrowly justified lifecycle types.
* Respect cancellation and deadlines.
* Wrap errors with `%w` when callers may inspect them.
* Use `errors.Is` / `errors.As` compatible error contracts.
* Avoid panics for expected failures.
* Avoid `log.Fatal` outside `main`.
* Return errors from libraries instead of exiting the process.
* Keep CLI/process exit handling in `cmd/` or `main`.
* Use `defer` for cleanup where ownership is clear.
* Always close response bodies, files, rows, statements, and cancellable resources.
* Bound goroutines, worker pools, channel buffers, retries, scans, and memory growth.
* Define goroutine ownership and shutdown.
* Prefer `errgroup`-style coordination only when dependency is justified.
* Avoid goroutine leaks on early return.
* Use `sync`, channels, and mutexes with explicit ownership rules.
* Avoid sharing memory by accident through maps, slices, pointers, and closures.
* Make map iteration output deterministic when output matters.
* Use table-driven tests for behavior matrices.
* Use `t.Run` subtests when cases need clear names or isolation.
* Use `t.Helper()` in test helpers.
* Use `t.Cleanup()` for test resource cleanup.
* Use `testing/fstest`, `httptest`, `iotest`, fake clocks, and temp dirs where relevant.
* Use fuzz tests for parsers, decoders, validators, normalizers, and protocol boundaries.
* Use golden tests when CLI output, generated files, reports, or serialized artifacts are contracts.
* Run `go test ./...` when build/test validation is in scope.
* Run `go test -race ./...` when concurrency is touched and feasible.
* Run `go vet ./...` when validation is in scope.
* Use `gofmt` for all Go files.
* Use `goimports` when import organization is available in the repo/tooling.
* Keep `go.mod` and `go.sum` reproducible.
* Do not edit `go.sum` manually.
* Use `go mod tidy` only when dependency graph changes or validation requires it.
* Prefer standard library before third-party libraries.
* Justify every non-stdlib dependency.
* Avoid large frameworks unless the project already uses them or the requirement clearly justifies them.
* For HTTP servers, set explicit timeouts.
* For HTTP clients, set explicit timeouts or context deadlines.
* Do not use `http.DefaultClient` for production integrations without explicit reason.
* Do not use `http.ListenAndServe` directly in production server code without configured server timeouts.
* Validate and bound request bodies.
* Use structured error responses where HTTP API contracts exist.
* Keep HTTP handlers thin; delegate domain behavior to internal packages.
* For CLIs, keep command parsing separate from business logic.
* For Cobra CLIs, keep `RunE` returning errors instead of panicking or exiting deep inside logic.
* For workers, define polling, batching, retry, backoff, idempotency, shutdown, and poison-message behavior explicitly.
* For database code, pass context to queries.
* Check `rows.Err()`.
* Close `rows`.
* Keep transactions explicit.
* Avoid hidden global DB handles.
* Avoid N+1 queries and unbounded result loading.
* For JSON/YAML, define unknown-field behavior explicitly where config/API contracts matter.
* Use `json.Decoder.DisallowUnknownFields` for strict config/API decoding when appropriate.
* Keep config structs explicit and validated.
* Avoid silently accepting zero values when zero is invalid.
* Use typed durations, URLs, paths, and sizes where it improves correctness.
* Use `time.Time` and `time.Duration` deliberately.
* Avoid time-zone ambiguity.
* Inject clock behavior for time-sensitive tests when needed.
* Avoid reflection-heavy or generic-heavy designs unless they materially simplify a real contract.
* Use generics only when they reduce duplication without hiding important domain behavior.
* Avoid overusing `interface{}` / `any`.
* Prefer explicit structs over untyped maps for stable data contracts.
* Keep package APIs small enough to review.
* Keep generated Go code clearly marked and reproducible.
* Prefer `go generate` for Go code generation when generation is required.
* Do not hand-edit generated `.go` files.
* Keep `//go:generate` commands stable and documented when used.
* Do not commit build outputs unless the repository contract requires them.
* Keep binaries out of source paths.
* Use `embed` only for intentional static assets, with clear ownership and size awareness.
* Avoid broad `recover` usage; use it only at trusted process boundaries if justified.
* Avoid swallowing errors from deferred cleanup when cleanup failure matters.
* Avoid naked returns except in very small functions where clarity is not harmed.
* Avoid clever named return usage.
* Keep lint suppressions rare, local, and justified.
* Keep public API compatibility visible for exported Go packages.
* Add migration notes when exported Go APIs change.
* Keep examples under `Example...` tests when they should compile and appear in docs.
* Use benchmarks for performance-sensitive Go code.
* Avoid allocation-heavy hot paths when performance is a stated requirement.
* Validate with exact commands and disclose not-run commands separately.
