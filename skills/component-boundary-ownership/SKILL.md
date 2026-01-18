---
name: component-boundary-ownership
description: Use when user decides repository organization, where functionality should live, or reviews component boundaries. Determines cross-component ownership and placement (macro), delegates intra-component file layout to scoped-colocation (micro).
metadata:
  type: Implementation
  priority: P2
---

# Component Boundary Ownership

## Overview

Determine macro-level repository organisation and component boundaries based on deployment
independence, team ownership, coupling analysis, and reuse patterns. Delegates micro-level
concerns (intra-component file layout) to scoped-colocation skill.

Ensure clear ownership and minimal coupling when organizing repositories. Determines macro
placement (which component owns what), delegates micro placement (file layout within
components) to scoped-colocation.

**REQUIRED:** superpowers:brainstorming, superpowers:verification-before-completion

## When to Use

- User decides repository organization or restructures codebase
- User asks where functionality should live (component placement decisions)
- User reviews or questions existing component boundaries
- New functionality spans multiple existing components
- Team ownership changes require boundary realignment
- Deployment independence needs evaluation for splitting/merging components

## Core Workflow

1. **Identify candidate boundaries** based on deployment independence, team ownership, coupling analysis, and reuse patterns
2. **Evaluate organization pattern:** Monorepo (workspaces), Polyrepo (separate repos), Modular Monolith (internal boundaries)
3. **Decide placement** aligned to ownership, deployment boundaries, and documentation grouping
4. **Document boundaries** in `docs/architecture/component-boundaries.md` with ownership matrix
5. **Delegate micro concerns** to scoped-colocation for intra-component file placement

## Boundary Decision Criteria

| Criterion  | Extract Boundary When                         |
| ---------- | --------------------------------------------- |
| Deployment | Components deploy independently               |
| Ownership  | Different teams own different parts           |
| Coupling   | High internal cohesion, low external coupling |
| Reuse      | Code shared by 3+ components                  |

## Well-Known Locations

Files with required positions: README.md (root), package.json (component root), .github/ (repo root), .gitignore (root).

See [Boundary Patterns](references/boundary-patterns.md) for detailed guidance.

## Rationalizations Table

| Excuse                    | Reality                                                           |
| ------------------------- | ----------------------------------------------------------------- |
| "Can reorganize later"    | Boundaries harder to add later. Establish early.                  |
| "Current structure works" | Missing boundaries couple components, slow changes.               |
| "Just need it working"    | Placement decision takes 5 minutes. Wrong placement creates debt. |

## Red Flags - STOP

- "Can reorganize later" / "Just put it in /src"
- "Current structure is fine" / "Split when we need to"

**All mean: Apply skill to evaluate boundaries properly.**
