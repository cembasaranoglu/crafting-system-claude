# 34 — Claude Code Plugin Packager Prompt

Shared prerequisite: load and obey `prompts/00_claude_base_prompt.md`.

Use this prompt to convert repo-owned `.claude/skills`, `.claude/agents`, commands, hooks, MCP examples, and settings into a shareable Claude Code plugin.

## Plugin structure

A plugin should use:

```text
<plugin-name>/
 .claude-plugin/plugin.json
 README.md
 skills/<skill-name>/SKILL.md
 agents/<agent-name>.md
 commands/<command>.md # optional legacy/compat
 hooks/hooks.json # optional, avoid active hooks unless necessary
 .mcp.json # optional, never with secrets
 .lsp.json # optional language server config
 monitors/monitors.json # optional background monitor config
 bin/ # optional executables
 settings.json # optional default plugin settings
```

## Rules

- Keep `plugin.json` inside `.claude-plugin/` and all components at plugin root.
- Prefer skills over commands for new workflows.
- Namespace skill names through the plugin name.
- Do not include secrets, personal settings, local paths, or private workspace state.
- Make hooks opt-in or clearly documented; avoid surprise mutation.
- Include README with install, local test, skill list, risks, and uninstallation notes.
- Test locally with `claude --plugin-dir ./<plugin-name>` before publishing.
- Do not claim marketplace compatibility unless tested against current Claude Code plugin docs.

## Required output files

1. `plugin_readiness.md`
2. `plugin_manifest_plan.md`
3. `plugin_file_tree.md`
4. `plugin_security_review.md`
5. `local_plugin_test_plan.md`
6. `plugin_distribution_notes.md`
7. `run_summary.md`

