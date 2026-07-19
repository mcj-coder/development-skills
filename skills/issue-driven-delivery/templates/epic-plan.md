# Epic Plan Requirements

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Epics require comprehensive planning before implementation begins. Unlike regular issues,
epics coordinate multiple child issues and require explicit plan files.

### Epic Definition

An **epic** is a work item that:

- Decomposes into 3+ child issues
- Spans multiple PRs or implementation phases
- Requires coordination across components or domains
- Has acceptance criteria that span child issue scope

### Plan File Requirement

**Before creating child issues**, epics MUST have a plan file:

1. Create plan file at `docs/plans/YYYY-MM-DD-epic-N-description.md`
2. Post plan link in epic issue body or first comment
3. Plan must include child issue breakdown
4. Plan approval required before child issue creation

**Plan template for epics:**

```markdown
# Epic Plan: [Title]

**Epic:** #N
**Status:** Draft | Approved | In Progress | Complete
**Created:** YYYY-MM-DD

## Overview

[Brief description of epic scope and goals]

## Child Issue Breakdown

| Issue | Title                | Component | Depends On |
| ----- | -------------------- | --------- | ---------- |
| #N+1  | [First child issue]  | backend   | -          |
| #N+2  | [Second child issue] | frontend  | #N+1       |

## Implementation Order

1. [First phase - which child issues]
2. [Second phase - which child issues]

## Acceptance Criteria

- [ ] All child issues completed
- [ ] Integration verified
- [ ] [Epic-level criteria]

## Approval History

| Date | Approver | Decision | Notes |
| ---- | -------- | -------- | ----- |

## Archive

**Archived:** YYYY-MM-DD
**Final Status:** Complete
```

### Epic Lifecycle

```text
Epic Created
    ↓
Create Plan File → Post link in epic → Get approval
    ↓
Create Child Issues (referencing plan)
    ↓
Implement Child Issues (track in plan)
    ↓
All Children Complete
    ↓
Update Plan Status to "Complete"
    ↓
Archive Plan: git mv docs/plans/epic-N.md docs/plans/archive/
    ↓
Close Epic
```

### Epic DoD Additions

In addition to standard DoD, epics require:

- [ ] **Plan exists** - Plan file created before child issues
- [ ] **All children closed** - Every child issue completed
- [ ] **Plan archived** - Plan in `docs/plans/archive/` with "Complete" status
- [ ] **Epic acceptance criteria** - All epic-level criteria verified

### Common Epic Mistakes

| Mistake                         | Impact                                   | Prevention                         |
| ------------------------------- | ---------------------------------------- | ---------------------------------- |
| No plan file                    | No coordination, scattered child issues  | Create plan BEFORE child issues    |
| Plan not linked to epic         | Plan disconnected from tracking          | Post plan link in epic body        |
| Child issues created first      | Implementation before planning           | Enforce plan-first workflow        |
| Plan not archived               | Incomplete lifecycle, lost documentation | Archive plan when epic closes      |
| Epic closed before all children | Incomplete work marked complete          | DoD validation checks child status |
