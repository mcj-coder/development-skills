# Repo Best Practices Bootstrap Tests

## RED: Failure scenarios (expected without skill)

### Scenario A: New repository without security setup

**Context:** User creates a new repository without security best practices.

**Baseline failure to record:**

- Repository created without branch protection
- No SECURITY.md or vulnerability reporting process
- No secret scanning enabled
- No Dependabot alerts configured
- Direct commits to main allowed

**Observed baseline (RED):**

- Repository is vulnerable to accidental secret leaks
- No process for reporting security issues
- No visibility into dependency vulnerabilities
- No code review enforcement

### Scenario B: Existing repository with gaps

**Context:** User has an existing repository that lacks documentation.

**Baseline failure to record:**

- Missing CONTRIBUTING.md
- Missing SECURITY.md
- No CLAUDE.md or AGENTS.md for agent support
- No .editorconfig for consistent formatting

**Observed baseline (RED):**

- Contributors don't know how to contribute
- Security issues have no reporting channel
- Agents cannot be onboarded effectively
- Inconsistent code formatting across team

### Scenario C: CI/CD without security hardening

**Context:** User has CI/CD but without security best practices.

**Baseline failure to record:**

- Workflows without explicit permissions block
- Long-lived secrets used instead of OIDC
- No artifact signing or provenance
- Fork PRs run workflows automatically

**Observed baseline (RED):**

- Supply chain attack surface is large
- Secrets could be exfiltrated by malicious dependencies
- Build artifacts cannot be verified
- Malicious fork PRs could steal secrets

## GREEN: Expected behaviour with skill

### Platform Detection

- [ ] Skill detects GitHub from remote URL pattern `github.com`
- [ ] Skill detects Azure DevOps from `dev.azure.com` or `visualstudio.com`
- [ ] Skill detects GitLab from `gitlab.com` or `gitlab.`
- [ ] Skill detects Bitbucket from `bitbucket.org`
- [ ] Skill reports "unknown" for unrecognized platforms
- [ ] Skill identifies appropriate CLI tool for each platform

### Greenfield Repository Setup

- [ ] Skill prompts for platform detection before starting
- [ ] Skill checks CLI authentication status
- [ ] Skill presents complete checklist for new repository
- [ ] Skill offers to configure each feature
- [ ] Skill creates documentation files from templates
- [ ] Skill enables branch protection via platform CLI
- [ ] Skill enables secret scanning (where available)
- [ ] Skill configures Dependabot/vulnerability alerts
- [ ] Skill commits configuration changes with descriptive messages

### Brownfield Repository Audit

- [ ] Skill detects existing configurations before suggesting changes
- [ ] Skill reports compliant items separately from gaps
- [ ] Skill does not overwrite existing SECURITY.md or CONTRIBUTING.md
- [ ] Skill offers to fill gaps without disrupting existing setup
- [ ] Skill generates compliance report with current state

### Opt-Out Mechanism

- [ ] Skill reads `.repo-bootstrap.yml` if present
- [ ] Skill respects category-level opt-outs
- [ ] Skill respects feature-level opt-outs
- [ ] Skill does not report opted-out items as gaps
- [ ] Skill documents opt-out reasons in comments
- [ ] Skill creates `.repo-bootstrap.yml` when user opts out

### Cost Awareness

- [ ] Skill flags paid features with cost indicator
- [ ] Skill offers free alternatives for paid features
- [ ] Skill allows opt-out of paid features
- [ ] Skill does not configure paid features without confirmation

### Template Usage

- [ ] Skill uses templates from `templates/` directory
- [ ] Skill replaces placeholders in templates
- [ ] Skill creates files in correct locations
- [ ] Skill respects existing files (no overwrite without confirmation)

### Verification

- [ ] Skill re-runs checklist after configuration to verify
- [ ] Skill reports final compliance status
- [ ] Skill identifies items that could not be configured automatically
- [ ] Skill follows verification-before-completion skill requirement

## RED: Error Handling Scenarios

### Scenario: Missing Prerequisites

**Context:** Required CLI tool is not installed.

**Expected behaviour:**

- [ ] Skill detects missing CLI tool
- [ ] Skill reports which tool is needed and how to install
- [ ] Skill offers to continue with manual-only items
- [ ] Skill does not crash or hang

### Scenario: Authentication Failure

**Context:** CLI tool is installed but not authenticated.

**Expected behaviour:**

- [ ] Skill detects authentication failure
- [ ] Skill provides authentication instructions
- [ ] Skill does not attempt API calls without auth
- [ ] Skill offers to continue with file-only items

### Scenario: Unsupported Platform

**Context:** Repository is on unsupported platform (e.g., self-hosted Git).

**Expected behaviour:**

- [ ] Skill reports platform as "unknown"
- [ ] Skill suggests manual configuration
- [ ] Skill offers to create documentation files only
- [ ] Skill does not attempt platform-specific CLI commands

### Scenario: Insufficient Permissions

**Context:** User has read access but not admin access.

**Expected behaviour:**

- [ ] Skill detects permission error from CLI
- [ ] Skill reports which features require admin access
- [ ] Skill offers to configure user-level items only
- [ ] Skill does not fail completely

## Verification Checklist

### Skill Structure

- [ ] `SKILL.md` exists with valid frontmatter
- [ ] `SKILL.md` includes REQUIRED dependency on verification-before-completion
- [ ] `references/checklist.md` covers all 6 categories
- [ ] `references/platform-detection.md` documents all platforms
- [ ] `references/cost-considerations.md` identifies paid features
- [ ] Templates exist for all documented features

### Cross-References

- [ ] CLAUDE.md template references skills-first-workflow patterns
- [ ] AGENTS.md template references skills-first-workflow patterns
- [ ] Skill SKILL.md links to all reference files
- [ ] Templates README explains usage

### Platform Coverage

- [ ] GitHub commands tested and documented
- [ ] Azure DevOps commands documented (CLI limitations noted)
- [ ] GitLab commands documented (API requirements noted)
- [ ] Bitbucket documented as manual-only
