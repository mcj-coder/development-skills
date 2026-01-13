# release-tagging-plan - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Ad-hoc Release Tagging

**Given** agent WITHOUT release-tagging-plan skill
**And** codebase has no versioning strategy
**When** user says: "We need to tag a release"
**Then** record baseline behaviour:

- Does agent assess release scope? (expected: NO - arbitrary version bump)
- Does agent follow semantic versioning? (expected: NO - inconsistent)
- Does agent document breaking changes? (expected: NO - version only)
- Does agent consider release cadence? (expected: NO - ad-hoc)
- Rationalizations observed: "Let's just bump the version", "1.0 sounds good"

### Test R2: Breaking Change Handling

**Given** agent WITHOUT release-tagging-plan skill
**And** codebase has breaking API changes
**When** user says: "Tag a new release with these changes"
**Then** record baseline behaviour:

- Does agent identify breaking changes? (expected: NO - treats all changes equally)
- Does agent bump major version? (expected: NO - likely minor or patch)
- Does agent document migration path? (expected: NO - just changelog)
- Rationalizations observed: "It's just a small change", "Minor version is fine"

### Test R3: Pre-release and Release Candidate Handling

**Given** agent WITHOUT release-tagging-plan skill
**And** feature ready for testing but not production
**When** user says: "Create a pre-release for testing"
**Then** record baseline behaviour:

- Does agent use proper pre-release format? (expected: NO - inconsistent)
- Does agent maintain pre-release lineage? (expected: NO - ad-hoc naming)
- Does agent plan promotion path? (expected: NO - manual process)
- Rationalizations observed: "Just add -beta", "We'll figure out the real version later"

### Test R4: Hotfix Versioning

**Given** agent WITHOUT release-tagging-plan skill
**And** critical bug in production release
**When** user says: "We need to hotfix version 2.3.1"
**Then** record baseline behaviour:

- Does agent maintain version lineage? (expected: NO - unclear increment)
- Does agent avoid conflicting with planned releases? (expected: NO - version collision risk)
- Does agent document hotfix scope? (expected: NO - just fix and tag)
- Rationalizations observed: "Just increment patch", "We'll sort versions later"

### Expected Baseline Failures Summary

- [ ] Agent doesn't follow semantic versioning consistently
- [ ] Agent doesn't identify breaking changes for major bumps
- [ ] Agent doesn't use proper pre-release identifiers
- [ ] Agent doesn't maintain version lineage for hotfixes
- [ ] Agent doesn't document release scope and changes
- [ ] Agent doesn't plan release cadence
- [ ] Agent doesn't consider downstream consumers

## GREEN Phase - WITH Skill

### Test G1: Semantic Version Assessment

**Given** agent WITH release-tagging-plan skill
**When** user says: "Plan a release tag for these changes: new feature X, bug fix Y, deprecation notice Z"
**Then** agent applies semantic versioning assessment:

1. **Change Classification:**
   - Breaking changes (API removals, incompatible changes) -> MAJOR
   - New features (backward compatible additions) -> MINOR
   - Bug fixes (backward compatible fixes) -> PATCH

2. **Agent determines highest impact:**
   - If any breaking change -> Major bump required
   - If new features but no breaking -> Minor bump
   - If only bug fixes -> Patch bump

3. **Agent documents rationale:**

```markdown
## Release Version Assessment: 2.4.0 -> 2.5.0

| Change Type | Items | Version Impact |
| ----------- | ----- | -------------- |
| Breaking    | None  | -              |
| Features    | X     | MINOR          |
| Fixes       | Y     | PATCH          |
| Deprecation | Z     | (notice only)  |

**Recommended Version:** 2.5.0 (MINOR bump for new feature)
**Rationale:** Feature X adds new API endpoint, no breaking changes
```

**And** agent provides completion evidence:

- [ ] All changes classified by type
- [ ] Highest impact change determines version bump
- [ ] Version follows semantic versioning (MAJOR.MINOR.PATCH)
- [ ] Rationale documented for version selection

### Test G2: Breaking Change Documentation

**Given** agent WITH release-tagging-plan skill
**And** release includes breaking changes
**When** user says: "Document the breaking changes for v3.0.0"
**Then** agent creates migration documentation:

```markdown
## Breaking Changes in v3.0.0

### Removed APIs

- `GET /api/v1/users/{id}/legacy` - Removed, use `/api/v2/users/{id}` instead
- `UserLegacyDto` class - Removed, migrate to `UserDto`

### Changed Behaviours

- `AuthService.Validate()` now throws `AuthException` instead of returning null
- Default timeout changed from 30s to 10s

### Migration Guide

1. Update API calls from v1 to v2 endpoints
2. Replace `UserLegacyDto` with `UserDto` (field mapping below)
3. Add try-catch blocks around `AuthService.Validate()` calls

### Deprecation Warnings

These were deprecated in v2.x and are now removed:

- Feature A (deprecated v2.1.0)
- Feature B (deprecated v2.3.0)
```

**And** agent provides completion evidence:

- [ ] All breaking changes enumerated
- [ ] Migration path documented for each breaking change
- [ ] Deprecated items linked to removal
- [ ] Consumer impact assessed

### Test G3: Pre-release Strategy

**Given** agent WITH release-tagging-plan skill
**And** feature ready for staged rollout
**When** user says: "Plan pre-release versions for feature X"
**Then** agent creates pre-release strategy:

```markdown
## Pre-release Plan: Feature X

### Version Lineage

| Phase   | Version       | Purpose               | Promotion Criteria       |
| ------- | ------------- | --------------------- | ------------------------ |
| Alpha   | 2.5.0-alpha.1 | Internal testing      | Core functionality works |
| Beta    | 2.5.0-beta.1  | External beta testers | No critical bugs         |
| RC      | 2.5.0-rc.1    | Release candidate     | All tests pass           |
| Release | 2.5.0         | Production            | RC stable for 1 week     |

### Naming Convention

- Alpha: `MAJOR.MINOR.PATCH-alpha.N` (internal only)
- Beta: `MAJOR.MINOR.PATCH-beta.N` (limited external)
- RC: `MAJOR.MINOR.PATCH-rc.N` (production candidate)

### Promotion Process

1. Alpha -> Beta: All unit tests pass, integration tests pass
2. Beta -> RC: No P1/P2 bugs, performance benchmarks met
3. RC -> Release: No bugs found in RC period, stakeholder approval
```

**And** agent provides completion evidence:

- [ ] Pre-release phases defined with clear purposes
- [ ] Version format follows semver pre-release spec
- [ ] Promotion criteria documented for each phase
- [ ] Rollback plan included if issues found

### Test G4: Hotfix Version Planning

**Given** agent WITH release-tagging-plan skill
**And** production issue requires hotfix to v2.3.1
**And** main branch is on v2.5.0-beta.1
**When** user says: "Plan hotfix versioning for critical bug"
**Then** agent creates hotfix version plan:

````markdown
## Hotfix Version Plan

### Current State

- Production: v2.3.1
- Main branch: v2.5.0-beta.1
- Bug severity: Critical (P1)

### Hotfix Version: v2.3.2

**Branching Strategy:**

1. Create hotfix branch from v2.3.1 tag
2. Apply fix on hotfix branch
3. Tag as v2.3.2
4. Cherry-pick fix to main branch
5. Document in both v2.3.2 and future v2.5.0 changelogs

### Version Lineage

```text
v2.3.0 -> v2.3.1 -> v2.3.2 (hotfix)
                \-> v2.4.0 -> v2.5.0-beta.1 (includes fix)
```
````

### Verification

- [ ] v2.3.2 only contains hotfix changes
- [ ] Fix included in main branch for v2.5.0
- [ ] No version number conflicts
- [ ] Changelog updated in both branches

**And** agent provides completion evidence:

- [ ] Hotfix version maintains lineage (patch increment)
- [ ] No version conflicts with planned releases
- [ ] Fix propagated to main branch
- [ ] Both release lines documented

### Test G5: Release Cadence Planning

**Given** agent WITH release-tagging-plan skill
**And** team wants predictable release schedule
**When** user says: "Establish a release cadence for our project"
**Then** agent creates release cadence plan:

```markdown
## Release Cadence Plan

### Recommended Cadence

| Release Type | Frequency | Version Impact | Examples           |
| ------------ | --------- | -------------- | ------------------ |
| Major        | Yearly    | MAJOR bump     | v3.0.0 -> v4.0.0   |
| Minor        | Monthly   | MINOR bump     | v3.1.0 -> v3.2.0   |
| Patch        | As needed | PATCH bump     | v3.1.1 -> v3.1.2   |
| Hotfix       | Emergency | PATCH bump     | Critical bugs only |

### Release Calendar

- **Major releases:** Q1 each year (January)
- **Minor releases:** First Monday of each month
- **Patch releases:** After accumulated bug fixes (max 2 weeks)

### Version Forecast

| Date       | Planned Version | Scope                      |
| ---------- | --------------- | -------------------------- |
| 2025-01-06 | v3.0.0          | Breaking changes, new arch |
| 2025-02-03 | v3.1.0          | Feature A, Feature B       |
| 2025-03-03 | v3.2.0          | Feature C                  |

### Deprecation Policy

- Deprecate in version N
- Remove in version N+2 (major) or after 6 months
- Document deprecation warnings with removal timeline
```

**And** agent provides completion evidence:

- [ ] Release cadence defined for each version type
- [ ] Calendar established with predictable dates
- [ ] Deprecation policy documented
- [ ] Version forecast created for planning

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Version Inflation

**Given** agent WITH release-tagging-plan skill
**And** user says: "Let's just call it v2.0 since it's a big release"
**When** changes don't include breaking changes
**Then** agent responds:

- Acknowledges release significance
- Explains semantic versioning principles
- Proposes appropriate version based on change types
- Suggests marketing version if different from technical version

**And** agent does NOT:

- Accept arbitrary version bumps
- Ignore semantic versioning rules
- Skip change classification

### Test P2: Resist Skipping Pre-releases

**Given** agent WITH release-tagging-plan skill
**And** user says: "Skip beta, ship directly to production"
**When** feature is complex or high-risk
**Then** agent responds:

- Acknowledges urgency
- Assesses risk of skipping pre-release
- Proposes accelerated but safe release path
- Documents risk acceptance if user insists

**And** agent does NOT:

- Automatically skip pre-release phases
- Ignore testing requirements
- Hide risk from stakeholders

### Test P3: Resist Version Collision

**Given** agent WITH release-tagging-plan skill
**And** user says: "Use v2.4.0 for this hotfix"
**When** v2.4.0 is already planned for different release
**Then** agent responds:

- Identifies version collision
- Explains version lineage importance
- Proposes alternative version number
- Ensures no downstream confusion

**And** agent does NOT:

- Reuse version numbers
- Create ambiguous version history
- Ignore planned version roadmap

## Integration Scenarios

### Test I1: Integration with Git Tagging

**Given** agent WITH release-tagging-plan skill
**When** version plan is approved
**Then** agent provides tagging commands:

```bash
# Create annotated tag with release notes
git tag -a v2.5.0 -m "Release v2.5.0

Features:
- Feature X: New API endpoint

Fixes:
- Bug Y: Resolved timeout issue

See CHANGELOG.md for full details"

# Push tag to remote
git push origin v2.5.0
```

**Evidence:**

- [ ] Tag follows version plan
- [ ] Tag message includes release summary
- [ ] Tag is annotated (not lightweight)
- [ ] Push command included

### Test I2: Integration with Changelog

**Given** agent WITH release-tagging-plan skill
**When** release is planned
**Then** agent generates changelog entry:

```markdown
## [2.5.0] - 2025-01-15

### Added

- Feature X: New API endpoint for user preferences

### Fixed

- Bug Y: Timeout issue in authentication flow

### Deprecated

- `LegacyEndpoint`: Will be removed in v3.0.0

### Security

- Updated dependency Z to address CVE-2025-1234
```

**Evidence:**

- [ ] Changelog follows Keep a Changelog format
- [ ] All changes categorized appropriately
- [ ] Version and date included
- [ ] Links to issues/PRs included

### Test I3: Integration with CI/CD

**Given** agent WITH release-tagging-plan skill
**When** release process is planned
**Then** agent includes CI/CD considerations:

- Tag triggers release pipeline
- Pre-release tags trigger staging deployment
- Release tags trigger production deployment
- Version propagates to build artifacts

**Evidence:**

- [ ] Pipeline trigger conditions documented
- [ ] Deployment targets mapped to version types
- [ ] Artifact versioning addressed

## Rationalizations Closure

### Test RC1: "Let's just bump the version"

**Given** agent WITH release-tagging-plan skill
**When** user or agent rationalizes: "Let's just bump the version"
**Then** agent responds:

- "What types of changes are included? Let me assess the appropriate bump."
- Applies change classification
- Determines correct semantic version

### Test RC2: "Nobody uses old versions anyway"

**Given** agent WITH release-tagging-plan skill
**When** user or agent rationalizes: "Nobody uses old versions anyway"
**Then** agent responds:

- "Let's verify consumer usage. Even if low, version lineage matters for debugging."
- Checks for downstream dependencies
- Maintains proper version history regardless

### Test RC3: "Pre-releases are too slow"

**Given** agent WITH release-tagging-plan skill
**When** user or agent rationalizes: "Pre-releases are too slow"
**Then** agent responds:

- "What's the risk profile of this release? We can accelerate safely."
- Proposes risk-based pre-release approach
- Documents risk acceptance if skipped

### Test RC4: "Marketing wants a big version number"

**Given** agent WITH release-tagging-plan skill
**When** user or agent rationalizes: "Marketing wants a big version number"
**Then** agent responds:

- "Technical and marketing versions can differ. Let's keep semver for technical."
- Proposes marketing version strategy
- Maintains semantic versioning for technical consumers

## Verification Assertions

Each GREEN test should verify:

- [ ] Semantic versioning rules followed (MAJOR.MINOR.PATCH)
- [ ] Changes classified by type (breaking, feature, fix)
- [ ] Breaking changes documented with migration guides
- [ ] Pre-release strategy follows semver spec
- [ ] Hotfix versions maintain proper lineage
- [ ] Version collision prevented
- [ ] Release cadence planned and documented
- [ ] Changelog generated in standard format
- [ ] Git tagging commands provided
- [ ] CI/CD integration considered
