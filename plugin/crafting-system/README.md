# Crafting Kit — Claude Code plugin (`crafting-system`)

- **Plugin name:** `crafting-system`
- **Author:** Cem Basaranoglu
- **License:** MIT
- **Manifest:** [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- **Marketplace descriptor:** [`../../.claude-plugin/marketplace.json`](../../.claude-plugin/marketplace.json)

This plugin packages Crafting Kit workflows as Claude Code **skills** (auto-invocable) and **subagents** (delegatable). It is designed to be loaded in Claude Code via `claude --plugin-dir`, or installed via the local marketplace at `.claude-plugin/marketplace.json`.

## What's in this directory

```text
plugin/crafting-system/
├── .claude-plugin/plugin.json        # Plugin manifest
├── .mcp.example.json                 # Example MCP server config (disabled)
├── .lsp.example.json                 # Example LSP config (project-specific, disabled)
├── settings.example.json             # Example Claude Code settings (disabled)
├── agents/                           # 28 subagents (.md with YAML frontmatter)
├── commands/                         # Slash commands (currently empty)
├── examples/                         # hooks.json.example, local_plugin_test.md
├── hooks/                            # Hook scripts + hooks.json.example (disabled-by-default)
├── policies/                         # tool_permission_policy.yaml, secret_tool_policy.yaml
├── scripts/                          # validate / smoke-test / package / install scripts
├── skills/                           # 41 skills (each is a folder with SKILL.md)
├── tests/                            # Test fixtures (secret-scan)
└── README.md                         # This file
```

## Local test

From this directory:

```bash
./scripts/validate-plugin.sh
./scripts/smoke-test.sh
claude --plugin-dir .
```

From the package root:

```bash
bash plugin/crafting-system/scripts/validate-plugin.sh
bash plugin/crafting-system/scripts/smoke-test.sh
claude --plugin-dir ./plugin/crafting-system
```

`smoke-test.sh` runs `validate-plugin.sh`, `test-hooks.sh`, `test-secret-scan.sh`, and packages the plugin to `/tmp/crafting-system-plugin.zip` (verifying the zip with `unzip -t`).

## Skills (41)

Skills are auto-invocable units that Claude Code can choose to apply when a user request matches their description. Each skill is a folder under `skills/` with a `SKILL.md` containing YAML frontmatter (`name`, `description`, optional `disable-model-invocation`).

```text
adr-rfc-writer                  ai-context-builder
ai-context-compiler             architecture-fitness
claude-tuning-playbook          code-quality-bar
code-review-quality-gate        compliance-evidence
context-map                     cursor-rules-compiler
docs-oss-writer                 eval-plan
evidence-ledger                 failure-mode-auditor
feature-inventory               git-safety-automation
git-workflow                    hld-strict
lld-strict                      mcp-permission-model
mcp-tooling-readiness           multi-agent-orchestrator
oss-ready-packager              oss-release-readiness
patch-diff-mode                 plugin-review
product-docs-generator          product-vision-competitor
prompt-audit                    prompt-design
prompt-glossary-navigator       prompt-test-harness
readiness-aggregator            readiness-gates
refactor-strict                 repo-qa-knowledge-base
risk-execution-control          safe-refactoring-family
secret-aware-runtime-credentials  security-supply-chain
```

Skills marked `disable-model-invocation: true` are intended to be triggered explicitly (by user request or another skill), not auto-selected by the model. As of `1.0.2`, that includes the gate-style skills: `git-safety-automation`, `git-workflow`, `mcp-permission-model`, `mcp-tooling-readiness`, `oss-ready-packager`, `oss-release-readiness`, `patch-diff-mode`, `plugin-review`, `readiness-aggregator`, `readiness-gates`, `risk-execution-control`, `risk-gate`, `secret-aware-runtime-credentials`.

Example invocations from a Claude Code session:

```text
/crafting-system:prompt-audit
/crafting-system:prompt-design
/crafting-system:risk-execution-control
/crafting-system:secret-aware-runtime-credentials
/crafting-system:code-review-quality-gate
/crafting-system:adr-rfc-writer
/crafting-system:readiness-aggregator
/crafting-system:cursor-rules-compiler
```

## Subagents (28)

Subagents are delegatable specialists. Each `agents/<name>.md` has YAML frontmatter (`name`, `description`, `tools`, optional `model`) and a body describing scope and rules.

```text
adr-rfc-editor             api-contract-reviewer
claude-tuning-reviewer     cursor-context-architect
docs-maintainer            documentation-dx-lead
evidence-auditor           git-release-operator
kubernetes-runtime-agent   lead-orchestrator
oss-governance-agent       oss-governance-reviewer
performance-reviewer       plugin-reviewer
principal-architect        product-analyst
product-market-analyst     prompt-architect
readiness-auditor          refactoring-architect
release-manager            repo-cartographer
risk-gatekeeper            secret-boundary-reviewer
security-reviewer          strict-code-reviewer
supply-chain-agent         test-strategy-agent
```

All subagents currently declare `tools: Read, Grep, Glob` — i.e. read-only / planning. None of them execute writes, Git mutations, releases, or deployments. To grant write capability, edit the agent's `tools:` field and pair it with the appropriate gate prompts (`154`, `155`, `156`).

## Hooks (disabled by default)

```text
hooks/
├── hooks.json.example                 # PreToolUse + PostToolUse matchers
├── pretooluse-secret-guard.sh         # Block reads/commands that hit credential paths
├── pretooluse-block-dangerous-git.sh  # Block destructive git operations without auth
├── posttooluse-secret-scan.sh         # Scan post-write content for secret patterns
└── README.md
```

Hooks are loaded only when a real `hooks/hooks.json` exists. The shipped file is `hooks/hooks.json.example`, so hooks are off by default. Enable them deliberately:

```bash
cp plugin/crafting-system/hooks/hooks.json.example plugin/crafting-system/hooks/hooks.json
```

Then re-validate:

```bash
bash plugin/crafting-system/scripts/test-hooks.sh
bash plugin/crafting-system/scripts/test-secret-scan.sh
```

The hook scripts use `${CLAUDE_PLUGIN_ROOT}` so they keep working regardless of where the plugin is installed.

## Policies

- [`policies/tool_permission_policy.yaml`](policies/tool_permission_policy.yaml) — default-deny tool permissions; explicit approval required for external writes; untrusted-content fetching is treated as instruction-untrusted.
- [`policies/secret_tool_policy.yaml`](policies/secret_tool_policy.yaml) — denylist of paths and commands that expose secrets; allowlist for safe placeholders and example configs.

These policies are intended to be **referenced** by prompts and skills (e.g. `prompts/155_tool_permission_policy.md`, `prompts/158_secret_and_runtime_credentials.md`); enforcement at runtime requires the hooks above to be enabled.

## MCP, LSP, settings

All three are shipped as `.example` files and **disabled by default**:

- [`.mcp.example.json`](.mcp.example.json) — example `mcpServers` entry, read-only mode. Rename to `.mcp.json` to enable.
- [`.lsp.example.json`](.lsp.example.json) — example LSP server config (Go + TypeScript). Project-specific convention; rename to `.lsp.json` to enable.
- [`settings.example.json`](settings.example.json) — minimal Claude Code settings (`subagentStatusLine: true`). Rename to `settings.json` to enable.

Do not add real credentials to any of these files. The packaging scripts exclude the obvious credential filenames, but the safe default is to keep secrets entirely outside the plugin tree.

## Safety boundaries

- Real secrets are denied by default by `policies/secret_tool_policy.yaml` and the `pretooluse-secret-guard.sh` hook.
- Destructive Git, database, deployment, release, and external-write actions require explicit approval (see `prompts/156_human_approval_protocol.md`).
- All hook, MCP, LSP, and settings files with the `.example` suffix are **disabled-by-default examples**. Enable them only after review.
- All subagents are read-only / plan-only by default.

## Scripts reference

| Script | Purpose |
|---|---|
| `scripts/validate-plugin.sh` | Validate manifests (`plugin.json`, `.mcp.example.json`, `hooks/hooks.json.example`), check hook + script files are executable, check skill/agent frontmatter has `---` markers. |
| `scripts/smoke-test.sh` | Runs `validate-plugin.sh`, `test-hooks.sh`, `test-secret-scan.sh`, then packages and tests the zip. |
| `scripts/test-hooks.sh` | Tests that the dangerous-git pre-tool hook blocks expected commands. |
| `scripts/test-secret-scan.sh` | Tests the post-write secret scan against `tests/fixtures/secrets/`. |
| `scripts/package-plugin.sh [out.zip]` | Build a plugin zip excluding `.git`, logs, env files, keys, and `secrets/`. |
| `scripts/install-local.sh <dest>` | Copy this plugin tree to `<dest>` for local installation. |
| `scripts/git-safety-preflight.sh` | Print a Git status + safety summary before mutation actions. |

## Versioning

The plugin's version is recorded in [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) and may be ahead of the package-level [`../../VERSION`](../../VERSION) for plugin-only releases. Behavior changes are recorded in [`../../CHANGELOG.md`](../../CHANGELOG.md).
