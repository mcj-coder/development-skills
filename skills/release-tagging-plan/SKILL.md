---
name: release-tagging-plan
description: Use when planning release versions, creating tags, or establishing versioning strategies. Applies semantic versioning principles, manages pre-release workflows, handles hotfix lineage, and creates release cadence plans with proper changelog documentation.
---

# Release Tagging Plan

## Overview

Plan and execute release versioning using **semantic versioning principles** with
clear change classification, pre-release strategies, and documented release cadence.
Prevent version confusion and maintain traceable release history.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Planning a new release version
- Establishing versioning strategy for a project
- Handling breaking changes and major releases
- Creating pre-release (alpha/beta/RC) workflows
- Managing hotfix versions for production issues
- Setting up release cadence and calendar
- Documenting changelog entries

## Detection and Deference

Before creating new versioning strategy, check for existing patterns:

```bash
# Check for existing version configuration
ls package.json pyproject.toml *.csproj version.txt VERSION 2>/dev/null

# Check for existing changelog
ls CHANGELOG.md CHANGES.md HISTORY.md 2>/dev/null

# Check for existing release tags
git tag --list 'v*' | tail -10
```

**If existing versioning found:**

- Follow the established versioning pattern
- Maintain consistency with existing tags
- Don't introduce conflicting version schemes

**If no versioning found:**

- Establish semantic versioning as default
- Create CHANGELOG.md using Keep a Changelog format
- Document versioning conventions in README or CONTRIBUTING

## Core Workflow

1. **Classify changes** by type (breaking, feature, fix)
2. **Determine version bump** based on highest impact change
3. **Plan pre-release phases** if needed (alpha, beta, RC)
4. **Document changes** in changelog with proper categories
5. **Create git tag** with annotated release notes
6. **Update version references** in project files
7. **Plan downstream communication** for consumers

## Semantic Versioning Summary

```text
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]

Examples:
  1.0.0        - First stable release
  1.1.0        - New backward-compatible feature
  1.1.1        - Backward-compatible bug fix
  2.0.0        - Breaking change
  2.0.0-alpha.1 - Alpha pre-release
  2.0.0-beta.1  - Beta pre-release
  2.0.0-rc.1    - Release candidate
```

### Version Bump Rules

| Change Type            | Version Impact | Example        |
| ---------------------- | -------------- | -------------- |
| Breaking API change    | MAJOR          | 1.2.3 -> 2.0.0 |
| Removed functionality  | MAJOR          | 1.2.3 -> 2.0.0 |
| New feature (backward) | MINOR          | 1.2.3 -> 1.3.0 |
| Deprecation notice     | MINOR          | 1.2.3 -> 1.3.0 |
| Bug fix                | PATCH          | 1.2.3 -> 1.2.4 |
| Documentation only     | PATCH          | 1.2.3 -> 1.2.4 |
| Security fix           | PATCH (urgent) | 1.2.3 -> 1.2.4 |

### Pre-release Identifiers

| Phase | Format        | Purpose           |
| ----- | ------------- | ----------------- |
| Alpha | X.Y.Z-alpha.N | Internal testing  |
| Beta  | X.Y.Z-beta.N  | External testing  |
| RC    | X.Y.Z-rc.N    | Release candidate |

## Release Planning Template

When planning a release, document:

````markdown
## Release Plan: vX.Y.Z

### Change Summary

| Type     | Count | Items                |
| -------- | ----- | -------------------- |
| Breaking | 0     | -                    |
| Features | 2     | Feature A, Feature B |
| Fixes    | 3     | Bug X, Bug Y, Bug Z  |

### Version Decision

- Previous version: X.Y.Z
- Recommended version: X.Y+1.0
- Reason: New features, no breaking changes

### Pre-release Plan (if applicable)

- [ ] Alpha: Internal testing
- [ ] Beta: External testers
- [ ] RC: Production candidate
- [ ] Release: General availability

### Changelog Entry

[Draft changelog in Keep a Changelog format]

### Tag Command

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z - Summary"
```
````

## Hotfix Workflow

For production issues requiring immediate patches:

1. **Identify affected version** (e.g., v2.3.1 in production)
2. **Create hotfix branch** from release tag, not main
3. **Apply minimal fix** - no feature work in hotfixes
4. **Tag as patch increment** (v2.3.1 -> v2.3.2)
5. **Cherry-pick to main** - ensure fix in future releases
6. **Document in both** hotfix and future release changelogs

```bash
# Hotfix workflow
git checkout -b hotfix/2.3.2 v2.3.1
# ... apply fix ...
git tag -a v2.3.2 -m "Hotfix: Critical bug description"
git push origin hotfix/2.3.2 --tags

# Propagate to main
git checkout main
git cherry-pick <hotfix-commit>
```

## Red Flags - STOP

- "Let's just bump to v2.0 because it's a big release" (without breaking changes)
- "Skip pre-release, ship directly" (for complex features)
- "Use v2.4.0 for the hotfix" (when v2.4.0 is planned for features)
- "Nobody uses old versions anyway" (version history matters)
- "We'll figure out the version later" (plan before coding)

**All mean: Apply semantic versioning assessment first.**

## Changelog Format

Use [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added

- New features

### Changed

- Changes in existing functionality

### Deprecated

- Features to be removed in future versions

### Removed

- Features removed in this release

### Fixed

- Bug fixes

### Security

- Vulnerability fixes
```

## Git Tagging Best Practices

```bash
# Always use annotated tags for releases
git tag -a v1.2.3 -m "Release v1.2.3

Summary of this release.

See CHANGELOG.md for details."

# Sign tags if GPG is configured
git tag -s v1.2.3 -m "Signed release v1.2.3"

# Push tags to remote
git push origin v1.2.3

# Push all tags
git push origin --tags
```

## CI/CD Integration Points

- **Tag pattern triggers:** `v*` for releases, `v*-*` for pre-releases
- **Deployment mapping:** Pre-releases to staging, releases to production
- **Artifact versioning:** Embed version in build artifacts
- **Release notes:** Auto-generate from changelog on tag push

## Release Cadence Options

| Cadence       | Major       | Minor       | Patch     |
| ------------- | ----------- | ----------- | --------- |
| Time-based    | Yearly      | Monthly     | As needed |
| Feature-based | On breaking | On features | On fixes  |
| Continuous    | Rare        | Per sprint  | Per merge |

Choose based on:

- Consumer expectations (stability vs features)
- Team capacity (release overhead)
- Risk tolerance (testing requirements)

## Sample Tag Commands

### Creating Release Tags

```bash
# Standard release tag (annotated)
git tag -a v1.2.3 -m "Release v1.2.3

Summary: Bug fixes and performance improvements

See CHANGELOG.md for details."

# Pre-release tags
git tag -a v2.0.0-alpha.1 -m "Alpha 1 for v2.0.0 - Internal testing only"
git tag -a v2.0.0-beta.1 -m "Beta 1 for v2.0.0 - External testing"
git tag -a v2.0.0-rc.1 -m "Release candidate 1 for v2.0.0"

# Signed release tag (GPG)
git tag -s v1.2.3 -m "Signed release v1.2.3"

# Push single tag
git push origin v1.2.3

# Push all tags
git push origin --tags
```

### Listing and Managing Tags

```bash
# List all version tags
git tag --list 'v*'

# List with dates
git tag --list 'v*' --format='%(refname:short) - %(creatordate:short)'

# Show tag details
git show v1.2.3

# Delete local tag
git tag -d v1.2.3

# Delete remote tag
git push origin --delete v1.2.3

# Get latest tag
git describe --tags --abbrev=0
```

### Hotfix Tag Workflow

```bash
# Create hotfix branch from release tag
git checkout -b hotfix/1.2.4 v1.2.3

# Apply fix
git commit -m "fix: critical security vulnerability"

# Tag the hotfix
git tag -a v1.2.4 -m "Hotfix v1.2.4

Security fix for CVE-XXXX-YYYY
See CHANGELOG.md for details."

# Push branch and tag
git push origin hotfix/1.2.4
git push origin v1.2.4

# Merge back to main
git checkout main
git cherry-pick <hotfix-commit>
```

## Changelog Linkage Examples

### Linking Tags to Changelog Entries

```markdown
<!-- CHANGELOG.md -->

# Changelog

All notable changes to this project will be documented in this file.

## [1.2.3] - 2024-01-15

### Added

- New export feature (#123)
- Dark mode support (#145)

### Fixed

- Login timeout issue (#156)
- Memory leak in cache handler (#162)

### Security

- Updated dependencies for CVE-XXXX (#171)

[1.2.3]: https://github.com/org/repo/compare/v1.2.2...v1.2.3
[1.2.2]: https://github.com/org/repo/compare/v1.2.1...v1.2.2
```

### Auto-generating Release Notes

```bash
# Generate changelog from commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Generate with categories (requires conventional commits)
git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"- %s" | grep -E "^- (feat|fix|docs|chore|refactor):"

# Using GitHub CLI for release notes
gh release create v1.2.3 --generate-notes

# Create release with changelog excerpt
gh release create v1.2.3 --notes "$(cat <<EOF
## What's Changed

### New Features
- Added export functionality (#123)
- Dark mode support (#145)

### Bug Fixes
- Fixed login timeout (#156)

**Full Changelog**: https://github.com/org/repo/compare/v1.2.2...v1.2.3
EOF
)"
```

### CI/CD Changelog Automation

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - "v*"

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get previous tag
        id: prev_tag
        run: |
          PREV=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
          echo "tag=$PREV" >> $GITHUB_OUTPUT

      - name: Generate changelog
        id: changelog
        run: |
          if [ -n "${{ steps.prev_tag.outputs.tag }}" ]; then
            CHANGES=$(git log ${{ steps.prev_tag.outputs.tag }}..HEAD --pretty=format:"- %s")
          else
            CHANGES=$(git log --pretty=format:"- %s" -20)
          fi
          echo "changes<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGES" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          body: |
            ## Changes in ${{ github.ref_name }}

            ${{ steps.changelog.outputs.changes }}

            **Full Changelog**: https://github.com/${{ github.repository }}/compare/${{ steps.prev_tag.outputs.tag }}...${{ github.ref_name }}
```

### Changelog Entry Template

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added

- [Feature description] (#issue-number)

### Changed

- [Change description] (#issue-number)

### Deprecated

- [Deprecation notice] - will be removed in vX+1.0.0

### Removed

- [Removal description] - see migration guide

### Fixed

- [Bug fix description] (#issue-number)

### Security

- [Security fix description] (#issue-number, CVE-XXXX-YYYY)

[X.Y.Z]: https://github.com/org/repo/compare/vX.Y.Z-1...vX.Y.Z
```
