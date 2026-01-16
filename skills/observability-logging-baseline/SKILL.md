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

## Minimal Validation Checklist

Use this checklist to verify observability is correctly configured:

### Structured Logging Validation

- [ ] Log entry contains structured fields (not just message string)
- [ ] Correlation ID present in all request-scoped logs
- [ ] Log level appropriate for message type
- [ ] No PII or sensitive data in logs

**Sample log entry to verify:**

```json
{
  "timestamp": "2024-01-15T10:30:45.123Z",
  "level": "Information",
  "message": "User logged in successfully",
  "properties": {
    "UserId": "usr_12345",
    "IpAddress": "192.168.1.100",
    "CorrelationId": "abc-123-def-456",
    "ServiceName": "auth-api"
  }
}
```

**Validation command:**

```bash
# Check log output format
curl -s http://localhost:5000/api/health | jq .
# Then check application logs for structured output

# Verify correlation ID propagation
curl -H "X-Correlation-ID: test-123" http://localhost:5000/api/users/1
# Check logs contain "CorrelationId": "test-123"
```

### Metrics Validation

- [ ] RED metrics exposed for HTTP endpoints
- [ ] Metric names follow semantic conventions
- [ ] Labels have bounded cardinality
- [ ] Metrics endpoint accessible

**Sample metric names to verify:**

```text
http_server_request_duration_seconds_bucket{method="GET",route="/api/users/{id}",status="200",le="0.1"}
http_server_request_duration_seconds_count{method="GET",route="/api/users/{id}",status="200"}
http_server_active_requests{method="GET"}
```

**Validation command:**

```bash
# Check metrics endpoint
curl -s http://localhost:5000/metrics | grep http_server

# Verify histogram buckets exist
curl -s http://localhost:5000/metrics | grep "_bucket"

# Check for high-cardinality labels (should NOT see user IDs, request IDs, etc.)
curl -s http://localhost:5000/metrics | grep -E "user_id|request_id"
# Should return nothing
```

### Trace Propagation Validation

- [ ] W3C traceparent header propagated
- [ ] Spans created for HTTP requests
- [ ] Database operations create child spans
- [ ] Cross-service traces connected

**Sample trace header:**

```text
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01
tracestate: myvendor=value
```

**Validation command:**

```bash
# Verify trace context propagation
# Make request with traceparent header
curl -H "traceparent: 00-12345678901234567890123456789012-1234567890123456-01" \
     -v http://localhost:5000/api/users/1 2>&1 | grep -i traceparent

# Check response includes traceparent
# Verify downstream services receive same trace ID

# Check OTLP exporter connectivity
curl -s http://localhost:4317/health  # gRPC health check
curl -s http://localhost:4318/health  # HTTP health check
```

### Quick Validation Script

```bash
#!/bin/bash
# validate-observability.sh

SERVICE_URL="${1:-http://localhost:5000}"
ERRORS=0

echo "=== Observability Validation ==="
echo "Service: $SERVICE_URL"
echo ""

# Test 1: Metrics endpoint
echo "1. Checking metrics endpoint..."
if curl -sf "$SERVICE_URL/metrics" > /dev/null; then
  echo "   ✓ Metrics endpoint accessible"

  # Check for RED metrics
  if curl -sf "$SERVICE_URL/metrics" | grep -q "http_server_request_duration"; then
    echo "   ✓ Duration metric present"
  else
    echo "   ✗ Duration metric missing"
    ((ERRORS++))
  fi
else
  echo "   ✗ Metrics endpoint not accessible"
  ((ERRORS++))
fi

# Test 2: Correlation ID propagation
echo ""
echo "2. Checking correlation ID propagation..."
CORRELATION_ID="test-$(date +%s)"
RESPONSE=$(curl -sf -H "X-Correlation-ID: $CORRELATION_ID" "$SERVICE_URL/api/health" -i 2>&1)
if echo "$RESPONSE" | grep -qi "x-correlation-id"; then
  echo "   ✓ Correlation ID returned in response"
else
  echo "   ✗ Correlation ID not propagated"
  ((ERRORS++))
fi

# Test 3: Trace context
echo ""
echo "3. Checking trace context propagation..."
TRACE_ID="12345678901234567890123456789012"
RESPONSE=$(curl -sf -H "traceparent: 00-$TRACE_ID-1234567890123456-01" \
                "$SERVICE_URL/api/health" -i 2>&1)
if echo "$RESPONSE" | grep -qi "traceparent"; then
  echo "   ✓ Trace context propagated"
else
  echo "   ⚠ Trace context not in response headers (may be logged internally)"
fi

# Summary
echo ""
echo "=== Summary ==="
if [ $ERRORS -eq 0 ]; then
  echo "✓ All validations passed"
  exit 0
else
  echo "✗ $ERRORS validation(s) failed"
  exit 1
fi
```

### Evidence Template

````markdown
# Observability Validation Evidence

**Service**: [service-name]
**Date**: YYYY-MM-DD
**Validator**: [name]

## Logging

- [x] Structured logging configured
- [x] Correlation ID middleware active
- [x] Log level: Information (production)

**Sample log entry:**
[paste actual log entry here]

## Metrics

- [x] Metrics endpoint: /metrics
- [x] RED metrics present
- [x] No high-cardinality labels

**Metrics output:**

```text
[paste relevant metrics here]
```

## Tracing

- [x] OpenTelemetry SDK configured
- [x] W3C Trace Context propagation
- [x] Sampling: 10% (production)

**Trace verification:**
[paste trace ID and verification steps]
````
