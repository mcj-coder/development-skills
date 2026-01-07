# Automation-First Principle ADR Implementation Plan

**Issue:** #119
**Date:** 2026-01-07
**Status:** Draft

## Overview

Create an ADR documenting the principle that common repetitive processes should be automated
via scripts rather than requiring manual agent intervention.

## Scope

### In Scope

- Create ADR at `docs/adr/0002-automation-first-principle.md`
- Define criteria for when to automate (frequency, complexity, error-prone)
- Establish reference script pattern (location, naming, documentation)
- Document skill-to-script integration pattern

### Out of Scope

- Creating actual automation scripts (future work per skill)
- Platform-specific automation implementations
- CI/CD integration details

## Implementation Tasks

### Task 1: Create ADR Document

Create `docs/adr/0002-automation-first-principle.md` with MADR format:

**Frontmatter:**

```yaml
---
name: automation-first-principle
description: |
  Apply when designing skills that involve repetitive processes,
  or when identifying opportunities to reduce manual agent work.
decision: Automate repetitive processes via reference scripts; skills drive script creation.
status: accepted
---
```

**Body sections (MADR format):**

1. **Title and Metadata**
   - `# 2. Automation-First Principle`
   - Date, Deciders, Tags metadata block

2. **Context and Problem Statement**
   - Skills often involve repetitive processes (flag removal, priority updates)
   - Manual agent work is expensive and error-prone
   - Need consistent approach to identifying automation opportunities
   - Question: When should a process be automated vs manual?

3. **Decision Drivers**
   - Reduce repetitive manual agent work
   - Improve consistency and reliability
   - Create reusable reference implementations
   - Enable skill composability with automation

4. **Considered Options**
   - Manual agent execution for all processes
   - Full automation with no manual fallback
   - Hybrid: automate common cases, manual for edge cases

5. **Decision Outcome: Automation-First with Manual Fallback**
   - Common repetitive processes should be automated
   - Reference scripts provided in skills
   - Manual fallback for complex/edge cases

   **Subsection: Automation Criteria**
   When to automate a process:
   - **Frequency**: Process occurs regularly (daily, per-issue, per-PR)
   - **Complexity**: Process is mechanical with clear rules
   - **Error-prone**: Manual execution risks human error
   - **Teachable**: Process can be documented as algorithm

   When NOT to automate:
   - Requires discretion or context-dependent decisions
   - Occurs rarely (setup-only, one-time)
   - Automation cost exceeds manual effort over project lifetime

   **Subsection: Reference Script Pattern**
   - **Location**: `skills/<skill-name>/scripts/`
   - **Naming**: `<verb>-<noun>.sh` or `<verb>-<noun>.ps1`
   - **Documentation**: Header comments with purpose, usage, prerequisites
   - **Testing**: Scripts should be idempotent and testable
   - **Platform**: Provide both bash and PowerShell where practical

   **Subsection: Skill-to-Script Integration**
   - Skills identify automation opportunities during design
   - Skills reference scripts for repetitive operations
   - Scripts become reusable templates for target repos
   - Target repos may adapt scripts to local conventions

6. **Consequences**
   - Good: Reduced manual work for agents and humans
   - Good: Consistent execution of repetitive processes
   - Good: Reusable reference implementations
   - Neutral: Initial script development effort
   - Bad: Scripts require maintenance as platforms evolve

7. **Examples**

   **Blocked flag removal:**
   - Trigger: Blocking issue is closed
   - Script: `scripts/unblock-dependents.sh`
   - Action: Find dependent issues, remove blocked flag

   **Priority inheritance:**
   - Trigger: Issue priority changes
   - Script: `scripts/get-priority-order.sh`
   - Action: Calculate priority based on dependencies

   **Dependent notification:**
   - Trigger: Issue state changes
   - Script: `scripts/notify-dependents.sh`
   - Action: Comment on dependent issues about state change

8. **Anti-Patterns**
   - Agent manually performing scriptable operations repeatedly
   - Over-automation of decisions requiring human discretion
   - Platform-specific scripts without documentation

9. **Links**
   - Reference ADR-0001: Skill Design Philosophy
   - Link to existing scripts in `skills/issue-driven-delivery/scripts/`

**Deliverable:** `docs/adr/0002-automation-first-principle.md`

### Task 2: Update ADR Index

Update `docs/adr/README.md` ADR Index section to include new ADR.

**Deliverable:** Updated index in README.md

### Task 3: Run Linting Validation

1. Run `npm run lint` to validate YAML and markdown
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                              | Task   |
| ---------------------------------------------------------------- | ------ |
| ADR created at `docs/adr/0002-automation-first-principle.md`     | Task 1 |
| Automation criteria defined (frequency, complexity, error-prone) | Task 1 |
| Reference script pattern documented                              | Task 1 |
| Integration pattern: skills drive script creation                | Task 1 |
| Examples: blocked flag removal, priority inheritance             | Task 1 |
| Linting passes                                                   | Task 3 |

## BDD Verification Checklist

### Task 1: ADR Creation

- [ ] File exists at `docs/adr/0002-automation-first-principle.md`
- [ ] Frontmatter contains all required fields (name, description, decision, status)
- [ ] `name` is kebab-case: `automation-first-principle`
- [ ] `description` explains when to apply ADR
- [ ] `decision` is one-line actionable outcome
- [ ] `status` is `accepted`
- [ ] Title and metadata block present (Date, Deciders, Tags)
- [ ] Body follows MADR format (Context, Drivers, Options, Outcome, Consequences)
- [ ] Automation criteria defined with "when to automate" and "when NOT to automate"
- [ ] Reference script pattern documented (location, naming, documentation, testing)
- [ ] Skill-to-script integration pattern explained
- [ ] At least 3 concrete examples with trigger, script, action
- [ ] Anti-patterns section identifies common mistakes
- [ ] Consequences section includes good, neutral, and bad impacts
- [ ] Links to related ADRs and existing scripts

### Task 2: Index Update

- [ ] `docs/adr/README.md` ADR Index includes entry for 0002
- [ ] Entry format matches existing entries

### Task 3: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors in frontmatter

## Review Personas

| Phase          | Reviewers                                      | Focus                                  |
| -------------- | ---------------------------------------------- | -------------------------------------- |
| Refinement     | Documentation Specialist, Agent Skill Engineer | ADR structure, automation clarity      |
| Implementation | Documentation Specialist, Agent Skill Engineer | Content quality, example effectiveness |
| Approval       | Tech Lead                                      | Strategic alignment, completeness      |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread
