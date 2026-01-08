---
name: skills-first-workflow
description: Use when entering any repository, creating a new repository, or performing repository migration. Automatically enforces prerequisite skill loading and verification before any implementation begins.
compatibility: Requires Superpowers skill system to be installed
metadata:
  type: Process
  priority: P0 (Safety & Integrity)
---

# Skills-First-Workflow

## Overview

Enforce that all work follows a skills-first approach: prerequisite skill
libraries must be installed, bootstrapped, and loaded before any implementation
begins. Performs runtime verification and automatically fixes missing prerequisites.

**CRITICAL**: Load this skill FIRST when entering any repository.

## When to Use

**Entering a repository:**

- First action in any repository
- Beginning any task or work session
- Default behaviour for all repository work

**Creating a repository:**

- Initializing a new repository
- Scaffolding a new project
- Setting up repo structure

**Migrating a repository:**

- Adding skills-first workflow to existing repo
- Updating repository to enforce prerequisite loading
- Establishing skills-first practices

## Core Workflow

1. **Announce** the skill and confirm Superpowers availability.
2. **Verify prerequisites** (runs automatically with AutoFix):
   - Superpowers installed and bootstrapped
   - `superpowers:using-superpowers` loaded
   - AGENTS.md exists and references skills-first-workflow
   - Task-relevant process skills loaded
3. **Initialize or migrate** repository if needed:
   - Greenfield: Create AGENTS.md and README.md
   - Brownfield: Create AGENTS.md on feature branch
4. **Enforce process skills before implementation**:
   - Use `process-skill-router` to select the correct skill based on context
   - Process skills have precondition guards - check these before proceeding
   - Brainstorming (for unclear requirements/new features)
   - Planning (for multi-step tasks)
   - TDD (for code changes)
   - Verification (always before claiming complete)
5. **Block implementation** until all verifications pass.

## Runtime Verification

### Prerequisites Checked

**AutoFix mechanism**: When verification fails, AutoFix reads prerequisite
repository URLs from AGENTS.md, fetches installation instructions from source
repositories, and executes per the agent's default installation mechanism. If
AutoFix cannot complete automatically, it halts and provides manual instructions.

1. **Superpowers available** → AutoFix: Install and bootstrap if not
2. **using-superpowers loaded** → AutoFix: Load if not
3. **AGENTS.md exists** → AutoFix: Create/update if not
4. **Task skills loaded** → AutoFix: Load required skills if not

**Verification must pass before any implementation work begins.**

See `references/AUTOFIX.md` for detailed AutoFix procedures and examples.

## Repository Initialization

### Greenfield

When creating a new repository:

1. Create AGENTS.md with skills-first directives
2. Create README.md with Work Items section
3. Verify initialization complete
4. Commit as part of repository setup

See `references/AGENTS-TEMPLATE.md` for AGENTS.md content.

### Brownfield

When migrating existing repository:

1. Create feature branch: `feat/add-skills-first-workflow`
2. Create AGENTS.md with skills-first directives
3. Update README.md if needed (add Work Items section)
4. Commit with evidence
5. Create PR if required

See `references/AGENTS-TEMPLATE.md` for AGENTS.md content.

## Strict Enforcement Rules

### Before Implementation

**All verifications must pass:**

- Superpowers available
- `using-superpowers` loaded
- AGENTS.md exists and current
- Task-relevant skills loaded

**Only then can implementation begin.**

### Process Skills Required

**Use `process-skill-router` when uncertain which skill applies.** The router evaluates
context and recommends the correct skill based on priority order.

**Precondition guards:** Process skills have precondition checks that must pass before
proceeding. If a precondition fails, the skill will redirect to the correct alternative.
For example, `requirements-gathering` checks that no ticket exists before proceeding.

**For no ticket exists (new work):**

- Load and apply `requirements-gathering` first to create a ticket

**For unclear requirements or new features:**

- Load and apply `superpowers:brainstorming` first

**For multi-step tasks:**

- Load and apply `superpowers:writing-plans` first

**For code changes:**

- Load and apply `superpowers:test-driven-development` first
- Write failing tests before implementation

**For all tasks:**

- Load and apply `superpowers:verification-before-completion`
- Verify before claiming complete

### No Exceptions

**User requests to skip:**

- Explain cannot skip skills-first workflow
- Offer to streamline if skills already loaded
- Proceed with verification anyway

**Simple changes (typos, formatting):**

- Still verify skills loaded (fast if already met)
- Enforcement applies to all changes

**Emergency hotfix:**

- Skills-first still applies
- Minimal skill set acceptable (TDD + verification)
- Cannot skip verification entirely

## Composition

**This skill does NOT create rigid dependencies:**

- Other skills do not declare this as prerequisite
- Loaded first by convention (via AGENTS.md reference)
- Skills remain composable and independent

**Verification responsibilities:**

- Verifies `using-superpowers` loaded
- Verifies AGENTS.md references skills-first-workflow
- Other skills loaded based on task requirements

## Evidence Requirements

**Greenfield:**

- [ ] AGENTS.md created with skills-first directives and prerequisite repo URLs
- [ ] README.md created with Work Items section
- [ ] Both files committed as part of initialization

**Brownfield:**

- [ ] Feature branch created
- [ ] AGENTS.md created/updated with skills-first directives and prerequisite repo URLs
- [ ] Changes committed with evidence
- [ ] PR created if required

**Every Task:**

- [ ] Verification passed: Superpowers available
- [ ] Verification passed: using-superpowers loaded
- [ ] Verification passed: AGENTS.md exists and current
- [ ] Verification passed: Task-relevant skills loaded
- [ ] Process skills applied before implementation

## Quick Reference

| Scenario            | Action                              | Result                            |
| ------------------- | ----------------------------------- | --------------------------------- |
| New repo            | Load skill → AutoFix creates files  | AGENTS.md + README.md initialized |
| Existing repo       | Load skill → AutoFix on branch      | AGENTS.md created via PR          |
| Missing Superpowers | AutoFix installs                    | Superpowers bootstrapped          |
| Missing skills      | AutoFix loads                       | Required skills loaded            |
| Skip request        | Explain + proceed with verification | Enforcement maintained            |

## Red Flags - STOP

- "Just skip the skills and implement quickly."
- "We don't need AGENTS.md for this repo."
- "I'll load skills after I start coding."
- "Tests can come later, implement first."
- "Verification is optional for small changes."

## Success Criteria

**Prerequisites met:**

- Superpowers installed and bootstrapped
- `using-superpowers` loaded
- AGENTS.md exists and references skills-first-workflow

**Process followed:**

- Process skills loaded before implementation
- TDD applied for code changes
- Verification applied before claiming complete

**No shortcuts:**

- Implementation did not begin before skills loaded
- Tests written before implementation code
- Verification completed before claiming done

**AutoFix worked:**

- Missing prerequisites automatically installed
- Missing AGENTS.md automatically created
- No manual intervention required for standard cases

## References

- `references/AGENTS-TEMPLATE.md` - Template for creating AGENTS.md
- `references/AUTOFIX.md` - Detailed AutoFix behaviour for each verification check
- `process-skill-router` - Route to correct process skill based on context
- `requirements-gathering` - Example of precondition guard pattern
