# best-practice-introduction - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Constraint + Security Fix

**Given** agent WITHOUT best-practice-introduction skill
**And** pressure: time constraint ("security audit tomorrow")
**When** user says: "We need to add SAST scanning to all our repositories"
**Then** record baseline behaviour:

- Does agent create phased rollout plan? (expected: NO - applies immediately everywhere)
- Does agent define pilot phase? (expected: NO - no time for pilots)
- Does agent define rollback criteria? (expected: NO - security is mandatory)
- Rationalizations observed: "Security can't wait", "Must apply to all repos immediately"

### Test R2: Sunk Cost + Failed Tool

**Given** agent WITHOUT best-practice-introduction skill
**And** pressure: sunk cost ("already bought enterprise license")
**When** user says: "Our team hates the new static analysis tool we just adopted, can we try a different one?"
**Then** record baseline behaviour:

- Does agent define rollback plan? (expected: NO - license cost is sunk)
- Does agent pilot alternative before full switch? (expected: NO - already disrupted once)
- Does agent assess why first tool failed? (expected: NO - focus on switching)
- Rationalizations observed: "Already paid for it, must use it", "Can't keep switching tools"

### Test R3: Authority + Immediate Mandate

**Given** agent WITHOUT best-practice-introduction skill
**And** pressure: authority ("CTO mandated this practice")
**And** pressure: time ("effective immediately")
**When** user says: "CTO wants all teams using trunk-based development starting next sprint"
**Then** record baseline behaviour:

- Does agent propose pilot phase? (expected: NO - conflicts with CTO mandate)
- Does agent identify adoption risks? (expected: NO - mandate is non-negotiable)
- Does agent define success criteria? (expected: NO - compliance is the goal)
- Rationalizations observed: "CTO decision is final", "Must comply immediately"

### Expected Baseline Failures Summary

- [ ] Agent applies new practices immediately without pilot phase
- [ ] Agent skips risk assessment when under authority/time pressure
- [ ] Agent doesn't define rollback criteria for "mandatory" changes
- [ ] Agent doesn't validate adoption success before full rollout
- [ ] Agent doesn't define success criteria beyond compliance
- [ ] Agent defers to authority without objective comparison

## GREEN Phase - WITH Skill

### Test G1: New Linting Tool - Opt-In Pilot

**Given** agent WITH best-practice-introduction skill
**When** user says: "I want to introduce ESLint with strict rules to our JavaScript projects"
**Then** agent announces skill and proposes phased rollout

**And** agent creates rollout plan with minimum 2 phases:

```markdown
**Phase 1: Opt-In Pilot (Week 1-2)**

- Scope: 1-2 volunteer teams
- Enforcement: Local warnings, CI informational
- Success criteria: <5 violations per 100 LOC, team feedback positive
- Rollback trigger: >50% of team requests removal

**Phase 2: Warning Rollout (Week 3-4)**

- Scope: All JavaScript projects
- Enforcement: Warnings in IDE and CI (no build failures)
- Success criteria: Violation rate decreasing week-over-week

**Phase 3: Error Enforcement (Week 5+)**

- Enforcement: Errors in pre-commit and CI
- Baseline existing violations in docs/known-issues.md
```

**And** agent defines rollback criteria:

- > 30% reduction in PR velocity
- > 3 teams request exemption
- Critical blocking false positives discovered

**And** agent defines communication plan

**Evidence Checklist:**

- [ ] Phased rollout plan defined (minimum 2 phases)
- [ ] Each phase has scope, enforcement level, success criteria
- [ ] Rollback criteria defined with measurable thresholds
- [ ] Communication plan included
- [ ] Pilot feedback mechanism specified

### Test G2: Architectural Pattern - Phased by Component

**Given** agent WITH best-practice-introduction skill
**When** user says: "We want to adopt clean architecture across our microservices"
**Then** agent announces skill and proposes component-by-component rollout

**And** agent creates rollout plan:

```markdown
**Phase 1: Pattern Definition (Week 1)**

- Define clean architecture boundaries
- Create reference implementation with newest service
- Document layer structure and dependency rules

**Phase 2: Greenfield Application (Week 2-3)**

- Apply pattern to new services only
- Validate with real-world usage
- Gather developer feedback
- Success criteria: New services pass architecture tests

**Phase 3: Small Service Migration (Week 4-6)**

- Select 2-3 smallest existing services
- Refactor incrementally
- Document migration patterns
- Success criteria: Services migrated without functional regressions

**Phase 4: Large Service Migration (Week 7+)**

- Prioritize by business value and complexity
- Migrate one service at a time
- Allow hybrid state during migration
```

**And** agent defines success metrics:

- All new services use pattern from day 1
- 50% of existing services migrated by Month 3
- 100% of existing services migrated by Month 6

**Evidence Checklist:**

- [ ] Phased rollout by component type (greenfield then brownfield)
- [ ] Reference implementation specified
- [ ] Incremental migration plan
- [ ] Success metrics defined with timeline
- [ ] Hybrid state allowed during transition

### Test G3: Security Practice - Immediate with Support

**Given** agent WITH best-practice-introduction skill
**When** user says: "Security audit requires dependency scanning in CI immediately"
**Then** agent acknowledges urgency but defines support structure

**And** agent creates rollout plan:

```markdown
**Phase 1: Immediate Implementation (Day 1)**

- Add dependency scanning to CI pipelines
- Run baseline scan on all repositories
- Document existing vulnerabilities in docs/security-baseline.md
- Configure CI: allow existing baseline, block new violations

**Phase 2: Education & Support (Day 1-3)**

- Create runbook for common vulnerability types
- Document escalation path for blocking issues
- Establish security champion for questions
- Send announcement with documentation links

**Phase 3: Baseline Remediation (Week 1-4)**

- Prioritize critical/high vulnerabilities
- Schedule remediation sprints
- Target: Zero critical/high by Week 4

**Phase 4: Full Enforcement (Week 5+)**

- Remove baseline exceptions for remediated items
- Enforce zero-vulnerability on new code
```

**And** agent specifies fix-forward approach (no rollback for security)

**Evidence Checklist:**

- [ ] Immediate implementation with baseline exceptions
- [ ] Educational resources and support defined
- [ ] Escalation path specified
- [ ] Remediation plan with timeline
- [ ] Fix-forward approach documented (no rollback)

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH best-practice-introduction skill
**And** user says: "No time for pilot, just roll it out everywhere"
**When** agent is tempted to skip phased approach
**Then** agent responds:

- Acknowledges time constraint
- Explains risks of immediate rollout
- Offers compressed timeline (1-week pilot vs 2-week)
- Proposes baseline approach for urgent security

**And** agent does NOT:

- Skip phases entirely
- Apply to all without validation
- Ignore rollback criteria

### Test P2: Resist Authority Pressure

**Given** agent WITH best-practice-introduction skill
**And** user says: "CTO mandated this effective immediately"
**When** agent is tempted to defer to authority
**Then** agent responds:

- Respects the mandate
- Proposes phased implementation of the mandate
- Frames as "how to execute successfully, not whether to execute"
- Defines success criteria beyond compliance

**And** agent does NOT:

- Skip risk assessment
- Avoid defining rollback criteria
- Ignore adoption challenges

### Test P3: Resist Sunk Cost Fallacy

**Given** agent WITH best-practice-introduction skill
**And** user says: "We already bought the license, we have to use it"
**When** agent is tempted to force adoption of failing tool
**Then** agent responds:

- Acknowledges investment
- Assesses why current adoption failed
- Proposes pilot of alternative before full switch
- Frames decision on productivity cost, not license cost

**And** agent does NOT:

- Force continued use of ineffective tool
- Skip analysis of why first rollout failed
- Ignore team feedback

## Integration Scenarios

### Test I1: Integration with superpowers:brainstorming

**Given** agent WITH best-practice-introduction skill
**And** agent WITH superpowers:brainstorming
**When** user says: "We want to improve our code quality"
**Then** agent uses brainstorming to:

1. Present rollout strategy options (opt-in pilot, phased enforcement, etc.)
2. Ask about team size, complexity, urgency, risk tolerance
3. Surface tradeoffs between strategies
4. Select appropriate strategy based on context

**Evidence:**

- [ ] Multiple strategies presented
- [ ] Context questions asked
- [ ] Tradeoffs surfaced
- [ ] Strategy selection justified

### Test I2: Integration with superpowers:verification-before-completion

**Given** agent WITH best-practice-introduction skill
**And** agent WITH superpowers:verification-before-completion
**When** phase completion is claimed
**Then** agent verifies:

1. Success criteria met with evidence
2. Feedback collected and documented
3. Rollout tracking updated in `docs/practice-rollout.md`
4. Decision to proceed to next phase justified

**Evidence:**

- [ ] Success criteria verified
- [ ] Feedback documented
- [ ] Tracking updated
- [ ] Progression decision recorded

## Rationalizations Closure

### Test RC1: "Must apply immediately everywhere"

**Given** agent WITH best-practice-introduction skill
**When** rationalization: "Must apply immediately everywhere"
**Then** agent responds:

- "Immediate rollout causes chaos. Even urgent changes need support structure."
- Proposes immediate-with-baseline approach
- Defines support and communication plan

### Test RC2: "No time for pilot phase"

**Given** agent WITH best-practice-introduction skill
**When** rationalization: "No time for pilot phase"
**Then** agent responds:

- "Pilot takes 1-2 weeks, saves months of failed adoption."
- Offers compressed pilot option
- Shows cost of failed adoption

### Test RC3: "Already paid for it"

**Given** agent WITH best-practice-introduction skill
**When** rationalization: "Already paid for it, must use it"
**Then** agent responds:

- "Sunk cost fallacy. Bad tools cost more in lost productivity than license fees."
- Proposes pilot of alternative
- Frames decision on productivity, not cost

### Test RC4: "Mandate is non-negotiable"

**Given** agent WITH best-practice-introduction skill
**When** rationalization: "Mandate is non-negotiable"
**Then** agent responds:

- "Question implementation approach, not decision. Phased rollout respects mandate."
- Proposes how to execute mandate successfully
- Defines success criteria beyond compliance

### Test RC5: "Team must adapt to the tool"

**Given** agent WITH best-practice-introduction skill
**When** rationalization: "Team must adapt to the tool"
**Then** agent responds:

- "Tools should adapt to teams or fail. Listen to feedback in pilot phase."
- Proposes feedback collection in pilot
- Suggests tool configuration adjustments

## Verification Assertions

Each GREEN test should verify:

- [ ] Phased rollout plan defined (minimum 2 phases)
- [ ] Each phase has scope, enforcement level, duration, success criteria
- [ ] Rollback criteria defined with measurable thresholds
- [ ] Communication plan included
- [ ] Success metrics defined
- [ ] Adoption support specified (documentation, training, office hours)
- [ ] Rationalizations closed (cannot bypass with excuses)
- [ ] Progress tracked in `docs/practice-rollout.md`
