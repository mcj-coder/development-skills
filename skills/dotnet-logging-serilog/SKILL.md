---
name: dotnet-logging-serilog
description: Standardise logging on ILogger with Serilog as the provider; ensure startup exceptions are logged as Critical.
---

## Core

### When to use

- Any ASP.NET Core / worker service needing structured logging.
- Any PR touching host startup, logging configuration, bootstrap code, exception handling, or deployment diagnostics.

### Defaults (non-negotiable)

- Application code must depend on the standard **`ILogger` / `ILogger<T>`** abstractions.
- Use **Serilog** as the logging provider/integration to enable structured logging and sinks.
- Do not introduce alternative logging abstractions or bespoke wrappers unless strictly necessary and justified.

### Startup exception severity

- Exceptions occurring during **host startup** (before the app is serving traffic) must be logged at **Critical** severity.
- The goal is to ensure "fail-fast" startup faults are immediately visible in operational tooling.

### Azure / Application Insights integration (default when applicable)

- If the solution is deployed to **Azure** and **Application Insights** is available:
  - Serilog **must** be integrated with Application Insights.
  - Logs should flow to Application Insights with appropriate severity mapping.
- If **OpenTelemetry** is available in the solution:
  - Serilog **should** participate in the OpenTelemetry pipeline for correlation with traces and metrics.
- Integration must preserve:
  - structured log properties,
  - correlation/trace identifiers,
  - and severity consistency.

### Unhandled exception handling

- Unhandled exceptions occurring during request processing or background execution **must be logged**.
- Logging must capture:
  - exception details,
  - correlation/trace identifiers where available,
  - and sufficient context to diagnose the failure.
- For web applications, this typically implies a global exception handling middleware.
- For worker services, this implies a top-level execution wrapper or equivalent host-level handling.

### Review rules

- Reject PRs that inject/use `Serilog.ILogger` directly in application code when
  `Microsoft.Extensions.Logging.ILogger` suffices.
- Reject PRs that swallow startup exceptions or only write them to console without Critical-level logging.
- Ensure logs are structured (properties) rather than string concatenation for key operational fields.

## Load: examples

### Use ILogger in application code (conceptual)

```csharp
public sealed class CustomerService
{
    private readonly ILogger<CustomerService> _logger;

    public CustomerService(ILogger<CustomerService> logger) => _logger = logger;

    public void DoWork(CustomerId id)
    {
        _logger.LogInformation("Processing customer {CustomerId}", id);
    }
}
```

### Serilog integration at host startup (conceptual)

- Configure Serilog as the logging provider during host building.
- Ensure a bootstrap logger exists early enough to capture startup failures.
- Wrap host build/run in a try/catch and log exceptions as **Critical** before rethrowing.

## Load: advanced

### Operational hygiene

- Enrich logs with correlation IDs / trace IDs where available.
- Ensure PII/secret redaction policies are enforced.
- Use sink configuration appropriate to the environment (console for local/dev, centralized sink for shared envs).

### Determinism and performance

- Prefer structured properties over string interpolation for high-volume logs.
- Avoid logging large payloads by default; log identifiers and summary fields.

## Load: enforcement

### Review heuristic: logging integration

- If application code references `Serilog.*` types, require refactor to `ILogger` unless there is a strong justification.
- If host startup uses Serilog, verify startup failures are logged as **Critical** with exception details.
- Verify critical configuration is applied early enough to capture exceptions thrown during host building.
