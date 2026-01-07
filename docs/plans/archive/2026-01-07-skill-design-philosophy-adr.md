# Skill Design Philosophy ADR Implementation Plan

**Issue:** #118
**Date:** 2026-01-07
**Status:** Draft (Rev 2 - addressing review feedback)

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
- Define re-application rules with explicit triggers

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
  or questioning how skills should interact with target repositories
  and who owns ongoing process decisions.
decision: Design skills to bootstrap opinionated defaults, then defer to documented decisions in target repositories.
status: accepted
---
```

**Body sections (MADR format):**

1. **Title and Metadata**
   - `# 1. Skill Design Philosophy`
   - Date, Deciders, Tags metadata block

2. **Context and Problem Statement**
   - Skills help bootstrap best practices (TDD, issue-driven, etc.)
   - Need clarity on skill vs target repo responsibility boundary
   - Question: Once a process is established, who owns it?

3. **Decision Drivers**
   - Skills should be agent and platform agnostic
   - Target repos should be self-documenting
   - Agents shouldn't constantly re-apply skills where documented decisions exist
   - Skills should be composable and non-overlapping

4. **Considered Options**
   - Skills always apply (re-evaluate every time)
   - Skills bootstrap only (never re-apply)
   - Hybrid: bootstrap + defer to documented decisions

5. **Decision Outcome: Hybrid Bootstrap Pattern**
   - Skills define process with opinionated defaults
   - Target repo captures decisions (ADR, playbook, AGENTS.md)
   - Documented decisions become "the way"
   - Agents defer to documented decisions unless explicitly prompted

   **Subsection: Detection Mechanism**
   - File locations to check: `docs/adr/`, `docs/coding-standards.md`, `AGENTS.md`, `docs/ways-of-working/`
   - What constitutes a "documented decision": explicit statement, not partial mention
   - Reference AGENTS.md Documentation Mapping table for file-to-concept mapping

   **Subsection: Capture Pattern Guidance**
   - **ADR**: For major architectural or tooling decisions with alternatives considered
   - **Playbook**: For operational procedures with explicit triggers
   - **AGENTS.md**: For agent execution rules and workflow requirements
   - **coding-standards.md**: For coding practices and conventions

   **Subsection: Re-application Triggers**
   Explicit phrases that override deference:
   - "Re-apply {skill-name}"
   - "Reconsider {process-name}"
   - "Reset {pattern} to skill defaults"
   - "Run {skill-name} again"

6. **Consequences**
   - Good: Target repos become self-documenting
   - Good: Agents don't constantly re-prompt for known decisions
   - Good: Skills remain reusable across projects
   - Neutral: Requires discipline to capture decisions
   - Neutral: Target repos may accumulate stale decisions (requires periodic review)
   - Bad: Initial setup requires more documentation

7. **Examples**

   **TDD skill example:**
   - Skill establishes: RED/GREEN/REFACTOR workflow
   - Target repo captures in `coding-standards.md`:

     ```markdown
     ## Test-Driven Development

     This project follows TDD for all code changes. Write failing tests first,
     implement to pass, then refactor. BDD checklists are used for documentation.
     ```

   **Issue-driven workflow example:**
   - Skill establishes: All non-read-only work requires issue
   - Target repo captures in `AGENTS.md`:

     ```markdown
     - **No changes without a Taskboard issue.** All non-read-only work must be tied
       to a Taskboard issue before starting work.
     ```

   **Platform choice example:**
   - Skill defines: "Use a CI/CD platform (GitHub Actions, Azure DevOps, GitLab CI)"
   - Target repo captures in ADR:

     ```markdown
     decision: Use GitHub Actions for CI/CD pipelines.
     ```

8. **Anti-Patterns**
   - Skill constantly re-prompts for decisions already documented
   - Agent ignores target repo documentation and applies skill defaults
   - Skill creates documentation using skill-specific names instead of human terminology

9. **Links**
   - Reference AGENTS.md Documentation Mapping section
   - Link to related ADRs if applicable

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
- [ ] `description` explains when to apply ADR (includes ownership question)
- [ ] `decision` is one-line actionable outcome (imperative format)
- [ ] `status` is `accepted`
- [ ] Title and metadata block present (Date, Deciders, Tags)
- [ ] Body follows MADR format (Context, Drivers, Options, Outcome, Consequences)
- [ ] Bootstrap pattern documented with explanation
- [ ] Agent/platform agnostic principle stated explicitly
- [ ] Target repo capture pattern explained with format selection guidance
- [ ] Detection mechanism specified (file paths agents should check)
- [ ] Re-application triggers explicitly enumerated
- [ ] At least 3 concrete examples with actual capture content
- [ ] Anti-patterns section identifies common mistakes
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

## Review Feedback Addressed (Rev 2)

### Documentation Specialist Feedback

| Issue                                 | Resolution                                                |
| ------------------------------------- | --------------------------------------------------------- |
| I1: Missing MADR metadata             | Added Title and metadata block to body sections           |
| I2: Section ordering                  | Reordered to follow MADR format                           |
| I3: Description lacks ownership       | Added "who owns ongoing process decisions" to frontmatter |
| M1: Decision could be more actionable | Changed to imperative "defer to documented decisions"     |
| M2: Missing Links section             | Added Links section to body outline                       |
| M3: BDD checklist for structure       | Updated to reflect actual planned sections                |

### Agent Skill Engineer Feedback

| Issue                            | Resolution                                              |
| -------------------------------- | ------------------------------------------------------- |
| I1: Detection mechanism missing  | Added Detection Mechanism subsection with file paths    |
| I2: Capture guidance abstract    | Added concrete format guidance for ADR/playbook/AGENTS  |
| I3: Re-application triggers      | Added explicit trigger phrases in subsection            |
| I4: BDD missing implementability | Added checklist items for detection, triggers, examples |
| M1: Cross-reference AGENTS.md    | Added reference to Documentation Mapping                |
| M2: Platform example weak        | Expanded with concrete ADR decision example             |
| M3: Add anti-patterns            | Added Anti-Patterns section                             |
| M4: Maintenance burden note      | Added neutral consequence about stale decisions         |
