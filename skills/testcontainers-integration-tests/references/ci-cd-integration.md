# CI/CD Integration for Testcontainers

## GitHub Actions

### Basic Setup

```yaml
name: Integration Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Pre-pull Docker images
        run: |
          docker pull postgres:15
          docker pull rabbitmq:3.12-management

      - name: Set up .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: "8.0.x"

      - name: Run integration tests
        run: dotnet test --filter "Category=Integration"
```

### Docker-in-Docker (DinD)

GitHub Actions ubuntu-latest has Docker pre-installed. No special configuration needed.

### Parallel Jobs

```yaml
jobs:
  test-postgres:
    runs-on: ubuntu-latest
    steps:
      - name: Pre-pull Postgres
        run: docker pull postgres:15
      - name: Run Postgres tests
        run: dotnet test --filter "Category=Postgres"

  test-rabbitmq:
    runs-on: ubuntu-latest
    steps:
      - name: Pre-pull RabbitMQ
        run: docker pull rabbitmq:3.12-management
      - name: Run RabbitMQ tests
        run: dotnet test --filter "Category=RabbitMQ"
```

## GitLab CI

### Basic Setup

```yaml
integration-tests:
  image: mcr.microsoft.com/dotnet/sdk:8.0
  services:
    - docker:dind
  variables:
    DOCKER_HOST: tcp://docker:2375
    DOCKER_TLS_CERTDIR: ""
  before_script:
    - docker pull postgres:15
    - docker pull rabbitmq:3.12-management
  script:
    - dotnet test --filter "Category=Integration"
```

### Using Docker Socket

```yaml
integration-tests:
  image: mcr.microsoft.com/dotnet/sdk:8.0
  variables:
    DOCKER_HOST: unix:///var/run/docker.sock
  script:
    - dotnet test --filter "Category=Integration"
  tags:
    - docker-socket # Runner with Docker socket mounted
```

## Azure DevOps

### Basic Setup

```yaml
trigger:
  - main

pool:
  vmImage: "ubuntu-latest"

steps:
  - task: Docker@2
    displayName: "Pre-pull Docker images"
    inputs:
      command: "pull"
      arguments: "postgres:15"

  - task: DotNetCoreCLI@2
    displayName: "Run integration tests"
    inputs:
      command: "test"
      arguments: '--filter "Category=Integration"'
```

### Self-Hosted Agent with Docker

For self-hosted agents, ensure Docker is installed and the agent user has Docker permissions:

```bash
sudo usermod -aG docker azdevops
```

## Jenkins

### Pipeline with Docker

```groovy
pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/dotnet/sdk:8.0'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Pre-pull Images') {
            steps {
                sh 'docker pull postgres:15'
                sh 'docker pull rabbitmq:3.12-management'
            }
        }

        stage('Integration Tests') {
            steps {
                sh 'dotnet test --filter "Category=Integration"'
            }
        }
    }
}
```

## CircleCI

### Basic Setup

```yaml
version: 2.1

jobs:
  integration-tests:
    machine:
      image: ubuntu-2204:current
    steps:
      - checkout
      - run:
          name: Pre-pull Docker images
          command: |
            docker pull postgres:15
            docker pull rabbitmq:3.12-management
      - run:
          name: Run integration tests
          command: dotnet test --filter "Category=Integration"

workflows:
  test:
    jobs:
      - integration-tests
```

## Testcontainers Cloud

For environments where Docker is restricted or unavailable:

### Configuration

```bash
# Set environment variable
export TC_CLOUD_TOKEN=your-token

# Or use config file
# ~/.testcontainers.properties
tc.cloud.token=your-token
```

### When to Use

- Corporate environments with Docker restrictions
- Environments without Docker socket access
- Consistent performance across different CI environments

## Common CI Issues and Solutions

### Issue: Container Pull Timeout

**Symptom:** Tests fail with image pull timeout
**Solution:** Pre-pull images in setup step, use specific tags

```yaml
- name: Pre-pull with timeout
  run: docker pull postgres:15
  timeout-minutes: 5
```

### Issue: Port Conflicts

**Symptom:** "Address already in use" errors
**Solution:** Testcontainers uses random ports by default. Ensure you're using `getMappedPort()` not hardcoded ports.

```java
// GOOD: Dynamic port
int port = postgres.getMappedPort(5432);

// BAD: Hardcoded port
int port = 5432;  // May conflict
```

### Issue: Resource Exhaustion

**Symptom:** Tests fail intermittently, Docker daemon unresponsive
**Solution:** Clean up containers, limit parallel jobs, increase CI resources

```yaml
# Cleanup after tests
- name: Docker cleanup
  if: always()
  run: docker system prune -f
```

### Issue: Slow First Test

**Symptom:** First test takes 30+ seconds, subsequent tests fast
**Solution:** Use shared fixture pattern for container reuse

### Issue: Flaky Tests in CI

**Symptom:** Tests pass locally but fail in CI
**Solution:** Check for timing issues, increase wait times, use health checks

```csharp
.WithWaitStrategy(
    Wait.ForUnixContainer()
        .UntilPortIsAvailable(5432)
        .UntilMessageIsLogged("database system is ready to accept connections")
)
```

## CI Resource Requirements

| CI Platform    | Minimum Resources          | Recommended            |
| -------------- | -------------------------- | ---------------------- |
| GitHub Actions | ubuntu-latest (2 CPU, 7GB) | Sufficient             |
| GitLab CI      | Docker-in-Docker           | Medium runner (2+ CPU) |
| Azure DevOps   | ubuntu-latest              | Sufficient             |
| Jenkins        | Docker socket access       | 4GB+ memory            |
| CircleCI       | machine executor           | Large resource class   |

## Performance Optimization Checklist for CI

- [ ] Pre-pull Docker images in setup step
- [ ] Use specific image tags (not `latest`)
- [ ] Implement container reuse (shared fixture)
- [ ] Configure parallel test execution
- [ ] Add Docker cleanup step (always runs)
- [ ] Monitor test execution time
- [ ] Set appropriate timeouts
- [ ] Use health checks for container readiness
