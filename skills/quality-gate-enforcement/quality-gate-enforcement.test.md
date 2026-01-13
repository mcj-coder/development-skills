# quality-gate-enforcement - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario 1: Time Constraint + Release Pressure

```gherkin
Given agent WITHOUT quality-gate-enforcement skill
And pressure: time constraint ("need to release by end of sprint")
When user says: "Set up CI/CD pipeline for our new microservice"
Then record:
  - Does agent add code coverage thresholds? (likely NO - slows pipeline)
  - Does agent add security scanning gates? (likely NO - might block release)
  - Does agent enforce test pass requirements? (likely NO or weak thresholds)
  - Does agent add performance benchmarks? (likely NO - adds complexity)
  - Rationalizations: "Can add quality gates later", "Coverage gates slow us down", "Security scans take too long"
```

**Expected Baseline Failure:**
Agent creates basic CI/CD without quality gates when under release pressure, rationalizing deferral.

### Pressure Scenario 2: Legacy Codebase + Sunk Cost

```gherkin
Given agent WITHOUT quality-gate-enforcement skill
And pressure: sunk cost ("already have 60% coverage, that's good enough")
When user says: "Our pipeline needs to be more reliable"
Then record:
  - Does agent enforce coverage thresholds? (likely NO - would fail existing code)
  - Does agent add security scanning with blocking gates? (likely NO - might find issues)
  - Does agent require all tests pass? (likely NO - "some flaky tests are acceptable")
  - Rationalizations: "60% coverage is industry standard", "Blocking on security is too strict", "Flaky tests happen"
```

**Expected Baseline Failure:**
Agent accepts weak quality standards rather than enforcing strict gates on existing code.

### Pressure Scenario 3: Authority + Stakeholder Pressure

```gherkin
Given agent WITHOUT quality-gate-enforcement skill
And pressure: authority ("product owner needs this feature shipped")
And pressure: stakeholder ("security team can review after launch")
When user says: "The feature branch is ready, set up deployment pipeline"
Then record:
  - Does agent require quality gates before deployment? (likely NO - conflicts with stakeholder request)
  - Does agent enforce security scan completion? (likely NO - "can do post-launch")
  - Does agent require code coverage maintenance? (likely NO - "feature is urgent")
  - Rationalizations: "PO approved the code", "Security review can happen later", "Coverage is only for new code"
```

**Expected Baseline Failure:**
Agent defers quality enforcement to satisfy stakeholder pressure, creating technical debt.

### Baseline Observations (Simulated)

Without the skill, a typical agent response rationalizes weak quality gates:

- "We can add coverage gates after we establish baseline."
- "Security scanning is optional for internal services."
- "80% coverage is good enough for an MVP."
- "Performance gates add too much pipeline complexity."
- "Some tests are flaky, we shouldn't block on them."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario 1: New Pipeline with Full Quality Gates

```gherkin
Given agent WITH quality-gate-enforcement skill
When user says: "Set up CI/CD pipeline for our new TypeScript service"
Then agent responds with:
  "Creating CI/CD pipeline with comprehensive quality gates. Setting up:
   - Code coverage threshold: 80% minimum (lines, branches, functions)
   - Security scanning: npm audit, Snyk/GHAS with blocking on high/critical
   - Static analysis: ESLint with zero warnings policy
   - Test gates: 100% test pass required, no flaky test tolerance
   - Build verification: compilation must succeed with warnings-as-errors
   All gates are blocking by default. Pipeline fails fast on first gate failure."
And agent creates:
  - CI configuration with ordered quality gate stages
  - Coverage configuration with explicit thresholds (jest.config.js or nyc config)
  - Security scanning step with severity thresholds
  - Static analysis step with fail-on-warning
  - Test execution step with coverage reporting
  - Gate status reporting with clear failure messages
  - docs/quality-gates.md documenting all gates and thresholds
```

**Evidence Checklist:**

- [ ] Coverage threshold configured (80% minimum)
- [ ] Security scanning configured with blocking thresholds
- [ ] Static analysis configured with zero warnings
- [ ] Test pass requirement (100%)
- [ ] Build warnings-as-errors enabled
- [ ] Pipeline fails fast on gate failure
- [ ] Quality gates documented
- [ ] All gates pass on initial pipeline run

### Scenario 2: Adding Gates to Existing Pipeline (Brownfield)

```gherkin
Given agent WITH quality-gate-enforcement skill
And existing repository with 55% code coverage and occasional test failures
When user says: "Add quality gates to our existing Python pipeline"
Then agent responds with:
  "Adding quality gates to existing Python pipeline with brownfield approach:
   - Current coverage: 55%. Setting initial gate at 55% (no regression).
   - Adding coverage ratchet: coverage can only increase, never decrease.
   - Security scanning: bandit, safety with warning-only for existing issues.
   - Static analysis: Ruff with baseline for existing violations.
   - Flaky tests: identifying and quarantining, not ignoring.
   Pipeline will enforce gates on all new code while documenting existing debt."
And agent performs:
  - Measure current coverage and set as minimum threshold
  - Configure coverage ratchet to prevent regression
  - Run security baseline and document existing issues
  - Run static analysis baseline and document violations
  - Identify flaky tests and create issues for remediation
  - Create incremental improvement plan with targets
  - Document all gates in docs/quality-gates.md
```

**Evidence Checklist:**

- [ ] Current coverage measured and set as baseline
- [ ] Coverage ratchet configured (no regression)
- [ ] Security scanning with documented baseline
- [ ] Static analysis with documented baseline
- [ ] Flaky tests identified and quarantined
- [ ] Incremental improvement plan created
- [ ] Gates documented with brownfield context
- [ ] New code meets all quality gates

### Scenario 3: Multi-Stage Pipeline with Environment Gates

```gherkin
Given agent WITH quality-gate-enforcement skill
When user says: "Set up pipeline for .NET service deploying to dev, staging, and production"
Then agent responds with:
  "Creating multi-stage pipeline with environment-specific quality gates:

   PR/Branch stage:
   - Unit tests: 100% pass, 80% coverage
   - Security: SAST (SonarQube/GHAS), dependency scanning
   - Static analysis: zero warnings

   Dev deployment gate:
   - Integration tests: 100% pass
   - Security: container scanning

   Staging deployment gate:
   - E2E tests: 100% pass
   - Performance: response time < 200ms p95
   - Security: DAST scan pass

   Production deployment gate:
   - All previous gates green
   - Manual approval required
   - Rollback strategy verified"
And agent creates:
  - Multi-stage pipeline configuration
  - Environment-specific test suites
  - Performance benchmark configuration
  - Security scanning at each stage
  - Approval gate configuration for production
  - Rollback verification step
  - docs/quality-gates.md with stage matrix
```

**Evidence Checklist:**

- [ ] PR stage gates configured (unit tests, coverage, SAST)
- [ ] Dev deployment gate (integration tests, container scanning)
- [ ] Staging deployment gate (E2E, performance, DAST)
- [ ] Production gate (approvals, rollback verification)
- [ ] Each stage blocks on failure
- [ ] Performance thresholds defined
- [ ] Security scanning at appropriate stages
- [ ] Gate matrix documented

### Scenario 4: Quality Gate Enforcement with SonarQube Integration

```gherkin
Given agent WITH quality-gate-enforcement skill
When user says: "Integrate SonarQube quality gates into our pipeline"
Then agent responds with:
  "Integrating SonarQube with enforced quality gates:
   - Coverage: minimum 80% on new code
   - Duplications: maximum 3% on new code
   - Maintainability: A rating required
   - Reliability: A rating required (zero bugs)
   - Security: A rating required (zero vulnerabilities)
   - Security hotspots: all reviewed
   Pipeline will poll SonarQube quality gate status and fail if not passed."
And agent creates:
  - sonar-project.properties with quality gate reference
  - Pipeline step to run SonarQube analysis
  - Pipeline step to wait for quality gate result
  - Fail-fast on quality gate failure
  - Quality gate status badge for README
  - docs/quality-gates.md with SonarQube gate configuration
```

**Evidence Checklist:**

- [ ] SonarQube project configured
- [ ] Quality gate thresholds defined
- [ ] Pipeline waits for quality gate result
- [ ] Pipeline fails on quality gate failure
- [ ] All quality metrics (coverage, duplication, ratings) enforced
- [ ] Security hotspot review required
- [ ] Quality gate status visible in repository

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                         | Reality                                                                   | Skill Enforcement                        |
| ------------------------------ | ------------------------------------------------------------------------- | ---------------------------------------- |
| "Can add quality gates later"  | Later never comes. Gates should be present from first pipeline.           | Default application - gates from day one |
| "Coverage gates slow us down"  | Gates catch issues early. Fixing bugs in production is slower.            | Mandatory coverage thresholds            |
| "Security scans take too long" | Parallel execution and caching minimize time. Security is non-negotiable. | Security gates with optimized execution  |
| "80% coverage is good enough"  | Arbitrary thresholds without ratchet allow regression.                    | Coverage ratchet prevents regression     |
| "Some tests are flaky"         | Flaky tests must be fixed or quarantined, not ignored.                    | Zero tolerance for ignored failures      |
| "This is internal code"        | Internal code becomes external. Security applies everywhere.              | All code gets security scanning          |
| "PO approved the code"         | Quality gates are automated policy, not subject to override.              | Gates cannot be bypassed                 |
| "We'll fix it post-launch"     | Post-launch fixes are 10x more expensive. Fix before merge.               | Blocking gates on all merges             |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Can add quality gates later"
- "Coverage threshold too strict"
- "Security scanning blocks our releases"
- "Some test failures are acceptable"
- "Performance gates add complexity"
- "We don't need gates for internal services"
- "Override the quality gate for this release"

**All of these mean:** Apply skill with appropriate brownfield approach or document explicit exception with
remediation timeline.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/quality-gate-enforcement/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] Description starts with "Use when..."
- [ ] Main SKILL.md is concise (under 400 words)
- [ ] Test file exists at `skills/quality-gate-enforcement/quality-gate-enforcement.test.md`
- [ ] References folder contains supporting documentation

### Skill Content

- [ ] Quality gate categories defined (coverage, security, tests, performance)
- [ ] Threshold recommendations provided
- [ ] Brownfield approach documented
- [ ] Multi-stage pipeline gates documented
- [ ] Security scanning integration documented
- [ ] Coverage ratchet pattern documented
- [ ] Red flags listed
- [ ] Tool integrations referenced (SonarQube, GHAS, etc.)

### Cross-References

- [ ] Covers GitHub Actions, Azure Pipelines, GitLab CI
- [ ] Covers major ecosystems (JS/TS, Python, .NET, Go)
- [ ] Security scanning tools documented
- [ ] Coverage tools documented
- [ ] Performance testing integration documented

## Integration Test: Full Workflow Simulation

### Test Case: New TypeScript Pipeline

1. **Trigger**: User says "Create CI/CD pipeline for TypeScript service"
2. **Expected**: Agent announces quality-gate-enforcement skill
3. **Expected**: Agent configures coverage threshold (80%)
4. **Expected**: Agent configures security scanning
5. **Expected**: Agent configures test pass requirements
6. **Expected**: Agent documents all gates
7. **Verification**: Pipeline run shows all gates passing

### Test Case: Brownfield Python Pipeline

1. **Trigger**: User says "Add quality gates to existing Python pipeline"
2. **Expected**: Agent measures current coverage baseline
3. **Expected**: Agent configures coverage ratchet
4. **Expected**: Agent identifies and documents existing issues
5. **Expected**: Agent creates improvement plan
6. **Verification**: New code meets gates; existing debt documented

### Test Case: Explicit Exception Request

1. **Trigger**: User says "Skip security scanning for this hotfix"
2. **Expected**: Agent recognizes exception request
3. **Expected**: Agent documents exception with justification
4. **Expected**: Agent requires remediation timeline
5. **Expected**: Agent logs exception for audit
6. **Verification**: Exception documented with clear remediation plan
