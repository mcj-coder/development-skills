# Assignment Workflow

## Pull-Based Kanban Pattern

Team members self-assign work items when taking ownership, then unassign after completing their phase to signal handoff to the next role.

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

## Common Patterns

### Starting Work

1. Find next unassigned ticket in appropriate state
2. Verify ticket has all needed context
3. Self-assign ticket
4. Begin work

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
