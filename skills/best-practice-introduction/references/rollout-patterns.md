# Rollout Patterns Reference

## Rollout Strategy Options

### Opt-In Pilot

Best for: New tooling, linting rules, optional improvements.

**How it works:**

1. Recruit 1-2 volunteer teams
2. Run pilot for 1-2 weeks
3. Gather feedback and adjust
4. Expand to broader adoption

**Tradeoffs:**

- Safe, low risk
- Slow adoption timeline
- Relies on volunteer availability

### Phased by Team/Component

Best for: Architectural patterns, testing approaches.

**How it works:**

1. Start with newest/smallest component
2. Validate pattern with real usage
3. Migrate incrementally by component
4. Allow hybrid state during migration

**Tradeoffs:**

- Smooth transition
- Longer timeline
- Requires component isolation

### Phased by Enforcement Level

Best for: Linting, quality gates, CI checks.

**How it works:**

1. Warning level first (informational)
2. Error level after stabilization
3. Pre-commit hooks after CI proven

**Tradeoffs:**

- Educational approach
- May be ignored initially
- Clear progression path

### Immediate with Baseline

Best for: Security requirements, compliance mandates.

**How it works:**

1. Apply immediately to all
2. Baseline existing violations
3. Enforce only on new/modified code
4. Remediate baseline incrementally

**Tradeoffs:**

- Fast deployment
- Requires exception handling
- No rollback for security (fix forward)

## Phase Template

```markdown
### Phase N: {Phase Name}

- **Scope:** {Teams/Components/Repos}
- **Enforcement:** {Informational | Warning | Error}
- **Duration:** {Start - End dates}
- **Success Criteria:**
  - {Metric 1}: {Target value}
  - {Metric 2}: {Target value}
- **Rollback Trigger:** {Condition that stops rollout}
- **Status:** {Not Started | In Progress | Complete}
```

## Rollback Criteria Examples

Define specific, measurable rollback triggers:

| Category     | Trigger            | Threshold                    |
| ------------ | ------------------ | ---------------------------- |
| Productivity | PR velocity drop   | >30% reduction               |
| Adoption     | Exemption requests | >3 teams request             |
| Technical    | False positives    | Critical blockers discovered |
| Sentiment    | Team satisfaction  | Survey score <3/5            |

## Communication Plan Template

```markdown
## Communication Plan

- **Announcement:** {Channel} on {Date}
  - What's changing
  - Why it matters
  - Timeline overview

- **Feedback Collection:**
  - Survey after pilot (Week 2)
  - Office hours weekly during rollout
  - Slack channel for questions

- **Progress Updates:**
  - Weekly status in {Channel}
  - Metrics dashboard at {Link}
```

## Success Metrics

Track adoption and impact:

- **Adoption Rate:** % of teams/repos using practice
- **Violation Trend:** Increasing/Stable/Decreasing
- **Developer Satisfaction:** Survey scores
- **Support Burden:** Questions per week

## Conventions Tracking

Update `docs/practice-rollout.md` with:

```markdown
## {Practice Name} Rollout

**Status:** {Phase 1 | Phase 2 | Complete}
**Started:** {YYYY-MM-DD}
**Target Completion:** {YYYY-MM-DD}

[Phase details using template above]

**Resources:**

- Documentation: {Link}
- Training: {Link}
- Support: {Contact/Channel}
```

For decisions to skip phased approach, update `docs/practice-decisions.md`:

```markdown
### {Practice Name} - Immediate Rollout

- **Practice:** {Name and description}
- **Decision:** Immediate rollout without pilot
- **Rationale:** {Reason for skipping phases}
- **Date:** {YYYY-MM-DD}
- **Risk Accepted:** {Description of risks}
- **Mitigation:** {How risks are addressed}
- **Review Date:** {When to reassess}
```

## Greenfield vs Brownfield

### Greenfield (New Projects)

- Establish practices from project start
- Can use strict enforcement immediately
- Pilot with first feature/component
- Fast adoption (no migration needed)

### Brownfield (Existing Projects)

- Requires baseline of existing violations
- Phased enforcement (warnings then errors)
- Longer timeline for full adoption
- Focus on "new/modified code first"
- Document legacy exceptions
- Incremental remediation of baseline
