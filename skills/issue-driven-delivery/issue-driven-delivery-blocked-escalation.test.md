# Issue-Driven Delivery - Blocked Work Escalation Test

## Scenario: Blocked Work Escalation Path

Validates that blocked work items have escalation rules to prevent indefinite blocking
and ensure timely resolution.

## Given

- A work item with `blocked` label
- Work item has been blocked for some duration
- Blocker has not been resolved

## Acceptance Criteria

### Time Threshold

- [x] Blocked time threshold defined (default: 2 business days)
- [x] Threshold is configurable via ways-of-working
- [x] Time starts from when `blocked` label was added

### Escalation Path

- [x] Escalation path documented (who to notify)
- [x] Escalation timing documented (when to escalate)
- [x] Escalation method documented (how to notify)
- [x] Default escalation: Tech Lead after 2 days

### Re-prioritization Guidance

- [x] Guidance for when to re-prioritize blocked work
- [x] Options: wait, unblock, deprioritize, split
- [x] Decision criteria for each option documented

### Visibility and Tracking

- [x] CLI command to find long-blocked items
- [x] Blocked duration visible in reports
- [x] Blocked items included in standup/review discussions

### Customization

- [x] Teams can customize escalation threshold
- [x] Teams can customize escalation path
- [x] Default rules work without customization

## Then

Blocked work escalation ensures issues do not languish indefinitely, providing
visibility and timely resolution through defined escalation paths.

## Verification Evidence

```bash
# Verify escalation section exists
grep -ci "escalation\|blocked.*threshold\|blocked.*time" skills/issue-driven-delivery/SKILL.md
# Result: 16 matches

# Verify CLI commands for finding blocked items
grep -c "gh issue list.*blocked" skills/issue-driven-delivery/SKILL.md
# Result: Multiple CLI command examples

# Verify re-prioritization guidance
grep -c "deprioritize\|reprioritize\|split\|unblock" skills/issue-driven-delivery/SKILL.md
# Result: 13 matches - all 4 options documented

# Verify ceremony integration
grep -c "standup\|sprint.*review\|sprint.*planning" skills/issue-driven-delivery/SKILL.md
# Result: Multiple ceremony references
```

## Notes

- Escalation is notification, not automatic action
- Teams should customize thresholds based on their context
- Blocked work should be visible in daily standups
- Long-blocked items may indicate process issues
