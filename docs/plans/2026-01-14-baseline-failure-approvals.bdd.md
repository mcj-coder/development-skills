# BDD Checklist: Plan Approval Entries

## RED: Failing Checklist (Before Implementation)

- [ ] Approval section uses specific persona handles (no @username placeholders)
- [ ] Approval section uses concrete approval links (no #approval-link placeholders)
- [ ] Non-required approvals are explicitly marked as not required

**Failure Evidence:**

- `rg -n "@username|#approval-link" docs/plans/2026-01-14-baseline-failure-blocking.md` finds placeholders.

## GREEN: Passing Checklist (After Implementation)

- [ ] Approval section uses specific persona handles (no @username placeholders)
- [ ] Approval section uses concrete approval links (no #approval-link placeholders)
- [ ] Non-required approvals are explicitly marked as not required
