# Research Notes Used While Building This Prompt Pack

This file summarizes the public documentation signals used to make the pack Claude-compatible. Re-check official docs when using the pack in the future.

## Claude Code

Source consulted: official Claude Code documentation.

Key design implications:

- Claude Code can read a codebase, edit files, run commands, and integrate with development tools. This pack separates analysis prompts from code-authoring prompts so Claude does not edit files before the user explicitly asks.
- Claude Code is available across terminal, IDE, desktop app, and browser surfaces. This pack avoids depending on a single surface.
- Claude Code skills use `SKILL.md`; Claude loads skill bodies only when relevant or invoked. This pack keeps always-on `CLAUDE.md` small and places long reusable procedures under `.claude/skills` templates.
- Claude Code supports MCP connections to external tools and data sources. This pack treats MCP as optional and requires trust/security review before connecting tools, especially third-party servers.
- Claude Code context and cost guidance recommends `/usage`, `/clear`, `/compact`, custom compaction instructions, and choosing Sonnet for most coding tasks while reserving Opus for more complex architecture or multi-step reasoning.

## Claude prompt engineering

Source consulted: official Anthropic prompt engineering documentation.

Key design implications:

- Claude prompting guidance emphasizes clarity, examples, XML-style structure, output control, thinking, and agentic systems.
- The prompt improver documentation highlights structured templates, XML tags, reasoning instructions, and example enhancement. This pack uses those patterns but asks for concise visible rationale in deliverables.
- For output consistency, Anthropic recommends precisely specifying the desired output format and using examples. This pack defines named artifacts and YAML/Markdown schemas.
- Prompt caching is useful for static instructions, examples, and large repeated context. This pack separates stable base/context instructions from task-specific instructions so API users can cache the stable prefix.

## Cursor

Official Cursor docs pages were located but the browser-accessible page content was mostly client-rendered during this run. The pack therefore uses conservative Cursor project-rule templates and marks them review-required.

Practical Cursor design implications:

- Keep project rules compact and repository-specific.
- Prefer `.cursor/rules/*.mdc` project rules over one giant legacy `.cursorrules` file.
- Do not store personal Cursor settings, chat history, secrets, or local machine paths in the repository.
- Use Cursor rules for coding conventions and boundaries; keep long procedures in docs or Claude skills.

## Review requirement

Before committing `.claude` or `.cursor` files to a real repository, review them with your team.


## Cursor

Source consulted: official Cursor Rules documentation.

Key design implications:

- Cursor supports persistent instructions via rules. This pack provides repository-level rule templates under `.cursor/rules/`.
- Cursor rules should be treated as repository policy, not as personal notes.
- Because Cursor formats and rule loading behavior can change, the generated Cursor files are templates that must be reviewed in the target Cursor version before committing.
