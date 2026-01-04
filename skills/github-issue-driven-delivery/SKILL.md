---
name: github-issue-driven-delivery
description: Use when work is tied to a GitHub issue and requires issue-comment approval, sub-task tracking, or gh-based delivery workflows.
---

# GitHub Issue Driven Delivery

## Overview

Use GitHub issues as the source of truth for planning, approvals, execution evidence, and reviews.

## Prerequisites

- gh CLI installed and authenticated.

## When to Use

- Work is explicitly tied to a GitHub issue.
- The user requests issue-driven planning, approvals, or delivery tracking.
- The user requires gh usage for workflow management.

## Core Workflow

1. Announce the skill and why it applies; confirm gh availability.
2. Confirm the target issue and keep all work tied to it.
3. Create a plan, commit it as WIP, and post the plan link in an issue comment for approval.
4. Stop and wait for an explicit approval comment containing the word "approved" before continuing.
5. Keep all plan discussions and decisions in issue comments.
6. After approval, add issue sub-tasks for every plan task and keep a 1:1 mapping by name.
7. Execute each task and attach evidence and reviews to its sub-task.
8. Stop and wait for explicit approval before closing each sub-task.
9. Close sub-tasks only after approval and mark the plan task complete.
10. Require each persona to post a separate review comment in the issue thread using superpowers:receiving-code-review.
11. Summarize persona recommendations in the plan and link to the individual review comments.
12. Add follow-up fixes as new tasks in the same issue.
13. Create a new issue for next steps with implementation, test detail, and acceptance criteria.
14. Open a PR after delivery is accepted.
15. If a PR exists, link the PR and issue, monitor PR comment threads, and address PR feedback before completion.
16. If changes occur after review feedback, re-run BDD validation and update evidence before claiming completion.
17. If BDD assertions change, require explicit approval before updating them.
18. When all sub-tasks are complete and all verification tasks are complete and
    the PR is approved ensure that the source Issue is closed with the PR and
    the source branch is deleted

## Evidence Requirements

- Evidence must be posted as clickable links in issue comments (commit URLs, blob URLs, logs, or artifacts).
- Each sub-task comment must include links to the exact commits and files that satisfy it.
- Persona reviews must be separate issue comments using superpowers:receiving-code-review, with links captured in the summary.
- Verify `gh auth status` before creating issues, comments, or PRs.
- Link the PR and issue and include PR comment links when a PR exists.
- If post-review changes occur, re-run BDD validation and update the plan evidence.
- In the plan, separate **Original Scope Evidence** from **Additional Work**.
- After each additional task, re-run BDD validation and persona reviews and link the
  verification comment to the change commit and task.
- Keep only the latest verification evidence in the plan; prior evidence remains
  in issue/PR comment threads.

## Evidence Checklist

- Plan link posted and approved in issue comments.
- Sub-tasks created for each plan task with 1:1 name mapping.
- Evidence and reviews attached to each sub-task.
- Persona reviews posted as individual comments in the issue thread using superpowers:receiving-code-review.
- Next steps captured in a new issue.
- PR opened after acceptance.
- PR and issue cross-linked with PR feedback addressed (when a PR exists).
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

- Keep the issue thread as the single source of truth.
- Use task list items in the issue body as sub-tasks when sub-issues are unavailable.
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

- Proceeding without a plan approval comment.
- Tracking work in local notes instead of issue comments.
- Closing sub-tasks without evidence or review.
- Posting evidence without clickable links.
- Skipping next-step issue creation.

## Red Flags - STOP

- "I will just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I will skip them."
- "I will post evidence without links."
- "I will open a PR before acceptance."

## Rationalizations (and Reality)

| Excuse                             | Reality                                          |
| ---------------------------------- | ------------------------------------------------ |
| "The plan does not need approval." | Approval must be in issue comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                    |
| "I will summarize later."          | Discussion and evidence stay in the issue chain. |
| "Next steps can be a note."        | Next steps require a new issue with details.     |
