# Impact Assessment

## Overview

Impact measures the cost of technical debt to the business, developers, and
users. Higher impact means greater urgency. All scores require evidence.

## Impact Dimensions

### Business Impact

How does this debt affect business outcomes?

- Revenue impact (delays, outages, lost customers)
- Operational costs (manual workarounds, support tickets)
- Opportunity cost (can't build new features)
- Compliance (regulatory requirements, audits)

### Developer Experience Impact

How does this debt affect team productivity?

- Time lost debugging or working around issues
- Onboarding difficulty for new team members
- Cognitive load and context switching
- Morale and frustration levels

### User Experience Impact

How does this debt affect end users?

- Performance degradation
- Feature limitations
- Error frequency
- Workarounds required

## Impact Scoring Scale

| Score | Level    | Description                        | Evidence Examples                   |
| ----- | -------- | ---------------------------------- | ----------------------------------- |
| 1     | Minimal  | Cosmetic issue, no measurable cost | Minor naming inconsistency          |
| 2     | Low      | Small friction, workarounds easy   | Occasional confusion, < 30 min/week |
| 3     | Moderate | Regular friction, measurable cost  | 1-2 hours/week lost, some tickets   |
| 4     | High     | Significant cost, blocks work      | 4+ hours/week lost, many tickets    |
| 5     | Critical | Major business impact, urgent      | Revenue impact, outages, compliance |

## Evidence Requirements

Each impact score must be supported by evidence:

### Quantitative Evidence (Preferred)

- Time tracking data (hours spent on workarounds)
- Support ticket counts related to the issue
- Performance metrics (response times, error rates)
- Incident reports and outage duration
- Code churn metrics (files changed frequently due to debt)

### Qualitative Evidence (When Quantitative Unavailable)

- Team survey results (frustration levels)
- Interview quotes from developers
- Customer feedback related to the issue
- Sprint retrospective themes

## Impact Assessment Template

```markdown
## Impact Assessment: [Debt Item Name]

### Business Impact

- Score: [1-5]
- Evidence: [specific data or observations]
- Affected metrics: [revenue, cost, compliance]

### Developer Impact

- Score: [1-5]
- Evidence: [time lost, friction points]
- Team members affected: [count or roles]

### User Impact

- Score: [1-5]
- Evidence: [performance data, feedback]
- Users affected: [count or percentage]

### Overall Impact Score: [average or weighted]
```

## Common Impact Patterns

### High Impact Indicators

- Multiple teams affected by the same issue
- Issue mentioned in multiple retrospectives
- Workarounds documented in wiki or runbooks
- New team members consistently struggle with area
- Incidents trace back to the debt item

### Low Impact Indicators

- Isolated to one rarely-changed area
- No incidents or tickets related to issue
- Team adapted, no ongoing friction
- Only affects edge cases

## Impact vs Visibility

High visibility does not equal high impact:

| Scenario                             | Visibility | Actual Impact  |
| ------------------------------------ | ---------- | -------------- |
| Ugly code in frequently touched file | High       | Low (cosmetic) |
| Security vulnerability in production | Low        | Critical       |
| Slow test suite everyone complains   | High       | Moderate       |
| Outdated dependency with CVEs        | Low        | High           |

**Always score based on actual impact, not visibility or complaints.**

## Integration with Risk and Effort

Impact alone does not determine priority:

- High impact + High risk + Low effort = **Urgent priority**
- High impact + Low risk + High effort = **Plan strategically**
- Low impact + Any risk + Any effort = **Deprioritise**

See the main SKILL.md for the priority calculation formula.
