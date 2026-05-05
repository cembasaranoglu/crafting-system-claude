# Changelog

All notable changes to Crafting Kit are recorded here. The current version is in [`VERSION`](VERSION). The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project follows SemVer (see [`GOVERNANCE.md`](GOVERNANCE.md)).

## 1.1.3 — 2026-05-05

### Fixed — Cowork plugin upload size/file-count threshold

After renaming `claude-tuning-*` (1.1.2), the full bundle still failed Cowork upload validation. Log analysis of `~/Library/Logs/Claude/main.log` revealed the actual pattern:

```
[remoteUploadOps] uploadPluginViaRemote filename=crafting-system.zip bytes=749336 overwrite=true
[remoteMarketplaceClient] uploadAccountPlugin marketplaceId=... filename=crafting-system.zip ...
# (no subsequent "Installed plugin: crafting-system" line)
```

Upload to the marketplace bucket succeeds, but the install/validation step fails silently. Empirical results across all test packages:

| Package | Skills | Size | Result |
|---|---:|---:|---|
| `crafting-system-known-good-40` | 40 | 35 KB | pass |
| `crafting-system-lean40` | 40 | 36 KB | pass |
| `crafting-system-lean` | **42** | **40 KB** | **pass** |
| `Bv2-fixed-no-agents-no-refs` | 51 | 43 KB | fail |
| Full bundle (1.1.0 / 1.1.1 / 1.1.2) | 51 + 28 agents + refs | 732 KB | fail |

The threshold sits between 42 and 51 skills, or between ~40 KB and ~43 KB. Cowork apparently caps the per-plugin install size or component count.

### Changed — `cowork/` tree restructured

`cowork/` now reflects the lean shape that Cowork accepts:

```text
cowork/
├── .claude-plugin/plugin.json   # 1.1.3
├── README.md
├── skills/                      # 42 functional skills (no references/)
├── agents/                      # 28 read-only specialist subagents (kept in repo, NOT in .plugin)
└── library/                     # Optional library skills (NOT in .plugin)
    ├── skills/                  # 9 library skills with full references/
    │   ├── adr-library/
    │   ├── diagrams-library/
    │   ├── policies-library/
    │   ├── schemas-library/
    │   ├── templates-library/
    │   ├── manifests-library/
    │   ├── examples-library/
    │   ├── failure-modes-library/
    │   └── prompt-library/
    └── .skill-packages/         # individual .skill zips for per-skill install
```

The shipped `crafting-system.plugin` (≈30 KB, 42 skills + manifest + README) installs cleanly. Agents remain in `cowork/agents/` for repo reference but are excluded from the `.plugin` build to keep file count under the threshold. Library skills (which carry full references/ for prompts, policies, schemas, ADRs, templates, etc.) live in `cowork/library/` and ship as **individual `.skill` files** under `cowork/library/.skill-packages/` — install them one-by-one in Cowork if needed.

The root `plugin/crafting-system/` (Claude Code plugin) is unchanged; it still ships full content (42 skills + 28 agents + hooks + policies) since Claude Code does not have the same threshold.

### Changed

- `VERSION` bumped to `1.1.3`.
- `plugin/crafting-system/.claude-plugin/plugin.json`, `cowork/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` bumped to `1.1.3`.
- Lean `.plugin` build command:

  ```bash
  cd cowork
  zip -qr /tmp/crafting-system.plugin .claude-plugin README.md -x '*.DS_Store'
  cd skills
  for d in */; do zip -q /tmp/crafting-system.plugin "$d/SKILL.md"; done
  ```

### Validation

- `make validate` — pass
- `bash plugin/crafting-system/scripts/validate-plugin.sh` — pass
- `bash plugin/crafting-system/scripts/smoke-test.sh` — pass
- Cowork uploads: `crafting-system-lean.plugin` (42) and `crafting-system-lean40.plugin` (40) — confirmed pass in Cowork UI

### Reference content access

Even though library skills are not in the `.plugin`, the underlying material is fully accessible:

- 132 prompts: `prompt-system/prompts/`
- 6 policies: `prompt-system/policies/`
- 5 schemas: `prompt-system/schemas/`
- 5 ADRs: `prompt-system/adrs/`
- 24 templates: `prompt-system/templates/` and `templates/`
- Diagrams, manifests, examples, failure-modes — all in `prompt-system/`
- Cowork-ready library skill bundles: `cowork/library/.skill-packages/*.skill`

## 1.1.2 — 2026-05-05

### Fixed — Cowork plugin upload validation (skill/agent names containing `claude`)

Cowork rejects plugin packages whose **skill or subagent name contains `claude`**. Binary-search isolation across multiple test packages confirmed this: removing the only such skill (`claude-tuning-playbook`) made an otherwise-failing 6-skill bundle pass.

Renames applied in both `plugin/crafting-system/` and `cowork/`:

| Old name | New name |
|---|---|
| `claude-tuning-playbook` (skill) | `prompt-tuning-playbook` |
| `claude-tuning-reviewer` (subagent) | `prompt-tuning-reviewer` |

Wired through:

- skill folder + `SKILL.md` `name:` + body header in plugin and cowork
- agent file + `name:` + body header in plugin and cowork
- `plugin/crafting-system/.claude-plugin/plugin.json` agents array
- `prompt-system/skill_manifest.yaml`
- `prompt-system/prompt_to_skill_map.yaml`
- `prompt-system/agent_manifest.yaml`
- READMEs (root, plugin, cowork) and GUIDE

Skill descriptions also stripped of bare brand mentions where the description was attributing behavior to "Claude" specifically (e.g. "Audits Claude prompts" → "Audits agent prompts"). File-path references to `CLAUDE.md` (a generated artifact name) were preserved.

Note: `docs/03_claude_tuning_playbook.md` retains the legacy filename for backwards-compat with prior CHANGELOG / README links; only the in-plugin skill/agent surface was renamed.

### Changed

- `VERSION` bumped to `1.1.2`.
- `plugin/crafting-system/.claude-plugin/plugin.json`, `cowork/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` bumped to `1.1.2`.

### Validation

- `make validate` — pass
- `bash plugin/crafting-system/scripts/validate-plugin.sh` — pass
- `bash plugin/crafting-system/scripts/smoke-test.sh` — pass
- Repackaged `crafting-system.plugin` from `cowork/` — `unzip -t` pass
- Cowork upload elimination tests:
  - `T1` (Sub1-fixed minus `claude-tuning-playbook`, 5 skills) — **pass** in Cowork UI
  - `crafting-system-known-good-40.plugin` (40 skills, no `claude` names) — **pass** in Cowork UI

Cowork upload of the **full** 1.1.2 bundle — to be confirmed by user; with both `claude`-named components renamed, no remaining components should trigger the rejection.

## 1.1.1 — 2026-05-04

### Fixed — Cowork plugin install validation

The Cowork desktop app rejected plugin upload of the v1.1.0 bundle. Binary-search isolation identified `adr-library/SKILL.md` as the failing component when uploaded alone. The cause was a YAML frontmatter shape Cowork's parser does not accept: a double-quoted `description` containing a colon and no blank line between the closing `---` and the body.

All 9 cowork-only library skills have been rewritten to a Cowork-safe pattern:

- `description:` is plain (unquoted) ASCII
- no colons inside the description text
- a blank line between the closing `---` and the body
- a `# <name>` heading at the top of the body

Affected files (all under `cowork/skills/<name>/SKILL.md`):

- `adr-library`
- `diagrams-library`
- `policies-library`
- `schemas-library`
- `templates-library`
- `manifests-library`
- `examples-library`
- `failure-modes-library` (already in safe form, unchanged)
- `prompt-library` (already in safe form, unchanged)

The original 41 functional skills and the new `scheduled-scoring` skill were already in the safe form; no change required.

### Changed

- `VERSION` bumped to `1.1.1`.
- `plugin/crafting-system/.claude-plugin/plugin.json`, `cowork/.claude-plugin/plugin.json`, and `.claude-plugin/marketplace.json` all bumped to `1.1.1` and re-synced.
- Marketplace plugin description tightened to mention both Claude Code and Cowork.

### Validation

- `make validate` — pass
- `bash scripts/validate_all.sh` — pass
- `bash plugin/crafting-system/scripts/validate-plugin.sh` — pass
- `bash plugin/crafting-system/scripts/smoke-test.sh` — pass
- Cowork `.plugin` repackaged from `cowork/` — `unzip -t` pass
- Solo upload test of the fixed `adr-library` to Cowork — confirmed by user

Cowork runtime upload of the **full** 1.1.1 bundle — to be confirmed by user; the same parser-safe pattern applied to all library skills should resolve the validation failure.

## 1.1.0 — 2026-05-04

### Added — scheduled scoring system

A new top-level capability: **scheduled repository scoring** across GitHub Actions, GitLab Pipelines, and Claude/project schedulers, with the boundary **CI measures, Claude interprets** (ADR-0005). The kit ships a 21-score catalog, weighted profiles (`standard`, `oss_first`, `data_heavy`), schedule routing matrix, recommended cadence (daily / weekly / monthly / on-demand), and an output schema every run conforms to.

New artifacts:

- `prompt-system/prompts/163_scheduled_scoring_system.md` — primary prompt with score catalog, schedule routing, cadence, output contract, operating rules, and stop conditions.
- `prompt-system/policies/scheduled_scoring_policy.yaml` — weighted profiles, bucket membership, routing matrix, cadence, hard rules.
- `prompt-system/schemas/scheduled_run_report.schema.yaml` — run-report output schema (every score must record `evidence` or `not_run`; no silent zeros).
- `prompt-system/adrs/adr-0005-scheduled-scoring-boundary.md` — boundary rationale.
- `docs/11_scheduled_scoring.md` — developer guide.
- `plugin/crafting-system/skills/scheduled-scoring/SKILL.md` — Claude Code skill (manual-only invocation).
- `cowork/skills/scheduled-scoring/{SKILL.md,references/}` — Cowork skill bundling the prompt, policy, schema, and ADR as references.

Cowork library skills updated to include the new prompt/policy/schema/ADR (`prompt-library`, `policies-library`, `schemas-library`, `adr-library`).

Manifests + index updated:

- `prompt-system/prompt_manifest.yaml` — entry for `prompt.163_scheduled_scoring_system`.
- `prompt-system/skill_manifest.yaml` — entry for skill `scheduled-scoring` (manual-only).
- `prompt-system/prompt_to_skill_map.yaml` — map `163` → `scheduled-scoring`.
- `prompt-system/stage_manifest.yaml` and root `stage_manifest.yaml` — new stage `scheduled_scoring`.
- `prompt-system/PROMPT_INDEX.md` — regenerated; total prompts now 133.

### Changed

- `VERSION` bumped to `1.1.0`.
- `plugin/crafting-system/.claude-plugin/plugin.json` and `cowork/.claude-plugin/plugin.json` versioned to `1.1.0` with refreshed descriptions and `keywords` (`scheduled-scoring`, `ci-interpretation` added).
- `.claude-plugin/marketplace.json` versioned to `1.1.0`.
- `README.md`, `GUIDE.md`, `plugin/crafting-system/README.md`, `cowork/README.md` updated to reflect the new skill, scores, and developer doc.
- Skill count moved from 41 to 42 (plugin) and 50 to 51 (cowork, including library skills).

### Validation status

- `make validate` — pass
- `bash scripts/validate_all.sh` — pass
- `bash plugin/crafting-system/scripts/validate-plugin.sh` — pass
- `bash plugin/crafting-system/scripts/smoke-test.sh` — pass
- `python3 scripts/render_prompt_index.py --check` — in sync
- Cowork `.plugin` repackaged from `cowork/` — pass

`claude --plugin-dir` runtime load — **not run** in this checkout.

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
