# Progressive Document Loading Guidance Implementation Plan

**Issue:** #100
**Date:** 2026-01-07
**Status:** Draft

## Overview

Add agent guidance for progressive document loading (frontmatter first, full content when
relevant) to AGENTS.md, with BDD tests to verify compliance. This consolidates the loading
patterns established in #97 (roles), #98 (ADRs), and #99 (playbooks).

## Scope

### In Scope

- Add "Progressive Document Loading" section to AGENTS.md
- Define loading hierarchy and summary fields per document type
- Specify when full document loading is appropriate
- Create BDD test file validating progressive loading behavior

### Out of Scope

- Automated enforcement tooling
- Changes to existing document READMEs (already done in #97-99)
- Runtime validation of loading behavior

## Implementation Tasks

### Task 1: Update AGENTS.md with Progressive Document Loading Section

Add section after "Documentation Standards for Agents" containing:

1. **Progressive Loading Principle** - Load frontmatter first, full content when relevant
2. **Summary Fields by Document Type** table:
   - Roles: `name`, `description`, `model`
   - ADRs: `name`, `description`, `decision`, `status`
   - Playbooks: `name`, `description`, `summary`, `triggers`
3. **When Frontmatter Suffices** - Selection, checking applicability, building lists
4. **When Full Document Needed** - Execution, understanding rationale, step-by-step
5. **Loading Algorithm** - Step-by-step process for agents

**Deliverable:** Updated `AGENTS.md`

### Task 2: Create BDD Test File

Create `docs/references/progressive-loading.test.md` with:

1. **RED Scenarios** - Agent loads full document unnecessarily
2. **GREEN Scenarios**:
   - Agent loads frontmatter only for selection
   - Agent loads full document when executing
   - Agent applies progressive disclosure workflow
3. **Evidence Requirements** - How to verify compliance

**Deliverable:** `docs/references/progressive-loading.test.md`

### Task 3: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues
3. Verify markdown structure intact

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                    | Task   |
| ------------------------------------------------------ | ------ |
| AGENTS.md updated with "Progressive Document Loading"  | Task 1 |
| Rule clearly states: frontmatter first                 | Task 1 |
| Summary fields defined per document type               | Task 1 |
| BDD test file created with RED/GREEN scenarios         | Task 2 |
| Tests validate agents don't load full when unnecessary | Task 2 |
| Tests validate agents DO load full when needed         | Task 2 |
| All linting passes                                     | Task 3 |

## BDD Verification Checklist

### Task 1: AGENTS.md Update

- [ ] Progressive Document Loading section exists
- [ ] Section placed after Documentation Standards for Agents
- [ ] Loading principle clearly stated
- [ ] Summary fields table includes all three document types
- [ ] "When Frontmatter Suffices" scenarios documented
- [ ] "When Full Document Needed" scenarios documented
- [ ] Loading algorithm/steps provided

### Task 2: BDD Test File

- [ ] File exists at `docs/references/progressive-loading.test.md`
- [ ] Contains RED scenario (unnecessary full load)
- [ ] Contains GREEN scenarios (frontmatter selection, full when executing)
- [ ] Evidence requirements specified
- [ ] Scenarios are testable and specific

### Task 3: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors
- [ ] Markdown structure valid

## Review Personas

| Phase          | Reviewers                                      | Focus                          |
| -------------- | ---------------------------------------------- | ------------------------------ |
| Refinement     | Agent Skill Engineer, Documentation Specialist | Agent usability, clarity       |
| Implementation | Agent Skill Engineer                           | BDD test quality, completeness |
| Approval       | Tech Lead                                      | Standards compliance           |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread
