---
name: dotnet-logging-serilog
description: Standardise logging on ILogger with Serilog as the provider; ensure startup exceptions are logged as Critical.
metadata:
  type: Implementation
  priority: P2
  status: deprecated
  superseded-by: observability-logging-baseline
---

## Overview

This skill standardizes structured logging in .NET applications using `ILogger`/`ILogger<T>`
abstractions with Serilog as the underlying provider. It ensures startup exceptions are logged at
Critical severity for immediate visibility in operational tooling, and provides patterns for
Application Insights and OpenTelemetry integration.

## When to Use

- Building or modifying ASP.NET Core or worker service applications that need structured logging
- Reviewing PRs that touch host startup, logging configuration, or exception handling
- Integrating logging with Azure Application Insights or OpenTelemetry
- Ensuring startup failures are properly captured and visible in monitoring systems

## Core Workflow

1. Configure Serilog as the logging provider during host building with a bootstrap logger for early startup capture
2. Use `ILogger<T>` abstractions in application code (never reference Serilog types directly)
3. Wrap host build/run in try/catch and log startup exceptions at Critical severity
4. Configure appropriate sinks (console for dev, Application Insights or centralized sink for production)
5. Verify structured properties are used instead of string concatenation for operational fields

> **DEPRECATED**: This skill has been consolidated into `observability-logging-baseline`.
>
> - For comprehensive observability guidance (logs, metrics, traces), use
>   **`observability-logging-baseline`**
> - For .NET-specific Serilog patterns, see
>   **`observability-logging-baseline/references/serilog-implementation.md`**
>
> This skill remains for backwards compatibility but will not receive updates.

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

## Verification: fail-fast startup test

### Fail-fast startup test example

Use this test pattern to verify logging is configured correctly and startup failures are captured:

```csharp
[Fact]
public async Task Host_StartupWithLoggingError_LogsExceptionAseCritical()
{
    // Arrange: Create a host with intentionally broken configuration
    var logs = new List<LogEvent>();

    var builder = Host.CreateDefaultBuilder()
        .ConfigureServices(services =>
        {
            services.AddSingleton(new BrokenDependency()); // Throws during startup
        })
        .UseSerilog((context, config) =>
        {
            config
                .MinimumLevel.Debug()
                .WriteTo.Sink(new CollectingSink(logs));
        });

    // Act & Assert: Verify exception is logged as Critical before propagating
    var ex = await Assert.ThrowsAsync<InvalidOperationException>(
        () => builder.Build().RunAsync());

    // Verify Critical-level log entry exists
    var criticalLog = logs.FirstOrDefault(le => le.Level == LogEventLevel.Fatal);
    Assert.NotNull(criticalLog);
    Assert.Contains(typeof(InvalidOperationException).Name, criticalLog.MessageTemplate.Text);
}
```

### Serilog configuration verification pattern

Verify configuration at startup using these checks:

```csharp
// 1. Verify bootstrap logger captures early startup failures
var logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .WriteTo.Console()
    .CreateBootstrapLogger();

try
{
    var host = Host.CreateDefaultBuilder()
        .UseSerilog(logger)
        .ConfigureServices(/* ... */)
        .Build();

    await host.RunAsync();
}
catch (Exception ex)
{
    logger.Fatal(ex, "Host terminated unexpectedly");
    throw;
}

// 2. Verify Application Insights integration (if applicable)
var builder = Host.CreateDefaultBuilder()
    .ConfigureServices(services =>
    {
        services.AddApplicationInsightsTelemetry();
    })
    .UseSerilog((context, config) =>
    {
        var instrumentationKey = context.Configuration["ApplicationInsights:InstrumentationKey"];
        config
            .MinimumLevel.Debug()
            .WriteTo.ApplicationInsights(
                new TelemetryClient(new TelemetryConfiguration(instrumentationKey)),
                TelemetryConverter.Traces);
    });
```

### Test checklist for startup logging

- [ ] Bootstrap logger captures exceptions before host configuration completes
- [ ] Startup exceptions are logged at **Critical** (or **Fatal**) severity
- [ ] Exception details (stack trace, message) are included in the log
- [ ] Correlation/trace IDs are present if available
- [ ] Logs flow to Application Insights (if configured)
- [ ] No startup exceptions are silently swallowed
