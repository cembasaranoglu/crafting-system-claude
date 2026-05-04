# Secret-Aware Prompt Behavior

Crafting Kit treats secrets as runtime boundary contracts, not prompt material.

## Core rule

Claude, Cursor, and plugin workflows must not ask for, read, repeat, write, log, commit, package, or transmit real credentials.

Use:

- environment variable names
- secret reference names
- placeholders
- fake local/dev-only values
- runtime injection contracts
- redaction rules
- validation rules

Do not use:

- real passwords
- credential-bearing database URLs
- API tokens
- private keys
- real certificates
- cloud credentials
- copied `.env` files
- command output that prints secrets

## Correct behavior

If code needs a database URL, ask for the env var name or secret reference, not the value.

Allowed question:

```text
Which environment variable should the application read for the database URL?
Example: DATABASE_URL
```

Forbidden question:

```text
What is the production database password?
```

If a real-looking secret appears in a user message or file, do not repeat it. Tell the user to rotate it outside the workflow and continue with placeholders or references.

## Prompt and plugin integration

Use:

- `prompt-system/prompts/158_secret_and_runtime_credentials.md`
- `plugin/crafting-system/skills/secret-aware-runtime-credentials/SKILL.md`
- `plugin/crafting-system/hooks/pretooluse-secret-guard.sh`
- `plugin/crafting-system/policies/secret_tool_policy.yaml`

## Required report

Secret-sensitive runs should produce:

```yaml
secret_handling_report:
 real_secret_requested: "yes | no"
 real_secret_received: "yes | no"
 real_secret_repeated: "no"
 secret_values_written_to_repo: "no"
 secret_values_written_to_artifacts: "no"
 placeholders_created: []
 secret_references_created: []
 redaction_added: []
 tests_added_or_recommended: []
 execution_blocked_or_approval_required: []
```
