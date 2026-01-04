# GitHub Issue Driven Delivery Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement
> this plan task-by-task.

**Goal:** Implement the `github-issue-driven-delivery` skill spec and BDD-style
tests for issue 30, plus README registration.

**Architecture:** Create a new `skills/github-issue-driven-delivery/` folder with
`SKILL.md` and a colocated BDD test file. Update `README.md` to list the new
skill and prerequisites (gh CLI). Use GitHub Issue comments for plan approval
and later sub-task tracking.

**Tech Stack:** Markdown, Git, GitHub CLI (`gh`).

---

## Task 0: Post plan for approval (issue 30)

**Files:**

- Modify: `docs/plans/2026-01-03-github-issue-driven-delivery.md`

### Step 1: Stage the plan file

Run: `git add docs/plans/2026-01-03-github-issue-driven-delivery.md`

### Step 2: Commit WIP plan

```bash
git commit -m "chore(plan): add github-issue-driven-delivery implementation plan"
```

### Step 3: Push branch

Run: `git push -u origin feat-github-issue-driven-delivery-skill`

### Step 4: Comment on issue 30 with plan link

Run:

```bash
gh issue comment 30 --repo mcj-coder/development-skills --body "Plan for approval: https://github.com/mcj-coder/development-skills/blob/feat-github-issue-driven-delivery-skill/docs/plans/2026-01-03-github-issue-driven-delivery.md"
```

### Step 5: Wait for approval comment

Proceed only after approval is posted in the issue thread.

---

## Task 1: RED - Add failing BDD test (baseline) - Complete

**Files:**

- Create: `skills/github-issue-driven-delivery/github-issue-driven-delivery.test.md`

### Step 1: Write the failing test

```markdown
# github-issue-driven-delivery - BDD Tests (RED)

## Baseline (No Skill Present)

### Pressure Scenario 1: "Just do it quickly"

Given a user says to implement an issue quickly without mentioning plans or approvals
When the agent responds without this skill
Then the agent skips committing a WIP plan and does not request issue-comment approval

### Pressure Scenario 2: "Keep it local"

Given a user wants work tracked in a local checklist only
When the agent responds without this skill
Then the agent avoids using issue comments and sub-tasks for tracking

### Pressure Scenario 3: "We will fix it later"

Given a user asks to postpone review and evidence
When the agent responds without this skill
Then the agent omits persona reviews and evidence in the issue chain

## Assertions (Expected to Fail Until Skill Exists)

- gh is listed as a prerequisite in the skill.
- The workflow requires committing a WIP plan and posting a plan-link comment before execution.
- Plan approval is collected via an issue comment before sub-tasks are created.
- Each plan task maps to an issue sub-task (task list or sub-issue).
- Evidence and reviews are attached to each sub-task.
- Sub-tasks close only after approval and plan task is marked complete.
- Persona reviews are posted in the issue comment chain and summarized in the plan.
- Follow-up changes are new tasks in the same issue.
- Next steps create a new issue with implementation + test detail.
- A PR is created after acceptance.
```

### Step 2: Run test to verify it fails

Run: `Test-Path skills/github-issue-driven-delivery/SKILL.md`
Expected: `False` (skill does not exist yet, so assertions fail).

### Step 3: Commit the failing test

```bash
git add skills/github-issue-driven-delivery/github-issue-driven-delivery.test.md
git commit -m "test(skills): add failing tests for github-issue-driven-delivery"
```

---

## Task 2: GREEN + REFACTOR - Implement skill spec - Complete

**Files:**

- Create: `skills/github-issue-driven-delivery/SKILL.md`

### Step 1: Check for skill init script (from skill-creator guidance)

Run: `Test-Path scripts/init_skill.py`
Expected: `False` (if script is missing, create skill folder manually).

### Step 2: Write minimal skill spec to satisfy tests

````markdown
---
name: github-issue-driven-delivery
description: Use when work is driven by a GitHub issue, when issue comments or sub-tasks are needed for planning and approvals, or when gh is required for issue-based delivery workflows.
---

# GitHub Issue Driven Delivery

## Overview

Deliver issue-based work by keeping planning, approvals, execution evidence, and reviews in the GitHub issue thread using gh.

## When to Use

- Work is explicitly tied to a GitHub issue.
- The user asks for issue-driven planning, approvals, or delivery tracking.
- The user requires gh usage for workflow management.

## Prerequisites

- gh CLI installed and authenticated.

## Core Workflow

1. Announce the skill and why it applies; confirm gh availability.
2. Confirm the target issue and keep all work tied to it.
3. Create a plan, commit it as WIP, and post the plan link in an issue comment for approval.
4. Use issue comments for all discussion and decisions.
5. After approval, add issue sub-tasks for every plan task.
6. Execute each task and attach evidence/reviews to its sub-task.
7. Close sub-tasks only after approval and mark plan tasks complete.
8. Post persona reviews in the issue thread and summarize recommendations in the plan.
9. Add follow-up fixes as new tasks in the same issue.
10. Create a new issue for next steps with implementation and test detail.
11. Open a PR after delivery is accepted.

## Quick Reference

| Step          | Action                  | gh Example                                     |
| ------------- | ----------------------- | ---------------------------------------------- |
| Plan approval | Comment with plan link  | `gh issue comment <id> --body "Plan: <url>"`   |
| Sub-tasks     | Add task list items     | `gh issue edit <id> --body-file tasks.md`      |
| Evidence      | Comment with links/logs | `gh issue comment <id> --body "Evidence: ..."` |
| Next steps    | Create issue            | `gh issue create --title "..." --body "..."`   |
| PR            | Open PR                 | `gh pr create --title "..." --body "..."`      |

## Implementation

- Maintain a single source of truth: the issue thread.
- Use task list items in the issue body as sub-tasks when sub-issues are not available.
- Link every sub-task to its corresponding plan task by name or number.

## Example

```bash
# Post plan for approval
gh issue comment 30 --body "Plan: https://github.com/.../docs/plans/2026-01-03-github-issue-driven-delivery.md"

# Add sub-tasks (task list items in issue body)
# tasks.md content:
# ## Tasks
# - [ ] Task 1: Add failing tests
# - [ ] Task 2: Implement skill spec
# - [ ] Task 3: Update README

gh issue edit 30 --body-file tasks.md
```
````

## Common Mistakes

- Proceeding without a plan approval comment.
- Tracking work in local notes instead of issue comments.
- Closing sub-tasks without evidence or review.
- Skipping next-step issue creation.

## Red Flags - STOP

- "I'll just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I'll skip them."
- "I'll open a PR before acceptance."

## Rationalizations (and Reality)

| Excuse                             | Reality                                          |
| ---------------------------------- | ------------------------------------------------ |
| "The plan doesn't need approval."  | Approval must be in issue comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                    |
| "I'll summarize later."            | Discussion and evidence stay in the issue chain. |
| "Next steps can be a note."        | Next steps require a new issue with details.     |

### Step 3: Run test to verify it passes

Run: `rg "github-issue-driven-delivery" skills/github-issue-driven-delivery/SKILL.md`
Expected: Matches for name, description, and required sections.

### Step 4: Commit the skill

```bash
git add skills/github-issue-driven-delivery/SKILL.md
git commit -m "feat(skills): add github-issue-driven-delivery skill"
```

---

## Task 3: Update README to register the new skill - Complete

**Files:**

- Modify: `README.md`

### Step 1: Add skills section entry

```markdown
## Skills

- `github-issue-driven-delivery` (requires `gh`)
```

### Step 2: Verify README includes the new skill

Run: `rg "github-issue-driven-delivery" README.md`
Expected: One match under the Skills section.

### Step 3: Commit README update

```bash
git add README.md
git commit -m "docs(readme): list github-issue-driven-delivery skill"
```

---

## Task 4: Tighten approval gating and evidence link requirements - Complete

**Files:**

- Modify: `skills/github-issue-driven-delivery/SKILL.md`

### Step 1: Update approval gating and evidence link requirements

- Add an explicit approval gate before continuing after plan approval.
- Add explicit approval gate before closing each sub-task.
- Require evidence comments to include clickable links.

### Step 2: Verify skill content includes approval gates and evidence link rules

Run: `rg "approval|evidence" skills/github-issue-driven-delivery/SKILL.md`
Expected: Matches for approval gates and evidence link requirements.

### Step 3: Commit the changes

```bash
git add skills/github-issue-driven-delivery/SKILL.md
git commit -m "docs(skills): tighten approval gating and evidence links"
```

---

## Persona Review Summary - Complete

**Recommendations:**

- Add explicit approval wording guidance (e.g., require "approved" in comments).
- Emphasize 1:1 mapping between plan tasks and sub-tasks by name.
- Require commit + file links for evidence.
- Verify gh auth status before workflow steps.
- Include acceptance criteria in next-step issues.

**Persona review comment links:**

- Tech Lead: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707470698>
- Project Manager: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707470900>
- QA Engineer: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707471002>
- DevOps Engineer: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707471116>
- Product Owner: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707471229>

---

## Task 5: Require persona reviews as individual comments before summary - Complete

**Files:**

- Modify: `skills/github-issue-driven-delivery/SKILL.md`

### Step 1: Require individual persona comments before summary

- Add explicit requirement that each persona posts a separate issue comment.
- Require the summary to reference those individual comments.

### Step 2: Verify skill content includes the new requirement

Run: `rg "persona|review|summary" skills/github-issue-driven-delivery/SKILL.md`
Expected: Matches for individual persona comments and summary requirements.

### Step 3: Commit the change

```bash
git add skills/github-issue-driven-delivery/SKILL.md
git commit -m "docs(skills): require persona review comments before summary"
```

---

## Task 6: Require persona reviews to use receiving-code-review skill - Complete

**Files:**

- Modify: `skills/github-issue-driven-delivery/SKILL.md`

### Step 1: Reference receiving-code-review skill for persona reviews

- Require persona review comments to follow the receiving-code-review skill format.

### Step 2: Verify skill content includes the new requirement

Run: `rg "receiving-code-review" skills/github-issue-driven-delivery/SKILL.md`
Expected: Matches in persona review requirements.

### Step 3: Commit the change

```bash
git add skills/github-issue-driven-delivery/SKILL.md
git commit -m "docs(skills): require receiving-code-review for persona reviews"
```

---

## Task 7: Apply persona review recommendations - Complete

**Files:**

- Modify: `skills/github-issue-driven-delivery/SKILL.md`

### Step 1: Incorporate persona recommendations

- Require explicit approval wording (e.g., "approved") in comments.
- Emphasize 1:1 mapping between plan tasks and sub-tasks by name.
- Require evidence to include both commit and file links.
- Require verifying gh auth status before workflow steps.
- Require acceptance criteria in next-step issues.

### Step 2: Verify skill content includes the recommendations

Run: `rg "approved|1:1|auth|acceptance criteria|commit|file" skills/github-issue-driven-delivery/SKILL.md`
Expected: Matches for each recommendation.

### Step 3: Commit the change

```bash
git add skills/github-issue-driven-delivery/SKILL.md
git commit -m "docs(skills): apply persona review recommendations"
```

---

## Task 8: Post individual persona reviews and link them in the summary - Complete

**Files:**

- Modify: `docs/plans/2026-01-03-github-issue-driven-delivery.md`

### Step 1: Post individual persona reviews

- Post a separate issue comment per persona using superpowers:receiving-code-review.

### Step 2: Update the plan summary with comment links

- Add links to each persona comment in the summary section.

### Step 3: Commit the update

```bash
git add docs/plans/2026-01-03-github-issue-driven-delivery.md
git commit -m "chore(plan): link persona review comments"
```

---

## Task 9: Re-run verification checks after refactors and post evidence - Complete

**Files:**

- Modify: `docs/plans/2026-01-03-github-issue-driven-delivery.md`

### Step 1: Re-run verification checks

Run:

```bash
Test-Path skills/github-issue-driven-delivery/SKILL.md
rg "receiving-code-review" skills/github-issue-driven-delivery/SKILL.md
rg "approved|1:1|auth status|acceptance criteria|commits and files" skills/github-issue-driven-delivery/SKILL.md
```

### Step 2: Capture outputs as evidence

- Append the BDD validation evidence to the end of this plan document:
  - Representative simulated skill output excerpt.
  - Checklist of BDD assertions mapped to the output excerpt.
  - Review evidence with links and latest review text per persona.

### Step 3: Commit and link evidence

```bash
git add docs/plans/2026-01-03-github-issue-driven-delivery.md
git commit -m "chore(plan): add issue 30 verification and BDD evidence"
```

---

## Task 11: Refine evidence with skill output and review links

**Files:**

- Modify: `docs/plans/2026-01-03-github-issue-driven-delivery.md`

### Step 1: Capture representative skill output

- Add a representative excerpt of the skill sections (Core Workflow, Evidence Requirements, Evidence Checklist).

### Step 2: Add a BDD assertion checklist mapped to output

- For each BDD assertion, reference where in the excerpt the assertion is proven.

### Step 3: Add review evidence to the plan

- Include links to each persona comment and paste the latest review text for each persona.
- Include the review summary with link to the summary comment.

### Step 4: Commit the update

```bash
git add docs/plans/2026-01-03-github-issue-driven-delivery.md
git commit -m "chore(plan): refine evidence for BDD and reviews"
```

---

## Verification Evidence (2026-01-04)

### Representative Simulated Skill Output

Excerpt from `skills/github-issue-driven-delivery/SKILL.md`:

```text
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

## Evidence Requirements

- Evidence must be posted as clickable links in issue comments (commit URLs, blob URLs, logs, or artifacts).
- Each sub-task comment must include links to the exact commits and files that satisfy it.
- Persona reviews must be separate issue comments using superpowers:receiving-code-review, with links captured in the summary.
- Verify `gh auth status` before creating issues, comments, or PRs.
```

### BDD Assertions Checklist (Mapped to Output)

- `gh is listed as a prerequisite in the skill.`
  - Proof: `## Prerequisites` in SKILL.md lists `gh CLI installed and authenticated.`
- `The workflow requires committing a WIP plan and posting a plan-link comment before execution.`
  - Proof: Core Workflow step 3 in output excerpt.
- `Plan approval is collected via an issue comment before sub-tasks are created.`
  - Proof: Core Workflow step 4 in output excerpt.
- `Each plan task maps to an issue sub-task (task list or sub-issue).`
  - Proof: Core Workflow step 6 in output excerpt.
- `Evidence and reviews are attached to each sub-task.`
  - Proof: Core Workflow step 7 and Evidence Requirements list in output excerpt.
- `Sub-tasks close only after approval and plan task is marked complete.`
  - Proof: Core Workflow steps 8-9 in output excerpt.
- `Persona reviews are posted in the issue comment chain and summarized in the plan.`
  - Proof: Core Workflow steps 10-11 in output excerpt.
- `Follow-up changes are new tasks in the same issue.`
  - Proof: Core Workflow step 12 in output excerpt.
- `Next steps create a new issue with implementation + test detail.`
  - Proof: Core Workflow step 13 in output excerpt.
- `A PR is created after acceptance.`
  - Proof: Core Workflow step 14 in output excerpt.

### Review Evidence

Persona review links (latest):

- Tech Lead: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707470698>
- Project Manager: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707470900>
- QA Engineer: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707471002>
- DevOps Engineer: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707471116>
- Product Owner: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707471229>

Summary comment:

- Summary: <https://github.com/mcj-coder/development-skills/issues/30#issuecomment-3707455697>

Latest review excerpts:

Tech Lead:

```text
Findings: None.
Residual risks: Manual enforcement only; consider future automation via CI or templates.
```

Project Manager:

```text
Findings: None.
Residual risks: Task maintenance may drift without automation.
```

QA Engineer:

```text
Findings: None.
Residual risks: Verification is manual and document-based.
```

DevOps Engineer:

```text
Findings: None.
Residual risks: `gh auth status` is required and still manual.
```

Product Owner:

```text
Findings: None.
Residual risks: Acceptance criteria quality may vary between tickets.
```
