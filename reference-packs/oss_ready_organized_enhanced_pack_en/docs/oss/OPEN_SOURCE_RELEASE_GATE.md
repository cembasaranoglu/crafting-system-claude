# Open source release gate

Public release blockers:

- real secrets committed
- unclear license
- missing security disclosure channel
- missing README purpose and usage
- private customer data in docs/tests/examples
- internal hostnames/tokens/credentials in config
- unreviewed third-party license exposure
- unsupported production-readiness claims
- missing validation story for build/test/lint/security checks

A repository can be prepared for OSS review before all release blockers are resolved, but public release should not proceed until blockers are explicitly handled.
