# Issue-Driven Delivery - Definition of Ready Test

## Scenario: Definition of Ready Gate

Validates that work items must meet Definition of Ready criteria before transitioning
from refinement to implementation.

## Given

- A work item in refinement state with approved plan
- Work item ready to transition to implementation

## Acceptance Criteria

### DoR Checklist Definition

- [x] DoR checklist defined in skill or reference document
- [x] Required items clearly distinguished from optional items
- [x] Checklist is actionable with verifiable criteria

### Required DoR Items

- [x] Acceptance criteria exist and are testable
- [x] Dependencies identified and documented (or confirmed none)
- [x] Mandatory tags applied (component, work-type, priority)
- [x] Plan approved and committed

### Optional DoR Items

- [x] Sizing/estimation documented (optional)
- [x] Spike completion verified if applicable (optional)
- [x] Design review complete if applicable (optional)
- [x] Team capacity confirmed (optional for Scrum mode)

### Validation Integration

- [x] DoR validation step added at refinement to implementation transition
- [x] Validation occurs at step 7 (after plan approval, before sub-task creation)
- [x] CLI commands provided to verify DoR items
- [x] Clear error message when DoR not met

### Customization

- [x] Teams can customize DoR via ways-of-working
- [x] Default DoR works without customization
- [x] Custom items can be added or removed

## Then

Definition of Ready gate prevents work from entering implementation without proper
preparation, reducing rework and blocked work during implementation.

## Verification Evidence

```bash
# Verify DoR section exists in SKILL.md
grep -ci "Definition of Ready\|DoR" skills/issue-driven-delivery/SKILL.md
# Result: 20 matches

# Verify DoR checklist exists
grep -c "acceptance criteria\|dependencies identified\|mandatory tags" skills/issue-driven-delivery/SKILL.md
# Result: 12 matches

# Verify validation commands documented
grep -c "gh issue view" skills/issue-driven-delivery/SKILL.md | head -1
# Result: Multiple CLI command examples

# Verify customization documented
grep -c "ways-of-working" skills/issue-driven-delivery/SKILL.md
# Result: Multiple references to customization via ways-of-working
```

## Notes

- DoR should be lightweight - avoid bureaucracy
- Required items are non-negotiable quality gates
- Optional items support specific team practices
- Error messages should guide remediation
