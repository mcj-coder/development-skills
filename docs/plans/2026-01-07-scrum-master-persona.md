# Scrum Master Persona Implementation Plan

**Issue:** #109
**Date:** 2026-01-07
**Status:** Draft

## Overview

Add Scrum Master persona for process compliance and documentation completeness reviews.

## Scope

### In Scope

- Create role document at `docs/roles/scrum-master.md`
- Define focus areas: process compliance, ticket quality, backlog grooming, process docs
- Clarify scope: reviews process docs for completeness; does not implement people aspects
- Update `docs/roles/README.md` index

### Out of Scope

- Implementing people management aspects (team dynamics, motivation)
- Sprint ceremonies implementation
- Team capacity planning

## Implementation Tasks

### Task 1: Create Role Document

Create `docs/roles/scrum-master.md` following the established role format:

**Frontmatter:**

```yaml
---
name: scrum-master
description: |
  Use for process compliance reviews, ticket quality validation, and
  ensuring workflows and ceremonies are properly documented. Reviews
  skills and process documentation for completeness against Scrum practices.
model: balanced # Process review → Sonnet 4.5, GPT-5.1
---
```

**Body sections (matching existing role format):**

1. **Title and Role Line**
   - `# Scrum Master`
   - `**Role:** Process compliance and documentation completeness`

2. **Expertise**
   - Process compliance and workflow validation
   - Ticket quality (acceptance criteria, sizing, dependencies)
   - Backlog grooming and prioritization
   - Process documentation review
   - Ceremony documentation and structure

3. **Perspective Focus**
   - Is the process clearly defined?
   - Are tickets complete with AC, sizing, and dependencies?
   - Is the backlog properly maintained and prioritized?
   - Are ceremonies documented with clear structure?
   - Are WIP limits defined and respected?

4. **When to Use**
   - Process documentation review
   - Skill review for process completeness
   - Ticket quality validation
   - Backlog grooming review
   - Workflow definition review

5. **Example Review Questions**
   - "Are acceptance criteria clear and testable?"
   - "Are dependencies identified and documented?"
   - "Is the Definition of Ready/Done defined?"
   - "Are WIP limits established for this workflow?"
   - "Is the backlog prioritized with clear rationale?"

6. **Blocking Issues (Require Escalation)**
   - Tickets without acceptance criteria
   - Undefined or unclear workflow processes
   - Missing Definition of Ready/Done
   - Backlog items without priority or rationale
   - Processes that skip required ceremonies

7. **Scope Clarification**
   - Section explaining that this role reviews documentation for completeness
   - Agents do not implement people aspects (motivation, team dynamics)
   - When reviewing, consider full Scrum Master scope for documentation completeness

**Deliverable:** `docs/roles/scrum-master.md`

### Task 2: Update Role Index

Update `docs/roles/README.md` to include Scrum Master:

- Add new category section (if needed) or add to existing category
- Add to Canonical Names list

**Deliverable:** Updated README.md

### Task 3: Run Linting Validation

1. Run `npm run lint` to validate YAML and markdown
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                | Task   |
| -------------------------------------------------- | ------ |
| Role file created with valid frontmatter           | Task 1 |
| Process compliance review focus documented         | Task 1 |
| Ticket quality criteria included                   | Task 1 |
| Scope limitation (documentation, not people) clear | Task 1 |
| README index updated                               | Task 2 |
| Linting passes                                     | Task 3 |

## BDD Verification Checklist

### Task 1: Role Creation

- [ ] File exists at `docs/roles/scrum-master.md`
- [ ] Frontmatter contains all required fields (name, description, model)
- [ ] `name` is kebab-case: `scrum-master`
- [ ] `description` explains when to use role with trigger conditions
- [ ] `model` is `balanced`
- [ ] Title is `# Scrum Master`
- [ ] Role line present: `**Role:** ...`
- [ ] Expertise section lists 4-6 areas
- [ ] Perspective Focus section lists 4-6 questions
- [ ] When to Use section lists applicable scenarios
- [ ] Example Review Questions section provides concrete examples
- [ ] Blocking Issues section defines escalation triggers
- [ ] Scope clarification section explains documentation-only focus

### Task 2: Index Update

- [ ] `docs/roles/README.md` includes Scrum Master in appropriate category
- [ ] Entry format: `- **[Scrum Master](scrum-master.md)** - Description`
- [ ] Canonical Names list includes `Scrum Master` with aliases

### Task 3: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors in frontmatter

## Review Personas

| Phase          | Reviewers                                      | Focus                                  |
| -------------- | ---------------------------------------------- | -------------------------------------- |
| Refinement     | Documentation Specialist, Agent Skill Engineer | Role structure, description clarity    |
| Implementation | Documentation Specialist, Agent Skill Engineer | Content quality, scope appropriateness |
| Approval       | Tech Lead                                      | Strategic alignment, completeness      |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread
