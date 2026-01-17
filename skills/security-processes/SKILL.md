---
name: security-processes
description: Use when defining or enforcing cross-language security processes including SCA, SBOM/container scanning, SAST strategy, dependency update governance, release gates, and exception handling.
metadata:
  type: Quality
  priority: P0
---

# Security Processes (Cross-Cutting, Multi-Language)

## Overview

Organization-grade security governance across languages and platforms. This skill defines
security policies, processes, and exception handling at the organizational level.

## When to Use

- Defining organisation-wide security policies and governance standards
- Establishing SCA (Software Composition Analysis) and SBOM requirements
- Configuring dependency scanning and update governance processes
- Setting up release gates and security policy enforcement
- Defining remediation SLAs and exception handling procedures
- Reviewing or auditing security processes across repositories

## Core Workflow

1. Define security controls matrix by repository type and deployment model
2. Configure baseline security pipeline (dependency scan, SAST, secret scan, SBOM)
3. Establish minimum security gates for PRs and releases
4. Document remediation SLAs by severity (Critical: 24h, High: 7d, Medium: 30d, Low: 90d)
5. Create exception request and approval workflow
6. Set up security scan evidence templates for compliance documentation
7. Configure pipeline stages appropriate to each environment (dev/staging/prod)

## Security Skills Decision Matrix

Use this matrix to select the appropriate security skill:

| If You Need To...                                              | Use This Skill                |
| -------------------------------------------------------------- | ----------------------------- |
| Define org-wide security policies and governance               | **security-processes** (this) |
| Set up SAST tools, secrets detection, or security linting      | static-analysis-security      |
| Configure CI/CD quality gates including security scan blocking | quality-gate-enforcement      |

### Skill Scope Comparison

| Aspect             | security-processes              | static-analysis-security        | quality-gate-enforcement        |
| ------------------ | ------------------------------- | ------------------------------- | ------------------------------- |
| **Primary Focus**  | Governance & policy             | Tool configuration              | Pipeline enforcement            |
| **Scope**          | Organization-wide               | Project-level                   | Pipeline-level                  |
| **Outputs**        | Policies, SLAs, exception rules | Tool configs, suppression rules | Gate thresholds, blocking rules |
| **When to Invoke** | Defining security standards     | Setting up scanning             | Configuring CI/CD               |
| **Relationship**   | Orchestrates other skills       | Implements SAST portion         | Enforces as gates               |

### Invocation Order

For a complete security implementation:

1. **security-processes** - Define policies and requirements first
2. **static-analysis-security** - Configure SAST tools per policy
3. **quality-gate-enforcement** - Enforce as CI/CD gates

## Purpose

Define and implement organization-grade security processes across languages and platforms.

## Progressive loading

Load reference files in `references/` based on the process being implemented:

- `dependency-scanning.md`
- `sast.md`
- `supply-chain-and-sbom.md`
- `dependency-update-governance.md`
- `release-gates-and-policy.md`

## Outputs

- Security controls matrix by repo type and deployment model
- CI/CD gate definitions and exception handling policy
- Remediation SLAs and metrics definitions

## Minimal Baseline Security Pipeline

### GitHub Actions Baseline

```yaml
# .github/workflows/security.yml
name: Security

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: "0 0 * * 1" # Weekly scan

jobs:
  dependency-scan:
    name: Dependency Scanning
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: "fs"
          scan-ref: "."
          severity: "CRITICAL,HIGH"
          exit-code: "1"
          format: "sarif"
          output: "trivy-results.sarif"

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: "trivy-results.sarif"

  sast:
    name: Static Analysis
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4

      - name: Initialize CodeQL
        uses: github/codeql-action/init@v3
        with:
          languages: javascript # or: python, csharp, java, go

      - name: Autobuild
        uses: github/codeql-action/autobuild@v3

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v3

  secret-scan:
    name: Secret Scanning
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: TruffleHog OSS
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          extra_args: --only-verified

  sbom:
    name: Generate SBOM
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Generate SBOM
        uses: anchore/sbom-action@v0
        with:
          format: spdx-json
          output-file: sbom.spdx.json

      - name: Upload SBOM
        uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.spdx.json
```

### Minimum Security Gates

| Gate             | Trigger  | Severity      | Action            |
| ---------------- | -------- | ------------- | ----------------- |
| Dependency scan  | PR, Push | Critical/High | Block merge       |
| SAST (CodeQL)    | PR, Push | High+         | Block merge       |
| Secret detection | PR, Push | Any           | Block merge       |
| SBOM generation  | Release  | N/A           | Required artifact |

### Pipeline Stages by Environment

| Stage           | Development | Staging    | Production       |
| --------------- | ----------- | ---------- | ---------------- |
| Dependency scan | ✓ Warn      | ✓ Block    | ✓ Block          |
| SAST            | ✓ Warn      | ✓ Block    | ✓ Block          |
| Secret scan     | ✓ Block     | ✓ Block    | ✓ Block          |
| Container scan  | ○ Optional  | ✓ Block    | ✓ Block          |
| DAST            | ○ Optional  | ✓ Warn     | ✓ Block          |
| SBOM            | ○ Optional  | ✓ Generate | ✓ Sign & publish |

## Evidence Templates

### Security Scan Evidence

```markdown
## Security Scan Evidence

**Repository**: [repo-name]
**Scan Date**: YYYY-MM-DD
**Pipeline Run**: [link to CI run]

### Dependency Scanning

| Tool      | Version | Findings           | Status |
| --------- | ------- | ------------------ | ------ |
| Trivy     | v0.48.0 | 0 Critical, 2 High | ✓ Pass |
| npm audit | -       | 0 Critical, 1 High | ✓ Pass |

**High Findings:**

- [CVE-XXXX-YYYY]: [package@version] - [description]
  - Remediation: Upgrade to [version]
  - ETA: [date]

### Static Analysis (SAST)

| Tool    | Rules             | Findings  | Status |
| ------- | ----------------- | --------- | ------ |
| CodeQL  | security-extended | 0 errors  | ✓ Pass |
| Semgrep | p/security-audit  | 1 warning | ✓ Pass |

### Secret Scanning

| Tool                   | Patterns | Findings   | Status |
| ---------------------- | -------- | ---------- | ------ |
| TruffleHog             | Default  | 0 verified | ✓ Pass |
| GitHub Secret Scanning | Enabled  | 0 alerts   | ✓ Pass |

### SBOM

- Format: SPDX 2.3
- Location: [artifact link]
- Components: [N] packages documented
```

### Exception Request Template

```markdown
## Security Exception Request

**ID**: SEC-EXC-YYYY-NNN
**Requestor**: [name]
**Date**: YYYY-MM-DD

### Exception Details

**Finding**: [CVE/Rule ID]
**Severity**: [Critical/High/Medium/Low]
**Tool**: [scanner name]
**Affected**: [package/file/resource]

### Business Justification

[Why this exception is needed]

### Risk Assessment

| Factor                | Assessment               |
| --------------------- | ------------------------ |
| Exploitability        | [High/Medium/Low]        |
| Impact                | [High/Medium/Low]        |
| Exposure              | [External/Internal/None] |
| Compensating Controls | [List controls]          |

### Remediation Plan

- **Target Date**: YYYY-MM-DD
- **Tracking Issue**: [link]
- **Responsible**: [name/team]

### Approval

- [ ] Security Team: [name] [date]
- [ ] Engineering Lead: [name] [date]
- [ ] Risk Owner: [name] [date]

### Expiration

This exception expires on: YYYY-MM-DD
Review required before: YYYY-MM-DD
```

### Remediation SLA Template

```markdown
## Remediation SLAs

| Severity | Definition                            | SLA      | Escalation          |
| -------- | ------------------------------------- | -------- | ------------------- |
| Critical | Active exploitation, RCE, data breach | 24 hours | VP Engineering      |
| High     | Serious vulnerability, auth bypass    | 7 days   | Engineering Manager |
| Medium   | Moderate risk, information disclosure | 30 days  | Tech Lead           |
| Low      | Minor issues, best practice           | 90 days  | Backlog             |

### Process

1. **Detection**: Security tool identifies finding
2. **Triage**: Security team assigns severity within 4 hours
3. **Assignment**: Engineering team assigned within 1 business day
4. **Remediation**: Fix deployed within SLA
5. **Verification**: Security team confirms fix
6. **Documentation**: Evidence captured in [system]

### Exceptions

- Exception requests must be submitted before SLA expires
- Maximum exception duration: 30 days (renewable once)
- Critical findings: No exceptions without VP approval
```

## Quick Validation Commands

```bash
# Run local security checks
npm audit --audit-level=high
trivy fs --severity HIGH,CRITICAL .
semgrep --config=p/security-audit .

# Check for secrets
trufflehog filesystem . --only-verified

# Generate SBOM locally
syft . -o spdx-json > sbom.json
```

## Red Flags - STOP

These statements indicate security process anti-patterns:

| Thought                               | Reality                                                                    |
| ------------------------------------- | -------------------------------------------------------------------------- |
| "We'll add security scanning later"   | Vulnerabilities compound; integrate scanning from the start                |
| "Low severity can be ignored"         | Low findings accumulate into real risk; track and remediate systematically |
| "Exceptions don't need documentation" | Undocumented exceptions become permanent; require justification and expiry |
| "SBOM isn't relevant for us"          | Supply chain attacks are real; generate and sign SBOMs for releases        |
| "Secret scanning has false positives" | Tune patterns rather than disable; verified-only detection reduces noise   |
| "One security check is enough"        | Defence in depth requires layers; combine SCA, SAST, secrets, and SBOM     |
