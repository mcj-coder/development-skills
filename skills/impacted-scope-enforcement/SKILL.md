---
name: impacted-scope-enforcement
description: Use when user deploys changes, commits code, runs builds/tests, or requests selective validation. Ensures only impacted components are tested/deployed when appropriate, scoping quality gates to modified code.
---

# Impacted Scope Enforcement

## Overview

**Scope quality gates and deployments to impacted components only.** Full-system validation
wastes CI resources and delays feedback when only a subset of code changed. Identify impact,
scope gates, execute selectively.

**REQUIRED BACKGROUND:** superpowers:verification-before-completion

## When to Use

**Triggered for:**

- User deploys changes or requests deployment
- User commits code triggering quality gates
- User runs local or CI builds/tests
- User asks about selective or incremental validation
- Repository uses immutable releases and SemVer

## Core Workflow

1. **Identify impact** - Determine which components changed (use git diff, affected tooling)
2. **Scope quality gates** - Limit lint, format, tests to impacted files/components
3. **Apply coverage delta** - Check coverage of modified lines only (not absolute coverage)
4. **Selective execution** - Build/test/deploy only affected components + dependencies
5. **Preserve critical gates** - Always run architecture tests, security scans

## Quick Reference

| Scenario              | Scoping Strategy                           |
| --------------------- | ------------------------------------------ |
| Single file change    | Lint/test affected file + direct consumers |
| Service change (mono) | Build/test that service + consumer tests   |
| Shared library change | Build/test all dependent services          |
| Documentation only    | Skip deployment, validate markdown only    |
| Deploy single service | Deploy that service, keep others unchanged |

## Coverage Delta

**Use modified line coverage, not absolute coverage:**

```text
Coverage Delta = (covered modified lines / total modified lines) x 100
Target: 80% of modified lines covered
```

Absolute coverage punishes unrelated code. Delta focuses quality on changes.

## Service-Specific Versioning

For immutable releases:

- Tag services individually: `backend-v2.6.0`, `frontend-v1.8.2`
- Deploy only changed services
- Rollback to previous immutable version per service

## Red Flags - STOP

- "Run full suite to be safe"
- "Deploy everything together"
- "Apply absolute coverage to entire codebase"
- "Use single version tag for all components"
- "Might miss something with selective approach"

**All mean: Apply skill to scope validation/deployment to impacted components.**

See `references/scoping-strategies.md` for tooling examples and detailed patterns.
See `references/rationalizations.md` for excuse table and pressure responses.

## Build Tool Commands

### Nx (TypeScript/JavaScript)

```bash
# Find affected projects
npx nx affected:apps --base=main --head=HEAD

# Run tests only for affected projects
npx nx affected:test --base=main --head=HEAD

# Build only affected projects
npx nx affected:build --base=main --head=HEAD

# Show dependency graph of affected
npx nx affected:graph --base=main --head=HEAD
```

### Bazel

```bash
# Query affected targets
bazel query "rdeps(//..., set($(git diff --name-only main...HEAD)))"

# Test only affected targets
bazel test $(bazel query "rdeps(//..., set($(git diff --name-only main...HEAD)))" --output=label)

# Build only affected
bazel build $(bazel query "kind(.*_binary, rdeps(//..., set($(git diff --name-only main...HEAD))))")
```

### Gradle

```bash
# Using gradle-affected plugin
./gradlew affectedUnitTests -Paffected.base=main

# Manual approach with changed modules
CHANGED=$(git diff --name-only main...HEAD | grep -E "^[^/]+/" | cut -d'/' -f1 | sort -u)
for module in $CHANGED; do
  ./gradlew :$module:test
done
```

### Turborepo (TypeScript/JavaScript)

```bash
# Run tests for affected packages
npx turbo run test --filter='...[origin/main]'

# Build affected packages
npx turbo run build --filter='...[origin/main]'
```

## Delta Coverage Workflow

### Step 1: Generate baseline coverage

```bash
# Checkout main, run tests with coverage
git checkout main
npm test -- --coverage --coverageReporters=json
cp coverage/coverage-final.json coverage-baseline.json
git checkout -
```

### Step 2: Identify modified lines

```bash
# Get line numbers of changes
git diff main...HEAD --unified=0 | grep -E "^@@" > changed-lines.txt
```

### Step 3: Calculate delta coverage

```javascript
// delta-coverage.js
const baseline = require("./coverage-baseline.json");
const current = require("./coverage/coverage-final.json");
const changedFiles = execSync("git diff --name-only main...HEAD")
  .toString()
  .split("\n");

let coveredLines = 0,
  totalLines = 0;

for (const file of changedFiles.filter(
  (f) => f.endsWith(".ts") || f.endsWith(".js"),
)) {
  const fileCoverage = current[file];
  if (!fileCoverage) continue;

  const changedLineNumbers = getChangedLines(file); // from git diff
  for (const line of changedLineNumbers) {
    totalLines++;
    if (fileCoverage.s[line] > 0) coveredLines++;
  }
}

const deltaCoverage = (coveredLines / totalLines) * 100;
console.log(`Delta coverage: ${deltaCoverage.toFixed(1)}%`);
if (deltaCoverage < 80) process.exit(1);
```

### CI Integration (GitHub Actions)

```yaml
- name: Delta coverage check
  run: |
    git fetch origin main
    CHANGED_FILES=$(git diff --name-only origin/main...HEAD | grep -E '\.(ts|js)$' || true)
    if [ -z "$CHANGED_FILES" ]; then
      echo "No code changes, skipping delta coverage"
      exit 0
    fi
    npm test -- --coverage --collectCoverageFrom="$CHANGED_FILES"
    node scripts/delta-coverage.js
```

## Required Agent Steps

1. Announce skill and why it applies
2. Identify affected components (git diff, affected tooling)
3. For commits: Scope git hook quality gates to impacted files/components
4. For commits: Apply coverage delta to modified lines only
5. For builds: Define selective build execution (impacted + dependencies)
6. For builds: Define selective test execution (unit, integration, contracts)
7. For deployments: Ensure only impacted components deployed
8. For deployments: Define service-specific version tags and traceability
9. Preserve full-suite critical gates (architecture, security)
10. Provide evidence checklist for completion
