# impacted-scope-enforcement - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Constraint + Small Change

**Given** agent WITHOUT impacted-scope-enforcement skill
**And** pressure: time constraint ("need to deploy before lunch")
**When** user says: "I fixed a typo in the user service README, deploy it"
**Then** record baseline behaviour:

- Does agent scope deployment to user service only? (expected: NO - deploys all services)
- Does agent run full test suite? (expected: YES - unnecessary)
- Does agent check if README changes need deployment? (expected: NO - deploys anyway)
- Rationalizations observed: "Better safe than sorry", "Full suite ensures nothing broke"

### Test R2: Sunk Cost + Feature in Monorepo

**Given** agent WITHOUT impacted-scope-enforcement skill
**And** pressure: sunk cost ("already spent 2 hours on this")
**And** monorepo with 12 services
**When** user says: "Commit the authentication service changes"
**Then** record baseline behaviour:

- Does agent run tests for all 12 services? (expected: YES - full suite)
- Does agent scope lint/format to auth service? (expected: NO - runs on all)
- Does agent apply coverage delta to auth service only? (expected: NO - full coverage check)
- Rationalizations observed: "Ensures no cross-service breakage", "Full suite is fast enough"

### Test R3: Authority + Production Deploy

**Given** agent WITHOUT impacted-scope-enforcement skill
**And** pressure: authority ("CTO approved this specific service update")
**And** pressure: production ("users are waiting")
**When** user says: "Deploy the payment service v2.3.1"
**Then** record baseline behaviour:

- Does agent deploy only payment service? (expected: NO - deploys all or multiple)
- Does agent validate only payment service? (expected: NO - full validation)
- Does agent tag specific service version? (expected: NO - monolithic tag)
- Rationalizations observed: "Safer to deploy together", "Validation is quick"

### Expected Baseline Failures Summary

- [ ] Agent runs full test suites for localized changes
- [ ] Agent deploys all components when only one changed
- [ ] Agent applies quality gates to entire codebase instead of modified scope
- [ ] Agent doesn't distinguish between documentation and code changes
- [ ] Agent uses monolithic version tags instead of service-specific tags

## GREEN Phase - WITH Skill

### Test G1: Commit with Scoped Quality Gates

**Given** agent WITH impacted-scope-enforcement skill
**And** monorepo with services: auth, user, payment, notification
**When** user says: "Commit changes to authentication service"
**Then** agent responds with scoped quality gates:

- Identifies impacted components: authentication service only
- Scopes lint to authentication service files
- Scopes unit tests to authentication service tests
- Applies coverage delta (80% of modified lines)
- Lists skipped components (user, payment, notification)
- Preserves full-suite gates (architecture tests, security scan)

**Evidence checklist:**

- [ ] Impacted component identified correctly
- [ ] Quality gates scoped to modified files
- [ ] Coverage delta applied (not absolute coverage)
- [ ] Full-suite critical gates preserved
- [ ] Execution time reduced vs full suite

### Test G2: CI Build with Selective Execution

**Given** agent WITH impacted-scope-enforcement skill
**And** monorepo with services: api, worker, scheduler
**And** change affects api service only
**When** user says: "Run CI build for this PR"
**Then** agent responds with selective execution plan:

- Build scope: api service + shared-lib dependency
- Test scope: api unit tests, api integration tests, consumer contracts
- Cache strategy: Reuse worker, scheduler from previous build
- Estimated time savings quantified

**Evidence checklist:**

- [ ] Build scope limited to impacted + dependencies
- [ ] Test scope includes consumer contracts
- [ ] Cache strategy for unaffected components
- [ ] Execution time estimate provided
- [ ] Resource optimization quantified

### Test G3: Deployment with Immutable Releases

**Given** agent WITH impacted-scope-enforcement skill
**And** repository uses immutable releases and SemVer
**And** services: frontend, backend, database-migrator
**When** user says: "Deploy backend changes to production"
**Then** agent responds with scoped deployment plan:

- Version changes: backend bumped (e.g., v2.5.3 to v2.6.0)
- Unchanged services listed with current versions
- Service-specific tag: `backend-v2.6.0`
- Rollback target: `backend-v2.5.3`
- Traceability: tag to commit to container image

**Evidence checklist:**

- [ ] Only impacted service deployed
- [ ] Service-specific version tag created
- [ ] Traceability from tag to commit to container
- [ ] Rollback to previous immutable version documented
- [ ] Unaffected services not deployed

### Test G4: Documentation-Only Change

**Given** agent WITH impacted-scope-enforcement skill
**And** change affects only README.md in user service
**When** user says: "Deploy my documentation update"
**Then** agent responds:

- Identifies change as documentation-only
- Skips deployment (no code change)
- Runs markdown validation only
- Explains why deployment is unnecessary

**Evidence checklist:**

- [ ] Documentation change correctly identified
- [ ] Deployment skipped with explanation
- [ ] Markdown validation executed
- [ ] No unnecessary builds triggered

## Pressure Scenarios (WITH Skill)

### Test P1: Resist "Better Safe" Pressure

**Given** agent WITH impacted-scope-enforcement skill
**And** user says: "Run full test suite just to be safe"
**When** agent is tempted to run full suite for localized change
**Then** agent responds:

- Acknowledges safety concern
- Explains selective tests + core gates provide safety
- Shows full suite wastes time on unaffected code
- Proposes scoped execution with critical gates preserved

**And** agent does NOT:

- Run full test suite without justification
- Skip architecture/security gates

### Test P2: Resist "Deploy Together" Pressure

**Given** agent WITH impacted-scope-enforcement skill
**And** user says: "Deploy everything together, it's easier"
**When** agent is tempted to deploy all services
**Then** agent responds:

- Acknowledges simplicity concern
- Explains deploying unchanged services risks unnecessary downtime
- Shows independent rollback is harder with monolithic deployment
- Proposes service-specific deployment with traceability

**And** agent does NOT:

- Deploy unchanged services
- Use monolithic version tags

### Test P3: Resist "Absolute Coverage" Pressure

**Given** agent WITH impacted-scope-enforcement skill
**And** user says: "Coverage must be 80% for the whole project"
**When** agent is tempted to apply absolute coverage
**Then** agent responds:

- Acknowledges coverage goal
- Explains absolute coverage punishes unrelated code
- Shows coverage delta focuses quality on changes
- Proposes 80% coverage of modified lines

**And** agent does NOT:

- Fail builds for unrelated uncovered code
- Skip coverage validation entirely

## Integration Scenarios

### Test I1: Integration with verification-before-completion

**Given** agent WITH impacted-scope-enforcement skill
**And** agent WITH superpowers:verification-before-completion
**When** selective execution completes
**Then** agent:

1. Runs verification commands for impacted scope only
2. Confirms gates passed for affected components
3. Provides evidence checklist with scoped verification

**Evidence:**

- [ ] Verification scoped to impacted components
- [ ] Critical gates (architecture, security) verified
- [ ] Evidence provided before declaring complete

### Test I2: Brainstorming Integration

**Given** agent WITH impacted-scope-enforcement skill
**And** user is exploring validation approach
**When** agent brainstorms scoping approach
**Then** agent presents options:

1. Full validation (safest, slowest, expensive)
2. Impacted-only (fastest, risk of missed indirect deps)
3. Hybrid (core always + impacted)

**And** asks about:

- Monorepo vs multi-repo structure
- Deployment model (continuous vs scheduled)
- Risk tolerance for indirect dependencies
- CI resource constraints

**And** surfaces tradeoffs for each approach

## Rationalizations Closure

### Test RC1: "Better safe - run full test suite"

**Given** agent WITH impacted-scope-enforcement skill
**When** rationalization appears: "Better safe - run full test suite"
**Then** agent responds:

- "Selective tests + core gates provide safety. Full suite wastes time on unaffected code."
- Proposes scoped execution with preserved critical gates

### Test RC2: "Might miss cross-service breakage"

**Given** agent WITH impacted-scope-enforcement skill
**When** rationalization appears: "Might miss cross-service breakage"
**Then** agent responds:

- "Include consumer contract tests for affected interfaces. Don't test unrelated code."
- Proposes contract tests for service boundaries

### Test RC3: "Deployment is automated anyway"

**Given** agent WITH impacted-scope-enforcement skill
**When** rationalization appears: "Deployment is automated anyway"
**Then** agent responds:

- "Deploying unchanged services risks unnecessary downtime and complicates rollback."
- Proposes service-specific deployment

### Test RC4: "Coverage delta is complex"

**Given** agent WITH impacted-scope-enforcement skill
**When** rationalization appears: "Coverage delta is complex"
**Then** agent responds:

- "Git diff + coverage report = simple delta. Absolute coverage punishes unrelated code."
- Proposes coverage delta calculation

### Test RC5: "One tag easier than per-service"

**Given** agent WITH impacted-scope-enforcement skill
**When** rationalization appears: "One tag easier than per-service"
**Then** agent responds:

- "Monolithic tags hide what changed. Service tags enable independent rollback."
- Proposes service-specific tagging strategy

### Test RC6: "Not a monorepo, doesn't apply"

**Given** agent WITH impacted-scope-enforcement skill
**When** rationalization appears: "Not a monorepo, doesn't apply"
**Then** agent responds:

- "Single-repo projects benefit from scoped gates too (frontend vs backend, modules, layers)."
- Proposes appropriate scoping for single-repo structure

## Verification Assertions

Each GREEN test should verify:

- [ ] Impacted components explicitly identified
- [ ] Quality gates scoped to impacted files/components
- [ ] Coverage delta applied (modified lines, not absolute)
- [ ] Build execution selective (impacted + dependencies only)
- [ ] Test execution scoped by type
- [ ] Deployment limited to impacted components
- [ ] Service-specific version tags and traceability
- [ ] Critical full-suite gates preserved (architecture, security)
- [ ] Optimization quantified (time/resource savings)
- [ ] Evidence checklist provided
