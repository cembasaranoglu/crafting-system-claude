# Claude Code Plugin Install and Test Guide

## Plugin location

```text
plugin/crafting-system/
```

## Local structural validation

```bash
./plugin/crafting-system/scripts/validate-plugin.sh
./plugin/crafting-system/scripts/smoke-test.sh
```

## Local Claude Code test

```bash
claude --plugin-dir ./plugin/crafting-system
```

Inside Claude Code:

```text
/help
/agents
/crafting-system:prompt-audit
/crafting-system:risk-execution-control
/crafting-system:secret-aware-runtime-credentials
/crafting-system:code-review-quality-gate
```

## Plugin structure requirements

```text
plugin/crafting-system/
 .claude-plugin/plugin.json
 skills/<skill-name>/SKILL.md
 agents/<agent-name>.md
 hooks/hooks.json.example
 scripts/*.sh
 policies/*.yaml
 .mcp.example.json
 .lsp.example.json
 settings.example.json
```

`skills/`, `agents/`, and `hooks/` must stay at plugin root level. Only `plugin.json` belongs under `.claude-plugin/`.

## Namespacing

Skills are invoked through the plugin namespace:

```text
/crafting-system:<skill-name>
```

## Runtime validation boundary

The generated package validates file structure only. Real Claude Code runtime loading must be tested by the user in a local Claude Code environment.
