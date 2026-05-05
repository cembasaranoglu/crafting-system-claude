# 71 — Tool Permission Policy Prompt

Shared prerequisite: Load `prompts/70_execution_control.md` first.

Use this prompt to classify and permit or deny tool usage. It is designed for Claude plugins, MCP servers, IDE plugins, and local automation wrappers.

## Rule

A tool call is not allowed merely because the user asked for the final outcome. The tool call must be classified, scoped, risk-scored, and permitted.

## Tool categories

```yaml
tool_categories:
 read_only:
 examples: [read_file, list_files, search_files, inspect_repo]
 default: allow_if_inside_allowed_scope
 research:
 examples: [web_search, open_docs, fetch_official_docs]
 default: allow_if_research_gate_passed
 local_write:
 examples: [create_file, edit_file, apply_patch]
 default: allow_if_execution_risk_below_40_and_scope_bounded
 command:
 examples: [shell, build, test, lint, generate]
 default: classify_command_before_use
 package:
 examples: [zip, tar, build_artifact]
 default: allow_if_output_scope_safe
 git_local:
 examples: [git_add, git_commit, git_branch, git_checkout]
 default: approval_required
 git_remote:
 examples: [git_push, git_force_push, delete_remote_branch]
 default: approval_required_high_risk
 dependency:
 examples: [npm_install, go_get, pip_install, cargo_update]
 default: approval_required
 database:
 examples: [migration, truncate, seed, backfill, query_production]
 default: approval_required_or_denied
 deployment:
 examples: [kubectl_apply, helm_upgrade, terraform_apply, cloud_mutation]
 default: approval_required_or_denied
 secret:
 examples: [read_env, print_token, copy_key]
 default: deny_by_default
```

## Protected path rules

Deny or require approval for:

- `.env`, `.env.*`, `*.pem`, `*.key`, `*.p12`, `*.pfx`
- credential stores
- SSH keys
- cloud provider credentials
- production config
- hidden local machine state
- files outside target root
- parent directory traversal
- generated files when generator source is unknown
- lockfiles when dependency changes are not approved
- CI/CD workflows when commands are unknown

## Command classifier

Before running any command, classify:

```yaml
command_classification:
 command: ""
 working_directory: ""
 reads_only: true_or_false
 mutates_files: true_or_false
 mutates_git: true_or_false
 mutates_dependencies: true_or_false
 mutates_database: true_or_false
 mutates_external_system: true_or_false
 network_access: true_or_false
 destructive_keywords_detected: []
 secret_exposure_risk: true_or_false
 production_risk: true_or_false
 approval_required: true_or_false
 allowed: true_or_false
```

## Dangerous command signals

Treat as high or critical risk unless explicitly approved and scoped:

- `rm -rf`
- `git reset --hard`
- `git clean -fdx`
- `git push --force`
- `kubectl apply/delete/scale/rollout restart`
- `helm upgrade/install/uninstall`
- `terraform apply/destroy`
- `drop database`, `drop table`, `truncate`, `delete from` without where
- `curl | sh`, `wget | sh`, remote script execution
- package install/update commands
- commands reading `.env`, keys, tokens, home directory credentials

## Output schema

```yaml
tool_permission_decision:
 tool_name: ""
 requested_arguments_summary: ""
 execution_class: ""
 allowed: "yes | no"
 approval_required: "yes | no"
 reason: ""
 scope_boundary: ""
 protected_path_check: "passed | failed | not_applicable"
 command_classification: {}
 safer_alternative: ""
```
