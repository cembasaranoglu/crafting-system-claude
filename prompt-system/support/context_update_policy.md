# Context Update Policy

Update AI context files when repository truth changes.

## Update triggers

- new or removed runtime surface
- public API/CLI/config change
- feature status changes
- architecture boundary changes
- build/test/lint command changes
- deployment/runtime changes
- security/secrets policy changes
- docs structure changes

## Files to review

- `CLAUDE.md`
- `docs/AI_CONTEXT.md`
- `docs/PROJECT_GLOSSARY.md`
- `docs/FEATURE_INVENTORY.md`
- `docs/QUESTION_ROUTING_MAP.md`
- `.claude/skills/*/SKILL.md`
- `.claude/agents/*.md`
- `.cursor/rules/*.mdc`

## Rules

- Keep stable, curated context in repository docs.
- Keep personal sessions, run logs, temporary prompts, and scratch artifacts outside repository.
- Do not store secrets or private credentials.
- Mark unknowns and not-run validation.
