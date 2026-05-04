#!/usr/bin/env sh
# oss-ready-bootstrap-advanced.sh
# Language-independent OSS readiness scaffold and audit report generator.
#
# Boundary:
# - Does not edit application source code.
# - Does not edit package manifests, lockfiles, vendor directories, Dockerfiles, Kubernetes manifests, or existing CI files.
# - Does not claim build/test/security/release validation.
# - Existing files are skipped by default; --overwrite creates timestamped .bak files first.
# - Run reports are written outside the target repository by default.

set -eu

PROGRAM_NAME="oss-ready-bootstrap-advanced.sh"
TARGET="$(pwd)"
PROJECT_NAME=""
OWNER="${OSS_OWNER:-${USER:-TODO_OWNER}}"
YEAR="${OSS_YEAR:-$(date +%Y)}"
LICENSE_KIND="${OSS_LICENSE:-MIT}"
CREATE_GITHUB="${OSS_CREATE_GITHUB:-1}"
CREATE_GITLAB="${OSS_CREATE_GITLAB:-0}"
DEPENDENCY_BOT="${OSS_DEPENDENCY_BOT:-auto}"
SCORECARD="${OSS_SCORECARD:-0}"
REUSE_SAMPLES="${OSS_REUSE_SAMPLES:-0}"
DRY_RUN="0"
AUDIT_ONLY="0"
OVERWRITE="0"
FAIL_ON_DIRTY="0"
REPORT_DIR=""
CODEOWNER="${OSS_CODEOWNER:-}"
RUN_ID="$(date -u +%Y%m%dT%H%M%SZ 2>/dev/null || date +%Y%m%dT%H%M%S)"

usage() {
 cat <<'EOF'
Usage:
 sh scripts/oss-ready-bootstrap-advanced.sh [options]

Options:
 --target PATH Target repository root. Default: current directory.
 --project-name NAME Project name for generated Markdown. Default: repo directory name.
 --owner NAME Copyright owner for generated LICENSE. Default: $OSS_OWNER or current user.
 --year YEAR Copyright year. Default: current year.
 --license KIND License to create when LICENSE is missing. Values: MIT, Apache-2.0, none. Default: MIT.
 --github Create GitHub community templates. Default.
 --no-github Do not create .github templates.
 --gitlab Create GitLab issue/MR templates. Default: off.
 --no-gitlab Do not create GitLab templates.
 --codeowner VALUE Create .github/CODEOWNERS with this value. Example: '@org/team'.
 --dependency-bot MODE Values: auto, dependabot, renovate, off. Default: auto.
 --scorecard Create .github/workflows/scorecard.yml. Default: off.
 --no-scorecard Do not create Scorecard workflow.
 --reuse-samples Create inactive REUSE/SPDX sample docs under docs/oss/reuse/.
 --audit-only Do not scaffold files; only produce audit reports and suggestions.
 --report-dir PATH Directory for reports. Default: outside repo under /tmp.
 --dry-run Report planned changes without modifying repository files.
 --overwrite Overwrite existing generated target files after timestamped .bak files.
 --fail-on-dirty Fail if git working tree already has changes.
 -h, --help Show this help.

Examples:
 sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --audit-only
 sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dry-run
 sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dependency-bot dependabot --scorecard
 sh scripts/oss-ready-bootstrap-advanced.sh --target /repo --dependency-bot renovate --gitlab --reuse-samples
EOF
}

say() { printf '%s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# Backwards-compatible positional target support.
if [ "$#" -gt 0 ] && [ "${1#-}" = "$1" ]; then
 TARGET="$1"
 shift
fi

while [ "$#" -gt 0 ]; do
 case "$1" in
 --target) shift; [ "$#" -gt 0 ] || fail "--target requires a path"; TARGET="$1" ;;
 --project-name) shift; [ "$#" -gt 0 ] || fail "--project-name requires a value"; PROJECT_NAME="$1" ;;
 --owner) shift; [ "$#" -gt 0 ] || fail "--owner requires a value"; OWNER="$1" ;;
 --year) shift; [ "$#" -gt 0 ] || fail "--year requires a value"; YEAR="$1" ;;
 --license) shift; [ "$#" -gt 0 ] || fail "--license requires a value"; LICENSE_KIND="$1" ;;
 --github) CREATE_GITHUB="1" ;;
 --no-github) CREATE_GITHUB="0" ;;
 --gitlab) CREATE_GITLAB="1" ;;
 --no-gitlab) CREATE_GITLAB="0" ;;
 --codeowner) shift; [ "$#" -gt 0 ] || fail "--codeowner requires a value"; CODEOWNER="$1" ;;
 --dependency-bot) shift; [ "$#" -gt 0 ] || fail "--dependency-bot requires a value"; DEPENDENCY_BOT="$1" ;;
 --scorecard) SCORECARD="1" ;;
 --no-scorecard) SCORECARD="0" ;;
 --reuse-samples) REUSE_SAMPLES="1" ;;
 --audit-only) AUDIT_ONLY="1" ;;
 --report-dir) shift; [ "$#" -gt 0 ] || fail "--report-dir requires a path"; REPORT_DIR="$1" ;;
 --dry-run) DRY_RUN="1" ;;
 --overwrite) OVERWRITE="1" ;;
 --fail-on-dirty) FAIL_ON_DIRTY="1" ;;
 -h|--help) usage; exit 0 ;;
 *) fail "unknown option: $1" ;;
 esac
 shift
done

case "$LICENSE_KIND" in
 MIT|mit) LICENSE_KIND="MIT" ;;
 Apache-2.0|apache-2.0|APACHE-2.0|Apache) LICENSE_KIND="Apache-2.0" ;;
 none|NONE|None) LICENSE_KIND="none" ;;
 *) fail "unsupported --license value: $LICENSE_KIND" ;;
esac

case "$DEPENDENCY_BOT" in
 auto|dependabot|renovate|off) ;;
 *) fail "unsupported --dependency-bot value: $DEPENDENCY_BOT" ;;
esac

[ -d "$TARGET" ] || fail "target path is not a directory: $TARGET"
cd "$TARGET" || fail "cannot cd into target: $TARGET"
TARGET_ABS="$(pwd)"

if [ -z "$PROJECT_NAME" ]; then
 PROJECT_NAME="${OSS_PROJECT_NAME:-$(basename "$TARGET_ABS") }"
 PROJECT_NAME=$(printf '%s' "$PROJECT_NAME" | sed 's/[[:space:]]*$//')
fi

if [ -z "$REPORT_DIR" ]; then
 REPORT_DIR="${TMPDIR:-/tmp}/oss-ready-${PROJECT_NAME}-${RUN_ID}"
fi
mkdir -p "$REPORT_DIR" || fail "cannot create report dir: $REPORT_DIR"

CREATED="$REPORT_DIR/created_files.list"
UPDATED="$REPORT_DIR/updated_files.list"
SKIPPED="$REPORT_DIR/skipped_files.list"
PLANNED="$REPORT_DIR/planned_files.list"
WARNINGS="$REPORT_DIR/warnings.list"
SUGGESTIONS="$REPORT_DIR/suggestions.md"
SEVERITY_SUMMARY="$REPORT_DIR/suggestion_severity_summary.md"
TOOLCHAIN="$REPORT_DIR/toolchain_inventory.md"
FINDINGS="$REPORT_DIR/repo_findings.md"
SNAPSHOT="$REPORT_DIR/oss_readiness_snapshot.md"
SUMMARY="$REPORT_DIR/run_summary.md"

: > "$CREATED"
: > "$UPDATED"
: > "$SKIPPED"
: > "$PLANNED"
: > "$WARNINGS"
: > "$SUGGESTIONS"

add_line() {
 out_file="$1"
 shift
 printf '%s\n' "$*" >> "$out_file"
}

warn() {
 printf 'WARN: %s\n' "$*" >&2
 add_line "$WARNINGS" "$*"
}

suggest() {
 severity="$1"
 area="$2"
 title="$3"
 action="$4"
 reference="${5:-}"
 {
 echo "### [$severity] $title"
 echo ""
 echo "- area: $area"
 echo "- action: $action"
 if [ -n "$reference" ]; then
 echo "- reference: $reference"
 fi
 echo ""
 } >> "$SUGGESTIONS"
}

ensure_dir() {
 dir="$1"
 [ "$dir" = "." ] && return 0
 if [ "$DRY_RUN" = "1" ]; then
 [ -d "$dir" ] || add_line "$PLANNED" "mkdir $dir"
 else
 [ -d "$dir" ] || mkdir -p "$dir"
 fi
}

backup_file() {
 file="$1"
 [ -f "$file" ] || return 0
 backup="$file.bak.$RUN_ID"
 cp "$file" "$backup"
 add_line "$UPDATED" "backup $file -> $backup"
}

write_file() {
 path="$1"
 dir="$(dirname "$path")"
 ensure_dir "$dir"
 tmp="$REPORT_DIR/write_buffer.tmp"
 cat > "$tmp"

 if [ "$AUDIT_ONLY" = "1" ]; then
 add_line "$PLANNED" "audit-only would consider $path"
 rm -f "$tmp"
 return 0
 fi

 if [ "$DRY_RUN" = "1" ]; then
 if [ -e "$path" ] && [ "$OVERWRITE" != "1" ]; then
 add_line "$SKIPPED" "$path exists"
 say "skip: $path already exists"
 elif [ -e "$path" ]; then
 add_line "$PLANNED" "overwrite $path"
 say "plan: overwrite $path"
 else
 add_line "$PLANNED" "create $path"
 say "plan: create $path"
 fi
 rm -f "$tmp"
 return 0
 fi

 if [ -e "$path" ] && [ "$OVERWRITE" != "1" ]; then
 add_line "$SKIPPED" "$path exists"
 say "skip: $path already exists"
 rm -f "$tmp"
 return 0
 fi

 if [ -e "$path" ] && [ "$OVERWRITE" = "1" ]; then
 backup_file "$path"
 cp "$tmp" "$path"
 add_line "$UPDATED" "$path"
 say "update: $path"
 else
 cp "$tmp" "$path"
 add_line "$CREATED" "$path"
 say "create: $path"
 fi
 rm -f "$tmp"
}

append_block_if_missing() {
 file="$1"
 marker="$2"
 tmp="$REPORT_DIR/block_buffer.tmp"
 cat > "$tmp"

 if [ "$AUDIT_ONLY" = "1" ]; then
 add_line "$PLANNED" "audit-only would consider block in $file"
 rm -f "$tmp"
 return 0
 fi

 if [ -f "$file" ] && grep -F "$marker" "$file" >/dev/null 2>&1; then
 add_line "$SKIPPED" "$file already has block"
 say "skip: $file already has OSS block"
 rm -f "$tmp"
 return 0
 fi

 if [ "$DRY_RUN" = "1" ]; then
 add_line "$PLANNED" "append block to $file"
 say "plan: append block to $file"
 rm -f "$tmp"
 return 0
 fi

 [ -f "$file" ] || : > "$file"
 {
 echo ""
 echo "$marker"
 cat "$tmp"
 echo "# <<< oss-ready managed block"
 } >> "$file"
 add_line "$UPDATED" "$file appended block"
 say "update: $file"
 rm -f "$tmp"
}

run_preflight() {
 say "==> OSS-ready advanced scaffold"
 say "target: $TARGET_ABS"
 say "project: $PROJECT_NAME"
 say "mode: audit_only=$AUDIT_ONLY dry_run=$DRY_RUN overwrite=$OVERWRITE"

 if [ "$FAIL_ON_DIRTY" = "1" ] && command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
 if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
 fail "git working tree is dirty and --fail-on-dirty was set"
 fi
 fi

 if [ "$OWNER" = "TODO_OWNER" ]; then
 warn "owner is TODO_OWNER; generated LICENSE requires review"
 fi
}

has_file() { [ -f "$1" ]; }
has_dir() { [ -d "$1" ]; }

write_findings_and_toolchain() {
 {
 echo "# Repository findings"
 echo ""
 echo "- target: $TARGET_ABS"
 echo "- project: $PROJECT_NAME"
 echo "- git repository: $(if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then echo yes; else echo no; fi)"
 echo "- existing README: $(if has_file README.md; then echo yes; else echo no; fi)"
 echo "- existing LICENSE: $(if has_file LICENSE || has_file LICENSE.md; then echo yes; else echo no; fi)"
 echo "- existing SECURITY.md: $(if has_file SECURITY.md; then echo yes; else echo no; fi)"
 echo "- existing CONTRIBUTING.md: $(if has_file CONTRIBUTING.md; then echo yes; else echo no; fi)"
 echo "- existing GitHub templates: $(if has_dir .github; then echo yes; else echo no; fi)"
 echo "- existing GitLab templates: $(if has_dir .gitlab; then echo yes; else echo no; fi)"
 echo "- existing docs/oss: $(if has_dir docs/oss; then echo yes; else echo no; fi)"
 } > "$FINDINGS"

 {
 echo "# Toolchain inventory"
 echo ""
 echo "Detected files do not mean validation passed. They only indicate possible ecosystems."
 echo ""
 echo "| Ecosystem | Evidence |"
 echo "|---|---|"
 [ -f package.json ] && echo "| npm/javascript | package.json |"
 [ -f pnpm-lock.yaml ] && echo "| pnpm | pnpm-lock.yaml |"
 [ -f yarn.lock ] && echo "| yarn | yarn.lock |"
 [ -f package-lock.json ] && echo "| npm lockfile | package-lock.json |"
 [ -f go.mod ] && echo "| Go modules | go.mod |"
 [ -f pyproject.toml ] && echo "| Python | pyproject.toml |"
 [ -f requirements.txt ] && echo "| Python | requirements.txt |"
 [ -f Cargo.toml ] && echo "| Rust | Cargo.toml |"
 [ -f pom.xml ] && echo "| Maven | pom.xml |"
 if [ -f build.gradle ] || [ -f build.gradle.kts ] || [ -f settings.gradle ] || [ -f settings.gradle.kts ]; then echo "| Gradle | Gradle files |"; fi
 [ -f Gemfile ] && echo "| Ruby Bundler | Gemfile |"
 [ -f composer.json ] && echo "| PHP Composer | composer.json |"
 [ -f Dockerfile ] && echo "| Docker | Dockerfile |"
 [ -f Containerfile ] && echo "| Container | Containerfile |"
 [ -d .github/workflows ] && echo "| GitHub Actions | .github/workflows |"
 if find . -maxdepth 2 -name '*.tf' -type f 2>/dev/null | grep . >/dev/null 2>&1; then echo "| Terraform | *.tf |"; fi
 if find . -maxdepth 3 -name '*.csproj' -type f 2>/dev/null | grep . >/dev/null 2>&1; then echo "| .NET/NuGet | *.csproj |"; fi
 } > "$TOOLCHAIN"
}

collect_suggestions() {
 if ! has_file README.md; then
 suggest high community "README.md is missing" "Create a README with purpose, status, install, build, test, run, config, examples, support boundary and validation status." "GitHub Community Profile"
 fi
 if ! has_file LICENSE && ! has_file LICENSE.md; then
 suggest high license "LICENSE is missing" "Choose an approved OSS license before public release. Generated license text still needs owner/year/legal review." "SPDX / REUSE"
 fi
 if ! has_file SECURITY.md; then
 suggest high security "SECURITY.md is missing" "Add vulnerability disclosure instructions and a real private reporting channel before public release." "GitHub Community Profile / OpenSSF Best Practices"
 fi
 if ! has_file CONTRIBUTING.md; then
 suggest medium contribution "CONTRIBUTING.md is missing" "Document contribution flow, validation expectations, PR/MR requirements and scope boundaries." "GitHub Community Profile"
 fi
 if ! has_file CODE_OF_CONDUCT.md; then
 suggest medium community "CODE_OF_CONDUCT.md is missing" "Add a code of conduct before opening broad community contribution." "GitHub Community Profile"
 fi
 if ! has_file SUPPORT.md; then
 suggest low support "SUPPORT.md is missing" "Define support boundary, response expectations and where questions should go." "Community health"
 fi
 if ! has_dir docs/oss; then
 suggest medium documentation "docs/oss directory is missing" "Add OSS readiness policy docs under docs/oss so repository governance is not scattered across root files." "Maintainer readiness"
 fi
 if [ "$CREATE_GITHUB" = "1" ] && ! has_file .github/pull_request_template.md; then
 suggest medium contributor-experience "GitHub pull request template is missing" "Add a PR template that asks for scope, validation, not-run commands and risk." "GitHub Community Profile"
 fi
 if [ "$CREATE_GITHUB" = "1" ] && ! has_dir .github/ISSUE_TEMPLATE; then
 suggest medium contributor-experience "GitHub issue templates are missing" "Add issue templates for bug reports and feature requests." "GitHub Community Profile"
 fi
 if [ "$DEPENDENCY_BOT" != "off" ] && ! has_file .github/dependabot.yml && ! has_file renovate.json; then
 suggest medium dependency-management "Dependency automation config is missing" "Select Dependabot or Renovate, then review ecosystem-specific update behavior." "Dependabot / Renovate / OpenSSF Scorecard"
 fi
 if [ -d .github/workflows ]; then
 if ! grep -R "^[[:space:]]*permissions:" .github/workflows >/dev/null 2>&1; then
 suggest medium ci-security "GitHub Actions permissions are not explicit" "Set least-privilege permissions in each workflow instead of relying on repository defaults." "GitHub Actions secure use / OpenSSF Scorecard"
 fi
 else
 suggest medium ci "CI workflow is missing" "Add language-specific build, test, lint and security validation after the real toolchain is confirmed." "OpenSSF Scorecard"
 fi
 if [ -f package.json ] && [ ! -f package-lock.json ] && [ ! -f pnpm-lock.yaml ] && [ ! -f yarn.lock ]; then
 suggest medium dependency-management "JavaScript lockfile is missing" "Choose package manager policy and commit the expected lockfile if reproducible installs are required." "OpenSSF Best Practices"
 fi
 if [ -f Dockerfile ] || [ -f Containerfile ]; then
 suggest medium container "Container runtime needs manual review" "Review base image pinning, non-root user, filesystem permissions, healthcheck, image labels and build provenance." "SLSA / OpenSSF Scorecard"
 fi
 if ! has_file docs/oss/VALIDATION_MATRIX.md; then
 suggest high validation "Validation matrix is missing" "Document exact build, test, lint, security and release commands; mark not-run and blocked states truthfully." "OpenSSF Best Practices"
 fi
 if ! has_file docs/oss/SBOM_POLICY.md; then
 suggest medium supply-chain "SBOM policy is missing" "Document SBOM format, generation point, artifact storage and release expectation before claiming SBOM coverage." "SLSA / SPDX"
 fi
 if ! has_file docs/oss/PROVENANCE_POLICY.md; then
 suggest medium supply-chain "Provenance policy is missing" "Document which release artifacts need provenance and what SLSA target is realistic." "SLSA"
 fi
}

write_root_files() {
 append_block_if_missing ".gitignore" "# >>> oss-ready managed block" <<'EOF'
# OS/editor noise
.DS_Store
Thumbs.db
*.swp
*.swo
.idea/
.vscode/

# logs/temp/cache
*.log
tmp/
temp/
.cache/
.cache-*/
coverage/
.coverage

# generic build outputs
build/
dist/
out/
target/

# local env and secrets
.env
.env.*
!.env.example
!.env.*.example
*.pem
*.key
*.p12
*.pfx
*.crt
*.csr
secrets/
.secret/
private/

# personal AI/editor workspace; keep intentional repo-level AI docs separately
.cursor/
.claude/settings.local.json
.claude/logs/
.claude/tmp/
.claude/cache/

# assistant/run artifacts should stay outside shipped repo
artifacts/
output/
workspace/
generated_repo/
final/
source_code/
EOF

 write_file ".gitattributes" <<'EOF'
* text=auto eol=lf

*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.webp binary
*.ico binary
*.pdf binary
*.zip binary
*.gz binary
*.tar binary
EOF

 write_file ".editorconfig" <<'EOF'
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[Makefile]
indent_style = tab
EOF

 write_file "README.md" <<EOF
# $PROJECT_NAME

## Status

This repository has an OSS readiness scaffold. This does not mean the project is production-ready, fully tested, security-reviewed, published or release-ready.

## Purpose

Describe what this project does, who it is for and what problem it solves.

## Quick start

Add repository-specific setup, build, test and run commands here.

## Configuration and secrets

Do not commit real secrets. Use safe examples such as \`.env.example\`.

## Validation status

Document exact commands that have been run and their results.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

See [SECURITY.md](SECURITY.md).

## License

See [LICENSE](LICENSE).
EOF

 if [ "$LICENSE_KIND" = "MIT" ]; then
 write_file "LICENSE" <<EOF
MIT License

Copyright (c) $YEAR $OWNER

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
 elif [ "$LICENSE_KIND" = "Apache-2.0" ]; then
 write_file "LICENSE" <<EOF
Apache License
Version 2.0, January 2004
https://www.apache.org/licenses/

Copyright $YEAR $OWNER

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

 https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
EOF
 else
 suggest high license "No LICENSE generated" "A license was intentionally not generated because --license none was selected. Choose an approved license before public release." "SPDX"
 fi

 write_file "SECURITY.md" <<'EOF'
# Security policy

## Reporting a vulnerability

Do not open public issues for sensitive security reports.

Private reporting channel:

- TODO: security contact or private disclosure channel

Please include:

- affected version or commit
- impact summary
- reproduction steps
- relevant logs or screenshots with secrets redacted

## Secrets and sensitive data

Do not commit credentials, tokens, private keys, production connection strings or private customer data.
EOF

 write_file "CONTRIBUTING.md" <<'EOF'
# Contributing

## Ground rules

- Keep changes scoped.
- Do not include secrets or private data.
- Update docs/examples when user-facing behavior changes.
- Add or update tests when behavior changes.
- Do not weaken validation, security checks or error handling to make tests pass.

## Pull request / merge request expectations

Every change should explain:

- what changed
- why it changed
- validation run
- validation not run
- risks or follow-ups
EOF

 write_file "CODE_OF_CONDUCT.md" <<'EOF'
# Code of Conduct

This project expects respectful, constructive and inclusive collaboration.

Unacceptable behavior includes harassment, abuse, discriminatory language, doxxing, threats and deliberate disruption.

Maintainers may remove, edit or reject contributions that violate this policy.
EOF

 write_file "SUPPORT.md" <<'EOF'
# Support

This repository does not define a formal SLA unless one is explicitly documented elsewhere.

Use issues or discussions for general questions. Use the private security channel in SECURITY.md for vulnerabilities.
EOF

 write_file "GOVERNANCE.md" <<'EOF'
# Governance

This repository should define maintainers, ownership boundaries, release authority and security response responsibility before broad public contribution.

See docs/oss/GOVERNANCE_MODEL.md and docs/oss/MAINTAINER_HANDOFF.md.
EOF

 write_file "MAINTAINERS.md" <<'EOF'
# Maintainers

| Area | Maintainer | Backup | Notes |
|---|---|---|---|
| project | TODO | TODO | Required before public release |
| security | TODO | TODO | Use private disclosure channel |
| release | TODO | TODO | Required before package publishing |
EOF

 write_file "CHANGELOG.md" <<'EOF'
# Changelog

All notable changes should be documented here.

This project has not declared a release/versioning policy yet.

## Unreleased

- OSS readiness scaffold added.
EOF

 write_file "docs/README.md" <<'EOF'
# Documentation

Use this directory for project documentation that is too detailed for the root README.

Recommended docs:

- architecture overview
- configuration reference
- development guide
- release guide
- operations guide
- troubleshooting
- OSS readiness docs under docs/oss/
EOF
}

write_oss_docs() {
 write_file "docs/oss/README.md" <<'EOF'
# OSS readiness docs

This directory keeps repository governance, security, release, dependency and supply-chain policy docs together.

Recommended read order:

1. OSS_READINESS_CHECKLIST.md
2. OSS_READINESS_SCORE.md
3. VALIDATION_MATRIX.md
4. DEPENDENCY_POLICY.md
5. SUPPLY_CHAIN_POLICY.md
6. HOSTING_PLATFORM_SETTINGS.md
7. OPEN_SOURCE_RELEASE_GATE.md
EOF

 write_file "docs/oss/OSS_READINESS_CHECKLIST.md" <<'EOF'
# OSS readiness advanced checklist

Mark every item as done, partial, blocked, not applicable or not reviewed.

## Repo hygiene

- [ ] No secrets committed
- [ ] No local .env committed
- [ ] No personal AI/editor workspace committed
- [ ] No build output committed unless intentional
- [ ] No assistant run output inside shipped repo
- [ ] .gitignore covers OS/editor/cache/build/log/temp files
- [ ] .gitattributes defines line ending and binary handling
- [ ] .editorconfig exists or style policy is documented

## Community profile

- [ ] README.md explains purpose, status, install, build, test, run, config, examples, support boundary
- [ ] LICENSE exists and is approved
- [ ] CONTRIBUTING.md exists
- [ ] CODE_OF_CONDUCT.md exists
- [ ] SECURITY.md contains real private disclosure channel
- [ ] SUPPORT.md defines support boundary
- [ ] issue template exists
- [ ] pull request or merge request template exists

## Validation readiness

- [ ] Build command known
- [ ] Unit test command known
- [ ] Lint/format command known
- [ ] Security/dependency scan command known
- [ ] CI workflow exists and matches actual commands
- [ ] Validation not-run states are documented

## Security and supply chain

- [ ] Dependency update bot selected
- [ ] Lockfile policy documented
- [ ] Dependency review process exists
- [ ] Vulnerability triage policy exists
- [ ] SBOM policy exists
- [ ] Provenance policy exists
- [ ] Release artifact signing policy exists or explicitly not applicable
EOF

 write_file "docs/oss/OSS_READINESS_SCORE.md" <<'EOF'
# OSS readiness score model

This model is not automatic certification. It is a maturity discussion tool.

| Level | Name | Meaning |
|---|---|---|
| L0 | Repo hygiene baseline | Repository is clean enough to review/share |
| L1 | Community profile baseline | External reader can understand project basics |
| L2 | Contributor-ready | Contribution workflow is clear |
| L3 | Maintainer-ready | Ownership, governance and handoff are clear |
| L4 | Validation-ready | Build/test/lint/security commands are known and reportable |
| L5 | Release-ready | Versioning, changelog, artifact and package release policy are clear |
| L6 | Security/supply-chain-ready | Dependency, provenance, SBOM, platform security and disclosure posture are clear |

Use validated only when exact evidence exists.
EOF

 write_file "docs/oss/VALIDATION_MATRIX.md" <<'EOF'
# Validation matrix

| Area | Command | Required before PR | Required before release | Status | Notes |
|---|---|---:|---:|---|---|
| build | TODO | yes | yes | unknown | Toolchain-specific command required |
| unit tests | TODO | yes | yes | unknown | Fast deterministic tests preferred |
| integration tests | TODO | no | yes | unknown | External dependencies must be explicit |
| lint | TODO | yes | yes | unknown | Do not disable failures silently |
| format | TODO | yes | yes | unknown | Repo-specific formatter required |
| dependency scan | TODO | no | yes | unknown | Bot config is not a scan by itself |
| secret scan | TODO | yes | yes | unknown | Use platform or local scanner |
| release build | TODO | no | yes | unknown | Artifact command required |
| SBOM | TODO | no | release-dependent | unknown | Toolchain-specific |
| provenance | TODO | no | release-dependent | unknown | SLSA target required |
EOF

 write_file "docs/oss/DEPENDENCY_POLICY.md" <<'EOF'
# Dependency policy

- Keep dependencies intentional.
- Keep versions reproducible.
- Avoid unreviewed supply-chain changes.
- Separate security updates from feature updates when needed.

Every dependency change should state package name, current version, target version, direct/transitive status, reason, advisory link if applicable, lockfile impact and validation run.
EOF

 write_file "docs/oss/SUPPLY_CHAIN_POLICY.md" <<'EOF'
# Supply chain policy

This policy covers dependency intake, CI execution, release artifact generation, SBOM, provenance and artifact distribution.

Minimum expectations:

- Dependencies are updated through a reviewed process.
- CI permissions are least-privilege.
- Release artifacts are produced by documented commands.
- SBOM and provenance targets are documented before public release.
- Secrets are delivered through platform secret stores, never source files.
EOF

 write_file "docs/oss/SBOM_POLICY.md" <<'EOF'
# SBOM policy

SBOM generation is toolchain-specific. Do not claim SBOM coverage until a real command has been selected and run.

Decisions to make:

- SBOM format: SPDX, CycloneDX or both
- generation point: build, release or package publish
- artifact storage location
- signing/attestation expectation
- direct vs transitive dependency scope
EOF

 write_file "docs/oss/PROVENANCE_POLICY.md" <<'EOF'
# Provenance policy

Provenance describes how an artifact was built and from which inputs.

Questions to answer:

- Which artifact needs provenance?
- Which workflow produces it?
- Is provenance generated automatically?
- Is provenance stored next to the artifact?
- Is provenance verified by consumers?

Do not claim SLSA compliance unless selected level and required controls are validated.
EOF

 write_file "docs/oss/HOSTING_PLATFORM_SETTINGS.md" <<'EOF'
# Hosting platform settings

Some controls cannot be enforced by repository files alone.

## GitHub settings to review

- branch protection or rulesets
- required reviews
- required status checks
- secret scanning
- push protection
- Dependabot alerts
- Dependabot security updates
- default workflow permissions
- allowed actions policy
- environments and deployment protection rules

## GitLab settings to review

- protected branches
- merge request approvals
- required pipelines
- secret variables
- push rules
- dependency/security scanning availability
- protected environments
EOF

 write_file "docs/oss/SECURITY_RESPONSE_PROCESS.md" <<'EOF'
# Security response process

Security reports should use a private channel. Public issues should not be used for sensitive vulnerability details.

Triage fields:

- reporter contact
- affected version or commit
- impact summary
- reproduction steps
- workaround
- patch owner
- disclosure timeline
EOF

 write_file "docs/oss/RELEASE_PROCESS.md" <<'EOF'
# Release process

Required before release:

- changelog updated
- version selected
- release tag policy followed
- build/test/lint/security validation complete
- dependency review complete
- license review complete
- security disclosure channel active
- artifact publishing owner confirmed
- rollback/deprecation notes prepared if needed
EOF

 write_file "docs/oss/GOVERNANCE_MODEL.md" <<'EOF'
# Governance model

Suggested roles:

- Owner: final responsibility for repository direction and release approval
- Maintainer: reviews and merges changes
- Security contact: handles private vulnerability reports
- Release owner: prepares and verifies releases

Architecture, compatibility, security, license and release decisions should be documented in issues, PRs, ADRs or release notes.
EOF

 write_file "docs/oss/MAINTAINER_HANDOFF.md" <<'EOF'
# Maintainer handoff

Checklist:

- [ ] Maintainers list is current
- [ ] Release process documented
- [ ] Security channel has backup owner
- [ ] Package registry access documented outside repository secrets
- [ ] CI secrets ownership documented
- [ ] Emergency rollback process documented
EOF

 write_file "docs/oss/RUNTIME_OPERATIONS_REVIEW.md" <<'EOF'
# Runtime operations review

Applies only if the repository has a service, worker, CLI job, scheduler, batch job, UI app or deployment runtime.

Review:

- runtime surfaces
- config and secrets
- health/readiness endpoints
- metrics/logging/tracing
- graceful shutdown
- retry/backoff/idempotency
- deployment topology
- rollback process
EOF

 write_file "docs/oss/AI_TOOLING_POLICY.md" <<'EOF'
# AI tooling policy

AI tools may be used for planning, review, documentation and code assistance, but generated output must be reviewed like any other contribution.

Not allowed by default:

- personal .cursor workspace state
- local Claude session files
- assistant scratch output
- generated zip/output/workspace directories
- private prompts containing secrets or credentials
EOF

 write_file "docs/oss/OPEN_SOURCE_RELEASE_GATE.md" <<'EOF'
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
EOF

 write_file "docs/oss/REUSE_SPDX_POLICY.md" <<'EOF'
# REUSE and SPDX policy

SPDX identifiers should be used for license references where possible.

REUSE compliance requires consistent licensing information across files. Do not add broad wildcard metadata unless repository ownership and third-party file boundaries are understood.
EOF

 write_file "docs/oss/CONTRIBUTOR_EXPERIENCE.md" <<'EOF'
# Contributor experience

A contributor should be able to answer:

- What does the project do?
- What is in scope?
- How is the project installed?
- How are tests run?
- What validation is expected before PR/MR?
- How are security issues reported?
- What kind of contributions are not accepted?
EOF
}

write_platform_templates() {
 if [ "$CREATE_GITHUB" = "1" ]; then
 write_file ".github/pull_request_template.md" <<'EOF'
## Summary

Describe the change and why it is needed.

## Scope

- [ ] code
- [ ] tests
- [ ] docs
- [ ] config/schema/API
- [ ] CI/release
- [ ] security
- [ ] other

## Validation

Commands run:

```text
TODO
```

Commands not run and why:

```text
TODO
```

## Risk

Describe compatibility, security, operational or migration risk.
EOF

 write_file ".github/ISSUE_TEMPLATE/bug_report.md" <<'EOF'
---
name: Bug report
about: Report a reproducible problem
title: ''
labels: bug
assignees: ''
---

## What happened?

## Expected behavior

## Steps to reproduce

## Environment

## Logs or screenshots

Redact secrets before posting.
EOF

 write_file ".github/ISSUE_TEMPLATE/feature_request.md" <<'EOF'
---
name: Feature request
about: Propose a scoped improvement
title: ''
labels: enhancement
assignees: ''
---

## Problem

## Proposed solution

## Alternatives considered

## Acceptance criteria

## Non-goals
EOF

 if [ -n "$CODEOWNER" ]; then
 write_file ".github/CODEOWNERS" <<EOF
* $CODEOWNER
EOF
 fi

 if [ "$SCORECARD" = "1" ]; then
 write_file ".github/workflows/scorecard.yml" <<'EOF'
name: OpenSSF Scorecard

on:
 branch_protection_rule:
 schedule:
 - cron: '20 3 * * 1'
 workflow_dispatch:

permissions:
 contents: read
 security-events: write
 id-token: write

jobs:
 scorecard:
 runs-on: ubuntu-latest
 steps:
 - name: Checkout
 uses: actions/checkout@v4
 with:
 persist-credentials: false
 - name: Run Scorecard
 uses: ossf/scorecard-action@.4.0
 with:
 results_file: results.sarif
 results_format: sarif
 publish_results: true
 - name: Upload SARIF
 uses: github/codeql-action/upload-sarif@
 with:
 sarif_file: results.sarif
EOF
 fi
 fi

 if [ "$CREATE_GITLAB" = "1" ]; then
 write_file ".gitlab/issue_templates/Bug.md" <<'EOF'
## What happened?

## Expected behavior

## Steps to reproduce

## Environment

## Logs or screenshots

Redact secrets before posting.
EOF
 write_file ".gitlab/issue_templates/Feature.md" <<'EOF'
## Problem

## Proposed solution

## Alternatives considered

## Acceptance criteria

## Non-goals
EOF
 write_file ".gitlab/merge_request_templates/Default.md" <<'EOF'
## Summary

## Scope

- [ ] code
- [ ] tests
- [ ] docs
- [ ] config/schema/API
- [ ] CI/release
- [ ] security

## Validation

Commands run:

```text
TODO
```

Commands not run and why:

```text
TODO
```

## Risk
EOF
 fi
}

detect_dependabot_ecosystems() {
 out="$REPORT_DIR/dependabot_updates.tmp"
 : > "$out"
 [ -f package.json ] && printf ' - package-ecosystem: "npm"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"
 [ -f go.mod ] && printf ' - package-ecosystem: "gomod"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"
 if [ -f pyproject.toml ] || [ -f requirements.txt ]; then printf ' - package-ecosystem: "pip"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"; fi
 [ -f Cargo.toml ] && printf ' - package-ecosystem: "cargo"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"
 [ -f pom.xml ] && printf ' - package-ecosystem: "maven"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"
 [ -f Gemfile ] && printf ' - package-ecosystem: "bundler"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"
 [ -f composer.json ] && printf ' - package-ecosystem: "composer"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"
 if [ -f Dockerfile ] || [ -f Containerfile ]; then printf ' - package-ecosystem: "docker"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"; fi
 if [ -d .github/workflows ] || [ "$SCORECARD" = "1" ]; then printf ' - package-ecosystem: "github-actions"\n directory: "/"\n schedule:\n interval: "weekly"\n' >> "$out"; fi
}

write_dependency_bot() {
 mode="$DEPENDENCY_BOT"
 if [ "$mode" = "auto" ]; then
 if [ "$CREATE_GITHUB" = "1" ]; then
 mode="dependabot"
 else
 mode="off"
 fi
 fi

 if [ "$mode" = "off" ]; then
 suggest medium dependency-management "Dependency bot disabled" "Document the manual dependency update and vulnerability triage process." "OpenSSF Best Practices"
 return 0
 fi

 if [ "$mode" = "renovate" ]; then
 write_file "renovate.json" <<'EOF'
{
 "$schema": "https://docs.renovatebot.com/renovate-schema.json",
 "extends": ["config:recommended"],
 "dependencyDashboard": true,
 "prConcurrentLimit": 5,
 "prHourlyLimit": 2,
 "labels": ["dependencies"],
 "semanticCommits": "enabled"
}
EOF
 return 0
 fi

 if [ "$mode" = "dependabot" ]; then
 detect_dependabot_ecosystems
 if [ ! -s "$REPORT_DIR/dependabot_updates.tmp" ]; then
 suggest medium dependency-management "No Dependabot ecosystems detected" "Add .github/dependabot.yml manually after the package ecosystems are confirmed." "Dependabot"
 return 0
 fi
 {
 echo "version: 2"
 echo "updates:"
 cat "$REPORT_DIR/dependabot_updates.tmp"
 } > "$REPORT_DIR/dependabot.yml.generated"
 write_file ".github/dependabot.yml" < "$REPORT_DIR/dependabot.yml.generated"
 fi
}

write_reuse_samples() {
 [ "$REUSE_SAMPLES" = "1" ] || return 0
 write_file "docs/oss/reuse/REUSE.toml.sample" <<'EOF'
# Inactive sample only.
# Do not copy this as active REUSE metadata before reviewing ownership and third-party boundaries.

version = 1

# [[annotations]]
# path = ["docs/**"]
# precedence = "aggregate"
# SPDX-FileCopyrightText = "YEAR OWNER"
# SPDX-License-Identifier = "MIT"
EOF
 write_file "docs/oss/reuse/LICENSES_README.sample.md" <<'EOF'
# LICENSES directory sample

REUSE often expects license texts under LICENSES/ using SPDX identifiers.

Do not create active REUSE metadata until file-level ownership and third-party boundaries are reviewed.
EOF
}

write_severity_summary() {
 {
 echo "# Suggestion severity summary"
 echo ""
 for sev in critical high medium low info; do
 count=$(grep -c "^### \[$sev\]" "$SUGGESTIONS" 2>/dev/null || true)
 echo "- $sev: $count"
 done
 } > "$SEVERITY_SUMMARY"
}

snapshot_status() {
 label="$1"
 status="$2"
 notes="$3"
 printf '| %s | %s | %s |\n' "$label" "$status" "$notes"
}

write_snapshot() {
 l0="partial"
 l1="partial"
 l2="partial"
 l3="partial"
 l4="blocked"
 l5="partial"
 l6="partial"

 [ -f .gitignore ] && [ -f .gitattributes ] && [ -f .editorconfig ] && l0="ready_for_manual_review"
 [ -f README.md ] && [ -f SECURITY.md ] && [ -f CONTRIBUTING.md ] && [ -f CODE_OF_CONDUCT.md ] && l1="generated_needs_review"
 if [ -f .github/pull_request_template.md ] || [ -f .gitlab/merge_request_templates/Default.md ]; then l2="generated_needs_review"; fi
 [ -f GOVERNANCE.md ] && [ -f MAINTAINERS.md ] && l3="generated_needs_review"
 [ -f docs/oss/VALIDATION_MATRIX.md ] && l4="blocked_until_commands_are_filled"
 [ -f docs/oss/RELEASE_PROCESS.md ] && l5="generated_needs_review"
 [ -f docs/oss/SUPPLY_CHAIN_POLICY.md ] && [ -f docs/oss/SBOM_POLICY.md ] && [ -f docs/oss/PROVENANCE_POLICY.md ] && l6="generated_needs_review"

 {
 echo "# OSS readiness snapshot"
 echo ""
 echo "This is not certification. It is a script-generated maturity snapshot."
 echo ""
 echo "| Level | Status | Notes |"
 echo "|---|---|---|"
 snapshot_status "L0 Repo hygiene baseline" "$l0" "Review ignored files, secrets and local artifacts"
 snapshot_status "L1 Community profile baseline" "$l1" "Root community docs may still contain TODO values"
 snapshot_status "L2 Contributor-ready" "$l2" "Validation and review workflow need project-specific commands"
 snapshot_status "L3 Maintainer-ready" "$l3" "Owners/backups must be real people or teams"
 snapshot_status "L4 Validation-ready" "$l4" "Build/test/lint/security commands must be filled and run"
 snapshot_status "L5 Release-ready" "$l5" "Release process needs real artifact/package commands"
 snapshot_status "L6 Security/supply-chain-ready" "$l6" "Platform settings and supply-chain controls need manual evidence"
 } > "$SNAPSHOT"
}

write_reports() {
 write_severity_summary
 write_snapshot
 {
 echo "# OSS readiness run summary"
 echo ""
 echo "- target repository: $TARGET_ABS"
 echo "- project: $PROJECT_NAME"
 echo "- generated at: $RUN_ID"
 echo "- audit-only: $AUDIT_ONLY"
 echo "- dry-run: $DRY_RUN"
 echo "- overwrite: $OVERWRITE"
 echo "- dependency bot: $DEPENDENCY_BOT"
 echo "- github templates: $CREATE_GITHUB"
 echo "- gitlab templates: $CREATE_GITLAB"
 echo "- scorecard workflow requested: $SCORECARD"
 echo "- reuse samples requested: $REUSE_SAMPLES"
 echo ""
 echo "## Report files"
 echo ""
 echo "- repo findings: $FINDINGS"
 echo "- toolchain inventory: $TOOLCHAIN"
 echo "- suggestions: $SUGGESTIONS"
 echo "- severity summary: $SEVERITY_SUMMARY"
 echo "- maturity snapshot: $SNAPSHOT"
 echo ""
 echo "## Created files"
 if [ -s "$CREATED" ]; then sed 's/^/- /' "$CREATED"; else echo "- none"; fi
 echo ""
 echo "## Updated files"
 if [ -s "$UPDATED" ]; then sed 's/^/- /' "$UPDATED"; else echo "- none"; fi
 echo ""
 echo "## Skipped files"
 if [ -s "$SKIPPED" ]; then sed 's/^/- /' "$SKIPPED"; else echo "- none"; fi
 echo ""
 echo "## Planned files"
 if [ -s "$PLANNED" ]; then sed 's/^/- /' "$PLANNED"; else echo "- none"; fi
 echo ""
 echo "## Warnings"
 if [ -s "$WARNINGS" ]; then sed 's/^/- /' "$WARNINGS"; else echo "- none"; fi
 echo ""
 echo "## Suggestions"
 if [ -s "$SUGGESTIONS" ]; then cat "$SUGGESTIONS"; else echo "- none"; fi
 echo ""
 echo "## Validation truth"
 echo ""
 echo "This script did not run repository build, test, lint, security scan, release build, deployment or platform validation."
 } > "$SUMMARY"
}

print_digest() {
 say ""
 say "suggestions:"
 if [ -s "$SUGGESTIONS" ]; then
 grep '^### ' "$SUGGESTIONS" | sed 's/^### /- /' | sed -n '1,5p'
 total=$(grep -c '^### ' "$SUGGESTIONS" 2>/dev/null || true)
 if [ "$total" -gt 5 ] 2>/dev/null; then
 say "- ... $total total suggestions. See: $SUGGESTIONS"
 else
 say "full suggestions: $SUGGESTIONS"
 fi
 else
 say "- none"
 fi
 say ""
 say "run summary: $SUMMARY"
}

run_preflight
write_findings_and_toolchain
collect_suggestions

if [ "$AUDIT_ONLY" != "1" ]; then
 write_root_files
 write_oss_docs
 write_platform_templates
 write_dependency_bot
 write_reuse_samples
else
 say "audit-only: repository files will not be written"
fi

write_reports
print_digest
say "==> Done"
