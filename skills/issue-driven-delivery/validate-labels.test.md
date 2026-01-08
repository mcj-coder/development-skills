# validate-labels - BDD Tests

## Overview

Tests for the GitHub Actions workflow that validates required labels before state transitions.

**Related Files:**

- `.github/workflows/validate-labels.yml` - Installed workflow
- `skills/issue-driven-delivery/templates/validate-labels.yml` - Template workflow
- `docs/playbooks/label-validation.md` - Configuration playbook

## Baseline (No Workflow Present)

### Pressure Scenario 1: Missing Component Labels

Given an issue transitions to implementation
When no validation workflow exists
Then issues without component labels proceed undetected
And affected areas are unclear during development
And post-hoc labeling is forgotten or inconsistent

### Pressure Scenario 2: Uncategorized Work Types

Given issues are being verified and closed
When no validation enforces work-type labels
Then work type distribution metrics are inaccurate
And sprint reports show incomplete categorization
And planning capacity estimates lack data

### Pressure Scenario 3: Priority Drift

Given issues are closed without priority labels
When no validation catches missing priorities
Then priority metrics are incomplete
And retrospective analysis cannot assess priority handling
And process improvement lacks quantitative basis

## Baseline Observations (Simulated)

Without the workflow, typical problems include:

- "We closed 20 issues but half don't have priorities."
- "I can't tell what component this issue affected."
- "Our metrics dashboard shows 40% uncategorized work."
- "Sprint reports are unreliable due to missing labels."

## Assertions (Workflow Behavior)

### Trigger Assertions

- [ ] Workflow triggers on `issues.labeled` event
- [ ] Workflow triggers on `issues.unlabeled` event
- [ ] Workflow triggers on `issues.closed` event
- [ ] Workflow does NOT trigger on unrelated issue events

### Validation Rule Assertions

- [ ] `state:implementation` requires `component:*` label
- [ ] `state:verification` requires `work-type:*` label
- [ ] Issue close requires `priority:*` label
- [ ] `state:refinement` has no label requirements
- [ ] `state:grooming` has no label requirements
- [ ] `state:new-feature` has no label requirements

### Error Message Assertions

- [ ] Missing component label produces clear error message
- [ ] Missing work-type label produces clear error message
- [ ] Missing priority label produces clear error message
- [ ] Error messages include guidance on which label to add
- [ ] Error messages use `::warning::` or `::error::` annotations

### Edge Case Assertions

- [ ] Multiple missing labels are all reported
- [ ] Partial label match does not satisfy requirement (e.g., `component` vs `component:api`)
- [ ] Label removal triggers re-validation
- [ ] Adding required label after warning clears validation

## Scenarios

### Scenario 1: Implementation Without Component Label

Given issue #N exists with label `state:refinement`
And issue #N has NO `component:*` label
When `state:implementation` label is added to issue #N
Then workflow triggers with event action "labeled"
And workflow detects missing `component:*` label
And workflow outputs `::warning::` annotation
And warning message includes "component:" guidance
And workflow completes (non-blocking)

**Verification:**

```bash
# Before: Check issue has no component label
gh issue view N --json labels --jq '.labels[].name' | grep -c "^component:" || echo "0"
# Expected: 0

# Action: Add implementation state
gh issue edit N --add-label "state:implementation"

# After: Check workflow run
gh run list --workflow=validate-labels.yml --limit=1 --json conclusion,status
# Expected: completed with annotations
```

### Scenario 2: Verification Without Work-Type Label

Given issue #N exists with label `state:implementation`
And issue #N has `component:skill` label
And issue #N has NO `work-type:*` label
When `state:verification` label is added to issue #N
Then workflow triggers with event action "labeled"
And workflow validates component label (passes)
And workflow detects missing `work-type:*` label
And workflow outputs `::warning::` annotation
And warning message includes "work-type:" guidance

### Scenario 3: Close Without Priority Label

Given issue #N exists with labels `state:verification`, `component:skill`, `work-type:new-feature`
And issue #N has NO `priority:*` label
When issue #N is closed
Then workflow triggers with event action "closed"
And workflow detects missing `priority:*` label
And workflow outputs `::error::` annotation
And error message includes "priority:" guidance

### Scenario 4: All Labels Present - Passes

Given issue #N exists with labels:

- `state:verification`
- `component:skill`
- `work-type:new-feature`
- `priority:p2`

When issue #N is closed
Then workflow triggers with event action "closed"
And workflow validates all required labels exist
And workflow completes successfully (no warnings/errors)
And workflow logs "All required labels present"

### Scenario 5: Label Removed - Re-validates

Given issue #N exists with labels `state:implementation`, `component:skill`
And validation previously passed
When `component:skill` label is removed from issue #N
Then workflow triggers with event action "unlabeled"
And workflow re-validates current state
And workflow detects missing `component:*` label
And workflow outputs `::warning::` annotation

### Scenario 6: Multiple Missing Labels

Given issue #N exists with only `state:verification` label
And issue #N has NO `component:*`, `work-type:*`, or `priority:*` labels
When issue #N is closed
Then workflow triggers with event action "closed"
And workflow detects all three missing label types
And workflow outputs warnings for each missing label type
And all missing labels are listed in output

### Scenario 7: Refinement State - No Validation

Given issue #N exists with NO labels
When `state:refinement` label is added to issue #N
Then workflow triggers with event action "labeled"
And workflow detects refinement state
And workflow skips validation (refinement has no requirements)
And workflow completes successfully

### Scenario 8: Partial Label Match Fails

Given issue #N exists with label `component` (without suffix)
And issue #N needs to transition to implementation
When `state:implementation` label is added
Then workflow triggers
And workflow does NOT count `component` as valid (must be `component:*`)
And workflow outputs warning for missing `component:*` label

## Edge Cases

### Edge Case 1: Rapid Label Changes

Given issue #N exists in implementation state
When multiple labels are changed rapidly (within seconds)
Then multiple workflow runs may be triggered
And each run validates the current label state at execution time
And final state reflects latest validation result

### Edge Case 2: Issue Reopened

Given issue #N was previously closed with all labels
When issue #N is reopened
Then no validation is triggered (reopened is not validated)
And labels remain intact
And future transitions will be validated normally

### Edge Case 3: Labels Added During Workflow Run

Given workflow run is in progress for issue #N
When additional labels are added before workflow completes
Then current workflow run uses labels at time of trigger
And new label addition triggers new workflow run
And final state reflects all validations

## Test Evidence Format

For each test scenario, record:

```markdown
### Test: [Scenario Name]

**Date:** YYYY-MM-DD
**Issue:** #N
**Initial Labels:** [list of labels before test]
**Action:** [what was done]
**Expected:** [expected outcome]
**Actual:** [actual outcome]
**Workflow Run:** [run ID or link]
**Status:** PASS/FAIL
```

## Regression Checklist

Use this checklist when modifying the workflow:

- [ ] All trigger events still fire correctly
- [ ] Implementation validation requires component label
- [ ] Verification validation requires work-type label
- [ ] Close validation requires priority label
- [ ] Refinement/grooming states have no requirements
- [ ] Error messages are clear and actionable
- [ ] Label pattern matching is correct (prefix:suffix)
- [ ] Multiple missing labels are all reported
- [ ] No breaking changes to template configuration
