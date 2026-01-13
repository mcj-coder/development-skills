# BDD Checklist: Plan Step Heading Formatting

## RED: Failing Checklist (Before Implementation)

- [ ] Plan step headings do not include escaped asterisks

**Failure Evidence:**

- `rg -n "#### Step .*\\\\\\*\\\\\\*" docs/plans/2026-01-13-worktrees-preference.md docs/plans/2026-01-13-npm-test-script.md`

## GREEN: Passing Checklist (After Implementation)

- [ ] Plan step headings do not include escaped asterisks
