# Automated Feature Checks

> Reference material for the [`repo-best-practices-bootstrap`](../SKILL.md) skill.


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
