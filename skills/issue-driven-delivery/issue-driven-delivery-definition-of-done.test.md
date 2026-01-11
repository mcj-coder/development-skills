# Issue-Driven Delivery - Definition of Done Test

## Scenario: Definition of Done Checklist

Validates that work items must meet Definition of Done criteria before closing,
consolidating all completion requirements into an explicit checklist.

## Given

- A work item in verification state
- All sub-tasks completed
- Work item ready to close

## Acceptance Criteria

### DoD Checklist Definition

- [x] DoD checklist defined in skill or reference document
- [x] Required items clearly distinguished from optional items
- [x] Checklist consolidates scattered completion requirements

### Required DoD Items

- [x] All tests pass (unit, integration, BDD validation)
- [x] PR created and merged
- [x] Plan archived to docs/plans/archive/
- [x] Mandatory tags complete (component, work-type, priority)
- [x] Role-based reviews completed

### Optional DoD Items

- [x] Documentation updated (if applicable)
- [x] Release notes drafted (if applicable)
- [x] Metrics/telemetry verified (if applicable)
- [x] Performance validated (if applicable)

### Validation Integration

- [x] DoD validation step added before work item close (step 20)
- [x] CLI commands provided to verify DoD items
- [x] Clear error message when DoD not met
- [x] DoD check prevents premature closure

### Customization

- [x] Teams can customize DoD via ways-of-working
- [x] Default DoD works without customization
- [x] Custom items can be added or removed

## Then

Definition of Done checklist ensures work items are fully complete before closure,
preventing incomplete work from being marked done and improving delivery quality.

## Verification Evidence

```bash
# Verify DoD section exists in SKILL.md
grep -ci "Definition of Done\|DoD" skills/issue-driven-delivery/SKILL.md
# Result: 19 matches

# Verify DoD checklist items documented
grep -c "tests pass\|PR.*merged\|plan archived\|tags complete\|reviews completed" skills/issue-driven-delivery/SKILL.md
# Result: 14 matches

# Verify step 20 references DoD
grep -A2 "^20\." skills/issue-driven-delivery/SKILL.md | grep -c "Definition of Done"
# Result: 1 match - step 20 references DoD validation

# Verify customization documented
grep -c "ways-of-working" skills/issue-driven-delivery/SKILL.md
# Result: Multiple references to customization
```

## Notes

- DoD consolidates requirements scattered across steps 10, 10.5, 17, 20
- Required items are non-negotiable completion gates
- Optional items support specific team practices
- DoD is the mirror of DoR - entry vs exit criteria
