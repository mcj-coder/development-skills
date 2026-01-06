# Workflow Violation Root Cause Analysis - Issue #68

**Date:** 2026-01-06
**Issue:** #68 - Add work item prioritization to issue-driven-delivery
**Severity:** High (Workflow violation, user reports "this keeps occurring")

## What Happened

1. Implemented issue #68 by committing directly to `main` branch
2. Pushed to `main` without creating a PR
3. Closed issue without PR review
4. User identified the violation
5. Had to revert main, create feature branch, create PR #69, and merge properly

## Expected Workflow (issue-driven-delivery)

**Step 7c:** Self-assign when ready to implement (Developer recommended)
- **Missing:** Should have created feature branch at this point or earlier

**Step 15:** Open a PR after delivery is accepted
- **Violated:** Committed directly to main instead of creating PR

**Step 17:** If a PR exists, link the PR and work item
- **Violated:** No PR existed to link

**Step 20:** When all PRs merged, close work item
- **Violated:** Closed work item without PR being merged

## Root Causes

### 1. No Branch Created at Start (Primary Root Cause)

**What went wrong:**
- Started working directly on `main` branch
- Never created `feat/issue-68-prioritization-rules` branch before implementation
- By the time I reached "Step 15: Open PR", I had already committed to main

**Why it happened:**
- Issue-driven-delivery workflow doesn't explicitly say "create feature branch" at assignment
- Assumed working on main was acceptable
- Didn't think ahead to the PR requirement in Step 15

**What should have happened:**
- After Step 7c (self-assign for implementation), immediately create feature branch
- Or create branch even earlier, during refinement phase
- All commits should go to feature branch, not main

### 2. Missing Workflow Checkpoint Before First Commit (Secondary Root Cause)

**What went wrong:**
- Proceeded directly from "self-assign" to "start coding"
- Never paused to check: "What branch should I work on?"
- First `git commit` went to main without questioning it

**Why it happened:**
- No explicit workflow reminder about branching strategy before first commit
- Focused on implementation tasks rather than process compliance
- Git didn't prevent commit to main (no branch protection)

**What should have happened:**
- Before first commit, check: "Am I on the right branch?"
- Workflow should remind about feature branch at Step 7c

### 3. Workflow Documentation Gap (Contributing Factor)

**What went wrong:**
- Step 15 says "Open a PR after delivery is accepted"
- But doesn't say "Work on a feature branch throughout implementation"
- Branch strategy is implicit, not explicit

**Why it happened:**
- Workflow assumes reader knows to use feature branches
- GitHub Flow branching strategy is mentioned in README but not referenced in workflow
- No link between "self-assign for implementation" and "create feature branch"

**What should have happened:**
- Step 7c should say: "Self-assign when ready to implement. Create feature branch from main."
- Step 15 should reference that branch when creating PR

### 4. Pattern Recognition Failure (Contributing Factor)

**What went wrong:**
- User reports "this keeps occurring" - indicates repeat violation
- Not learning from previous mistakes
- Not internalizing branch discipline

**Why it happened:**
- No lasting memory of previous workflow violations
- Each session starts fresh without prior violation history
- No checklist or guard rails to prevent repeat violations

**What should have happened:**
- After first violation, create persistent reminder about branching
- Add workflow checkpoint at critical decision points
- Implement pre-commit validation

## Immediate Fixes Applied

1. ✅ Reverted direct commit from main (commit cd26839)
2. ✅ Created feature branch `feat/issue-68-prioritization-rules`
3. ✅ Re-applied changes on feature branch (commit f28bda3)
4. ✅ Created PR #69
5. ✅ Merged PR #69 to main (commit 193ab5f)
6. ✅ Closed issue #68 properly

## Preventive Measures

### For issue-driven-delivery Skill

**Update Step 7c:**
```markdown
7c. Self-assign when ready to implement (Developer recommended). Create feature
branch from main: `git checkout -b feat/issue-N-description`. All implementation
work must be done on feature branch, not main.
```

**Update Step 15:**
```markdown
15. Open a PR from your feature branch to main after delivery is accepted.
Link PR to work item.
```

**Add new Common Mistake:**
```markdown
- Committing directly to main instead of feature branch (violates GitHub Flow)
```

**Add new Red Flag:**
```markdown
- "I'll just commit to main this time" (bypasses PR review process)
```

### For Agent Behavior

**Pre-Implementation Checklist:**
- [ ] Feature branch created? (If no, stop and create it)
- [ ] Working on correct branch? (If on main, stop and switch)
- [ ] Ready to commit? (If on main, abort and switch to feature branch)

**Workflow Checkpoints:**
- After self-assignment (Step 7c): Verify feature branch exists
- Before first commit: Verify not on main branch
- Before creating PR: Verify commits are on feature branch, not main

### Repository Configuration (Recommended)

**Branch Protection Rules:**
- Protect main branch from direct commits
- Require PR reviews before merge
- Require status checks to pass

**Pre-commit Hook Addition:**
```bash
# Add to .husky/pre-commit
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ]; then
  echo "ERROR: Direct commits to main are not allowed"
  echo "Create a feature branch: git checkout -b feat/issue-N-description"
  exit 1
fi
```

## Success Criteria for Fix

✅ PR #69 created with proper workflow
✅ Feature branch used throughout process
✅ PR merged to main via squash
✅ Issue closed after PR merge
✅ Root cause analysis documented

## Lessons Learned

1. **Branch discipline is non-negotiable** - Always work on feature branches
2. **Workflow documentation needs explicit branching guidance** - Don't assume knowledge
3. **Checkpoints matter** - Pause before first commit to verify branch
4. **Pattern violations are signals** - "Keeps occurring" means systemic issue, not one-off mistake
5. **Process compliance > implementation speed** - Taking time to follow process prevents rework

## Action Items

- [ ] Update issue-driven-delivery skill with explicit branch creation at Step 7c
- [ ] Add pre-commit hook to prevent direct commits to main
- [ ] Create workflow checklist skill for critical decision points
- [ ] Add branch protection rules to repository settings

## Related Issues

- #68: Work item prioritization (this violation)
- User report: "this keeps occurring" (indicates multiple previous violations)

---

**Conclusion:** Primary root cause is failure to create and use feature branch from the start. Workflow assumes branching knowledge but doesn't make it explicit. Fix requires both documentation updates and behavioral checkpoints to prevent future violations.
