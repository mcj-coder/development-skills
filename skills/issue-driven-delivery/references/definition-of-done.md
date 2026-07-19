# Definition of Done (DoD) Checklist

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Before closing a work item (step 20), verify all completion criteria are met. The DoD
consolidates scattered completion requirements into an explicit checklist, ensuring work
is truly complete before marking done.

### Required DoD Items (Must Pass)

All required items must be verified before closing the work item:

- [ ] **All tests pass** - Unit, integration, and BDD validation green
- [ ] **PR merged** - All required PRs for issue scope merged to main
- [ ] **Plan archived** - Plan moved to `docs/plans/archive/` with "Complete" status
- [ ] **Mandatory tags complete** - Component, work-type, and priority labels set
- [ ] **Role reviews completed** - All required persona reviews posted and addressed

### Optional DoD Items (Team-Specific)

Teams may add optional items via ways-of-working:

- [ ] Documentation updated (README, API docs, user guides)
- [ ] Release notes drafted (for user-facing changes)
- [ ] Metrics/telemetry verified (observability requirements met)
- [ ] Performance validated (benchmarks pass, no regressions)

### DoD Validation Commands

**GitHub:**

```bash
# Verify PR merged
gh pr list --state merged --search "head:feat/issue-N" --json number --jq 'length > 0' && echo "PASS: PR merged" || echo "FAIL: No merged PR found"

# Verify plan archived
ls docs/plans/archive/*issue-N* 2>/dev/null && echo "PASS: Plan archived" || echo "FAIL: Plan not archived"

# Verify mandatory tags
LABELS=$(gh issue view N --json labels --jq '.labels[].name')
echo "$LABELS" | grep -q "component:\|skill" && echo "PASS: Component tag" || echo "FAIL: Missing component tag"
echo "$LABELS" | grep -q "work-type:" && echo "PASS: Work-type tag" || echo "FAIL: Missing work-type tag"
echo "$LABELS" | grep -q "priority:" && echo "PASS: Priority tag" || echo "FAIL: Missing priority tag"

# Verify role reviews (check for review comments in issue)
gh issue view N --json comments --jq '.comments[].body' | grep -qiE "review:|reviewed by|LGTM" && echo "PASS: Reviews found" || echo "WARN: No review comments detected"
```

### DoD Failure Handling

If DoD validation fails, do NOT close the work item. Instead:

1. **Identify gaps** - Review which required items failed
2. **Complete work** - Merge PR, archive plan, add missing tags, complete reviews
3. **Re-validate** - Run DoD check again
4. **Close** - Only close after all required items pass

**Error message template:**

```text
Definition of Done: FAILED

Cannot close work item. Missing required items:
- PR not merged (found open PR #123)
- Plan not archived (still in docs/plans/)

Actions required:
1. Merge PR #123 or resolve blocking reviews
2. Archive plan: git mv docs/plans/plan.md docs/plans/archive/
3. Re-run DoD validation before closing
```

### Customizing DoD

Teams can customize DoD requirements in their ways-of-working:

```markdown
# docs/ways-of-working/definition-of-done.md

## Our Definition of Done

### Required (in addition to defaults)

- Release notes updated in CHANGELOG.md
- Performance benchmarks pass (no > 10% regression)

### Not Required (override defaults)

- Plan archival (small team, plans in PR descriptions)
```

Reference your custom DoD in AGENTS.md or repository documentation.

### DoR vs DoD Summary

| Gate                      | When                  | Purpose                          |
| ------------------------- | --------------------- | -------------------------------- |
| Definition of Ready (DoR) | Before implementation | Ensure work is properly prepared |
| Definition of Done (DoD)  | Before closing        | Ensure work is truly complete    |

Both gates are quality checkpoints. DoR prevents starting unprepared work; DoD prevents
closing incomplete work.
