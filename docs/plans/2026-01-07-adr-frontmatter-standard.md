# ADR Frontmatter Standard Implementation Plan

**Issue:** #98
**Date:** 2026-01-07
**Status:** Draft (Rev 2 - addressing review feedback)

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
- Multi-decision ADR handling (future enhancement)

## Implementation Tasks

### Task 1: Create ADR README with Frontmatter Schema

Create `docs/adr/README.md` documenting:

1. **Frontmatter Standard section** with required fields table
2. **Field specifications:**
   - `name`: kebab-case identifier matching filename without number prefix
     (e.g., `use-adrs` not `0000-use-adrs`)
   - `description`: When to load/apply this ADR. Must include trigger conditions
     agents can match. 1-3 sentences. Format: "Apply when {condition}."
   - `decision`: One-line actionable outcome using imperative verb. Must answer
     "What do we do?" Format: `{verb} {action} {context}`. Agent applies directly.
   - `status`: One of `accepted`, `superseded`, `deprecated`
3. **Status value definitions with agent behavior:**
   - `accepted`: Decision is current. Agents SHOULD apply when description matches.
   - `superseded`: Replaced by another ADR. Agents MUST NOT apply; load
     superseding ADR instead. Body must reference superseding ADR.
   - `deprecated`: No longer applicable. Agents MUST NOT apply.
4. **Example frontmatter blocks** for each status value
5. **Agent workflow guidance:**
   - When to read frontmatter vs full ADR
   - How to handle superseded/deprecated status
   - Conflict resolution: newer ADR takes precedence when descriptions overlap

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
- [ ] Contains Frontmatter Standard section with required fields table
- [ ] Documents `name` field with kebab-case format requirement
- [ ] Documents `description` field with trigger condition format guidance
- [ ] Documents `decision` field with imperative verb format requirement
- [ ] Documents `status` field with valid values
- [ ] Includes example frontmatter blocks for ALL status values (accepted, superseded, deprecated)
- [ ] Defines status values with explicit agent behavior (SHOULD/MUST/MUST NOT)
- [ ] Provides agent workflow guidance (when to read full ADR, conflict resolution)

### Task 2: ADR Retrofit

- [ ] `0000-use-adrs.md` has YAML frontmatter at top
- [ ] `name` field is kebab-case without number prefix (`use-adrs`)
- [ ] `description` uses "Apply when..." format with trigger conditions
- [ ] `decision` is imperative verb + specific action (agent can apply directly)
- [ ] `status` is valid value (`accepted`)
- [ ] Inline Date, Deciders, Tags preserved (MADR compatibility)
- [ ] Inline `Status:` removed (now in frontmatter)
- [ ] Body content otherwise unchanged

### Task 3: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors
- [ ] Markdown structure valid
- [ ] Agent can apply decision from frontmatter without reading body

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

## Review Feedback Addressed (Rev 2)

### Documentation Specialist Feedback

| Issue                                     | Resolution                                                  |
| ----------------------------------------- | ----------------------------------------------------------- |
| C1: Missing field format specs for `name` | Added kebab-case requirement, clarified no number prefix    |
| C2: `decision` field guidance too vague   | Added imperative verb format, "What do we do?" test         |
| C3: Status values lacked detail           | Added agent behavior (SHOULD/MUST/MUST NOT) for each status |
| I1: Status inconsistency                  | Clarified: remove inline Status, keep Date/Deciders/Tags    |
| I4: Single example for all statuses       | Added requirement for examples of ALL status values         |

### Agent Skill Engineer Feedback

| Issue                               | Resolution                                                            |
| ----------------------------------- | --------------------------------------------------------------------- |
| C1: Ambiguous status semantics      | Added explicit agent behavior: SHOULD apply, MUST NOT apply           |
| C2: Multi-decision ADRs             | Added to Out of Scope as future enhancement                           |
| C3: Missing agent workflow guidance | Added agent workflow section (when to read full, conflict resolution) |
| I1: Description lacks structure     | Added "Apply when {condition}" format guidance                        |
| I2: No decision sufficiency test    | Added BDD check: "Agent can apply decision without reading body"      |
