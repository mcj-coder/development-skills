# BDD Checklist: Baseline Failure Plan Matches Template

## RED: Failing Checklist (Before Implementation)

- [ ] Plan includes YAML frontmatter fields from `docs/plans/TEMPLATE.md`
- [ ] Plan includes required template sections (Summary, Issue Context, Approval, Success Criteria)
- [ ] Plan includes template headings through Retrospective

**Failure Evidence:**

- `rg -n "status:|## Version History|## Approval|## Summary|## Issue Context|## Success Criteria|## Retrospective"`
  `docs/plans/2026-01-14-baseline-failure-blocking.md` shows missing sections.

## GREEN: Passing Checklist (After Implementation)

- [ ] Plan includes YAML frontmatter fields from `docs/plans/TEMPLATE.md`
- [ ] Plan includes required template sections (Summary, Issue Context, Approval, Success Criteria)
- [ ] Plan includes template headings through Retrospective
