# Feature Branch Workflow Enhancement Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

## Goal

Update issue-driven-delivery to use feature branches from refinement through closing, with frequent
rebasing and plan archival.

## Architecture

Modify workflow to create branch at refinement start (not implementation), keep plans on branches,
rebase at state transitions, archive before closing.

## Tech Stack

Git workflow, Markdown skill documentation

---

## Task 1: Update Step 3b - Create Branch at Refinement Start

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:103-109`

### Step 1: Read current step 3b

Read the current step 3b text to understand existing wording.

### Step 2: Update step 3b to create feature branch

Replace step 3b with:

```markdown
3b. Set work item state to `refinement` when beginning plan creation. **Create
feature branch from main:** `git checkout -b feat/issue-N-description`. All
refinement and implementation work will be done on this feature branch. Plan
will be committed to this branch to keep main clean.
```

### Step 3: Verify change

Read the updated section to confirm the change is correct.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): create feature branch at refinement start"
```

## Task 2: Update Step 4 - Plan on Feature Branch

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:110-118`

### Step 1: Read current step 4

Read the current step 4 text.

### Step 2: Update step 4 introduction

Update the introduction to specify plan goes on feature branch:

```markdown
4. Create a plan in `docs/plans/YYYY-MM-DD-feature-name.md` on the feature branch,
   commit it as WIP, **push to remote**, and post the plan link in a work item
   comment for approval.
```

### Step 3: Update step 4a for commit SHA

Ensure step 4a emphasizes commit SHA for immutability:

```markdown
4a. Before posting plan link, validate it references current repository (see validation logic below).
Plan link must use commit SHA for immutability after approval.
```

### Step 4: Verify changes

Read the updated section to confirm correctness.

### Step 5: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): commit plan to feature branch"
```

## Task 3: Update Step 7c - Rebase Before Implementation

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:217-227`

### Step 1: Read current step 7c

Read the current step 7c text.

### Step 2: Add rebase requirement to step 7c

Update step 7c to include rebase and plan validity review:

```markdown
7c. Self-assign when ready to implement (Developer recommended). **Rebase feature
branch with main:** `git fetch origin && git rebase origin/main`. If significant
changes to main since plan creation (affecting files/areas in plan), review plan
validity, update plan if needed (requires re-approval), and push updated plan.
**All implementation work must be done on feature branch, not main.** If work item
has `blocked` label, verify approval comment exists. If approved, remove `blocked`
label and proceed. If not approved, stop with error showing blocking reason.
```

### Step 3: Verify change

Read the updated section.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): rebase before implementation start"
```

## Task 4: Add Step 8b.5 - Rebase Before Verification

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md` (after line 232)

### Step 1: Find insertion point

Find the line with "8b. When all sub-tasks complete, unassign yourself to signal implementation
complete."

### Step 2: Insert new step 8b.5

After step 8b, insert:

```markdown
8b.5. Before transitioning to verification, rebase feature branch with main:
`git fetch origin && git rebase origin/main`. If rebase picks up changes,
re-run implementation verification (tests, builds, etc.) to ensure rebased
changes don't break accepted behavior. If conflicts occur, resolve them and
re-verify. Push rebased branch: `git push --force-with-lease`.
```

### Step 3: Renumber subsequent steps

Renumber step 8c (becomes 8c.5), 8d (becomes 8d.5).

### Step 4: Verify changes

Read the updated section to ensure proper numbering.

### Step 5: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): add rebase before verification"
```

## Task 5: Add Step 10.5 - Final Rebase and Archive

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md` (after step 10c)

### Step 1: Find insertion point

Find the line with "10c. Work item auto-unassigns when closed."

### Step 2: Insert new step 10.5

After step 10c, insert:

```markdown
10.5. Before closing work item, perform final rebase and plan archival:
a) Rebase feature branch with main: `git fetch origin && git rebase origin/main`
b) If rebase picks up changes, re-run ALL verification (acceptance criteria, tests)
c) Archive plan: `git mv docs/plans/YYYY-MM-DD-feature-name.md docs/plans/archive/`
d) Commit archive: `git commit -m "docs: archive plan for issue #N"`
e) Push rebased branch: `git push --force-with-lease`
f) Verification must confirm rebased changes preserve accepted behavior
g) If behavior breaks, fix issues before closing
```

### Step 3: Verify changes

Read the updated section.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): add final rebase and plan archival"
```

## Task 6: Update Step 20 - Reference Archived Plans

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:256-265`

### Step 1: Read current step 20

Read the current step 20 text.

### Step 2: Update step 20 to mention archived plans

Update step 20:

```markdown
20. When all sub-tasks are complete and all verification tasks are complete and
    all required PRs for the issue scope are merged, post final evidence comment
    to the source work item, close it, and delete merged branches. Plan is now
    archived in `docs/plans/archive/` for reference. If issue requires multiple
    PRs, keep open until all scope delivered or remaining work moved to new ticket.
    Do not leave work items open after all work complete. After closing, search for
    work items blocked by this issue ("Blocked by #X") and auto-unblock: if sole
    blocker, remove `blocked` label and comment "Auto-unblocked: #X completed";
    if multiple blockers, update comment to remove this blocker and keep `blocked`
    label until all resolved.
```

### Step 3: Verify change

Read the updated section.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): reference archived plans in step 20"
```

## Task 7: Update Red Flags Section

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:344-363`

### Step 1: Read current Red Flags section

Read lines 344-363 to see current Red Flags.

### Step 2: Add new Red Flags

Add these items to the Red Flags list:

```markdown
- "Rebase can wait until PR review"
- "Already verified once, don't need to re-verify after rebase"
- "Main hasn't changed much, skip rebase"
- "Conflicts are minor, just resolve and push"
- "Plan is in main, that's fine"
- "Archive is optional, skip it"
```

### Step 3: Verify changes

Read the updated Red Flags section.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): add rebase and plan Red Flags"
```

## Task 8: Update Common Mistakes Section

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:325-348`

### Step 1: Read current Common Mistakes section

Read lines 325-348.

### Step 2: Add new Common Mistakes

Add these items to the Common Mistakes list:

```markdown
- Creating plan on main instead of feature branch (pollutes docs folder)
- Skipping rebase before verification (may verify against stale main)
- Not re-verifying after rebase picks up changes
- Ignoring plan validity when main has changed significantly
- Resolving merge conflicts without re-running tests
- Not archiving plan before closing (loses planning history)
- Deleting branch before archiving plan (loses plan entirely)
```

### Step 3: Verify changes

Read the updated Common Mistakes section.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): add rebase and plan Common Mistakes"
```

## Task 9: Update Rationalizations Table

### Files

- Modify: `skills/issue-driven-delivery/SKILL.md:358-369`

### Step 1: Read current Rationalizations table

Read lines 358-369.

### Step 2: Add new rationalizations

Add these rows to the Rationalizations table:

```markdown
| "Plan on main is easier" | Unactioned plans clutter main, feature branch keeps it clean |
| "Archive is busywork" | Archive preserves planning history and design decisions |
| "Rebase can wait until PR" | Rebase before verification ensures tests pass against current main |
| "Already verified, rebase won't break it" | Main changes can invalidate verification, must re-verify |
| "Plan is still valid" | Must review plan if main changed files the plan touches |
| "Conflicts are trivial" | Any conflict requires re-verification to ensure correctness |
```

### Step 3: Verify changes

Read the updated Rationalizations section.

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(issue-driven-delivery): add rebase and plan Rationalizations"
```

## Task 10: Create archive Directory Documentation

### Files

- Create: `docs/plans/archive/README.md`

### Step 1: Create archive README

Create documentation explaining the archive folder:

```markdown
# Archived Implementation Plans

This directory contains completed implementation plans for reference.

## Purpose

Plans are archived here after work items are closed to:

- Preserve planning history and design decisions
- Keep active plans directory clean (plans in feature branches only)
- Provide reference for future similar work
- Document what was planned vs. what was implemented

## Archive Process

When closing a work item (step 10.5):

1. Move plan from `docs/plans/` to `docs/plans/archive/`
2. Commit: `git commit -m "docs: archive plan for issue #N"`
3. Archive is included in PR with implementation

## Naming Convention

Plans follow: `YYYY-MM-DD-feature-name.md`

Date reflects when plan was created, not when archived.
```

### Step 2: Commit archive README

```bash
git add docs/plans/archive/README.md
git commit -m "docs: add archive directory documentation"
```

## Task 11: Run Linting and Spell Check

### Files

- Verify: `skills/issue-driven-delivery/SKILL.md`

### Step 1: Run linting

```bash
npm run lint:check
```

### Step 2: Run spell check

```bash
npm run spell-check
```

### Step 3: Fix any issues

If linting or spell check fails, fix issues and recommit.

### Step 4: Verify all checks pass

Ensure both linting and spell check pass with no errors.

## Task 12: Push Plan and Request Approval

### Files

- Push all commits to remote

### Step 1: Push feature branch

```bash
git push -u origin feat/issue-74-feature-branch-workflow
```

### Step 2: Get commit SHA

```bash
COMMIT_SHA=$(git rev-parse HEAD)
echo "Commit SHA: $COMMIT_SHA"
```

### Step 3: Post plan link with commit SHA

Post to issue #74:

```text
Plan: https://github.com/mcj-coder/development-skills/blob/{COMMIT_SHA}/docs/plans/2026-01-06-feature-branch-workflow.md

This plan updates issue-driven-delivery to use feature branches from refinement through closing,
with frequent rebasing and plan archival.

### 12 Tasks
1. Update Step 3b - Create Branch at Refinement Start
2. Update Step 4 - Plan on Feature Branch
3. Update Step 7c - Rebase Before Implementation
4. Add Step 8b.5 - Rebase Before Verification
5. Add Step 10.5 - Final Rebase and Archive
6. Update Step 20 - Reference Archived Plans
7. Update Red Flags Section
8. Update Common Mistakes Section
9. Update Rationalizations Table
10. Create archive Directory Documentation
11. Run Linting and Spell Check
12. Push Plan and Request Approval

Ready for approval.
```
