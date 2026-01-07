# ADR Frontmatter Standard Implementation Plan

**Issue:** #98
**Date:** 2026-01-07
**Status:** Draft

## Overview

Add YAML frontmatter standard to Architecture Decision Records (ADRs) enabling agents to
apply decisions without reading full ADR content. This follows the pattern established
in #97 for role documents.

## Scope

### In Scope

- Define YAML frontmatter schema for ADRs
- Document frontmatter specification in ADR README
- Retrofit existing ADR (`0000-use-adrs.md`) with frontmatter
- Ensure MADR format compatibility in body

### Out of Scope

- Creating new ADRs
- Changes to ADR body content beyond metadata consolidation
- Automated frontmatter validation tooling

## Implementation Tasks

### Task 1: Create ADR README with Frontmatter Schema

Create `docs/adr/README.md` documenting:

1. Frontmatter Standard section with required fields
2. Field descriptions:
   - `name`: kebab-case identifier matching filename
   - `description`: when to load/apply this ADR (agent trigger conditions)
   - `decision`: one-line actionable outcome (sufficient to apply without full read)
   - `status`: `accepted`, `superseded`, or `deprecated`
3. Example frontmatter block
4. Status value definitions
5. Usage guidance for agents

**Deliverable:** `docs/adr/README.md`

### Task 2: Retrofit Existing ADR

Update `docs/adr/0000-use-adrs.md`:

1. Add YAML frontmatter at top:

   ```yaml
   ---
   name: use-adrs
   description: |
     Apply when deciding how to document architectural decisions
     or questioning why ADRs are used in this repository.
   decision: Use MADR format ADRs in docs/adr/ for significant architectural and process decisions.
   status: accepted
   ---
   ```

2. Keep inline metadata (Date, Deciders, Tags) for MADR compatibility
3. Remove redundant `Status:` from inline metadata (now in frontmatter)
4. Preserve all existing content

**Deliverable:** Updated `docs/adr/0000-use-adrs.md`

### Task 3: Run Linting Validation

1. Run `npm run lint` to validate YAML frontmatter
2. Fix any formatting issues
3. Verify markdown structure intact

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                 | Task      |
| --------------------------------------------------- | --------- |
| Frontmatter schema documented for ADRs              | Task 1    |
| Existing ADR has valid YAML frontmatter             | Task 2, 3 |
| `decision` field contains actionable one-liner      | Task 2    |
| `description` field includes when-to-apply guidance | Task 2    |
| Frontmatter is valid YAML (passes linting)          | Task 3    |
| Existing ADR content preserved                      | Task 2    |
| MADR format compatibility maintained                | Task 2    |

## BDD Verification Checklist

### Task 1: ADR README Creation

- [ ] README.md exists at `docs/adr/README.md`
- [ ] Contains Frontmatter Standard section
- [ ] Documents all required fields (name, description, decision, status)
- [ ] Includes example frontmatter block
- [ ] Defines status values (accepted, superseded, deprecated)
- [ ] Provides agent usage guidance

### Task 2: ADR Retrofit

- [ ] `0000-use-adrs.md` has YAML frontmatter at top
- [ ] `name` field matches filename (use-adrs)
- [ ] `description` includes agent trigger conditions
- [ ] `decision` is one-line actionable outcome
- [ ] `status` is valid value (accepted)
- [ ] Inline Date, Deciders, Tags preserved (MADR compatibility)
- [ ] Body content unchanged (except Status removal)

### Task 3: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors
- [ ] Markdown structure valid

## Review Personas

| Phase          | Reviewers                                      | Focus                                 |
| -------------- | ---------------------------------------------- | ------------------------------------- |
| Refinement     | Documentation Specialist, Agent Skill Engineer | Schema clarity, agent usability       |
| Implementation | Documentation Specialist, Agent Skill Engineer | Content quality, frontmatter validity |
| Approval       | Tech Lead                                      | Standards compliance, completeness    |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread
