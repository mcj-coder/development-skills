---
name: issue-driven-delivery
description: Use when work is tied to a ticketing system work item and requires comment approval, sub-task tracking, or CLI-based delivery workflows.
---

# Issue-Driven Delivery

## Overview

Use work items as the source of truth for planning, approvals, execution evidence, and reviews.

## Prerequisites

- Ticketing system CLI installed and authenticated (gh for GitHub, ado for Azure DevOps, jira for Jira).

## When to Use

- Work is explicitly tied to a work item in the ticketing system.
- The user requests work-item-driven planning, approvals, or delivery tracking.
- The user requires ticketing CLI usage for workflow management.

## Platform Resolution

Infer platform from the taskboard URL (from README.md Work Items section):

| Platform     | Domain patterns                     | CLI    |
| ------------ | ----------------------------------- | ------ |
| GitHub       | `github.com`                        | `gh`   |
| Azure DevOps | `dev.azure.com`, `visualstudio.com` | `ado`  |
| Jira         | `atlassian.net`, `jira.`            | `jira` |

If the URL is not recognised, stop and ask the user to confirm the platform.

## Work Item State Tracking

Update work item state throughout the delivery lifecycle to maintain visibility:

### Lifecycle States

1. **New Feature**: Initial state when work item created
2. **Refinement**: During planning, brainstorming, requirements gathering
3. **Implementation**: During active development and execution
4. **Verification**: During testing, review, and validation
5. **Complete**: Final state when work item closed

### State Transitions

- **New → Refinement**: When plan creation begins
- **Refinement → Implementation**: When plan is approved
- **Implementation → Verification**: When all sub-tasks complete and testing begins
- **Verification → Complete**: When all acceptance criteria met and work item closed

### Platform-Specific Implementation

**GitHub**: Use state labels

- `state:new-feature`, `state:refinement`, `state:implementation`, `state:verification`

**Azure DevOps**: Use work item state field

- New → Active (Refinement) → Resolved (Implementation/Verification) → Closed

**Jira**: Use issue status

- To Do → In Planning → In Progress → In Review → Done

### When to Update State

- Set `state:refinement` when creating the plan
- Set `state:implementation` immediately after plan approval
- Set `state:verification` when implementation complete and testing begins
- Set `state:complete` / close work item only after all acceptance criteria met

## Core Workflow

1. Announce the skill and why it applies; confirm ticketing CLI availability.
2. Confirm a Taskboard work item exists for the work. If none exists, create the
   work item before making any changes. Read-only work and reviews are allowed
   without a ticket.
3. Confirm the target work item and keep all work tied to it.
   3a. Set work item state to `refinement` when beginning plan creation.
4. Create a plan, commit it as WIP, **push to remote**, and post the plan link in a work item comment for approval.
   4a. After posting plan link, work item remains in `refinement` state.
5. Stop and wait for an explicit approval comment containing the word "approved" before continuing.
6. Keep all plan discussions and decisions in work item comments.
7. After approval, add work item sub-tasks for every plan task and keep a 1:1 mapping by name.
   7a. After plan approval, set work item state to `implementation`.
8. Execute each task and attach evidence and reviews to its sub-task.
   8a. When all sub-tasks complete, set work item state to `verification`.
9. Stop and wait for explicit approval before closing each sub-task.
10. Close sub-tasks only after approval and mark the plan task complete.
    10a. When verification complete and acceptance criteria met, close work item (state: complete).
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
    the PR is approved ensure that the source work item is closed with the PR and
    the source branch is deleted

## Evidence Requirements

- **All commits must be pushed to remote before posting links** - local commits
  are not accessible via ticketing system URLs.
- Evidence must be posted as clickable links in work item comments (commit URLs, blob URLs, logs, or artifacts).
- Each sub-task comment must include links to the exact commits and files that satisfy it.
- Persona reviews must be separate work item comments using
  superpowers:receiving-code-review, with links captured in the summary.
- Verify ticketing CLI authentication status before creating work items, comments, or PRs.
- Link the PR and work item and include PR comment links when a PR exists.
- Post evidence that required skills were applied for concrete changes before
  opening a PR. For process-only changes, record analytical verification.
- If post-review changes occur, re-run BDD validation and update the plan evidence.
- In the plan, separate **Original Scope Evidence** from **Additional Work**.
- After each additional task, re-run BDD validation and persona reviews and link the
  verification comment to the change commit and task.
- Keep only the latest verification evidence in the plan; prior evidence remains
  in work item/PR comment threads.

## Evidence Checklist

- Plan link posted and approved in work item comments.
- Sub-tasks created for each plan task with 1:1 name mapping.
- Evidence and reviews attached to each sub-task.
- Persona reviews posted as individual comments in the work item thread using superpowers:receiving-code-review.
- Next steps captured in a new work item.
- PR opened after acceptance.
- PR and work item cross-linked with PR feedback addressed (when a PR exists).
- Post-review changes re-verified with updated BDD evidence.
- Plan evidence structured into original scope, additional work, and latest
  verification only.

## Quick Reference

| Step          | Action                      | gh Example                                     |
| ------------- | --------------------------- | ---------------------------------------------- |
| Plan approval | Comment with plan link      | `gh issue comment <id> --body "Plan: <url>"`   |
| Sub-tasks     | Add task list items         | `gh issue edit <id> --body-file tasks.md`      |
| Evidence      | Comment with links and logs | `gh issue comment <id> --body "Evidence: ..."` |
| Next steps    | Create issue                | `gh issue create --title "..." --body "..."`   |
| PR            | Open PR                     | `gh pr create --title "..." --body "..."`      |
| PR feedback   | Track PR comments           | `gh pr view <id> --comments`                   |

## Implementation Notes

- Keep the work item thread as the single source of truth.
- Use task list items in the work item body as sub-tasks when sub-work-items are unavailable.
- Match each sub-task title to its plan task for traceability.

## Example

```bash
# Post plan for approval
gh issue comment 30 --body "Plan: https://github.com/.../docs/plans/2026-01-03-github-issue-driven-delivery.md"

# Add sub-tasks (task list items in issue body)
# tasks.md content:
# ## Sub-Tasks
# - [ ] Task 1: Add failing tests
# - [ ] Task 2: Implement skill spec
# - [ ] Task 3: Update README

gh issue edit 30 --body-file tasks.md
```

## Common Mistakes

- Committing locally without pushing to remote (breaks all ticketing system links).
- Proceeding without a plan approval comment.
- Tracking work in local notes instead of work item comments.
- Closing sub-tasks without evidence or review.
- Posting evidence without clickable links.
- Skipping next-step work item creation.

## Red Flags - STOP

- "I will just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I will skip them."
- "I will post evidence without links."
- "I will open a PR before acceptance."

## Rationalizations (and Reality)

| Excuse                             | Reality                                              |
| ---------------------------------- | ---------------------------------------------------- |
| "The plan does not need approval." | Approval must be in work item comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                        |
| "I will summarize later."          | Discussion and evidence stay in the work item chain. |
| "Next steps can be a note."        | Next steps require a new work item with details.     |
