# 03 — Claude Code Plugin Best Practices

## 1. Understand the layers

Claude Code customization has several layers:

| Layer | Best for | Typical location |
| --- | --- | --- |
| `CLAUDE.md` | Persistent project facts, conventions, high-level guidance | repository root or relevant package directories |
| Skills | Reusable procedures, checklists, prompt workflows, task instructions | `.claude/skills/<skill>/SKILL.md` or plugin `skills/<skill>/SKILL.md` |
| Commands | Legacy/custom command style; new work should prefer skills | `.claude/commands/` or plugin `commands/` |
| Subagents | Isolated specialized workers with separate context and tool permissions | `.claude/agents/` or plugin `agents/` |
| Hooks | Deterministic automation around tool events | `.claude/settings.json` or plugin `hooks/hooks.json` |
| MCP servers | External tools, APIs, databases, issue trackers, observability systems | `.mcp.json`, managed config, or plugin MCP config |
| LSP servers | Code intelligence and symbol navigation | `.lsp.json` or marketplace LSP plugins |
| Plugins | Shareable/versioned bundle of skills, agents, hooks, MCP, LSP, monitors, settings | plugin root with `.claude-plugin/plugin.json` |

## 2. Use standalone config before packaging

Use standalone `.claude/` when you are experimenting or customizing one repo. Package as a plugin when the workflow must be shared, versioned, reused across multiple projects, or distributed.

## 3. Keep `.claude-plugin/` clean

A Claude Code plugin should place only `plugin.json` inside `.claude-plugin/`. Skills, agents, hooks, MCP config, LSP config, monitors, binaries, and settings belong at the plugin root.

Recommended structure:

```text
my-plugin/
 .claude-plugin/
 plugin.json
 skills/
 prompt-audit/
 SKILL.md
 support/
 rubric.md
 agents/
 prompt-architect.md
 hooks/
 hooks.json
 .mcp.json
 .lsp.json
 monitors/
 monitors.json
 bin/
 settings.json
 README.md
```

Only include directories you actually need.

## 4. Write precise plugin metadata

`plugin.json` should be short and specific:

```json
{
 "name": "crafting-system",
 "description": "Prompt, risk-gate, and plugin-design workflows for Claude Code.",
 "version": "0.1.0",
 "author": { "name": "Your Team" }
}
```

The plugin name becomes the namespace for skills, such as `/crafting-system:prompt-audit`.

## 5. Design skills as products

A skill should have a clear job. Avoid dumping broad philosophy into one skill.

Good skill categories:

- prompt audit
- prompt design
- plugin review
- risk gate
- eval plan
- context map
- release/readiness review
- commit message generation

Bad skill categories:

- “do everything”
- “super prompt”
- “advanced mode”
- “production ready” without criteria

## 6. Frontmatter rules

Recommended minimum:

```yaml
---
description: Audits a Claude prompt for clarity, risk boundaries, source-first behavior, tool policy, output schemas, and evaluation readiness. Use when the user asks to review or improve a prompt.
---
```

Use `disable-model-invocation: true` when a skill should only run manually, especially for actions that stage, commit, deploy, send, delete, or post.

Avoid broad `allowed-tools` defaults. If a skill needs tool pre-approval, keep it narrow and reviewable.

## 7. Make skill descriptions triggerable but not noisy

A description should contain the natural words users will say, but not be so broad that it triggers constantly.

Good:

```text
Reviews a Claude Code plugin for manifest structure, skill boundaries, permission risk, hook safety, MCP exposure, and packaging readiness. Use when the user asks to review a plugin or plugin plan.
```

Too broad:

```text
Use for any Claude task.
```

## 8. Separate reference content from task content

Reference skill:

```markdown
---
description: Coding conventions for this repository.
---

When editing this repo, follow these conventions...
```

Task skill:

```markdown
---
description: Creates a release note from current changes.
disable-model-invocation: true
---

Create release notes for $ARGUMENTS using these steps...
```

Task skills are often better as manually invoked skills.

## 9. Use `$ARGUMENTS` for user input

Skills should explicitly capture arguments when direct invocation is expected:

```markdown
Audit this prompt or plugin target: $ARGUMENTS
```

For multi-argument tasks, use positional forms such as `$0`, `$1`, and `$2`.

## 10. Use dynamic context cautiously

Claude Code skills can inject shell command output before Claude sees the prompt. This is powerful and risky.

Use dynamic context when:

- the command is read-only
- output size is bounded
- the data is needed to ground the task
- the command is stable across environments

Avoid it when:

- command output may contain secrets
- command mutates state
- command has unbounded output
- command depends on unavailable tools
- prompt injection could arrive through external output

Prefer explicitly instructing Claude to inspect files rather than silently injecting huge command output.

## 11. Use `context: fork` for isolated work

Use a forked skill when the skill does heavy research or would flood the main conversation. Example:

```yaml
---
description: Research prompt failures across a large repository.
context: fork
agent: Explore
---
```

Do not use `context: fork` for passive reference content. A fork needs a concrete task.

## 12. Use subagents for isolation, not magic

Subagents are useful for:

- independent codebase exploration
- large search tasks
- specialist review
- parallel research
- keeping noisy logs out of the main conversation

Do not use subagents for tasks that require tight shared state across every step.

## 13. Hooks are enforcement, prompts are guidance

If something must always happen, a hook or external CI check is stronger than a prompt instruction. Use hooks for deterministic automation, but keep them safe:

- avoid destructive commands
- bound runtime and output
- treat hook input as untrusted JSON
- document what event triggers the hook
- provide opt-out or managed policy where appropriate

## 14. MCP best practices

Use MCP when Claude needs direct access to external systems such as issue trackers, design tools, monitoring dashboards, or databases.

MCP risk controls:

- connect only trusted servers
- prefer read-only credentials first
- separate dev/staging/prod servers
- document each tool’s purpose and permission boundary
- avoid exposing secrets through tool outputs
- protect against prompt injection in untrusted external content
- disable unused servers to reduce context and risk

## 15. Plugin testing checklist

Before sharing a plugin:

- `plugin.json` parses as JSON
- plugin name is stable and namespace-safe
- skills are under `skills/<name>/SKILL.md`
- skill descriptions are specific
- no broad `allowed-tools` without reason
- no dynamic command mutates state
- no secrets or local paths are embedded
- manual-only skills use `disable-model-invocation: true`
- local test with `claude --plugin-dir ./plugin-name`
- direct invocation tested for every skill
- auto-trigger behavior tested for model-invoked skills
- README explains install, usage, permissions, limitations, and support

## 16. Plugin release checklist

- Choose versioning policy.
- Add changelog.
- Add license only if you intentionally choose one.
- Include support boundaries.
- Document required local tools.
- Document security considerations.
- Review all bundled scripts.
- Test with another user or clean environment.
