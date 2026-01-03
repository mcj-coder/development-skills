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
4. Keep all plan discussions and decisions in issue comments.
5. After approval, add issue sub-tasks for every plan task.
6. Execute each task and attach evidence and reviews to its sub-task.
7. Close sub-tasks only after approval and mark the plan task complete.
8. Post persona reviews in the issue thread and summarize recommendations in the plan.
9. Add follow-up fixes as new tasks in the same issue.
10. Create a new issue for next steps with implementation and test detail.
11. Open a PR after delivery is accepted.

## Evidence Checklist

- Plan link posted and approved in issue comments.
- Sub-tasks created for each plan task.
- Evidence and reviews attached to each sub-task.
- Persona reviews posted in the issue thread.
- Next steps captured in a new issue.
- PR opened after acceptance.

## Quick Reference

| Step          | Action                      | gh Example                                     |
| ------------- | --------------------------- | ---------------------------------------------- |
| Plan approval | Comment with plan link      | `gh issue comment <id> --body "Plan: <url>"`   |
| Sub-tasks     | Add task list items         | `gh issue edit <id> --body-file tasks.md`      |
| Evidence      | Comment with links and logs | `gh issue comment <id> --body "Evidence: ..."` |
| Next steps    | Create issue                | `gh issue create --title "..." --body "..."`   |
| PR            | Open PR                     | `gh pr create --title "..." --body "..."`      |

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
- Skipping next-step issue creation.

## Red Flags - STOP

- "I will just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I will skip them."
- "I will open a PR before acceptance."

## Rationalizations (and Reality)

| Excuse                             | Reality                                          |
| ---------------------------------- | ------------------------------------------------ |
| "The plan does not need approval." | Approval must be in issue comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                    |
| "I will summarize later."          | Discussion and evidence stay in the issue chain. |
| "Next steps can be a note."        | Next steps require a new issue with details.     |
