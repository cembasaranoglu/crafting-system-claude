# Validation matrix

This file should be filled with repository-specific command truth.

| Area | Command | Required before PR | Required before release | Status | Notes |
|---|---|---:|---:|---|---|
| build | TODO | yes | yes | unknown | Toolchain-specific command required |
| unit tests | TODO | yes | yes | unknown | Fast deterministic tests preferred |
| integration tests | TODO | no | yes | unknown | External dependencies must be explicit |
| lint | TODO | yes | yes | unknown | Do not disable failures silently |
| format | TODO | yes | yes | unknown | Repository-specific formatter required |
| dependency scan | TODO | no | yes | unknown | Bot config is not a scan by itself |
| secret scan | TODO | yes | yes | unknown | Use a platform scanner or local scanner |
| release build | TODO | no | yes | unknown | Artifact command required |
| SBOM | TODO | no | release-dependent | unknown | Toolchain-specific |
| provenance | TODO | no | release-dependent | unknown | SLSA target required |

Do not mark a command as passing unless it was actually run for the current repository state.
