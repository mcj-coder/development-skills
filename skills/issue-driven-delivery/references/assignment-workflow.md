# Assignment Workflow

## Pull-Based Kanban Pattern

Team members self-assign work items when taking ownership, then unassign after completing their phase to signal
handoff to the next role.

**Pattern**: Unassigned → Self-Assign → Work → Unassign → Next person pulls

**Benefits:**

- Clear ownership: One person responsible at a time
- Visual work queues: Unassigned tickets are ready to pull
- Prevent bottlenecks: No hoarding of assigned tickets
- Smooth handoffs: Unassignment signals completion

## Assignment by State

### New Feature State (Unassigned)

**Status**: Awaiting refinement
**Ready for**: Tech Lead to pull and refine

**When to pick up**: When you have capacity to create a plan and need next work item

**Action**: Self-assign and transition to Refinement state

### Refinement State (Tech Lead Assigned)

**Status**: Plan creation and approval in progress
**Assigned to**: Tech Lead (or person creating the plan)

**Responsibilities:**

- Create implementation plan
- Post plan for approval
- Respond to approval questions and feedback
- Iterate on design based on feedback
- Add sub-tasks after approval

**Approval Feedback Loop:**

- **Stay assigned** during the entire refinement phase
- Feedback, questions, or "continue" = still in refinement, keep working
- Only unassign when you see explicit "approved" or "LGTM" comment
- If revisions needed, update design and re-post link in same issue thread
- Assignment stays with refiner until approval received

**Handoff**: After explicit plan approval, unassign ticket and transition to Implementation

### Implementation State (Developer Assigned)

**Status**: Ready for development work
**Ready for**: Developer to pull and implement

**When to pick up**: When you have capacity to implement and need next work item

**Responsibilities:**

- Execute all plan tasks
- Post evidence for each sub-task
- Complete all sub-tasks
- Get sub-task approvals

**Handoff**: After all sub-tasks complete, unassign ticket and transition to Verification

### Verification State (QA Assigned)

**Status**: Ready for testing and validation
**Ready for**: QA to pull and verify

**When to pick up**: When you have capacity to verify and need next work item

**Responsibilities:**

- Verify acceptance criteria
- Test implemented functionality
- Review evidence and sub-task completion
- Post verification results

**Handoff**: After verification complete, close work item (auto-unassigns)

**Exception**: If revisions needed, unassign and transition back to Implementation

## Platform-Specific CLI Commands

### GitHub (using gh CLI)

**Self-assign current user:**

```bash
gh issue edit <issue-number> --add-assignee @me
```

**Unassign current user:**

```bash
gh issue edit <issue-number> --remove-assignee @me
```

**Check current assignment:**

```bash
gh issue view <issue-number> --json assignees --jq '.assignees[].login'
```

**Find next unassigned ticket in specific state:**

```bash
# Find unassigned tickets in implementation state
gh issue list --label "state:implementation" --assignee "" --limit 5

# Find unassigned tickets in verification state
gh issue list --label "state:verification" --assignee "" --limit 5
```

**Combined state transition with assignment:**

```bash
# Transition to implementation and unassign
gh issue edit 30 --remove-assignee @me --add-label "state:implementation" --remove-label "state:refinement"

# Self-assign and transition to refinement
gh issue edit 30 --add-assignee @me --add-label "state:refinement" --remove-label "state:new-feature"
```

### Azure DevOps (using az devops CLI)

**Self-assign current user:**

```bash
az boards work-item update --id <work-item-id> --assigned-to @me
```

**Unassign:**

```bash
az boards work-item update --id <work-item-id> --assigned-to ""
```

**Find unassigned work items:**

```bash
az boards work-item query --wiql "SELECT [System.Id], [System.Title] FROM WorkItems WHERE [System.AssignedTo] = '' AND [System.State] = 'Active'"
```

### Jira (using jira CLI)

**Self-assign current user:**

```bash
jira issue assign <issue-key> $(jira me)
```

**Unassign:**

```bash
jira issue assign <issue-key> --default
```

**Find unassigned issues:**

```bash
jira issue list --jql "assignee is EMPTY AND status = 'In Progress'"
```

## WIP Limit Enforcement

Work-In-Progress (WIP) limits prevent bottlenecks and context switching by capping how many
tickets one person can have assigned simultaneously.

### Default WIP Limit

**Default: 2 tickets per person** in any in-progress state (refinement, implementation, verification).

This default balances productivity (allows for blocked ticket + active work) with focus (prevents
over-commitment).

### Validation Before Self-Assignment

Before self-assigning a new ticket, check your current assignment count:

**GitHub:**

```bash
# Check how many tickets you currently have assigned
MY_ASSIGNED=$(gh issue list --assignee @me --state open --label "state:refinement,state:implementation,state:verification" --json number --jq 'length')
echo "Currently assigned: $MY_ASSIGNED tickets"

# Only proceed if under WIP limit
if [ "$MY_ASSIGNED" -ge 2 ]; then
  echo "⚠️ WIP limit reached ($MY_ASSIGNED/2). Complete existing work before taking new tickets."
  exit 1
fi
```

**Azure DevOps:**

```bash
# Count assigned in-progress items
az boards work-item query --wiql "SELECT [System.Id] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.State] IN ('Active', 'In Progress')" --query "workItems | length(@)"
```

**Jira:**

```bash
# Count assigned in-progress issues
jira issue list --jql "assignee = currentUser() AND status IN ('In Progress', 'In Review')" --plain --columns key | wc -l
```

### When WIP Limit Exceeded

If your current assignment count equals or exceeds the WIP limit:

1. **STOP** - Do not self-assign new work
2. **Review** - Check your assigned tickets for blockers or handoff opportunities
3. **Complete or hand off** - Either finish current work or unassign if blocked
4. **Then proceed** - Only take new work after creating capacity

**Error message pattern:**

```text
⚠️ WIP limit exceeded (2/2 tickets assigned)
Cannot self-assign issue #N.

Current assignments:
- #123: feat: implement user auth (state:implementation)
- #456: fix: resolve login timeout (state:implementation)

Actions:
1. Complete one of your current tickets, or
2. Unassign a blocked ticket (post blocker comment first), or
3. Request WIP limit increase from Tech Lead
```

### Configuring WIP Limits

WIP limits can be customized per team or repository. Document the decision in one of these locations:

**Option 1: ADR** (recommended for significant deviation from default)

```yaml
# docs/adr/0003-wip-limits.md
---
name: wip-limits
decision: WIP limit of 3 tickets per developer, 1 for Tech Lead during planning sprints
status: accepted
---
```

**Option 2: Ways of Working** (simpler)

```markdown
# docs/ways-of-working/team-agreements.md

## WIP Limits

- Developers: 3 tickets
- Tech Lead: 1 ticket during sprint planning, 2 otherwise
- QA: 4 tickets (verification is typically faster)
```

**Option 3: AGENTS.md** (for agent-specific enforcement)

```markdown
## WIP Limits

Agents must respect WIP limits: maximum 2 tickets assigned at any time.
```

### WIP Limit Exceptions

Temporary exceptions are allowed with explicit approval:

1. **Urgent P0/P1 work** - May exceed limit for critical fixes (document reason)
2. **Handoff coordination** - Brief overlap during transitions is acceptable
3. **Team capacity** - Tech Lead may approve temporary increase

Document any exception in the ticket comment thread.

## Common Patterns

### Starting Work

1. **Check WIP limit** - Verify you have capacity for new work
2. Find next unassigned ticket in appropriate state
3. Verify ticket has all needed context
4. Self-assign ticket
5. Begin work

### Completing Your Phase

1. Finish all responsibilities for current state
2. Post final deliverable/evidence
3. Unassign yourself
4. Transition to next state
5. Ticket now ready for next person to pull

### Handling Interruptions

**If you need to step away mid-work:**

- Post comment explaining current status
- Unassign yourself
- Ticket returns to queue for someone else to pick up

**If you're blocked:**

- Keep assignment (you're still responsible)
- Post comment explaining blocker
- Tag person who can unblock
- Once unblocked, continue work

### Finding Next Work

**Priority order:**

1. Tickets you previously worked on (in comments/history) needing revisions
2. Highest priority unassigned tickets in your role's state
3. Oldest unassigned tickets if priorities equal

## Role Recommendations

**These are recommendations, not requirements.** Teams should adapt based on their structure.

- **New Feature → Refinement**: Tech Lead, Architect, Product Owner
- **Refinement → Implementation**: Developer, Engineer
- **Implementation → Verification**: QA, Tester, Developer (peer review)

**Small teams**: Same person may handle multiple roles - just follow the assignment pattern for clarity.

## Anti-Patterns to Avoid

**Don't:**

- Assign tickets to other people (violates pull-based pattern)
- Keep tickets assigned "just in case" (blocks others)
- Take multiple assigned tickets simultaneously (creates WIP bottleneck)
- Skip unassignment at handoff (unclear who's responsible)
- Work on unassigned tickets without assigning (invisible work)
- Unassign during approval feedback before getting explicit approval

**Do:**

- Let people self-assign when ready
- Unassign promptly when done
- Limit work-in-progress per person
- Make ownership visible through assignment
- Stay assigned during entire phase (including feedback loops)
