---
name: quality-gate-enforcement
description: Use when creating or modifying CI/CD pipelines to enforce quality gates (coverage thresholds, security scans, test requirements, performance benchmarks). Ensures code quality standards are automatically enforced before merge or deployment.
---

# Quality Gate Enforcement

## Overview

**P1 Quality & Correctness** - Applies to all CI/CD pipelines. Quality gates are blocking by default.

**REQUIRED:** superpowers:verification-before-completion, superpowers:test-driven-development

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
