# Usage

## 1. Audit-only mode

Use audit-only mode to generate reports without writing scaffold files into the target repository.

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /path/to/repo --audit-only
```

This mode produces reports such as:

- `run_summary.md`
- `repo_findings.md`
- `toolchain_inventory.md`
- `suggestions.md`
- `suggestion_severity_summary.md`
- `oss_readiness_snapshot.md`

## 2. Dry-run mode

Use dry-run mode to see what the script would create or update.

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /path/to/repo --dry-run
```

## 3. Scaffold apply

Use scaffold apply mode to create the safe baseline repository files.

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /path/to/repo
```

Existing files are not overwritten by default. Existing paths are recorded in `skipped_files.list`.

## 4. Optional platform templates

GitHub templates are enabled by default:

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --github
```

Disable GitHub templates:

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --no-github
```

Add GitLab issue and merge request templates:

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --gitlab
```

## 5. Dependency bot selection

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dependency-bot auto
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dependency-bot dependabot
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dependency-bot renovate
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dependency-bot off
```

`auto` creates a Dependabot config when GitHub templates are enabled. If GitHub templates are disabled, no dependency bot config is generated.

## 6. Safe overwrite

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --overwrite
```

Overwrite mode creates timestamped `.bak` files before replacing existing generated target files.

## 7. Dirty working tree guard

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --fail-on-dirty
```

This fails when the target path is a Git repository with uncommitted changes.

## 8. Report directory

By default, reports are created outside the target repository under `/tmp`. A custom report directory can be provided:

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --report-dir /tmp/my-oss-report
```

Do not place run reports inside the shipped repository unless that is an intentional project policy.

## 9. Scorecard workflow scaffold

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --scorecard
```

This creates a workflow file only. It does not run OpenSSF Scorecard and does not claim a Scorecard result.

## 10. REUSE/SPDX sample material

```sh
sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --reuse-samples
```

This creates inactive sample material only. It does not claim REUSE compliance.
