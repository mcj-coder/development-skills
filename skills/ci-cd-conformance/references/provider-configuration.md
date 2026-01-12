# Provider Configuration Guide

## GitHub Actions

### Enable Security Features

```bash
# Enable secret scanning
gh api repos/{owner}/{repo}/vulnerability-alerts -X PUT

# Configure branch protection
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -f required_status_checks[strict]=true \
  -f required_pull_request_reviews[required_approving_review_count]=1

# Verify Dependabot
gh api repos/{owner}/{repo}/automated-security-fixes

# Enable code scanning
gh api repos/{owner}/{repo}/code-scanning/sarif -X GET
```

### Quality Gate Workflow (CI)

```yaml
name: CI
on:
  pull_request:
    branches: [main]

jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - run: npm ci
      - run: npm run lint
      - run: npm test -- --coverage
      - run: npm audit --audit-level=high

      - name: Security scan
        uses: github/codeql-action/analyze@v3
```

### Immutable Release Workflow (CD)

```yaml
name: CD
on:
  push:
    tags: ["v*"]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Configure OIDC
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - run: npm ci && npm run build
      - run: ./deploy.sh
```

### Dependabot Configuration

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "deps"
    groups:
      dependencies:
        patterns: ["*"]
```

## Azure DevOps Pipelines

### Enable Security Features

```bash
# Enable advanced security
az devops security permission update \
  --allow \
  --subject user@contoso.com \
  --token repoV2/{org}/{project}/{repo}

# Configure branch policies
az repos policy create \
  --policy-type build \
  --repository-id {repo-id} \
  --branch main \
  --blocking true \
  --enabled true

# List service connections
az devops service-endpoint list --project {project}
```

### Quality Gate Pipeline

```yaml
# azure-pipelines.yml
trigger:
  - main

pr:
  - main

stages:
  - stage: QualityGates
    jobs:
      - job: Test
        pool:
          vmImage: "ubuntu-latest"
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: "20.x"

          - script: npm ci
            displayName: Install dependencies

          - script: npm run lint
            displayName: Lint

          - script: npm test -- --coverage
            displayName: Test with coverage

          - task: PublishCodeCoverageResults@2
            inputs:
              summaryFileLocation: coverage/cobertura-coverage.xml
              failIfCoverageEmpty: true

          - script: npm audit --audit-level=high
            displayName: Security audit
```

### Tag-Triggered Deployment

```yaml
trigger:
  tags:
    include:
      - "v*"

stages:
  - stage: Deploy
    condition: startsWith(variables['Build.SourceBranch'], 'refs/tags/v')
    jobs:
      - deployment: Production
        environment: production
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureCLI@2
                  inputs:
                    azureSubscription: "managed-identity-connection"
                    scriptType: "bash"
                    scriptLocation: "inlineScript"
                    inlineScript: |
                      npm ci && npm run build
                      ./deploy.sh
```

## GitLab CI

### Enable Security Features

```bash
# Enable security features via API
curl --request PUT \
  --header "PRIVATE-TOKEN: {token}" \
  "https://gitlab.com/api/v4/projects/{id}" \
  --data "security_and_compliance_enabled=true"

# Configure protected branches
glab api projects/{id}/protected_branches \
  --method POST \
  -f name=main \
  -f push_access_level=40 \
  -f merge_access_level=40
```

### Quality Gate Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - test
  - security
  - deploy

variables:
  npm_config_cache: "$CI_PROJECT_DIR/.npm"

cache:
  paths:
    - .npm/
    - node_modules/

test:
  stage: test
  script:
    - npm ci
    - npm run lint
    - npm test -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

sast:
  stage: security
  include:
    - template: Security/SAST.gitlab-ci.yml

dependency_scanning:
  stage: security
  include:
    - template: Security/Dependency-Scanning.gitlab-ci.yml
```

### Tag-Triggered Deployment

```yaml
deploy:
  stage: deploy
  rules:
    - if: $CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/
  environment:
    name: production
  script:
    - npm ci && npm run build
    - ./deploy.sh
```

## Jenkins

### Security Plugin Configuration

Required plugins:

- OWASP Dependency-Check
- SonarQube Scanner
- Credentials Binding
- Pipeline: GitHub

### Quality Gate Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test -- --coverage'
            }
            post {
                always {
                    publishCoverage adapters: [coberturaAdapter('coverage/cobertura-coverage.xml')]
                }
            }
        }

        stage('Security') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP-DC'
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
            }
        }
    }
}
```

### Tag-Triggered Deployment

```groovy
pipeline {
    agent any

    triggers {
        // Trigger on tag creation
        pollSCM('H/5 * * * *')
    }

    when {
        tag pattern: "v\\d+\\.\\d+\\.\\d+", comparator: "REGEXP"
    }

    stages {
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'deploy-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS')]) {
                    sh 'npm ci && npm run build'
                    sh './deploy.sh'
                }
            }
        }
    }
}
```

## OIDC Configuration

### GitHub to Azure (No Long-Lived Secrets)

1. Create Azure AD App Registration
2. Configure federated credentials for GitHub Actions
3. Use `azure/login@v2` with OIDC

```yaml
permissions:
  id-token: write
  contents: read

steps:
  - uses: azure/login@v2
    with:
      client-id: ${{ secrets.AZURE_CLIENT_ID }}
      tenant-id: ${{ secrets.AZURE_TENANT_ID }}
      subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

### GitHub to AWS (No Long-Lived Secrets)

```yaml
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789:role/github-actions
      aws-region: us-east-1
```
