# Serilog Implementation for .NET

This reference provides .NET-specific guidance for implementing structured logging with Serilog,
complementing the platform-agnostic guidance in the main observability-logging-baseline skill.

## Overview

Serilog is the recommended logging provider for .NET applications. It provides:

- Structured logging with message templates
- Rich sink ecosystem for log destinations
- Enrichers for contextual data
- Integration with Microsoft.Extensions.Logging

## Core Principles

### ILogger Abstraction

Application code must depend on `Microsoft.Extensions.Logging.ILogger` only:

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

**Review rule**: Reject PRs that inject/use `Serilog.ILogger` directly in application code
when `Microsoft.Extensions.Logging.ILogger` suffices.

### Startup Exception Logging

Exceptions during host startup must be logged at **Critical** severity:

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
    Log.Fatal(ex, "Host terminated unexpectedly");
    throw;
}
finally
{
    Log.CloseAndFlush();
}
```

**Key points:**

- Use a bootstrap logger early to capture exceptions during host building
- Log startup failures at Critical/Fatal severity
- Ensure `Log.CloseAndFlush()` is called to flush buffered logs

## Azure Integration

### Application Insights

When running in Azure with Application Insights enabled:

```csharp
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

**Requirements:**

- Severity levels must map correctly to App Insights telemetry
- Structured log properties must be preserved
- Correlation/trace identifiers must be maintained

### OpenTelemetry Integration

When OpenTelemetry is present, configure Serilog to participate in the telemetry pipeline:

- Correlate logs with traces
- Align operation and trace IDs
- Support end-to-end diagnostics

## Unhandled Exception Handling

### Web Applications

Register global exception handling middleware early in the pipeline:

```csharp
app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        var exceptionHandler = context.Features.Get<IExceptionHandlerFeature>();

        if (exceptionHandler?.Error != null)
        {
            logger.LogError(exceptionHandler.Error,
                "Unhandled exception for {Method} {Path}",
                context.Request.Method,
                context.Request.Path);
        }

        context.Response.StatusCode = 500;
        await context.Response.WriteAsync("An error occurred");
    });
});
```

### Worker Services

Wrap top-level execution loops:

```csharp
protected override async Task ExecuteAsync(CancellationToken stoppingToken)
{
    while (!stoppingToken.IsCancellationRequested)
    {
        try
        {
            await DoWorkAsync(stoppingToken);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            _logger.LogError(ex, "Error in worker execution");
            await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
        }
    }
}
```

## Verification

### Fail-Fast Startup Test

```csharp
[Fact]
public async Task Host_StartupWithLoggingError_LogsExceptionAsCritical()
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

### Startup Logging Checklist

- [ ] Bootstrap logger captures exceptions before host configuration completes
- [ ] Startup exceptions are logged at **Critical** (or **Fatal**) severity
- [ ] Exception details (stack trace, message) are included in the log
- [ ] Correlation/trace IDs are present if available
- [ ] Logs flow to Application Insights (if configured)
- [ ] No startup exceptions are silently swallowed

## Operational Hygiene

### Enrichment

```csharp
.Enrich.FromLogContext()
.Enrich.WithMachineName()
.Enrich.WithEnvironmentName()
.Enrich.WithProperty("Application", "MyApp")
```

### PII Redaction

Enforce PII/secret redaction policies:

```csharp
.Destructure.ByTransforming<CreditCard>(cc => new
{
    Last4 = cc.Number.Substring(cc.Number.Length - 4),
    cc.ExpiryMonth,
    cc.ExpiryYear
})
```

### Sink Configuration

| Environment | Recommended Sinks                          |
| ----------- | ------------------------------------------ |
| Local/Dev   | Console (coloured, structured)             |
| Staging     | Console + File + Centralized (e.g., Seq)   |
| Production  | Centralized sink (Seq, App Insights, etc.) |

## Review Rules

- Reject PRs that inject/use `Serilog.ILogger` directly when `ILogger` suffices
- Reject PRs that swallow startup exceptions without Critical-level logging
- Ensure logs are structured (properties) rather than string concatenation
- Verify startup failures are captured by bootstrap logger
