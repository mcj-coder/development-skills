# Plan Lifecycle Tracking Implementation Plan

**Issue:** #105
**Date:** 2026-01-07
**Status:** In Progress

## Approval History

| Phase           | Reviewer                 | Decision | Date       | Plan Commit | Comment Link |
| --------------- | ------------------------ | -------- | ---------- | ----------- | ------------ |
| Plan Refinement | Documentation Specialist | Feedback | 2026-01-07 | (context)   | (context)    |
| Plan Refinement | Agent Skill Engineer     | Feedback | 2026-01-07 | (context)   | (context)    |
| Plan Approval   | Tech Lead                | APPROVED | 2026-01-07 | (context)   | (context)    |

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
2. **Approval History table** - Phase, Reviewer, Decision, Date, Plan Commit, Comment Link
3. **Overview** - Brief description
4. **Scope** - In Scope / Out of Scope
5. **Implementation Tasks** - Numbered tasks with deliverables
6. **Acceptance Criteria Mapping** - AC to Task mapping
7. **BDD Verification Checklist** - Per-task verification items
8. **Review Personas** - Which personas review at each phase
9. **Evidence Requirements** - What evidence is needed
10. **Review History** - Feedback and resolutions by revision

#### Approval History Table Structure

```markdown
## Approval History

| Phase | Reviewer | Decision | Date | Plan Commit | Comment Link |
| ----- | -------- | -------- | ---- | ----------- | ------------ |
|       |          |          |      |             |              |
```

**Field Definitions:**

| Field        | Description                                                                    | Example        |
| ------------ | ------------------------------------------------------------------------------ | -------------- |
| Phase        | Workflow phase: Plan Refinement, Plan Approval, Implementation, Final Approval | Plan Approval  |
| Reviewer     | Role name from docs/roles/                                                     | Tech Lead      |
| Decision     | One of: Feedback, APPROVED                                                     | APPROVED       |
| Date         | ISO date (YYYY-MM-DD)                                                          | 2026-01-07     |
| Plan Commit  | 7-char SHA of plan state when reviewed                                         | abc1234        |
| Comment Link | Link to issue comment with review                                              | [comment](url) |

#### Review History Section Structure

```markdown
## Review History

### Rev 1 → Rev 2 (Plan Refinement)

**Documentation Specialist Feedback (2026-01-07):**

- **C1:** [Critical issue] → [Resolution taken]
- **I1:** [Important issue] → [Resolution taken]

**Agent Skill Engineer Feedback (2026-01-07):**

- **I1:** [Important issue] → [Resolution taken]

### Implementation Reviews

**Documentation Specialist (2026-01-07):**

- **M1:** [Minor issue] → [Fixed in commit abc123]
```

**Format:**

- Use severity prefixes: C (Critical), I (Important), M (Minor)
- Include date with reviewer name
- Show issue → resolution pattern for traceability
- Link to commits that addressed feedback

#### Status Values and Transitions

| Status        | Meaning                      | Trigger                                  | Who Updates |
| ------------- | ---------------------------- | ---------------------------------------- | ----------- |
| Draft         | Initial plan creation        | Plan created in step 4                   | Refiner     |
| Draft (Rev N) | Updated after feedback       | Feedback received                        | Refiner     |
| Approved      | Tech Lead approved           | Approval comment detected                | Refiner     |
| In Progress   | Implementation started       | Self-assign for implementation (step 7c) | Implementer |
| Complete      | All tasks done, reviews pass | Final approval received                  | Implementer |

**Transition Actions:**

1. **Draft → Draft (Rev N)**: Update plan, add feedback to Review History, commit
2. **Draft (Rev N) → Approved**: Add approval to Approval History, update status, commit
3. **Approved → In Progress**: Update status in plan header, commit
4. **In Progress → Complete**: Add final reviews to Approval History, update status, commit

**Deliverable:** `docs/references/plan-template.md`

### Task 2: Update Issue-Driven-Delivery Skill

Update `skills/issue-driven-delivery/SKILL.md` to add plan lifecycle requirements:

**issue-driven-delivery Step 4 additions:**

- Plan MUST include empty Approval History table (use template structure)
- Plan MUST include empty Review History section
- Plan status starts at "Draft"
- Commit message: `docs(plan): create implementation plan for issue #N`

**issue-driven-delivery Step 5 additions (after detecting approval):**

Immediately after detecting explicit approval comment:

1. Add approval row to Approval History table:
   - Phase: "Plan Approval"
   - Reviewer: Role of approver (e.g., "Tech Lead")
   - Decision: "APPROVED"
   - Date: Current date (YYYY-MM-DD)
   - Plan Commit: SHA of plan version that was approved
   - Comment Link: Link to approval comment
2. Update status from "Draft (Rev N)" to "Approved"
3. Commit: `docs(plan): record plan approval for issue #N`
4. Push to remote
5. Post acknowledgment: "Plan approval recorded in [commit SHA]"

**issue-driven-delivery Step 6 additions (when revisions requested):**

After receiving review feedback (before approval):

1. Add feedback row to Approval History table:
   - Phase: "Plan Refinement"
   - Decision: "Feedback"
2. Append feedback summary to Review History section:
   - Use severity prefixes (C/I/M)
   - Include link to full review comment
3. Implement resolutions
4. Append resolutions to Review History (issue → resolution)
5. Increment status: "Draft" → "Draft (Rev 2)" → "Draft (Rev 3)"
6. Commit: `docs(plan): address review feedback for issue #N`
7. Push and re-request approval

**issue-driven-delivery Step 8 additions (after implementation reviews):**

After receiving each implementation review:

1. Add review row to Approval History table:
   - Phase: "Implementation"
   - Decision: "Feedback" or "APPROVED"
2. If feedback received:
   - Append to Review History under "Implementation Reviews"
   - Link to commits that addressed feedback
3. Commit: `docs(plan): record implementation review for issue #N`

After final Tech Lead approval:

1. Add final approval row to Approval History
2. Update status to "Complete"
3. Commit: `docs(plan): mark plan complete for issue #N`

**issue-driven-delivery Step 10.5 enhancements (extends existing archival):**

Replace existing step 10.5 plan archival with enhanced version:

Before creating PR, perform plan lifecycle completion:

1. Verify plan status is "Complete" (not Draft, Approved, or In Progress)
2. Verify Approval History has all required entries:
   - At least one Plan Approval entry (Tech Lead)
   - Implementation review entries (one per Review Persona)
   - Final Approval entry (Tech Lead)
3. Verify Review History captures all feedback and resolutions
4. Archive plan: `git mv docs/plans/X.md docs/plans/archive/`
5. Commit: `docs(plan): complete lifecycle and archive for issue #N`
6. Push: `git push --force-with-lease`
7. Create PR (includes archival commit)

#### Plan Lifecycle Verification Checklist

Add to skill as verification before PR merge:

```markdown
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
```

**Deliverable:** Updated `skills/issue-driven-delivery/SKILL.md`

### Task 3: Archive Unarchived Plans

#### Discovery Process

1. List all plans in `docs/plans/*.md` (excluding archive/)
2. For each plan, extract issue number from header
3. Check issue state: `gh issue view N --json state`
4. If state=CLOSED and PR merged, plan should be archived

#### Known Unarchived Plans

- `docs/plans/2026-01-07-scrum-master-persona.md` → archive (from #109, PR #127 merged)

#### Archive Process

For each identified plan:

1. `git mv docs/plans/YYYY-MM-DD-name.md docs/plans/archive/`
2. Commit: `docs: archive completed plan for issue #N`
3. Document in issue comment: list of archived plans with issue numbers

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
- [ ] Template includes Approval History table with all columns defined
- [ ] Template includes field definitions for each Approval History column
- [ ] Template includes Review History section with example format
- [ ] Status values documented with triggers and responsibilities
- [ ] Status transition rules table present
- [ ] All 10 standard sections present
- [ ] No YAML frontmatter (templates are not active documents)
- [ ] Uses placeholder values: `YYYY-MM-DD`, `feature-name`, `#NNN`

### Task 2: Skill Update

- [ ] issue-driven-delivery Step 4 requires Approval History table
- [ ] issue-driven-delivery Step 4 requires Review History section
- [ ] issue-driven-delivery Step 5 specifies approval recording (WHO, WHEN, HOW)
- [ ] issue-driven-delivery Step 6 specifies revision feedback recording
- [ ] issue-driven-delivery Step 8 specifies implementation review recording
- [ ] issue-driven-delivery Step 10.5 enhanced with lifecycle verification
- [ ] Step 10.5 includes status verification before archive
- [ ] Step 10.5 includes Approval History completeness check
- [ ] Plan Lifecycle Verification checklist added
- [ ] Checklist items are measurable (not subjective)

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

**Task 1 (Template Creation):**

- Commit SHA for template file creation
- File link to `docs/references/plan-template.md`

**Task 2 (Skill Update):**

- Commit SHA for skill update
- File link to updated `skills/issue-driven-delivery/SKILL.md`

**Task 3 (Archive):**

- Commit SHA for plan archive
- List of archived plans with issue numbers

**Task 4 (Validation):**

- Lint output showing clean build (0 errors)

**Meta-verification (dogfooding):**

- This plan MUST include Approval History table
- This plan MUST be archived before PR merge
- This plan MUST have status="Complete" before merge

## Review History

### Rev 1 → Rev 2 (Plan Refinement)

**Documentation Specialist Feedback (2026-01-07):**

- **C1:** Missing Approval History table structure → Added exact table structure with field definitions
- **C2:** Status transition rules missing → Added status transition table with triggers and WHO
- **C3:** Review History structure undefined → Added Review History section structure with example
- **I1:** Step references vague → Changed to "issue-driven-delivery Step N" throughout
- **I2:** Verification checklist incomplete → Added measurable checklist items
- **I4:** Task 3 scope unclear → Added discovery process and archive steps

**Agent Skill Engineer Feedback (2026-01-07):**

- **C1:** Missing automation trigger for status updates → Added WHO, WHEN, HOW for each step
- **C2:** Step 10.5 archive timing conflicts → Clarified as "enhancement" extending existing step
- **C3:** Circular dependency in approval recording → Added "Plan Commit" and "Comment Link" fields
- **I1:** No guidance for In Progress status → Added status transition rules table
- **I2:** Review History appending vague → Added specific instructions per step
- **I4:** BDD verification not objective → Made all checklist items objective

### Implementation Reviews

(Pending - will be added after implementation reviews)
