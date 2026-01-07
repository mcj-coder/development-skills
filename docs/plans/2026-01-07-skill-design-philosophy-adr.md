# Skill Design Philosophy ADR Implementation Plan

**Issue:** #118
**Date:** 2026-01-07
**Status:** Draft

## Overview

Create an ADR documenting the design philosophy for skills in this repository, establishing
how skills bootstrap opinionated best practices while enabling target repos to own their
processes.

## Scope

### In Scope

- Create ADR at `docs/adr/0001-skill-design-philosophy.md`
- Define bootstrap vs ongoing ownership pattern
- Establish agent/platform agnostic principle
- Document "capture in target repo" pattern
- Define re-application rules

### Out of Scope

- Updating existing skills to comply (future work)
- Automation tooling for pattern detection
- Platform-specific implementation guidance

## Implementation Tasks

### Task 1: Create ADR Document

Create `docs/adr/0001-skill-design-philosophy.md` with MADR format:

**Frontmatter:**

```yaml
---
name: skill-design-philosophy
description: |
  Apply when designing new skills, reviewing skill implementations,
  or questioning how skills should interact with target repositories.
decision: Design skills to bootstrap opinionated defaults; target repos capture decisions and own ongoing process.
status: accepted
---
```

**Body sections:**

1. **Context and Problem Statement**
   - Skills help bootstrap best practices (TDD, issue-driven, etc.)
   - Need clarity on skill vs target repo responsibility boundary
   - Question: Once a process is established, who owns it?

2. **Decision Drivers**
   - Skills should be agent and platform agnostic
   - Target repos should be self-documenting
   - Agents shouldn't constantly re-apply skills where documented decisions exist
   - Skills should be composable and non-overlapping

3. **Considered Options**
   - Skills always apply (re-evaluate every time)
   - Skills bootstrap only (never re-apply)
   - Hybrid: bootstrap + defer to documented decisions

4. **Decision Outcome: Hybrid Bootstrap Pattern**
   - Skills define process with opinionated defaults
   - Target repo captures decisions (ADR, playbook, AGENTS.md)
   - Documented decisions become "the way"
   - Agents defer to documented decisions unless explicitly prompted

5. **Patterns and Guidelines**
   - **Bootstrap Pattern**: Skill helps define initial process
   - **Capture Pattern**: Decisions recorded in target repo
   - **Deference Pattern**: Agents check for existing decisions first
   - **Re-application Rule**: Only re-apply when explicitly requested

6. **Examples**
   - TDD skill: establishes practice, target repo records in coding-standards.md
   - Issue-driven: establishes workflow, target repo captures in AGENTS.md
   - Platform choice: skill supports multiple, target repo records specific choice

7. **Consequences**
   - Good: Target repos become self-documenting
   - Good: Agents don't constantly re-prompt for known decisions
   - Good: Skills remain reusable across projects
   - Neutral: Requires discipline to capture decisions
   - Bad: Initial setup requires more documentation

**Deliverable:** `docs/adr/0001-skill-design-philosophy.md`

### Task 2: Update ADR Index

Update `docs/adr/README.md` ADR Index section to include new ADR.

**Deliverable:** Updated index in README.md

### Task 3: Run Linting Validation

1. Run `npm run lint` to validate YAML and markdown
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                               | Task   |
| ----------------------------------------------------------------- | ------ |
| ADR created at `docs/adr/0001-skill-design-philosophy.md`         | Task 1 |
| Bootstrap pattern documented: skills define process with defaults | Task 1 |
| Agent/platform agnostic principle stated                          | Task 1 |
| Target repo capture pattern defined (decisions become "the way")  | Task 1 |
| Re-application rules: agents defer to documented decisions        | Task 1 |
| Examples provided for each pattern                                | Task 1 |
| Linting passes                                                    | Task 3 |

## BDD Verification Checklist

### Task 1: ADR Creation

- [ ] File exists at `docs/adr/0001-skill-design-philosophy.md`
- [ ] Frontmatter contains all required fields (name, description, decision, status)
- [ ] `name` is kebab-case: `skill-design-philosophy`
- [ ] `description` explains when to apply ADR
- [ ] `decision` is one-line actionable outcome
- [ ] `status` is `accepted`
- [ ] Body follows MADR format (Context, Drivers, Options, Outcome, Consequences)
- [ ] Bootstrap pattern documented with explanation
- [ ] Agent/platform agnostic principle stated explicitly
- [ ] Target repo capture pattern explained (ADR, playbook, AGENTS.md)
- [ ] Re-application rules defined (defer unless explicitly prompted)
- [ ] At least 3 concrete examples provided
- [ ] Consequences section includes good, neutral, and bad impacts

### Task 2: Index Update

- [ ] `docs/adr/README.md` ADR Index includes entry for 0001
- [ ] Entry format matches existing entries

### Task 3: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors in frontmatter

## Review Personas

| Phase          | Reviewers                                      | Focus                                  |
| -------------- | ---------------------------------------------- | -------------------------------------- |
| Refinement     | Documentation Specialist, Agent Skill Engineer | ADR structure, pattern clarity         |
| Implementation | Documentation Specialist, Agent Skill Engineer | Content quality, example effectiveness |
| Approval       | Tech Lead                                      | Strategic alignment, completeness      |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread
