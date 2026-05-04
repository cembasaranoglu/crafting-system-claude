# Supply chain policy

This policy covers dependency intake, CI execution, release artifact generation, SBOM, provenance and artifact distribution.

Minimum expectations:

- Dependencies are updated through a reviewed process.
- CI permissions are least-privilege.
- Release artifacts are produced by documented commands.
- SBOM and provenance targets are documented before public release.
- Secrets are delivered through platform secret stores, never source files.
- Build and release claims are tied to exact commands or workflow runs.
