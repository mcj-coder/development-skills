# Label Validation Script Implementation Plan

**Issue:** #144
**Date:** 2026-01-08
**Status:** Draft

## Approval History

| Phase         | Reviewer  | Decision | Date | Plan Commit | Comment Link |
| ------------- | --------- | -------- | ---- | ----------- | ------------ |
| Plan Approval | Tech Lead | PENDING  | -    | -           | -            |

## Overview

Create automation to validate that issues have required tags before state transitions.
This ensures issues are properly categorized at each workflow phase.

**Validation Rules:**

| State Transition         | Required Labels | Rationale                       |
| ------------------------ | --------------- | ------------------------------- |
| → `state:refinement`     | (none)          | Initial planning can start      |
| → `state:implementation` | `component:*`   | Must know what area is affected |
| → `state:verification`   | `work-type:*`   | Must categorize the work type   |
| → Issue Closed           | `priority:*`    | Must have priority for metrics  |

## Scope

### In Scope

- Template GitHub Actions workflow for label validation
- Installed workflow for this repository
- Playbook documenting configuration and rules
- README.md quick reference update
- BDD test file for regression testing

### Out of Scope

- Automatic label suggestion (future enhancement)
- Cross-validation with other systems
- Label creation automation

## Implementation Tasks

### Task 1: Create BDD Test File

Create `skills/issue-driven-delivery/validate-labels.test.md` with:

- Baseline scenarios showing pain points without validation
- Assertions for each validation rule
- Test scenarios for pass/fail conditions
- Edge cases

**Deliverable:** `skills/issue-driven-delivery/validate-labels.test.md`

### Task 2: Create Template Workflow

Create `skills/issue-driven-delivery/templates/validate-labels.yml` with:

- Trigger on: `issues.labeled`, `issues.unlabeled`, `issues.closed`
- Label pattern matching for component, work-type, priority
- Validation logic per state transition
- Warning/error output with guidance
- Configurable label patterns

**Deliverable:** `skills/issue-driven-delivery/templates/validate-labels.yml`

### Task 3: Install Workflow in Repository

Create `.github/workflows/validate-labels.yml` customized for this repository:

- Label patterns configured for repository conventions
- State labels configured (`state:implementation`, `state:verification`)

**Deliverable:** `.github/workflows/validate-labels.yml`

### Task 4: Create Playbook

Create `docs/playbooks/label-validation.md` with:

- Overview and purpose
- Validation rules table
- Configuration instructions
- Error message explanations
- Troubleshooting guide

**Deliverable:** `docs/playbooks/label-validation.md`

### Task 5: Update README.md

Add quick reference in Automation section.

**Deliverable:** Updated README.md

### Task 6: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                   | Task   |
| ----------------------------------------------------- | ------ |
| Template workflow in skill's `templates/` folder      | Task 2 |
| Customized workflow installed in `.github/workflows/` | Task 3 |
| Workflow blocks state transitions when tags missing   | Task 3 |
| Clear error messages identify missing tags            | Task 2 |
| README.md updated with quick reference                | Task 5 |
| `docs/playbooks/label-validation.md` created          | Task 4 |
| All linting passes (`npm run lint`)                   | Task 6 |

## BDD Verification Checklist

### Task 1: BDD Test File

- [ ] File exists at `skills/issue-driven-delivery/validate-labels.test.md`
- [ ] Contains baseline scenarios
- [ ] Contains assertions for each validation rule
- [ ] Contains test scenarios with verification steps

### Task 2: Template Workflow

- [ ] File exists at `skills/issue-driven-delivery/templates/validate-labels.yml`
- [ ] YAML is valid (no syntax errors)
- [ ] Contains trigger configuration for issues events
- [ ] Contains configurable label patterns
- [ ] Contains validation logic for each state

### Task 3: Installed Workflow

- [ ] File exists at `.github/workflows/validate-labels.yml`
- [ ] Label patterns configured correctly
- [ ] Workflow validates successfully
- [ ] Posts error/warning when validation fails

### Task 4: Playbook

- [ ] File exists at `docs/playbooks/label-validation.md`
- [ ] Has valid frontmatter
- [ ] Documents all validation rules
- [ ] Contains troubleshooting section

### Task 5: README Update

- [ ] README.md references validate-labels workflow
- [ ] Quick reference is in Automation section

### Task 6: Validation

- [ ] `npm run lint` passes with no errors

## Technical Approach

### Workflow Trigger Strategy

The workflow cannot truly "block" a label from being added - GitHub doesn't support
label transition blocking. Instead, the workflow will:

1. Detect state label changes
2. Validate required labels exist
3. Post a comment with warnings/errors if validation fails
4. Optionally remove the state label (configurable)

### Label Pattern Matching

Use bash pattern matching for flexible label detection:

```bash
# Check for component label
if echo "$LABELS" | grep -qE "^component:"; then
  HAS_COMPONENT=true
fi
```

### Output Format

Use GitHub Actions annotations for visibility:

```bash
echo "::warning title=Missing Label::Issue requires 'component:*' label before implementation"
echo "::error title=Validation Failed::Cannot close issue without 'priority:*' label"
```

## Review Personas

| Phase          | Reviewers                         | Focus                |
| -------------- | --------------------------------- | -------------------- |
| Refinement     | Tech Lead, Documentation Spec     | Plan completeness    |
| Implementation | DevOps Engineer, Senior Developer | Workflow correctness |
| Approval       | Tech Lead                         | Strategic alignment  |

## Evidence Requirements

**Task 1:**

- Commit SHA for BDD test file
- File link to test file

**Task 2:**

- Commit SHA for template workflow
- File link to template

**Task 3:**

- Commit SHA for installed workflow
- File link to workflow
- Test run showing validation (pass and fail cases)

**Task 4:**

- Commit SHA for playbook
- File link to playbook

**Task 5:**

- Commit SHA for README update
- Diff showing added reference

**Task 6:**

- Lint output showing clean build (0 errors)

## Review History

_No reviews yet._
