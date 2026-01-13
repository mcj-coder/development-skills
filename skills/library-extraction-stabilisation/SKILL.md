---
name: library-extraction-stabilisation
description: Use when shared code is used by 3+ components, user asks about extracting library, or code is copied across services. Ensures stability, ownership, versioning, and governance before extraction.
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
