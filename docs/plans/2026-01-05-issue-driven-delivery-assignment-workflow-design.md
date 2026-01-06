# Issue-Driven Delivery Assignment Workflow Design

**Date:** 2026-01-05
**Status:** Design
**Related Skill:** `skills/issue-driven-delivery/SKILL.md`

## Goal

Add pull-based kanban assignment workflow to the `issue-driven-delivery` skill to enable clear ownership handoffs
and work coordination across team roles (Tech Lead, Developer, QA).

## Problem Statement

The current `issue-driven-delivery` skill has well-defined state transitions (New → Refinement → Implementation →
Verification → Complete) but provides no guidance on work item assignment. This creates ambiguity:

- Who is responsible for a ticket at any given time?
- How do team members know which tickets are ready to be picked up?
- When should handoffs occur between roles (Tech Lead → Developer → QA)?

## Requirements

1. **Pull-based kanban pattern**: Team members self-assign when taking ownership, unassign after completing their phase
2. **Clear handoff points**: Unassignment signals work is ready for next role to pull
3. **Role recommendations without enforcement**: Suggest Tech Lead for Refinement, Developer for Implementation,
   QA for Verification, but stay flexible
4. **Platform-agnostic**: Provide CLI examples for GitHub, Azure DevOps, and Jira
5. **Minimal disruption**: Integrate assignment guidance without restructuring existing skill

## Design Approach

**Selected Approach:** Minimal Integration

Add assignment workflow as lightweight enhancements at state transition points in the existing skill structure:

- Create new `references/assignment-workflow.md` reference file
- Add assignment steps to Core Workflow at transitions
- Add Common Mistakes and Red Flags entries
- Update Example section with assignment CLI commands
- Update Prerequisites and Overview to mention assignment pattern

**Why this approach:**

- Minimal disruption to existing skill structure
- Easy for existing users to adopt incrementally
- Follows established reference file pattern
- Integrates where it matters (at transition points)

## Detailed Design

### 1. New Reference File: `references/assignment-workflow.md`

Create comprehensive reference documenting the pull-based pattern with platform-specific CLI commands.

**Structure:**

````markdown
# Assignment Workflow

## Pull-Based Kanban Pattern

Team members self-assign work items when taking ownership, then unassign
after completing their phase to signal handoff to the next role.

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
gh issue edit <issue-number> --assignee @me
```
````

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
gh issue edit 30 --assignee @me --add-label "state:refinement" --remove-label "state:new-feature"
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

**Do:**

- Let people self-assign when ready
- Unassign promptly when done
- Limit work-in-progress per person
- Make ownership visible through assignment

````text

### 2. Core Workflow Updates

Add assignment guidance as sub-steps at transition points in SKILL.md Core Workflow section:

**At Step 3 (lines 60-61):**
```markdown
3. Confirm the target work item and keep all work tied to it.
   3a. Self-assign the work item when beginning refinement (Tech Lead recommended).
   3b. Set work item state to `refinement` when beginning plan creation.
   3c. Stay assigned during entire refinement phase (plan creation, approval feedback loop, iterations).
````

**Between Step 6 and Step 7 (new):**

```markdown
6a. During approval feedback: Stay assigned and respond to questions/feedback in work item comments.
6b. If revisions needed: Update plan, push changes, re-post link in same thread. Stay assigned.
6c. Only unassign after receiving explicit "approved" or "LGTM" comment.
```

**At Step 7 (lines 66-67):**

```markdown
7. After approval, add work item sub-tasks for every plan task and keep a 1:1 mapping by name.
   7a. Unassign yourself to signal refinement complete and handoff to implementation.
   7b. Set work item state to `implementation`.
   7c. Self-assign when ready to implement (Developer recommended).
```

**At Step 8 (lines 68-69):**

```markdown
8. Execute each task and attach evidence and reviews to its sub-task.
   8a. When all sub-tasks complete, unassign yourself to signal implementation complete.
   8b. Set work item state to `verification`.
   8c. Self-assign when ready to verify (QA recommended).
```

**At Step 10 (line 73):**

```markdown
10b. When verification complete and acceptance criteria met, close work item (state: complete).
10c. Work item auto-unassigns when closed.
```

### 3. Common Mistakes Updates

Add to existing Common Mistakes section (after line 136):

```markdown
- Leaving work item assigned after state transition (blocks next team member from pulling work).
- Unassigning during approval feedback loop before receiving explicit approval (creates confusion about ownership).
- Assigning work items to others instead of letting them self-assign (violates pull-based pattern).
- Taking multiple assigned tickets simultaneously (creates work-in-progress bottleneck).
```

### 4. Red Flags Updates

Add to existing Red Flags section (after line 144):

```markdown
- "I'll assign this ticket to [name] for the next phase."
- "I'm keeping this assigned in case I need to come back to it."
```

### 5. Example Section Updates

Replace existing example (lines 113-127) with assignment-aware version:

````markdown
## Example

```bash
# Self-assign when starting refinement
gh issue edit 30 --assignee @me
gh issue edit 30 --add-label "state:refinement"

# Post plan for approval
gh issue comment 30 --body "Plan: https://github.com/org/repo/blob/branch/docs/plans/implementation-plan.md"

# After approval: unassign to signal handoff, transition state
gh issue edit 30 --remove-assignee @me
gh issue edit 30 --add-label "state:implementation" --remove-label "state:refinement"

# Developer finds next unassigned implementation ticket
gh issue list --label "state:implementation" --assignee "" --limit 5

# Developer self-assigns when ready to implement
gh issue edit 30 --assignee @me

# Add sub-tasks (task list items in issue body)
# tasks.md content:
# ## Sub-Tasks
# - [ ] Task 1: Add failing tests
# - [ ] Task 2: Implement skill spec
# - [ ] Task 3: Update README

gh issue edit 30 --body-file tasks.md

# After implementation complete: unassign, transition to verification
gh issue edit 30 --remove-assignee @me
gh issue edit 30 --add-label "state:verification" --remove-label "state:implementation"

# QA self-assigns when ready to verify
gh issue edit 30 --assignee @me
```
````

````text

### 6. Prerequisites Section Update

Add reference to assignment workflow (after line 14):

```markdown
## Prerequisites

- Ticketing system CLI installed and authenticated (gh for GitHub, ado for Azure DevOps, jira for Jira).
- See [Assignment Workflow](references/assignment-workflow.md) for pull-based team coordination pattern.
````

### 7. Overview Section Update

Update overview to mention assignment (lines 8-10):

```markdown
## Overview

Use work items as the source of truth for planning, approvals, execution evidence, and reviews. Team members self-assign work items when taking ownership and unassign at state transitions to enable pull-based coordination.
```

## BDD Test Scenarios

### RED Scenarios (Baseline - Current Behaviour Without Assignment Workflow)

### Test 1: No assignment guidance during refinement\*\*

- **Given**: Agent starts refinement on issue without assignment workflow
- **When**: Agent creates design document
- **Then**: Agent doesn't self-assign issue
- **And**: No indication of who is responsible for refinement
- **Evidence**: Check git history - design commits without assignment changes

### Test 2: Unclear handoff after plan approval\*\*

- **Given**: Plan is approved in issue comments
- **When**: Agent receives "approved" comment
- **Then**: Agent doesn't unassign themselves
- **And**: Next developer doesn't know ticket is ready to pull
- **Evidence**: Issue remains assigned to planner after approval

### Test 3: Assignment confusion during approval feedback\*\*

- **Given**: Agent posts design for approval
- **When**: Reviewer posts "continue" or feedback (not "approved")
- **Then**: Agent unassigns themselves prematurely OR is unclear about ownership
- **Evidence**: Assignment changes during feedback loop

### GREEN Scenarios (Expected Behaviour With Assignment Workflow)

### Test 1: Self-assign during refinement\*\*

- **Given**: Agent picks up issue in "New Feature" state (unassigned)
- **When**: Agent begins refinement
- **Then**: Agent self-assigns issue and sets `state:refinement` label
- **Evidence**: `gh issue view <issue> --json assignees,labels`

### Test 2: Stay assigned during approval feedback\*\*

- **Given**: Agent has posted design for approval (assigned, state:refinement)
- **When**: Reviewer posts feedback/"continue" (not "approved")
- **Then**: Agent stays assigned and responds to feedback
- **And**: Agent updates design, pushes changes, re-posts link
- **And**: Assignment unchanged throughout iteration
- **Evidence**: Git log shows design updates, issue history shows continuous assignment

### Test 3: Unassign after explicit approval\*\*

- **Given**: Agent posted design, received explicit "approved" comment
- **When**: Agent proceeds to add sub-tasks
- **Then**: Agent unassigns themselves
- **And**: Agent sets `state:implementation` label
- **And**: Issue is now unassigned and ready for developer to pull
- **Evidence**: `gh issue view <issue> --json assignees,labels` shows unassigned + state:implementation

### Test 4: Developer pulls and self-assigns\*\*

- **Given**: Issue is unassigned with `state:implementation` label
- **When**: Developer ready to implement
- **Then**: Developer self-assigns issue
- **And**: Developer implements tasks
- **Evidence**: Issue history shows developer self-assignment

### Test 5: Developer unassigns after implementation\*\*

- **Given**: All sub-tasks complete
- **When**: Developer finishes implementation
- **Then**: Developer unassigns themselves
- **And**: Developer sets `state:verification` label
- **Evidence**: Issue unassigned + state:verification

### Test 6: QA pulls and verifies\*\*

- **Given**: Issue unassigned with `state:verification` label
- **When**: QA ready to verify
- **Then**: QA self-assigns issue
- **And**: QA verifies acceptance criteria
- **And**: QA closes issue (auto-unassigns)
- **Evidence**: Issue closed with QA as final assignee before close

### PRESSURE Scenarios (Non-Ideal Conditions)

### Test 1: Multiple tickets in queue\*\*

- **Given**: 5 unassigned issues in `state:implementation`
- **When**: Developer looks for next work
- **Then**: Developer can easily identify unassigned tickets to pull
- **Evidence**: `gh issue list --label "state:implementation" --assignee "" --limit 5`

### Test 2: Blocked during refinement\*\*

- **Given**: Agent assigned to issue, state:refinement
- **When**: Agent is blocked waiting for stakeholder input
- **Then**: Agent stays assigned (still responsible)
- **And**: Agent posts comment explaining blocker
- **Evidence**: Issue stays assigned with blocker comment

### Test 3: Need to abandon mid-refinement\*\*

- **Given**: Agent assigned to issue, state:refinement, design partially done
- **When**: Agent needs to step away (higher priority work)
- **Then**: Agent posts status comment
- **And**: Agent unassigns themselves
- **And**: Issue returns to unassigned state for someone else to pick up
- **Evidence**: Issue unassigned with status comment

### Integration Scenarios

### Test 1: Full lifecycle assignment flow\*\*

- **Given**: New issue created (unassigned, no state label)
- **When**: Full workflow executed from refinement → implementation → verification
- **Then**: Assignment changes match state transitions:
  - Tech Lead assigned during refinement
  - Unassigned after approval
  - Developer assigned during implementation
  - Unassigned after implementation
  - QA assigned during verification
  - Auto-unassigned on close
- **Evidence**: Issue timeline shows assignment changes aligned with state changes

### Test 2: Multiple platforms\*\*

- **Given**: Repositories on GitHub, Azure DevOps, Jira
- **When**: Agent follows assignment workflow on each platform
- **Then**: CLI commands work correctly for each platform
- **Evidence**: Test on all three platforms with real tickets

## Implementation Checklist

- [ ] Create `skills/issue-driven-delivery/references/assignment-workflow.md`
- [ ] Update `skills/issue-driven-delivery/SKILL.md` Overview section
- [ ] Update `skills/issue-driven-delivery/SKILL.md` Prerequisites section
- [ ] Update `skills/issue-driven-delivery/SKILL.md` Core Workflow steps 3, 7, 8, 10
- [ ] Update `skills/issue-driven-delivery/SKILL.md` Example section
- [ ] Update `skills/issue-driven-delivery/SKILL.md` Common Mistakes section
- [ ] Update `skills/issue-driven-delivery/SKILL.md` Red Flags section
- [ ] Test GitHub CLI assignment commands
- [ ] Test Azure DevOps CLI assignment commands (if available)
- [ ] Test Jira CLI assignment commands (if available)
- [ ] Commit design document
- [ ] Create implementation plan

## Success Criteria

**The design is successful when:**

1. Team members can easily find next unassigned ticket ready for their role
2. Ownership handoffs are clear through assignment state changes
3. Work-in-progress is visible through current assignments
4. Assignment pattern integrates naturally with existing state transitions
5. CLI examples are copy-paste ready for each platform
6. Documentation clearly explains the "why" behind pull-based workflow

## Open Questions

None - design validated through Q&A with stakeholder.

## Next Steps

1. Get design approval
2. Create implementation work item
3. Set up git worktree for isolated implementation
4. Create detailed implementation plan
5. Execute implementation with sub-task tracking
