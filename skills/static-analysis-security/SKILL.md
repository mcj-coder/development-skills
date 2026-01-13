---
name: static-analysis-security
description: Use when implementing or configuring static analysis for security, including SAST tools, security linting, secrets detection, and vulnerability threshold management. Covers tool selection, CI integration, IDE setup, and suppression policies.
---

# Static Analysis Security

## Overview

**P1 Quality & Correctness** - Automated detection of security vulnerabilities through static code analysis.
Complements manual code review with consistent, repeatable security checks.

**REQUIRED:** superpowers:verification-before-completion

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

## Reference Documents

Load based on specific need:

- [Tool Selection](references/tool-selection.md) - Detailed tool comparison and selection criteria
- [CI Configuration](references/ci-configuration.md) - Pipeline templates for common CI systems
- [Secrets Detection](references/secrets-detection.md) - Comprehensive secrets scanning setup
