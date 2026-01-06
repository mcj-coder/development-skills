# technical-debt-prioritisation - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Ad-hoc Debt Work

**Given** agent WITHOUT technical-debt-prioritisation skill
**And** codebase has multiple technical debt items
**When** user says: "We need to address our technical debt"
**Then** record baseline behaviour:

- Does agent assess impact systematically? (expected: NO - gut feel)
- Does agent quantify risk? (expected: NO - vague concerns)
- Does agent estimate effort? (expected: NO - rough guesses)
- Does agent categorise debt types? (expected: NO - ad-hoc list)
- Rationalizations observed: "This seems important", "We should fix this first"

### Test R2: Time Pressure - Skip Analysis

**Given** agent WITHOUT technical-debt-prioritisation skill
**And** pressure: time ("we have one sprint for debt work")
**When** user says: "Pick which tech debt to tackle this sprint"
**Then** record baseline behaviour:

- Does agent create priority framework? (expected: NO - picks randomly)
- Does agent identify quick wins? (expected: NO - picks familiar items)
- Does agent justify choices with evidence? (expected: NO - opinions only)
- Rationalizations observed: "This feels urgent", "Let's start with something easy"

### Test R3: Political Pressure - Pet Projects

**Given** agent WITHOUT technical-debt-prioritisation skill
**And** pressure: political ("senior dev wants to refactor module X")
**When** user says: "Team lead wants us to prioritise the auth refactor"
**And** other debt items may have higher impact
**Then** record baseline behaviour:

- Does agent compare objectively? (expected: NO - defers to authority)
- Does agent surface tradeoffs? (expected: NO - avoids conflict)
- Does agent require evidence? (expected: NO - accepts assertion)
- Rationalizations observed: "Team lead knows best", "Auth is important"

### Test R4: Large Backlog Paralysis

**Given** agent WITHOUT technical-debt-prioritisation skill
**And** large debt backlog (50+ items)
**When** user says: "Where do we even start with all this debt?"
**Then** record baseline behaviour:

- Does agent create scoring system? (expected: NO - overwhelmed)
- Does agent categorise by type? (expected: NO - flat list)
- Does agent identify patterns? (expected: NO - item by item)
- Rationalizations observed: "There's too much", "Let's just pick something"

### Expected Baseline Failures Summary

- [ ] Agent doesn't use systematic scoring framework
- [ ] Agent doesn't quantify impact, risk, and effort
- [ ] Agent doesn't categorise debt by type
- [ ] Agent doesn't identify quick wins objectively
- [ ] Agent doesn't create roadmap at multiple horizons
- [ ] Agent makes decisions based on gut feel, not evidence
- [ ] Agent doesn't surface tradeoffs transparently

## GREEN Phase - WITH Skill

### Test G1: Three-Dimensional Scoring

**Given** agent WITH technical-debt-prioritisation skill
**When** user says: "Prioritise these debt items: outdated framework, flaky tests, no API docs, circular dependencies"
**Then** agent applies three-dimensional scoring:

For each item, agent assesses:

1. **Impact (1-5):** Business cost, developer friction, user experience
2. **Risk (1-5):** Failure probability, security exposure, compliance
3. **Effort (1-5):** Complexity, dependencies, team expertise

**And** agent calculates priority score:

- Priority = (Impact + Risk) / Effort
- Higher score = higher priority

**And** agent provides evidence for each score:

- Impact: "Outdated framework causes 2-hour debugging sessions weekly"
- Risk: "No security patches available, CVE exposure"
- Effort: "Migration guide available, 3-day estimate"

**And** agent provides completion evidence:

- [ ] Each debt item scored on all three dimensions
- [ ] Evidence provided for each score (not gut feel)
- [ ] Priority calculated using formula
- [ ] Items ranked by priority score
- [ ] Scoring rationale documented

### Test G2: Debt Type Categorisation

**Given** agent WITH technical-debt-prioritisation skill
**When** user provides mixed debt backlog
**Then** agent categorises by type:

| Category       | Items                                      |
| -------------- | ------------------------------------------ |
| Code Quality   | Long methods, duplication, naming issues   |
| Architecture   | Circular dependencies, tight coupling      |
| Testing        | Flaky tests, coverage gaps                 |
| Documentation  | Missing API docs, stale README             |
| Infrastructure | Manual deployments, slow CI                |
| Dependencies   | Outdated framework, unmaintained libraries |
| Security       | Hardcoded credentials, missing validation  |

**And** agent analyses patterns:

- Most debt in which category?
- Systemic causes identified?
- Category-specific remediation strategies?

**And** agent provides completion evidence:

- [ ] Each item categorised by type
- [ ] Categories aligned with standard taxonomy
- [ ] Patterns identified across categories
- [ ] Systemic causes surfaced
- [ ] Category-specific strategies suggested

### Test G3: Quick Win Identification

**Given** agent WITH technical-debt-prioritisation skill
**And** debt backlog with mixed effort levels
**When** user says: "Find quick wins we can tackle this sprint"
**Then** agent identifies quick wins using criteria:

- **High Impact (4-5):** Significant cost reduction or improvement
- **Low Effort (1-2):** Can be completed in 1-2 days
- **Low Risk to Change:** Unlikely to cause regressions

**And** agent presents quick wins:

```markdown
## Quick Wins (High Impact, Low Effort)

1. **Add missing API documentation** - Impact: 4, Effort: 1, Score: 8.0
   - Evidence: 5 support tickets/week from missing docs
   - Effort: Template exists, 4 endpoints to document

2. **Fix flaky test in CI** - Impact: 4, Effort: 2, Score: 4.0
   - Evidence: Test fails randomly 1 in 10 runs, blocks deploys
   - Effort: Known race condition, fix identified
```

**And** agent provides completion evidence:

- [ ] Quick wins identified using objective criteria
- [ ] Each quick win scored with evidence
- [ ] Quick wins sorted by priority score
- [ ] Sprint capacity considered
- [ ] Dependencies between items noted

### Test G4: Roadmap Planning

**Given** agent WITH technical-debt-prioritisation skill
**And** prioritised debt backlog
**When** user says: "Create a debt remediation roadmap"
**Then** agent creates multi-horizon roadmap:

**Sprint (2 weeks):**

- Quick wins (score > 4.0, effort <= 2)
- Blocking issues (risk 5)
- Items: [list with scores]

**Quarter (3 months):**

- Medium priority (score 2.0-4.0)
- Systematic improvements
- Items grouped by category

**6-month:**

- Large architectural changes (effort 4-5)
- Strategic improvements
- Dependencies on quarterly work

**And** agent includes:

- Capacity assumptions
- Dependencies between items
- Success metrics for each horizon
- Review cadence recommendations

**And** agent provides completion evidence:

- [ ] Roadmap covers sprint, quarter, 6-month horizons
- [ ] Items assigned to appropriate horizon based on score and effort
- [ ] Dependencies mapped
- [ ] Capacity assumptions stated
- [ ] Success metrics defined
- [ ] Review cadence recommended

### Test G5: Evidence-Based Justification

**Given** agent WITH technical-debt-prioritisation skill
**When** user asks: "Why should we prioritise X over Y?"
**Then** agent provides evidence-based comparison:

```markdown
## Comparison: X vs Y

| Dimension | X (Outdated Framework)  | Y (Refactor Auth) |
| --------- | ----------------------- | ----------------- |
| Impact    | 5 (security + velocity) | 3 (code quality)  |
| Risk      | 5 (CVE exposure)        | 2 (no incidents)  |
| Effort    | 3 (migration guide)     | 4 (complex)       |
| Score     | 3.3                     | 1.25              |

**Evidence for X:**

- 3 CVEs in current version (security bulletin links)
- 2 hours/week debugging compatibility issues (ticket analysis)
- Migration guide available (link)

**Evidence for Y:**

- No security incidents related to auth
- Code complexity is high but stable
- Refactor would require 4 weeks

**Recommendation:** Prioritise X (higher score, concrete evidence of harm)
```

**And** agent provides completion evidence:

- [ ] Side-by-side comparison with scores
- [ ] Evidence cited for each dimension
- [ ] Recommendation based on evidence, not opinion
- [ ] Tradeoffs made transparent

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH technical-debt-prioritisation skill
**And** user says: "No time for analysis, just pick something"
**When** agent is tempted to skip scoring
**Then** agent responds:

- Acknowledges time constraint
- Offers rapid scoring (15-minute assessment)
- Explains quick wins need scoring to identify correctly
- Proposes: "5 minutes per item, top 5 items only"

**And** agent does NOT:

- Skip scoring entirely
- Pick based on gut feel
- Defer to loudest voice

### Test P2: Resist Political Pressure

**Given** agent WITH technical-debt-prioritisation skill
**And** user says: "Senior dev insists auth refactor is most important"
**When** agent is tempted to defer to authority
**Then** agent responds:

- Respects team dynamics
- Proposes objective comparison
- Frames as "let's validate with data"
- Surfaces tradeoffs transparently

**And** agent does NOT:

- Automatically prioritise authority's choice
- Hide comparison results
- Avoid discussing tradeoffs

### Test P3: Resist Scope Creep

**Given** agent WITH technical-debt-prioritisation skill
**And** user says: "While we're at it, let's also refactor this other thing"
**When** scope expands during debt work
**Then** agent responds:

- Notes scope expansion
- Scores new item using framework
- Re-prioritises if new item scores higher
- Flags capacity impact

**And** agent does NOT:

- Accept scope creep without scoring
- Ignore capacity constraints
- Let debt work become feature work

## Integration Scenarios

### Test I1: Integration with verification-before-completion

**Given** agent WITH technical-debt-prioritisation skill
**And** agent WITH superpowers:verification-before-completion
**When** debt remediation is "complete"
**Then** agent:

1. Verifies debt item addressed (not just started)
2. Confirms impact reduction (metrics if available)
3. Updates debt backlog status
4. Runs relevant tests

**Evidence:**

- [ ] Verification commands run
- [ ] Debt item marked resolved with evidence
- [ ] Impact metrics captured (before/after)
- [ ] Tests passing

### Test I2: Periodic Review Integration

**Given** agent WITH technical-debt-prioritisation skill
**When** quarterly review occurs
**Then** agent:

1. Re-scores remaining debt items
2. Identifies new debt accumulated
3. Updates roadmap based on progress
4. Reports on debt trend (increasing/decreasing)

**Evidence:**

- [ ] Backlog re-prioritised
- [ ] New items scored and categorised
- [ ] Roadmap updated
- [ ] Debt trend reported

## Rationalizations Closure

### Test RC1: "This feels urgent"

**Given** agent WITH technical-debt-prioritisation skill
**When** user or agent rationalizes: "This feels urgent"
**Then** agent responds:

- "Let's quantify the urgency. What's the risk if we don't address this?"
- Applies risk scoring framework
- Compares to other items objectively

### Test RC2: "We should just pick something"

**Given** agent WITH technical-debt-prioritisation skill
**When** user or agent rationalizes: "We should just pick something"
**Then** agent responds:

- "Quick scoring takes 15 minutes and prevents wasted effort"
- Offers rapid assessment option
- Shows cost of wrong prioritisation

### Test RC3: "Team lead knows best"

**Given** agent WITH technical-debt-prioritisation skill
**When** user or agent rationalizes: "Team lead knows best"
**Then** agent responds:

- "Team lead's input is valuable. Let's validate with data."
- Proposes objective comparison
- Frames as supporting, not challenging

### Test RC4: "There's too much debt"

**Given** agent WITH technical-debt-prioritisation skill
**When** user or agent rationalizes: "There's too much debt to prioritise"
**Then** agent responds:

- "Large backlogs especially need prioritisation. Focus on top 10 first."
- Uses categories to manage complexity
- Identifies quick wins to build momentum

## Verification Assertions

Each GREEN test should verify:

- [ ] Three-dimensional scoring applied (impact, risk, effort)
- [ ] Priority calculated with formula
- [ ] Evidence provided for scores
- [ ] Debt categorised by type
- [ ] Quick wins identified objectively
- [ ] Roadmap spans multiple horizons
- [ ] Decisions evidence-based, not opinion-based
- [ ] Tradeoffs made transparent
- [ ] Rationalizations closed (cannot be bypassed)
