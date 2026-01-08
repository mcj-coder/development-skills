# Issue-Driven Delivery Enhancement Epic Implementation Plan

**Issue:** #139
**Date:** 2026-01-08
**Status:** Draft (Rev 2)

## Approval History

| Phase           | Reviewer     | Decision | Date       | Plan Commit | Comment Link |
| --------------- | ------------ | -------- | ---------- | ----------- | ------------ |
| Plan Refinement | Tech Lead    | Feedback | 2026-01-08 | e39f4df     | (inline)     |
| Plan Refinement | Scrum Master | Feedback | 2026-01-08 | e39f4df     | (inline)     |

## Overview

This plan defines the refinement and orchestration strategy for epic #139, which enhances
`issue-driven-delivery` with backlog grooming capabilities, process skill routing, playbook
documentation, and automation scripts.

**Epic Goal:** Enhance the issue-driven-delivery workflow to handle real-world backlogs with
issues in various states of readiness, while automating common backlog management tasks.

## Scope

### In Scope

- Epic orchestration and child ticket coordination
- Dependency graph validation and metadata correction
- Child ticket readiness assessment (all 10 tickets)
- Gap analysis and missing scope identification
- Implementation order with priority rationale
- Playbook structure planning
- Incremental verification strategy

### Out of Scope

- Actual implementation of child tickets (each has its own plan)
- Changes to external dependencies (e.g., #137 already complete)
- Superpowers skill modifications (external dependency)

## Definition of Ready / Definition of Done

### Epic Definition of Ready (DoR)

Before beginning epic execution:

- [ ] All 10 child tickets created with issue numbers
- [ ] Dependency metadata correct (no TBD placeholders in issue bodies)
- [ ] All acceptance criteria mapped to child tickets
- [ ] Implementation order documented with rationale
- [ ] Playbook structure defined

### Epic Definition of Done (DoD)

Epic is complete when:

- [ ] All 10 child tickets closed (state: complete)
- [ ] All 18 acceptance criteria verified with evidence
- [ ] Brownfield verification (#149) complete with passing results
- [ ] All documentation accurate and installed
- [ ] All scripts execute successfully
- [ ] All hooks trigger correctly
- [ ] `npm run lint` passes with 0 errors

## Child Ticket Analysis

### Dependency Graph (from issue)

```text
#140 (Process Skill Router) [No dependencies - FOUNDATION]
    ↓
#141 (Skill Precondition Guards) [Depends on #140]
    ↓
#142 (Backlog Grooming Phase) [Depends on #141, #137✓]
    ↓
┌───┬───┬───┬───┬───┐
│   │   │   │   │   │
#143 #144 #145 #146 #147 #148 (Automation Scripts)
│   │   │   │   │   │
└───┴───┴───┴───┴───┘
            ↓
#149 (Brownfield Verification) [Depends on all automation]
```

### Child Ticket Status Assessment

| Ticket | Title                     | Priority | Blocked?   | Ready?  | Notes                        |
| ------ | ------------------------- | -------- | ---------- | ------- | ---------------------------- |
| #140   | Process Skill Router      | P1       | No         | **YES** | Foundation - no dependencies |
| #141   | Skill Precondition Guards | P1       | Yes (#140) | No      | Needs #140 first             |
| #142   | Backlog Grooming Phase    | P1       | Yes (#141) | No      | Needs #141 + #137 (done)     |
| #143   | Project/Taskboard Sync    | P2       | Yes (#142) | No      | Needs #142                   |
| #144   | Label Validation          | P2       | Yes (#142) | No      | Needs #142                   |
| #145   | Duplicate Detection       | P2       | Yes (#142) | No      | Needs #142                   |
| #146   | Blocked/Blocking Sync     | P2       | Yes (#142) | No      | Needs #142                   |
| #147   | Standards Compliance      | P2       | Yes (#142) | No      | Needs #142                   |
| #148   | Backlog Health Report     | P2       | Yes (#142) | No      | Needs #142                   |
| #149   | Brownfield Verification   | P1       | Yes (all)  | No      | Final verification           |

## Implementation Tasks

### Task 0: Fix Dependency Metadata (Pre-Execution)

Update child issue bodies to replace TBD placeholders with concrete issue numbers.

1. Update #141 body: Replace "Blocked by: #TBD" with "Blocked by: #140"
2. Update #142 body: Replace "Blocked by: #TBD" with "Blocked by: #141"
3. Update #143-#148 bodies: Add "Blocked by: #142"
4. Update #149 body: Add "Blocked by: #143, #144, #145, #146, #147, #148"
5. Verify automation scripts (get-priority-order.sh) can parse dependency metadata

**Deliverable:** All child tickets have concrete blocker references (concrete evidence)

### Task 1: Validate Dependency Graph

Verify the dependency graph in #139 is correct and complete.

1. Review each child ticket's body for explicit dependencies
2. Confirm no circular dependencies exist
3. Verify #137 (external) is marked complete
4. Document any corrections needed
5. Validate skills-first-workflow integration maintains composition principle

**Exit Criteria:**

- [ ] Each child ticket's dependencies match blockers in parent epic
- [ ] No cycles in dependency graph
- [ ] All external dependencies (like #137) are verified closed
- [ ] Dependency graph matches critical path in Task 4
- [ ] skills-first-workflow integration is reference-based, not rigid prerequisite

**Deliverable:** Updated dependency graph if corrections found (concrete evidence)

### Task 2: Assess Child Ticket Readiness

For each unblocked child ticket, assess readiness for implementation.

**Initial Assessment (currently unblocked):** #140

**Iterative Assessment:** As dependencies resolve, assess newly unblocked tickets
using the same criteria.

**Readiness Criteria:**

1. Has clear acceptance criteria with testable conditions
2. Has appropriate labels (priority, work-type, component)
3. Scope is well-defined with deliverables
4. No ambiguities requiring clarification
5. Dependencies correctly documented

**Deliverable:** Readiness assessment in issue comment for each ticket (analytical)

### Task 3: Identify Gaps in Epic Scope

Review acceptance criteria from #139 against child tickets.

**Gap Definition:** A gap exists when:

- An acceptance criterion from #139 has no corresponding child ticket, OR
- A child ticket's scope doesn't match any AC (potential scope creep), OR
- Multiple tickets claim the same AC without clear ownership

**Steps:**

1. Map each of 18 ACs to a child ticket with ownership
2. Identify any AC without coverage (gaps)
3. Identify any child ticket overlap or redundancy
4. Propose new tickets if gaps found
5. Identify grooming/prioritization state machine interactions

**Deliverable:** Gap analysis in issue comment (analytical)

### Task 4: Define Implementation Order

Based on dependencies and priorities, define the recommended sequence.

**Critical Path:** #140 → #141 → #142

**Priority Rationale:**

- **#140 first:** Router framework must exist before guards can reference it.
  Guards (#141) need routing decisions to know where to redirect.
- **#141 second:** Precondition guards depend on router infrastructure.
  Grooming phase (#142) requires guards to validate issue readiness.
- **#142 third:** Grooming phase completes core workflow enhancement.
  Automation scripts depend on grooming-defined standards.

**Parallel Work:** #143-#148 can run in parallel after #142

**Final:** #149 after all automation scripts (integration verification)

**Incremental Verification Strategy:**

Each ticket (#140-#148) must include self-verification acceptance criteria and
pass linting before closing. #149 becomes integration verification, not first-time
verification. This follows Clean Build Principle.

**Deliverable:** Implementation order documented in issue (analytical)

### Task 5: Review Playbook Requirements

Identify playbooks needed (from AC) and map ownership.

| Playbook                  | Owner Ticket | Description                      |
| ------------------------- | ------------ | -------------------------------- |
| Ticket lifecycle playbook | #142         | Mermaid diagram of issue states  |
| Skill selection playbook  | #140         | Decision tree for process skills |
| Project/Taskboard Sync    | #143         | Script usage and customization   |
| Label Validation          | #144         | Script usage and customization   |
| Duplicate Detection       | #145         | Script usage and customization   |
| Blocked/Blocking Sync     | #146         | Script usage and customization   |
| Standards Compliance      | #147         | Script usage and customization   |
| Backlog Health Report     | #148         | Script usage and customization   |

**Deliverable:** Playbook structure outline with ownership (analytical)

### Task 6: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues

**Deliverable:** Clean lint output (concrete evidence)

## Acceptance Criteria Mapping

| #   | Acceptance Criteria                       | Owner     | Testable Condition                                 | Verification |
| --- | ----------------------------------------- | --------- | -------------------------------------------------- | ------------ |
| 1   | Backlog grooming phase with 6 activities  | #142      | SKILL.md contains 6 numbered grooming activities   | #149         |
| 2   | Process-skill-router exists               | #140      | skills/process-skill-router/SKILL.md exists        | #140         |
| 3   | requirements-gathering precondition guard | #141      | requirements-gathering checks ticket existence     | #141         |
| 4   | skills-first-workflow references router   | #141      | skills-first-workflow.md contains router reference | #141         |
| 5   | Ticket lifecycle playbook                 | #142      | docs/playbooks/ticket-lifecycle.md with Mermaid    | #142         |
| 6   | Skill selection playbook                  | #140      | docs/playbooks/skill-selection.md with tree        | #140         |
| 7   | Automation script playbooks               | #143-#148 | One playbook per script in docs/playbooks/         | #149         |
| 8   | Template scripts in skill's templates/    | #143-#148 | Scripts in skills/issue-driven-delivery/templates/ | #149         |
| 9   | Customized scripts in repo /scripts       | #143-#148 | Scripts installed in /scripts folder               | #149         |
| 10  | CI/CD hook integration                    | #147      | pre-commit hook calls standards script             | #147         |
| 11  | README.md updated                         | #149      | README.md has script quick reference section       | #149         |
| 12  | Git branching standards documented        | #142      | Playbook references architecture-overview.md       | #142         |
| 13  | GitHub Project board syncs                | #143      | Script syncs issue state labels to board           | #143         |
| 14  | Dogfooded on development-skills           | #149      | Scripts run successfully on this repo              | #149         |
| 15  | Verification: docs accurate               | #149      | All playbooks match actual behavior                | #149         |
| 16  | Verification: scripts execute             | #149      | All scripts run without errors                     | #149         |
| 17  | Verification: hooks trigger               | #149      | Pre-commit hook triggers on commit                 | #149         |
| 18  | Linting passes                            | #149      | npm run lint returns 0 exit code                   | #149         |

## BDD Verification Checklist

### Task 0: Dependency Metadata Fix

- [ ] #141 body references #140 as blocker
- [ ] #142 body references #141 as blocker
- [ ] #143-#148 bodies reference #142 as blocker
- [ ] #149 body references #143-#148 as blockers
- [ ] No TBD placeholders remain in child ticket bodies

### Task 1: Dependency Validation

- [ ] No circular dependencies in child tickets
- [ ] #137 marked as complete/closed
- [ ] All blocked tickets reference their blockers correctly
- [ ] Dependency graph in #139 matches actual ticket relationships
- [ ] skills-first-workflow integration uses reference pattern (not rigid dependency)

### Task 2: Readiness Assessment

- [ ] #140 has clear acceptance criteria
- [ ] #140 has priority:p1 label
- [ ] #140 has work-type label
- [ ] #140 has no ambiguous requirements
- [ ] Assessment process documented for iterative use

### Task 3: Gap Analysis

- [ ] All 18 acceptance criteria reviewed and mapped
- [ ] No acceptance criteria without coverage
- [ ] No redundant child tickets
- [ ] Grooming/prioritization state interactions identified

### Task 4: Implementation Order

- [ ] Critical path documented: #140 → #141 → #142
- [ ] Priority rationale documented for each critical path ticket
- [ ] Parallel tracks identified for automation scripts
- [ ] Final verification (#149) scheduled last
- [ ] Incremental verification strategy defined

### Task 5: Playbook Requirements

- [ ] Ticket lifecycle playbook structure defined
- [ ] Skill selection playbook structure defined
- [ ] Automation playbook structure defined
- [ ] Each playbook mapped to owner ticket

### Task 6: Validation

- [ ] `npm run lint` passes with no errors

### Epic Orchestration Verification

- [ ] All Phase 1 tickets complete before Phase 2 starts
- [ ] All Phase 2 tickets complete before Phase 3 starts
- [ ] Phase 3 respects WIP limit (max 3 concurrent)
- [ ] Phase 4 triggered only after all Phase 3 complete

## WIP Limits

| Phase   | Max Concurrent | Rationale                                    |
| ------- | -------------- | -------------------------------------------- |
| Phase 1 | 1              | Sequential foundation work                   |
| Phase 2 | 1              | Single core feature                          |
| Phase 3 | 3              | Parallel automation, avoid context switching |
| Phase 4 | 1              | Sequential verification                      |

## Coordination Ceremonies

**Epic Status Review:** After each child ticket closes

- Verify DoD met for closed ticket
- Update epic progress in #139 comment
- Identify any new blockers or risks
- Trigger unblocking for dependent tickets

**Blocked Ticket Escalation:**

- If ticket blocked >2 days, escalate to Tech Lead
- Document blocker reason in issue comment
- Consider parallel work on unblocked tickets

**Plan Revision Triggers:**

- Gap found in Task 3 requiring new ticket
- Architectural concern discovered during implementation
- State machine interaction conflict identified

## Review Personas

| Phase          | Reviewers        | Focus                           |
| -------------- | ---------------- | ------------------------------- |
| Refinement     | Tech Lead        | Epic structure and dependencies |
| Refinement     | Scrum Master     | Process compliance and workflow |
| Implementation | Senior Developer | Code quality per ticket         |
| Verification   | QA Engineer      | Integration and acceptance      |
| Approval       | Tech Lead        | Strategic alignment             |

## Evidence Requirements

**Task 0 (Dependency Metadata):** Concrete verification

- Commit SHAs for issue body updates
- Link to each updated issue showing blocker references

**Task 1 (Dependency Validation):** Concrete verification

- Issue comment with dependency validation results (markdown table)
- Link to #137 showing closed state

**Task 2 (Readiness Assessment):** Analytical verification

- Issue comment with readiness checklist for #140
- Statement: "This is analytical verification (process-only)"

**Task 3 (Gap Analysis):** Analytical verification

- Issue comment with AC coverage matrix (all 18 rows)
- Statement: "This is analytical verification (process-only)"

**Task 4 (Implementation Order):** Analytical verification

- Issue comment with recommended sequence and rationale
- Statement: "This is analytical verification (process-only)"

**Task 5 (Playbook Requirements):** Analytical verification

- Issue comment with playbook outline table
- Statement: "This is analytical verification (process-only)"

**Task 6 (Validation):** Concrete verification

- Lint output showing clean build (0 errors)
- Commit SHA if any fixes applied

## Review History

### Rev 1 → Rev 2 (Plan Refinement)

**Tech Lead Feedback (2026-01-08):**

- **C1:** Issue bodies have TBD placeholders → Added Task 0 to fix metadata
- **C2:** skills-first-workflow integration needs validation → Added to Task 1 exit criteria
- **C3:** All verification deferred to #149 → Added incremental verification strategy
- **I1:** Grooming/prioritization interaction undefined → Added to Task 3 gap analysis
- **I3:** Automation scripts lack architecture → Noted for Task 2.5 in child tickets

**Scrum Master Feedback (2026-01-08):**

- **C1:** Missing Definition of Ready/Done → Added DoR/DoD section
- **C2:** ACs lack testable conditions → Updated AC mapping with testable conditions
- **C3:** Only #140 assessed → Clarified iterative assessment process in Task 2
- **I1:** Implementation order lacks rationale → Added Priority Rationale subsection
- **I2:** No WIP limits → Added WIP Limits section
- **I4:** BDD doesn't cover orchestration → Added Epic Orchestration Verification
- **I6:** Missing ceremony documentation → Added Coordination Ceremonies section

---

## Epic Orchestration Strategy

### Phase 1: Foundation (Sequential)

1. **#140 - Process Skill Router** - Create routing framework
2. **#141 - Skill Precondition Guards** - Add guards to existing skills

### Phase 2: Core Feature (Sequential)

1. **#142 - Backlog Grooming Phase** - Add grooming to issue-driven-delivery

### Phase 3: Automation (Parallel, WIP=3)

These can be worked in parallel after #142:

1. **#143 - Project/Taskboard Sync**
2. **#144 - Label Validation**
3. **#145 - Duplicate Detection**
4. **#146 - Blocked/Blocking Sync**
5. **#147 - Standards Compliance**
6. **#148 - Backlog Health Report**

### Phase 4: Verification (Sequential)

1. **#149 - Brownfield Verification** - Integration verification

### Estimated Workflow

```text
Week 1: #140 → #141 (sequential, foundation)
Week 2: #142 → Begin parallel scripts
Week 3: #143-#148 (parallel, max 3 concurrent)
Week 4: #149 integration verification
```

**Note:** Timing estimates are preliminary and subject to revision. Use as rough
sequencing guide only. Includes contingency for approval feedback and TDD cycles.
