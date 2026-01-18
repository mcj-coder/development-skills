---
name: architecture-testing
description: Use when user mentions architectural boundaries, layering, dependency rules, project structure constraints, or asks to define/review/enforce architecture. For new apps, check if production quality/best practices/specific pattern requested.
metadata:
  type: Implementation
  priority: P1
---

# Architecture Testing

## Overview

Enforce architectural boundaries with automated tests. Prevents coupling that causes maintenance debt.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- User mentions architecture, boundaries, layers, dependency rules
- Creating production-quality application
- **Opt-out offered:** New apps without production/best-practice/pattern request

## Detection and Deference

Before creating architecture tests, check for existing patterns:

### Existing Tests Detection

| Pattern           | Detection Command                           | If Found             |
| ----------------- | ------------------------------------------- | -------------------- |
| .NET ArchTests    | `find . -name "*.ArchitectureTests.csproj"` | Enhance existing     |
| NetArchTest refs  | `grep -r "NetArchTest" *.csproj`            | Use existing project |
| ArchUnit (Java)   | `grep -r "archunit" pom.xml build.gradle`   | Use existing tests   |
| docs/architecture | `test -f docs/architecture-overview.md`     | Reference existing   |

### Deference Rules

When existing architecture tests are detected:

1. **Existing test project:** Enhance with additional rules, do not create new project.
2. **Existing architecture doc:** Update existing doc, do not create duplicate.
3. **Partial coverage:** Add tests for uncovered boundaries only.

Only create new architecture test project when detection finds nothing.

## Decision Capture

Architecture decisions must be captured in the target repository:

1. **Architecture ADR:** Create `docs/decisions/NNNN-architecture-pattern.md`
2. **Architecture Overview:** Update `docs/architecture-overview.md`
3. **Test Project README:** Document which boundaries are tested

### Architecture ADR Template

```markdown
# ADR-NNNN: Architecture Pattern Selection

## Status

Accepted

## Context

Project needs defined architectural boundaries.

## Decision

Use [Clean Architecture / Hexagonal / Layered] pattern.

## Rationale

- [Why this pattern fits the project]
- [Trade-offs considered]

## Consequences

- Architecture tests enforce: [list of rules]
- Violations fail the build
```

This ensures future developers understand the architectural constraints.

## Core Workflow

1. **Opt-out check:** New app without production quality request? Offer opt-out explicitly
2. **Pattern selection:** Clean, Hexagonal, Onion, Layered, or Modular Monolith
3. **Define boundaries:** Minimum 3 layers with explicit dependency rules
4. **Add enforcement:** NetArchTest (.NET), ArchUnit (Java), or custom
5. **CI integration:** Tests in pipeline, fail build on violations
6. **Document:** Update `docs/architecture-overview.md` (human-readable)
7. **Brownfield:** Permissive initial tests, tighten incrementally

See [Pattern Details](references/architecture-patterns.md) and [NetArchTest Examples](references/netarchtest-examples.md).

## Reference Templates

Use pre-built templates to accelerate architecture test setup:

| Pattern              | Template                                                                                             | Use Case            |
| -------------------- | ---------------------------------------------------------------------------------------------------- | ------------------- |
| Clean Architecture   | [templates/clean-architecture-tests.cs.template](templates/clean-architecture-tests.cs.template)     | Domain-centric apps |
| Layered Architecture | [templates/layered-architecture-tests.cs.template](templates/layered-architecture-tests.cs.template) | Traditional N-tier  |

### Using Templates

1. Copy template to `tests/{Project}.ArchitectureTests/`
2. Replace `{NAMESPACE}` with your root namespace
3. Add NetArchTest NuGet package
4. Adjust layer names to match your project structure
5. Run tests to verify boundaries

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
