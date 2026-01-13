---
name: incremental-change-impact
description: Use when user proposes changes, refactoring, or feature additions; asks about impact, affected components, or what needs testing; or before making structural changes. Identifies blast radius and cascading effects.
---

# Incremental Change Impact

## Overview

Identify full impact scope **before** making changes. Trace dependencies, enumerate affected
components, and assess cascading effects. Prevents blind changes that break unrelated systems.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- User proposes changes, refactoring, or feature additions
- User asks "what will this affect?" or "what needs testing?"
- Before structural changes (renaming, moving, deleting)
- Before configuration changes (timeouts, thresholds, limits)
- When reviewing change proposals for impact

## Core Workflow

1. **Identify change type** (rename, add, modify, delete, config)
2. **Trace direct dependencies** (callers, imports, references)
3. **Trace indirect dependencies** (reflection, serialization, dynamic loading)
4. **Identify affected tests** (unit, integration, e2e)
5. **Check non-code impacts** (docs, configs, external APIs)
6. **Assess cascading effects** (timeouts, retries, error handling)
7. **Provide risk assessment** (breaking vs non-breaking, severity)
8. **Recommend verification approach**

See `references/dependency-analysis.md`, `references/impact-matrix.md`,
and `references/tooling.md` for detailed techniques.

## Quick Reference

| Change Type      | Typical Impact Areas                                  |
| ---------------- | ----------------------------------------------------- |
| Method rename    | Callers, tests, reflection, serialization, docs, APIs |
| Add caching      | Invalidation points, transactions, all consumers      |
| Config change    | Cascading timeouts, retries, health checks            |
| Schema change    | Data access, migrations, backward compatibility       |
| Delete component | All dependents, error handling, fallback paths        |

## Red Flags - STOP

- "It's just a rename/config change"
- "IDE/compiler will catch it"
- "Tests will tell us if it breaks"
- "Too urgent to analyze"
- "Already done, let's ship"

**All mean: Apply skill to identify full impact before proceeding.**

## Rationalizations Table

| Excuse                       | Reality                                                           |
| ---------------------------- | ----------------------------------------------------------------- |
| "It's just a simple rename"  | Dynamic usage, reflection, external APIs make renames risky.      |
| "IDE will catch all usages"  | IDE misses reflection, serialization, config files, docs.         |
| "Tests will fail if broken"  | Tests may not cover all paths. Identify impact before, not after. |
| "This is an internal change" | Internal changes cascade through timeouts, retries, monitoring.   |
| "Too urgent to analyze"      | 5-minute analysis prevents hours of production debugging.         |
| "Already done, just ship"    | Sunk cost fallacy. Identify impact before deployment.             |

## Evidence Checklist

- [ ] Change type identified explicitly
- [ ] All direct dependencies listed with file paths
- [ ] Indirect dependencies checked (reflection, serialization, configs)
- [ ] Affected tests identified by category (unit, integration, e2e)
- [ ] Non-code impacts included (docs, external APIs, configs)
- [ ] Cascading effects assessed if applicable
- [ ] Risk assessment provided (breaking/non-breaking, severity)
- [ ] Verification approach recommended
