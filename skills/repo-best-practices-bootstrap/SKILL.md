---
name: repo-best-practices-bootstrap
description: |
  Use when setting up new repositories or auditing existing ones for security
  and best practice compliance. Covers branch protection, secret scanning, CI/CD security,
  documentation, and agent enablement.
metadata:
  type: Platform
  priority: P0
---

# Repo Best Practices Bootstrap

## Overview

Ensure repositories have appropriate security and best practice features configured and enabled.
Applicable to both greenfield (new repository) and brownfield (existing repository) projects.

**REQUIRED:** superpowers:verification-before-completion

## Bootstrapping Skills Decision Matrix

Use this matrix to select the appropriate bootstrapping skill:

| If You Need To...                                            | Use This Skill                           |
| ------------------------------------------------------------ | ---------------------------------------- |
| Start a new project from scratch                             | greenfield-baseline                      |
| Add/audit quality tooling (linting, tests, SAST)             | automated-standards-enforcement          |
| Add/audit repo security (branch protection, secret scanning) | **repo-best-practices-bootstrap** (this) |

### Skill Scope Comparison

| Aspect            | greenfield-baseline          | automated-standards-enforcement | repo-best-practices-bootstrap |
| ----------------- | ---------------------------- | ------------------------------- | ----------------------------- |
| **Primary Focus** | Project foundation           | Quality tooling                 | Repo security/compliance      |
| **Project State** | New (no existing code)       | New or existing                 | New or existing               |
| **Outputs**       | Repo structure, CI/CD, docs  | Linting, tests, SAST config     | Branch rules, secrets config  |
| **Triggers**      | Entry point for new projects | Auto-triggered or standalone    | Invoke directly               |

### Invocation Context

- **Greenfield projects**: Invoke after greenfield-baseline establishes structure
- **Brownfield projects**: Invoke directly for security audit
- **Compliance checks**: Invoke directly for audit against checklist

### Do NOT Use This Skill When

- Starting a brand new project without structure (use greenfield-baseline first)
- Only need quality tooling (use automated-standards-enforcement)
- Repository security already configured and passing audit

**Categories covered:**

1. Repository Security - Branch protection, signed commits, secret scanning, vulnerability alerts
2. CI/CD Security - Actions permissions, OIDC deployments, artifact signing, supply chain security
3. Code Quality Gates - Required reviews, status checks, linting, no direct commits
4. Documentation Baseline - README, CONTRIBUTING, LICENSE, SECURITY
5. Agent Enablement - CLAUDE.md, AGENTS.md, skills bootstrap, pre-commit hooks
6. Development Standards - .editorconfig, .gitignore, .gitattributes, pre-commit config
7. Project Management - Project board linking, kanban/sprint workflow configuration
8. Standard Tooling - husky, prettier, markdownlint, lint-staged, local secret scanning
9. Multi-Identity Workflow (Optional) - Persona-switching for role-based commits and GPG signing

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

#### Signed Commits (Special Handling)

**WARNING:** Do NOT enable signed commits in branch protection until setup is verified.

When user selects "Yes" to signed commits, guide them through setup interactively:

##### Step A: Check current GPG setup

```bash
# Check if GPG is installed
gpg --version

# Check for existing keys
gpg --list-secret-keys --keyid-format=long
```

##### Step B: Guide through setup if needed

Ask: "Do you have a GPG key configured for signing commits?"

- **If No:** Guide through playbook steps:
  1. Generate key: `gpg --full-generate-key` (RSA 4096, matching email)
  2. Get key ID: `gpg --list-secret-keys --keyid-format=long`
  3. Export public key: `gpg --armor --export KEY_ID`
  4. Add to platform (GitHub Settings > SSH and GPG keys)
  5. Configure git:

     ```bash
     git config --global user.signingkey KEY_ID
     git config --global commit.gpgsign true
     ```

- **If Yes:** Verify configuration:

  ```bash
  git config --get user.signingkey
  git config --get commit.gpgsign
  ```

##### Step C: Add git hook verification

Add blocking check to `.husky/pre-commit`:

```bash
# Require GPG commit signing to be configured
if [ "$(git config --get commit.gpgsign)" != "true" ]; then
  echo ""
  echo "❌ ERROR: GPG commit signing is not enabled"
  echo "   All commits must be cryptographically signed."
  echo ""
  echo "   To enable signed commits:"
  echo "   1. Follow the setup guide: docs/playbooks/enable-signed-commits.md"
  echo "   2. Configure git: git config --global commit.gpgsign true"
  echo "   3. Ensure your GPG key is added to GitHub"
  echo ""
  echo "ℹ️  To bypass (not recommended): git commit --no-verify"
  exit 1
fi
```

Create `.husky/pre-push` to detect commits with invalid or missing signatures:

```bash
# Check for unsigned or invalid commits before pushing
# Valid signatures: G (Good), U (Good but untrusted)
# Invalid: N (None), B (Bad), E (Error), R (Revoked), X/Y (Expired)

REMOTE="$1"
URL="$2"

# Detect the default branch dynamically
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$DEFAULT_BRANCH" ]; then
  DEFAULT_BRANCH="main"
fi

while read local_ref local_sha remote_ref remote_sha; do
  # Skip branch deletions and tag pushes
  if [ "$local_sha" = "0000000000000000000000000000000000000000" ]; then
    continue
  fi
  if echo "$local_ref" | grep -q '^refs/tags/'; then
    continue
  fi

  if [ "$remote_sha" = "0000000000000000000000000000000000000000" ]; then
    # New branch - check commits since divergence from default branch
    merge_base=$(git merge-base "origin/$DEFAULT_BRANCH" "$local_sha" 2>/dev/null)
    if [ -n "$merge_base" ]; then
      range="$merge_base..$local_sha"
    else
      range="$local_sha~50..$local_sha"
    fi
  else
    range="$remote_sha..$local_sha"
  fi

  # Check for any non-valid signatures
  invalid=$(git log --format="%H %G?" "$range" 2>/dev/null | grep -vE " [GU]$" | cut -d' ' -f1)

  if [ -n "$invalid" ]; then
    echo ""
    echo "❌ ERROR: Found commits with invalid or missing signatures"
    echo ""
    echo "To fix, rebase and re-sign your commits:"
    echo ""
    echo "  git rebase origin/$DEFAULT_BRANCH --exec 'git commit --amend --no-edit -S'"
    echo "  git push --force-with-lease"
    echo ""
    echo "See: docs/playbooks/enable-signed-commits.md"
    echo ""
    echo "ℹ️  To bypass (not recommended): git push --no-verify"
    exit 1
  fi
done

exit 0
```

##### Step D: Test before enabling branch protection

```bash
# Create test commit
git commit --allow-empty -m "test: verify GPG signing"

# Verify signature
git log --show-signature -1
```

##### Step E: Enable branch protection only after test passes

```bash
# GitHub
gh api repos/OWNER/REPO/branches/main/protection/required_signatures -X POST
```

Generate `docs/playbooks/enable-signed-commits.md` from template for future reference.

See [Signed Commits Playbook Template](templates/playbooks/enable-signed-commits.md).

### Step 4a: Persona-Switching Integration (Optional)

After core configuration, offer multi-identity workflow setup:

#### Detection

Check if persona-switching is already configured:

```bash
# Check for existing playbook
if [ -f "docs/playbooks/persona-switching.md" ]; then
  echo "Persona-switching already configured - skipping"
  # Report as "already configured" in summary
else
  # Proceed to prompt
fi
```

#### Prompt

Ask user: **"Enable multi-identity workflow?"** (Y/n)

- **Default:** No (persona-switching is optional)
- **If Yes:** Chain to persona-switching skill setup flow
- **If No:** Record opt-out and continue

#### If Enabled

Chain to `persona-switching` skill setup flow:

1. **Role Discovery** - Parse existing `docs/roles/*.md` or use defaults
2. **Security Profile Configuration** - Map personas to GitHub accounts
3. **Generate Artifacts:**
   - `docs/playbooks/persona-switching.md` - Repository playbook
   - `~/.config/<repo-name>/persona-config.sh` - User's shell config
4. **Verify Setup** - Test `use_persona` and `show_persona` commands

See [persona-switching skill](../persona-switching/SKILL.md) for full setup flow.

#### If Declined

Record opt-out in `.repo-bootstrap.yml`:

```yaml
opt_out:
  features:
    - persona-switching # optional - user declined
```

No justification required (optional feature).

#### Continue Bootstrap

After persona-switching setup completes (or is declined), continue with Step 5.

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

## Minimum Viable Bootstrap Profile

For quick project setup, use this minimal profile covering essential security and quality:

### MVP Checklist

| Category | Feature                  | Required | Effort |
| -------- | ------------------------ | -------- | ------ |
| Security | Branch protection (main) | Yes      | 2 min  |
| Security | Secret scanning          | Yes      | 1 min  |
| Quality  | README.md                | Yes      | 5 min  |
| Quality  | .gitignore               | Yes      | 1 min  |
| Quality  | Pre-commit hooks (lint)  | Yes      | 5 min  |
| CI/CD    | Basic CI workflow        | Yes      | 10 min |

Total MVP time: approximately 25 minutes.

### MVP Configuration Commands

```bash
#!/bin/bash
# mvp-bootstrap.sh - Minimum viable bootstrap

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"

echo "=== MVP Bootstrap for $REPO ==="

# 1. Branch protection
echo "Configuring branch protection..."
gh api repos/$REPO/branches/main/protection -X PUT \
  -f required_status_checks='{"strict":true,"contexts":[]}' \
  -f enforce_admins=false \
  -f required_pull_request_reviews='{"required_approving_review_count":1}' \
  -f restrictions=null

# 2. Secret scanning (free for public repos, requires GHAS for private)
echo "Enabling secret scanning..."
gh api repos/$REPO -X PATCH -f security_and_analysis='{"secret_scanning":{"status":"enabled"}}'

# 3. Create README if missing
if [ ! -f README.md ]; then
  echo "Creating README.md..."
  cat > README.md << 'READMEEOF'
# Project Name

Brief description of this project.

## Getting Started

Installation: npm install
Development: npm run dev
Testing: npm test

## Contributing

See CONTRIBUTING.md for contribution guidelines.
READMEEOF
fi

# 4. Create .gitignore if missing
if [ ! -f .gitignore ]; then
  echo "Creating .gitignore..."
  curl -sL https://www.toptal.com/developers/gitignore/api/node,python,dotnet > .gitignore
fi

# 5. Setup pre-commit hooks
echo "Setting up pre-commit hooks..."
npm install --save-dev husky lint-staged
npx husky init
echo 'npx lint-staged' > .husky/pre-commit

# 6. Create basic CI workflow
echo "Creating CI workflow..."
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'CIEOF'
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test
      - run: npm run lint
CIEOF

echo "=== MVP Bootstrap Complete ==="
```

## Automated Feature Checks

### Verification Script

```bash
#!/bin/bash
# check-bootstrap.sh - Verify bootstrap configuration

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
ERRORS=0
WARNINGS=0

echo "=== Bootstrap Verification for $REPO ==="
echo ""

# Security checks
echo "## Security"

# Branch protection
if gh api "repos/$REPO/branches/main/protection" &>/dev/null; then
  echo "✓ Branch protection enabled"
else
  echo "✗ Branch protection NOT configured"
  ((ERRORS++))
fi

# Secret scanning
SECRET_SCAN=$(gh api "repos/$REPO" --jq '.security_and_analysis.secret_scanning.status // "disabled"')
if [ "$SECRET_SCAN" = "enabled" ]; then
  echo "✓ Secret scanning enabled"
else
  echo "✗ Secret scanning disabled"
  ((ERRORS++))
fi

# Documentation checks
echo ""
echo "## Documentation"

for file in README.md CONTRIBUTING.md LICENSE; do
  if [ -f "$file" ]; then
    echo "✓ $file exists"
  else
    echo "⚠ $file missing"
    ((WARNINGS++))
  fi
done

# Quality checks
echo ""
echo "## Quality Gates"

# Pre-commit hooks
if [ -d ".husky" ] && [ -f ".husky/pre-commit" ]; then
  echo "✓ Pre-commit hooks configured"
else
  echo "✗ Pre-commit hooks NOT configured"
  ((ERRORS++))
fi

# CI workflow
if [ -f ".github/workflows/ci.yml" ] || [ -f ".github/workflows/ci.yaml" ]; then
  echo "✓ CI workflow exists"
else
  echo "✗ CI workflow missing"
  ((ERRORS++))
fi

# .gitignore
if [ -f ".gitignore" ]; then
  echo "✓ .gitignore exists"
else
  echo "⚠ .gitignore missing"
  ((WARNINGS++))
fi

# Summary
echo ""
echo "=== Summary ==="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [ $ERRORS -eq 0 ]; then
  echo "✓ Bootstrap verification passed"
  exit 0
else
  echo "✗ Bootstrap verification failed"
  exit 1
fi
```

### CI Integration

```yaml
# .github/workflows/bootstrap-check.yml
name: Bootstrap Compliance

on:
  push:
    branches: [main]
  schedule:
    - cron: "0 0 * * 1" # Weekly Monday check

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check required files
        run: |
          MISSING=""
          for file in README.md .gitignore; do
            [ ! -f "$file" ] && MISSING="$MISSING $file"
          done
          if [ -n "$MISSING" ]; then
            echo "::error::Missing required files:$MISSING"
            exit 1
          fi

      - name: Check pre-commit hooks
        run: |
          if [ ! -d ".husky" ]; then
            echo "::warning::Pre-commit hooks not configured"
          fi

      - name: Check branch protection
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          if ! gh api repos/${{ github.repository }}/branches/main/protection &>/dev/null; then
            echo "::warning::Branch protection not configured"
          fi
```

### Quick Verification Commands

```bash
# Check all bootstrap features at once
./scripts/check-bootstrap.sh

# Check specific features
gh api repos/OWNER/REPO/branches/main/protection --jq '.required_pull_request_reviews'
gh api repos/OWNER/REPO --jq '.security_and_analysis'

# Verify hooks are executable
ls -la .husky/

# Test CI workflow syntax
gh workflow view ci.yml

# List configured workflows
gh workflow list
```
