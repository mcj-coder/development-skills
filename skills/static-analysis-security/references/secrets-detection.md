# Secrets Detection Guide

## Overview

Secrets detection prevents accidental exposure of sensitive credentials in source code. This includes:

- API keys and tokens
- Passwords and connection strings
- Private keys and certificates
- Cloud provider credentials (AWS, Azure, GCP)
- Internal service credentials

## Tool Selection

### Recommended Tools

| Tool           | Best For        | Pre-commit | CI      | Historical |
| -------------- | --------------- | ---------- | ------- | ---------- |
| Gitleaks       | General purpose | Yes        | Yes     | Yes        |
| TruffleHog     | Deep scanning   | Yes        | Yes     | Yes (deep) |
| detect-secrets | Yelp-maintained | Yes        | Yes     | No         |
| git-secrets    | AWS focus       | Yes        | Limited | No         |

### Tool Comparison

#### Gitleaks (Recommended)

- Fast and accurate
- Good default patterns
- Easy custom rules
- SARIF output support
- Active maintenance

#### TruffleHog

- Very thorough scanning
- Excellent historical analysis
- Verification of live secrets
- Higher false positive rate

#### detect-secrets

- Baseline management built-in
- Good for brownfield projects
- Plugin architecture
- No SARIF support

## Gitleaks Setup

### Installation

```bash
# macOS
brew install gitleaks

# Linux
curl -sSfL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_linux_x64.tar.gz | tar xz

# Windows
choco install gitleaks
```

### Pre-commit Configuration

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

### Custom Configuration

```toml
# .gitleaks.toml
title = "Custom Gitleaks Config"

[extend]
useDefault = true

[[rules]]
id = "internal-api-key"
description = "Internal API Key"
regex = '''INTERNAL_API_KEY_[A-Z0-9]{32}'''
secretGroup = 0

[[rules]]
id = "internal-connection-string"
description = "Internal Database Connection String"
regex = '''Server=internal-db\.company\.com;.*Password=[^;]+'''
secretGroup = 0

[allowlist]
description = "Global allowlist"
paths = [
    '''\.gitleaks\.toml$''',
    '''\.git/''',
    '''tests/fixtures/fake-secrets\.txt$'''
]

[[rules.allowlist]]
commits = ["abc123def456"]  # Specific commit exceptions
regexes = ['''EXAMPLE_.*''']  # Pattern exceptions
```

### CI Integration

```yaml
# GitHub Actions
- name: Gitleaks Scan
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    GITLEAKS_CONFIG: .gitleaks.toml
```

## TruffleHog Setup

### Installation

```bash
# macOS
brew install trufflehog

# Linux/macOS via pip
pip install trufflehog

# Docker
docker pull trufflesecurity/trufflehog:latest
```

### Basic Usage

```bash
# Scan current directory
trufflehog filesystem .

# Scan git history
trufflehog git file://. --since-commit HEAD~100

# Scan with verification (checks if secrets are live)
trufflehog git file://. --only-verified
```

### CI Integration

```yaml
# GitHub Actions
- name: TruffleHog Scan
  uses: trufflesecurity/trufflehog@main
  with:
    path: ./
    base: ${{ github.event.repository.default_branch }}
    head: HEAD
```

## Custom Pattern Development

### Common Internal Patterns

```toml
# Internal API keys
[[rules]]
id = "company-api-key"
description = "Company Internal API Key"
regex = '''(?i)company[_-]?api[_-]?key['\"]?\s*[:=]\s*['\"]?([a-zA-Z0-9]{32,64})['\"]?'''
secretGroup = 1

# Internal JWT secrets
[[rules]]
id = "company-jwt-secret"
description = "Company JWT Signing Secret"
regex = '''JWT[_-]?SECRET['\"]?\s*[:=]\s*['\"]?([a-zA-Z0-9+/=]{32,})['\"]?'''
secretGroup = 1

# Database connection strings
[[rules]]
id = "internal-db-connection"
description = "Internal Database Connection"
regex = '''(?i)(mongodb|postgresql|mysql):\/\/[^:]+:[^@]+@[a-zA-Z0-9.-]+'''
secretGroup = 0
```

### Testing Custom Patterns

```bash
# Test pattern against sample file
echo 'COMPANY_API_KEY=abc123def456789012345678901234567890' > test-secret.txt
gitleaks detect --source test-secret.txt --config .gitleaks.toml --verbose
rm test-secret.txt
```

## Handling Detected Secrets

### Immediate Response

1. **Rotate the secret** - Generate new credentials immediately
2. **Revoke the old secret** - Disable the exposed credential
3. **Scan for usage** - Check logs for unauthorised access
4. **Clean history** - Remove from git history if necessary
5. **Add to allowlist** - Only after rotation, if pattern causes false positives

### Git History Cleaning

```bash
# Using git-filter-repo (recommended)
pip install git-filter-repo
git filter-repo --invert-paths --path secrets.txt

# Using BFG Repo-Cleaner
java -jar bfg.jar --delete-files secrets.txt

# Force push after cleaning (DANGEROUS - coordinate with team)
git push --force --all
```

### Documentation Template

```markdown
## Secret Exposure Incident - [DATE]

**Secret Type:** [API Key / Password / Token]
**Exposure Duration:** [Time discovered] - [Time rotated]
**Affected Service:** [Service name]

### Timeline

- [TIME] Secret committed in [COMMIT_SHA]
- [TIME] Secret detected by [TOOL]
- [TIME] Secret rotated
- [TIME] Old secret revoked
- [TIME] Git history cleaned (if applicable)

### Impact Assessment

- [ ] Logs reviewed for unauthorised access
- [ ] No evidence of compromise found / Compromise detected: [details]

### Prevention Measures

- [ ] Pre-commit hook verified
- [ ] CI scanning verified
- [ ] Team notified of incident
```

## Allowlist Management

### When to Allowlist

- **False positives** - Patterns that look like secrets but are not (test data, examples)
- **Rotated secrets** - After credential rotation, to prevent re-alerting on history
- **Test fixtures** - Clearly marked fake credentials for testing

### When NOT to Allowlist

- **Active secrets** - Never allowlist secrets that are still in use
- **Convenience** - Do not allowlist to avoid fixing the root cause
- **Whole files** - Avoid broad file exclusions; use specific patterns

### Allowlist Best Practices

```toml
# Good: Specific allowlist with clear reason
[[rules.allowlist]]
description = "Test fixture - fake API key for unit tests"
paths = ['''tests/fixtures/''']
regexes = ['''FAKE_API_KEY_FOR_TESTING''']

# Bad: Overly broad allowlist
[allowlist]
paths = ['''src/''']  # Never do this!
```

## Metrics and Reporting

### Key Metrics

- **Detection rate** - Secrets caught in pre-commit vs CI vs production
- **Time to remediation** - How quickly secrets are rotated after detection
- **False positive rate** - Percentage of alerts that are not real secrets
- **Coverage** - Percentage of repositories with secrets scanning enabled

### Reporting Dashboard

Track over time:

1. Total secrets detected (by type, severity)
2. Mean time to remediation
3. False positive ratio
4. Repositories without scanning
