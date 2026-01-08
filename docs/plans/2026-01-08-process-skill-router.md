# Process Skill Router Implementation Plan

**Issue:** #140
**Date:** 2026-01-08
**Status:** Draft

## Approval History

| Phase | Reviewer | Decision | Date | Plan Commit | Comment Link |
| ----- | -------- | -------- | ---- | ----------- | ------------ |
|       |          |          |      |             |              |

## Overview

Create a lightweight routing skill that guides agents to the correct process skill based on
preconditions. This addresses the skill selection loophole where agents may load `brainstorming`
when `requirements-gathering` should apply.

## Scope

### In Scope

- Create `skills/process-skill-router/SKILL.md` with routing rules
- Define decision tree for process skill selection
- Create `docs/playbooks/skill-selection.md` with Mermaid diagram
- Create BDD test file validating routing logic

### Out of Scope

- Modifying superpowers skills (external dependency)
- Implementing precondition guards in other skills (covered by #141)
- Updating skills-first-workflow to reference router (covered by #141)

## Implementation Tasks

### Task 1: Create SKILL.md with Routing Rules

Create the skill definition following existing skill patterns.

**Routing Rules:**

| Precondition                        | Recommended Skill       |
| ----------------------------------- | ----------------------- |
| No ticket exists                    | requirements-gathering  |
| Ticket exists, requirements unclear | brainstorming           |
| Ticket exists, ready to plan        | writing-plans           |
| Code changes needed                 | test-driven-development |
| Bug/unexpected behavior             | systematic-debugging    |

**Deliverable:** `skills/process-skill-router/SKILL.md`

### Task 2: Create BDD Test File

Create BDD test file with RED and GREEN scenarios.

**Deliverable:** `skills/process-skill-router/process-skill-router.test.md`

### Task 3: Create Skill Selection Playbook

Create playbook with Mermaid decision tree diagram.

**Deliverable:** `docs/playbooks/skill-selection.md`

### Task 4: Update Playbooks README Index

Add skill-selection.md to the playbook index.

**Deliverable:** Updated `docs/playbooks/README.md`

### Task 5: Run Linting Validation

Verify all files pass linting.

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                            | Task   |
| ---------------------------------------------- | ------ |
| SKILL.md created following agentskills.io spec | Task 1 |
| Routing rules cover all current process skills | Task 1 |
| Extensible pattern documented                  | Task 1 |
| skill-selection.md with Mermaid decision tree  | Task 3 |
| BDD test file validates routing logic          | Task 2 |
| All linting passes                             | Task 5 |

## BDD Verification Checklist

### Task 1: SKILL.md

- [ ] File exists at `skills/process-skill-router/SKILL.md`
- [ ] Has valid frontmatter (name, description)
- [ ] Contains routing rules table
- [ ] Documents extensibility pattern
- [ ] Follows existing skill structure

### Task 2: BDD Tests

- [ ] File exists at `skills/process-skill-router/process-skill-router.test.md`
- [ ] Contains RED scenarios (current failures)
- [ ] Contains GREEN scenarios (desired behavior)
- [ ] Tests all routing rules

### Task 3: Playbook

- [ ] File exists at `docs/playbooks/skill-selection.md`
- [ ] Has valid frontmatter (name, description, summary, triggers)
- [ ] Contains Mermaid decision tree
- [ ] Documents routing logic

### Task 4: README Update

- [ ] `docs/playbooks/README.md` includes skill-selection.md in index

### Task 5: Linting

- [ ] `npm run lint` passes with 0 errors

## Review Personas

| Phase          | Reviewers            | Focus               |
| -------------- | -------------------- | ------------------- |
| Implementation | Senior Developer     | Code quality        |
| Implementation | Agent Skill Engineer | Skill design        |
| Approval       | Tech Lead            | Strategic alignment |

## Evidence Requirements

**Task 1:** Concrete verification - file link, commit SHA
**Task 2:** Concrete verification - file link, commit SHA
**Task 3:** Concrete verification - file link, commit SHA
**Task 4:** Concrete verification - file link, commit SHA
**Task 5:** Concrete verification - lint output
