# Pitfalls and Scope Creep Prevention

## Rationalizations Table

| Excuse                           | Reality                                                                                     |
| -------------------------------- | ------------------------------------------------------------------------------------------- |
| "Need features to show progress" | Walking skeleton IS progress - proves architecture in days, prevents weeks of rework.       |
| "Deployment can come later"      | Deployment problems discovered late cause delays. Establish pipeline in skeleton.           |
| "Architecture will emerge"       | Architecture emerges from E2E constraints. Skeleton makes architecture explicit early.      |
| "Too late for walking skeleton"  | Never too late. Even mid-project, E2E test validates and documents architecture.            |
| "This delays feature work"       | Skeleton takes 2-4 days and prevents weeks of rework. Net acceleration, not delay.          |
| "We'll learn while building"     | Learn with minimal skeleton, not full implementation. Fail fast, pivot early.               |
| "CTO chose technologies"         | Authority doesn't override validation. Prove technologies work before committing full team. |
| "Already have 3 services built"  | Sunk cost fallacy. E2E test NOW finds integration issues before building more.              |
| "Just need better integration"   | Integration problems often signal architectural gaps. Walking skeleton reveals them.        |
| "Team is experienced enough"     | Experience reduces risk but doesn't eliminate it. Skeleton is cheap insurance.              |

## Red Flags - STOP

If you hear (or think) these, **STOP and apply walking-skeleton-delivery**:

- "Need features first"
- "Deployment later"
- "Architecture will emerge"
- "Too late for skeleton"
- "This delays delivery"
- "We'll figure it out"
- "Just need to integrate"
- "Tech lead said to build X first"

**All of these mean: Apply walking-skeleton-delivery before building features.**

## Common Scope Creep Patterns

### Pattern 1: Feature Creep

**Symptom:** "While we're at it, let's add user authentication"

**Problem:** Authentication is a feature, not skeleton infrastructure.

**Fix:** Add to OUT OF SCOPE list. Skeleton proves architecture works, not features.

### Pattern 2: Perfection Creep

**Symptom:** "We should set up proper logging, monitoring, tracing"

**Problem:** "Proper" implies production-grade, skeleton needs minimal.

**Fix:** Basic structured logs and health check only. Full observability comes later.

### Pattern 3: Design Creep

**Symptom:** "Let's design the full domain model first"

**Problem:** Domain model is part of features, not skeleton validation.

**Fix:** Single entity (e.g., Order with minimal fields). Rich domain comes with features.

### Pattern 4: Scale Creep

**Symptom:** "Should we set up load balancing and auto-scaling?"

**Problem:** Scaling is optimization, not architecture validation.

**Fix:** Single instance deployment. Scale after architecture proven.

### Pattern 5: Integration Creep

**Symptom:** "We need to connect to the existing user service"

**Problem:** External dependencies add complexity to skeleton.

**Fix:** Mock external services. Prove internal architecture first.

## Skeleton Size Guidelines

### Right Size (Minimal Viable Skeleton)

- 1 HTTP endpoint (create) + 1 HTTP endpoint (read)
- 1 database table
- 1 health check endpoint
- 1 BDD acceptance test
- CI/CD pipeline (build -> test -> deploy)

### Too Small (Not a Skeleton)

- Only unit tests (no E2E)
- Only local execution (no deployment)
- Only happy path (no basic error handling)

### Too Big (Mini-MVP)

- Multiple entities and relationships
- Authentication and authorization
- Complex business rules
- Multiple deployment environments
- Performance optimization

## Prevention Checklist

Before adding anything to skeleton scope, ask:

- [ ] Does this prove the architecture works?
- [ ] Is this necessary for E2E flow?
- [ ] Can this be added as a feature later?
- [ ] Does the skeleton still fit in 2-4 days?

If any answer is "No" or "Yes" to item 3, add to OUT OF SCOPE.

## Documentation Convention

When skeleton is delivered, document in `docs/architecture-overview.md`:

```markdown
## Walking Skeleton

**Delivered:** {YYYY-MM-DD}
**Goal:** Validate {architecture pattern | technology choices | distributed communication}

### Minimal E2E Flow

{Gherkin scenario}

### Skeleton Scope

**Included:**

- {Component}: {Minimal functionality}
- Deployment pipeline: {CI/CD setup}
- Observability: {Logs, health check}

**Deferred:**

- {Feature 1}: {Why deferred}
- {Feature 2}: {Why deferred}

### Architecture Validated

- {Pattern} works end-to-end
- Deployment automation works
- {Technology} integrates as expected

### Learnings

- {Insight 1}
- {Pain point discovered}

### Next Steps

1. {Feature to build next}
2. {Technical debt to address}
```
