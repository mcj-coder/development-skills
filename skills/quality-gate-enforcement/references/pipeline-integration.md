# Pipeline Integration

Platform-specific configurations for quality gate enforcement.

## GitHub Actions

```yaml
name: Quality Gates
on:
  pull_request:
  push:
    branches: [main]

jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies
        run: npm ci

      - name: Lint (zero warnings)
        run: npm run lint -- --max-warnings=0

      - name: Unit Tests with Coverage
        run: npm run test:coverage

      - name: Check Coverage Threshold
        run: |
          COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi

      - name: Security Scan
        run: npm audit --audit-level=high

      - name: Upload Coverage Report
        uses: codecov/codecov-action@v4
        with:
          fail_ci_if_error: true
```

## Azure Pipelines

```yaml
trigger:
  - main

pr:
  - main

stages:
  - stage: QualityGates
    displayName: Quality Gates
    jobs:
      - job: Build
        pool:
          vmImage: ubuntu-latest
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: "20.x"

          - script: npm ci
            displayName: Install dependencies

          - script: npm run lint -- --max-warnings=0
            displayName: Lint (zero warnings)

          - script: npm run test:coverage
            displayName: Unit Tests with Coverage

          - task: PublishCodeCoverageResults@2
            inputs:
              codeCoverageTool: Cobertura
              summaryFileLocation: $(System.DefaultWorkingDirectory)/coverage/cobertura-coverage.xml

          - script: |
              COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
              if (( $(echo "$COVERAGE < 80" | bc -l) )); then
                echo "##vso[task.logissue type=error]Coverage $COVERAGE% is below 80% threshold"
                exit 1
              fi
            displayName: Check Coverage Threshold

          - task: npm@1
            displayName: Security Scan
            inputs:
              command: custom
              customCommand: audit --audit-level=high
```

## GitLab CI

```yaml
stages:
  - quality

quality-gates:
  stage: quality
  image: node:20
  script:
    - npm ci
    - npm run lint -- --max-warnings=0
    - npm run test:coverage
    - |
      COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
      if (( $(echo "$COVERAGE < 80" | bc -l) )); then
        echo "Coverage $COVERAGE% is below 80% threshold"
        exit 1
      fi
    - npm audit --audit-level=high
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
```

## .NET Configuration

### GitHub Actions

```yaml
name: Quality Gates
on:
  pull_request:
  push:
    branches: [main]

jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: 8.0.x

      - name: Restore
        run: dotnet restore

      - name: Build (warnings as errors)
        run: dotnet build --no-restore --warnaserror

      - name: Test with Coverage
        run: |
          dotnet test --no-build \
            --collect:"XPlat Code Coverage" \
            --results-directory ./coverage \
            -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=cobertura

      - name: Check Coverage
        run: |
          COVERAGE=$(grep -oP 'line-rate="\K[^"]+' coverage/*/coverage.cobertura.xml | head -1)
          COVERAGE_PCT=$(echo "$COVERAGE * 100" | bc)
          if (( $(echo "$COVERAGE_PCT < 80" | bc -l) )); then
            echo "Coverage $COVERAGE_PCT% is below 80% threshold"
            exit 1
          fi

      - name: Security Scan
        run: dotnet list package --vulnerable --include-transitive
```

## Python Configuration

### GitHub Actions

```yaml
name: Quality Gates
on:
  pull_request:
  push:
    branches: [main]

jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov ruff bandit safety

      - name: Lint (zero warnings)
        run: ruff check . --exit-non-zero-on-fix

      - name: Test with Coverage
        run: |
          pytest --cov=src --cov-report=xml --cov-fail-under=80

      - name: Security Scan (SAST)
        run: bandit -r src -ll

      - name: Security Scan (dependencies)
        run: safety check
```

## Gate Failure Behaviour

All pipelines should:

1. **Fail fast** - Stop on first gate failure
2. **Clear messaging** - Report which gate failed and why
3. **No bypass** - Gates cannot be skipped without documented exception
4. **Audit trail** - Log all gate results for compliance
