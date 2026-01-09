# testing-strategy-agnostic - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Flat Test Strategy

**Given** agent WITHOUT testing-strategy-agnostic skill
**And** user asks about testing approach
**When** user says: "How should we structure our tests?"
**Then** record baseline behaviour:

- Does agent propose test pyramid? (expected: NO - flat list of tests)
- Does agent distinguish Unit/System/E2E? (expected: NO - generic "unit tests")
- Does agent mention architecture testing? (expected: NO - not considered)
- Does agent mention contract versioning? (expected: NO - not considered)
- Rationalizations observed: "Just write unit tests", "Test coverage is what matters"

### Test R2: Ignore Architecture Drift

**Given** agent WITHOUT testing-strategy-agnostic skill
**And** codebase with layered architecture (Domain, Application, Infrastructure)
**When** user says: "Review this PR that adds database code to domain layer"
**And** PR violates layering rules
**Then** record baseline behaviour:

- Does agent flag architecture violation? (expected: NO - focuses on functionality)
- Does agent suggest architecture tests? (expected: NO - manual review only)
- Does agent mention incremental enforcement? (expected: NO - all-or-nothing)
- Rationalizations observed: "It works", "We'll refactor later"

### Test R3: Unversioned Contract Changes

**Given** agent WITHOUT testing-strategy-agnostic skill
**And** API has consumers
**When** user says: "Add a new required field to the API response"
**And** change is breaking for existing consumers
**Then** record baseline behaviour:

- Does agent flag breaking change? (expected: NO - focuses on implementation)
- Does agent require version bump? (expected: NO - not considered)
- Does agent suggest compatibility window? (expected: NO - immediate change)
- Rationalizations observed: "Consumers will update", "It's just one field"

### Test R4: Noisy Logging in Tests

**Given** agent WITHOUT testing-strategy-agnostic skill
**And** system tests with logging
**When** user says: "Add logging to help debug test failures"
**Then** record baseline behaviour:

- Does agent apply payload discipline? (expected: NO - logs everything)
- Does agent use appropriate log levels? (expected: NO - all Info/Warn)
- Does agent consider noise in CI? (expected: NO - more logs = better)
- Rationalizations observed: "More logging helps debugging", "We can filter later"

### Test R5: Shared State in E2E Tests

**Given** agent WITHOUT testing-strategy-agnostic skill
**And** E2E tests against shared database
**When** user says: "E2E tests are flaky and failing randomly"
**Then** record baseline behaviour:

- Does agent identify data isolation issue? (expected: NO - blames timing)
- Does agent enforce test-owned state? (expected: NO - uses shared data)
- Does agent require cleanup guarantees? (expected: NO - best-effort cleanup)
- Rationalizations observed: "Just retry the tests", "Shared data is faster"

### Expected Baseline Failures Summary

- [ ] Agent doesn't propose layered test pyramid (Unit → System → E2E)
- [ ] Agent doesn't distinguish test tiers by purpose
- [ ] Agent doesn't suggest architecture testing
- [ ] Agent doesn't enforce contract versioning
- [ ] Agent doesn't apply payload logging discipline
- [ ] Agent doesn't require test data isolation
- [ ] Agent doesn't consider observability in test design

## GREEN Phase - WITH Skill

### Test G1: Layered Test Strategy Design

**Given** agent WITH testing-strategy-agnostic skill
**When** user says: "Help me design a testing strategy for our new service"
**Then** agent proposes layered test pyramid:

**Unit Tests:**

- Purpose: Class/method-level behaviour
- Characteristics: Isolated, deterministic, fast
- No external I/O

**System Tests:**

- Purpose: Component with real internal wiring
- Characteristics: Mock external dependencies only
- Validates functional outcomes and diagnosability

**E2E Tests:**

- Purpose: End-to-end user journeys
- Characteristics: Minimal, high-value scenarios
- Strong isolation and cleanup

**And** agent provides guidance on:

- Test tier selection criteria
- CI gate placement per tier
- Incremental enforcement approach

**Evidence:**

- [ ] Three test tiers clearly distinguished
- [ ] Purpose and characteristics defined per tier
- [ ] CI gate strategy recommended
- [ ] Incremental adoption path provided

### Test G2: Architecture Testing Enforcement

**Given** agent WITH testing-strategy-agnostic skill
**And** codebase with layered architecture
**When** user says: "How do we prevent architecture drift?"
**Then** agent proposes architecture tests covering:

- **Layering rules:** UI → Application → Domain (inward dependencies)
- **Allowed dependencies:** Package/module boundary enforcement
- **Cyclic dependency detection:** No circular references
- **Namespace conventions:** Vertical slices, bounded contexts
- **Forbidden frameworks:** No persistence in Domain, no UI in Application

**And** agent recommends:

- Dedicated architecture test suite in PR gates
- Small, explicit, business-aligned rules
- Incremental enforcement (strict for new/modified, baseline for legacy)

**Evidence:**

- [ ] Architecture test categories defined
- [ ] Layering rules specified
- [ ] PR gate placement recommended
- [ ] Incremental enforcement strategy provided
- [ ] Legacy baseline approach explained

### Test G3: Contract Versioning Discipline

**Given** agent WITH testing-strategy-agnostic skill
**And** API with multiple consumers
**When** user says: "We need to add breaking changes to our API"
**Then** agent enforces contract versioning:

**Requirements:**

- Explicit version bump (major version for breaking)
- Migration guidance documented
- Compatibility window defined

**PR Requirements:**

- Contract change notes (what changed, why)
- Evidence of compatibility checks

**Automated Checks:**

- API compatibility baseline comparison
- Public API surface snapshots
- Consumer-driven contract tests (if applicable)
- Schema linting and backward-compat validation

**Evidence:**

- [ ] Version bump requirement stated
- [ ] Migration guidance requirement stated
- [ ] Compatibility window requirement stated
- [ ] PR evidence requirements listed
- [ ] Automated check recommendations provided

### Test G4: Observability in Test Design

**Given** agent WITH testing-strategy-agnostic skill
**When** user says: "Add observability to our system tests"
**Then** agent applies observability requirements:

**Minimum Telemetry:**

- Correlation/trace identifiers
- Structured logs with operation name
- Error classification
- Dependency visibility (name, outcome, failure type)

**Payload Logging (Hard Rule):**

- Full payloads ONLY at Debug/Trace levels
- Info/Warn/Error/Critical MUST NOT include full payloads
- Payload logging redacted and environment-gated

**Noise Controls:**

- One summary error for retries (not repeated identical errors)
- No unexpected Error/Critical in successful scenarios

**Evidence:**

- [ ] Correlation ID requirement specified
- [ ] Structured logging requirement specified
- [ ] Payload logging constraints applied (Debug/Trace only)
- [ ] Noise control guidance provided
- [ ] Log level discipline enforced

### Test G5: Test Data Isolation

**Given** agent WITH testing-strategy-agnostic skill
**And** E2E tests that need data
**When** user says: "Our E2E tests need database state"
**Then** agent enforces data safety:

**Requirements:**

- Tests MUST NOT mutate non-test-owned data
- Tests use only data they create
- Cleanup is reliable and idempotent
- Strong isolation guarantees

**Implementation Guidance:**

- Test-scoped data creation
- Transaction rollback or explicit cleanup
- Unique test identifiers to prevent collision
- Verify isolation in test assertions

**Evidence:**

- [ ] Data ownership rules stated
- [ ] Cleanup requirements specified
- [ ] Isolation strategy recommended
- [ ] Collision prevention approach provided

### Test G6: Review Heuristics Application

**Given** agent WITH testing-strategy-agnostic skill
**When** user says: "Review this test implementation"
**Then** agent applies review heuristics:

1. **Tier Selection:** Is lowest-cost tier used for the behaviour?
2. **Architecture:** Does change preserve layering and dependencies?
3. **Contracts:** Is interface change intentional, versioned, compatible?
4. **Observability:** Are failures diagnosable without payload dumps?
5. **Payload Discipline:** Full payloads restricted to Debug/Trace?

**Evidence:**

- [ ] Review heuristics checklist applied
- [ ] Tier appropriateness verified
- [ ] Architecture impact assessed
- [ ] Contract impact assessed
- [ ] Observability requirements checked

## Pressure Scenarios (WITH Skill)

### Test P1: Resist "Just Write Tests" Pressure

**Given** agent WITH testing-strategy-agnostic skill
**And** user says: "Don't overthink it, just write some tests"
**When** agent is tempted to skip test strategy
**Then** agent responds:

- Acknowledges simplicity goal
- Explains test pyramid prevents wasted effort
- Shows right tier = faster feedback
- Proposes: "Let's spend 5 minutes deciding the tier"

**And** agent does NOT:

- Skip tier selection
- Write E2E tests for unit-testable logic
- Ignore test strategy entirely

### Test P2: Resist "Architecture Tests Are Overkill" Pressure

**Given** agent WITH testing-strategy-agnostic skill
**And** user says: "Architecture tests are over-engineering"
**When** agent is tempted to skip architecture testing
**Then** agent responds:

- Acknowledges concern about complexity
- Explains incremental enforcement starts small
- Shows architecture drift costs more to fix later
- Proposes: "Start with one critical boundary rule"

**And** agent does NOT:

- Skip architecture testing entirely
- Defer architecture enforcement indefinitely
- Accept "we'll refactor later" for drift

### Test P3: Resist "Breaking Changes Are Fine" Pressure

**Given** agent WITH testing-strategy-agnostic skill
**And** user says: "Consumers will just update, ship it"
**When** agent is tempted to skip versioning
**Then** agent responds:

- Acknowledges urgency
- Explains breaking changes without versioning cause outages
- Shows version bump takes minimal time
- Proposes: "Add version header and migration notes"

**And** agent does NOT:

- Ship breaking changes without version bump
- Skip compatibility window
- Accept "consumers will update" rationalization

### Test P4: Resist "More Logging Is Better" Pressure

**Given** agent WITH testing-strategy-agnostic skill
**And** user says: "Log everything to help debugging"
**When** agent is tempted to over-log
**Then** agent responds:

- Acknowledges debugging need
- Explains payload noise hides real errors
- Shows structured logging with correlation enables debugging
- Proposes: "Use Debug level for payloads, structured Info for operations"

**And** agent does NOT:

- Log full payloads at Info level
- Accept "more logs = better debugging"
- Skip log level discipline

## Integration Scenarios

### Test I1: Integration with test-driven-development

**Given** agent WITH testing-strategy-agnostic skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add a new feature with TDD"
**Then** agent:

1. First selects appropriate test tier for behaviour
2. Writes failing test at that tier
3. Implements minimal code to pass
4. Refactors with architecture rules in mind

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Appropriate test tier selected (not E2E for unit logic)
- [ ] Architecture rules considered in refactor phase

### Test I2: Integration with verification-before-completion

**Given** agent WITH testing-strategy-agnostic skill
**And** agent WITH superpowers:verification-before-completion
**When** test implementation is "complete"
**Then** agent:

1. Verifies tests run at appropriate tier
2. Confirms observability requirements met
3. Validates no payload leakage at Info+
4. Checks architecture tests pass (if applicable)

**Evidence:**

- [ ] Verification commands run before declaring complete
- [ ] Test tier appropriateness confirmed
- [ ] Observability verified (logs checked)
- [ ] Architecture tests passing

## Rationalizations Closure

### Test RC1: "Test coverage is what matters"

**Given** agent WITH testing-strategy-agnostic skill
**When** rationalization: "Test coverage is what matters"
**Then** agent responds:

- "Coverage without strategy tests the wrong things at the wrong tier."
- "Unit tests for integration behaviour give false confidence."
- "Right tier + targeted tests > high coverage with wrong tier."

### Test RC2: "Architecture tests are too strict"

**Given** agent WITH testing-strategy-agnostic skill
**When** rationalization: "Architecture tests are too strict"
**Then** agent responds:

- "Incremental enforcement starts permissive, tightens on touch."
- "New code gets strict rules; legacy gets baseline exceptions."
- "Business-aligned rules, not abstract purity constraints."

### Test RC3: "Versioning slows us down"

**Given** agent WITH testing-strategy-agnostic skill
**When** rationalization: "Versioning slows us down"
**Then** agent responds:

- "Version bump is minutes; breaking consumer outages are hours/days."
- "Explicit versions enable parallel consumer migration."
- "Compatibility windows prevent emergency rollbacks."

### Test RC4: "We need full payloads for debugging"

**Given** agent WITH testing-strategy-agnostic skill
**When** rationalization: "We need full payloads for debugging"
**Then** agent responds:

- "Full payloads at Debug/Trace level - available when needed."
- "Correlation IDs + structured logs enable debugging without noise."
- "Production logs at Info+ must be noise-free for real issues."

### Test RC5: "Shared test data is faster"

**Given** agent WITH testing-strategy-agnostic skill
**When** rationalization: "Shared test data is faster"
**Then** agent responds:

- "Shared data causes flaky tests - debugging flakes costs more."
- "Test-owned data ensures reproducibility."
- "Isolation enables parallel execution - actually faster."

## Verification Assertions

Each GREEN test should verify:

- [ ] Layered test pyramid proposed (Unit → System → E2E)
- [ ] Test tiers distinguished by purpose and characteristics
- [ ] Architecture testing recommended with incremental enforcement
- [ ] Contract versioning discipline applied
- [ ] Observability requirements specified (correlation, structured logs)
- [ ] Payload logging constraints enforced (Debug/Trace only)
- [ ] Test data isolation required
- [ ] Review heuristics applied consistently
- [ ] Rationalizations closed (cannot be bypassed)

---

## Evidence

**Verification checklist:**

- [ ] SKILL.md contains valid frontmatter with `name` and `description` fields
- [ ] SKILL.md defines test tier characteristics (Unit, Integration, System, E2E)
- [ ] Architecture testing guidance is documented
- [ ] Contract versioning discipline is documented
- [ ] Observability requirements are specified
- [ ] Test data isolation principles are documented
- [ ] Review heuristics table is present

**Skill structure verified:**

- [ ] `SKILL.md` exists with platform-agnostic testing guidance
- [ ] No platform-specific dependencies (defers to `testing-strategy-dotnet` for .NET)
