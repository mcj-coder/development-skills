---
name: repo-best-practices-bootstrap
description: |
  Use when setting up new repositories or auditing existing ones for security
  and best practice compliance. Covers branch protection, secret scanning, CI/CD security,
  documentation, and agent enablement.
---

# Repo Best Practices Bootstrap

## Overview

Ensure repositories have appropriate security and best practice features configured and enabled.
Applicable to both greenfield (new repository) and brownfield (existing repository) projects.

**REQUIRED:** superpowers:verification-before-completion

**Categories covered:**

1. Repository Security - Branch protection, signed commits, secret scanning, vulnerability alerts
2. CI/CD Security - Actions permissions, OIDC deployments, artifact signing, supply chain security
3. Code Quality Gates - Required reviews, status checks, linting, no direct commits
4. Documentation Baseline - README, CONTRIBUTING, LICENSE, SECURITY
5. Agent Enablement - CLAUDE.md, AGENTS.md, skills bootstrap, pre-commit hooks
6. Development Standards - .editorconfig, .gitignore, .gitattributes, pre-commit config
7. Project Management - Project board linking, kanban/sprint workflow configuration
8. Standard Tooling - husky, prettier, markdownlint, lint-staged, local secret scanning

## When to Use

- Setting up new repository (greenfield)
- Auditing existing repository (brownfield)
- User asks to "bootstrap", "secure", or "audit" a repository
- Compliance check requested
- Onboarding a repository to this skill library

## Prerequisites

- Git CLI installed and authenticated
- Platform CLI installed and authenticated:
  - GitHub: `gh` CLI
  - Azure DevOps: `az repos` CLI
  - GitLab: `glab` CLI
- Write access to the target repository

## Platform Detection

Detect the platform from the git remote URL:

```bash
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

See [Platform Detection](references/platform-detection.md) for full detection logic and CLI requirements.

## Core Workflow

### Step 1: Platform Detection

1. Run platform detection script
2. Verify CLI tool is installed and authenticated
3. If Bitbucket, inform user that manual configuration is required

### Step 2: Load Opt-Outs

1. Check for `.repo-bootstrap.yml` in repository root
2. Parse opt-out categories and features
3. Skip items that are opted out

### Step 3: Run Checklist

For each category not opted out:

1. Check current state using platform CLI
2. Report compliant items (already configured)
3. Report gaps (not configured)
4. Offer to configure gaps

See [Checklist](references/checklist.md) for the complete checklist with platform-specific commands.

### Step 4: Configure Gaps

For each gap the user wants to configure:

1. Use platform CLI to enable/configure the feature
2. Create documentation files from templates if needed
3. Commit changes with descriptive message

See templates in `templates/` directory for documentation and configuration files.

### Step 5: Verify Configuration

1. Re-run checklist to verify all selected items are now compliant
2. Document any items that could not be configured automatically
3. Report final compliance status

## Opt-Out Mechanism

Users can opt out of specific features or entire categories. Opt-outs are respected
during checklist execution and do not generate gaps.

**Category opt-out:** Skip all features in a category
**Feature opt-out:** Skip a specific feature

When a feature is opted out, document the reason in the opt-out file.

## Opt-Out Persistence

Opt-out decisions are stored in `.repo-bootstrap.yml` in the target repository:

```yaml
# .repo-bootstrap.yml
# Repository bootstrap configuration
# See: skills/repo-best-practices-bootstrap/SKILL.md

opt_out:
  categories:
    - ci-cd-security # Opt out entire category (reason: using external CI system)
  features:
    - signed-commits # Opt out specific feature (reason: team not using GPG)
    - artifact-signing # Opt out specific feature (reason: not publishing artifacts)
```

Commit this file to the repository to persist opt-out decisions across sessions.

## Cost Considerations

Some features require paid plans. The checklist indicates cost for each feature.

See [Cost Considerations](references/cost-considerations.md) for:

- Features requiring paid plans
- Free alternatives for each paid feature
- Platform-specific pricing notes

## See Also

- [Checklist](references/checklist.md) - Complete checklist with platform-specific commands
- [Platform Detection](references/platform-detection.md) - Detection logic and CLI requirements
- [Cost Considerations](references/cost-considerations.md) - Paid features and free alternatives
- [skills-first-workflow AGENTS Template](../skills-first-workflow/references/AGENTS-TEMPLATE.md) -
  Template for AGENTS.md file
