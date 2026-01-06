---
name: architecture-testing
description: Use when user mentions architectural boundaries, layering, dependency rules, project structure constraints, or asks to define/review/enforce architecture. For new apps, check if production quality/best practices/specific pattern requested.
---

# Architecture Testing

## Overview

Enforce architectural boundaries with automated tests. Prevents coupling that causes maintenance debt.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- User mentions architecture, boundaries, layers, dependency rules
- Creating production-quality application
- **Opt-out offered:** New apps without production/best-practice/pattern request

## Core Workflow

1. **Opt-out check:** New app without production quality request? Offer opt-out explicitly
2. **Pattern selection:** Clean, Hexagonal, Onion, Layered, or Modular Monolith
3. **Define boundaries:** Minimum 3 layers with explicit dependency rules
4. **Add enforcement:** NetArchTest (.NET), ArchUnit (Java), or custom
5. **CI integration:** Tests in pipeline, fail build on violations
6. **Document:** Update `docs/architecture-overview.md` (human-readable)
7. **Brownfield:** Permissive initial tests, tighten incrementally

See [Pattern Details](references/architecture-patterns.md) and [NetArchTest Examples](references/netarchtest-examples.md).

## Rationalizations Table

| Excuse                            | Reality                                                        |
| --------------------------------- | -------------------------------------------------------------- |
| "Can add architecture later"      | Later never happens. 10 min now saves hours later.             |
| "Speed over architecture"         | Architecture prevents defects. Defects cost more time.         |
| "Demo doesn't need it"            | Demos become production. Start right or rewrite.               |
| "Too disruptive to existing code" | Use brownfield approach: permissive tests, tighten gradually.  |
| "Tech lead said skip it"          | Clarify cost with tech lead. They may not realize impact.      |
| "Working code ships"              | Shipping debt accumulates interest. Pay now or pay more later. |

## Red Flags - STOP

- "Can add architecture later"
- "Too simple for boundaries"
- "Would block the deploy" (without proposing brownfield)
- "Tech lead said skip it" (without clarifying cost)

**All mean: Apply brownfield approach or document explicit opt-out in `docs/exclusions.md`.**
