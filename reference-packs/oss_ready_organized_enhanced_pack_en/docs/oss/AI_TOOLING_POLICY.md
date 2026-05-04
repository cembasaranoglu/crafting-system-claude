# AI tooling policy

AI tools may be used for planning, review, documentation and code assistance, but generated output must be reviewed like any other contribution.

Not allowed by default:

- personal `.cursor` workspace state
- local Claude session files
- assistant scratch output
- generated zip/output/workspace directories
- private prompts containing secrets or credentials
- generated claims of validation that were not actually run

Allowed when intentionally reviewed:

- repository-level AI guidance docs
- checked-in prompts that contain no secrets
- coding standards or review checklists
- automation scripts that are maintained like normal source files
