# Cross-Reference to Requirements-Gathering Plan

**Issue:** #117
**Date:** 2026-01-07
**Status:** Draft

## Overview

Add explicit cross-reference to the `requirements-gathering` skill in `issue-driven-delivery`
when a work item doesn't exist.

## Scope

### In Scope

- Update step 2 in issue-driven-delivery to reference requirements-gathering skill
- Add "See Also" section at end of skill with related skill references

### Out of Scope

- Changes to requirements-gathering skill itself
- Other issue-driven-delivery modifications

## Implementation Tasks

### Task 1: Update Step 2 with Cross-Reference

Update step 2 in `skills/issue-driven-delivery/SKILL.md`:

**Current:**

```markdown
2. Confirm a Taskboard work item exists for the work. If none exists, create the
   work item before making any changes.
```

**Proposed:**

```markdown
2. Confirm a Taskboard work item exists for the work. If none exists, use the
   `requirements-gathering` skill to create the work item before making any changes.
```

**Deliverable:** Updated step 2

### Task 2: Add See Also Section

Add "See Also" section at end of `skills/issue-driven-delivery/SKILL.md`:

```markdown
## See Also

- `requirements-gathering` - Use when no work item exists; creates ticket then stops
- `superpowers:brainstorming` - Design exploration for existing tickets
- `superpowers:writing-plans` - Implementation planning for existing tickets
```

**Deliverable:** New See Also section

### Task 3: Run Linting Validation

1. Run `npm run lint` to validate changes
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                       | Task   |
| --------------------------------------------------------- | ------ |
| Step 2 references requirements-gathering skill by name    | Task 1 |
| Workflow clarified: requirements-gathering creates ticket | Task 1 |
| Cross-reference in See Also section                       | Task 2 |
| Linting passes                                            | Task 3 |

## BDD Verification Checklist

### Task 1: Step 2 Update

- [ ] Step 2 mentions `requirements-gathering` skill
- [ ] "If none exists" path references the skill

### Task 2: See Also Section

- [ ] See Also section exists at end of file
- [ ] References requirements-gathering skill
- [ ] Clarifies workflow relationship

### Task 3: Validation

- [ ] `npm run lint` passes with no errors

## Review Personas

| Phase          | Reviewers                | Focus                 |
| -------------- | ------------------------ | --------------------- |
| Implementation | Documentation Specialist | Clarity, completeness |
| Approval       | Tech Lead                | Standards compliance  |

## Evidence Requirements

- Commit SHA for implementation
- Lint output showing clean build
