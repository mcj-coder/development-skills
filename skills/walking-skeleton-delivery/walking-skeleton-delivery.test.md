# walking-skeleton-delivery - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Pressure - Build Everything

**Given** agent WITHOUT walking-skeleton-delivery skill
**And** pressure: time ("want to show progress in sprint")
**When** user says: "Build a new microservice for order processing"
**Then** record baseline behaviour:

- Does agent suggest minimal E2E first? (expected: NO - starts building features)
- Does agent establish deployment pipeline? (expected: NO - focuses on code)
- Does agent validate architecture early? (expected: NO - discovers issues late)
- Rationalizations observed: "Need features to show progress", "Deployment can come later"

### Test R2: Authority Pressure - Technology Uncertainty

**Given** agent WITHOUT walking-skeleton-delivery skill
**And** pressure: authority ("CTO wants to try gRPC and event sourcing")
**When** user says: "Build new service with gRPC and event sourcing"
**And** team has no experience with either technology
**Then** record baseline behaviour:

- Does agent propose technology spike first? (expected: NO - starts implementing)
- Does agent validate E2E flow? (expected: NO - focuses on components)
- Does agent defer commitment? (expected: NO - builds full implementation)
- Rationalizations observed: "CTO chose technologies", "Learn while building"

### Test R3: Sunk Cost - Late Architectural Discovery

**Given** agent WITHOUT walking-skeleton-delivery skill
**And** pressure: sunk cost ("already implemented 3 services")
**When** user says: "Having trouble integrating services, doesn't flow end-to-end"
**And** architectural issues discovered late
**Then** record baseline behaviour:

- Does agent identify E2E validation gap? (expected: NO - focuses on fixing integration)
- Does agent suggest E2E test? (expected: NO - patches individual services)
- Rationalizations observed: "Too late for walking skeleton", "Just need better integration"

### Expected Baseline Failures Summary

- [ ] Agent doesn't propose minimal E2E slice before full build-out
- [ ] Agent focuses on individual components instead of E2E flow
- [ ] Agent doesn't establish deployment pipeline early
- [ ] Agent discovers architectural issues late in implementation
- [ ] Agent builds features without validating architecture first
- [ ] Agent doesn't use BDD format to define acceptance criteria

## GREEN Phase - WITH Skill

### Test G1: Walking Skeleton for New Microservice

**Given** agent WITH walking-skeleton-delivery skill
**When** user says: "Build a new order processing microservice"
**Then** agent responds with skeleton proposal including:

- Walking skeleton goal (what we're proving)
- Minimal E2E flow in BDD/Gherkin format
- Explicit scope (IN and OUT of scope)
- Timeline estimate (2 days)

**And** agent implements:

- Minimal E2E flow only (no extra features)
- BDD acceptance test in Gherkin format
- Deployment pipeline (CI/CD)

**And** agent verifies:

- Skeleton deploys successfully
- Acceptance test passes in staging
- Health check responds

**And** agent provides completion evidence:

- [ ] Minimal E2E flow defined in BDD format
- [ ] Skeleton scope explicitly defined (in and out of scope)
- [ ] Simplest possible implementation (no premature features)
- [ ] BDD acceptance test created and passing
- [ ] Deployment pipeline established
- [ ] Deployed to staging and validated
- [ ] Health check and observability working
- [ ] Architecture proven before full build-out
- [ ] Next steps defined (feature backlog)

### Test G2: Walking Skeleton for Technology Validation

**Given** agent WITH walking-skeleton-delivery skill
**And** new technology choices: gRPC, event sourcing
**When** user says: "Build new service with gRPC and event sourcing"
**And** team has no experience with these technologies
**Then** agent responds with technology validation skeleton including:

- Technology validation goals (what we're proving works)
- Minimal E2E flow in BDD format
- Explicit scope (technology proof only)
- Timeline estimate (3 days, includes learning curve)

**And** agent implements:

- Minimal spike with both technologies
- E2E flow proving integration works

**And** agent documents:

- Learnings and pain points
- Recommendation (proceed or pivot)
- Alternative approaches if issues found

**And** agent provides completion evidence:

- [ ] Technology choices explicitly validated
- [ ] Minimal spike with both technologies
- [ ] E2E flow proves integration works
- [ ] Learnings and pain points documented
- [ ] Recommendation provided (proceed or pivot)
- [ ] Alternative approaches suggested
- [ ] Decision deferred to user (not auto-committed)

### Test G3: Walking Skeleton for Distributed System

**Given** agent WITH walking-skeleton-delivery skill
**And** distributed system with multiple services
**When** user says: "Build distributed e-commerce system (catalog, cart, checkout)"
**Then** agent responds with distributed skeleton including:

- Multi-service E2E goal (what we're proving)
- Minimal E2E flow spanning services in BDD format
- Two-service skeleton scope (defer third service)
- Shared infrastructure requirements
- Timeline estimate (4 days)

**And** agent implements:

- Minimal two-service E2E (catalog + cart only)
- Service-to-service communication
- Shared infrastructure (gateway, separate DBs)
- Cross-service acceptance test

**And** agent provides completion evidence:

- [ ] Multi-service E2E flow defined
- [ ] Minimal implementation of each service
- [ ] Service-to-service communication working
- [ ] Shared infrastructure established (gateway, DBs)
- [ ] Cross-service acceptance test passing
- [ ] Independent deployment proven
- [ ] Architecture validated before full build-out
- [ ] Next steps defined (add checkout service, then features)

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH walking-skeleton-delivery skill
**And** user says: "We need to show progress in the sprint review"
**When** agent is tempted to skip skeleton and build features
**Then** agent responds:

- Acknowledges time concern
- Explains skeleton IS demonstrable progress
- Proposes 2-day skeleton followed by features
- Shows E2E working demo is more impressive than incomplete features

**And** agent does NOT:

- Skip skeleton for "feature progress"
- Defer deployment pipeline
- Build features without E2E validation

### Test P2: Resist Authority Pressure

**Given** agent WITH walking-skeleton-delivery skill
**And** user says: "CTO decided on these technologies, just implement them"
**When** agent is tempted to skip technology validation
**Then** agent responds:

- Respects authority decision on technology choice
- Proposes technology validation skeleton to prove choices work
- Frames as "risk reduction" not "questioning decision"
- Explains cost of late discovery if technologies don't integrate

**And** agent does NOT:

- Blindly implement without validation
- Question technology choices (that's not the point)
- Skip E2E validation because "CTO decided"

### Test P3: Resist Sunk Cost Pressure

**Given** agent WITH walking-skeleton-delivery skill
**And** user says: "We've already built 3 services, too late for skeleton"
**When** agent is tempted to just "fix the integration"
**Then** agent responds:

- Acknowledges existing investment
- Proposes E2E acceptance test as "skeleton retrofit"
- Explains test will document architecture and find gaps
- Shows it's never too late to validate E2E

**And** agent does NOT:

- Patch integration without E2E validation
- Agree it's "too late" for skeleton approach
- Build more services without E2E test

## Integration Scenarios

### Test I1: Integration with test-driven-development

**Given** agent WITH walking-skeleton-delivery skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Build new order service"
**Then** agent:

1. First invokes walking-skeleton-delivery for E2E skeleton
2. Creates BDD acceptance test (skeleton scope)
3. Implements minimal skeleton
4. Then invokes TDD for additional features
5. Each feature has its own red-green-refactor cycle

**Evidence:**

- [ ] Skeleton created with BDD acceptance test
- [ ] Features added using TDD methodology
- [ ] Clear separation: skeleton (E2E) vs features (TDD)

### Test I2: Integration with verification-before-completion

**Given** agent WITH walking-skeleton-delivery skill
**And** agent WITH superpowers:verification-before-completion
**When** skeleton implementation is "complete"
**Then** agent:

1. Runs verification commands (deploy, test, health check)
2. Confirms E2E flow works in staging
3. Only then declares skeleton complete
4. Provides evidence checklist with verification results

**Evidence:**

- [ ] Verification commands run before declaring complete
- [ ] E2E test passing in staging environment
- [ ] Health check verified
- [ ] Evidence provided (not just assertion)

### Test I3: Brainstorming Integration

**Given** agent WITH walking-skeleton-delivery skill
**And** user is exploring approach for new system
**When** agent brainstorms skeleton approach
**Then** agent presents options:

1. Single feature E2E (order creation)
2. Technical spike (prove tech)
3. Deployment pipeline only

**And** asks about:

- Architectural uncertainty level
- Team experience with technologies
- Deployment complexity
- Integration points

**And** surfaces tradeoffs:

- Full feature E2E: Complete but may take longer
- Technical spike: Fast but may not validate full flow
- Pipeline first: Infrastructure focus, defers feature work

## Rationalizations Closure

### Test RC1: "Need features to show progress"

**Given** agent WITH walking-skeleton-delivery skill
**When** user or agent rationalizes: "Need features to show progress"
**Then** agent responds:

- "Walking skeleton IS progress - proves architecture in days, prevents weeks of rework"
- Proposes skeleton demo as sprint achievement
- Shows E2E working is more valuable than incomplete features

### Test RC2: "Deployment can come later"

**Given** agent WITH walking-skeleton-delivery skill
**When** user or agent rationalizes: "Deployment can come later"
**Then** agent responds:

- "Deployment problems discovered late cause delays. Establish pipeline in skeleton."
- Deployment is NOT optional in skeleton
- Late deployment issues are expensive

### Test RC3: "Too late for walking skeleton"

**Given** agent WITH walking-skeleton-delivery skill
**When** user or agent rationalizes: "Too late for walking skeleton"
**Then** agent responds:

- "Never too late. Even mid-project, E2E test validates and documents architecture."
- Proposes E2E acceptance test as skeleton retrofit
- Shows value even for existing systems

### Test RC4: "This delays feature work"

**Given** agent WITH walking-skeleton-delivery skill
**When** user or agent rationalizes: "This delays feature work"
**Then** agent responds:

- "Skeleton takes 2-4 days and prevents weeks of rework. Net acceleration, not delay."
- Shows cost comparison: 2-4 days vs weeks of late rework
- Architecture issues found early are cheap to fix

## Verification Assertions

Each GREEN test should verify:

- [ ] Walking skeleton goal clearly defined
- [ ] Minimal E2E flow in BDD/Gherkin format
- [ ] Scope explicitly defined (IN and OUT)
- [ ] Deployment pipeline established
- [ ] BDD acceptance test passing
- [ ] Health check and basic observability working
- [ ] Learnings documented
- [ ] Next steps defined
- [ ] Evidence checklist provided
- [ ] Rationalizations closed (cannot be bypassed)
