---
name: finishing-a-development-branch
description: >-
  Use when implementation is complete, all tests pass, and you need to decide how to integrate the work -
  guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guides developers through the proper completion workflow for development branches, enforcing SHIFT LEFT
principles by ensuring verification and role-based reviews complete BEFORE pull request creation.

**Core principle:** Find and fix issues early. Verification and reviews happen before PR, not during PR.

## When to Use

- Implementation work is complete on a feature branch
- All tests pass locally
- Ready to integrate changes into main branch
- Need guidance on next steps (PR, merge, cleanup)

## Prerequisites

Before using this skill:

- All implementation tasks complete
- Tests passing (run verification commands)
- Changes committed to feature branch
- Feature branch pushed to remote

## Workflow

### Step 1: Verify Implementation Complete

Before proceeding, confirm:

```bash
# All tests pass
npm test  # or appropriate test command

# No uncommitted changes
git status

# Feature branch is up to date with remote
git fetch origin
git status
```

If tests fail or changes uncommitted, complete implementation first.

### Step 1.5: Check Verification Requirements

**CRITICAL CHECKPOINT:** Determine what verification and reviews are required BEFORE creating PR.

#### Automatic Detection (via git diff)

Check what types of files changed to determine required reviews:

```bash
# Check for skill modifications
git diff main...HEAD --name-only | grep -E "skills/.*\.md$"
# If matches found → Skill Author review REQUIRED

# Check for documentation changes
git diff main...HEAD --name-only | grep -E "docs/.*\.md$|README\.md|CONTRIBUTING\.md"
# If matches found → Documentation Expert review REQUIRED

# Check for test changes
git diff main...HEAD --name-only | grep -E "\.test\.|\.spec\.|__tests__/"
# If matches found → QA Engineer verification REQUIRED
```

#### Manual Verification Checklist

Even without automatic detection, always verify:

- [ ] QA verification complete (acceptance criteria met)
- [ ] Role-based reviews complete based on change type:
  - [ ] Skill Author (if skills modified)
  - [ ] Documentation Expert (if docs modified)
  - [ ] [Other roles as specified in work item]
- [ ] All critical issues from reviews addressed
- [ ] Evidence posted to work item

#### If Verification/Reviews NOT Complete

**STOP. Do not proceed to Step 2.**

Display this message:

```text
⚠️ VERIFICATION/REVIEWS REQUIRED BEFORE PR CREATION

SHIFT LEFT Principle: Find issues before PR, not during PR.

Current status:
- [ ] QA verification (acceptance criteria)
- [ ] Skill Author review (skills modified)
- [ ] Documentation Expert review (docs modified)
- [ ] Evidence posted to work item

Next steps:
1. Complete required verifications and reviews
2. Post evidence to work item (issue comment with links)
3. Address any critical issues found
4. Return to this skill to create PR

Why this matters:
- PRs create merge pressure ("it's already a PR, let's approve")
- Early verification finds issues when they're cheaper to fix
- Evidence exists before PR (approval becomes simple gate check)
- Clear separation: verification = correctness, PR review = merge readiness
```

**Exit skill. Do not present PR creation option.**

#### If Verification/Reviews Complete

Confirm evidence posted to work item, then proceed to Step 2.

### Step 2: Choose Integration Path

Now that verification and reviews are complete, choose how to integrate:

#### Option 1: Direct Merge to Main (Fast-Forward)

Use when:

- Linear history preferred
- No collaborative review needed (already verified)
- Changes are straightforward
- Fast-forward merge possible

```bash
git checkout main
git merge --ff-only feat/branch-name
git push origin main
git branch -d feat/branch-name
git push origin --delete feat/branch-name
```

#### Option 2: Push and Create Pull Request

Use when:

- GitHub PR workflow required
- Need merge commit for traceability
- Team visibility important
- CI/CD runs on PR creation

**Verification checkpoint passed** ✅ - You may now create PR.

```bash
# Ensure branch is pushed
git push -u origin feat/branch-name

# Create PR (reference work item and evidence)
gh pr create --title "Title from work item" --body "$(cat <<'EOF'
Closes #ISSUE_NUMBER

## Summary
[1-3 bullet points summarizing changes]

## Verification Evidence
All verification and role-based reviews completed before PR creation.

- QA Verification: [link to work item comment]
- Skill Author Review: [link to work item comment]
- Documentation Expert Review: [link to work item comment]

## Changes
[Brief description of what changed]

See work item #ISSUE_NUMBER for complete evidence and review discussions.
EOF
)"
```

#### Option 3: Abandon/Cleanup

Use when:

- Work no longer needed
- Approach changed
- Merging into different branch

```bash
git checkout main
git branch -D feat/branch-name
git push origin --delete feat/branch-name
```

### Step 3: Post-Integration

After merging (Option 1 or 2):

1. Update work item state to `complete`
2. Post final evidence comment with merge commit SHA
3. Archive any plans (if using issue-driven-delivery)
4. Delete feature branch
5. Check for work items blocked by this issue and auto-unblock

## End-to-End Example Workflow

**Complete flow from implementation to merge:**

```bash
# 1. Implementation complete, tests passing
npm test  # ✅ All pass
git status  # ✅ All committed

# 2. Push feature branch
git push -u origin feat/issue-123-add-feature

# 3. Run verification (QA role)
# - Check acceptance criteria in work item
# - Test feature manually
# - Post verification comment to work item

# 4. Request role-based reviews
# - Skill Author reviews skill changes
# - Documentation Expert reviews docs
# - Each posts separate review comment

# 5. Address critical issues
# - Make fixes, commit, push
# - Re-verify if needed

# 6. Post evidence summary
# Comment on work item with links to all verification/review comments

# 7. NOW invoke finishing-a-development-branch skill
# - Verification checkpoint passes ✅
# - Choose Option 2 (Create PR)

# 8. Create PR with evidence links
gh pr create --title "feat: add user authentication" --body "..."

# 9. PR approval (simple gate check - evidence already exists)
# 10. Merge and cleanup
```

## Detection Logic (Implementation Guidance)

When this skill runs, it should:

1. **Check git diff for changed file types:**

   ```bash
   CHANGED_FILES=$(git diff main...HEAD --name-only)

   # Skills modified?
   echo "$CHANGED_FILES" | grep -q "skills/" && NEED_SKILL_AUTHOR=true

   # Docs modified?
   echo "$CHANGED_FILES" | grep -qE "docs/|README|CONTRIBUTING" && NEED_DOC_EXPERT=true

   # Tests modified?
   echo "$CHANGED_FILES" | grep -qE "\.test\.|\.spec\." && NEED_QA=true
   ```

2. **Check work item for verification comments:**

   ```bash
   # Use gh CLI to check for verification comments
   gh issue view ISSUE_NUM --json comments --jq '.comments[] | select(.body | contains("QA Verification") or contains("Skill Author Review"))'
   ```

3. **Block or allow PR creation:**
   - If verification comments found → Proceed to Option 2
   - If verification comments missing → Show warning, exit skill

## Common Mistakes

- **Opening PR before verification complete** (violates SHIFT LEFT)
  - Reality: PR creates merge pressure, undermines thorough verification
  - Fix: Complete verification first, then create PR

- **Opening PR before role-based reviews** (missing critical feedback)
  - Reality: Issues found during PR review are more expensive to fix
  - Fix: Get role-based reviews first, address issues, then create PR

- **Using "draft PR" as excuse to skip pre-PR verification**
  - Reality: Draft PRs still create visibility and pressure
  - Fix: Use work item state for visibility, complete verification before any PR

- **Skipping verification checkpoint because "tests pass"**
  - Reality: Tests passing ≠ acceptance criteria met
  - Fix: Always verify acceptance criteria and get role-based reviews

- **Creating PR to "get feedback"**
  - Reality: Feedback should come from role-based reviews in work item
  - Fix: Request reviews in work item, iterate there, then create PR

## Red Flags - STOP

- "I'll open the PR now and get reviews later"
  - **STOP:** Reviews must complete before PR creation

- "PR can be in draft while verification happens"
  - **STOP:** No PR (draft or otherwise) until verification complete

- "Reviews can happen during PR review"
  - **STOP:** SHIFT LEFT means finding issues before PR, not during

- "Tests pass, that's good enough for a PR"
  - **STOP:** Tests passing ≠ acceptance criteria verified

- "I'll just create the PR and mark it WIP"
  - **STOP:** Work item state tracks progress, not PR state

## Rationalizations (and Reality)

| Excuse                                       | Reality                                                      |
| -------------------------------------------- | ------------------------------------------------------------ |
| "Draft PR is fine before verification"       | PR creates merge pressure, undermining thorough verification |
| "Reviews can happen in PR comments"          | SHIFT LEFT means finding issues before PR, not during        |
| "Opening PR early shows progress"            | Progress is shown via work item state, not premature PRs     |
| "Tests passing means ready for PR"           | Acceptance criteria verification ≠ tests passing             |
| "PR is just for visibility"                  | Work item provides visibility without merge pressure         |
| "We can always close the PR if issues found" | Finding issues before PR is cheaper and cleaner              |

## Benefits of SHIFT LEFT (Verification Before PR)

1. **Issues found earlier** → Cheaper to fix (no PR update pressure)
2. **No PR review pressure** → Thorough reviews without "it's already a PR" bias
3. **Evidence exists before PR** → Approval is simple gate check
4. **Clear separation** → Verification = correctness, PR review = merge readiness
5. **Better quality** → More thorough reviews without merge pressure
6. **Cleaner history** → No PR churn from verification issues

## Integration with issue-driven-delivery

This skill is invoked after step 8c in issue-driven-delivery workflow:

- Step 8c: Set work item state to `verification` (**Do not open PR yet**)
- Step 9-11: Complete verification and role-based reviews
- Step 11.5: Invoke `finishing-a-development-branch` skill
  - Verification checkpoint checks reviews complete
  - If complete → Option 2 creates PR
  - If incomplete → Stop with guidance

This ensures SHIFT LEFT principles are enforced at the workflow level.

## Additional Notes

**Manual PR Creation Outside Skill:**

If someone bypasses this skill and creates PR manually:

- PR review should check for verification evidence in work item
- If evidence missing, request verification completion before approval
- Add comment linking to verification comments in work item

**Exception Handling:**

If urgent hotfix requires bypassing verification:

1. Document business justification in work item
2. Get explicit Tech Lead approval
3. Create follow-up work item for post-merge verification
4. Never bypass verification for regular features

**Metrics and Enforcement:**

Consider tracking:

- Time between verification complete and PR creation
- Number of PRs created without verification evidence
- Issues found in verification vs PR review
- Use metrics to demonstrate SHIFT LEFT value
