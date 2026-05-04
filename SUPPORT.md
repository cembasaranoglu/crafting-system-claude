# Support

## Where to ask

| Question type | Where |
|---|---|
| Bug reports | GitHub issues (or your fork's tracker). Include the version from [`VERSION`](VERSION) and exact reproduction steps. |
| Feature requests | GitHub issues. Describe the gap, the proposed prompt/skill/agent surface, and which existing prompt(s) it interacts with. |
| Documentation gaps | GitHub issues. Cite the file and line. |
| Prompt / plugin improvement proposals | GitHub issues, or open a draft PR with a runnable example. |
| Suspected vulnerability or exposed secret | **Do not file a public issue.** See [`SECURITY.md`](SECURITY.md). |

## What to include in a bug report

- Repository version (`VERSION`) and commit (if known).
- Exact command(s) you ran and their output.
- Whether `make validate` and the plugin scripts pass on your checkout.
- The prompt or skill ID involved (e.g. `prompts/154_execution_control.md`, `/crafting-system:secret-aware-runtime-credentials`).
- Expected vs. observed behavior.

## What to leave out

Do not include in any public support request:

- secrets, tokens, keys, or credentials (real or rotated)
- private repository contents
- production logs
- customer data or PII
- internal hostnames or URLs you wouldn't share publicly

## Self-service first

Before opening an issue, please:

1. Read [`README.md`](README.md), [`GUIDE.md`](GUIDE.md), and the relevant doc under [`docs/`](docs/).
2. Run `make validate` and the plugin scripts to confirm the issue isn't environmental.
3. Check [`prompt-system/PROMPT_INDEX.md`](prompt-system/PROMPT_INDEX.md) and the manifests under [`prompt-system/`](prompt-system/) to confirm the prompt/skill you expected actually exists.
4. Check [`CHANGELOG.md`](CHANGELOG.md) for recent behavior changes.
