# Repo Best Practices Bootstrap Implementation Plan

**Issue:** #121
**Date:** 2026-01-07
**Status:** In Progress

## Approval History

| Phase           | Reviewer             | Decision | Date       | Plan Commit | Comment Link |
| --------------- | -------------------- | -------- | ---------- | ----------- | ------------ |
| Plan Refinement | Security Reviewer    | Feedback | 2026-01-07 | fb16c6b     | (session)    |
| Plan Refinement | Agent Skill Engineer | Feedback | 2026-01-07 | fb16c6b     | (session)    |
| Plan Refinement | DevOps Engineer      | Feedback | 2026-01-07 | fb16c6b     | (session)    |
| Plan Approval   | Tech Lead            | APPROVED | 2026-01-07 | deb4af3     | (session)    |

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
- Azure DevOps and GitLab templates (GitHub primary for MVP, others deferred to follow-up issue)
- Bitbucket CLI support (platform detection yes, templates no)
- Full implementation for all platforms (GitHub primary, others documented with CLI commands)

## Implementation Tasks

### Task 1: Create Skill Skeleton

Create the main SKILL.md with frontmatter, overview, and core workflow.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/SKILL.md`

**Content structure:**

````markdown
---
name: repo-best-practices-bootstrap
description:
  Use when setting up new repositories or auditing existing ones for security
  and best practice compliance. Covers branch protection, secret scanning, CI/CD security,
  documentation, and agent enablement.
---

# Repo Best Practices Bootstrap

## Overview

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Setting up new repository (greenfield)
- Auditing existing repository (brownfield)
- User asks to "bootstrap", "secure", or "audit" a repository
- Compliance check requested

## Prerequisites

## Platform Detection

## Core Workflow

## Opt-Out Mechanism

## Opt-Out Persistence

Opt-out decisions are stored in `.repo-bootstrap.yml` in the target repository:

```yaml
# .repo-bootstrap.yml
opt_out:
  categories:
    - ci-cd-security # Opt out entire category
  features:
    - signed-commits # Opt out specific feature
    - artifact-signing
```

## See Also
````

**Deliverable:** `skills/repo-best-practices-bootstrap/SKILL.md`

### Task 2: Create Checklist Reference

Create comprehensive checklist covering all 6 categories with platform-specific commands.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/references/checklist.md`

**Categories to include:**

1. **Repository Security:**
   - Branch protection rules (main/master protected)
   - Signed commits configuration (optional/recommended)
   - Secret scanning enabled (with push protection)
   - Vulnerability/Dependabot alerts enabled
   - Security policy (SECURITY.md)

2. **CI/CD Security:**
   - Actions/pipeline permissions (least privilege, explicit `permissions:` block)
   - OIDC for deployments (sample workflow for AWS/Azure/GCP)
   - Artifact signing (Sigstore/cosign integration)
   - Supply chain security (SLSA levels, provenance generation)
   - Workflow approval for forks (prevent malicious PRs)

3. **Code Quality Gates:**
   - Required reviews (minimum reviewers)
   - Required status checks before merge
   - Linting enforcement (pre-commit hooks)
   - No direct commits to main
   - Conventional commits (optional)

4. **Documentation Baseline:**
   - README.md with standard sections
   - CONTRIBUTING.md
   - LICENSE (appropriate for project)
   - SECURITY.md (vulnerability reporting, supported versions, response timeline)
   - CODEOWNERS (optional)

5. **Agent Enablement:**
   - CLAUDE.md (agent onboarding) - cross-reference `skills/skills-first-workflow/references/AGENTS-TEMPLATE.md`
   - AGENTS.md (agent execution rules)
   - Skills bootstrap configuration
   - Pre-commit hooks for agent workflows

6. **Development Standards:**
   - .editorconfig
   - .gitignore (language-appropriate templates)
   - .gitattributes
   - Pre-commit hook configuration
   - CI/CD pipeline templates

Each item must include:

- Description
- Platform-specific CLI commands (GitHub primary, Azure DevOps, GitLab via API)
- Cost indicator (Free/Paid)
- Opt-out instructions

**Note:** GitLab protected branches require API calls via `glab api` (no native CLI commands).

**Deliverable:** `skills/repo-best-practices-bootstrap/references/checklist.md`

### Task 3: Create Platform Detection Reference

Document platform detection logic and CLI availability.

**Files:**

- Create: `skills/repo-best-practices-bootstrap/references/platform-detection.md`

**Content:**

- Git remote URL patterns for each platform
- CLI tool requirements (gh, az repos, glab)
- Detection script (based on existing `issue-driven-delivery` pattern)
- Fallback behavior for unsupported platforms

**Detection script to include:**

```bash
# Detection based on git remote origin
REMOTE_URL=$(git config --get remote.origin.url)

if [[ "$REMOTE_URL" =~ github\.com ]]; then
  PLATFORM="github"
  CLI_TOOL="gh"
elif [[ "$REMOTE_URL" =~ dev\.azure\.com|visualstudio\.com ]]; then
  PLATFORM="azuredevops"
  CLI_TOOL="az repos"
elif [[ "$REMOTE_URL" =~ gitlab\.com|gitlab\. ]]; then
  PLATFORM="gitlab"
  CLI_TOOL="glab"
elif [[ "$REMOTE_URL" =~ bitbucket\.org ]]; then
  PLATFORM="bitbucket"
  CLI_TOOL="manual"  # No CLI support in MVP
fi
```

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
  (includes supported versions, vulnerability reporting, response timeline)
- `skills/repo-best-practices-bootstrap/templates/common/.editorconfig`
- `skills/repo-best-practices-bootstrap/templates/common/.gitattributes`
- `skills/repo-best-practices-bootstrap/templates/common/.pre-commit-config.yaml` (base template, language-agnostic)
- `skills/repo-best-practices-bootstrap/templates/gitignore/node.gitignore`
- `skills/repo-best-practices-bootstrap/templates/gitignore/dotnet.gitignore`
- `skills/repo-best-practices-bootstrap/templates/gitignore/python.gitignore`
- `skills/repo-best-practices-bootstrap/templates/README.md` (usage guide)

**Cross-references:**

- CLAUDE.md.template and AGENTS.md.template should reference patterns from `skills/skills-first-workflow/references/AGENTS-TEMPLATE.md`
- .editorconfig and .gitattributes based on this repository's files

**Deliverable:** Common templates directory with all files

### Task 6: Create GitHub Templates

Create GitHub-specific templates and configurations.

**Files to create:**

- `skills/repo-best-practices-bootstrap/templates/github/branch-protection.json`
  (includes required_reviews, required_signatures, required_status_checks)
- `skills/repo-best-practices-bootstrap/templates/github/ruleset.json` (modern Repository Rulesets for new repos)
- `skills/repo-best-practices-bootstrap/templates/github/CODEOWNERS.template`
- `skills/repo-best-practices-bootstrap/templates/github/workflows/ci.yml` (with explicit `permissions:` block, least privilege)
- `skills/repo-best-practices-bootstrap/templates/github/workflows/oidc-deploy.yml` (sample OIDC for AWS/Azure/GCP)
- `skills/repo-best-practices-bootstrap/templates/github/dependabot.yml`

**Notes:**

- branch-protection.json for classic protection (existing repos)
- ruleset.json for modern Repository Rulesets (recommended for new repos)
- ci.yml must include explicit `permissions:` with minimal scopes
- Azure DevOps and GitLab templates deferred to follow-up issue (GitHub primary for MVP)

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

1. Run platform detection (expect: GitHub)
2. Execute checklist against this repository
3. Document compliant items vs gaps

**Expected compliant items (this repo already has):**

- CLAUDE.md
- AGENTS.md
- .editorconfig
- .gitattributes
- Pre-commit hooks (via lint-staged)

**Expected gaps to identify:**

- Branch protection status (verify configured)
- Secret scanning status
- Dependabot configuration

**Deliverable:** Dogfooding results documented in issue comment with comparison table

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
- [ ] `templates/common/SECURITY.md.template` exists (includes supported versions, response timeline)
- [ ] `templates/common/.editorconfig` exists
- [ ] `templates/common/.gitattributes` exists
- [ ] `templates/common/.pre-commit-config.yaml` exists
- [ ] `templates/gitignore/node.gitignore` exists
- [ ] `templates/gitignore/dotnet.gitignore` exists
- [ ] `templates/gitignore/python.gitignore` exists
- [ ] `templates/README.md` exists with usage instructions
- [ ] CLAUDE.md.template references skills-first-workflow patterns

### Task 6: GitHub Templates

- [ ] `templates/github/branch-protection.json` exists (with required_reviews, required_signatures)
- [ ] `templates/github/ruleset.json` exists (modern Repository Rulesets)
- [ ] `templates/github/CODEOWNERS.template` exists
- [ ] `templates/github/workflows/ci.yml` exists (with explicit `permissions:` block)
- [ ] `templates/github/workflows/oidc-deploy.yml` exists
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

### Rev 1 → Rev 2 (Plan Refinement)

**Security Reviewer Feedback (2026-01-07):** REQUIRES CHANGES

- **C1:** Missing signed commits coverage → Added to Task 2 checklist
- **C2:** Missing supply chain security (SLSA, provenance) → Added to Task 2 CI/CD Security
- **I1:** Workflow approval for forks not addressed → Added to Task 2 CI/CD Security
- **I2:** OIDC configuration lacks specificity → Added oidc-deploy.yml to Task 6
- **I3:** Actions permissions not explicitly verified → Added permissions note to Task 6
- **I4:** Secret scanning enable commands missing → Added to Task 2 checklist
- **I5:** Artifact signing not documented → Added to Task 2 CI/CD Security

**Agent Skill Engineer Feedback (2026-01-07):** APPROVED WITH CHANGES

- **C1:** Missing REQUIRED skills dependency → Added to Task 1 SKILL.md skeleton
- **C2:** Missing Azure DevOps/GitLab templates → Explicitly deferred to Out of Scope
- **I2:** Automation triggers not clearly defined → Added When to Use triggers to Task 1
- **I3:** Opt-out mechanism lacks persistence strategy → Added opt-out persistence to Task 1
- **I4:** Agent enablement templates should reference existing patterns → Added cross-reference to Task 5

**DevOps Engineer Feedback (2026-01-07):** APPROVED WITH CHANGES

- **C1:** glab CLI lacks protected branch commands → Added note to Task 2 about API requirement
- **I1:** Missing modern GitHub Rulesets support → Added ruleset.json to Task 6
- **I7:** Platform detection script not specified → Added script to Task 3
- **I8:** Missing .gitignore and .gitattributes templates → Added to Task 5
- **I9:** Branch protection doesn't cover all security features → Added notes to Task 6
