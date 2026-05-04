# Dependency policy

Dependencies should be intentional, reproducible and reviewable.

Minimum expectations:

- Prefer existing dependencies before adding new ones.
- Prefer standard library/platform capabilities where practical.
- Keep lockfiles under the repository policy for the detected ecosystem.
- Separate security updates from unrelated feature changes when needed.
- Do not accept dependency updates without validation notes.

Every dependency change should state:

- package name
- current version
- target version
- direct or transitive status
- reason for the change
- advisory link when applicable
- lockfile impact
- validation run and validation not run
