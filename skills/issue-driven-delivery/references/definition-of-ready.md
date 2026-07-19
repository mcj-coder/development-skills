# Definition of Ready (DoR) Gate

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Before transitioning from refinement to implementation (step 7), verify the work item meets
the Definition of Ready. This gate ensures work is properly prepared, reducing rework and
blocked work during implementation.

### Required DoR Items (Must Pass)

All required items must be verified before transitioning to implementation:

- [ ] **Acceptance criteria exist** - Testable criteria defined in work item or linked plan
- [ ] **Dependencies identified** - Blocking/blocked relationships documented (or "none" confirmed)
- [ ] **Mandatory tags applied** - Component, work-type, and priority labels set
- [ ] **Plan approved** - Explicit approval comment exists in work item thread

### Optional DoR Items (Team-Specific)

Teams may add optional items via ways-of-working:

- [ ] Sizing/estimation documented (story points, t-shirt size)
- [ ] Spike completion verified (if research was required)
- [ ] Design review complete (for architectural changes)
- [ ] Team capacity confirmed (for Scrum mode sprint commitment)

### DoR Validation Commands

**GitHub:**

```bash
# Verify acceptance criteria exist (check issue body or linked plan)
gh issue view N --json body --jq '.body' | grep -qi "acceptance\|criteria\|should\|must" && echo "PASS: Acceptance criteria found" || echo "FAIL: Missing acceptance criteria"

# Verify mandatory tags
LABELS=$(gh issue view N --json labels --jq '.labels[].name')
echo "$LABELS" | grep -q "component:\|skill" && echo "PASS: Component tag" || echo "FAIL: Missing component tag"
echo "$LABELS" | grep -q "work-type:" && echo "PASS: Work-type tag" || echo "FAIL: Missing work-type tag"
echo "$LABELS" | grep -q "priority:" && echo "PASS: Priority tag" || echo "FAIL: Missing priority tag"

# Verify plan approval
gh issue view N --json comments --jq '.comments[].body' | grep -qiE "approved|lgtm" && echo "PASS: Plan approved" || echo "FAIL: Missing plan approval"

# Verify dependencies documented
gh issue view N --json body,comments --jq '[.body, .comments[].body] | join(" ")' | grep -qiE "blocked by|depends on|no dependencies|dependencies: none" && echo "PASS: Dependencies documented" || echo "WARN: Dependencies not explicitly documented"
```

### Automated Enforcement

Plan approval is enforced automatically via DangerJS (Rule 9). When a PR references an issue:

1. **Plan comment check** - DangerJS verifies the linked issue has a plan comment containing:
   - "## Plan" or "## Implementation Plan" or "## Refinement" header
   - Link to `docs/plans/` directory
   - "Awaiting approval" or "Ready for approval" language

2. **Approval check** - DangerJS verifies an approval comment exists containing:
   - "Approval acknowledged" or "Plan approved"
   - "Approved to proceed" or "Proceeding with"

PRs will receive warnings if plan approval is missing. See `dangerfile.js` Rule 9 for implementation.

**Exemplar:** [Issue #177](https://github.com/mcj-coder/development-skills/issues/177) demonstrates
the complete plan approval workflow with proper comment formatting.

### DoR Failure Handling

If DoR validation fails, do NOT transition to implementation. Instead:

1. **Identify gaps** - Review which required items failed
2. **Address gaps** - Add missing acceptance criteria, tags, or approval
3. **Re-validate** - Run DoR check again
4. **Document** - Post DoR validation result to work item comment

**Error message template:**

```text
Definition of Ready: FAILED

Cannot transition to implementation. Missing required items:
- Acceptance criteria not found in issue body
- Missing priority tag

Actions required:
1. Add acceptance criteria to issue body or link to approved plan
2. Apply priority label (priority:p0 through priority:p4)
3. Re-run DoR validation before proceeding
```

### Customizing DoR

Teams can customize DoR requirements in their ways-of-working:

```markdown
# docs/ways-of-working/definition-of-ready.md

## Our Definition of Ready

### Required (in addition to defaults)

- Story points estimated
- UX mockups approved (for UI changes)

### Not Required (override defaults)

- Dependencies documentation (small team, implicit)
```

Reference your custom DoR in AGENTS.md or repository documentation.
