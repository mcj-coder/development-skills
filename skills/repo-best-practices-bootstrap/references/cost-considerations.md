# Cost Considerations

This document identifies features that may require paid plans and provides
free alternatives where available.

## Cost Summary by Feature

| Feature             | GitHub Free | GitHub Paid | Azure DevOps | GitLab Free | GitLab Paid |
| ------------------- | ----------- | ----------- | ------------ | ----------- | ----------- |
| Branch Protection   | Yes         | Yes         | Yes          | Yes         | Yes         |
| Required Reviews    | Yes\*       | Yes         | Yes          | Yes\*       | Yes         |
| Secret Scanning     | Public only | Yes (GHAS)  | Defender     | Yes         | Yes         |
| Push Protection     | Public only | Yes (GHAS)  | N/A          | Yes         | Yes         |
| Dependabot Alerts   | Yes         | Yes         | Extensions   | Yes         | Yes         |
| CODEOWNERS          | Yes         | Yes         | Yes          | Premium     | Premium     |
| Multiple Approvers  | 1 max       | Unlimited   | Yes          | 1 max       | Unlimited   |
| Status Checks       | Yes         | Yes         | Yes          | Yes         | Yes         |
| Signed Commits Req. | Yes         | Yes         | N/A          | Premium     | Premium     |
| Repository Rulesets | Yes         | Yes         | N/A          | N/A         | N/A         |

\*Limited features on free tier

## Paid Features by Platform

### GitHub

**GitHub Advanced Security (GHAS) - Required for:**

- Secret scanning on private repositories
- Secret push protection on private repositories
- Code scanning with CodeQL (advanced features)
- Security overview dashboard

**Pricing:** Per-committer pricing, enterprise plans

**Free Alternative:**

- Use third-party secret scanning (Gitleaks, detect-secrets)
- Pre-commit hooks with secret detection
- Public repositories get these features for free

**GitHub Team/Enterprise - Required for:**

- More than 1 required reviewer
- Draft pull requests
- Protected branches on private repos (some features)
- CODEOWNERS enforcement

### Azure DevOps

**Azure DevOps Services (paid tier):**

- Advanced branch policies
- Multiple approval gates
- Deployment gates

**Microsoft Defender for DevOps:**

- Secret scanning
- Vulnerability scanning
- Container security

**Pricing:** Per-user licensing for advanced features

**Free Alternative:**

- Basic branch policies available on free tier
- Use GitHub Actions for CI/CD instead
- Third-party security scanning tools

### GitLab

**GitLab Premium - Required for:**

- Multiple merge request approvers
- Code owners enforcement
- Push rules (signed commits)
- Protected environments
- Merge request approval rules

**GitLab Ultimate - Required for:**

- Security dashboards
- Dependency scanning (advanced)
- License compliance
- DAST (Dynamic Application Security Testing)

**Pricing:** Per-user per-month

**Free Alternative:**

- Basic features available on free tier
- Use CI/CD templates for security scanning
- Third-party tools for advanced features

## Free Alternatives Matrix

| Paid Feature              | Free Alternative                                            |
| ------------------------- | ----------------------------------------------------------- |
| Secret scanning (private) | Gitleaks, detect-secrets, truffleHog (pre-commit hooks)     |
| Multiple approvers        | Social contract (document in CONTRIBUTING.md)               |
| Code owners enforcement   | Document ownership in CODEOWNERS (not enforced)             |
| Advanced vulnerability    | Dependabot (free), Snyk (free tier), OWASP Dependency-Check |
| Signed commits (enforced) | Document policy, verify in CI/CD (not blocking)             |
| Security dashboard        | Manual reporting, third-party dashboards                    |

## Decision Matrix

Use this matrix to decide whether to use paid features:

| Factor                      | Use Paid           | Use Free Alternative |
| --------------------------- | ------------------ | -------------------- |
| Private repository          | Consider GHAS      | Pre-commit hooks     |
| Team size > 5               | Consider Team tier | Document processes   |
| Regulatory requirements     | Likely needed      | May not be compliant |
| Open source project         | Often free anyway  | N/A                  |
| Security-critical project   | Strongly consider  | Risk assessment      |
| Cost-sensitive organization | Evaluate ROI       | Start with free      |

## Recommendations by Scenario

### Open Source Project

Most features are free for public repositories:

- Use GitHub's free secret scanning
- Use Dependabot for vulnerability alerts
- Branch protection with 1 reviewer (free)
- All documentation features (free)

### Small Team (< 5 developers)

Free tier is usually sufficient:

- Single required reviewer (free)
- Basic branch protection (free)
- Pre-commit hooks for linting (free)
- Manual code review ownership (free)

### Enterprise/Regulated Environment

Paid features often required:

- GHAS for secret scanning
- Multiple required reviewers
- Enforced CODEOWNERS
- Security dashboards for compliance

### Cost-Conscious Startup

Mix of free and essential paid:

- Free tier for most features
- Pre-commit hooks for secret detection
- Document policies in CONTRIBUTING.md
- Evaluate paid features quarterly

## Implementation Notes

When configuring features:

1. **Check current plan:** `gh api user` (check plan field)
2. **Start with free features:** Configure all free features first
3. **Document gaps:** Note which paid features are skipped
4. **Review quarterly:** Re-evaluate as project grows

## Opt-Out for Cost Reasons

If opting out of a feature due to cost, document in `.repo-bootstrap.yml`:

```yaml
opt_out:
  features:
    - secret-scanning # Reason: Private repo, using pre-commit instead
    - multiple-approvers # Reason: Team size is 3, single reviewer sufficient
```
