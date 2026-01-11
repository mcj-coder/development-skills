# Issue-Driven Delivery - Estimation/Sizing Tests

## RED: Failure scenarios (expected without feature)

### Scenario A: Large work item not identified before sprint

**Context:** Team commits to a work item without sizing; it takes 3x expected effort.

**Baseline failure to record:**

- No sizing guidance in skill
- Large items not identified during refinement
- Sprint commitment unreliable
- No decomposition trigger

**Observed baseline (RED):**

- Sprint goals missed due to underestimated work
- No mechanism to flag oversized items
- Team velocity unpredictable

### Scenario B: Inconsistent sizing across team

**Context:** Different team members use different estimation approaches.

**Baseline failure to record:**

- No standard sizing approaches documented
- No guidance on where to record estimates
- No team agreement on sizing method

**Observed baseline (RED):**

- Velocity tracking unreliable (mixing approaches)
- Sprint planning lacks consistency
- New team members lack onboarding for sizing

## GREEN: Expected behaviour with feature

### Sizing Approaches Documentation

- [ ] Story points documented (Fibonacci: 1, 2, 3, 5, 8, 13)
- [ ] T-shirt sizing documented (XS, S, M, L, XL)
- [ ] Time-based estimates documented (hours/days)
- [ ] Guidance: sizing is optional (team choice)
- [ ] Guidance: pick one approach, use consistently

### When to Size

- [ ] Sizing occurs during refinement phase (before step 7)
- [ ] Sizing is optional but recommended for sprint planning
- [ ] DoR can include sizing as optional item
- [ ] Sizing recorded before implementation begins

### Recording Estimates

- [ ] GitHub: Use project field (Size or Estimate column)
- [ ] Azure DevOps: Use Story Points or Effort field
- [ ] Jira: Use Story Points or Time Estimate field
- [ ] Fallback: Add estimate in issue body or comment

### Decomposition Thresholds

- [ ] Story points: >5 points triggers decomposition recommendation
- [ ] T-shirt sizing: XL or larger triggers decomposition
- [ ] Time-based: >2 days triggers decomposition
- [ ] Threshold is guidance, not hard rule
- [ ] Cross-reference to requirements-gathering for decomposition workflow

### Ways-of-Working Template

- [ ] Template includes sizing preferences section
- [ ] Documents team's chosen approach
- [ ] Documents team's decomposition threshold
- [ ] Documents sizing ceremony timing (planning, refinement)

### Platform-Specific Commands

- [ ] GitHub: Project field commands documented
- [ ] Azure DevOps: Work item field commands documented
- [ ] Jira: Issue field commands documented

## Error Handling Scenarios

### Scenario: Team has no sizing preference

**Expected behaviour:**

- [ ] Skill notes sizing is optional
- [ ] Suggests trying approaches to find fit
- [ ] Provides comparison of approaches
- [ ] Does not block workflow without sizing

### Scenario: Item exceeds decomposition threshold

**Expected behaviour:**

- [ ] Warning displayed during refinement
- [ ] Link to requirements-gathering decomposition section
- [ ] User can proceed (threshold is guidance)
- [ ] Decomposition recommendation logged

## Verification Checklist

### Documentation

- [ ] Sizing approaches section in SKILL.md
- [ ] Decomposition thresholds documented
- [ ] Cross-reference to requirements-gathering exists
- [ ] Ways-of-working template updated

### Platform Coverage

- [ ] GitHub project fields documented
- [ ] Azure DevOps fields documented
- [ ] Jira fields documented

### Integration

- [ ] DoR can include sizing (optional item)
- [ ] Refinement phase mentions sizing timing
- [ ] Sprint planning references sizing data
