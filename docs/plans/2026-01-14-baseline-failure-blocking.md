---
status: Draft
version: v1
issue: #361
created: 2026-01-14
last_updated: 2026-01-14
---

# Design Plan: Baseline Failure Blocking Rule

## Version History

| Version | Date       | Changes        | Discussion | Approved By | Follow-up Issues |
| ------- | ---------- | -------------- | ---------- | ----------- | ---------------- |
| v1      | 2026-01-14 | Initial design | #361       | TBD         | -                |

**Note:** Amendments during implementation are appended here with new version numbers (v1.1, v1.2, etc.)

## Approval

**Design Approved By:**

- [ ] Product Owner: @username (2026-01-14) #approval-link
- [ ] Tech Lead: @username (2026-01-14) #approval-link
- [ ] Security Reviewer: @username (2026-01-14) [if required] #approval-link
- [ ] Architecture Reviewer: @username (2026-01-14) [if required] #approval-link
- [ ] QA Reviewer: @username (2026-01-14) [if required] #approval-link

**Status:** `Draft` -> `Approved v1` (when all approvals received)
**Approved Date:** YYYY-MM-DD
Ready to move to implementation.

---

## Summary

Document the baseline failure handling rule: if baseline verification fails, create or reference a
blocking issue and pause the current task until the baseline passes.

## Issue Context

**Parent Issue:** #361 - Document baseline test failure handling and block work until resolved
**Epic Issue:** N/A
**Related ADRs:** N/A

## Refinement Participants

**Required Personas:**

- Product Owner
- Scrum Master
- Tech Lead
- QA Engineer

**Specialist Personas (if applicable):**

- Documentation Specialist

**Participants in this refinement:**

- @mcj-coder (Tech Lead)

## Key Requirements

### Functional Requirements

1. **Baseline failure handling:** Document that baseline failures must be addressed immediately.
   - Acceptance criterion: AGENTS.md explicitly states baseline failures must be addressed immediately.
   - Acceptance criterion: AGENTS.md states current work is blocked until baseline passes.

2. **Blocking issue requirement:** Document that a blocking issue must be created or referenced.
   - Acceptance criterion: CLAUDE.md mirrors the same baseline failure rule.
   - Acceptance criterion: Guidance requires creating a blocking issue if none exists.

### Non-Functional Requirements

- **Documentation:** Agent-facing documentation is consistent and unambiguous.

## Success Criteria

**Definition of Done for this feature:**

- [ ] AGENTS.md states baseline failures must be addressed immediately.
- [ ] AGENTS.md states current work is blocked until baseline passes.
- [ ] CLAUDE.md mirrors the same baseline failure rule.
- [ ] Guidance requires creating a blocking issue if none exists.
- [ ] BDD checklist (RED/GREEN) evidence recorded.

## Architecture Approach

### High-Level Design

Update AGENTS.md and CLAUDE.md to include a concise baseline failure rule and apply
BDD checklist evidence for documentation changes.

### Technology Choices

- **Documentation:** Markdown in AGENTS.md and CLAUDE.md

## Testing Approach

### System Tests (BDD)

**Scope:** Documentation behavior and enforcement requirements

**Key Scenarios (Gherkin):**

```gherkin
Scenario: Baseline failure blocks work
  Given baseline verification fails
  When an agent attempts to continue the task
  Then the agent creates or references a blocking issue
  And the agent pauses until baseline passes
```

**Test Organization:**

- BDD checklist: `docs/plans/2026-01-14-baseline-failure-blocking-template.bdd.md`

## Security Considerations

No security impact expected for this documentation change.

## Breaking Changes

No breaking changes.

## Expected Artefacts

### Documentation Changes

- [ ] Update `AGENTS.md`
- [ ] Update `CLAUDE.md`

## Deployment Strategy

**Deployment:** Standard merge to main.

## Work Breakdown

### Task Breakdown

| Task | Description                  | Role/Skillset | Estimate |
| ---- | ---------------------------- | ------------- | -------- |
| 1    | RED BDD checklist            | Documentation | 1h       |
| 2    | Update AGENTS.md + CLAUDE.md | Documentation | 1h       |
| 3    | GREEN BDD evidence           | Documentation | 1h       |

## Risks and Mitigations

| Risk                          | Likelihood | Impact | Mitigation                             |
| ----------------------------- | ---------- | ------ | -------------------------------------- |
| Rule is ignored by agents     | Medium     | Medium | Clear guidance + evidence requirements |
| Confusion about when to block | Low        | Medium | Concise wording and examples           |

## Dependencies

### Internal Dependencies

- None

### External Dependencies

- None

## Implementation Notes

- Follow TDD/BDD documentation process.
- Update AGENTS.md and CLAUDE.md in the same commit batch.

### For Reviewers

Review Roles: Documentation Specialist, Scrum Master, Tech Lead, QA Engineer.
Run `C:\Users\mcj\.claude\persona-config.sh` before starting line-level reviews.

---

## Follow-up Issues

Issues created during implementation/review for future work:

| Issue      | Title | Reason | Target Release | Status |
| ---------- | ----- | ------ | -------------- | ------ |
| (none yet) | -     | -      | -              | -      |

## Retrospective

After implementation has been approved and verified.

**Completed:** YYYY-MM-DD
**Participants:** @participant1, @participant2

### What Went Well

- TBD

### What Could Be Improved

- TBD

### Action Items

| Action | Owner | Target Date | Status |
| ------ | ----- | ----------- | ------ |
| TBD    | TBD   | YYYY-MM-DD  | Open   |
