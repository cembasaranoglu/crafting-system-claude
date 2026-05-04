# 07 — Context Engineering, Memory, and Cost

## 1. Put information in the right layer

| Information type | Best location |
| --- | --- |
| permanent project facts | `CLAUDE.md` |
| reusable procedure | Skill |
| shareable procedure bundle | Plugin |
| noisy independent exploration | Subagent |
| external system access | MCP |
| code symbol navigation | LSP |
| deterministic enforcement | Hook / CI |
| stable repeated API prefix | Prompt cache |
| current request data | user message / task input |
| temporary large exploration notes | progress file or subagent result |

## 2. CLAUDE.md vs Skill

Use `CLAUDE.md` for facts and conventions that should always be in context:

- repository purpose
- build/test commands
- coding conventions
- important directories
- known constraints

Use skills for procedures:

- code review process
- release checklist
- prompt audit process
- plugin packaging process
- risk gate

If a `CLAUDE.md` section becomes a long procedure, move it into a skill.

## 3. Skill lifecycle considerations

A skill body loads when invoked and then remains in the conversation. Keep it concise. Put large reference material in support files and tell Claude when to read it.

## 4. Context window strategy

For long tasks:

- keep a progress file
- keep structured state when useful
- commit or checkpoint safe intermediate work
- avoid repeatedly reading the same giant files
- use subagents for noisy exploration
- summarize intermediate findings with source references

## 5. Cost reduction

Reduce cost by:

- using the smallest effective model/effort
- caching stable prefixes
- disabling unused MCP servers
- preferring CLI commands for compact output when appropriate
- using LSP/code intelligence for typed languages
- limiting tool schemas and skill descriptions to what is needed
- using subagents for noisy work that can return a compact summary

## 6. Prompt caching design

Stable cached prefix:

```text
Base operating contract
Project conventions
Plugin/prompt policy
Long static reference docs
Tool definitions
```

Variable suffix:

```text
Current user task
Current source excerpts
Tool results
Today’s context
```

## 7. Context hygiene

Avoid:

- stuffing every document into every prompt
- repeating the same rule in many places
- keeping obsolete instructions
- loading many skills in one session when only one applies
- including secrets in prompt context
- exposing untrusted external content without warning Claude about prompt injection

## 8. Handoff format

For multi-window workflows:

```yaml
handoff:
 completed: []
 current_state: ""
 files_changed: []
 commands_run: []
 validation_status:
 run: []
 not_run: []
 failed: []
 blockers: []
 assumptions: []
 next_actions: []
```
