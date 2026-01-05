# PR Requirement Enforcement Before Closing Issues - Implementation Plan

**Goal:** Add explicit enforcement to issue-driven-delivery skill preventing issues from
being closed without a PR being created and merged.

**Architecture:** Update SKILL.md Core Workflow step 10a to verify PR exists and is
merged, add error message, update Red Flags, Common Mistakes, and Rationalizations
sections to close the loophole.

**Tech Stack:** Markdown documentation

---

## Task 1: Update Core Workflow Step 10a

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:95-97`

### Step 1: Read current step 10a

Current content (lines 95-97):

```markdown
10a. Before closing work item, verify all mandatory tags exist (component,
work type, priority). Error if any missing. Suggest appropriate tags
based on work item content.
```

### Step 2: Update step 10a to include PR verification

Replace with:

```markdown
10a. Before closing work item, verify: - All mandatory tags exist (component, work type, priority) - PR exists and is merged (unless read-only work)
Error if any missing. Suggest appropriate tags based on work item content.
Exception: Read-only work and reviews are allowed without a ticket/PR.
```

### Step 3: Verify formatting and line length

Run: `markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS (no line length violations)

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add PR verification to Core Workflow step 10a

- Update step 10a to verify PR exists and is merged before closing
- Add exception for read-only work
- Enforce PR requirement to prevent premature closure

Refs: #65"
```

## Task 2: Add Error Message for Missing PR

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md` (add new section after step 10)

### Step 1: Identify insertion point

After step 10c (line 99), before step 11 (line 100)

### Step 2: Add error message example

Insert new content:

<!-- markdownlint-disable MD040 -->

````markdown
**Error if PR missing:**

```text
ERROR: Cannot close work item without merged PR.
Required: Create PR using step 15, wait for review and merge.
Exception: Read-only work and reviews are allowed without a ticket/PR.
```
````

<!-- markdownlint-enable MD040 -->

### Step 3: Verify formatting

Run: `markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add error message for missing PR before close

- Add explicit error message when attempting to close without merged PR
- Document exception for read-only work
- Provides clear guidance on required action

Refs: #65"
```

## Task 3: Update Red Flags Section

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:175-183`

### Step 1: Read current Red Flags section

Current Red Flags (lines 175-183):

```markdown
## Red Flags - STOP

- "I will just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I will skip them."
- "I will post evidence without links."
- "I will open a PR before acceptance."
- "I'll assign this ticket to [name] for the next phase."
- "I'm keeping this assigned in case I need to come back to it."
```

### Step 2: Add PR-skipping red flags

Add after line 183:

```markdown
- "I'll close the issue without creating a PR."
- "Verification is complete, so I can close it now."
```

### Step 3: Verify formatting

Run: `markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add PR-skipping patterns to Red Flags

- Add red flag: closing without PR
- Add red flag: verification complete assumption
- Helps agents recognize when they're about to skip PR step

Refs: #65"
```

## Task 4: Update Common Mistakes Section

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:162-173`

### Step 1: Read current Common Mistakes section

Current Common Mistakes (lines 162-173):

```markdown
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
```

### Step 2: Add PR-related mistake

Add after line 173:

```markdown
- Closing work item after verification without creating PR (PR must exist and be merged first).
```

### Step 3: Verify formatting

Run: `markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add PR requirement to Common Mistakes

- Document that closing after verification requires PR first
- Clarifies PR must exist AND be merged before closing
- Prevents premature closure loophole

Refs: #65"
```

## Task 5: Update Rationalizations Table

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:185-192`

### Step 1: Read current Rationalizations table

Current Rationalizations (lines 185-192):

```markdown
## Rationalizations (and Reality)

| Excuse                             | Reality                                              |
| ---------------------------------- | ---------------------------------------------------- |
| "The plan does not need approval." | Approval must be in work item comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                        |
| "I will summarize later."          | Discussion and evidence stay in the work item chain. |
| "Next steps can be a note."        | Next steps require a new work item with details.     |
```

### Step 2: Add PR-related rationalizations

Add two new rows to the table (after line 191):

```markdown
| "Verification complete means I can close" | Must create PR, get review, merge, then close |
| "Changes are pushed, that's enough" | PR provides review process and merge tracking |
```

### Step 3: Verify table formatting

Run: `markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS (MD013 may trigger if rows too long - wrap if needed)

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add PR rationalizations to counter common excuses

- Add rationalization: verification complete vs PR required
- Add rationalization: pushed changes vs PR review process
- Counters arguments for skipping PR creation

Refs: #65"
```

## Task 6: Run Linting and Verification

**Files:**

- All modified files

### Step 1: Run linting checks

Run: `npm run lint:check`
Expected: PASS (0 errors)

### Step 2: Run spell check

Run: `npm run spell-check`
Expected: PASS (0 errors)

### Step 3: Verify git status

Run: `git status`
Expected: All changes committed, working tree clean

### Step 4: Push to remote

```bash
git push origin feature/issue-65-pr-enforcement
```

## Success Criteria

The implementation is successful when:

1. ✅ Step 10a explicitly verifies PR exists and is merged
2. ✅ Error message documented for missing PR
3. ✅ Red Flags section includes PR-skipping patterns
4. ✅ Common Mistakes section includes PR requirement
5. ✅ Rationalizations table counters PR-skipping excuses
6. ✅ Exception for read-only work documented
7. ✅ All linting and spell checks pass
8. ✅ Changes committed and pushed to feature branch

## Verification

After implementation, verify:

- An agent reading step 10a will know to check for merged PR
- Clear error message guides agents to create PR before closing
- Red Flags help agents recognize when they're about to skip PR step
- Common Mistakes educates about proper workflow
- Rationalizations counter common excuses for skipping PR

The loophole discovered in issue #60 will be closed: agents cannot close issues after verification
without creating and merging a PR.
