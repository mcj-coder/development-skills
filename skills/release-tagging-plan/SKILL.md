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
