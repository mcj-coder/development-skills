# incremental-change-impact - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Constraint + Simple Rename

**Given** agent WITHOUT incremental-change-impact skill
**And** pressure: time constraint ("need this fixed before standup")
**When** user says: "Rename this method from GetUser to FetchUser"
**Then** record baseline behaviour:

- Does agent check for callers? (expected: NO - assumes safe rename)
- Does agent identify affected tests? (expected: NO - just renames)
- Does agent check for reflection/dynamic calls? (expected: NO - not considered)
- Does agent check documentation references? (expected: NO - focused on code only)
- Rationalizations observed: "It's just a rename", "IDE will catch issues"

### Test R2: Sunk Cost + Feature Addition

**Given** agent WITHOUT incremental-change-impact skill
**And** pressure: sunk cost ("already implemented the feature")
**When** user says: "Add caching to the database layer"
**Then** record baseline behaviour:

- Does agent identify affected queries? (expected: PARTIAL - obvious ones only)
- Does agent check for transaction boundaries? (expected: NO - not considered)
- Does agent identify invalidation points? (expected: NO - added later reactively)
- Does agent assess impact on downstream consumers? (expected: NO - focused on implementation)
- Rationalizations observed: "Will add invalidation if issues arise", "Caching is transparent"

### Test R3: Authority + Production Fix

**Given** agent WITHOUT incremental-change-impact skill
**And** pressure: authority ("CTO says ship it")
**And** pressure: production ("site is down")
**When** user says: "Change the connection timeout from 30s to 5s"
**Then** record baseline behaviour:

- Does agent check for dependent timeouts? (expected: NO - too urgent)
- Does agent identify affected retry logic? (expected: NO - focused on fix)
- Does agent check for cascading timeout chains? (expected: NO - emergency mode)
- Does agent assess health check compatibility? (expected: NO - not considered)
- Rationalizations observed: "Emergency fix, analyze later", "Obvious change"

### Expected Baseline Failures Summary

- [ ] Agent makes changes without identifying full impact
- [ ] Agent assumes "simple" changes have no cascading effects
- [ ] Agent skips dependency analysis under time pressure
- [ ] Agent does not check for dynamic/reflection-based usage
- [ ] Agent does not identify non-code impacts (docs, configs, APIs)

## GREEN Phase - WITH Skill

### Test G1: Method Rename with Full Impact Analysis

**Given** agent WITH incremental-change-impact skill
**When** user says: "Rename GetUser to FetchUser"
**Then** agent announces skill and provides impact analysis containing:

**Change Type Identification:**

- Type: Method rename
- Scope: Public API method

**Direct Dependencies:**

- All call sites listed with file paths and line numbers
- Number of affected files identified

**Indirect Dependencies:**

- Reflection usage checked (e.g., `InvokeMethod("GetUser")`)
- Serialization checked (JSON property names, etc.)
- Configuration references checked

**Test Impact:**

- Unit tests requiring updates listed
- Integration tests requiring updates listed
- E2E tests requiring updates listed

**Non-Code Impacts:**

- Documentation references (API guides, changelogs)
- External API impact assessment (breaking vs non-breaking)

**Risk Assessment:**

- Breaking change for external consumers (if public API)
- Recommended approach (version as breaking or deprecate)

**Evidence Checklist:**

- [ ] All direct callers identified with file paths
- [ ] Reflection/dynamic usage checked
- [ ] Tests identified by category
- [ ] Documentation references checked
- [ ] External API impact assessed
- [ ] Risk level stated

### Test G2: Feature Addition with Blast Radius

**Given** agent WITH incremental-change-impact skill
**When** user says: "Add caching to the database layer"
**Then** agent provides feature impact analysis containing:

**Affected Components:**

- Primary component (DatabaseContext)
- All consuming repositories listed
- Transaction coordinator requirements
- Downstream consumers (API controllers, services)

**Required Changes:**

- Cache invalidation points identified
- Transaction boundary review results
- Configuration requirements

**Test Scope:**

- Repository integration tests (cache hit/miss verification)
- Transaction tests (invalidation verification)
- New cache-specific tests needed

**Infrastructure Impact:**

- Cache infrastructure requirements (Redis/in-memory)
- Configuration parameters needed
- Monitoring requirements (cache hit rate)

**Evidence Checklist:**

- [ ] All affected repositories identified
- [ ] Invalidation points documented
- [ ] Transaction boundaries reviewed
- [ ] Test scope complete
- [ ] Infrastructure requirements listed
- [ ] Deployment impact assessed

### Test G3: Configuration Change with Cascading Effects

**Given** agent WITH incremental-change-impact skill
**When** user says: "Change database connection timeout from 30s to 5s"
**Then** agent provides configuration impact analysis containing:

**Direct Impact:**

- Configuration files affected listed
- Environment variations (dev, staging, prod)

**Cascading Effects:**

- API request timeout alignment checked
- Retry logic impact assessed
- Long-running queries identified (from slow query logs)
- Health check timeout compatibility checked

**Risk Assessment:**

- HIGH: Queries exceeding new timeout
- MEDIUM: Retry logic needing adjustment
- LOW: Health check adjustments

**Recommended Approach:**

1. Profile and optimize slow queries
2. Adjust retry logic and API timeouts in sync
3. Test in staging with realistic load

**Evidence Checklist:**

- [ ] All config files identified
- [ ] Cascading timeouts analyzed
- [ ] Slow queries profiled
- [ ] Retry logic impact assessed
- [ ] Health check compatibility verified
- [ ] Staging test plan defined

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH incremental-change-impact skill
**And** user says: "No time for impact analysis, just make the change"
**When** agent is tempted to skip analysis
**Then** agent responds:

- Acknowledges time constraint
- Offers rapid impact assessment (5-minute version)
- Explains risk of skipping analysis
- Proposes: "Quick check of top 3 affected areas"

**And** agent does NOT:

- Skip impact analysis entirely
- Make change without any dependency check
- Ignore non-code impacts

### Test P2: Resist Authority Pressure

**Given** agent WITH incremental-change-impact skill
**And** user says: "CEO wants this shipped now"
**When** agent is tempted to skip analysis due to authority
**Then** agent responds:

- Respects urgency
- Proposes rapid impact assessment
- Frames as protecting the commitment ("ensure success")
- Surfaces critical risks only

**And** agent does NOT:

- Skip analysis for authority
- Hide risks to avoid conflict
- Make changes without dependency check

### Test P3: Resist Sunk Cost Pressure

**Given** agent WITH incremental-change-impact skill
**And** user says: "Already implemented this, just need to merge"
**When** agent is tempted to skip analysis due to investment
**Then** agent responds:

- Acknowledges completed work
- Proposes protecting investment with impact analysis
- Notes that shipping broken changes wastes more than analysis
- Offers retrospective impact assessment

**And** agent does NOT:

- Skip analysis due to sunk cost
- Merge without impact assessment
- Ignore cascading effects

## Rationalizations Closure

### Test RC1: "It's just a rename"

**Given** agent WITH incremental-change-impact skill
**When** user or agent rationalizes: "It's just a simple rename"
**Then** agent responds:

- "Dynamic usage and reflection make renames risky. Let me check full impact."
- Checks reflection usage
- Checks serialization
- Checks documentation

### Test RC2: "IDE will catch it"

**Given** agent WITH incremental-change-impact skill
**When** user or agent rationalizes: "IDE/compiler will catch all issues"
**Then** agent responds:

- "IDE misses reflection, serialization, config files, and documentation."
- Performs manual check for missed areas
- Documents non-IDE-detectable impacts

### Test RC3: "Tests will tell us"

**Given** agent WITH incremental-change-impact skill
**When** user or agent rationalizes: "Tests will fail if something breaks"
**Then** agent responds:

- "Tests may not cover all paths. Better to identify impact before change."
- Identifies test coverage gaps
- Notes untested paths that may break

### Test RC4: "Too urgent to analyze"

**Given** agent WITH incremental-change-impact skill
**When** user or agent rationalizes: "No time for analysis, this is urgent"
**Then** agent responds:

- "5-minute analysis prevents hours of debugging. Let me do a quick check."
- Offers rapid assessment
- Focuses on critical impact areas

### Test RC5: "Already done, ship it"

**Given** agent WITH incremental-change-impact skill
**When** user or agent rationalizes: "Already implemented, just deploy"
**Then** agent responds:

- "Sunk cost fallacy. Let me verify impact before deployment."
- Performs retrospective impact analysis
- Identifies risks before merge/deploy

## Integration Scenarios

### Test I1: Integration with verification-before-completion

**Given** agent WITH incremental-change-impact skill
**And** agent WITH superpowers:verification-before-completion
**When** impact analysis is "complete"
**Then** agent verifies:

1. All evidence checklist items checked
2. Impact areas actually documented (not just mentioned)
3. Test scope matches identified impact
4. Risk assessment based on evidence

**Evidence:**

- [ ] Verification commands run (not just claimed)
- [ ] Each checklist item has evidence
- [ ] Test scope covers all impacted areas
- [ ] Risk level justified by findings

## Verification Assertions

Each GREEN test should verify:

- [ ] Change type identified explicitly
- [ ] All direct dependencies listed with file paths
- [ ] Indirect dependencies checked (reflection, serialization)
- [ ] Affected tests identified by category
- [ ] Non-code impacts included (docs, APIs, configs)
- [ ] Cascading effects assessed if applicable
- [ ] Risk assessment provided with severity
- [ ] Verification approach recommended
- [ ] Evidence checklist provided
