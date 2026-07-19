# Pre-Merge Checklist

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Before merging any PR, verify all checklist items are complete with evidence.

### Mandatory Pre-Merge Verification

**Do NOT merge a PR until ALL items are verified:**

1. **Issue acceptance criteria checked**
   - All checkboxes in issue body are checked (`[x]`)
   - Each checked item has evidence link: `- [x] Item ([evidence](link))`
   - Descoped items struck through with approval: `- [ ] ~~Item~~ (descoped: [approval](link))`

2. **PR test plan completed**
   - All test plan checkboxes are checked
   - Evidence gathered by implementer, not reviewer
   - Test plan items reference verification output

3. **Plan lifecycle complete**
   - Plan status updated to "Complete"
   - Plan archived: `git mv docs/plans/X.md docs/plans/archive/`
   - Archive commit included in PR or merged separately

4. **All reviews addressed**
   - No pending review comments
   - All conversations resolved
   - Re-review requested if significant changes made

5. **CI checks pass**
   - All required status checks green
   - Use `gh pr checks N` to verify
   - Never use `--admin` to bypass failing checks
   - See [Merge Policy](#merge-policy) for proper merge commands

### Pre-Merge Validation Commands

**GitHub:**

```bash
# Check issue acceptance criteria
BODY=$(gh issue view N --json body --jq '.body')
UNCHECKED=$(echo "$BODY" | grep -c '- \[ \]' || true)
DESCOPED=$(echo "$BODY" | grep -c '- \[ \] ~~' || true)
REMAINING=$((UNCHECKED - DESCOPED))
[ "$REMAINING" -eq 0 ] && echo "PASS: All criteria checked" || echo "FAIL: $REMAINING unchecked items"

# Check for evidence links on checked items
CHECKED=$(echo "$BODY" | grep -c '\- \[x\]' || true)
WITH_EVIDENCE=$(echo "$BODY" | grep -c '\- \[x\].*(' || true)
[ "$CHECKED" -eq "$WITH_EVIDENCE" ] && echo "PASS: All checked items have evidence" || echo "FAIL: $((CHECKED - WITH_EVIDENCE)) items missing evidence"

# Check PR test plan
PR_BODY=$(gh pr view N --json body --jq '.body')
PR_UNCHECKED=$(echo "$PR_BODY" | grep -c '- \[ \]' || true)
[ "$PR_UNCHECKED" -eq 0 ] && echo "PASS: PR test plan complete" || echo "FAIL: $PR_UNCHECKED unchecked test items"

# Check plan archived
ls docs/plans/archive/*issue-N* 2>/dev/null && echo "PASS: Plan archived" || echo "WARN: Plan not archived"
```

### Reviewer Responsibilities

The **reviewer** verifies:

- Evidence links resolve and show expected content
- Checked items genuinely meet acceptance criteria
- No pre-checked items without evidence
- Scope changes have approval links

The **reviewer does NOT**:

- Gather evidence for the implementer
- Check boxes on behalf of implementer
- Approve PRs with incomplete checklists

### PR Template Recommendation

Add to `.github/pull_request_template.md`:

```markdown
## Test Plan

<!-- All items must be checked with evidence before merge -->

- [ ] Unit tests pass ([CI run](link))
- [ ] Integration tests pass ([CI run](link))
- [ ] Manual testing complete ([evidence](link))

## Pre-Merge Checklist

<!-- Reviewer: Verify these are complete, do not complete them yourself -->

- [ ] Issue acceptance criteria all checked with evidence
- [ ] Plan archived (if applicable)
- [ ] All review comments addressed
```

### Pre-Merge Failure Handling

If pre-merge validation fails:

1. **Do NOT merge** the PR
2. Request implementer to complete missing items
3. Wait for evidence before re-review
4. Document what was missing in PR comment

**Never:**

- Merge with unchecked acceptance criteria
- Check boxes on behalf of others
- Accept "will fix later" for evidence
- Use `--admin` to bypass branch protection without explicit user approval

### Merge Policy

Branch protection exists to ensure quality. Never bypass it without explicit approval.

**Merge command precedence:**

1. **Preferred: Auto-merge** (waits for all checks)

   ```bash
   gh pr merge N --squash --auto --delete-branch
   ```

   Auto-merge queues the PR to merge when all required checks pass.

2. **Fallback: Wait then merge** (if auto-merge unavailable)

   ```bash
   # Wait for checks to complete
   gh pr checks N --watch

   # Merge after all checks pass
   gh pr merge N --squash --delete-branch
   ```

3. **NEVER: Admin bypass** (requires explicit user approval)

   ```bash
   # DANGEROUS: Bypasses all branch protection
   gh pr merge N --admin  # ONLY with user's explicit written permission
   ```

**Why auto-merge?**

| Approach     | CI Checks  | Code Owner  | Branch Rules | Risk Level |
| ------------ | ---------- | ----------- | ------------ | ---------- |
| `--auto`     | ✅ Waits   | ✅ Required | ✅ Enforced  | Low        |
| Manual merge | ✅ Waits   | ✅ Required | ✅ Enforced  | Low        |
| `--admin`    | ❌ Skipped | ❌ Skipped  | ❌ Bypassed  | **High**   |

**When is `--admin` acceptable?**

Only with ALL of these conditions:

1. User explicitly requests bypass in writing
2. Emergency situation documented
3. Fallback plan if merge causes issues
4. Post-merge verification planned

**Merge checklist:**

```bash
# Before merging, verify:
gh pr checks N  # All checks should show "pass"
gh pr view N --json reviewDecision  # Should show "APPROVED"
gh pr view N --json mergeable  # Should show "MERGEABLE"

# Then merge properly:
gh pr merge N --squash --delete-branch
```
