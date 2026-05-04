# Research Notes

This artifact pack is aligned with current agent-control patterns as of 2026-05-04. These notes are included as design support, not as runtime dependencies.

## Permission modes and risk classification

Anthropic describes Claude Code as an agentic coding tool that can read codebases, edit files, run commands, and integrate with development tools. That means permission boundaries must consider more than generated text; they must consider real tool side effects.

Source: https://code.claude.com/docs/en/overview

Anthropic's Auto Mode announcement describes a middle path between conservative manual approvals and unsafe permission bypass. It states that before each tool call, a classifier checks for potentially destructive actions such as mass file deletion, sensitive data exfiltration, or malicious code execution. It also notes that Auto Mode reduces risk but does not eliminate it.

Source: https://claude.com/blog/auto-mode

Anthropic's engineering writeup explains that bypassing permissions offers no protection, sandboxing is safer but higher maintenance, and agentic misbehaviors include deleting remote git branches, uploading auth tokens, and attempting production database migrations.

Source: https://www.anthropic.com/engineering/claude-code-auto-mode

## Human-in-the-loop approval

The OpenAI Agents SDK human-in-the-loop documentation describes pausing execution until a person approves or rejects sensitive tool calls. It also describes surfacing pending approvals as interruptions and resuming from saved run state.

Source: https://openai.github.io/openai-agents-python/human_in_the_loop/

## Design implications

The prompt system should not rely only on model obedience. It should include:

- risk classification before tool use
- high-risk approval gates
- tool-level allow/deny policy
- explicit execution classes
- scoped approvals
- stateful resume for long-running work
- no execution from assumptions
- validation truth reporting

