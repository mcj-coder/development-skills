# Plan Lifecycle Tracking Implementation Plan

**Issue:** #105
**Date:** 2026-01-07
**Status:** Draft

## Overview

Enforce plan lifecycle tracking with approval history, review tracking, and mandatory archival before PR merge.

## Scope

### In Scope

- Create plan template with Approval History and Review History sections
- Update issue-driven-delivery skill with plan lifecycle requirements
- Add verification step ensuring plan is complete and archived before PR merge
- Archive existing unarchived plans (#109 plan)

### Out of Scope

- Retroactively updating all existing plans with approval tables
- Automated plan status validation tooling
- CI enforcement of plan lifecycle

## Implementation Tasks

### Task 1: Create Plan Template

Create `docs/references/plan-template.md` with standard structure:

**Sections:**

1. **Header** - Title, Issue, Date, Status
2. **Approval History table** - Phase, Reviewer, Decision, Date, Commit
3. **Overview** - Brief description
4. **Scope** - In Scope / Out of Scope
5. **Implementation Tasks** - Numbered tasks with deliverables
6. **Acceptance Criteria Mapping** - AC to Task mapping
7. **BDD Verification Checklist** - Per-task verification items
8. **Review Personas** - Which personas review at each phase
9. **Evidence Requirements** - What evidence is needed
10. **Review History** - Feedback and resolutions by revision

**Status Values:**

| Status        | Meaning                           |
| ------------- | --------------------------------- |
| Draft         | Initial plan creation             |
| Draft (Rev N) | Updated after feedback            |
| Approved      | Tech Lead approved plan           |
| In Progress   | Implementation started            |
| Complete      | All tasks done, ready for archive |

**Deliverable:** `docs/references/plan-template.md`

### Task 2: Update Issue-Driven-Delivery Skill

Update `skills/issue-driven-delivery/SKILL.md` to add plan lifecycle requirements:

**Step 4 additions:**

- Plan MUST include Approval History table (initially empty)
- Plan status starts at "Draft"

**Step 5 additions:**

- After approval, update plan:
  - Add approval row to Approval History table
  - Update status to "Approved"
  - Commit and push plan update

**Step 6 additions:**

- When revisions requested, update plan:
  - Append feedback to Review History section
  - Increment revision in status (Draft Rev N)
  - Commit and push plan update

**Step 8 additions:**

- After implementation reviews, update plan:
  - Add review rows to Approval History table
  - Append feedback/resolutions to Review History
  - Update status to "Complete" after final approval

**Step 10.5 additions:**

- Add verification: "Plan status is Complete"
- Add verification: "Approval History table has all required entries"
- Add verification: "Review History captures all feedback"

#### New Section: Plan Lifecycle Verification

Add BDD checklist for plan completeness before PR merge:

```markdown
## Plan Lifecycle Verification

Before PR merge, verify plan is complete:

- [ ] Plan status is "Complete"
- [ ] Approval History has plan approval entry (Tech Lead)
- [ ] Approval History has implementation review entries
- [ ] Approval History has final approval entry (Tech Lead)
- [ ] Review History captures all feedback and resolutions
- [ ] Plan is archived: `git mv docs/plans/X.md docs/plans/archive/`
```

**Deliverable:** Updated `skills/issue-driven-delivery/SKILL.md`

### Task 3: Archive Unarchived Plans

Archive plans from completed issues that were not properly archived:

- `docs/plans/2026-01-07-scrum-master-persona.md` → archive (from #109)

Check for any other unarchived plans from merged PRs and archive them.

**Deliverable:** All completed plans in `docs/plans/archive/`

### Task 4: Run Linting Validation

1. Run `npm run lint` to validate markdown
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                       | Task           |
| ----------------------------------------- | -------------- |
| Plan template with Approval History table | Task 1         |
| Plan template with Review History section | Task 1         |
| Plan status values documented             | Task 1, Task 2 |
| Plan status updated on state changes      | Task 2         |
| Review results appended to plan           | Task 2         |
| Plan archived before PR merge             | Task 2         |
| BDD checklist for plan completeness       | Task 2         |

## BDD Verification Checklist

### Task 1: Plan Template

- [ ] File exists at `docs/references/plan-template.md`
- [ ] Template includes Approval History table structure
- [ ] Template includes Review History section structure
- [ ] Status values documented (Draft, Draft Rev N, Approved, In Progress, Complete)
- [ ] All standard sections present

### Task 2: Skill Update

- [ ] Step 4 mentions Approval History table
- [ ] Step 5 includes approval recording instructions
- [ ] Step 6 includes revision feedback recording
- [ ] Step 8 includes review recording instructions
- [ ] Step 10.5 includes plan archival
- [ ] Plan Lifecycle Verification section exists
- [ ] BDD checklist for plan completeness exists

### Task 3: Archive

- [ ] `docs/plans/2026-01-07-scrum-master-persona.md` moved to archive
- [ ] No other unarchived plans from merged PRs remain

### Task 4: Validation

- [ ] `npm run lint` passes with no errors

## Review Personas

| Phase          | Reviewers                                      | Focus                                |
| -------------- | ---------------------------------------------- | ------------------------------------ |
| Refinement     | Documentation Specialist, Agent Skill Engineer | Template structure, workflow clarity |
| Implementation | Documentation Specialist, Agent Skill Engineer | Content quality, integration         |
| Approval       | Tech Lead                                      | Strategic alignment, completeness    |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread
