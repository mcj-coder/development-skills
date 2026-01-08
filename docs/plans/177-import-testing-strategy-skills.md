# Implementation Plan: Import Testing Strategy Skills

**Issue:** #177
**Branch:** `feature/177-import-testing-strategy-skills`
**Date:** 2026-01-08

## Overview

Import 15 skills from `C:\Users\mcj\Downloads\testing-strategy-skills-v2` into this repository.
Skills require consistency review and migration to match repo formats (agentskills.io spec).

## Pre-Migration Analysis

### Source Structure Assessment

| Aspect            | Source Format               | Target Format      | Migration Action              |
| ----------------- | --------------------------- | ------------------ | ----------------------------- |
| Reference folder  | `refs/`                     | `references/`      | Rename folder                 |
| Test files        | Missing                     | `*.test.md`        | Create for each skill         |
| Frontmatter       | Present (name, description) | Same               | Verify compliance             |
| Shared references | Top-level `references/`     | Colocate in skills | Distribute to relevant skills |

### Skills Inventory (15 total)

#### Batch 1: Testing & Platform-Agnostic (3 skills)

1. `testing-strategy-agnostic` - No refs, small skill
2. `testing-strategy-dotnet` - Check for refs
3. `security-processes` - Has 5 refs files

#### Batch 2: .NET Core Practices (6 skills)

1. `dotnet-best-practices` - Has 20+ refs files (largest)
2. `dotnet-efcore-practices` - EF Core patterns
3. `dotnet-healthchecks` - Health check implementation
4. `dotnet-logging-serilog` - Serilog logging
5. `dotnet-testing-assertions` - Assertion patterns
6. `dotnet-domain-primitives` - Domain primitives

#### Batch 3: .NET Design Patterns (5 skills)

1. `dotnet-source-generation-first` - Source gen patterns
2. `dotnet-mapping-standard` - Object mapping
3. `dotnet-specification-pattern` - Specification pattern
4. `dotnet-open-source-first-governance` - OSS governance
5. `dotnet-bespoke-code-minimisation` - Code minimisation

#### Batch 4: C# Language (1 skill)

1. `csharp-best-practices` - Has refs for C# 10-14

### Shared References Distribution

Source `references/` files to be distributed:

| Reference File                            | Target Skill                   |
| ----------------------------------------- | ------------------------------ |
| `strongly-typed-ids.md`                   | `dotnet-domain-primitives`     |
| `mapperly.md`                             | `dotnet-mapping-standard`      |
| `specification-pattern.md`                | `dotnet-specification-pattern` |
| `awesome-assertions.md`                   | `dotnet-testing-assertions`    |
| `efcore-migrations-and-configurations.md` | `dotnet-efcore-practices`      |
| `healthchecks-xabaril.md`                 | `dotnet-healthchecks`          |
| `logging-serilog-ilogger.md`              | `dotnet-logging-serilog`       |

## Execution Plan

### Phase 1: Setup & Validation (This PR)

**Objective:** Establish migration infrastructure and validate approach with first batch.

1. Create directory structure for all 15 skills
2. Import Batch 1 (3 skills) with full compliance:
   - Copy SKILL.md files
   - Rename `refs/` to `references/`
   - Create `*.test.md` files with BDD scenarios
   - Verify frontmatter compliance
3. Run `npm run lint` to verify no warnings
4. Commit and create sub-task issues for remaining batches

### Phase 2-4: Batch Imports (Subsequent PRs)

Each batch follows the same process:

1. Import skills from batch
2. Distribute relevant shared references
3. Create test files
4. Verify lint compliance
5. Update README.md skills list

### Phase 5: Finalisation

1. Update README.md with complete skills list
2. Verify all skills load correctly
3. Run final lint check
4. Close issue #177

## Migration Procedure (Per Skill)

```text
For each skill:
1. mkdir skills/<skill-name>
2. cp source/SKILL.md → skills/<skill-name>/SKILL.md
3. IF refs/ exists:
   mv refs/ → references/
4. cp shared reference if applicable
5. CREATE <skill-name>.test.md with BDD scenarios
6. VERIFY frontmatter has name + description
7. UPDATE any internal refs/ → references/ paths in SKILL.md
8. RUN npm run lint
```

## Test File Template

Each skill requires a test file following this structure:

```markdown
# <skill-name> - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: [Scenario Name]

**Given** agent WITHOUT <skill-name> skill
**When** [trigger condition]
**Then** record baseline behaviour:

- [Expected deficient behaviour 1]
- [Expected deficient behaviour 2]

## GREEN Phase - WITH Skill

### Test G1: [Scenario Name]

**Given** agent WITH <skill-name> skill
**When** [trigger condition]
**Then** agent responds with:

- [Expected correct behaviour 1]
- [Expected correct behaviour 2]

**Evidence:**

- [ ] [Verification item 1]
- [ ] [Verification item 2]
```

## Acceptance Criteria

- [ ] All 15 skills in `skills/` directory
- [ ] All `refs/` folders renamed to `references/`
- [ ] All 15 skills have `*.test.md` files
- [ ] All shared references distributed to relevant skills
- [ ] All SKILL.md files have valid frontmatter (name, description)
- [ ] All internal paths updated (`refs/` → `references/`)
- [ ] README.md updated with new skills
- [ ] `npm run lint` passes with 0 warnings

## Estimated Effort

- **Batch 1:** 3 skills (small-medium complexity)
- **Batch 2:** 6 skills (high complexity - `dotnet-best-practices` has 20+ refs)
- **Batch 3:** 5 skills (medium complexity)
- **Batch 4:** 1 skill (medium complexity - has 6 refs)

## Risks & Mitigations

| Risk                                | Mitigation                                                      |
| ----------------------------------- | --------------------------------------------------------------- |
| Large `dotnet-best-practices` skill | Import refs progressively; test file covers main scenarios only |
| Path references in SKILL.md         | Search and replace `refs/` → `references/`                      |
| Missing frontmatter fields          | Add during migration                                            |
| Lint failures                       | Fix incrementally per batch                                     |

## Decision: Sub-Tasks Approach

**Recommendation:** Create sub-task issues for each batch to enable:

- Incremental progress tracking
- Smaller, reviewable PRs
- Parallel work if needed

**Alternative:** Single PR with all 15 skills

- Pros: Single merge
- Cons: Large PR, harder to review

**Decision needed from user:** Proceed with batched sub-tasks or single PR?
