# dotnet-logging-serilog - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Direct Serilog Usage in Application Code

**Given** agent WITHOUT dotnet-logging-serilog skill
**And** user has an ASP.NET Core service with logging needs
**When** user says: "Add logging to the CustomerService class"
**Then** record baseline behaviour:

- Does agent use `ILogger<T>` abstraction? (expected: MAYBE - may use Serilog.ILogger directly)
- Does agent inject `Serilog.ILogger` instead of `Microsoft.Extensions.Logging.ILogger`? (expected: YES - common pattern)
- Does agent explain abstraction benefits? (expected: NO - uses whatever works)
- Rationalizations observed: "Serilog is what we're using", "Direct Serilog gives more features"

### Test R2: Missing Startup Exception Logging

**Given** agent WITHOUT dotnet-logging-serilog skill
**And** user is setting up a new ASP.NET Core application
**When** user says: "Configure Serilog for my ASP.NET Core app"
**Then** record baseline behaviour:

- Does agent wrap startup in try/catch? (expected: NO - assumes startup succeeds)
- Does agent configure bootstrap logger? (expected: NO - configures only after host build)
- Does agent log startup failures at Critical? (expected: NO - may only console.write or swallow)
- Rationalizations observed: "Startup errors will show in console", "Host handles exceptions"

### Test R3: Swallowed Unhandled Exceptions

**Given** agent WITHOUT dotnet-logging-serilog skill
**And** user has an API with exception handling middleware
**When** user says: "Add global exception handling to my API"
**Then** record baseline behaviour:

- Does agent log all unhandled exceptions? (expected: PARTIAL - may only return error response)
- Does agent include correlation IDs in exception logs? (expected: NO - not considered)
- Does agent capture sufficient context? (expected: NO - minimal details)
- Rationalizations observed: "Exception middleware returns 500", "Stack trace shows in dev mode"

### Test R4: Missing Azure/Application Insights Integration

**Given** agent WITHOUT dotnet-logging-serilog skill
**And** user deploys to Azure with Application Insights
**When** user says: "Set up Serilog for our Azure-deployed service"
**Then** record baseline behaviour:

- Does agent configure Application Insights sink? (expected: NO - uses console/file sinks only)
- Does agent preserve structured properties for AI? (expected: NO - not considered)
- Does agent maintain severity mapping? (expected: NO - may lose Critical/Error distinction)
- Rationalizations observed: "Console logging works", "AI has its own logging"

### Test R5: String Concatenation Instead of Structured Logging

**Given** agent WITHOUT dotnet-logging-serilog skill
**And** user adds logging to a data processing service
**When** user says: "Add logging to track order processing"
**Then** record baseline behaviour:

- Does agent use structured properties? (expected: NO - uses string interpolation)
- Does agent use message templates with placeholders? (expected: NO - concatenates strings)
- Does agent explain structured logging benefits? (expected: NO - not aware of distinction)
- Rationalizations observed: "String interpolation is cleaner", "Logs look the same"

### Expected Baseline Failures Summary

- [ ] Agent injects `Serilog.ILogger` instead of `ILogger<T>` in application code
- [ ] Agent does not configure bootstrap logger for startup failures
- [ ] Agent does not wrap host startup in try/catch with Critical logging
- [ ] Agent swallows or minimally logs unhandled exceptions
- [ ] Agent does not include correlation IDs in exception logging
- [ ] Agent does not configure Application Insights sink for Azure deployments
- [ ] Agent uses string concatenation instead of structured log properties
- [ ] Agent does not ensure severity mapping consistency

## GREEN Phase - WITH Skill

### Test G1: ILogger Abstraction Usage

**Given** agent WITH dotnet-logging-serilog skill
**When** user says: "Add logging to the OrderProcessor class"
**Then** agent responds with ILogger abstraction approach including:

- Injection of `ILogger<OrderProcessor>` via constructor
- Use of `Microsoft.Extensions.Logging.ILogger` (not Serilog.ILogger)
- Structured logging with message templates
- Proper use of log levels for different scenarios

**And** agent implements:

- Constructor injection of `ILogger<T>`
- Structured log calls with placeholders (not string interpolation)
- Appropriate log levels (Information, Warning, Error)

**Evidence:**

- [ ] `ILogger<T>` injected from `Microsoft.Extensions.Logging`
- [ ] No direct references to `Serilog.ILogger` in application code
- [ ] Message templates use `{PropertyName}` syntax
- [ ] Log levels appropriate to message severity

### Test G2: Startup Exception Logging at Critical Level

**Given** agent WITH dotnet-logging-serilog skill
**When** user says: "Configure Serilog for my ASP.NET Core application"
**Then** agent responds with startup protection including:

- Bootstrap logger configuration before host building
- Try/catch wrapper around host build and run
- Critical/Fatal level logging for startup exceptions
- `Log.CloseAndFlush()` in finally block

**And** agent implements:

- `CreateBootstrapLogger()` early in Program.cs
- Try/catch wrapping entire host lifecycle
- `Log.Fatal(ex, ...)` for startup failures
- Finally block with `Log.CloseAndFlush()`

**Evidence:**

- [ ] Bootstrap logger created before host builder
- [ ] Host build/run wrapped in try/catch
- [ ] Startup exceptions logged at Fatal/Critical level
- [ ] Exception details included in log
- [ ] `Log.CloseAndFlush()` in finally block
- [ ] Exception re-thrown after logging

### Test G3: Unhandled Exception Logging

**Given** agent WITH dotnet-logging-serilog skill
**And** user has an ASP.NET Core API
**When** user says: "Add global exception handling with proper logging"
**Then** agent responds with exception handling approach including:

- Global exception handling middleware configuration
- Logging of all unhandled exceptions at Error/Critical level
- Correlation ID capture and inclusion in logs
- Sufficient context for diagnosis

**And** agent implements:

- Exception middleware registered early in pipeline
- Structured exception logging with context
- Correlation ID retrieval and logging
- No exception swallowing without logging

**Evidence:**

- [ ] Global exception middleware configured
- [ ] Exceptions logged at appropriate severity (Error/Critical)
- [ ] Correlation/trace ID included in logs
- [ ] Exception details (message, stack trace) captured
- [ ] Additional context logged (request path, method)
- [ ] Response returned after logging (not swallowed)

### Test G4: Azure/Application Insights Integration

**Given** agent WITH dotnet-logging-serilog skill
**And** user deploys to Azure with Application Insights
**When** user says: "Configure Serilog for Azure Application Insights integration"
**Then** agent responds with AI integration approach including:

- Application Insights sink configuration
- Severity level mapping to AI telemetry
- Structured property preservation
- Correlation identifier alignment

**And** agent implements:

- `Serilog.Sinks.ApplicationInsights` package usage
- Proper TelemetryClient configuration
- Severity mapping (Fatal -> Critical, Error -> Error, etc.)
- Structured properties preserved in custom dimensions

**Evidence:**

- [ ] Application Insights sink configured
- [ ] Severity levels map correctly to AI severity
- [ ] Structured properties appear in AI custom dimensions
- [ ] Correlation IDs preserved for end-to-end tracing
- [ ] Application code still uses `ILogger<T>` (not AI SDK directly)

### Test G5: OpenTelemetry Integration

**Given** agent WITH dotnet-logging-serilog skill
**And** user has OpenTelemetry configured for tracing
**When** user says: "Integrate Serilog with our OpenTelemetry setup"
**Then** agent responds with OTel integration approach including:

- Serilog participation in OTel pipeline
- Log-trace correlation
- Operation and trace ID alignment
- End-to-end diagnostic support

**And** agent implements:

- OpenTelemetry log exporter configuration
- TraceId/SpanId enrichment in logs
- Correlation with OTel traces
- Proper attribute mapping

**Evidence:**

- [ ] Serilog integrated with OpenTelemetry pipeline
- [ ] Logs contain TraceId and SpanId
- [ ] Logs correlate with distributed traces
- [ ] Application code unchanged (still ILogger)
- [ ] Structured properties mapped to OTel attributes

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Direct Serilog Usage

**Given** agent WITH dotnet-logging-serilog skill
**And** user says: "Serilog.ILogger has more features, just use it directly"
**When** agent is tempted to inject Serilog.ILogger in application code
**Then** agent responds:

- Acknowledges Serilog's rich feature set
- Explains abstraction benefits (testability, provider swapping)
- Shows how ILogger<T> works with Serilog enrichment
- Proposes ILogger<T> with Serilog as provider

**And** agent does NOT:

- Inject `Serilog.ILogger` in application services
- Create custom logging wrappers around Serilog
- Accept "more features" rationalization for tight coupling

### Test P2: Resist Skipping Startup Protection

**Given** agent WITH dotnet-logging-serilog skill
**And** user says: "The host handles exceptions, we don't need try/catch"
**When** agent is tempted to skip startup exception handling
**Then** agent responds:

- Acknowledges host exception handling exists
- Explains startup failures may be silent without bootstrap logger
- Shows Critical-level logging ensures operational visibility
- Proposes try/catch with bootstrap logger

**And** agent does NOT:

- Skip bootstrap logger configuration
- Leave host startup unwrapped
- Accept "host handles it" rationalization
- Log startup failures at non-Critical severity

### Test P3: Resist Exception Swallowing

**Given** agent WITH dotnet-logging-serilog skill
**And** user says: "Just return 500, we don't need to log every exception"
**When** agent is tempted to skip exception logging
**Then** agent responds:

- Acknowledges HTTP 500 response is correct behaviour
- Explains logs are essential for diagnosis without reproduction
- Shows correlation IDs enable request tracing
- Proposes logging before returning error response

**And** agent does NOT:

- Return error responses without logging
- Log exceptions without context
- Skip correlation ID capture
- Accept "500 is enough" rationalization

### Test P4: Resist String Interpolation for Logging

**Given** agent WITH dotnet-logging-serilog skill
**And** user says: "String interpolation is cleaner than message templates"
**When** agent is tempted to use string concatenation in logs
**Then** agent responds:

- Acknowledges interpolation syntax is familiar
- Explains structured logging enables querying by property
- Shows templates preserve property semantics
- Proposes message templates with named placeholders

**And** agent does NOT:

- Use `$"Processing {orderId}"` instead of `"Processing {OrderId}"`
- Lose structured property semantics
- Accept "looks the same" rationalization
- Mix interpolation and templates

## Integration Scenarios

### Test I1: Integration with testing-strategy-dotnet

**Given** agent WITH dotnet-logging-serilog skill
**And** agent WITH testing-strategy-dotnet skill
**When** user says: "Add system tests for OrderService with logging verification"
**Then** agent:

1. Uses ILogger<T> abstraction in OrderService
2. Creates system tests verifying log output
3. Asserts structured properties in logs
4. Verifies no Error/Critical logs on success path

**Evidence:**

- [ ] ILogger<T> used in implementation
- [ ] System tests capture log output
- [ ] Structured properties verified
- [ ] Observability assertions from testing-strategy-dotnet applied

### Test I2: Integration with aspire-integration-testing

**Given** agent WITH dotnet-logging-serilog skill
**And** agent WITH aspire-integration-testing skill
**When** user says: "Write integration tests for distributed order service"
**Then** agent:

1. Configures Serilog for test environment
2. Uses Aspire test host with logging captured
3. Verifies correlation IDs across service boundaries
4. Asserts startup logging present and correct

**Evidence:**

- [ ] Serilog configured for test environment
- [ ] Aspire test host captures logs
- [ ] Correlation IDs verified across services
- [ ] Startup exception handling tested

### Test I3: Integration with superpowers:verification-before-completion

**Given** agent WITH dotnet-logging-serilog skill
**And** agent WITH superpowers:verification-before-completion
**When** logging configuration is "complete"
**Then** agent:

1. Runs application to verify startup logging works
2. Triggers exception to verify exception logging
3. Checks log output for structured properties
4. Provides evidence checklist

**Evidence:**

- [ ] Application started successfully with logging
- [ ] Startup exception scenario verified
- [ ] Exception logging verified with context
- [ ] Evidence provided (not just assertion)

## Rationalizations Closure

### Test RC1: "Serilog.ILogger has more features"

**Given** agent WITH dotnet-logging-serilog skill
**When** rationalization: "Serilog.ILogger has more features than ILogger<T>"
**Then** agent responds:

- "ILogger<T> provides all common logging operations. Serilog enrichment works transparently."
- "Tight coupling to Serilog prevents provider substitution and complicates testing."
- "Advanced Serilog features (sinks, enrichers) are configured at startup, not in application code."

### Test RC2: "Host handles startup exceptions"

**Given** agent WITH dotnet-logging-serilog skill
**When** rationalization: "The host framework handles exceptions, we don't need try/catch"
**Then** agent responds:

- "Exceptions during host building may occur before any logger is configured."
- "Bootstrap logger ensures failures are captured even when main logging isn't ready."
- "Critical-level logging makes startup faults immediately visible in operational dashboards."

### Test RC3: "Returning 500 is enough"

**Given** agent WITH dotnet-logging-serilog skill
**When** rationalization: "Returning HTTP 500 is sufficient error handling"
**Then** agent responds:

- "HTTP 500 tells the client something failed. Logs tell operators what failed."
- "Without logging, reproduction is required for diagnosis. Logs enable post-mortem analysis."
- "Correlation IDs in logs enable tracing requests across distributed systems."

### Test RC4: "String interpolation looks the same"

**Given** agent WITH dotnet-logging-serilog skill
**When** rationalization: "String interpolation produces the same log output"
**Then** agent responds:

- "Output looks similar but semantics differ. Interpolation loses property names."
- "Structured properties enable querying: 'show all logs for OrderId=123'."
- "Message templates are optimized; interpolation allocates strings even when log level is disabled."

### Test RC5: "Azure has its own logging"

**Given** agent WITH dotnet-logging-serilog skill
**When** rationalization: "Application Insights has its own logging, we don't need Serilog integration"
**Then** agent responds:

- "Serilog integration provides consistent structured logging across all sinks."
- "AI sink ensures logs appear in AI with proper severity and correlation."
- "Application code uses ILogger<T>; AI integration is infrastructure concern."

## Verification Assertions

Each GREEN test should verify:

- [ ] Application code uses `ILogger<T>` from `Microsoft.Extensions.Logging`
- [ ] No direct `Serilog.ILogger` references in application services
- [ ] Bootstrap logger configured before host building
- [ ] Host startup wrapped in try/catch with Critical logging
- [ ] Startup exceptions logged at Critical/Fatal level
- [ ] `Log.CloseAndFlush()` called in finally block
- [ ] Unhandled exceptions logged with context
- [ ] Correlation IDs captured in exception logs
- [ ] Structured logging with message templates (not interpolation)
- [ ] Application Insights sink configured for Azure deployments
- [ ] OpenTelemetry integration for correlation (when applicable)
- [ ] Severity mapping consistent across sinks
- [ ] No exception swallowing without logging
- [ ] Evidence checklist provided
