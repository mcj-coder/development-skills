---
name: library-extraction-stabilisation
description: Use when shared code is used by 3+ components, user asks about extracting library, or code is copied across services. Ensures stability, ownership, versioning, and governance before extraction.
metadata:
  type: Implementation
  priority: P3
---

# Library Extraction Stabilisation

## Overview

Extract shared code into libraries **only after proven stability** and with clear
ownership. Prevent premature abstraction, version chaos, and orphaned libraries.

**REQUIRED:** superpowers:brainstorming (before extraction decision)

## When to Use

- Shared functionality used by 3+ components
- User asks "should I extract this as a library?"
- Code duplication across services/components
- User proposes creating shared package/library
- Existing internal library needs stabilization

## Core Workflow

1. **Count consumers** (need 3+ for extraction)
2. **Assess stability** (change frequency over 3 months)
3. **Define ownership** (team with capacity)
4. **Define versioning** (SemVer, breaking change policy)
5. **Plan migration** (incremental, rollback strategy)
6. **If not ready:** Document alternative and re-evaluation criteria

## Extraction Readiness Criteria

| Criterion | Threshold                     | Action if Not Met     |
| --------- | ----------------------------- | --------------------- |
| Consumers | 3+                            | Wait for 3rd consumer |
| Stability | <2 changes/month for 2 months | Defer until stable    |
| Ownership | Team identified with capacity | Identify owner first  |
| Support   | SLA or best-effort defined    | Define support model  |

## Red Flags - STOP

- "Already used in 2 places, should extract"
- "Keep changing in multiple places, must extract"
- "DRY principle requires extraction"
- "Library will force stability"

**All mean:** Apply readiness assessment before proceeding.

## Rationalizations Table

| Excuse                              | Reality                                                  |
| ----------------------------------- | -------------------------------------------------------- |
| "DRY says extract now"              | DRY applies after proven need. 2 uses isn't proof.       |
| "Easier to maintain in one place"   | Only if stable. Volatile library causes upgrade fatigue. |
| "Library will force stability"      | Backwards. Stability enables libraries.                  |
| "Tech lead said create library"     | Clarify. Share stability/ownership concerns.             |
| "Best practice is shared libraries" | Microservices tolerate duplication over coupling.        |

## Reference Documents

- [Governance Models](references/governance-models.md) - Ownership and support models
- [Versioning Strategy](references/versioning-strategy.md) - SemVer, breaking changes
- [Migration Planning](references/migration-planning.md) - Consumer migration guide

## Decision Matrix Template

Use this matrix to evaluate whether extraction is appropriate:

```markdown
# Library Extraction Decision: [Component Name]

**Date**: YYYY-MM-DD
**Evaluator**: [Name]

## Readiness Assessment

| Criterion                        | Current State              | Threshold  | Pass? |
| -------------------------------- | -------------------------- | ---------- | ----- |
| Consumer count                   | [N]                        | ≥ 3        | ☐     |
| Change frequency (last 3 months) | [N/month]                  | < 2/month  | ☐     |
| Defined owner                    | [Team/None]                | Named team | ☐     |
| Support model                    | [SLA/Best-effort/None]     | Defined    | ☐     |
| API stability                    | [Stable/Evolving/Volatile] | Stable     | ☐     |
| Test coverage                    | [N]%                       | ≥ 80%      | ☐     |

## Consumer Analysis

| Consumer  | Integration Type  | Impact if Breaking Change |
| --------- | ----------------- | ------------------------- |
| Service A | Direct dependency | High - core functionality |
| Service B | Transitive        | Medium - feature subset   |
| Service C | Direct dependency | High - multiple endpoints |

## Risk Assessment

| Risk                              | Likelihood | Impact  | Mitigation                              |
| --------------------------------- | ---------- | ------- | --------------------------------------- |
| Breaking change during extraction | [H/M/L]    | [H/M/L] | Semantic versioning, deprecation period |
| Ownership vacuum                  | [H/M/L]    | [H/M/L] | Assign team before extraction           |
| Version sprawl                    | [H/M/L]    | [H/M/L] | Enforce upgrade policy                  |

## Decision

☐ **Proceed with extraction** - All criteria met
☐ **Defer extraction** - Criteria not met, re-evaluate on [date]
☐ **Alternative approach** - [Describe: shared module, copy, etc.]

**Rationale**: [Brief explanation of decision]
```

## Migration Plan Checklist

### Phase 1: Preparation (Week 1)

- [ ] Document current API surface
- [ ] Identify all consumers (direct and transitive)
- [ ] Establish version numbering scheme (SemVer)
- [ ] Create library repository with CI/CD
- [ ] Set up package publishing (NuGet, npm, PyPI, etc.)
- [ ] Document breaking change policy
- [ ] Assign ownership team with on-call rotation

### Phase 2: Initial Release (Week 2)

- [ ] Extract code into library repository
- [ ] Ensure test coverage ≥ 80%
- [ ] Create API documentation
- [ ] Publish v1.0.0 (or appropriate version)
- [ ] Migrate first consumer (lowest risk)
- [ ] Verify functionality in staging environment
- [ ] Document migration steps for other consumers

### Phase 3: Consumer Migration (Weeks 3-4)

- [ ] Notify all consumers of migration timeline
- [ ] Provide migration guide with examples
- [ ] Support each consumer during migration
- [ ] Track migration progress:

| Consumer  | Status                                 | Migration Date | Issues |
| --------- | -------------------------------------- | -------------- | ------ |
| Service A | ☐ Pending / ☐ In Progress / ☐ Complete |                |        |
| Service B | ☐ Pending / ☐ In Progress / ☐ Complete |                |        |
| Service C | ☐ Pending / ☐ In Progress / ☐ Complete |                |        |

### Phase 4: Stabilisation (Week 5+)

- [ ] Remove original code from source locations
- [ ] Monitor library usage metrics
- [ ] Address any post-migration issues
- [ ] Establish regular release cadence
- [ ] Document lessons learned

### Rollback Plan

If migration fails for any consumer:

1. Consumer reverts to previous version (before library dependency)
2. Library team investigates and patches
3. Consumer re-attempts migration with patched version
4. If repeated failures: consider consumer-specific fork or delay

### Success Criteria

- [ ] All consumers successfully migrated
- [ ] No production incidents attributed to library
- [ ] Library version published and consumable
- [ ] Original code removed from source repositories
- [ ] Documentation complete and accessible
