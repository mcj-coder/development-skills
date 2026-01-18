---
name: static-analysis-security
description: Use when implementing or configuring static analysis for security, including SAST tools, security linting, secrets detection, and vulnerability threshold management. Covers tool selection, CI integration, IDE setup, and suppression policies.
metadata:
  type: Quality
  priority: P0
---

# Static Analysis Security

## Overview

**P1 Quality & Correctness** - Automated detection of security vulnerabilities through static code analysis.
Complements manual code review with consistent, repeatable security checks.

**REQUIRED:** superpowers:verification-before-completion

## Security Skills Decision Matrix

Use this matrix to select the appropriate security skill:

| If You Need To...                                              | Use This Skill                      |
| -------------------------------------------------------------- | ----------------------------------- |
| Define org-wide security policies and governance               | security-processes                  |
| Set up SAST tools, secrets detection, or security linting      | **static-analysis-security** (this) |
| Configure CI/CD quality gates including security scan blocking | quality-gate-enforcement            |

### Skill Scope Comparison

| Aspect             | security-processes              | static-analysis-security        | quality-gate-enforcement        |
| ------------------ | ------------------------------- | ------------------------------- | ------------------------------- |
| **Primary Focus**  | Governance & policy             | Tool configuration              | Pipeline enforcement            |
| **Scope**          | Organization-wide               | Project-level                   | Pipeline-level                  |
| **Outputs**        | Policies, SLAs, exception rules | Tool configs, suppression rules | Gate thresholds, blocking rules |
| **When to Invoke** | Defining security standards     | Setting up scanning             | Configuring CI/CD               |
| **Relationship**   | Orchestrates other skills       | Implements SAST portion         | Enforces as gates               |

### Do NOT Use This Skill When

- Defining organizational security policies (use security-processes)
- Configuring CI/CD pipeline blocking rules (use quality-gate-enforcement)
- Tool configurations already exist and need enforcement (use quality-gate-enforcement)

## When to Use

- Setting up security scanning for new projects
- Adding SAST to existing CI/CD pipelines
- Configuring secrets detection
- Establishing vulnerability thresholds
- Integrating security analysis into developer workflow
- **Opt-out**: User explicitly refuses with documented risk acceptance

## Core Concepts

### SAST vs DAST vs SCA

| Analysis Type | What It Scans       | When It Runs | This Skill Covers            |
| ------------- | ------------------- | ------------ | ---------------------------- |
| SAST          | Source code         | Build time   | Yes                          |
| DAST          | Running application | Runtime      | No (see security-processes)  |
| SCA           | Dependencies        | Build time   | Partially (dependency vulns) |

This skill focuses on **static analysis** - examining code without executing it.

## Core Workflow

1. **Identify languages and frameworks** in the project
2. **Select appropriate SAST tools** per language (see [Tool Selection](references/tool-selection.md))
3. **Configure security linting** integrated with existing linters
4. **Set up secrets detection** for pre-commit and CI
5. **Define severity thresholds** appropriate for project maturity
6. **Configure suppression policy** with justification requirements
7. **Integrate with CI pipeline** with SARIF output for unified reporting
8. **Enable IDE integration** for shift-left developer feedback
9. **Document configuration** and rationale

## Quick Reference

### Language-Specific Tools

| Language              | SAST Tool                   | Security Linting         | Dependency Scan                  |
| --------------------- | --------------------------- | ------------------------ | -------------------------------- |
| TypeScript/JavaScript | Semgrep, CodeQL             | eslint-plugin-security   | npm-audit, Snyk                  |
| Python                | Bandit, Semgrep             | Ruff (security rules)    | Safety, pip-audit                |
| Go                    | gosec, Semgrep              | golangci-lint (security) | govulncheck                      |
| Java/Kotlin           | SpotBugs, Semgrep           | PMD Security Rules       | OWASP Dependency-Check           |
| C#                    | Security Code Scan, Semgrep | Roslyn Analyzers         | dotnet list package --vulnerable |
| Ruby                  | Brakeman, Semgrep           | RuboCop Security         | Bundler Audit                    |

### Secrets Detection Tools

| Tool           | Pre-commit | CI Scan | Historical Scan |
| -------------- | ---------- | ------- | --------------- |
| Gitleaks       | Yes        | Yes     | Yes             |
| TruffleHog     | Yes        | Yes     | Yes (deep)      |
| git-secrets    | Yes        | Limited | No              |
| detect-secrets | Yes        | Yes     | No              |

### Severity Thresholds

| Project Phase        | Critical | High  | Medium | Low  |
| -------------------- | -------- | ----- | ------ | ---- |
| Greenfield           | Block    | Block | Warn   | Info |
| Brownfield (initial) | Block    | Warn  | Info   | Info |
| Brownfield (mature)  | Block    | Block | Warn   | Info |
| Pre-release          | Block    | Block | Block  | Warn |

## Suppression Policy

All suppressions MUST include:

1. **Justification** - Why this finding is acceptable
2. **Owner** - Who approved the suppression
3. **Expiry** - When to review (max 90 days for non-false-positives)
4. **Ticket** - Tracking issue for remediation (if not false positive)

### Suppression Format Examples

**ESLint:**

```javascript
// eslint-disable-next-line security/detect-object-injection -- Validated index from trusted source, see #123
const value = obj[validatedKey];
```

**Bandit:**

```python
# nosec B105 - False positive: not a hardcoded password, see #456
DEFAULT_PLACEHOLDER = "REPLACE_ME"
```

**Semgrep:**

```yaml
# In .semgrep.yml or inline
# nosemgrep: typescript.lang.security.audit.dangerous-exec
```

## CI Integration

### Recommended Pipeline Structure

```yaml
security-scan:
  stage: test
  parallel:
    - sast
    - secrets
    - dependencies
  artifacts:
    reports:
      sarif: security-results.sarif
```

### SARIF Output

Enable SARIF format for:

- Unified reporting across tools
- IDE integration (VSCode, JetBrains)
- GitHub Security tab integration
- Trend analysis over time

## Brownfield Rollout

For existing projects with technical debt:

1. **Baseline scan** - Run full scan, document all findings
2. **Exception baseline** - Create time-bound exceptions for existing findings
3. **Report-only phase** - CI reports but does not fail (1-2 sprints)
4. **Graduated blocking** - Block critical, then high, then medium
5. **Track progress** - Measure reduction in baselined findings

## Red Flags - STOP

These statements indicate security analysis gaps:

- "Manual code review is enough for security"
- "Too many false positives, disable the scanner"
- "We only scan our own code, not dependencies"
- "Any security tool will do"
- "We'll tune the scanner after release"
- "Security scanning is too slow for CI"
- "Just suppress all the findings"

**All mean:** Apply this skill properly or document explicit opt-out with risk acceptance.

## Sample Suppression Entries

### ESLint Security Suppressions

```javascript
// GOOD: Specific, justified, linked to ticket
// eslint-disable-next-line security/detect-object-injection -- Index validated against allowlist per SEC-123
const value = obj[sanitizedKey];

// eslint-disable-next-line security/detect-non-literal-fs-filename -- Path validated from config, not user input
const config = fs.readFileSync(configPath);

// BAD: Vague, no justification
// eslint-disable-next-line security/detect-object-injection
const value = obj[key];
```

### Bandit Suppressions (Python)

```python
# GOOD: Specific reason, ticket reference
# nosec B105 - Placeholder constant for testing, replaced at runtime. See SEC-456
TEST_TOKEN_PLACEHOLDER = "REPLACE_WITH_REAL_TOKEN"

# nosec B608 - SQL query uses parameterized values, table name from enum only
query = f"SELECT * FROM {TableName.USERS.value} WHERE id = %s"

# BAD: No explanation
password = "admin123"  # nosec
```

### Semgrep Suppressions

```yaml
# In code (inline):
# nosemgrep: javascript.express.security.audit.xss.mustache-escape

# In .semgrepignore file:
# Ignore test fixtures
tests/fixtures/**

# In semgrep config (.semgrep.yml):
rules:
  - id: custom-rule
    paths:
      exclude:
        - "*_test.go"
        - "testdata/**"
```

### CodeQL Suppressions (via SARIF)

```yaml
# codeql-config.yml
paths-ignore:
  - tests/**
  - "**/testdata/**"
query-filters:
  - exclude:
      id: js/unused-local-variable
      # Only exclude in test files
      paths: "**/*.test.js"
```

### Suppression Tracking Template

```markdown
## Security Suppression Log

| ID      | Tool    | Rule                    | File         | Justification    | Owner | Expiry     | Ticket  |
| ------- | ------- | ----------------------- | ------------ | ---------------- | ----- | ---------- | ------- |
| SUP-001 | Bandit  | B105                    | config.py:42 | Test placeholder | @dev  | 2025-03-01 | SEC-123 |
| SUP-002 | Semgrep | xss-audit               | api.ts:156   | Sanitized output | @lead | N/A (FP)   | N/A     |
| SUP-003 | ESLint  | detect-object-injection | util.js:89   | Validated index  | @dev  | 2025-04-15 | SEC-456 |
```

## Evidence Capture Guidance

### Scan Evidence Template

````markdown
## Security Scan Evidence

**Date**: YYYY-MM-DD
**Commit**: abc1234
**Branch**: feature/xyz
**Scanner Version**: [tool@version]

### Summary

| Severity | Count | Status                 |
| -------- | ----- | ---------------------- |
| Critical | 0     | Pass                   |
| High     | 2     | Blocked (requires fix) |
| Medium   | 5     | Baselined              |
| Low      | 12    | Info only              |

### New Findings

| ID   | Severity | Rule          | Location          | Status       |
| ---- | -------- | ------------- | ----------------- | ------------ |
| F001 | High     | sql-injection | api/query.ts:45   | Fix required |
| F002 | High     | xss-reflected | web/render.ts:123 | Fix required |

### Baselined Findings

| ID   | Severity | Baseline Date | Review Date | Ticket  |
| ---- | -------- | ------------- | ----------- | ------- |
| B001 | Medium   | 2024-12-01    | 2025-03-01  | SEC-789 |
| B002 | Medium   | 2024-12-01    | 2025-03-01  | SEC-790 |

### Verification

```bash
# Commands run
semgrep --config=p/security-audit --sarif -o results.sarif .
bandit -r src/ -f sarif -o bandit.sarif
gitleaks detect --source . --report-format sarif --report-path secrets.sarif
```
````

### CI Pipeline Evidence

```yaml
# GitHub Actions example with evidence artifacts
security-scan:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4

    - name: Run Semgrep
      uses: returntocorp/semgrep-action@v1
      with:
        config: p/security-audit
        generateSarif: true

    - name: Run Gitleaks
      uses: gitleaks/gitleaks-action@v2
      with:
        report_format: sarif

    - name: Upload SARIF results
      uses: github/codeql-action/upload-sarif@v3
      with:
        sarif_file: results/

    - name: Archive scan evidence
      uses: actions/upload-artifact@v4
      with:
        name: security-scan-evidence-${{ github.sha }}
        path: |
          results/*.sarif
          results/*.json
        retention-days: 90
```

### Evidence Retention Requirements

| Evidence Type      | Retention       | Storage           |
| ------------------ | --------------- | ----------------- |
| SARIF reports      | 90 days minimum | CI artifacts      |
| Suppression log    | Permanent       | Repository        |
| Baseline snapshots | Per release     | Release artifacts |
| Audit trail        | 1 year          | Compliance system |

### Verification Commands

```bash
# Verify SARIF output is valid
cat results.sarif | jq '.runs[0].results | length'

# Check for unaddressed critical/high findings
jq '[.runs[].results[] | select(.level == "error")] | length' results.sarif

# Verify no secrets in scan scope
gitleaks detect --source . --verbose --no-git

# Compare against baseline
semgrep --config=p/security-audit --baseline-commit HEAD~1 .
```

## Reference Documents

Load based on specific need:

- [Tool Selection](references/tool-selection.md) - Detailed tool comparison and selection criteria
- [CI Configuration](references/ci-configuration.md) - Pipeline templates for common CI systems
- [Secrets Detection](references/secrets-detection.md) - Comprehensive secrets scanning setup
