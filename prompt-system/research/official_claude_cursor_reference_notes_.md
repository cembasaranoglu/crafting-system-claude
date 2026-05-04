# Official Claude/Cursor Reference Notes for Pack

Research date: 2026-05-04.

## Claude Code plugin model

Claude Code plugins are directories with `.claude-plugin/plugin.json` and optional root-level `skills/`, `commands/`, `agents/`, `hooks/`, `.mcp.json`, `.lsp.json`, `monitors/`, `bin/`, and `settings.json` components. Plugin components should not be placed inside `.claude-plugin/` except `plugin.json`.

Local test command:

```bash
claude --plugin-dir ./plugin/crafting-system
```

## Claude skills model

Claude Code skills use `SKILL.md` with YAML frontmatter plus Markdown instructions. Skills can live at project, personal, enterprise, or plugin scope. Plugin skills are namespaced by plugin name.

## Claude subagents model

Subagents use Markdown files with YAML frontmatter. The required fields are `name` and `description`; optional fields include tools, model, skills, memory, effort, isolation, maxTurns, and others. Plugin subagents have some security restrictions.

## Cursor rules model

Cursor project rules are persistent repository instructions. This pack uses flat `.cursor/rules/*.mdc` templates because that remains broadly compatible with the current Cursor rules workflow. Teams may also use `AGENTS.md` for cross-agent instructions.

## MCP/tooling safety

MCP servers can give Claude direct access to tools, databases, APIs, and workflows. Treat MCP as a privileged integration surface: least privilege, explicit approval, secret isolation, prompt-injection review, and auditability are required.

