# Skill TDD Remediation Plan

**Issue:** #89
**Date:** 2026-01-06
**Status:** Draft - Awaiting Approval

## Summary

Five skills were merged without following the proper TDD methodology defined in
`writing-skills`. This plan remediates by running actual baseline tests (RED
phase) and verifying the skills address observed failures (GREEN phase).

## Skills Requiring Remediation

| Skill | Issue | Current State |
|-------|-------|---------------|
| automated-standards-enforcement | #3 | Merged, has BDD docs but no baseline |
| walking-skeleton-delivery | #29 | Merged, has BDD docs but no baseline |
| testcontainers-integration-tests | #28 | Merged, has BDD docs but no baseline |
| technical-debt-prioritisation | #27 | Merged, has BDD docs but no baseline |
| agent-workitem-automation | #36 | Updated, has BDD docs but no baseline |

## Remediation Approach

For each skill, follow the `writing-skills` TDD methodology:

### RED Phase (Baseline Testing)

1. Create a sub-agent WITHOUT the skill loaded
2. Present pressure scenario from the skill's test file
3. Document exact agent behavior:
   - What choices did they make?
   - What rationalizations did they use (verbatim)?
   - Which pressures triggered violations?
4. Commit baseline results to `{skill-name}.baseline.md`

### GREEN Phase (Skill Verification)

1. Create a sub-agent WITH the skill loaded
2. Run same pressure scenarios
3. Verify agent now complies
4. If agent still fails, update skill to address specific failures
5. Document compliance in test file

### REFACTOR Phase (Loophole Closure)

1. Identify any NEW rationalizations from testing
2. Add explicit counters to skill
3. Update rationalization tables with real observed rationalizations
4. Re-test until bulletproof

## Task Breakdown

### Task 1: Baseline automated-standards-enforcement

- Load pressure scenarios from test file
- Run sub-agent WITHOUT skill
- Document baseline failures
- Commit results

### Task 2: Verify automated-standards-enforcement

- Run sub-agent WITH skill
- Verify compliance
- Update if needed

### Task 3: Baseline walking-skeleton-delivery

- Same process as Task 1

### Task 4: Verify walking-skeleton-delivery

- Same process as Task 2

### Task 5: Baseline testcontainers-integration-tests

- Same process as Task 1

### Task 6: Verify testcontainers-integration-tests

- Same process as Task 2

### Task 7: Baseline technical-debt-prioritisation

- Same process as Task 1

### Task 8: Verify technical-debt-prioritisation

- Same process as Task 2

### Task 9: Baseline agent-workitem-automation

- Same process as Task 1

### Task 10: Verify agent-workitem-automation

- Same process as Task 2

### Task 11: REFACTOR all skills

- Update rationalization tables with observed data
- Add red flags based on actual behavior
- Re-test any updated skills

### Task 12: Create PR and close issue

- Commit all baseline and verification evidence
- Create PR with remediation summary
- Get Tech Lead approval
- Merge and close issue

## Execution Strategy

Run Tasks 1-2 sequentially for first skill to establish pattern, then parallelize
remaining skills (2 at a time per user constraint).

## Evidence Requirements

For each skill:
- [ ] Baseline document showing agent failures WITHOUT skill
- [ ] Verbatim rationalizations captured
- [ ] Verification showing agent compliance WITH skill
- [ ] Updated test file with real observed behaviors
- [ ] Rationalization table updated with actual data

## Acceptance Criteria

- [ ] All 5 skills have documented RED phase baselines
- [ ] All 5 skills pass GREEN phase verification
- [ ] Rationalization tables reflect real agent behavior
- [ ] Red flags lists based on actual observations
- [ ] PR merged with remediation evidence

## References

- `writing-skills` skill - TDD methodology for skills
- Each skill's `.test.md` file - Pressure scenarios to use
