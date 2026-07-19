# Blocked Work Escalation

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Work items with `blocked` label must not languish indefinitely. This section defines
escalation rules to ensure timely resolution or re-prioritization.

### Escalation Threshold

**Default: 2 business days** without resolution plan or active progress on blocker.

Time starts when `blocked` label is added. Clock pauses if:

- Blocker has active work in progress
- Resolution plan documented and being executed
- Explicit extension approved by Tech Lead

### Escalation Path

When blocked duration exceeds threshold:

1. **Day 2**: Notify Tech Lead (or designated escalation contact)
2. **Day 5**: Escalate to Scrum Master for re-prioritization decision
3. **Day 10**: Flag for management visibility in sprint review

**Notification template:**

```text
Blocked Work Escalation

Issue #N has been blocked for X days.

Blocker: #M (or external dependency description)
Blocked since: YYYY-MM-DD
Current status: [waiting/investigating/no progress]

Requested action: [resolve blocker/re-prioritize/split work]
```

### Finding Long-Blocked Items

**GitHub:**

```bash
# Find all blocked issues
gh issue list --label "blocked" --state open --json number,title,createdAt,labels

# Find issues blocked for more than 2 days (requires jq date processing)
gh issue list --label "blocked" --state open --json number,title,updatedAt --jq '
  .[] | select(
    (now - (.updatedAt | fromdateiso8601)) / 86400 > 2
  ) | "\(.number): \(.title) (updated \(.updatedAt))"
'

# Simple list for manual review
gh issue list --label "blocked" --state open --limit 20
```

**Blocked items report script:**

```bash
#!/bin/bash
# blocked-report.sh - Report on blocked work items

echo "=== Blocked Work Items Report ==="
echo "Generated: $(date)"
echo ""

BLOCKED=$(gh issue list --label "blocked" --state open --json number,title,updatedAt)
COUNT=$(echo "$BLOCKED" | jq 'length')

echo "Total blocked items: $COUNT"
echo ""

if [ "$COUNT" -gt 0 ]; then
  echo "Issues requiring attention:"
  echo "$BLOCKED" | jq -r '.[] | "- #\(.number): \(.title)"'
fi
```

### Re-prioritization Guidance

When blockers persist beyond escalation threshold, choose one of these actions:

| Action           | When to Use                            | How                                        |
| ---------------- | -------------------------------------- | ------------------------------------------ |
| **Wait**         | Blocker being actively resolved        | Document expected resolution date          |
| **Unblock**      | Can proceed with partial scope         | Remove blocked work, document limitation   |
| **Deprioritize** | Lower priority than blocker resolution | Move to backlog, reduce priority label     |
| **Split**        | Some work can proceed independently    | Create child issues for unblocked portions |

**Decision flowchart:**

```text
Is blocker being actively worked?
  YES → Wait (document ETA)
  NO → Can work proceed with reduced scope?
    YES → Unblock (document limitation)
    NO → Is this work more important than resolving blocker?
      YES → Prioritize blocker resolution
      NO → Deprioritize or Split
```

### Blocked Work in Ceremonies

**Daily Standup:**

- Review all blocked items
- Confirm blocker status and ETA
- Identify items approaching escalation threshold

**Sprint Planning (Scrum mode):**

- Do not commit blocked items to sprint
- Include blocker resolution in sprint if critical

**Sprint Review:**

- Report long-blocked items to stakeholders
- Request prioritization decisions for persistent blockers

### Customizing Escalation Rules

Teams can customize escalation in their ways-of-working:

```markdown
# docs/ways-of-working/escalation-policy.md

## Blocked Work Escalation

### Thresholds

- Warning: 1 business day
- Tech Lead escalation: 3 business days
- Management visibility: 1 week

### Escalation Contacts

- Primary: @tech-lead-username
- Secondary: @scrum-master-username
- Management: @engineering-manager-username

### Exceptions

- External dependency blockers: 5 business day threshold
- P0/P1 blockers: Same-day escalation
```

Reference your custom policy in AGENTS.md or repository documentation.
