# Automation-First Principle ADR Implementation Plan

**Issue:** #119
**Date:** 2026-01-07
**Status:** Draft (Rev 2 - addressing review feedback)

## Overview

Create an ADR documenting the principle that common repetitive processes should be automated
via scripts rather than requiring manual agent intervention.

## Scope

### In Scope

- Create ADR at `docs/adr/0002-automation-first-principle.md`
- Define criteria for when to automate (frequency, complexity, error-prone)
- Establish reference script pattern (location, naming, documentation)
- Document skill-to-script integration pattern
- Add agent decision algorithm

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
  when identifying opportunities to reduce manual agent work,
  or when deciding whether to create automation scripts for a workflow.
decision: Automate repetitive processes via reference scripts; skills drive script creation.
status: accepted
---
```

**Body sections (MADR format):**

1. **Title and Metadata**
   - `# 2. Automation-First Principle`
   - Date, Deciders, Tags metadata block
   - Note: Status appears ONLY in frontmatter for `accepted` ADRs

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
   - **Frequency**: Process occurs regularly (3+ times per week)
   - **Complexity**: Process is mechanical with clear rules (no discretion required)
   - **Error-prone**: Manual execution risks human error
   - **Teachable**: Process can be documented as algorithm

   When NOT to automate:
   - Requires discretion or context-dependent decisions (>2 decision points)
   - Occurs rarely (<10 times over project lifetime)
   - Takes <5 minutes AND occurs <10 times total (manual is acceptable)
   - Automation cost exceeds manual effort over project lifetime

   **Subsection: Agent Decision Algorithm**

   When encountering a repetitive process:
   1. Check if script exists in `skills/<skill-name>/scripts/`
   2. If exists: Invoke script with appropriate flags (e.g., `--apply` for changes)
   3. If not exists AND meets automation criteria: Create issue for script creation
   4. If not exists AND does not meet criteria: Execute manually, document in issue

   **Subsection: Reference Script Pattern**

   Scripts in development-skills repository:
   - **Location**: `skills/<skill-name>/scripts/`
   - **Naming**: `<verb>-<noun>.sh` or `<verb>-<noun>.ps1`
   - **Documentation**: Header comments with purpose, usage, prerequisites
   - **Testing**: Scripts should be idempotent with dry-run by default
   - **Invocation**: Use `--apply` flag to make changes, dry-run without

   Target repositories may adapt:
   - Location may be `scripts/` at repo root or other convention
   - Scripts become templates teams customize to local needs

   **Subsection: Cross-Platform Guidance**
   - **SHOULD** provide both bash and PowerShell when:
     - Script performs cross-platform operations (file manipulation, git commands)
     - Target repos include Windows environments without WSL
   - **MAY** provide bash-only when:
     - Targeting CI/CD environments (GitHub Actions, Linux containers)
     - Windows users have WSL or Git Bash available
   - **Current state**: Existing scripts are bash-only; PowerShell variants future work

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

   **Blocked flag removal (existing script):**
   - Trigger: Blocking issue is closed
   - Script: `skills/issue-driven-delivery/scripts/unblock-dependents.sh`
   - Action: Find dependent issues, remove blocked flag
   - Invocation: `./unblock-dependents.sh mcj-coder/repo 45` (dry-run)
   - Apply: `./unblock-dependents.sh mcj-coder/repo 45 --apply`

   **Priority calculation (existing script):**
   - Trigger: Need to determine issue priority order
   - Script: `skills/issue-driven-delivery/scripts/get-priority-order.sh`
   - Action: Calculate priority based on labels and dependencies
   - Invocation: `./get-priority-order.sh mcj-coder/repo`

   **Dependent notification (future example):**
   - Trigger: Issue state changes
   - Script: `skills/<skill-name>/scripts/notify-dependents.sh` (to be created)
   - Action: Comment on dependent issues about state change

8. **Anti-Patterns**
   - **Agent manually performing scriptable operations repeatedly** - indicates
     automation criteria not being applied or script not discoverable
   - **Over-automation of decisions requiring discretion** - indicates "when NOT
     to automate" criteria being ignored
   - **Platform-specific scripts without documentation** - indicates documentation
     standard not being followed
   - **Non-idempotent scripts** - scripts should be safe to run multiple times

9. **Links**
   - [ADR-0001: Skill Design Philosophy](0001-skill-design-philosophy.md)
   - [Issue-driven-delivery scripts](../../skills/issue-driven-delivery/scripts/)
   - [Scripts README](../../skills/issue-driven-delivery/scripts/README.md)

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
- [ ] `description` explains when to apply ADR (includes 3 trigger conditions)
- [ ] `decision` is one-line actionable outcome
- [ ] `status` is `accepted`
- [ ] Title uses correct numbering format: `# 2. Automation-First Principle`
- [ ] Metadata block present (Date, Deciders, Tags)
- [ ] Body follows MADR format (Context, Drivers, Options, Outcome, Consequences)
- [ ] Automation criteria defined with quantitative thresholds
- [ ] "When NOT to automate" includes concrete decision rules
- [ ] Agent decision algorithm provides step-by-step process
- [ ] Reference script pattern documented (location, naming, documentation, testing)
- [ ] Cross-platform guidance with SHOULD/MAY criteria
- [ ] Skill-to-script integration pattern explained
- [ ] Examples reference actual existing scripts with full paths
- [ ] At least 3 examples with trigger, script, action (2 existing, 1 future)
- [ ] Anti-patterns with explanations (what each indicates)
- [ ] Consequences section includes good, neutral, and bad impacts
- [ ] Links use proper markdown format with relative paths

### Task 2: Index Update

- [ ] `docs/adr/README.md` ADR Index includes entry for 0002
- [ ] Entry format matches existing entries
- [ ] Line length within 120 characters

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

## Review Feedback Addressed (Rev 2)

### Documentation Specialist Feedback

| Issue                                | Resolution                                              |
| ------------------------------------ | ------------------------------------------------------- |
| I1: Frontmatter description triggers | Added third trigger about script creation decisions     |
| I2: Status section pattern           | Clarified status only in frontmatter for accepted ADRs  |
| I3: Script location clarification    | Added section distinguishing dev-skills vs target repos |
| I4: Cross-platform guidance vague    | Added SHOULD/MAY criteria with specific scenarios       |
| M4: BDD title numbering              | Added verification item for title format                |
| M5: Idempotency anti-pattern         | Added "Non-idempotent scripts" to anti-patterns         |

### Agent Skill Engineer Feedback

| Issue                           | Resolution                                              |
| ------------------------------- | ------------------------------------------------------- |
| I1: Decision thresholds missing | Added quantitative criteria (3+/week, <10 times, etc.)  |
| I2: Agent decision flowchart    | Added "Agent Decision Algorithm" subsection             |
| I3: Script naming vs existing   | Updated examples to use actual existing script paths    |
| I4: PowerShell guidance         | Added "Cross-Platform Guidance" subsection with clarity |
| M3: Link to scripts README      | Added link to scripts/README.md in Links section        |
| M4: Anti-patterns with context  | Added "what this indicates" to each anti-pattern        |
