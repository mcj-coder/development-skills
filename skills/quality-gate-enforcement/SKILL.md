---
name: quality-gate-enforcement
description: Use when creating or modifying CI/CD pipelines to enforce quality gates (coverage thresholds, security scans, test requirements, performance benchmarks). Ensures code quality standards are automatically enforced before merge or deployment.
metadata:
  type: Quality
  priority: P1
---

# Quality Gate Enforcement

## Overview

**P1 Quality & Correctness** - Applies to all CI/CD pipelines. Quality gates are blocking by default.

**REQUIRED:** superpowers:verification-before-completion, superpowers:test-driven-development

## Security Skills Decision Matrix

Use this matrix to select the appropriate security skill:

| If You Need To...                                              | Use This Skill                      |
| -------------------------------------------------------------- | ----------------------------------- |
| Define org-wide security policies and governance               | security-processes                  |
| Set up SAST tools, secrets detection, or security linting      | static-analysis-security            |
| Configure CI/CD quality gates including security scan blocking | **quality-gate-enforcement** (this) |

### Skill Scope Comparison

| Aspect             | security-processes              | static-analysis-security        | quality-gate-enforcement        |
| ------------------ | ------------------------------- | ------------------------------- | ------------------------------- |
| **Primary Focus**  | Governance & policy             | Tool configuration              | Pipeline enforcement            |
| **Scope**          | Organization-wide               | Project-level                   | Pipeline-level                  |
| **Outputs**        | Policies, SLAs, exception rules | Tool configs, suppression rules | Gate thresholds, blocking rules |
| **When to Invoke** | Defining security standards     | Setting up scanning             | Configuring CI/CD               |
| **Relationship**   | Orchestrates other skills       | Implements SAST portion         | Enforces as gates               |

### Do NOT Use This Skill When

- Defining what policies should be enforced (use security-processes)
- Selecting and configuring SAST tools (use static-analysis-security)
- Setting up tool-specific suppression rules (use static-analysis-security)

## When to Use

- Creating or modifying CI/CD pipelines
- Adding quality controls to existing workflows
- Integrating security scanning into deployment process
- **Opt-out**: Explicit exception with documented remediation timeline

## Core Quality Gates

| Gate Category   | Minimum Threshold     | Enforcement |
| --------------- | --------------------- | ----------- |
| Code Coverage   | 80% (lines, branches) | Blocking    |
| Security Scan   | Zero high/critical    | Blocking    |
| Test Pass Rate  | 100%                  | Blocking    |
| Static Analysis | Zero warnings         | Blocking    |
| Build Status    | Zero errors           | Blocking    |

## Core Workflow

1. Identify pipeline stages (PR, build, deploy)
2. Define gate thresholds per stage
3. Configure coverage tools with thresholds
4. Add security scanning (SAST, dependency, container)
5. Enforce test pass requirements
6. Add static analysis with warnings-as-errors
7. Configure fail-fast behaviour
8. Document gates in `docs/quality-gates.md`
9. Implement coverage ratchet for brownfield

## Multi-Stage Gate Matrix

| Stage      | Gates                               |
| ---------- | ----------------------------------- |
| PR/Branch  | Unit tests, coverage, SAST, linting |
| Dev Deploy | Integration tests, container scan   |
| Staging    | E2E tests, performance, DAST        |
| Production | All gates green, manual approval    |

See [Pipeline Integration](references/pipeline-integration.md) for CI/CD platform configurations.

## Coverage Ratchet Pattern

For brownfield codebases:

1. Measure current coverage percentage
2. Set threshold at current level (no regression)
3. Require coverage increase with each PR
4. Never allow coverage to decrease
5. Track progress toward target threshold

See [Brownfield Strategy](references/brownfield-strategy.md) for incremental adoption.

## Security Scanning Integration

| Scan Type  | Stage   | Tools                       |
| ---------- | ------- | --------------------------- |
| SAST       | PR      | SonarQube, CodeQL, Semgrep  |
| Dependency | PR      | npm audit, Snyk, Dependabot |
| Container  | Build   | Trivy, Grype, Snyk          |
| DAST       | Staging | OWASP ZAP, Burp Suite       |

See [Security Scanning](references/security-scanning.md) for tool configuration.

## Red Flags - STOP

- "Can add quality gates later"
- "Coverage threshold too strict"
- "Security scanning blocks releases"
- "Some test failures are acceptable"
- "Override quality gate for this release"
- "Internal code doesn't need gates"

**All mean:** Apply brownfield approach or document exception with remediation timeline.

## Exception Handling

When gates cannot be met immediately:

1. Document exception in `docs/quality-gates.md`
2. Specify reason and scope
3. Define remediation timeline (max 30 days)
4. Create tracking issue
5. Review exceptions weekly

Never disable gates without documented exception.

## Sample Gate Configurations

### .NET (GitHub Actions)

```yaml
# .github/workflows/quality-gates.yml
name: Quality Gates

on: [pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: "8.0.x"

      - name: Build
        run: dotnet build --warnaserror

      - name: Test with Coverage
        run: |
          dotnet test --collect:"XPlat Code Coverage" \
            --settings coverlet.runsettings \
            -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover

      - name: Coverage Gate
        uses: codecov/codecov-action@v4
        with:
          fail_ci_if_error: true
          threshold: 80

      - name: Security Scan (SAST)
        uses: github/codeql-action/analyze@v3
```

### Node.js (GitHub Actions)

```yaml
jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: "20"

      - name: Install & Build
        run: npm ci && npm run build

      - name: Lint (warnings as errors)
        run: npm run lint -- --max-warnings 0

      - name: Test with Coverage
        run: npm test -- --coverage --coverageThreshold='{"global":{"branches":80,"functions":80,"lines":80}}'

      - name: Security Audit
        run: npm audit --audit-level=high
```

### Python (GitHub Actions)

```yaml
jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: pip install -r requirements.txt -r requirements-dev.txt

      - name: Lint (ruff)
        run: ruff check . --output-format=github

      - name: Type check (mypy)
        run: mypy src/ --strict

      - name: Test with Coverage
        run: pytest --cov=src --cov-fail-under=80

      - name: Security (bandit)
        run: bandit -r src/ -ll
```

## Coverage Ratchet Example

For brownfield codebases, implement a ratchet that only allows coverage to increase:

```yaml
# coverage-ratchet.yml
name: Coverage Ratchet

on: [pull_request]

jobs:
  ratchet:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get baseline coverage
        id: baseline
        run: |
          git checkout origin/main
          npm test -- --coverage --coverageReporters=json-summary
          BASELINE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
          echo "coverage=$BASELINE" >> $GITHUB_OUTPUT

      - name: Get PR coverage
        id: current
        run: |
          git checkout ${{ github.head_ref }}
          npm test -- --coverage --coverageReporters=json-summary
          CURRENT=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
          echo "coverage=$CURRENT" >> $GITHUB_OUTPUT

      - name: Enforce ratchet
        run: |
          BASELINE=${{ steps.baseline.outputs.coverage }}
          CURRENT=${{ steps.current.outputs.coverage }}
          if (( $(echo "$CURRENT < $BASELINE" | bc -l) )); then
            echo "::error::Coverage decreased from $BASELINE% to $CURRENT%"
            exit 1
          fi
          echo "Coverage: $BASELINE% → $CURRENT% ✓"
```

### Ratchet Configuration File

```json
// .coverage-ratchet.json
{
  "baseline": 65.5,
  "target": 80,
  "increment": 0.5,
  "excludePaths": ["**/migrations/**", "**/generated/**"],
  "enforceOnFiles": ["src/**/*.ts", "src/**/*.tsx"]
}
```
