# architecture-testing Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create an agentskills.io-compatible skill that ensures agents apply architectural boundary
enforcement with opt-out for simple projects.

**Architecture:** Follow writing-skills TDD methodology: RED phase (baseline without skill), GREEN phase
(write minimal skill), REFACTOR phase (close loopholes). Skill uses progressive loading with main
SKILL.md (<300 words) plus references/ folder for heavy content.

**Tech Stack:** Markdown (agentskills.io format), YAML frontmatter, Claude Code subagents for testing

---

## Task 1: Create Directory Structure

### Files

- Create: `skills/architecture-testing/SKILL.md` (placeholder)
- Create: `skills/architecture-testing/references/` (directory)

#### Step 1: Create skill directory and placeholder

```bash
mkdir -p skills/architecture-testing/references
```

#### Step 2: Create minimal placeholder SKILL.md

Create `skills/architecture-testing/SKILL.md`:

```markdown
---
name: architecture-testing
description: >-
  Use when user mentions architectural boundaries, layering, dependency rules, project structure
  constraints, or asks to define/review/enforce architecture. For new apps, check if production
  quality/best practices/specific pattern requested.
---

# architecture-testing

PLACEHOLDER - Skill content pending TDD baseline testing.
```

#### Step 3: Commit placeholder

```bash
git add skills/architecture-testing/
git commit -m "chore: create architecture-testing skill placeholder for TDD"
```

---

## Task 2: RED Phase - Baseline Scenario 1 (Time Pressure + New Project)

### Files

- Create: `skills/architecture-testing/architecture-testing.baseline.md`

#### Step 1: Design the pressure scenario prompt

Use this exact prompt with a subagent that does NOT have the architecture-testing skill loaded:

```text
You are building a new application. Time pressure: "Need this for demo tomorrow."

User request: "Create a REST API for managing tasks with users, projects, and tasks. We need endpoints
for CRUD operations on all three entities."

Implement the initial structure and at least one entity's endpoints.
```

#### Step 2: Run baseline test via Task tool

```text
Task(subagent_type="general-purpose", prompt=<scenario above>)
```

#### Step 3: Document baseline behavior

Record in `architecture-testing.baseline.md`:

- Did agent establish architecture pattern? (expected: NO)
- Did agent define layer boundaries? (expected: NO)
- Did agent add architecture tests? (expected: NO)
- Capture verbatim rationalizations (e.g., "Keep it simple", "Can add later")

#### Step 4: Commit baseline evidence

```bash
git add skills/architecture-testing/architecture-testing.baseline.md
git commit -m "test(architecture-testing): RED phase scenario 1 - time pressure baseline"
```

---

## Task 3: RED Phase - Baseline Scenario 2 (Sunk Cost + Refactoring)

### Files

- Modify: `skills/architecture-testing/architecture-testing.baseline.md`

#### Step 1: Design the sunk cost scenario prompt

```text
You have already written 800 lines of code across 15 files for a REST API. The code works but has
mixed concerns - database access in controllers, business logic scattered across files.

User request: "This is getting messy, can you add clean architecture to organize this better?"

Propose how you would approach this.
```

#### Step 2: Run baseline test via Task tool

```text
Task(subagent_type="general-purpose", prompt=<scenario above>)
```

#### Step 3: Append baseline behavior to documentation

Add to `architecture-testing.baseline.md`:

- Did agent define boundaries for existing code? (expected: NO - too disruptive)
- Did agent add tests to enforce boundaries? (expected: NO)
- Capture verbatim rationalizations

#### Step 4: Commit baseline evidence

```bash
git add skills/architecture-testing/architecture-testing.baseline.md
git commit -m "test(architecture-testing): RED phase scenario 2 - sunk cost baseline"
```

---

## Task 4: RED Phase - Baseline Scenario 3 (Authority + Production Rush)

### Files

- Modify: `skills/architecture-testing/architecture-testing.baseline.md`

#### Step 1: Design the authority pressure scenario prompt

```text
Context: Tech lead said "just finish it" and production deploy is Friday.

You are working on a REST API that's 80% complete. No architecture tests exist. The code works but
has some dependency direction violations.

User request: "Add the remaining features and prepare for production. We need to ship Friday."

What's your approach?
```

#### Step 2: Run baseline test via Task tool

```text
Task(subagent_type="general-purpose", prompt=<scenario above>)
```

#### Step 3: Append baseline behavior to documentation

Add to `architecture-testing.baseline.md`:

- Did agent suggest architecture enforcement? (expected: NO)
- Did agent add architecture tests before production? (expected: NO)
- Capture verbatim rationalizations

#### Step 4: Commit completed RED phase

```bash
git add skills/architecture-testing/architecture-testing.baseline.md
git commit -m "test(architecture-testing): RED phase complete - all baseline scenarios documented"
```

---

## Task 5: GREEN Phase - Write Minimal SKILL.md

### Files

- Modify: `skills/architecture-testing/SKILL.md`

#### Step 1: Write the SKILL.md addressing baseline failures

Replace placeholder with minimal skill content (<300 words). Must address:

- Time pressure rationalization ("Can add later")
- Sunk cost rationalization ("Too disruptive")
- Authority rationalization ("Tech lead said skip it")

```markdown
---
name: architecture-testing
description: >-
  Use when user mentions architectural boundaries, layering, dependency rules, project structure
  constraints, or asks to define/review/enforce architecture. For new apps, check if production
  quality/best practices/specific pattern requested.
---

# Architecture Testing

## Overview

Enforce architectural boundaries with automated tests. Prevents dependency violations that cause
coupling and maintenance debt.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- User mentions architecture, boundaries, layers, dependency rules
- Creating production-quality application
- **Opt-out offered:** New apps without explicit production/best-practice/pattern request

## Core Workflow

1. **Opt-out check:** New app without production quality/best practice/pattern? Offer opt-out
2. **Pattern selection:** Clean, Hexagonal, Onion, Layered, or Modular Monolith
3. **Define boundaries:** Minimum 3 explicit layers with dependency rules
4. **Add tests:** NetArchTest (.NET), ArchUnit (Java), or custom
5. **Enforce:** Pre-commit hooks + CI pipeline
6. **Document:** Update `docs/architecture-overview.md` (human-readable)
7. **Brownfield:** Permissive tests initially, tighten incrementally

## Quick Reference

| Pattern   | Key Boundary Rule                      |
| --------- | -------------------------------------- |
| Clean     | Dependencies point inward only         |
| Hexagonal | Ports/adapters isolate core            |
| Onion     | Domain at center, no outward deps      |
| Layered   | Each layer depends only on layer below |

See [Pattern Details](references/architecture-patterns.md) and
[NetArchTest Examples](references/netarchtest-examples.md).

## Red Flags - STOP

- "Can add architecture later" (Later never happens)
- "Too disruptive for existing code" (Use brownfield approach)
- "Demo doesn't need it" (Demos become production)
- "Tech lead said skip it" (Clarify cost with tech lead)

**All mean: Apply brownfield approach or document explicit opt-out in `docs/exclusions.md`.**
```

#### Step 2: Verify word count

```bash
wc -w skills/architecture-testing/SKILL.md
# Target: <300 words (excluding code blocks)
```

#### Step 3: Commit minimal skill

```bash
git add skills/architecture-testing/SKILL.md
git commit -m "feat(architecture-testing): GREEN phase - minimal skill addressing baseline failures"
```

---

## Task 6: GREEN Phase - Create Reference Files

### Files

- Create: `skills/architecture-testing/references/architecture-patterns.md`
- Create: `skills/architecture-testing/references/netarchtest-examples.md`

#### Step 1: Create architecture-patterns.md

```markdown
# Architecture Patterns Reference

## Clean Architecture

**Layers (inside out):**

1. Domain - Entities, value objects, domain services
2. Application - Use cases, DTOs, interfaces
3. Infrastructure - Database, external services, frameworks
4. Presentation - Controllers, views, API endpoints

**Dependency Rule:** All dependencies point inward. Domain has no dependencies.

## Hexagonal Architecture (Ports & Adapters)

**Structure:**

- Core: Domain logic and port interfaces
- Adapters: Implementations (DB, HTTP, messaging)

**Dependency Rule:** Adapters depend on ports, never core on adapters.

## Onion Architecture

**Layers:**

1. Domain Model (center)
2. Domain Services
3. Application Services
4. Infrastructure (outer)

**Dependency Rule:** Each layer can only depend on inner layers.

## Layered Architecture

**Layers:**

1. Presentation
2. Business Logic
3. Data Access

**Dependency Rule:** Each layer depends only on the layer directly below.

## Modular Monolith

**Structure:**

- Independent modules with clear boundaries
- Modules communicate through defined interfaces
- Can be extracted to microservices later

**Dependency Rule:** No circular dependencies between modules.
```

#### Step 2: Create netarchtest-examples.md

````markdown
# NetArchTest Examples

## Installation

```bash
dotnet add package NetArchTest.Rules
```

## Common Boundary Tests

### Domain Has No External Dependencies

```csharp
[Fact]
public void Domain_Should_Not_Reference_Infrastructure()
{
    var result = Types.InAssembly(typeof(DomainMarker).Assembly)
        .ShouldNot()
        .HaveDependencyOn("Infrastructure")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

### Controllers Only in Presentation

```csharp
[Fact]
public void Controllers_Should_Only_Be_In_Presentation()
{
    var result = Types.InCurrentDomain()
        .That()
        .HaveNameEndingWith("Controller")
        .Should()
        .ResideInNamespace("Presentation")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

### Application Layer Depends Only on Domain

```csharp
[Fact]
public void Application_Should_Only_Depend_On_Domain()
{
    var result = Types.InAssembly(typeof(ApplicationMarker).Assembly)
        .ShouldNot()
        .HaveDependencyOn("Infrastructure")
        .And()
        .ShouldNot()
        .HaveDependencyOn("Presentation")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

## Brownfield: Permissive Tests with Suppressions

```csharp
[Fact]
public void Domain_Should_Not_Reference_Infrastructure_Except_Legacy()
{
    var result = Types.InAssembly(typeof(DomainMarker).Assembly)
        .That()
        .DoNotResideInNamespace("Domain.Legacy") // Suppress legacy code
        .ShouldNot()
        .HaveDependencyOn("Infrastructure")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```
````

#### Step 3: Commit reference files

```bash
git add skills/architecture-testing/references/
git commit -m "docs(architecture-testing): add reference files for patterns and NetArchTest"
```

---

## Task 7: GREEN Phase - Verify Skill Passes Scenarios

### Files

- Modify: `skills/architecture-testing/architecture-testing.baseline.md`

#### Step 1: Run Scenario 1 WITH skill loaded

Use Task tool with architecture-testing skill context:

```text
You have the architecture-testing skill loaded. Follow it exactly.

Time pressure: "Need this for demo tomorrow."

User request: "Create a REST API for managing tasks with users, projects, and tasks."

What is your approach?
```

#### Step 2: Verify compliance

Check response includes:

- [ ] Opt-out offered (new app without production/pattern specified)
- [ ] If proceeding, pattern identified
- [ ] Boundary rules stated (minimum 3)
- [ ] Architecture tests mentioned

#### Step 3: Run Scenario 2 WITH skill loaded (brownfield)

```text
You have the architecture-testing skill loaded. Follow it exactly.

User request: "This existing codebase is messy, can you add clean architecture?"

What is your approach?
```

#### Step 4: Verify brownfield compliance

Check response includes:

- [ ] Incremental migration approach
- [ ] Permissive initial tests proposed
- [ ] No "too disruptive" rationalization

#### Step 5: Run Scenario 3 WITH skill loaded (authority pressure)

```text
You have the architecture-testing skill loaded. Follow it exactly.

Context: Tech lead said "just finish it" and production deploy is Friday.

User request: "Add remaining features and prepare for production."

What is your approach?
```

#### Step 6: Verify authority pressure compliance

Check response includes:

- [ ] Architecture enforcement suggested despite pressure
- [ ] Or explicit recommendation to clarify with tech lead
- [ ] No "skip it" rationalization

#### Step 7: Update baseline.md with GREEN phase results

Add GREEN phase section to `architecture-testing.baseline.md` documenting compliance.

#### Step 8: Commit GREEN phase verification

```bash
git add skills/architecture-testing/architecture-testing.baseline.md
git commit -m "test(architecture-testing): GREEN phase - skill compliance verified"
```

---

## Task 8: REFACTOR Phase - Close Loopholes

### Files

- Modify: `skills/architecture-testing/SKILL.md`
- Modify: `skills/architecture-testing/architecture-testing.baseline.md`

#### Step 1: Identify new rationalizations from GREEN testing

Review GREEN phase responses for any new workarounds or partial compliance.

#### Step 2: Add rationalizations table if missing

Ensure SKILL.md includes table mapping excuses to reality.

#### Step 3: Verify red flags list is complete

Ensure all observed rationalizations are in red flags.

#### Step 4: Re-run scenarios to verify loopholes closed

Run all 3 scenarios again, verify full compliance.

#### Step 5: Update baseline.md with REFACTOR results

Add REFACTOR phase section documenting loopholes identified and closed.

#### Step 6: Commit REFACTOR phase

```bash
git add skills/architecture-testing/
git commit -m "refactor(architecture-testing): close loopholes from pressure testing"
```

---

## Task 9: Final Verification and PR

### Files

- All files in `skills/architecture-testing/`

#### Step 1: Verify file structure

```bash
ls -la skills/architecture-testing/
# Expected:
# - SKILL.md (<300 words main content)
# - architecture-testing.baseline.md (TDD evidence)
# - references/architecture-patterns.md
# - references/netarchtest-examples.md
```

#### Step 2: Verify word count

```bash
wc -w skills/architecture-testing/SKILL.md
# Target: <300 words
```

#### Step 3: Run final compliance check

Run one more pressure scenario to confirm skill works.

#### Step 4: Push and create PR

```bash
git push -u origin feat/issue-1-architecture-testing
gh pr create \
  --title "feat(architecture-testing): add architecture boundary enforcement skill" \
  --body "## Summary
- Adds architecture-testing skill with TDD baseline evidence
- Implements opt-out for simple projects
- Includes brownfield incremental approach
- Progressive loading with references/ folder

## Test Evidence
See architecture-testing.baseline.md for RED/GREEN/REFACTOR phases.

Closes #1

---
Generated with [Claude Code](https://claude.com/claude-code)"
```

#### Step 5: Get Tech Lead approval and merge

Post Tech Lead review comment, merge PR, close issue #1.

---

## Execution Notes

- Each task should take 5-15 minutes
- RED phase requires subagent testing (Task tool)
- GREEN phase writes minimal content addressing observed failures
- REFACTOR phase closes any loopholes found during GREEN testing
- Commit frequently (after each task)
- Evidence in baseline.md is critical for skill validity
