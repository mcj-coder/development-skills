# BDD Checklist: Baseline Plan Review Roles

## RED: Failing Checklist (Before Implementation)

- [ ] Plan includes a "For Reviewers" section under Implementation Notes
- [ ] Plan lists required review roles in that section
- [ ] Plan notes to use `C:\Users\mcj\.claude\persona-config.sh` before reviews

**Failure Evidence:**

- `rg -n "For Reviewers|Review Roles:|persona-config\\.sh"`
  `docs/plans/2026-01-14-baseline-failure-blocking.md` returns no matches.

## GREEN: Passing Checklist (After Implementation)

- [x] Plan includes a "For Reviewers" section under Implementation Notes
- [x] Plan lists required review roles in that section
- [x] Plan notes to use `C:\Users\mcj\.claude\persona-config.sh` before reviews

**Evidence:**

- Implementation: <https://github.com/mcj-coder/development-skills/commit/8722def>
- Verification: `rg -n "For Reviewers|Review Roles:|persona-config\\.sh" docs/plans/2026-01-14-baseline-failure-blocking.md`
