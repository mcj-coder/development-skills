---
name: observability-logging-baseline
description: Use when establishing observability foundations including structured logging, metrics, and distributed tracing using OpenTelemetry standards.
---

## Core

### When to use

- Any service requiring production-ready observability.
- New services establishing logging, metrics, and tracing patterns.
- Existing services upgrading from unstructured to structured observability.
- Any PR introducing or modifying observability instrumentation.
- Architecture decisions involving monitoring and observability tooling.

### Defaults (strong preference)

- Use **structured logging** with message templates, not string interpolation.
- Prefer **OpenTelemetry** standards over vendor-specific SDKs.
- Implement **RED metrics** (Rate, Errors, Duration) for HTTP endpoints.
- Enable **W3C Trace Context** propagation for distributed tracing.
- Configure **correlation IDs** for request tracing across components.

### Three Pillars of Observability

| Pillar      | Purpose                      | Standard              |
| ----------- | ---------------------------- | --------------------- |
| **Logs**    | Discrete events with context | Structured JSON/text  |
| **Metrics** | Aggregated numerical data    | OpenTelemetry Metrics |
| **Traces**  | Request flow across services | OpenTelemetry Tracing |

### Rationale

- Structured logging enables searching, filtering, and alerting.
- OpenTelemetry provides vendor portability and industry standardisation.
- Correlation IDs enable distributed debugging across service boundaries.
- RED metrics provide consistent service health visibility.
- W3C Trace Context ensures interoperability across systems.

### Review rules

- Reject string interpolation in log messages when structured templates are possible.
- Reject vendor-specific SDKs without OpenTelemetry abstraction layer.
- Reject custom metric naming when semantic conventions exist.
- Require correlation ID propagation for multi-component requests.
- Require log level justification for verbose production logging.

## Load: structured-logging

### Structured Logging Principles

**Message Templates over String Interpolation:**

```csharp
// Correct: Message template with named placeholders
_logger.LogInformation("User {UserId} logged in from {IpAddress}", userId, ipAddress);

// Incorrect: String interpolation loses structure
_logger.LogInformation($"User {userId} logged in from {ipAddress}");
```

**Why structure matters:**

- Enables log aggregation queries: `UserId = "12345"`
- Preserves type information for analysis
- Supports alerting on specific field values
- Reduces log storage through deduplication

### Correlation ID Pattern

Every request should carry a correlation ID:

```csharp
// Middleware to propagate correlation ID
public class CorrelationIdMiddleware
{
    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = context.Request.Headers["X-Correlation-ID"].FirstOrDefault()
            ?? Guid.NewGuid().ToString();

        context.Items["CorrelationId"] = correlationId;
        context.Response.Headers["X-Correlation-ID"] = correlationId;

        using (_logger.BeginScope(new Dictionary<string, object>
        {
            ["CorrelationId"] = correlationId
        }))
        {
            await _next(context);
        }
    }
}
```

### Log Level Semantics

| Level       | Use Case                              | Production Default |
| ----------- | ------------------------------------- | ------------------ |
| Trace       | Detailed debugging (variable values)  | OFF                |
| Debug       | Diagnostic information for developers | OFF                |
| Information | Normal operation markers              | ON                 |
| Warning     | Unexpected but handled conditions     | ON                 |
| Error       | Failures requiring attention          | ON                 |
| Critical    | System-wide failures                  | ON                 |

### Sensitive Data Handling

**Never log:**

- Passwords, API keys, or tokens
- Full credit card numbers
- Personal identification numbers
- Health or financial data (without explicit consent)

**Redaction patterns:**

```csharp
// Mask sensitive fields
_logger.LogInformation("Payment processed for card ending {CardLast4}",
    cardNumber.Substring(cardNumber.Length - 4));

// Use redaction attributes
[LogPropertyIgnore]
public string Password { get; set; }
```

## Load: metrics

### RED Metrics (Golden Signals)

For every HTTP service, implement:

| Metric       | Type      | Description                  |
| ------------ | --------- | ---------------------------- |
| **Rate**     | Counter   | Requests per second          |
| **Errors**   | Counter   | Failed requests (4xx, 5xx)   |
| **Duration** | Histogram | Request latency distribution |

### USE Metrics (Resources)

For infrastructure resources:

| Metric          | Type    | Description               |
| --------------- | ------- | ------------------------- |
| **Utilisation** | Gauge   | Resource usage percentage |
| **Saturation**  | Gauge   | Queue depth, backlog      |
| **Errors**      | Counter | Resource-related failures |

### OpenTelemetry Metrics Setup

```csharp
builder.Services.AddOpenTelemetry()
    .WithMetrics(metrics =>
    {
        metrics
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation()
            .AddRuntimeInstrumentation()
            .AddOtlpExporter();
    });
```

### Metric Naming Conventions

Follow OpenTelemetry semantic conventions:

```text
# Format: <namespace>.<metric_name>_<unit>
http.server.request.duration   (histogram, seconds)
http.server.active_requests    (gauge)
db.client.connections.usage    (gauge)
```

**Avoid:**

- Custom prefixes: `myapp_request_count`
- Inconsistent units: `latency_ms` vs `duration_seconds`
- Vendor-specific names: `datadog.custom.metric`

## Load: tracing

### Distributed Tracing Concepts

| Term        | Definition                                      |
| ----------- | ----------------------------------------------- |
| **Trace**   | End-to-end request journey across services      |
| **Span**    | Single operation within a trace                 |
| **Context** | Trace ID + Span ID propagated across boundaries |

### W3C Trace Context

Standard headers for context propagation:

```http
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01
tracestate: vendor1=value1,vendor2=value2
```

### OpenTelemetry Tracing Setup

```csharp
builder.Services.AddOpenTelemetry()
    .WithTracing(tracing =>
    {
        tracing
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation()
            .AddSqlClientInstrumentation()
            .AddOtlpExporter();
    });
```

### Span Naming Conventions

| Operation Type | Convention                   | Example               |
| -------------- | ---------------------------- | --------------------- |
| HTTP Server    | `{method} {route}`           | `GET /api/users/{id}` |
| HTTP Client    | `HTTP {method}`              | `HTTP POST`           |
| Database       | `{db.system} {db.operation}` | `postgresql SELECT`   |
| Messaging      | `{destination} {operation}`  | `orders.queue send`   |

### Sampling Strategies

| Strategy      | Use Case                                |
| ------------- | --------------------------------------- |
| Always On     | Development, low-volume staging         |
| Probability   | Production (e.g., 10% of requests)      |
| Rate Limiting | High-volume services (N traces/second)  |
| Tail-Based    | Keep traces with errors or high latency |

```csharp
// Probability-based sampling
tracing.SetSampler(new TraceIdRatioBasedSampler(0.1)); // 10% sampling
```

## Load: enforcement

### Review Heuristic: Logging Changes

- If PR adds logging, verify message templates are used (not interpolation).
- If PR adds request handlers, verify correlation ID propagation exists.
- If PR logs user data, verify sensitive field redaction.
- If PR changes log levels, verify production volume impact assessed.

### Review Heuristic: Metrics Changes

- If PR adds metrics, verify semantic convention compliance.
- If PR measures latency, verify histogram is used (not gauge/average).
- If PR adds counters, verify appropriate labels without high cardinality.
- If PR uses vendor SDK, verify OpenTelemetry abstraction considered.

### Review Heuristic: Tracing Changes

- If PR crosses service boundaries, verify context propagation.
- If PR adds manual spans, verify naming follows conventions.
- If PR changes sampling, verify production volume considered.
- If PR adds span attributes, verify no sensitive data included.

### Anti-Patterns to Reject

| Anti-Pattern              | Why It's Problematic                 |
| ------------------------- | ------------------------------------ |
| `$"User {id}"`            | String interpolation loses structure |
| `Console.WriteLine`       | No structure, level, or enrichment   |
| Vendor-specific SDK only  | Creates lock-in, reduces portability |
| Logging PII directly      | Compliance and security risk         |
| Debug level in production | Volume costs and noise               |
| Custom metric names       | Breaks dashboard/alert portability   |
| Missing correlation IDs   | Distributed debugging impossible     |

## Load: advanced

### Observability in Kubernetes

**Container-friendly logging:**

```csharp
// JSON output for container log aggregation
builder.Host.UseSerilog((context, config) =>
{
    config
        .WriteTo.Console(new JsonFormatter())
        .Enrich.WithProperty("ServiceName", "my-api");
});
```

**Resource attributes for K8s:**

```csharp
.ConfigureResource(resource =>
{
    resource
        .AddService("my-api")
        .AddAttributes(new Dictionary<string, object>
        {
            ["k8s.namespace.name"] = Environment.GetEnvironmentVariable("K8S_NAMESPACE"),
            ["k8s.pod.name"] = Environment.GetEnvironmentVariable("K8S_POD_NAME")
        });
});
```

### Exporter Configuration

**OTLP (recommended for portability):**

```csharp
.AddOtlpExporter(options =>
{
    options.Endpoint = new Uri("http://otel-collector:4317");
    options.Protocol = OtlpExportProtocol.Grpc;
});
```

**Direct vendor export (when needed):**

```csharp
// Jaeger, Zipkin, or vendor-specific exporters
// Only use when OTLP collector is not available
.AddJaegerExporter()
```

### Cost and Performance Considerations

| Concern            | Mitigation                                 |
| ------------------ | ------------------------------------------ |
| Log volume         | Appropriate log levels, sampling           |
| Metric cardinality | Limit label values, avoid high-cardinality |
| Trace storage      | Sampling strategies, retention policies    |
| Network overhead   | Batching, compression, local collectors    |

### Incremental Adoption Path

1. **Phase 1: Structured Logging**
   - Convert string interpolation to message templates
   - Add correlation ID middleware
   - Configure JSON output for aggregation

2. **Phase 2: Metrics**
   - Add OpenTelemetry metrics SDK
   - Implement RED metrics for HTTP endpoints
   - Configure OTLP exporter

3. **Phase 3: Tracing**
   - Add OpenTelemetry tracing SDK
   - Enable automatic instrumentation
   - Configure sampling for production

4. **Phase 4: Refinement**
   - Add custom spans for business operations
   - Tune sampling strategies
   - Establish alerting on key signals
