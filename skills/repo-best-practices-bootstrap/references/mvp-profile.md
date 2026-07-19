# Minimum Viable Bootstrap Profile

> Reference material for the [`repo-best-practices-bootstrap`](../SKILL.md) skill.


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
