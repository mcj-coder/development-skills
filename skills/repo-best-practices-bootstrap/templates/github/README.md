# GitHub Templates

API-ready templates for GitHub repository configuration.

## Branch Protection (Classic)

**File:** `branch-protection.json`

Use for classic branch protection on existing repositories.

**Usage:**

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --input branch-protection.json
```

**Documentation:** <https://docs.github.com/en/rest/branches/branch-protection>

## Repository Rulesets (Modern)

**File:** `ruleset.json`

Modern alternative to branch protection. Recommended for new repositories.

**Usage:**

```bash
gh api repos/{owner}/{repo}/rulesets \
  --method POST \
  --input ruleset.json
```

**Documentation:** <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets>

## Customization

Before applying these templates:

1. Review the default values (status check names, review counts, etc.)
2. Modify to match your repository's CI/CD workflow
3. Adjust `required_status_checks` contexts to match your actual CI job names
