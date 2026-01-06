---
name: walking-skeleton-delivery
description: Use when starting new system or migration requiring minimal end-to-end slice for architecture validation. Defines simplest E2E flow in BDD format, establishes deployment pipeline, and validates technical decisions before full build-out.
---

# Walking Skeleton Delivery

## Overview

Build the **simplest possible end-to-end slice** first. Prove architecture works before
investing in features. A walking skeleton is production-quality code (not throwaway)
that validates your technical decisions in days, not weeks.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Starting new system or microservice
- Major migration or rewrite
- Validating unfamiliar technology stack
- Building distributed system (multi-service)
- User asks to "prove the architecture" or "validate approach"

## Core Workflow

1. **Define skeleton goal** (what are we proving?)
2. **Define minimal E2E flow in BDD format** (Gherkin scenario)
3. **Define scope explicitly:**
   - IN: Minimal components for E2E (API, persistence, basic observability)
   - OUT: Business logic, auth, error handling (deferred)
4. **Implement simplest possible code** (no premature features)
5. **Create BDD acceptance test**
6. **Establish deployment pipeline**
7. **Deploy and verify E2E works**
8. **Document learnings, define next steps**

See `references/examples-by-pattern.md` for concrete examples.

## Skeleton Scope Template

**IN SCOPE (minimal):** HTTP endpoint, basic persistence, health check, deployment pipeline, BDD test

**OUT OF SCOPE (defer):** Complex business rules, authentication, comprehensive error handling, multiple states

## Red Flags - STOP

- "Need features first" / "Deployment later"
- "Architecture will emerge" / "Too late for skeleton"
- "This delays delivery" / "We'll figure it out"

**All mean: Apply walking skeleton before building features.**

See `references/pitfalls-and-scope-creep.md` for rationalizations table.
See `references/technology-spike-distinction.md` for spike vs skeleton guidance.
