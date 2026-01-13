# Security Scanning

Comprehensive security scanning integration for quality gates.

## Scan Types Overview

| Type      | Purpose                    | Stage   | Blocking Level |
| --------- | -------------------------- | ------- | -------------- |
| SAST      | Static code analysis       | PR      | High/Critical  |
| SCA       | Dependency vulnerabilities | PR      | High/Critical  |
| Container | Image vulnerabilities      | Build   | High/Critical  |
| DAST      | Runtime vulnerabilities    | Staging | Critical only  |
| Secrets   | Exposed credentials        | PR      | All severities |

## SAST Tools

### SonarQube / SonarCloud

```yaml
# GitHub Actions
- name: SonarCloud Scan
  uses: SonarSource/sonarcloud-github-action@master
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}

- name: Check Quality Gate
  run: |
    STATUS=$(curl -s -u ${{ secrets.SONAR_TOKEN }}: \
      "https://sonarcloud.io/api/qualitygates/project_status?projectKey=$PROJECT_KEY" \
      | jq -r '.projectStatus.status')
    if [ "$STATUS" != "OK" ]; then
      echo "SonarQube Quality Gate failed"
      exit 1
    fi
```

### CodeQL (GitHub Advanced Security)

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: javascript, typescript

- name: Perform CodeQL Analysis
  uses: github/codeql-action/analyze@v3
  with:
    fail-on: error
```

### Semgrep

```yaml
- name: Semgrep Scan
  uses: returntocorp/semgrep-action@v1
  with:
    config: >-
      p/security-audit
      p/secrets
    publishToken: ${{ secrets.SEMGREP_APP_TOKEN }}
    generateSarif: true
```

## Dependency Scanning (SCA)

### Node.js

```yaml
# npm audit
- name: Security Audit
  run: npm audit --audit-level=high

# Snyk
- name: Snyk Security Scan
  uses: snyk/actions/node@master
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
  with:
    args: --severity-threshold=high
```

### Python

```yaml
# Safety
- name: Safety Check
  run: safety check -r requirements.txt

# pip-audit
- name: pip-audit
  run: pip-audit --strict --vulnerability-service pypi
```

### .NET

```yaml
# Built-in vulnerability check
- name: Check Vulnerabilities
  run: dotnet list package --vulnerable --include-transitive

# Snyk
- name: Snyk .NET Scan
  uses: snyk/actions/dotnet@master
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

### Go

```yaml
# govulncheck
- name: Vulnerability Check
  run: govulncheck ./...

# Nancy
- name: Nancy Scan
  run: nancy sleuth
```

## Container Scanning

### Trivy

```yaml
- name: Build Container
  run: docker build -t myapp:${{ github.sha }} .

- name: Trivy Container Scan
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: myapp:${{ github.sha }}
    format: table
    exit-code: 1
    severity: CRITICAL,HIGH
```

### Grype

```yaml
- name: Grype Container Scan
  uses: anchore/scan-action@v3
  with:
    image: myapp:${{ github.sha }}
    fail-build: true
    severity-cutoff: high
```

## Secret Detection

### Gitleaks

```yaml
- name: Gitleaks Scan
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### TruffleHog

```yaml
- name: TruffleHog Scan
  uses: trufflesecurity/trufflehog@main
  with:
    extra_args: --only-verified
```

## DAST Tools

### OWASP ZAP

```yaml
- name: ZAP Baseline Scan
  uses: zaproxy/action-baseline@v0.10.0
  with:
    target: https://staging.example.com
    fail_action: true
```

## Severity Thresholds

### Recommended Gate Configuration

```yaml
security_gates:
  sast:
    block_on:
      - critical
      - high
    warn_on:
      - medium
  sca:
    block_on:
      - critical
      - high
    warn_on:
      - medium
  container:
    block_on:
      - critical
      - high
    warn_on:
      - medium
  dast:
    block_on:
      - critical
    warn_on:
      - high
      - medium
  secrets:
    block_on:
      - all # Never allow exposed secrets
```

## Consolidated Security Report

### SARIF Integration

Most security tools can output SARIF format for unified reporting:

```yaml
- name: Upload SARIF
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: results.sarif
```

### Security Dashboard

Create `docs/security-status.md` for visibility:

```markdown
# Security Status

Last scan: 2024-01-15

## Summary

| Category     | Critical | High | Medium | Low |
| ------------ | -------- | ---- | ------ | --- |
| SAST         | 0        | 0    | 2      | 5   |
| Dependencies | 0        | 1    | 3      | 8   |
| Container    | 0        | 0    | 1      | 2   |

## Action Required

- [ ] Upgrade lodash to 4.17.21 (High - CVE-2021-23337)
```

## False Positive Management

```yaml
# .trivyignore
CVE-2023-12345  # False positive - not exploitable in our context

# .snyk
ignore:
  SNYK-JS-EXAMPLE-1234567:
    - '*':
        reason: False positive - input is sanitized
        expires: 2024-06-01
```

Document all suppressions with:

- Justification
- Expiration date
- Review schedule
