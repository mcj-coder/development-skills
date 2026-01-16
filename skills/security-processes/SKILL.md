---
name: security-processes
description: Use when defining or enforcing cross-language security processes including SCA, SBOM/container scanning, SAST strategy, dependency update governance, release gates, and exception handling.
---

# Security processes (cross-cutting, multi-language)

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
