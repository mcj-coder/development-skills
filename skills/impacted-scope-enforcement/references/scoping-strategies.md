# Scoping Strategies

Detailed patterns for scoping quality gates and deployments to impacted components.

## Identifying Impacted Components

### Git-Based Detection

```bash
# Files changed in current branch vs main
git diff --name-only origin/main...HEAD

# Files changed in staged commit
git diff --cached --name-only

# Files changed with status filter
git diff --name-only --diff-filter=ACM HEAD~1
```

### Monorepo Tooling

| Tool      | Affected Command                       | Description                 |
| --------- | -------------------------------------- | --------------------------- |
| Nx        | `nx affected:apps --base=main`         | Lists affected applications |
| Turborepo | `turbo run build --filter=...[main]`   | Builds changed packages     |
| Bazel     | `bazel query 'rdeps(//..., set(...))'` | Reverse dependency query    |
| Lerna     | `lerna changed`                        | Lists changed packages      |

### Custom Script Template

```bash
#!/usr/bin/env bash
# affected.sh - Identify affected components from git changes
set -euo pipefail

BASE_BRANCH="${1:-main}"
CHANGED_FILES=$(git diff --name-only "origin/$BASE_BRANCH"...HEAD)

# Extract service names from paths (adjust pattern for your structure)
AFFECTED_SERVICES=$(echo "$CHANGED_FILES" | grep -oP 'services/\K[^/]+' | sort -u)

echo "Affected services:"
echo "$AFFECTED_SERVICES"
```

## Scoping Quality Gates

### Pre-Commit Hooks

```bash
#!/usr/bin/env bash
# pre-commit hook - Scope validation to staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
  exit 0
fi

# Lint only staged files
echo "Linting staged files..."
eslint $STAGED_FILES

# Test affected components
echo "Testing affected components..."
AFFECTED=$(echo "$STAGED_FILES" | grep -oP 'src/\K[^/]+' | sort -u)
for component in $AFFECTED; do
  npm test -- --testPathPattern="$component"
done
```

### CI Pipeline Configuration

**GitHub Actions:**

```yaml
jobs:
  affected:
    runs-on: ubuntu-latest
    outputs:
      services: ${{ steps.affected.outputs.services }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - id: affected
        run: |
          SERVICES=$(git diff --name-only origin/main...HEAD | grep -oP 'services/\K[^/]+' | sort -u | tr '\n' ',')
          echo "services=$SERVICES" >> $GITHUB_OUTPUT

  build:
    needs: affected
    if: needs.affected.outputs.services != ''
    strategy:
      matrix:
        service: ${{ fromJson(format('["{0}"]', join(fromJson(format('["{0}"]', needs.affected.outputs.services)), '","'))) }}
    steps:
      - run: npm run build --workspace=${{ matrix.service }}
```

**Azure DevOps:**

```yaml
stages:
  - stage: Affected
    jobs:
      - job: Detect
        steps:
          - bash: |
              AFFECTED=$(git diff --name-only origin/main...HEAD | grep -oP 'services/\K[^/]+' | sort -u)
              echo "##vso[task.setvariable variable=affected;isOutput=true]$AFFECTED"
            name: detect

  - stage: Build
    dependsOn: Affected
    condition: ne(dependencies.Affected.outputs['Detect.detect.affected'], '')
    jobs:
      - job: BuildServices
        steps:
          - script: npm run build:affected
```

## Coverage Delta Calculation

### Script Template

```bash
#!/usr/bin/env bash
# coverage-delta.sh - Calculate coverage for modified lines
set -euo pipefail

THRESHOLD="${1:-80}"
BASE_BRANCH="${2:-main}"

# Get modified lines
MODIFIED_FILES=$(git diff --name-only "origin/$BASE_BRANCH"...HEAD -- '*.ts' '*.js')

# Run coverage for affected files
npx jest --coverage --collectCoverageFrom="$MODIFIED_FILES" --coverageReporters=json-summary

# Extract coverage percentage (implementation depends on coverage tool)
COVERAGE=$(jq '.total.lines.pct' coverage/coverage-summary.json)

echo "Coverage of modified files: $COVERAGE%"
echo "Threshold: $THRESHOLD%"

if (( $(echo "$COVERAGE < $THRESHOLD" | bc -l) )); then
  echo "FAIL: Coverage below threshold"
  exit 1
fi

echo "PASS: Coverage meets threshold"
```

### Integration with Coverage Tools

| Tool      | Delta Support                  |
| --------- | ------------------------------ |
| Jest      | `--changedSince=main`          |
| nyc       | `--include` with changed files |
| Codecov   | `--flags` per component        |
| Coveralls | Per-service coverage reports   |
| SonarQube | New code analysis period       |

## Selective Deployment

### Service-Specific Tagging

```bash
#!/usr/bin/env bash
# tag-service.sh - Create service-specific version tag
set -euo pipefail

SERVICE="$1"
VERSION="$2"

TAG="${SERVICE}-v${VERSION}"
COMMIT=$(git rev-parse HEAD)

git tag -a "$TAG" -m "Release $SERVICE version $VERSION"
git push origin "$TAG"

echo "Tagged $TAG at commit $COMMIT"
```

### Container Registry Strategy

```bash
# Build and push only affected service
SERVICE="backend"
VERSION="2.6.0"

docker build -t "registry.example.com/${SERVICE}:${VERSION}" "./services/${SERVICE}"
docker push "registry.example.com/${SERVICE}:${VERSION}"

# Unchanged services keep previous versions
# frontend:1.8.2, database-migrator:1.2.1 - not rebuilt
```

### Kubernetes Deployment

```yaml
# backend-deployment.yaml - Deploy only backend
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  template:
    spec:
      containers:
        - name: backend
          image: registry.example.com/backend:2.6.0
---
# Other services unchanged - no deployment needed
```

## Architecture Patterns

### Monorepo Structure

```text
repo/
  services/
    auth/          # Independent service
    user/          # Independent service
    payment/       # Independent service
  shared/
    lib-common/    # Shared library (change affects dependents)
    lib-contracts/ # Shared contracts
  tools/
    ci/            # CI configuration
```

### Dependency Graph

```text
auth -----> lib-common
user -----> lib-common
payment --> lib-common
         \-> lib-contracts

Change to lib-common: Test auth, user, payment
Change to auth only: Test auth only
Change to lib-contracts: Test payment only
```

### Single-Repo Scoping

Even without monorepo tooling, scope by:

- **Directory structure:** `src/frontend/`, `src/backend/`
- **File patterns:** `*.test.ts`, `*.spec.js`
- **Module boundaries:** `src/modules/auth/`, `src/modules/user/`

## Tooling Comparison

| Feature            | Nx       | Turborepo | Bazel    | Custom    |
| ------------------ | -------- | --------- | -------- | --------- |
| Affected detection | Built-in | Built-in  | Query    | Git-based |
| Caching            | Local+CI | Local+CI  | Advanced | Manual    |
| Task orchestration | Yes      | Yes       | Yes      | Scripts   |
| Language support   | JS/TS    | Any       | Any      | Any       |
| Learning curve     | Medium   | Low       | High     | Low       |
| Setup complexity   | Medium   | Low       | High     | Varies    |
