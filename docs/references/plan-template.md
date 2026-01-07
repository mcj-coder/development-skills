# Plan Template

This template provides the standard structure for implementation plans.
Copy this template when creating a new plan at `docs/plans/YYYY-MM-DD-feature-name.md`.

When copying, replace the template header above with your plan title and delete
this instruction block.

---

<!-- START TEMPLATE - Copy from here -->

## [Feature Name] Implementation Plan

**Issue:** #NNN
**Date:** YYYY-MM-DD
**Status:** Draft

## Approval History

| Phase | Reviewer | Decision | Date | Plan Commit | Comment Link |
| ----- | -------- | -------- | ---- | ----------- | ------------ |
|       |          |          |      |             |              |

**Field Definitions:**

| Field        | Description                                                                    |
| ------------ | ------------------------------------------------------------------------------ |
| Phase        | Workflow phase: Plan Refinement, Plan Approval, Implementation, Final Approval |
| Reviewer     | Role name from docs/roles/ (e.g., Tech Lead, Documentation Specialist)         |
| Decision     | One of: Feedback, APPROVED                                                     |
| Date         | ISO date format (YYYY-MM-DD)                                                   |
| Plan Commit  | 7-character SHA of plan state when reviewed                                    |
| Comment Link | Markdown link to issue comment with review                                     |

## Overview

Brief description of what this plan implements and why.

## Scope

### In Scope

- Item 1
- Item 2

### Out of Scope

- Item 1
- Item 2

## Implementation Tasks

### Task 1: [Task Name]

Description of what this task accomplishes.

**Deliverable:** [Specific file or artifact]

### Task 2: [Task Name]

Description of what this task accomplishes.

**Deliverable:** [Specific file or artifact]

### Task N: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria | Task   |
| ------------------- | ------ |
| [AC from issue]     | Task N |

## BDD Verification Checklist

### Task 1: [Task Name]

- [ ] Verification item 1
- [ ] Verification item 2

### Task 2: [Task Name]

- [ ] Verification item 1
- [ ] Verification item 2

### Task N: Validation

- [ ] `npm run lint` passes with no errors

## Review Personas

| Phase          | Reviewers        | Focus               |
| -------------- | ---------------- | ------------------- |
| Refinement     | [Role 1, Role 2] | [Focus area]        |
| Implementation | [Role 1, Role 2] | [Focus area]        |
| Approval       | Tech Lead        | Strategic alignment |

## Evidence Requirements

**Task 1:**

- Commit SHA for [deliverable]
- File link to [file]

**Task N (Validation):**

- Lint output showing clean build (0 errors)

## Review History

### Rev 1 → Rev 2 (Plan Refinement)

**[Reviewer Name] Feedback (YYYY-MM-DD):**

- **C1:** [Critical issue] → [Resolution taken]
- **I1:** [Important issue] → [Resolution taken]
- **M1:** [Minor issue] → [Resolution taken]

### Implementation Reviews

**[Reviewer Name] (YYYY-MM-DD):**

- **I1:** [Issue] → [Fixed in commit abc1234]

---

## Status Values and Transitions

| Status        | Meaning                      | Trigger                        | Who Updates |
| ------------- | ---------------------------- | ------------------------------ | ----------- |
| Draft         | Initial plan creation        | Plan created                   | Refiner     |
| Draft (Rev N) | Updated after feedback       | Feedback received              | Refiner     |
| Approved      | Tech Lead approved           | Approval comment detected      | Refiner     |
| In Progress   | Implementation started       | Self-assign for implementation | Implementer |
| Complete      | All tasks done, reviews pass | Final approval received        | Implementer |

**Transition Actions:**

1. **Draft → Draft (Rev N)**: Update plan, add feedback to Review History, commit
2. **Draft (Rev N) → Approved**: Add approval to Approval History, update status, commit
3. **Approved → In Progress**: Update status in plan header, commit
4. **In Progress → Complete**: Add final reviews to Approval History, update status, commit

---

## Plan Lifecycle Verification

Before PR merge, verify plan is complete:

- [ ] Plan status is "Complete" (not Draft, Approved, or In Progress)
- [ ] Approval History table exists with markdown table format
- [ ] Approval History has Plan Approval entry (Tech Lead)
- [ ] Approval History has >= 1 Implementation entry per Review Persona
- [ ] Approval History has Final Approval entry (Tech Lead)
- [ ] Review History section exists
- [ ] Review History has entry for each "Feedback" decision
- [ ] Review History resolutions link to fixing commits
- [ ] Plan archived: file exists at `docs/plans/archive/YYYY-MM-DD-*.md`
- [ ] Plan NOT in active: file removed from `docs/plans/`
