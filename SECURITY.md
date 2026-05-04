# Security Policy

## Reporting a vulnerability

**Do not open a public issue** for suspected vulnerabilities or exposed secrets.

Use a private maintainer contact (private security advisory or direct contact). Replace this placeholder with the project's preferred security contact before any public release:

```text
Security contact: <set by maintainer before publishing>
PGP key (optional): <set by maintainer before publishing>
```

When reporting, include:

- a clear description of the issue and impact
- steps to reproduce (or a minimal repro)
- affected files / prompts / skills / scripts
- the version (`VERSION`) and commit you tested against
- any logs you can share **with secrets removed**

A maintainer will acknowledge receipt and provide a remediation timeline. Do not disclose publicly until a fix or coordinated disclosure date is agreed.

## Secret policy

Real credentials are **never** accepted in:

- prompts, skills, agents, hooks, scripts, or plugin manifests
- issues, PRs, discussions, examples, tests, fixtures, logs
- generated artifacts, run summaries, or release zips

If a secret is accidentally exposed:

1. **Rotate it immediately** at the source system (cloud, registry, etc.).
2. Remove it from history per your organization's incident process (`git filter-repo` / BFG, then force-push and re-tag if required).
3. Audit access logs for the rotated credential.
4. Notify maintainers via the private channel above.

The plugin-side enforcement lives in:

- [`plugin/crafting-system/policies/secret_tool_policy.yaml`](plugin/crafting-system/policies/secret_tool_policy.yaml) — deny lists for sensitive paths and commands.
- [`plugin/crafting-system/hooks/pretooluse-secret-guard.sh`](plugin/crafting-system/hooks/pretooluse-secret-guard.sh) — pre-tool-use guard.
- [`plugin/crafting-system/hooks/posttooluse-secret-scan.sh`](plugin/crafting-system/hooks/posttooluse-secret-scan.sh) — post-tool-use scan.
- [`plugin/crafting-system/scripts/test-secret-scan.sh`](plugin/crafting-system/scripts/test-secret-scan.sh) — local test against `tests/fixtures/secrets/`.

The prompt-side contract is in [`prompt-system/prompts/158_secret_and_runtime_credentials.md`](prompt-system/prompts/158_secret_and_runtime_credentials.md) and [`prompt-system/prompts/21_security_privacy_secrets_audit.md`](prompt-system/prompts/21_security_privacy_secrets_audit.md).

## Scope

This policy covers:

- prompts, skills, agents, hooks, and scripts in this repository
- the plugin manifest at `plugin/crafting-system/.claude-plugin/plugin.json`
- packaging scripts (`scripts/package_release.sh`, `plugin/crafting-system/scripts/package-plugin.sh`)
- example MCP/LSP/settings files (which must remain disabled-by-default)

It does **not** cover downstream forks, third-party MCP servers, third-party Claude Code plugins, or runtime environments where this kit is loaded.

## Supported versions

Until a public versioning policy is published, only the latest tag in [`CHANGELOG.md`](CHANGELOG.md) is supported. Maintainers should document a real support window (e.g. last two MINOR versions) before public release.

## Hardening checklist before publishing

If you fork or vendor this repo for public release, run through:

- replace the placeholder security contact above
- run `make validate`
- run `bash plugin/crafting-system/scripts/test-secret-scan.sh`
- verify `scripts/package_release.sh` excludes (`.env*`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `secrets/`) match your repo's conventions
- verify hooks are still example-only (`hooks/hooks.json.example`, no `hooks.json`)
- review [`reference-packs/oss_ready_organized_enhanced_pack_en/docs/oss/SECURITY_RESPONSE_PROCESS.md`](reference-packs/oss_ready_organized_enhanced_pack_en/docs/oss/SECURITY_RESPONSE_PROCESS.md) for a fuller process template
