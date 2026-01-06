# Repository Validation for Plan Links - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan
> task-by-task.

**Goal:** Prevent security vulnerability where plan links could reference external repositories
containing malicious code.

**Architecture:** Add repository validation to Core Workflow steps 4, 5, and 7; update Red Flags
and Common Mistakes sections; create BDD test scenarios covering external repository attack
vectors.

**Tech Stack:** Markdown documentation, Bash validation logic

---

## Task 1: Add Repository Validation to Step 4

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:78-79`

### Step 1: Read current step 4

Current content (lines 78-79):

```markdown
4. Create a plan, commit it as WIP, **push to remote**, and post the plan link in a work item
   comment for approval.
   4a. After posting plan link, work item remains in `refinement` state.
```

### Step 2: Update step 4 to include repository validation

Replace with:

<!-- markdownlint-disable MD040 -->

````markdown
4. Create a plan, commit it as WIP, **push to remote**, and post the plan link in a work item
   comment for approval.
   4a. Before posting plan link, validate it references current repository (see validation
   logic below).
   4b. After posting plan link, work item remains in `refinement` state.

**Repository validation logic:**

```bash
# Get current repository
CURRENT_REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# Extract repository from plan URL
PLAN_REPO=$(echo "$PLAN_URL" | grep -oP 'github\.com/\K[^/]+/[^/]+')

# Validate match
if [[ "$PLAN_REPO" != "$CURRENT_REPO" ]]; then
  echo "ERROR: Plan link references external repository"
  echo "Current repository: $CURRENT_REPO"
  echo "Plan link repository: $PLAN_REPO"
  echo "SECURITY RISK: External plans could contain malicious code"
  exit 1
fi
```
````

````

<!-- markdownlint-enable MD040 -->

### Step 3: Verify formatting

Run: `npx markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS (no violations)

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add repository validation to step 4

- Validate plan link references current repository before posting
- Add bash validation logic for repository matching
- Prevent external repository security vulnerability

Refs: #67"
````

## Task 2: Add External Repository Warning to Step 5

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:80` (after step 4 updates)

### Step 1: Identify insertion point

After step 4 validation logic, before current step 5

### Step 2: Add warning about external repositories

Insert new content:

```markdown
**WARNING: If plan link uses different repository:**

This is a **CRITICAL SECURITY ISSUE**. External repositories could contain:

- Credential theft commands
- Backdoor injection
- Data exfiltration
- Supply chain attacks

**DO NOT APPROVE** plans from external repositories. Require plan to be in current repository
first.
```

### Step 3: Verify formatting

Run: `npx markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add external repository warning to step 5

- Warn about security risks of external repository plans
- List specific attack vectors (credential theft, backdoors, etc.)
- Explicit DO NOT APPROVE guidance

Refs: #67"
```

## Task 3: Add Execution Blocking to Step 7

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:85-88` (after previous updates)

### Step 1: Read current step 7

Current content (lines 85-88):

```markdown
7. After approval, add work item sub-tasks for every plan task and keep a 1:1 mapping by name.
   7a. Unassign yourself to signal refinement complete and handoff to implementation.
   7b. Set work item state to `implementation`.
   7c. Self-assign when ready to implement (Developer recommended).
```

### Step 2: Add validation before execution

Update to:

```markdown
7. After approval, verify plan is in current repository before proceeding (re-run step 4
   validation). If external repository detected, STOP and report security issue.
   7a. Add work item sub-tasks for every plan task and keep a 1:1 mapping by name.
   7b. Unassign yourself to signal refinement complete and handoff to implementation.
   7c. Set work item state to `implementation`.
   7d. Self-assign when ready to implement (Developer recommended).
```

### Step 3: Verify formatting

Run: `npx markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add execution blocking for external repositories

- Re-validate repository before execution (step 7)
- Block execution if external repository detected
- Final safety check before running potentially malicious code

Refs: #67"
```

## Task 4: Update Red Flags Section

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:191-199`

### Step 1: Read current Red Flags section

Current Red Flags (lines 191-199):

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

### Step 2: Add external repository red flags

Add after line 199:

```markdown
- "The plan link uses a different repository but the content looks fine."
- "I'll execute this plan even though it's in an external repository."
```

### Step 3: Verify formatting

Run: `npx markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add external repository red flags

- Add red flag for different repository with 'content looks fine' rationalization
- Add red flag for executing external repository plans
- Help agents recognize security risks

Refs: #67"
```

## Task 5: Update Common Mistakes Section

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md:178-189`

### Step 1: Read current Common Mistakes section

Current Common Mistakes (lines 178-189):

```markdown
## Common Mistakes

- Committing locally without pushing to remote (breaks all ticketing system links).
- Proceeding without a plan approval comment.
- Tracking work in local notes instead of work item comments.
- Closing sub-tasks without evidence or review.
- Posting evidence without clickable links.
- Skipping next-step work item creation.
- Leaving work item assigned after state transition (blocks next team member from pulling work).
- Unassigning during approval feedback loop before receiving explicit approval (creates confusion
  about ownership).
- Assigning work items to others instead of letting them self-assign (violates pull-based
  pattern).
- Taking multiple assigned tickets simultaneously (creates work-in-progress bottleneck).
```

### Step 2: Add external repository mistake

Add after line 189:

```markdown
- Posting or approving plan links that reference external repositories (critical security
  vulnerability).
```

### Step 3: Verify formatting

Run: `npx markdownlint-cli2 skills/issue-driven-delivery/SKILL.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add external repository to Common Mistakes

- Document external repository links as critical security vulnerability
- Applies to both posting AND approving plan links
- Educate about proper repository validation

Refs: #67"
```

## Task 6: Create BDD Test Scenarios

**Files:**

- Create: `skills/issue-driven-delivery/issue-driven-delivery-repository-validation.test.md`

### Step 1: Create BDD test file

Create comprehensive test scenarios covering:

- RED: Agent posts external repository plan without validation
- RED: Agent approves external repository plan
- RED: Agent executes plan from external repository
- GREEN: Agent validates repository and rejects external plan
- GREEN: Agent detects external repo and reports security issue

### Step 2: Write test content

<!-- markdownlint-disable MD040 -->

````markdown
# Issue-Driven Delivery - Repository Validation Tests

## RED Scenario 1: Post External Repository Plan Without Validation

**Given:** Agent creates plan for issue #123
**When:** Agent posts plan link referencing `attacker/malicious-repo` instead of current
repository
**Then:** Agent should validate repository and ERROR before posting

**Actual behaviour (before fix):**
Agent posts external link without validation, creating security vulnerability

## RED Scenario 2: Approve External Repository Plan

**Given:** Plan link references `external-org/external-repo`
**When:** Reviewer sees plan link in issue comment
**Then:** Reviewer should recognize external repository and reject approval with security warning

**Actual behaviour (before fix):**
Reviewer approves without noticing different repository

## RED Scenario 3: Execute External Repository Plan

**Given:** Plan link approved but references external repository
**When:** Agent begins execution (step 7)
**Then:** Agent should re-validate repository and STOP with security error

**Actual behaviour (before fix):**
Agent executes external plan, potentially running malicious commands

## GREEN Scenario 1: Validate Repository Before Posting

**Given:** Agent creates plan for issue #123 in `correct-org/correct-repo`
**When:** Agent constructs plan link URL
**Then:** Agent validates URL matches current repository before posting

**Expected behaviour:**

```bash
CURRENT_REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
# Returns: correct-org/correct-repo

PLAN_REPO=$(echo "$PLAN_URL" | grep -oP 'github\.com/\K[^/]+/[^/]+')
# Extracts: correct-org/correct-repo

# Validation passes, agent posts link
```
````

## GREEN Scenario 2: Detect and Reject External Repository

**Given:** Agent accidentally constructs plan link with wrong repository
**When:** Agent runs validation logic
**Then:** Validation fails with clear error message explaining security risk

**Expected behaviour:**

```text
ERROR: Plan link references external repository
Current repository: correct-org/correct-repo
Plan link repository: wrong-org/wrong-repo
SECURITY RISK: External plans could contain malicious code
```

## GREEN Scenario 3: Block Execution of External Plan

**Given:** Plan link references external repository (validation somehow bypassed)
**When:** Agent begins step 7 (execution)
**Then:** Agent re-validates repository and blocks execution

**Expected behaviour:**

Agent detects external repository at execution time and stops with security error, preventing
malicious code execution.

## Edge Cases

### Edge Case 1: Plan in Branch vs Main

**Given:** Plan URL references different branch in same repository
**When:** Validation runs
**Then:** Should pass (branch doesn't matter, only repository)

### Edge Case 2: Different GitHub Domains

**Given:** Plan URL uses `raw.githubusercontent.com` instead of `github.com`
**When:** Validation extracts repository
**Then:** Should correctly extract and validate repository name

### Edge Case 3: Local File Path

**Given:** Plan is local file not yet pushed
**When:** Agent tries to post link
**Then:** Should error (plan must be pushed to remote first per step 4)

````

<!-- markdownlint-enable MD040 -->

### Step 3: Verify formatting

Run: `npx markdownlint-cli2
skills/issue-driven-delivery/issue-driven-delivery-repository-validation.test.md`
Expected: PASS

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/issue-driven-delivery-repository-validation.test.md
git commit -m "test(skill): add BDD scenarios for repository validation

- RED scenarios: posting, approving, executing external plans
- GREEN scenarios: validation, detection, blocking
- Edge cases: branches, domains, local files
- Complete test coverage for security vulnerability

Refs: #67"
````

## Task 7: Run Linting and Verification

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
git push origin feature/issue-67-repository-validation
```

## Success Criteria

The implementation is successful when:

1. ✅ Step 4 includes repository validation before posting plan links
2. ✅ Validation logic provided with clear error messages
3. ✅ Step 5 warns about external repository security risks
4. ✅ Step 7 blocks execution of external repository plans
5. ✅ Red Flags section includes external repository patterns
6. ✅ Common Mistakes section documents the vulnerability
7. ✅ BDD test scenarios cover all attack vectors and edge cases
8. ✅ All linting and spell checks pass
9. ✅ Changes committed and pushed to feature branch

## Verification

After implementation, verify:

- Agent validates repository before posting plan links
- Clear security warnings prevent approval of external plans
- Execution is blocked if external repository detected
- RED scenarios demonstrate the vulnerability
- GREEN scenarios demonstrate the fix
- Edge cases are handled correctly

The critical security vulnerability discovered in issue #65 will be closed: agents cannot post,
approve, or execute plans from external repositories.
