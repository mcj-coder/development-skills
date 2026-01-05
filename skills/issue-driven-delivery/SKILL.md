---
name: issue-driven-delivery
description: Use when work is tied to a ticketing system work item and requires comment approval, sub-task tracking, or CLI-based delivery workflows.
---

# Issue-Driven Delivery

## Overview

Use work items as the source of truth for planning, approvals, execution evidence, and reviews. Team members self-assign
work items when taking ownership and unassign at state transitions to enable pull-based coordination.

## Prerequisites

- Ticketing system CLI installed and authenticated (gh for GitHub, ado for Azure DevOps, jira for Jira).
- See [Assignment Workflow](references/assignment-workflow.md) for pull-based team coordination pattern.

## When to Use

- Work is explicitly tied to a work item in the ticketing system.
- The user requests work-item-driven planning, approvals, or delivery tracking.
- The user requires ticketing CLI usage for workflow management.

## Platform Resolution

Infer platform from the taskboard URL (from README.md Work Items section).
Supported platforms: GitHub, Azure DevOps, Jira.

See [Platform Resolution](references/platform-resolution.md) for domain patterns
and CLI mappings.

## Work Item State Tracking

Update work item state throughout the delivery lifecycle to maintain visibility.

**Lifecycle**: New Feature → Refinement → Implementation → Verification → Complete

See [State Tracking](references/state-tracking.md) for detailed lifecycle states,
transitions, and platform-specific implementations.

## Component Tagging

Every work item must be tagged with the component or component type it impacts.

**Enforcement**: Verify component tag exists before closing work item. Stop with
error if missing.

See [Component Tagging](references/component-tagging.md) for tagging strategy,
platform-specific implementation, and automatic suggestions.

## Core Workflow

**Note:** For platform-specific CLI commands (set state, add component), see
[CLI Commands Reference](references/cli-commands.md) for GitHub, Azure DevOps,
and Jira examples.

1. Announce the skill and why it applies; confirm ticketing CLI availability.
2. Confirm a Taskboard work item exists for the work. If none exists, create the
   work item before making any changes. Read-only work and reviews are allowed
   without a ticket.
   2a. Verify work item has appropriate component tag. If missing, add component tag based on work scope.
3. Confirm the target work item and keep all work tied to it.
   3a. Self-assign the work item when beginning refinement (Tech Lead recommended).
   3b. Set work item state to `refinement` when beginning plan creation.
   3c. Stay assigned during entire refinement phase (plan creation, approval feedback loop, iterations).
4. Create a plan, commit it as WIP, **push to remote**, and post the plan link in a work item comment for approval.
   4a. After posting plan link, work item remains in `refinement` state.
5. Stop and wait for an explicit approval comment containing the word "approved" before continuing.
6. Keep all plan discussions and decisions in work item comments.
   6a. During approval feedback: Stay assigned and respond to questions/feedback in work item comments.
   6b. If revisions needed: Update plan, push changes, re-post link in same thread. Stay assigned.
   6c. Only unassign after receiving explicit "approved" or "LGTM" comment.
7. After approval, add work item sub-tasks for every plan task and keep a 1:1 mapping by name.
   7a. Unassign yourself to signal refinement complete and handoff to implementation.
   7b. Set work item state to `implementation`.
   7c. Self-assign when ready to implement (Developer recommended).
8. Execute each task and attach evidence and reviews to its sub-task.
   8a. When all sub-tasks complete, unassign yourself to signal implementation complete.
   8b. Set work item state to `verification`.
   8c. Self-assign when ready to verify (QA recommended).
9. Stop and wait for explicit approval before closing each sub-task.
10. Close sub-tasks only after approval and mark the plan task complete.
    10a. Before closing work item, verify component tag exists. Error if missing.
    10b. When verification complete and acceptance criteria met, close work item (state: complete).
    10c. Work item auto-unassigns when closed.
11. Require each persona to post a separate review comment in the work item thread using superpowers:receiving-code-review.
12. Summarize persona recommendations in the plan and link to the individual review comments.
13. Add follow-up fixes as new tasks in the same work item.
14. Create a new work item for next steps with implementation, test detail, and acceptance criteria.
15. Open a PR after delivery is accepted.
16. Before opening a PR, post evidence that required skills were applied in the
    repo when changes are concrete (config, docs, code). For process-only
    changes, note that verification is analytical.
17. If a PR exists, link the PR and work item, monitor PR comment threads, and address PR feedback before completion.
18. If changes occur after review feedback, re-run BDD validation and update evidence before claiming completion.
19. If BDD assertions change, require explicit approval before updating them.
20. When all sub-tasks are complete and all verification tasks are complete and
    all required PRs for the issue scope are merged, post final evidence comment
    to the source work item, close it, and delete merged branches. If issue
    requires multiple PRs, keep open until all scope delivered or remaining work
    moved to new ticket. Do not leave work items open after all work complete.

## Evidence Requirements

**Critical**: All commits must be pushed to remote before posting links. Evidence
must be posted as clickable links in work item comments.

**Key requirements**:

- Each sub-task comment includes links to exact commits and files
- Persona reviews are separate work item comments using
  superpowers:receiving-code-review
- Plan separates Original Scope Evidence from Additional Work
- Keep only latest verification evidence in plan

See [Evidence Requirements](references/evidence-requirements.md) for complete
requirements and evidence checklist.

## Implementation Notes

- Keep the work item thread as the single source of truth.
- Use task list items in the work item body as sub-tasks when sub-work-items are unavailable.
- Match each sub-task title to its plan task for traceability.

## Example

```bash
# Self-assign when starting refinement
gh issue edit 30 --add-assignee @me
gh issue edit 30 --add-label "state:refinement"

# Post plan for approval
gh issue comment 30 --body "Plan: https://github.com/org/repo/blob/branch/docs/plans/implementation-plan.md"

# After approval: unassign to signal handoff, transition state
gh issue edit 30 --remove-assignee @me
gh issue edit 30 --add-label "state:implementation" --remove-label "state:refinement"

# Developer finds next unassigned implementation ticket
gh issue list --label "state:implementation" --assignee "" --limit 5

# Developer self-assigns when ready to implement
gh issue edit 30 --add-assignee @me

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
gh issue edit 30 --add-assignee @me
```

## Common Mistakes

- Committing locally without pushing to remote (breaks all ticketing system links).
- Proceeding without a plan approval comment.
- Tracking work in local notes instead of work item comments.
- Closing sub-tasks without evidence or review.
- Posting evidence without clickable links.
- Skipping next-step work item creation.
- Leaving work item assigned after state transition (blocks next team member from pulling work).
- Unassigning during approval feedback loop before receiving explicit approval (creates confusion about ownership).
- Assigning work items to others instead of letting them self-assign (violates pull-based pattern).
- Taking multiple assigned tickets simultaneously (creates work-in-progress bottleneck).

## Red Flags - STOP

- "I will just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I will skip them."
- "I will post evidence without links."
- "I will open a PR before acceptance."
- "I'll assign this ticket to [name] for the next phase."
- "I'm keeping this assigned in case I need to come back to it."

## Rationalizations (and Reality)

| Excuse                             | Reality                                              |
| ---------------------------------- | ---------------------------------------------------- |
| "The plan does not need approval." | Approval must be in work item comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                        |
| "I will summarize later."          | Discussion and evidence stay in the work item chain. |
| "Next steps can be a note."        | Next steps require a new work item with details.     |
