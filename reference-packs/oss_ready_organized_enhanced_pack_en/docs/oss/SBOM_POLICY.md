# SBOM policy

SBOM generation is toolchain-specific. Do not claim SBOM coverage until a real command has been selected and run.

Decisions to make:

- SBOM format: SPDX, CycloneDX or both
- generation point: build, release or package publish
- artifact storage location
- signing or attestation expectation
- direct vs transitive dependency scope
- consumer verification expectation
