# sync-project-status - BDD Tests

## Overview

Tests for the GitHub Actions workflow that syncs issue state labels to Project board status.

**Related Files:**

- `.github/workflows/sync-project-status.yml` - Installed workflow
- `skills/issue-driven-delivery/templates/sync-project-status.yml` - Template workflow
- `docs/playbooks/project-sync.md` - Configuration playbook

## Baseline (No Workflow Present)

### Pressure Scenario 1: Manual Project Board Updates

Given an issue has its state label changed
When no sync workflow exists
Then the project board status remains unchanged
And manual intervention is required to update the board
And board state drifts from issue state

### Pressure Scenario 2: Forgotten Status Updates

Given a team uses both issue labels and project boards
When no automation syncs them
Then project board shows stale status
And team members make decisions based on outdated information
And workflow visibility is compromised

### Pressure Scenario 3: Inconsistent Updates

Given multiple team members update issues
When no standardized sync exists
Then project board updates are inconsistent
And some status changes are missed entirely
And board accuracy degrades over time

## Baseline Observations (Simulated)

Without the workflow, typical problems include:

- "The board shows 'Backlog' but the issue is in verification."
- "I moved the issue to implementation but forgot to update the board."
- "The board status doesn't match the label state."
- "We need someone to manually sync the board daily."

## Assertions (Workflow Behavior)

### Trigger Assertions

- [ ] Workflow triggers on `issues.labeled` event
- [ ] Workflow triggers on `issues.unlabeled` event
- [ ] Workflow triggers on `issues.closed` event
- [ ] Workflow triggers on `issues.reopened` event
- [ ] Workflow does NOT trigger on unrelated issue events

### Status Mapping Assertions

- [ ] `state:new-feature` label maps to "Backlog" status
- [ ] `state:grooming` label maps to "Backlog" status
- [ ] `state:refinement` label maps to "In Progress" status
- [ ] `state:implementation` label maps to "In Progress" status
- [ ] `state:verification` label maps to "In Review" status
- [ ] `blocked` label maps to "Blocked" status
- [ ] Closed issue maps to "Done" status

### Priority Rule Assertions

- [ ] `blocked` label takes precedence over all state labels
- [ ] Closed state takes precedence over all labels (including blocked)
- [ ] State labels are evaluated in correct priority order
- [ ] Issues without state labels default to "Backlog"

### Error Handling Assertions

- [ ] GraphQL query failure produces `::warning::` annotation
- [ ] GraphQL mutation failure produces `::error::` annotation
- [ ] Issue not in project is gracefully handled (no error)
- [ ] Workflow completes successfully even when issue not in project

### Permission Assertions

- [ ] Workflow documents permission requirements in header
- [ ] `GITHUB_TOKEN` limitation for Projects V2 is documented
- [ ] PAT requirement for org projects is documented

## Scenarios

### Scenario 1: Label Added - Single State Label

Given issue #N exists in project "Development Skills Kanban"
And issue #N has no state labels
When `state:refinement` label is added to issue #N
Then workflow triggers with event action "labeled"
And workflow determines target status "In Progress"
And workflow queries for project item ID
And workflow finds project item for issue #N
And workflow updates project status to "In Progress"
And workflow logs "Status updated to In Progress"

**Verification:**

```bash
# Before: Check issue is in project with Backlog status
gh issue view N --json projectItems --jq '.projectItems[0].status.name'
# Expected: "Backlog"

# Action: Add label
gh issue edit N --add-label "state:refinement"

# After: Check status changed
gh issue view N --json projectItems --jq '.projectItems[0].status.name'
# Expected: "In Progress"
```

### Scenario 2: Label Removed - Revert to Default

Given issue #N exists in project with status "In Progress"
And issue #N has label `state:implementation`
When `state:implementation` label is removed from issue #N
And no other state labels remain
Then workflow triggers with event action "unlabeled"
And workflow determines target status "Backlog"
And workflow updates project status to "Backlog"

### Scenario 3: Blocked Takes Priority

Given issue #N exists in project with status "In Progress"
And issue #N has label `state:implementation`
When `blocked` label is added to issue #N
Then workflow triggers with event action "labeled"
And workflow determines target status "Blocked"
And workflow updates project status to "Blocked"
And `state:implementation` is NOT evaluated (blocked has priority)

### Scenario 4: Issue Closed

Given issue #N exists in project with status "Blocked"
And issue #N has labels `blocked` and `state:verification`
When issue #N is closed
Then workflow triggers with event action "closed"
And workflow determines target status "Done"
And workflow updates project status to "Done"
And all labels are ignored (closed has highest priority)

### Scenario 5: Issue Not in Project

Given issue #M exists but is NOT in project "Development Skills Kanban"
When `state:refinement` label is added to issue #M
Then workflow triggers with event action "labeled"
And workflow queries for project item ID
And workflow finds NO project item for issue #M
And workflow logs "Issue is not in project 1"
And workflow completes successfully (no error)
And no status update is attempted

### Scenario 6: Multiple State Labels

Given issue #N exists in project with status "Backlog"
When both `state:implementation` and `state:verification` labels exist
Then workflow evaluates labels in priority order
And `state:verification` takes priority over `state:implementation`
And workflow updates project status to "In Review"

**Priority Order:**

1. closed (highest)
2. blocked
3. state:verification
4. state:implementation
5. state:refinement
6. state:grooming
7. state:new-feature
8. (no label) = Backlog (lowest)

### Scenario 7: GraphQL API Failure

Given issue #N exists in project
And GitHub API is experiencing issues
When `state:refinement` label is added
Then workflow attempts GraphQL query
And query fails with API error
And workflow logs `::warning::GraphQL query failed: [error message]`
And workflow sets `found=false`
And workflow exits gracefully (exit 0)

### Scenario 8: Permission Denied (Projects V2)

Given issue #N exists in an organization-level Projects V2 board
And workflow uses `GITHUB_TOKEN` without project scope
When `state:refinement` label is added
Then workflow attempts GraphQL query
And query returns empty result (no permission to read project items)
And workflow logs "Issue is not in project 1"
And workflow completes (appears as if issue not in project)

**Note:** This is expected behavior. The playbook documents that org-level Projects V2
require a PAT with `project` scope.

## Edge Cases

### Edge Case 1: Rapid Label Changes

Given issue #N exists in project
When multiple labels are changed rapidly (within seconds)
Then multiple workflow runs may be triggered
And each run processes with its own snapshot of labels
And final status reflects the most recent label state
And no race condition causes incorrect final state

### Edge Case 2: Label and Close Simultaneously

Given issue #N has `state:implementation` label
When issue is closed AND a label is changed in same action
Then both events may trigger separate workflow runs
And closed event takes priority regardless of order
And final status is "Done"

### Edge Case 3: Reopened Issue

Given issue #N was previously closed with status "Done"
When issue #N is reopened
Then workflow triggers with event action "reopened"
And workflow evaluates current labels
And status is set based on labels (or Backlog if no state labels)

## Test Evidence Format

For each test scenario, record:

```markdown
### Test: [Scenario Name]

**Date:** YYYY-MM-DD
**Issue:** #N
**Initial State:** [status before test]
**Action:** [what was done]
**Expected:** [expected outcome]
**Actual:** [actual outcome]
**Workflow Run:** [run ID or link]
**Status:** PASS/FAIL
```

## Regression Checklist

Use this checklist when modifying the workflow:

- [ ] All trigger events still fire correctly
- [ ] All label-to-status mappings work
- [ ] Priority order is maintained
- [ ] Blocked label overrides state labels
- [ ] Closed state overrides all labels
- [ ] Error handling produces correct annotations
- [ ] Issue not in project is handled gracefully
- [ ] No breaking changes to template configuration
