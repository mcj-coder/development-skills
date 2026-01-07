# Repo Best Practices Bootstrap Implementation Plan

**Issue:** #121
**Date:** 2026-01-07
**Status:** Draft

## Approval History

| Phase | Reviewer | Decision | Date | Plan Commit | Comment Link |
| ----- | -------- | -------- | ---- | ----------- | ------------ |
|       |          |          |      |             |              |

## Overview

Create a skill that ensures repositories have appropriate security and best practice features
configured and enabled, applicable to both greenfield and brownfield projects. The skill covers
6 categories: Repository Security, CI/CD Security, Code Quality Gates, Documentation Baseline,
Agent Enablement, and Development Standards.

## Scope

### In Scope

- Platform detection (GitHub, Azure DevOps, GitLab, Bitbucket)
- Checklist covering all 6 categories with platform-specific CLI commands
- Reference templates in `templates/` directory
- Opt-out mechanism (per feature and per category)
- Cost flagging with free alternatives
- Works for greenfield (new repo) and brownfield (existing repo)
- BDD tests for validation

### Out of Scope

- Automated CI/CD enforcement (separate issue)
- Full implementation for all platforms (GitHub primary, others documented)
- Bitbucket templates (GitHub, Azure DevOps, GitLab only for MVP)

## Implementation Tasks

### Task 1: Create Skill Skeleton

Create the main SKILL.md with frontmatter, overview, and core workflow.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/SKILL.md`

**Content structure:**

```markdown
---
name: repo-best-practices-bootstrap
description:
  Use when setting up new repositories or auditing existing ones for security
  and best practice compliance. Covers branch protection, secret scanning, CI/CD security,
  documentation, and agent enablement.
---

# Repo Best Practices Bootstrap

## Overview

## When to Use

## Prerequisites

## Platform Detection

## Core Workflow

## Opt-Out Mechanism

## See Also
```

**Deliverable:** `skills/repo-best-practices-bootstrap/SKILL.md`

### Task 2: Create Checklist Reference

Create comprehensive checklist covering all 6 categories with platform-specific commands.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/references/checklist.md`

**Categories to include:**

1. Repository Security (branch protection, signed commits, secret scanning, etc.)
2. CI/CD Security (permissions, OIDC, artifact signing, etc.)
3. Code Quality Gates (reviews, status checks, linting, etc.)
4. Documentation Baseline (README, CONTRIBUTING, LICENSE, SECURITY, etc.)
5. Agent Enablement (CLAUDE.md, AGENTS.md, skills, hooks)
6. Development Standards (.editorconfig, .gitignore, pre-commit, etc.)

Each item must include:

- Description
- Platform-specific CLI commands (GitHub, Azure DevOps, GitLab)
- Cost indicator (Free/Paid)
- Opt-out instructions

**Deliverable:** `skills/repo-best-practices-bootstrap/references/checklist.md`

### Task 3: Create Platform Detection Reference

Document platform detection logic and CLI availability.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/references/platform-detection.md`

**Content:**

- Git remote URL patterns for each platform
- CLI tool requirements (gh, az, glab)
- Detection script/logic
- Fallback behavior

**Deliverable:** `skills/repo-best-practices-bootstrap/references/platform-detection.md`

### Task 4: Create Cost Considerations Reference

Document cost-incurring features and free alternatives.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/references/cost-considerations.md`

**Content:**

- Features requiring paid plans
- Free alternatives for each paid feature
- Platform-specific pricing notes
- Decision matrix for cost vs benefit

**Deliverable:** `skills/repo-best-practices-bootstrap/references/cost-considerations.md`

### Task 5: Create Common Templates

Create platform-agnostic templates for documentation and configuration.

**Files to create:**

- `skills/repo-best-practices-bootstrap/templates/common/CLAUDE.md.template`
- `skills/repo-best-practices-bootstrap/templates/common/AGENTS.md.template`
- `skills/repo-best-practices-bootstrap/templates/common/CONTRIBUTING.md.template`
- `skills/repo-best-practices-bootstrap/templates/common/SECURITY.md.template`
- `skills/repo-best-practices-bootstrap/templates/common/.editorconfig`
- `skills/repo-best-practices-bootstrap/templates/common/.pre-commit-config.yaml`
- `skills/repo-best-practices-bootstrap/templates/README.md` (usage guide)

**Deliverable:** Common templates directory with all files

### Task 6: Create GitHub Templates

Create GitHub-specific templates and configurations.

**Files to create:**

- `skills/repo-best-practices-bootstrap/templates/github/branch-protection.json`
- `skills/repo-best-practices-bootstrap/templates/github/CODEOWNERS.template`
- `skills/repo-best-practices-bootstrap/templates/github/workflows/ci.yml`
- `skills/repo-best-practices-bootstrap/templates/github/dependabot.yml`

**Deliverable:** GitHub templates directory with all files

### Task 7: Create BDD Tests

Create BDD test file validating skill functionality.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/repo-best-practices-bootstrap.test.md`

**Scenarios to cover:**

- GREEN: Greenfield repository setup
- GREEN: Brownfield repository audit
- GREEN: Platform detection works
- GREEN: Opt-out mechanism works
- RED: Missing prerequisites handled
- RED: Invalid platform handled

**Deliverable:** `skills/repo-best-practices-bootstrap/repo-best-practices-bootstrap.test.md`

### Task 8: Dogfood on This Repository

Validate the skill by running checklist against this repository.

**Process:**

1. Run platform detection
2. Execute checklist
3. Document gaps found
4. Create issues for any missing items (if significant)

**Deliverable:** Dogfooding results documented in issue comment

### Task 9: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                             | Task      |
| --------------------------------------------------------------- | --------- |
| Skill created at `skills/repo-best-practices-bootstrap/`        | Task 1    |
| Platform detection logic documented                             | Task 3    |
| Checklist covers all 6 categories                               | Task 2    |
| Platform-specific CLI commands for GitHub, Azure DevOps, GitLab | Task 2    |
| Reference templates in `templates/`                             | Task 5, 6 |
| Opt-out mechanism documented                                    | Task 1, 2 |
| Cost-incurring features flagged with free alternatives          | Task 4    |
| Works for greenfield and brownfield                             | Task 1, 2 |
| Dogfooded on this repository                                    | Task 8    |
| BDD tests validate checklist completion                         | Task 7    |
| Linting passes                                                  | Task 9    |

## BDD Verification Checklist

### Task 1: Skill Skeleton

- [ ] File exists at `skills/repo-best-practices-bootstrap/SKILL.md`
- [ ] Frontmatter includes name and description
- [ ] Overview explains purpose
- [ ] When to Use section present
- [ ] Core Workflow defined
- [ ] Opt-out mechanism documented
- [ ] References to checklist and templates

### Task 2: Checklist Reference

- [ ] File exists at `skills/repo-best-practices-bootstrap/references/checklist.md`
- [ ] All 6 categories present
- [ ] Each item has description
- [ ] Each item has GitHub CLI command
- [ ] Each item has Azure DevOps command (where applicable)
- [ ] Each item has GitLab command (where applicable)
- [ ] Cost indicator (Free/Paid) for each item
- [ ] Opt-out instructions for each category

### Task 3: Platform Detection

- [ ] File exists at `skills/repo-best-practices-bootstrap/references/platform-detection.md`
- [ ] GitHub detection pattern documented
- [ ] Azure DevOps detection pattern documented
- [ ] GitLab detection pattern documented
- [ ] CLI tool requirements listed
- [ ] Detection script provided

### Task 4: Cost Considerations

- [ ] File exists at `skills/repo-best-practices-bootstrap/references/cost-considerations.md`
- [ ] Paid features identified
- [ ] Free alternatives documented
- [ ] Platform-specific notes present

### Task 5: Common Templates

- [ ] `templates/common/CLAUDE.md.template` exists
- [ ] `templates/common/AGENTS.md.template` exists
- [ ] `templates/common/CONTRIBUTING.md.template` exists
- [ ] `templates/common/SECURITY.md.template` exists
- [ ] `templates/common/.editorconfig` exists
- [ ] `templates/common/.pre-commit-config.yaml` exists
- [ ] `templates/README.md` exists with usage instructions

### Task 6: GitHub Templates

- [ ] `templates/github/branch-protection.json` exists
- [ ] `templates/github/CODEOWNERS.template` exists
- [ ] `templates/github/workflows/ci.yml` exists
- [ ] `templates/github/dependabot.yml` exists

### Task 7: BDD Tests

- [ ] File exists at `skills/repo-best-practices-bootstrap/repo-best-practices-bootstrap.test.md`
- [ ] GREEN scenarios cover greenfield and brownfield
- [ ] GREEN scenario for platform detection
- [ ] RED scenarios for error cases
- [ ] Scenarios are executable

### Task 8: Dogfooding

- [ ] Checklist run against this repository
- [ ] Results documented in issue comment
- [ ] Gaps identified (if any)

### Task 9: Validation

- [ ] `npm run lint` passes with no errors

## Review Personas

| Phase          | Reviewers                                                       | Focus                                            |
| -------------- | --------------------------------------------------------------- | ------------------------------------------------ |
| Refinement     | Security Reviewer, Agent Skill Engineer, DevOps Engineer        | Security coverage, automation, CI/CD             |
| Implementation | Documentation Specialist, DevOps Engineer, Agent Skill Engineer | Content quality, platform accuracy, skill design |
| Approval       | Tech Lead                                                       | Strategic alignment, completeness                |

## Evidence Requirements

**Task 1 (Skill Skeleton):**

- Commit SHA for skill file creation
- File link to `skills/repo-best-practices-bootstrap/SKILL.md`

**Task 2 (Checklist):**

- Commit SHA for checklist creation
- File link to `skills/repo-best-practices-bootstrap/references/checklist.md`

**Tasks 3-6 (References and Templates):**

- Commit SHAs for each file set
- Directory listing showing all files

**Task 7 (BDD Tests):**

- Commit SHA for test file
- File link to test file

**Task 8 (Dogfooding):**

- Issue comment link with results

**Task 9 (Validation):**

- Lint output showing clean build (0 errors)

## Review History

(To be populated during review cycles)
