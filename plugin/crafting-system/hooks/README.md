# Hook examples

Disabled by default. Claude Code command hooks receive event JSON on stdin. Copy `hooks.json.example` into a reviewed settings scope only after running `scripts/test-hooks.sh` and `scripts/test-secret-scan.sh`. Use `${CLAUDE_PLUGIN_ROOT}` paths because plugins are copied to a cache at install time.
