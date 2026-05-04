# Runtime operations review

This document applies only if the repository has a service, worker, CLI job, scheduler, batch job, UI app or deployment runtime.

Review:

- runtime surfaces
- config and secrets
- health/readiness endpoints
- metrics/logging/tracing
- graceful shutdown
- retry/backoff/idempotency
- deployment topology
- rollback process
- operational ownership

Do not claim operational readiness unless runtime behavior has been validated in the relevant environment.
