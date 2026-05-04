# Changelog

All notable changes to Crafting Kit are recorded here. The current version is in [`VERSION`](VERSION). The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project follows SemVer (see [`GOVERNANCE.md`](GOVERNANCE.md)).

## 1.0.2 — 2026-05-04

### Fixed

- Repaired malformed agent body text on 7 subagents (`documentation-dx-lead`, `git-release-operator`, `oss-governance-reviewer`, `principal-architect`, `product-market-analyst`, `readiness-auditor`, `strict-code-reviewer`) where the persona statement read `You are <verb-phrase>...` instead of a proper role description.
- Removed non-spec `skills:` key from those 7 subagents' frontmatter so the YAML matches the documented Claude Code subagent contract (`name`, `description`, `tools`, `model`). Companion-skill information is now preserved as plain text in the body.

### Changed

- Reformatted `.mcp.example.json`, `.lsp.example.json`, and `settings.example.json` for consistent indentation; content unchanged.
- `.claude-plugin/marketplace.json` now records `metadata.version`, and each plugin entry records `version`, `license`, and `keywords` to match current Claude Code marketplace conventions.

### Documentation

- Rewrote top-level `README.md` to reflect actual repository contents (133 prompts, 41 skills, 28 agents, real script names, real Makefile targets) and removed claims about files that do not exist (e.g. `.github/ISSUE_TEMPLATE/*`, `.github/PULL_REQUEST_TEMPLATE.md`).
- Rewrote `GUIDE.md` with the real stage flow and per-workflow prompt IDs.
- Rewrote `CONTRIBUTING.md` with concrete validation commands and PR expectations.
- Rewrote `GOVERNANCE.md` with explicit decision-process rules and SemVer policy.
- Rewrote `SECURITY.md` with secret-policy enforcement points (policies, hooks, scripts) and a hardening checklist.
- Rewrote `SUPPORT.md` and `CODE_OF_CONDUCT.md` for clarity.

### Validation status of this change

- `make validate` — pass
- `bash scripts/validate_all.sh` — pass
- `bash plugin/crafting-system/scripts/validate-plugin.sh` — pass
- `bash plugin/crafting-system/scripts/smoke-test.sh` — pass
- `bash plugin/crafting-system/scripts/test-hooks.sh` — pass
- `bash plugin/crafting-system/scripts/test-secret-scan.sh` — pass
- `claude --plugin-dir ./plugin/crafting-system` — **not run** (Claude Code CLI not invoked from this checkout).

## 1.0.1 — 2026-05-04

- Applied W00–W15 static release-readiness closure plan.
- Fixed Claude Code skill / agent frontmatter and YAML metadata.
- Hardened disabled-by-default hook examples.
- Added validation and packaging scripts (`scripts/validate_all.{sh,py}`, `scripts/package_release.sh`, `plugin/crafting-system/scripts/{validate-plugin,smoke-test,package-plugin,test-hooks,test-secret-scan,git-safety-preflight,install-local}.sh`).

## 1.0.0 — 2026-05-04

- Consolidated previous prompt-system packages into Crafting Kit.
- Renamed public package identity to **Crafting Kit**.
- Set plugin namespace to `crafting-system`.
- Recorded author metadata for Cem Basaranoglu.
- Added global risk gate, intent/stage router, no-assumption contract, execution control, tool permission policy, human approval protocol, validation-and-reporting gate (prompts `150`–`157`).
- Added secret-aware runtime credential prompt and matching plugin skill (prompt `158`, skill `secret-aware-runtime-credentials`).
- Added Claude tuning playbook (`prompts/160`) and Cursor advanced rules (`prompts/161`) prompts.
- Added prompt glossary and dependency map generator (`prompts/159`, `docs/02_prompt_glossary_and_dependency_map.md`).
- Added OSS community-health files (`LICENSE`, `NOTICE`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `GOVERNANCE.md`, `CHANGELOG.md`).
- Added plugin validation and smoke-test scripts.
