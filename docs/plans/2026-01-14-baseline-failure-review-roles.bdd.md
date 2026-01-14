# BDD Checklist: Baseline Plan Review Roles

## RED: Failing Checklist (Before Implementation)

- [ ] Plan includes a "For Reviewers" section under Implementation Notes
- [ ] Plan lists required review roles in that section
- [ ] Plan notes to use `C:\Users\mcj\.claude\persona-config.sh` before reviews

**Failure Evidence:**

- `rg -n "For Reviewers|Review Roles:|persona-config\\.sh"`
  `docs/plans/2026-01-14-baseline-failure-blocking.md` returns no matches.

## GREEN: Passing Checklist (After Implementation)

- [ ] Plan includes a "For Reviewers" section under Implementation Notes
- [ ] Plan lists required review roles in that section
- [ ] Plan notes to use `C:\Users\mcj\.claude\persona-config.sh` before reviews
