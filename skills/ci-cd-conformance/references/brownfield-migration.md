# Brownfield Migration Guide

## Migration Strategy Overview

Transitioning existing pipelines to full CI/CD conformance requires an incremental
approach to avoid disrupting working deployments.

## Phase 1: Assessment (Non-Breaking)

### Current State Analysis

```bash
# GitHub
gh api repos/{owner}/{repo} | jq '{
  has_branch_protection: .branch_protection_rules,
  vulnerability_alerts: .vulnerability_alerts_enabled,
  secret_scanning: .secret_scanning_enabled
}'

# Check existing workflows
ls .github/workflows/

# Azure DevOps
az repos policy list --repository-id {id} --branch main
az devops service-endpoint list --project {project}

# GitLab
glab api projects/{id} | jq '.security_and_compliance_enabled'
```

### Gap Analysis Checklist

| Requirement            | Current State | Gap |
| ---------------------- | ------------- | --- |
| Quality gates in CI    |               |     |
| Tag-based deployments  |               |     |
| Dependency scanning    |               |     |
| Secret detection       |               |     |
| Branch protection      |               |     |
| OIDC/managed identity  |               |     |
| Pipeline documentation |               |     |

## Phase 2: Add Quality Gates (Parallel)

Add quality gates without blocking existing deployment flow.

### Strategy: Parallel Workflows

```yaml
# .github/workflows/quality-gates.yml (NEW - does not block)
name: Quality Gates
on: pull_request

jobs:
  quality:
    runs-on: ubuntu-latest
    continue-on-error: true # Initially non-blocking
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run lint
      - run: npm test -- --coverage
      - run: npm audit --audit-level=high
```

### Make Gates Blocking (After Team Adapts)

```yaml
# After 1-2 weeks, remove continue-on-error
jobs:
  quality:
    runs-on: ubuntu-latest
    # continue-on-error: true  # REMOVED - now blocking
```

## Phase 3: Enable Platform Security

### GitHub Security Features

```bash
# Enable secret scanning (does not break anything)
gh api repos/{owner}/{repo}/vulnerability-alerts -X PUT

# Enable Dependabot (creates PRs, does not break anything)
# Add .github/dependabot.yml

# Enable CodeQL (runs on PR, does not block initially)
gh api repos/{owner}/{repo}/code-scanning/default-setup -X PATCH -f state=configured
```

### Branch Protection (Carefully)

```bash
# Start with require PR only (least disruptive)
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -f required_pull_request_reviews[required_approving_review_count]=1

# Later: require status checks
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -f required_status_checks[strict]=true \
  -f required_status_checks[contexts][]=quality
```

## Phase 4: Transition to Immutable Releases

### Strategy: Dual Triggers (Temporary)

Allow both branch-based and tag-based deployments during transition.

```yaml
# Existing: branch trigger (keep temporarily)
on:
  push:
    branches: [main]
    tags: ["v*"] # ADD tag trigger


# Document: "Tag deployments preferred, branch deployments deprecated"
```

### Communication Plan

1. Week 1-2: Document new tag-based process, train team
2. Week 3-4: Encourage tag deployments, track adoption
3. Week 5+: Remove branch trigger, tags only

### Tag Creation Process

```bash
# Create release tag
git checkout main
git pull origin main
git tag -a v1.2.3 -m "Release v1.2.3: Feature X, Bugfix Y"
git push origin v1.2.3

# Verify deployment triggered
gh run list --workflow cd.yml
```

## Phase 5: Eliminate Long-Lived Secrets

### Audit Current Secrets

```bash
# GitHub
gh secret list

# Identify long-lived credentials
# AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY (BAD)
# AZURE_CREDENTIALS (BAD - JSON with secret)
# AZURE_CLIENT_ID, AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID (GOOD - OIDC)
```

### Migration to OIDC

1. Create OIDC trust relationship in cloud provider
2. Update workflow to use OIDC
3. Test in non-production environment
4. Remove old secrets after verification

## Phase 6: Documentation

### Create Pipeline Documentation

```markdown
# docs/ci-cd-pipeline.md

## Pipeline Overview

**Provider:** GitHub Actions
**Migration Date:** YYYY-MM-DD

## Quality Gates

- Unit tests: Required, 80% coverage minimum
- Linting: Required, zero errors
- Security scan: Required, no high/critical vulnerabilities

## Release Process

1. Create PR with changes
2. CI runs quality gates (blocking)
3. PR approved and merged
4. Create tag: `git tag vX.Y.Z && git push origin vX.Y.Z`
5. CD deploys to staging automatically
6. Manual approval for production
7. CD deploys to production

## Migration Notes

- Branch-based deployments: Deprecated YYYY-MM-DD
- OIDC migration: Completed YYYY-MM-DD
- Quality gates blocking: Enabled YYYY-MM-DD
```

## Rollback Plan

If migration causes issues:

### Revert Quality Gates to Non-Blocking

```yaml
jobs:
  quality:
    continue-on-error: true # Temporarily revert
```

### Re-enable Branch Deployments

```yaml
on:
  push:
    branches: [main] # Re-enable temporarily
    tags: ["v*"]
```

### Document Issues

```markdown
# docs/known-issues.md

## CI/CD Migration Issues

### Issue: Quality gate failures blocking deployment

- **Date:** YYYY-MM-DD
- **Impact:** Team unable to deploy
- **Mitigation:** Reverted to non-blocking
- **Root cause:** Test flakiness in X
- **Resolution:** Fix flaky tests, re-enable blocking
```

## Success Criteria

Migration complete when:

- [ ] Quality gates blocking in CI
- [ ] Tag-based deployments only
- [ ] No long-lived secrets (OIDC configured)
- [ ] Platform security enabled (scanning, branch protection)
- [ ] Pipeline documented
- [ ] Team trained on new process
- [ ] Branch-based deploys removed
- [ ] No rollback needed for 2 weeks
