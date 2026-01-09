# Reference: ILogger + Serilog Integration (Startup Critical Logging)

This document supports `dotnet-logging-serilog` and is intended to be loaded on demand.

## Goals

- Application code depends on `Microsoft.Extensions.Logging.ILogger` only.
- Serilog provides structured logging, sinks, and enrichment.
- Startup failures are logged as **Critical** and are not silently lost.

## Canonical pattern (conceptual)

```csharp
using Microsoft.Extensions.Hosting;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateBootstrapLogger();

try
{
    var builder = Host.CreateApplicationBuilder(args);

    builder.Services.AddSerilog((services, lc) => lc
        .ReadFrom.Configuration(builder.Configuration)
        .ReadFrom.Services(services)
        .Enrich.FromLogContext());

    var app = builder.Build();

    await app.RunAsync();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Host terminated unexpectedly"); // treat as Critical/Fatal
    throw;
}
finally
{
    Log.CloseAndFlush();
}
```

## Notes

- Use a bootstrap logger early to capture exceptions during host building.
- Ensure the "startup failure" path logs the exception at the highest severity (Critical/Fatal).
- In ASP.NET Core hosting, an equivalent `WebApplication` pattern is acceptable as long as the same guarantees hold.

## Unhandled exception logging

### Web applications

- Register a global exception handling middleware early in the pipeline.
- Ensure unhandled exceptions are logged at **Error** or **Critical** severity as appropriate.
- Avoid swallowing exceptions without logging.

### Worker / background services

- Wrap top-level execution loops in try/catch blocks.
- Log unhandled exceptions before terminating or restarting the process.

### Notes

- Startup failures should remain **Critical/Fatal**.
- Runtime unhandled exceptions should be logged consistently and with context.

## Azure: Application Insights and OpenTelemetry integration

When running in Azure with Application Insights enabled:

- Configure Serilog to write to Application Insights.
- Ensure severity levels map correctly to App Insights telemetry.
- Preserve structured properties and correlation identifiers.

### OpenTelemetry

- If OpenTelemetry is present, Serilog should integrate with it to:
  - correlate logs with traces,
  - align operation and trace IDs,
  - support end-to-end diagnostics.

### Notes

- Application code must continue to depend only on `ILogger`.
- Azure/App Insights integration is an infrastructure concern and belongs in startup/host configuration.
