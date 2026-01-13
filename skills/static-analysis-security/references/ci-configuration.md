# CI Configuration for Security Scanning

## GitHub Actions

### Basic SAST Workflow

```yaml
name: Security Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  sast:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Run Semgrep
        uses: returntocorp/semgrep-action@v1
        with:
          config: p/security-audit p/secrets
          generateSarif: true

      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
```

### Multi-Language Security Workflow

```yaml
name: Security Scan

on:
  push:
    branches: [main]
  pull_request:

jobs:
  sast-javascript:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
      - run: npm ci
      - run: npm run lint:security
        # Assumes package.json has: "lint:security": "eslint --config .eslintrc.security.js ."

  sast-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install bandit safety
      - run: bandit -r src/ -f sarif -o bandit.sarif || true
      - run: safety check --full-report

  secrets-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  semgrep:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: returntocorp/semgrep-action@v1
        with:
          config: >
            p/security-audit
            p/secrets
            p/typescript
            p/python
```

### CodeQL Analysis (GitHub Advanced Security)

```yaml
name: CodeQL Analysis

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: "0 6 * * 1"

jobs:
  analyse:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    strategy:
      matrix:
        language: ["javascript", "python"]
    steps:
      - uses: actions/checkout@v4

      - name: Initialise CodeQL
        uses: github/codeql-action/init@v3
        with:
          languages: ${{ matrix.language }}
          queries: +security-extended

      - name: Autobuild
        uses: github/codeql-action/autobuild@v3

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyse@v3
```

## Azure DevOps

### Basic SAST Pipeline

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: "ubuntu-latest"

stages:
  - stage: SecurityScan
    jobs:
      - job: SAST
        steps:
          - task: UsePythonVersion@0
            inputs:
              versionSpec: "3.12"

          - script: |
              pip install bandit semgrep
              bandit -r src/ -f sarif -o $(Build.ArtifactStagingDirectory)/bandit.sarif || true
              semgrep --config p/security-audit --sarif -o $(Build.ArtifactStagingDirectory)/semgrep.sarif .
            displayName: "Run SAST Tools"

          - task: PublishBuildArtifacts@1
            inputs:
              pathToPublish: $(Build.ArtifactStagingDirectory)
              artifactName: security-reports

      - job: Secrets
        steps:
          - script: |
              curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.0/gitleaks_8.18.0_linux_x64.tar.gz | tar xz
              ./gitleaks detect --source . --report-format sarif --report-path gitleaks.sarif
            displayName: "Secrets Scan"
```

### With Microsoft Security DevOps

```yaml
trigger:
  - main

pool:
  vmImage: "ubuntu-latest"

steps:
  - task: MicrosoftSecurityDevOps@1
    displayName: "Microsoft Security DevOps"
    inputs:
      categories: "secrets,code"
```

## GitLab CI

### Basic SAST Configuration

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml

stages:
  - test
  - security

sast:
  stage: security

secret_detection:
  stage: security

custom-semgrep:
  stage: security
  image: returntocorp/semgrep
  script:
    - semgrep --config p/security-audit --sarif -o semgrep.sarif .
  artifacts:
    reports:
      sast: semgrep.sarif
```

## Jenkins

### Declarative Pipeline

```groovy
pipeline {
    agent any

    stages {
        stage('Security Scan') {
            parallel {
                stage('SAST') {
                    steps {
                        sh 'pip install bandit'
                        sh 'bandit -r src/ -f json -o bandit-report.json || true'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'bandit-report.json'
                        }
                    }
                }
                stage('Secrets') {
                    steps {
                        sh 'gitleaks detect --source . --report-format json --report-path gitleaks-report.json || true'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'gitleaks-report.json'
                        }
                    }
                }
            }
        }
    }
}
```

## Common Patterns

### Fail on Severity Threshold

```yaml
# GitHub Actions example
- name: Check SAST Results
  run: |
    CRITICAL=$(jq '[.runs[].results[] | select(.level == "error")] | length' semgrep.sarif)
    if [ "$CRITICAL" -gt 0 ]; then
      echo "::error::Found $CRITICAL critical security findings"
      exit 1
    fi
```

### Baseline Exception Handling

```yaml
# Semgrep with baseline
- name: Run Semgrep with Baseline
  run: |
    semgrep --config p/security-audit \
            --baseline-commit ${{ github.event.pull_request.base.sha }} \
            --sarif -o semgrep.sarif .
```

### Caching SAST Tools

```yaml
# GitHub Actions caching
- name: Cache Semgrep
  uses: actions/cache@v4
  with:
    path: ~/.semgrep
    key: semgrep-${{ runner.os }}

- name: Cache pip packages
  uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: pip-security-${{ hashFiles('**/requirements-security.txt') }}
```

## SARIF Integration

### Unified SARIF Merging

```yaml
- name: Merge SARIF Reports
  run: |
    pip install sarif-tools
    sarif merge bandit.sarif semgrep.sarif gitleaks.sarif -o combined.sarif
```

### Upload to GitHub Security Tab

```yaml
- name: Upload Combined SARIF
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: combined.sarif
    category: security-scan
```
