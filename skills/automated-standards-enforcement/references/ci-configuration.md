# CI Configuration

Configure CI pipelines to enforce automated standards with clean build policy.

## Principle: Full Validation in CI

**CI runs comprehensive checks on all files:**

- Not limited to staged files (unlike local hooks)
- Authoritative gate before merge
- Enforces clean build policy (zero warnings)

**CI should match local tooling:**

- Same tool versions
- Same configuration files
- Same rules and thresholds

## GitHub Actions

### Node.js Project

**.github/workflows/ci.yml**:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Format check
        run: npm run format:check

      - name: Spell check
        run: npm run spell

      - name: Test with coverage
        run: npm test -- --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        if: always()

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Audit dependencies
        run: npm audit --audit-level=high

      - name: Run security scan
        uses: github/codeql-action/analyze@v3
```

### Python Project

**.github/workflows/ci.yml**:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"
          cache: "pip"

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt

      - name: Lint with Ruff
        run: ruff check .

      - name: Format check with Ruff
        run: ruff format --check .

      - name: Type check with mypy
        run: mypy src

      - name: Spell check
        run: npx cspell "**/*.py" "**/*.md"

      - name: Test with coverage
        run: pytest --cov=src --cov-report=xml --cov-fail-under=80

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        if: always()

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install dependencies
        run: pip install bandit pip-audit

      - name: Security scan with Bandit
        run: bandit -r src

      - name: Audit dependencies
        run: pip-audit
```

### .NET Project

**.github/workflows/ci.yml**:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: "8.0.x"

      - name: Restore dependencies
        run: dotnet restore

      - name: Format check
        run: dotnet format --verify-no-changes

      - name: Build (warnings as errors)
        run: dotnet build --no-restore -warnaserror

      - name: Spell check
        run: npx cspell "**/*.cs" "**/*.md"

      - name: Test with coverage
        run: |
          dotnet test --no-build --collect:"XPlat Code Coverage"

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        if: always()

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: "8.0.x"

      - name: Check for vulnerable packages
        run: dotnet list package --vulnerable --include-transitive

      - name: Security scan
        uses: github/codeql-action/analyze@v3
        with:
          languages: csharp
```

## Azure Pipelines

### Node.js Project

**azure-pipelines.yml**:

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: "ubuntu-latest"

stages:
  - stage: Validate
    jobs:
      - job: Build
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: "20.x"

          - script: npm ci
            displayName: "Install dependencies"

          - script: npm run lint
            displayName: "Lint"

          - script: npm run format:check
            displayName: "Format check"

          - script: npm run spell
            displayName: "Spell check"

          - script: npm test -- --coverage --ci
            displayName: "Test with coverage"

          - task: PublishCodeCoverageResults@1
            inputs:
              codeCoverageTool: "Cobertura"
              summaryFileLocation: "coverage/cobertura-coverage.xml"

  - stage: Security
    jobs:
      - job: Audit
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: "20.x"

          - script: npm ci
            displayName: "Install dependencies"

          - script: npm audit --audit-level=high
            displayName: "Audit dependencies"
```

### .NET Project

**azure-pipelines.yml**:

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: "ubuntu-latest"

variables:
  buildConfiguration: "Release"

stages:
  - stage: Validate
    jobs:
      - job: Build
        steps:
          - task: UseDotNet@2
            inputs:
              version: "8.0.x"

          - script: dotnet restore
            displayName: "Restore"

          - script: dotnet format --verify-no-changes
            displayName: "Format check"

          - script: dotnet build --configuration $(buildConfiguration) -warnaserror
            displayName: "Build"

          - script: npx cspell "**/*.cs" "**/*.md"
            displayName: "Spell check"

          - script: dotnet test --configuration $(buildConfiguration) --collect:"XPlat Code Coverage"
            displayName: "Test"

          - task: PublishCodeCoverageResults@1
            inputs:
              codeCoverageTool: "Cobertura"
              summaryFileLocation: "**/coverage.cobertura.xml"

  - stage: Security
    jobs:
      - job: Audit
        steps:
          - task: UseDotNet@2
            inputs:
              version: "8.0.x"

          - script: dotnet list package --vulnerable --include-transitive
            displayName: "Check vulnerable packages"
```

## GitLab CI

### Node.js Project

**.gitlab-ci.yml**:

```yaml
stages:
  - validate
  - security

default:
  image: node:20-alpine

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/

lint:
  stage: validate
  script:
    - npm ci
    - npm run lint

format:
  stage: validate
  script:
    - npm ci
    - npm run format:check

spell:
  stage: validate
  script:
    - npm ci
    - npm run spell

test:
  stage: validate
  script:
    - npm ci
    - npm test -- --coverage
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

audit:
  stage: security
  script:
    - npm ci
    - npm audit --audit-level=high
  allow_failure: true
```

## Clean Build Policy Enforcement

### Fail on Warnings

**All CI configurations should fail on warnings:**

```yaml
# Node.js - ESLint
- script: npm run lint -- --max-warnings 0

# Python - Ruff
- script: ruff check . --exit-non-zero-on-fix

# .NET - Build
- script: dotnet build -warnaserror
```

### Coverage Gates

**Enforce minimum coverage thresholds:**

```yaml
# Node.js (Jest)
- script: npm test -- --coverage --coverageThreshold='{"global":{"lines":80}}'

# Python (pytest)
- script: pytest --cov-fail-under=80
# .NET (coverlet)
# Configure in test project:
# <CollectCoverage>true</CollectCoverage>
# <Threshold>80</Threshold>
```

## Baseline Exceptions (Brownfield)

For brownfield projects with existing violations:

### Document Baseline

Create `docs/known-issues.md`:

```markdown
# Known Issues (Baseline)

## Linting Violations

| Category         | Count | Priority | Target Date |
| ---------------- | ----- | -------- | ----------- |
| Unused variables | 45    | Low      | Q2 2024     |
| Missing types    | 123   | Medium   | Q1 2024     |

## Coverage Gap

Current: 52%
Target: 80%
Timeline: Incremental improvement, 5% per sprint
```

### CI Configuration with Baseline

```yaml
# Allow known violations (document in known-issues.md)
- script: npm run lint || echo "Known violations - see docs/known-issues.md"
  allow_failure: true

# Enforce on new code via diff-based coverage
- script: |
    npm test -- --coverage
    npx diff-cover coverage.xml --compare-branch=origin/main --fail-under=80
```

## Branch Protection

Configure branch protection to require CI passes:

### GitHub

**Settings > Branches > Branch protection rules:**

- Require status checks to pass before merging
- Require branches to be up to date before merging
- Include: `validate`, `security`

### Azure DevOps

**Repos > Branches > Branch policies:**

- Build validation: Required
- Minimum reviewers: 1
- Work item linking: Required

### GitLab

**Settings > Repository > Protected branches:**

- Allowed to merge: Maintainers
- Allowed to push: No one
- Require pipeline to succeed: Yes
