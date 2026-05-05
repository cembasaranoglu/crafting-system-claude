# Crafting System (Cowork)

Source-first engineering prompts as Cowork skills. The shipped `.plugin` contains the **42 functional skills** that Cowork's plugin install accepts cleanly.

## What's in the `.plugin`

```text
.claude-plugin/plugin.json    # 1.1.3
README.md                     # this file
skills/                       # 42 SKILL.md files (no references/, no $ARGUMENTS)
```

42 functional skills covering: prompt audit/design, risk and execution gates, secret-aware credentials, strict code review, ADR/RFC authoring, refactoring families, readiness gates, OSS packaging, AI-context generation, Git/release safety, and **scheduled repository scoring** (CI artifacts → score report).

## What's NOT in the `.plugin` (but available in this repo)

Cowork's plugin install fails above ~50 components per upload, so the following are kept in the repo for reference but excluded from the bundled `.plugin`:

- **`agents/`** — 28 read-only specialist subagents. Used by the Claude Code plugin (`plugin/crafting-system/`), kept here as repo metadata, not in the Cowork `.plugin`.
- **`library/skills/`** — 9 library skills (`adr-library`, `diagrams-library`, `policies-library`, `schemas-library`, `templates-library`, `manifests-library`, `examples-library`, `failure-modes-library`, `prompt-library`). Each carries the full Crafting Kit prompt/policy/schema/ADR/template/manifest content as `references/`.
- **`library/.skill-packages/`** — pre-built individual `.skill` zips of the 9 library skills. Install them one at a time in Cowork (Customize → Add skill) if you want progressive-disclosure access to the full library content.

## Usage

### Install the lean plugin

1. Claude Desktop → Settings → Customize → Add plugin
2. Upload the `.plugin` produced from this `cowork/` tree (or use the prebuilt one in the workspace folder)

### (Optional) Install library skills individually

For each `.skill` file under `cowork/library/.skill-packages/`:

1. Settings → Customize → Add skill
2. Upload the `.skill` file

After install, search the skill picker by name (e.g. `prompt-library`, `policies-library`) — its `references/` folder gives Claude the full prompt/policy/schema content via Cowork's progressive disclosure.

## Quick search

Common entry points after install:

```text
prompt-audit
prompt-design
risk-execution-control
secret-aware-runtime-credentials
code-review-quality-gate
adr-rfc-writer
readiness-aggregator
scheduled-scoring
cursor-rules-compiler
prompt-tuning-playbook
```

## Build

```bash
cd cowork

# Lean .plugin (49 skills, no agents, no references) — accepted by Cowork
rm -f /tmp/crafting-system.plugin
zip -qr /tmp/crafting-system.plugin .claude-plugin README.md skills \
  -x '*.DS_Store' -x 'skills/*/references/*'

# Individual library skills
for d in library/skills/*/; do
    name=$(basename "$d")
    ( cd library/skills && zip -qr "/tmp/$name.skill" "$name" -x '*.DS_Store' )
    mv "/tmp/$name.skill" "library/.skill-packages/"
done

# Individual extras skills
for d in extras/skills/*/; do
    name=$(basename "$d")
    ( cd extras/skills && zip -qr "/tmp/$name.skill" "$name" -x '*.DS_Store' )
    mv "/tmp/$name.skill" "extras/.skill-packages/"
done
```

## Boundaries

- Real secrets must never be entered into prompts, skill triggers, or any artifact this plugin produces.
- Code modification, push, release, and destructive operations require explicit human approval.
- All subagents (in `agents/`) are read-only / plan-only.

## Scheduled scoring at a glance

The `scheduled-scoring` skill applies the **CI measures, Claude interprets** boundary across GitHub Actions, GitLab Pipelines, and Claude/project schedulers. Provide CI report artifacts (JUnit, Sonar, Codecov, OpenSSF Scorecard, SAST/SCA, secret-scan, GitLab code-quality JSON) and the skill normalizes them into the 21-score catalog, computes the weighted total, runs trend comparison against a prior report, and produces immediate / this-week / later recommendations.

The full prompt + policy + schema + ADR live under `library/skills/` once the `prompt-library`, `policies-library`, `schemas-library`, and `adr-library` skills are installed via Cowork. They are also directly readable in the repo at:

- `prompt-system/prompts/163_scheduled_scoring_system.md`
- `prompt-system/policies/scheduled_scoring_policy.yaml`
- `prompt-system/schemas/scheduled_run_report.schema.yaml`
- `prompt-system/adrs/adr-0005-scheduled-scoring-boundary.md`
- `docs/11_scheduled_scoring.md`
