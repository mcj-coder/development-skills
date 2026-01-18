---
name: testing-strategy-dotnet
description: Use when implementing or reviewing a .NET testing approach with unit, system, and E2E tiers, BDD practices, architecture enforcement, contract versioning, and strict observability rules.
metadata:
  type: Implementation
  priority: P1
---

# Testing Strategy (.NET Opinionated)

## Overview

Define a consistent .NET testing architecture with clear project naming conventions, tiered
testing (unit, system, E2E), BDD practices using Reqnroll, architecture enforcement with
NetArchTest, and public API governance for published libraries. Enforces observability
criteria and payload logging constraints.

## When to Use

- Implementing or reviewing a .NET testing approach for a new solution
- Establishing test project naming and colocation conventions
- Introducing tiered testing (unit, system, E2E) to an existing codebase
- Adding architecture tests to enforce structural patterns
- Reviewing test tier selection and mocking boundaries in PRs
- Configuring CI pipelines for test execution

## Core Workflow

1. Create test projects following naming conventions (ComponentName.UnitTest, ComponentName.SystemTest, ComponentName.E2E)
2. Colocate test projects with the component they validate
3. Implement unit tests with xUnit and Moq for isolated class/method testing
4. Implement system tests with BDD style (Reqnroll) mocking only external dependencies
5. Implement E2E tests with Testcontainers for transient infrastructure
6. Add architecture tests using NetArchTest to enforce layering rules
7. Configure CI matrix to run appropriate test tiers per stage (PR, mainline, post-deploy)

## Intent

Define a consistent .NET testing architecture with:

- clear project naming/colocation conventions,
- method-level unit tests with Moq,
- BDD-style system and E2E tests,
- containerised dependencies for realistic but repeatable integration,
- **architecture testing** to prevent structural drift,
- and **public API/contract governance** for published libraries and service contracts.

## References (primary)

- [NetArchTest.Rules](https://github.com/BenMorris/NetArchTest)
- [ArchUnitNET](https://github.com/TNG/ArchUnitNET)
- [.NET API compatibility tooling](https://learn.microsoft.com/dotnet/fundamentals/apicompat/overview)
- [Microsoft.DotNet.ApiCompat.Tool](https://learn.microsoft.com/dotnet/fundamentals/apicompat/global-tool)
- [Public API analyzers (Roslyn)](https://www.nuget.org/packages/Microsoft.CodeAnalysis.PublicApiAnalyzers/)

---

## Project Conventions (Hard Requirements)

### Naming & Colocation

- Unit tests: `<SolutionName>.<ComponentName>.UnitTest`
- System tests: `<SolutionName>.<ComponentName>.SystemTest`
- Component E2E tests: `<SolutionName>.<ComponentName>.E2E`
- Repo-level E2E tests: `<SolutionName>.E2E`

Test projects are colocated with the project they validate (same solution folder scope).

---

## Test Tiers

### `<SolutionName>.<ComponentName>.UnitTest` (xUnit + Moq)

- Class and method-level tests.
- Moq for dependency mocking.
- No external I/O.

### `<SolutionName>.<ComponentName>.SystemTest` (BDD style)

- BDD style using Reqnroll.
- Mock/stub **external dependencies only**.
- Real internal wiring (DI, pipeline, domain logic).
- Includes **observability assertions**.

### `<SolutionName>.<ComponentName>.E2E` (BDD style)

- BDD style using Reqnroll.
- Testcontainers for transient dependencies (ephemeral DB/queues/caches).
- Playwright for UI integration where applicable.
- Strong data isolation; component E2E may inspect container state; repo-level E2E is black box.

---

## Architecture Testing (.NET) (Hard Requirements)

Architecture tests must exist to enforce solution structure and architecture patterns. Only require
additional tests for new architecture patterns being implemented, ie new architectural tests should
not be required for each vertical slice API added.

### Recommended libraries

- NetArchTest.eNhancedEdition (fluent rules for conventions and dependencies)
- ArchUnitNET (architecture rules over imported assemblies)

### Minimum rule set (baseline)

- Layering rules (e.g., Domain has no dependency on Infrastructure/Web).
- Prevent forbidden dependencies (e.g., EF Core types in Domain).
- Prevent cyclic dependencies between projects/namespaces.
- Enforce namespace/folder conventions for slices/modules.
- Enforce test project conventions (e.g., SystemTest projects must not reference mocks of internal
  collaborators; E2E black box must not reference internal projects).

### Placement and execution

- Prefer a dedicated architecture test project `<SolutionName>.ArchitectureTest` that runs in PR gates alongside Unit Tests.
- Baseline legacy violations explicitly; fail on new violations

#### Example: NetArchTest.eNhancedEdition layering rule (sketch)

```csharp
// Domain should not depend on Infrastructure
var result = Types.InAssembly(typeof(MyDomainMarker).Assembly)
    .That()
    .ResideInNamespace("MyCompany.MyApp.Domain", true)
    .ShouldNot()
    .HaveDependencyOn("MyCompany.MyApp.Infrastructure")
    .GetResult();

Assert.True(result.IsSuccessful, result.GetFailureReport());
```

---

## Contract Versioning & Public Interfaces (Published Libraries) (Hard Requirements)

### Public API governance (libraries)

Published libraries must prevent accidental public surface changes and enforce compatibility discipline.

#### Required controls

- Track public surface (e.g., shipped/unshipped API files via analyzers).
- Run API compatibility checks against a baseline for releases and/or PR gates.
- Require explicit versioning policy decisions for breaking changes.

#### Recommended tooling

- `Microsoft.CodeAnalysis.PublicApiAnalyzers` to track public APIs (Shipped/Unshipped text files).
- `Microsoft.DotNet.ApiCompat.Tool` (or MSBuild tasks) to compare assemblies/packages against a baseline.

### Service/API contracts (systems)

- Contracts must be versioned explicitly.
- System and E2E tests must validate version negotiation/fallback where supported.
- Breaking contract changes must be introduced via new versioned endpoints/messages, with migration guidance.

---

## Observability Criteria (System & E2E) (Hard Requirements)

### Mandatory rules

- Correlation/trace ID propagated per scenario/journey.
- Structured logs for failures with error classification.
- Successful scenarios emit no unexpected `Error`/`Critical` logs.

### Payload Logging Constraints (Hard Rule)

- Full request/response payloads MUST be logged only at `Debug` or `Trace`.
- `Info`/`Warn`/`Error`/`Critical` logs must be summary-only (no raw bodies).
- No secrets or sensitive data in logs (even at `Debug`/`Trace` unless explicitly redacted).
- Avoid destructuring large request/response models at `Info`+.

### Repo-level E2E (Black Box) observability

- Validate externally observable diagnostics only:
  - correlation IDs returned or otherwise retrievable,
  - correct status codes/error responses,
  - ability to correlate to operational telemetry in the deployed environment.

---

## Repo-level E2E Sub-types (Hard Requirements)

### Read-only Smoke Tests (Production-safe)

- BDD tagged, e.g., `@smoke @readonly`.
- Must not create/update/delete production data.
- Validate availability and key read-only journeys.

### Key End-to-End Journeys (Data-safe mutation)

- BDD tagged, e.g., `@journey`.
- Only in environments where test-owned data is permitted (staging/ephemeral/prod-sandbox).
- Under no circumstances may tests impact data not created by the test itself.

---

## CI Expectations

- PR: `<SolutionName>.<ComponentName>.UnitTest` always;
  `<SolutionName>.<ComponentName>.SystemTest` when integration boundaries change;
  selective component `<SolutionName>.<ComponentName>.E2E` as tagged subset.
- Mainline: full unit + system + component E2E.
- Post-deploy: repo-level read-only smoke against production.
- Capture diagnostic artifacts for System/E2E failures:
  - service logs (structured),
  - traces (where available),
  - Playwright screenshots/videos/traces for UI failures.

---

## Review Heuristics

- Correct tier selection and mocking boundaries.
- Architecture rules: layering and dependency constraints preserved; no new violations.
- Contracts/public APIs: intentional change, versioned, compatible, and checked automatically.
- Diagnosability: failures are explainable from logs/traces without payload dumps.
- Payload discipline: full payloads restricted to `Debug`/`Trace` only.

## Example Solution Structure

```text
MyCompany.OrderService/
├── src/
│   ├── MyCompany.OrderService.Domain/
│   │   ├── Orders/
│   │   │   ├── Order.cs
│   │   │   ├── OrderItem.cs
│   │   │   └── IOrderRepository.cs
│   │   └── MyCompany.OrderService.Domain.csproj
│   │
│   ├── MyCompany.OrderService.Application/
│   │   ├── Orders/
│   │   │   ├── Commands/
│   │   │   │   ├── CreateOrderCommand.cs
│   │   │   │   └── CreateOrderCommandHandler.cs
│   │   │   └── Queries/
│   │   │       ├── GetOrderQuery.cs
│   │   │       └── GetOrderQueryHandler.cs
│   │   └── MyCompany.OrderService.Application.csproj
│   │
│   ├── MyCompany.OrderService.Infrastructure/
│   │   ├── Persistence/
│   │   │   ├── OrderRepository.cs
│   │   │   └── AppDbContext.cs
│   │   └── MyCompany.OrderService.Infrastructure.csproj
│   │
│   └── MyCompany.OrderService.WebApi/
│       ├── Controllers/
│       │   └── OrdersController.cs
│       ├── Program.cs
│       └── MyCompany.OrderService.WebApi.csproj
│
├── tests/
│   ├── MyCompany.OrderService.Domain.UnitTest/
│   │   ├── Orders/
│   │   │   └── OrderTests.cs
│   │   └── MyCompany.OrderService.Domain.UnitTest.csproj
│   │
│   ├── MyCompany.OrderService.Application.UnitTest/
│   │   ├── Orders/
│   │   │   └── CreateOrderCommandHandlerTests.cs
│   │   └── MyCompany.OrderService.Application.UnitTest.csproj
│   │
│   ├── MyCompany.OrderService.WebApi.SystemTest/
│   │   ├── Features/
│   │   │   └── Orders/
│   │   │       ├── CreateOrder.feature
│   │   │       └── CreateOrderSteps.cs
│   │   ├── Fixtures/
│   │   │   └── WebApiFixture.cs
│   │   └── MyCompany.OrderService.WebApi.SystemTest.csproj
│   │
│   ├── MyCompany.OrderService.WebApi.E2E/
│   │   ├── Features/
│   │   │   └── OrderJourney.feature
│   │   ├── Fixtures/
│   │   │   ├── PostgresFixture.cs
│   │   │   └── E2EFixture.cs
│   │   └── MyCompany.OrderService.WebApi.E2E.csproj
│   │
│   ├── MyCompany.OrderService.E2E/
│   │   ├── Features/
│   │   │   ├── SmokeTests.feature
│   │   │   └── KeyJourneys.feature
│   │   └── MyCompany.OrderService.E2E.csproj
│   │
│   └── MyCompany.OrderService.ArchitectureTest/
│       ├── LayeringTests.cs
│       ├── NamingConventionTests.cs
│       └── MyCompany.OrderService.ArchitectureTest.csproj
│
├── MyCompany.OrderService.sln
└── Directory.Build.props
```

### Project References

```text
Domain.UnitTest         → Domain
Application.UnitTest    → Application, Domain
WebApi.SystemTest       → WebApi, Application, Domain (stubs external only)
WebApi.E2E              → WebApi (via HTTP, no direct reference)
OrderService.E2E        → None (black box, HTTP only)
ArchitectureTest        → All src projects (reflection-based)
```

## Sample CI Matrix

### GitHub Actions

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  DOTNET_VERSION: "8.0.x"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore --configuration Release

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build
          path: |
            **/bin/Release/**
            !**/obj/**

  unit-tests:
    needs: build
    runs-on: ubuntu-latest
    strategy:
      matrix:
        project:
          - MyCompany.OrderService.Domain.UnitTest
          - MyCompany.OrderService.Application.UnitTest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Run unit tests
        run: |
          dotnet test tests/${{ matrix.project }}/${{ matrix.project }}.csproj \
            --configuration Release \
            --logger "trx;LogFileName=results.trx" \
            --collect:"XPlat Code Coverage"

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results-${{ matrix.project }}
          path: tests/${{ matrix.project }}/TestResults/

  architecture-tests:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Run architecture tests
        run: |
          dotnet test tests/MyCompany.OrderService.ArchitectureTest/ \
            --configuration Release \
            --logger "trx;LogFileName=results.trx"

  system-tests:
    needs: [unit-tests, architecture-tests]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Run system tests
        run: |
          dotnet test tests/MyCompany.OrderService.WebApi.SystemTest/ \
            --configuration Release \
            --logger "trx;LogFileName=results.trx"

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: system-test-results
          path: tests/MyCompany.OrderService.WebApi.SystemTest/TestResults/

  component-e2e:
    needs: system-tests
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: testpass
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Run component E2E tests
        run: |
          dotnet test tests/MyCompany.OrderService.WebApi.E2E/ \
            --configuration Release \
            --logger "trx;LogFileName=results.trx" \
            --filter "Category!=Smoke"

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: e2e-test-results
          path: tests/MyCompany.OrderService.WebApi.E2E/TestResults/

  # Mainline only: full repo-level E2E
  repo-e2e:
    if: github.ref == 'refs/heads/main'
    needs: component-e2e
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Run repo-level E2E tests
        run: |
          dotnet test tests/MyCompany.OrderService.E2E/ \
            --configuration Release \
            --logger "trx;LogFileName=results.trx"
```

### Azure DevOps

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main

pool:
  vmImage: "ubuntu-latest"

variables:
  dotnetVersion: "8.0.x"
  buildConfiguration: "Release"

stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - task: UseDotNet@2
            inputs:
              version: $(dotnetVersion)

          - script: dotnet build --configuration $(buildConfiguration)
            displayName: Build

          - publish: $(System.DefaultWorkingDirectory)
            artifact: build

  - stage: Test
    dependsOn: Build
    jobs:
      - job: UnitTests
        strategy:
          matrix:
            Domain:
              project: "MyCompany.OrderService.Domain.UnitTest"
            Application:
              project: "MyCompany.OrderService.Application.UnitTest"
        steps:
          - task: UseDotNet@2
            inputs:
              version: $(dotnetVersion)

          - script: |
              dotnet test tests/$(project)/$(project).csproj \
                --configuration $(buildConfiguration) \
                --logger trx \
                --collect:"XPlat Code Coverage"
            displayName: Run $(project)

          - task: PublishTestResults@2
            inputs:
              testResultsFormat: "VSTest"
              testResultsFiles: "**/TestResults/*.trx"

      - job: ArchitectureTests
        steps:
          - task: UseDotNet@2
            inputs:
              version: $(dotnetVersion)

          - script: |
              dotnet test tests/MyCompany.OrderService.ArchitectureTest/ \
                --configuration $(buildConfiguration)
            displayName: Run architecture tests

      - job: SystemTests
        dependsOn: [UnitTests, ArchitectureTests]
        steps:
          - task: UseDotNet@2
            inputs:
              version: $(dotnetVersion)

          - script: |
              dotnet test tests/MyCompany.OrderService.WebApi.SystemTest/ \
                --configuration $(buildConfiguration) \
                --logger trx
            displayName: Run system tests

          - task: PublishTestResults@2
            inputs:
              testResultsFormat: "VSTest"
              testResultsFiles: "**/TestResults/*.trx"

  - stage: E2E
    dependsOn: Test
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - job: ComponentE2E
        services:
          postgres:
            image: postgres:15
            ports:
              - 5432:5432
        steps:
          - task: UseDotNet@2
            inputs:
              version: $(dotnetVersion)

          - script: |
              dotnet test tests/MyCompany.OrderService.WebApi.E2E/ \
                --configuration $(buildConfiguration)
            displayName: Run component E2E tests
```

### CI Matrix Summary

| Stage              | PR             | Mainline | Post-Deploy  |
| ------------------ | -------------- | -------- | ------------ |
| Build              | Yes            | Yes      | N/A          |
| Unit Tests         | Yes (parallel) | Yes      | N/A          |
| Architecture Tests | Yes            | Yes      | N/A          |
| System Tests       | Yes            | Yes      | N/A          |
| Component E2E      | Subset         | Full     | N/A          |
| Repo-level E2E     | No             | Full     | N/A          |
| Smoke Tests        | No             | No       | Yes (@smoke) |

### Test Execution Order

```text
1. Build
   └─► Compile all projects

2. Unit Tests (parallel)
   ├─► Domain.UnitTest
   └─► Application.UnitTest

3. Architecture Tests (parallel with Unit)
   └─► ArchitectureTest

4. System Tests (after Unit + Arch pass)
   └─► WebApi.SystemTest

5. Component E2E (after System pass)
   └─► WebApi.E2E

6. Repo-level E2E (mainline only, after Component E2E)
   └─► OrderService.E2E
```

### Diagnostic Artifact Collection

```yaml
# Add to each test job for failure diagnostics
- name: Collect diagnostics on failure
  if: failure()
  run: |
    mkdir -p diagnostics
    # Collect structured logs
    cp -r logs/*.json diagnostics/ 2>/dev/null || true
    # Collect traces
    cp -r traces/*.otlp diagnostics/ 2>/dev/null || true
    # Collect Playwright artifacts (if UI tests)
    cp -r playwright-report/ diagnostics/ 2>/dev/null || true

- name: Upload diagnostics
  if: failure()
  uses: actions/upload-artifact@v4
  with:
    name: diagnostics-${{ github.job }}
    path: diagnostics/
    retention-days: 7
```

## Red Flags - STOP

These statements indicate testing strategy misalignment:

| Thought                            | Reality                                                      |
| ---------------------------------- | ------------------------------------------------------------ |
| "Unit tests are enough"            | System and E2E tests catch integration issues; use all tiers |
| "Mock everything"                  | Mock external dependencies only; real wiring catches bugs    |
| "Architecture tests are overkill"  | Prevent structural drift; enforce layering from the start    |
| "API compatibility doesn't matter" | Breaking changes hurt consumers; track public surface        |
| "Payload logging at Info is fine"  | Full payloads at Debug/Trace only; avoid noise               |
| "Skip observability assertions"    | Verify correlation IDs and structured logs in tests          |
