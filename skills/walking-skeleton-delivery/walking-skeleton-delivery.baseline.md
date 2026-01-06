# walking-skeleton-delivery - TDD Baseline Evidence

**Issue:** #89
**Date:** 2026-01-06
**Status:** Verified

## RED Phase (WITHOUT Skill)

### Pressure Scenario

- **Pressure:** Time ("want to show progress in sprint")
- **Request:** "Build a new microservice for order processing. Sprint review in 3 days."

### Baseline Behavior Observed

Agent WITHOUT skill jumped to building features:

- **Minimal E2E first:** NO - Started with domain models and endpoints
- **Deployment pipeline early:** NO - Deferred to "run locally for demo"
- **Architecture validation:** NO - Would discover issues late

### Verbatim Rationalizations

1. "We can always swap it later"
2. "For the demo, we'd show..." (optimizing for demo, not delivery)
3. "In-memory storage initially" (avoiding hard integration work)
4. Time pressure used as excuse to skip foundational work

### Feature-First Anti-Pattern Demonstrated

```text
Day 1: Domain Models
Day 2: Business Logic
Day 3: Polish/Demo
Deployment: "Later"
```

## GREEN Phase (WITH Skill)

### Same Pressure Scenario Applied

Agent WITH skill applied walking skeleton approach:

- **Skeleton goal defined:** YES - "Prove deployment, persistence, observability E2E"
- **BDD flow defined:** YES - Two Gherkin scenarios provided
- **Deployment pipeline Day 1:** YES - Explicit priority before features
- **Scope explicitly defined:** YES - IN/OUT scope clearly stated

### Walking Skeleton Approach Demonstrated

```text
Day 1: Pipeline + minimal deployable service
Day 2: E2E data flow working
Day 3: Validation + demo from deployed service
Deployment: DONE ON DAY 1
```

### Skill Compliance

| Requirement | Compliant | Evidence |
|-------------|-----------|----------|
| Skeleton goal defined | YES | What we're proving documented |
| BDD/Gherkin flow | YES | Two scenarios for E2E validation |
| Explicit scope (IN/OUT) | YES | Clear boundary set |
| Deployment Day 1 | YES | Pipeline prioritized first |
| Resisted feature pressure | YES | Deferred items, quantities, pricing |

## Verification Result

**PASSED** - Skill successfully changed agent behavior from feature-first to
skeleton-first approach under time pressure.
