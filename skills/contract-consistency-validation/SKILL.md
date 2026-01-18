---
name: contract-consistency-validation
description: Use when user modifies public interfaces/APIs, changes behavior of exposed methods, or requests compatibility checks. Validates breaking changes, requires user confirmation, enforces SemVer, and mandates ADR for pre-1.0 relaxations or v1+ exceptions.
metadata:
  type: Quality
  priority: P1
---

# Contract Consistency Validation

## Overview

Ensure contract changes are validated for compatibility and breaking changes are confirmed before implementation.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Modifying public interfaces, APIs, or shared contracts
- Changing behavior of exposed methods (null handling, error codes)
- Preparing releases with interface changes
- Modifying method signatures, return types, or error handling

## Core Workflow

1. **Detect contract change** (interface, behavior, schema modification)
2. **Classify change type:**
   - **Additive:** New optional fields/endpoints (Minor bump)
   - **Breaking:** Removed fields, behavior changes, signature changes (Major bump)
   - **Deprecation:** Marking for future removal (Minor bump + documentation)
3. **For breaking changes:**
   - Flag explicitly and **halt**
   - Assess consumer impact
   - Present alternatives (versioning, deprecation, additive)
   - **Require explicit user confirmation**
4. **For pre-1.0 relaxation:** Require ADR documenting scope and consequences
5. **For v1+ exceptions:** Require justification, approvals, and rollback plan
6. **Update artifacts:** OpenAPI specs, schemas, CHANGELOG with migration guidance

See [Breaking Change Checklist](references/breaking-change-checklist.md) and [Contract Testing Strategies](references/contract-testing-strategies.md).

## Rationalizations Table

| Excuse                                 | Reality                                                 |
| -------------------------------------- | ------------------------------------------------------- |
| "Adding fields is always safe"         | Consumers with strict schemas reject unexpected fields  |
| "Product owner approved"               | Product approval does not override technical validation |
| "Pre-1.0 allows anything"              | Allowed, but requires ADR and documentation             |
| "Behavior improvement justifies break" | Better design does not make it non-breaking             |

## Red Flags - STOP

- "Adding fields is safe" (without validation)
- "Customer approved the change"
- "Pre-1.0 so anything goes"
- "Just need to ship this"

**All mean: Validate compatibility, require user confirmation.**
