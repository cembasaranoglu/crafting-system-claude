# Package structure

This pack is deliberately structured as a small tool pack instead of a flat file dump.

## `scripts/`

Runnable tooling lives here.

- `oss-ready-bootstrap-advanced.sh`: POSIX shell script that creates scaffold files and audit reports without editing application source code.

## `docs/`

Pack-level documentation lives here.

- `OSS_READY_OVERVIEW.md`: OSS-ready definition and maturity levels.
- `USAGE.md`: script usage guide.
- `PACKAGE_STRUCTURE.md`: package layout explanation.

## `docs/oss/`

OSS readiness policy and review material that can be generated or copied into a target repository.

These files do not claim code behavior. They provide policy, checklist, decision and manual review surfaces.

## `docs/reference/`

Reference mapping and standards context live here.

## `templates/`

GitHub, GitLab, Renovate and REUSE sample templates live here.

Templates do not create active compliance claims. They must be adapted to the target repository before public release.

## `examples/`

Example script outputs live here.

## `artifacts_manifest.yaml`

Machine-readable inventory of package files and boundaries.
