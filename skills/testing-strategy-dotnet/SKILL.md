---
name: testing-strategy-dotnet
description: Use when implementing or reviewing a .NET testing approach with unit, system, and E2E tiers, BDD practices, architecture enforcement, contract versioning, and strict observability rules.
---

# Testing Strategy (.NET Opinionated)

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
