# Scrum Master Persona Implementation Plan

**Issue:** #109
**Date:** 2026-01-07
**Status:** Draft (Rev 2 - addressing review feedback)

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
  Use when reviewing issue templates, workflow documentation, backlog
  structure, or process docs in docs/process/. Validates ticket completeness
  (acceptance criteria, sizing, dependencies), backlog prioritization, and
  Definition of Ready/Done documentation.
model: balanced # General development → Sonnet 4.5, GPT-5.1
---
```

**Body sections (matching existing role format):**

1. **Title and Role Line**
   - `# Scrum Master`
   - `**Role:** Process compliance and documentation completeness`

2. **Expertise**
   - Process documentation completeness (Definition of Ready, Definition of Done, workflow states)
   - Issue template validation (acceptance criteria format, dependency links, size labels)
   - Backlog structure (priority ordering, rationale documentation in issue bodies)
   - Workflow documentation (CONTRIBUTING.md, docs/process/ ceremony descriptions)
   - WIP limit documentation (workflow files, team agreements)

3. **Perspective Focus**
   - Does process documentation include required sections (Purpose, Inputs, Outputs, Steps)?
   - Do tickets include acceptance criteria with testable conditions?
   - Is the backlog ordered with priority rationale in issue descriptions?
   - Are ceremonies documented with participants, inputs, outputs, and cadence?
   - Are WIP limits defined numerically in workflow documentation?

4. **When to Use**
   - Reviewing docs/process/\*.md for completeness
   - Validating .github/ISSUE_TEMPLATE/\*.md structure
   - Checking skill files for workflow/ceremony documentation
   - Reviewing CONTRIBUTING.md for Definition of Ready/Done
   - Assessing backlog prioritization in GitHub Projects or issue trackers

5. **Example Review Questions**
   - "Are acceptance criteria clear and testable?"
   - "Are dependencies identified and documented?"
   - "Is the Definition of Ready/Done defined?"
   - "Are WIP limits established for this workflow?"
   - "Is the backlog prioritized with clear rationale?"

6. **Blocking Issues (Require Escalation)**
   - Issue templates missing `## Acceptance Criteria` section
   - Issues with `ready` label but missing size labels (S/M/L/XL)
   - CONTRIBUTING.md missing Definition of Ready or Definition of Done
   - Workflow documentation without ceremony descriptions (participants, cadence)
   - Issue dependencies not linked with GitHub issue references (#123)

7. **Scope Clarification**
   - Section explaining that this role reviews documentation for completeness
   - Agents do not implement people aspects (motivation, team dynamics)
   - When reviewing, consider full Scrum Master scope for documentation completeness

**Deliverable:** `docs/roles/scrum-master.md`

### Task 2: Update Role Index

Update `docs/roles/README.md` to include Scrum Master:

**Category Placement:** Add to "Product and Design" category (alongside Product Owner)

**Entry Format:**

```markdown
- **[Scrum Master](scrum-master.md)** - Process compliance and documentation completeness reviews
```

**Canonical Name Entry:**

```markdown
- `Scrum Master` (not: "SM", "Scrum", "Process Manager", "Agile Coach")
```

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

- [ ] `docs/roles/README.md` includes Scrum Master in "Product and Design" category
- [ ] Entry format: `- **[Scrum Master](scrum-master.md)** - Description`
- [ ] Canonical Names list includes `Scrum Master` with rejected aliases
- [ ] Role placed alongside Product Owner in category

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

## Review Feedback Addressed (Rev 2)

### Documentation Specialist Feedback

| Issue                               | Resolution                                       |
| ----------------------------------- | ------------------------------------------------ |
| I-1: Description lacks triggers     | Added file paths and specific validation targets |
| I-2: Role index category not spec   | Specified "Product and Design" category          |
| I-3: Canonical name/aliases missing | Added canonical entry with rejected aliases      |
| M-1: Model tier rationale           | Updated comment to match README standard         |

### Agent Skill Engineer Feedback

| Issue                                 | Resolution                                              |
| ------------------------------------- | ------------------------------------------------------- |
| I-1: Ambiguous trigger conditions     | Made file-path based (docs/process/, ISSUE_TEMPLATE/)   |
| I-2: Non-actionable expertise         | Added specific document structures and formats          |
| I-3: Unmeasurable blocking issues     | Made structural and objective (sections, labels, links) |
| M-4: Perspective focus abstract       | Added concrete checks with required sections            |
| M-5: Missing file path in When to Use | Added explicit file paths for each scenario             |
