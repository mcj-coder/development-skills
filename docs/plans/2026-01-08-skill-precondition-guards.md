# Plan: Skill Precondition Guards

**Issue**: #141
**Status**: Approved (Rev 2)
**Created**: 2026-01-08

## Goal

Add precondition guards to process skills that validate context and redirect to the correct
skill if the wrong skill was loaded.

## Background

The process-skill-router (#140) provides routing logic to help agents select the correct process
skill. However, agents may still load the wrong skill directly. Precondition guards add a
second layer of protection by having each skill validate its own preconditions at load time.

## Approach

### Pattern: Precondition Guard

Each process skill should include a "Precondition Check" section near the top that:

1. Lists the preconditions required for this skill
2. Provides verification steps
3. Redirects to the correct skill if preconditions fail

```markdown
## Precondition Check

Before proceeding, verify these conditions are met:

- [ ] Condition 1
- [ ] Condition 2

**If any condition fails:**
→ Use `process-skill-router` to find the correct skill
→ Or redirect directly to [alternative-skill]
```

### Implementation Tasks

#### Task 1: Add guard to requirements-gathering (RED first)

**Test file**: `skills/requirements-gathering/requirements-gathering-guards.test.md`

RED scenarios:

- Agent loads requirements-gathering when ticket already exists
- Agent proceeds without checking preconditions

GREEN scenarios:

- Agent checks if ticket exists before proceeding
- Agent redirects to brainstorming if ticket exists with unclear requirements
- Agent redirects to writing-plans if ticket exists with clear requirements

**SKILL.md changes**:

- Add "Precondition Check" section after "When to Use"
- Add verification steps: "Does a ticket exist for this work?"
- Add redirect guidance to process-skill-router

#### Task 2: Update skills-first-workflow

**Changes**:

- Add `process-skill-router` to prerequisites
- Update step 4 to reference process-skill-router for skill selection
- Add note about precondition guards in process skills

#### Task 3: Document guard pattern in process-skill-router

**Changes to `process-skill-router/SKILL.md`**:

- Add "Precondition Guard Pattern" section in extensibility documentation
- Provide template for other skills to follow

#### Task 4: Update BDD test file for process-skill-router

**Add scenarios to `process-skill-router/process-skill-router.test.md`**:

- GREEN: Guard in requirements-gathering redirects correctly
- PRESSURE: Guard handles edge case of ticket existing but closed

## Acceptance Criteria Mapping

| Requirement                                  | Task   | Deliverable                           |
| -------------------------------------------- | ------ | ------------------------------------- |
| requirements-gathering includes precondition | Task 1 | SKILL.md section                      |
| Guard redirects to correct skill             | Task 1 | Redirect guidance in SKILL.md         |
| skills-first-workflow references router      | Task 2 | Updated prerequisites                 |
| Guard pattern documented                     | Task 3 | Extensibility section update          |
| BDD tests validate guard behavior            | Task 1 | requirements-gathering-guards.test.md |
| All linting passes                           | All    | npm run lint verification             |

## TDD Sequence

Following the commit sequencing requirement from CONTRIBUTING.md:

1. **Commit 1**: Create `requirements-gathering-guards.test.md` with RED/GREEN/PRESSURE scenarios
2. **Commit 2**: Update `requirements-gathering/SKILL.md` with precondition guard
3. **Commit 3**: Update `skills-first-workflow/SKILL.md` with router reference
4. **Commit 4**: Update `process-skill-router/SKILL.md` with guard pattern documentation

## Risks and Mitigations

| Risk                                 | Mitigation                                |
| ------------------------------------ | ----------------------------------------- |
| Guard adds friction to skill loading | Keep guard lightweight (quick checklist)  |
| Agents may skip guard section        | Make it prominent, add to "Core Workflow" |
| Circular reference between skills    | Use process-skill-router as central hub   |

## Review Checklist

- [x] Senior Developer: Code quality and pattern consistency - APPROVE
- [x] Agent Skill Engineer: Skill design and BDD coverage - APPROVE WITH SUGGESTIONS
- [x] Tech Lead: Strategic alignment with skill philosophy - APPROVE

### Reviewer Feedback Addressed

From Agent Skill Engineer:

- Add PRESSURE scenario for draft/incomplete ticket state
- Clarify criteria for "unclear requirements" in redirect logic

---

**Refs**: #141, #140, #139
