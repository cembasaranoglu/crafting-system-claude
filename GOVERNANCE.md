# Governance

Crafting Kit is maintained by **Cem Basaranoglu** unless ownership is transferred in a future release and recorded here and in [`NOTICE`](NOTICE).

## Maintainership

- The maintainer has merge rights on `main` and decides on release tagging.
- The maintainer is responsible for keeping the validation suite (`make validate`) green on `main` before tagging.
- Additional maintainers may be added by an explicit PR that updates this file and `NOTICE`.

## Decision process

| Change type | Process |
|---|---|
| Typos, link fixes, doc clarifications | Single-reviewer PR. |
| Prompt content edits within an existing prompt | Reviewer PR. Update `prompt-system/prompt_manifest.yaml` only if metadata changes. |
| New prompt / skill / agent | Reviewer PR with manifest entries and validation results. |
| Renames | Reviewer PR with `prompt-system/prompt_aliases.yaml` updated and PROMPT_INDEX regenerated. |
| Behavior changes to prompts `150`–`158` (risk, execution, approval, secrets) | Maintainer review required. |
| Changes to `policies/*.yaml`, `schemas/*.yaml`, `plugin/.../secret_tool_policy.yaml` | Maintainer review required. |
| Hook / MCP / LSP example changes | Maintainer review. Examples must remain disabled-by-default. |
| Validator changes (`scripts/validate_*.py`, `check_*.py`) | Maintainer review. Validators must not silently weaken. |
| Breaking changes (manifests, public skill names, prompt IDs) | Maintainer review. Record in `CHANGELOG.md`; for architectural changes, add an ADR under `prompt-system/adrs/`. |

## Versioning

The current version lives in [`VERSION`](VERSION) and tracks `CHANGELOG.md`. Use SemVer:

- **MAJOR** for breaking changes to manifests, public skill names, prompt IDs, or hook/policy contracts.
- **MINOR** for additive prompts, skills, agents, gates, validators, or templates.
- **PATCH** for fixes, doc updates, and non-behavioral cleanups.

## ADRs

Architectural decisions are recorded under [`prompt-system/adrs/`](prompt-system/adrs/). Existing ADRs:

- ADR-0001: Global risk gate
- ADR-0002: Execution as a first-class stage
- ADR-0003: No-assumption execution
- ADR-0004: Tool permission enforcement

New architectural decisions should follow the same pattern (see [`docs/09_adr_rfc_style_guide.md`](docs/09_adr_rfc_style_guide.md)).

## Conflict resolution

Disagreements should be resolved through:

1. PR discussion with cited sources or runs.
2. ADR/RFC if the question is architectural.
3. Maintainer decision if consensus isn't reached. Maintainer decisions are explained in writing in the PR or issue thread.

## Communication

- Public discussion: GitHub issues / PRs in the project's fork.
- Security: see [`SECURITY.md`](SECURITY.md). Do not file public issues.
- Conduct: see [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).
