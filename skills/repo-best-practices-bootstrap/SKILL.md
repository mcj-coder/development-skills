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

### Step 2: Load or Initialize Configuration

1. Check for `.repo-bootstrap.yml` in repository root
2. **If file exists:** Parse opt-out categories and features, skip opted-out items
3. **If file does not exist (new repo):**
   - Inform user: "No bootstrap configuration found. I'll guide you through setup."
   - Create `.repo-bootstrap.yml` with empty opt-outs
   - Proceed to guided configuration (Step 3)

### Step 3: Guided Configuration

**MANDATORY:** Walk through ALL 8 categories. Categories cannot be skipped.
Only individual features within a category can be opted out.

For each category, **interactively guide the user** through configuration:

1. **Present the category** and explain its purpose
2. **Check current state** using platform CLI
3. **For each unconfigured feature:**
   - Explain what it does and why it matters
   - **Ask user:** "Would you like to configure this? (Yes/No/Skip)"
   - If Yes: Proceed with configuration (Step 4)
   - If No/Skip: Record opt-out with reason (Step 3a)
4. **For paid features without free tier:**
   - Present free/open-source alternatives (see Cost Considerations)
   - Offer to configure the alternative instead

See [Checklist](references/checklist.md) for the complete checklist with platform-specific commands.

#### Step 3a: Record Opt-Out Decision

When a user declines a feature:

1. **Ask for reason:** "Why are you skipping this? (brief explanation)"
2. **Record in `.repo-bootstrap.yml`:**

   ```yaml
   opt_out:
     features:
       - feature-name # Reason: user explanation
   ```

3. **Create ADR if significant:** For security-related opt-outs, create an Architecture
   Decision Record in `docs/decisions/`:

   ```markdown
   # ADR-NNN: Skip [Feature Name]

   ## Status

   Accepted

   ## Context

   [Why this decision was made]

   ## Decision

   We will not implement [feature] because [reason].

   ## Consequences

   [What this means for the project]
   ```

### Step 4: Configure Features

For each feature the user wants to configure:

1. **Guide through options:** Present configuration choices with recommendations
2. **Use platform CLI** to enable/configure the feature
3. **Create files from templates** and prompt user to customize:
   - CODEOWNERS: "Who should be listed as code owners?"
   - Branch protection: "What status checks should be required?"
   - Dependabot: "Which package ecosystems do you use?"
4. **Commit changes** with descriptive message referencing the feature

See templates in `templates/` directory for documentation and configuration files.

### Step 5: Generate CI/CD Workflow

**IMPORTANT:** Pre-commit hooks can be bypassed. CI/CD enforcement is mandatory.

1. **Mirror pre-commit rules in CI/CD:**
   - If lint-staged configured → Add linting job to CI
   - If prettier configured → Add format check to CI
   - If secretlint configured → Add secret scanning to CI
2. **Generate workflow file** from template (`.github/workflows/ci.yml`)
3. **Configure branch protection** to require CI checks pass before merge
4. **Verify enforcement:** Ensure same rules apply locally and in CI

See [CI/CD Templates](templates/github/workflows/) for workflow templates.

### Step 6: Verify Configuration

1. Re-run checklist to verify all selected items are now compliant
2. Document any items that could not be configured automatically
3. **Run CI workflow** to verify it passes
4. Report final compliance status

## Opt-Out Mechanism

Users can opt out of specific features within a category. Opt-outs are respected
during checklist execution and do not generate gaps.

**IMPORTANT:** Categories cannot be skipped. All 8 categories must be presented
to the user. Only individual features can be opted out.

**Feature opt-out:** Skip a specific feature (with documented reason)

When a feature is opted out, document the reason via ADR (preferred) or opt-out file.

## Opt-Out Persistence

**Preferred:** Use ADRs in `docs/decisions/` to document opt-out decisions with full context.

**Alternative:** If ADRs are not used, store opt-outs in `.repo-bootstrap.yml`:

```yaml
# .repo-bootstrap.yml
# Repository bootstrap configuration
# See: skills/repo-best-practices-bootstrap/SKILL.md

opt_out:
  features:
    - signed-commits # Reason: team not using GPG keys
    - artifact-signing # Reason: not publishing artifacts
```

Commit the opt-out documentation to persist decisions across sessions.

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
