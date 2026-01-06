# Effort Estimation

## Overview

Effort measures the work required to address technical debt. Lower effort
combined with high impact/risk identifies quick wins. All estimates require
consideration of complexity factors.

## Effort Factors

### Code Complexity

How complex is the change required?

- Lines of code affected
- Number of files/modules involved
- Algorithmic complexity
- Existing test coverage

### Dependencies

What dependencies exist?

- Other systems that must change
- Database migrations required
- External API changes
- Configuration changes across environments

### Team Expertise

How familiar is the team with this area?

- Domain knowledge required
- Technology expertise needed
- Learning curve for new approaches
- Key person availability

### Risk of Change

What is the risk of introducing regressions?

- Test coverage of affected area
- Coupling with other components
- Rollback complexity
- Deployment complexity

## Effort Scoring Scale

| Score | Level    | Duration  | Description                                  |
| ----- | -------- | --------- | -------------------------------------------- |
| 1     | Minimal  | < 1 day   | Simple change, well understood, good tests   |
| 2     | Low      | 1-2 days  | Straightforward change, some complexity      |
| 3     | Moderate | 3-5 days  | Notable complexity, multiple components      |
| 4     | High     | 1-2 weeks | Significant work, dependencies, coordination |
| 5     | Major    | 2+ weeks  | Large effort, high risk, many dependencies   |

## Effort Assessment Template

```markdown
## Effort Assessment: [Debt Item Name]

### Code Complexity

- Files affected: [count]
- Lines of code estimate: [count]
- Complexity: [low/medium/high]

### Dependencies

- Internal dependencies: [list]
- External dependencies: [list]
- Database changes: [yes/no, details]
- Config changes: [yes/no, details]

### Team Expertise

- Domain knowledge: [available/needs research]
- Technology skills: [available/needs learning]
- Key person required: [yes/no]

### Risk of Change

- Test coverage: [percentage or level]
- Rollback plan: [simple/complex]
- Deployment complexity: [low/medium/high]

### Overall Effort Score: [1-5]

### Estimated Duration: [days/weeks]
```

## Quick Win Identification

Quick wins are debt items with high priority score and low effort:

**Quick Win Criteria:**

- Impact >= 4 OR Risk >= 4
- Effort <= 2
- Priority Score > 4.0

**Quick Win Formula:**

```text
Priority Score = (Impact + Risk) / Effort

Quick Win: Score > 4.0 AND Effort <= 2
```

### Quick Win Examples

| Debt Item                     | Impact | Risk | Effort | Score | Quick Win? |
| ----------------------------- | ------ | ---- | ------ | ----- | ---------- |
| Add missing API documentation | 4      | 2    | 1      | 6.0   | Yes        |
| Fix flaky test                | 3      | 3    | 2      | 3.0   | No         |
| Update deprecated library     | 3      | 5    | 2      | 4.0   | Yes        |
| Refactor monolith to services | 5      | 4    | 5      | 1.8   | No         |
| Remove hardcoded credentials  | 2      | 5    | 1      | 7.0   | Yes        |

## Estimation Techniques

### Reference Class Forecasting

Compare to similar past work:

- "Last time we updated a library, it took X days"
- "Previous documentation tasks averaged X hours"
- "Similar refactoring took X weeks"

### Three-Point Estimation

For uncertain efforts, use range:

- Optimistic: Best case scenario
- Pessimistic: Worst case scenario
- Most Likely: Expected scenario

**Expected = (Optimistic + 4\*MostLikely + Pessimistic) / 6**

### Spike First

For highly uncertain efforts:

1. Time-box a spike (1-2 days)
2. Investigate the actual complexity
3. Re-estimate after spike
4. Decide whether to proceed

## Effort Multipliers

Apply multipliers for special circumstances:

| Factor                          | Multiplier | When to Apply                  |
| ------------------------------- | ---------- | ------------------------------ |
| New team member doing work      | 1.5x       | Learning curve included        |
| Cross-team coordination         | 1.5x       | Multiple teams must align      |
| Legacy system with no docs      | 2x         | Discovery time required        |
| Production system (no downtime) | 1.5x       | Extra care and staged rollout  |
| First time using technology     | 2x         | Learning and mistakes expected |

## Common Effort Patterns

### Underestimation Traps

Watch for these common underestimation causes:

- "Just a small change" (hidden dependencies)
- "I know this code" (outdated knowledge)
- "We have good tests" (tests don't cover edge cases)
- "Similar to last time" (context differs)

### Right-Sizing Work

| Effort Score | Recommended Approach                          |
| ------------ | --------------------------------------------- |
| 1-2          | Individual developer, within sprint           |
| 3            | Pair programming, dedicated focus time        |
| 4            | Team effort, span sprints, checkpoints        |
| 5            | Project planning, formal tracking, milestones |

## Integration with Impact and Risk

Effort is the denominator in priority scoring:

- Low effort amplifies priority (easy wins)
- High effort reduces priority (needs justification)
- High effort + High impact/risk = Strategic investment

Priority formula: `(Impact + Risk) / Effort`

### Decision Matrix

| Impact+Risk | Effort | Priority | Recommendation          |
| ----------- | ------ | -------- | ----------------------- |
| High (8-10) | Low    | > 4.0    | Do immediately (sprint) |
| High (8-10) | High   | < 2.0    | Plan strategically      |
| Med (5-7)   | Low    | > 2.5    | Include in sprint       |
| Med (5-7)   | High   | < 1.5    | Quarterly roadmap       |
| Low (2-4)   | Any    | < 2.0    | Backlog or ignore       |

See the main SKILL.md for the complete priority framework.
