# observability-logging-baseline - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Unstructured Logging Implementation

**Given** agent WITHOUT observability-logging-baseline skill
**And** user says: "Add logging to our API service"
**When** agent implements logging
**Then** record baseline behaviour:

- Does agent use structured logging? (expected: NO - uses string interpolation)
- Does agent consider correlation IDs? (expected: NO - no request tracing)
- Does agent configure log levels appropriately? (expected: NO - logs everything)
- Rationalizations observed: "Console.WriteLine is fine", "We'll add structure later"

### Test R2: Missing Metrics Foundation

**Given** agent WITHOUT observability-logging-baseline skill
**And** user says: "I need to monitor our service performance"
**When** agent discusses monitoring
**Then** record baseline behaviour:

- Does agent mention RED metrics? (expected: NO - ad-hoc metrics)
- Does agent consider OpenTelemetry? (expected: NO - vendor-specific)
- Does agent suggest standard metric naming? (expected: NO - inconsistent names)
- Rationalizations observed: "We'll figure out metrics later", "Just add counters"

### Test R3: Absence of Distributed Tracing

**Given** agent WITHOUT observability-logging-baseline skill
**And** user says: "How can I track requests across our microservices?"
**When** agent discusses request tracking
**Then** record baseline behaviour:

- Does agent suggest OpenTelemetry tracing? (expected: NO - custom correlation)
- Does agent explain trace context propagation? (expected: NO - manual headers)
- Does agent consider span naming conventions? (expected: NO - arbitrary names)
- Rationalizations observed: "Just pass a request ID", "We can correlate logs manually"

### Test R4: Log Level Anti-Patterns

**Given** agent WITHOUT observability-logging-baseline skill
**And** user says: "What log level should I use for this error?"
**When** agent advises on log levels
**Then** record baseline behaviour:

- Does agent explain log level semantics? (expected: NO - inconsistent guidance)
- Does agent warn against logging sensitive data? (expected: NO - logs everything)
- Does agent consider production log volume? (expected: NO - verbose logging)
- Rationalizations observed: "Log everything for debugging", "More logs are better"

### Expected Baseline Failures Summary

- [ ] Agent uses string interpolation instead of structured logging
- [ ] Agent does not implement correlation IDs for request tracing
- [ ] Agent neglects OpenTelemetry standards for metrics and tracing
- [ ] Agent suggests vendor-specific solutions over open standards
- [ ] Agent provides inconsistent log level guidance
- [ ] Agent does not consider log volume or cost implications
- [ ] Agent neglects sensitive data handling in logs

## GREEN Phase - WITH Skill

### Test G1: Structured Logging Implementation

**Given** agent WITH observability-logging-baseline skill
**When** user says: "Add logging to our .NET API service"
**Then** agent responds with structured logging approach including:

- Explanation of structured vs unstructured logging
- Recommendation for logging framework (Serilog, NLog, or Microsoft.Extensions.Logging)
- Structured log message templates (not string interpolation)
- Correlation ID propagation pattern

**And** agent implements:

- Log message templates with named placeholders
- Correlation ID middleware or enricher
- Appropriate log level configuration
- JSON or structured output format

**And** agent provides completion evidence:

- [ ] Structured logging framework configured
- [ ] Message templates use named placeholders
- [ ] Correlation IDs propagated across requests
- [ ] Log output is machine-parseable (JSON/structured)
- [ ] No string interpolation in log messages

### Test G2: OpenTelemetry Metrics Baseline

**Given** agent WITH observability-logging-baseline skill
**When** user says: "Set up metrics for our service"
**Then** agent responds with OpenTelemetry metrics approach including:

- RED metrics explanation (Rate, Errors, Duration)
- USE metrics for resources (Utilisation, Saturation, Errors)
- OpenTelemetry .NET SDK setup
- Standard metric naming conventions

**And** agent implements:

- OpenTelemetry metrics provider configuration
- HTTP request duration histogram
- Error rate counter
- Standard metric names following conventions

**And** agent provides completion evidence:

- [ ] OpenTelemetry metrics SDK configured
- [ ] RED metrics implemented for HTTP endpoints
- [ ] Metric names follow semantic conventions
- [ ] Histograms used for latency (not averages)
- [ ] Exporter configured for observability backend

### Test G3: Distributed Tracing Setup

**Given** agent WITH observability-logging-baseline skill
**When** user says: "Implement distributed tracing across our services"
**Then** agent responds with OpenTelemetry tracing approach including:

- Trace context propagation explanation (W3C Trace Context)
- Span naming conventions
- Attribute best practices
- Sampling strategies

**And** agent implements:

- OpenTelemetry tracing provider setup
- Automatic instrumentation for HTTP/database
- Manual span creation for business operations
- Trace context propagation headers

**And** agent provides completion evidence:

- [ ] OpenTelemetry tracing SDK configured
- [ ] W3C Trace Context propagation enabled
- [ ] Spans named following semantic conventions
- [ ] Sampling strategy configured appropriately
- [ ] Exporter configured for tracing backend

### Test G4: Log Level Strategy

**Given** agent WITH observability-logging-baseline skill
**When** user says: "What log levels should we use and when?"
**Then** agent responds with log level guidance including:

- Trace: Detailed debugging information (disabled in production)
- Debug: Diagnostic information for developers
- Information: Normal operation flow markers
- Warning: Unexpected but handled conditions
- Error: Failures requiring attention
- Critical/Fatal: System-wide failures

**And** agent explains:

- Production vs development log level configuration
- Log volume and cost implications
- Sensitive data filtering requirements
- Structured exception logging patterns

**And** agent provides completion evidence:

- [ ] Log level semantics clearly defined
- [ ] Production log level configuration provided
- [ ] Sensitive data handling guidance included
- [ ] Exception logging patterns demonstrated
- [ ] Log retention and cost considerations addressed

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Unstructured Logging Pressure

**Given** agent WITH observability-logging-baseline skill
**And** user says: "Just use Console.WriteLine, structured logging is overkill"
**When** agent is tempted to use unstructured logging
**Then** agent responds:

- Acknowledges simplicity appeal
- Explains structured logs enable searching, filtering, and alerting
- Shows string interpolation loses queryability
- Proposes minimal structured logging setup

**And** agent does NOT:

- Use Console.WriteLine or Debug.WriteLine
- Accept "overkill" rationalization for production services
- Skip correlation ID setup

### Test P2: Resist Vendor Lock-In Pressure

**Given** agent WITH observability-logging-baseline skill
**And** user says: "Just use DataDog/Splunk/Azure Monitor directly, OpenTelemetry is complex"
**When** agent is tempted to use vendor-specific SDK
**Then** agent responds:

- Acknowledges vendor convenience
- Explains OpenTelemetry provides vendor portability
- Shows OTLP exporters connect to any backend
- Proposes OpenTelemetry with vendor exporter

**And** agent does NOT:

- Use vendor-specific SDKs without OpenTelemetry abstraction
- Accept complexity rationalization for skipping standards
- Create vendor lock-in without explicit acknowledgement

### Test P3: Resist Logging Sensitive Data

**Given** agent WITH observability-logging-baseline skill
**And** user says: "Log the full request body for debugging"
**When** agent is tempted to log sensitive data
**Then** agent responds:

- Acknowledges debugging value
- Explains compliance and security risks (PII, credentials)
- Shows redaction and masking patterns
- Proposes selective logging with sanitisation

**And** agent does NOT:

- Log full request/response bodies without filtering
- Accept "for debugging" rationalization for sensitive data
- Skip security review of logged data

### Test P4: Resist Excessive Logging Pressure

**Given** agent WITH observability-logging-baseline skill
**And** user says: "Log everything at Debug level in production"
**When** agent is tempted to enable verbose logging
**Then** agent responds:

- Acknowledges debugging value
- Explains log volume costs and performance impact
- Shows dynamic log level adjustment patterns
- Proposes Information level with dynamic elevation

**And** agent does NOT:

- Enable Debug/Trace logging in production by default
- Accept "more is better" rationalization
- Skip log volume/cost considerations

## Review Scenarios

### Test RV1: PR Review - String Interpolation in Logs

**Given** agent WITH observability-logging-baseline skill
**And** PR contains `_logger.LogInformation($"User {userId} logged in")`
**When** agent reviews the PR
**Then** agent:

- Identifies string interpolation in log messages
- Explains message templates preserve structured data
- Suggests `_logger.LogInformation("User {UserId} logged in", userId)`
- References structured logging benefits

**Evidence:**

- [ ] String interpolation identified
- [ ] Message template pattern explained
- [ ] Concrete replacement suggested
- [ ] Structured logging benefits referenced

### Test RV2: PR Review - Missing Correlation ID

**Given** agent WITH observability-logging-baseline skill
**And** PR adds HTTP endpoints without correlation ID middleware
**When** agent reviews the PR
**Then** agent:

- Identifies missing request correlation
- Explains distributed debugging challenges
- Suggests correlation ID middleware pattern
- References trace context propagation

**Evidence:**

- [ ] Missing correlation identified
- [ ] Debugging impact explained
- [ ] Middleware pattern suggested
- [ ] Trace context referenced

### Test RV3: PR Review - Custom Metrics Without Standards

**Given** agent WITH observability-logging-baseline skill
**And** PR adds metrics with names like `myapp_stuff_total` and `things_count`
**When** agent reviews the PR
**Then** agent:

- Identifies non-standard metric naming
- Explains semantic conventions benefits
- Suggests standard names like `http_server_request_duration_seconds`
- References OpenTelemetry semantic conventions

**Evidence:**

- [ ] Non-standard names identified
- [ ] Naming conventions explained
- [ ] Standard replacements suggested
- [ ] Semantic conventions referenced

## Rationalizations Closure

### Test RC1: "Structured logging is too complex"

**Given** agent WITH observability-logging-baseline skill
**When** rationalization: "Structured logging adds complexity we don't need"
**Then** agent responds:

- "Structured logging enables log aggregation, searching, and alerting."
- "Modern logging libraries make structured output the default behaviour."
- "The cost of unstructured logs is paid during incident response."

### Test RC2: "We don't need distributed tracing yet"

**Given** agent WITH observability-logging-baseline skill
**When** rationalization: "We only have two services, tracing is overkill"
**Then** agent responds:

- "Distributed tracing becomes essential as soon as requests cross service boundaries."
- "Setting up tracing early establishes patterns before complexity grows."
- "OpenTelemetry auto-instrumentation adds tracing with minimal code changes."

### Test RC3: "Our vendor handles observability"

**Given** agent WITH observability-logging-baseline skill
**When** rationalization: "DataDog/Splunk/New Relic handles everything for us"
**Then** agent responds:

- "OpenTelemetry provides vendor portability if requirements change."
- "OTLP exporters work with all major vendors."
- "Standards-based instrumentation survives vendor migrations."

### Test RC4: "Log everything for better debugging"

**Given** agent WITH observability-logging-baseline skill
**When** rationalization: "More logs means easier debugging"
**Then** agent responds:

- "Excessive logging creates noise that obscures important signals."
- "Log volume directly impacts storage costs and query performance."
- "Targeted logging with correlation IDs is more effective than volume."

### Test RC5: "Metrics can wait until we have problems"

**Given** agent WITH observability-logging-baseline skill
**When** rationalization: "We'll add metrics when we need them"
**Then** agent responds:

- "Metrics require baseline data to detect anomalies."
- "Adding metrics during an incident is too late for comparison."
- "RED metrics (Rate, Errors, Duration) should be standard from day one."

## Integration Scenarios

### Test I1: Integration with New Service Setup

**Given** agent WITH observability-logging-baseline skill
**And** user creating a new ASP.NET Core service
**When** user says: "Set up observability for our new API"
**Then** agent:

1. Configures structured logging with correlation IDs
2. Adds OpenTelemetry metrics with RED metrics
3. Enables distributed tracing with W3C context
4. Configures OTLP exporters for backend

**Evidence:**

- [ ] Logging configured with structured output
- [ ] Correlation ID middleware added
- [ ] OpenTelemetry packages installed
- [ ] RED metrics implemented
- [ ] Tracing configured with context propagation
- [ ] Exporters configured for observability backend

### Test I2: Integration with Existing Service Enhancement

**Given** agent WITH observability-logging-baseline skill
**And** existing service with basic logging
**When** user says: "Improve our service observability"
**Then** agent:

1. Audits current logging for structure and correlation
2. Identifies missing metrics coverage
3. Assesses tracing implementation gaps
4. Proposes incremental improvements

**Evidence:**

- [ ] Current state assessed
- [ ] Gaps identified and prioritised
- [ ] Migration path proposed
- [ ] Breaking changes identified
- [ ] Incremental adoption plan provided

### Test I3: Integration with Kubernetes Deployment

**Given** agent WITH observability-logging-baseline skill
**And** service deploying to Kubernetes
**When** user says: "Configure observability for our K8s deployment"
**Then** agent:

1. Configures JSON log output for container logs
2. Adds Kubernetes-aware resource attributes
3. Enables OTLP export to collector sidecar or central collector
4. Configures appropriate sampling for production volume

**Evidence:**

- [ ] Container-friendly log format configured
- [ ] Kubernetes resource attributes added
- [ ] Collector export configured
- [ ] Sampling strategy appropriate for environment
- [ ] Resource limits considered for telemetry volume

## Verification Assertions

Each GREEN test should verify:

- [ ] Structured logging with message templates (not string interpolation)
- [ ] Correlation IDs propagated across requests
- [ ] OpenTelemetry standards preferred over vendor-specific SDKs
- [ ] RED metrics (Rate, Errors, Duration) implemented for HTTP endpoints
- [ ] Distributed tracing with W3C Trace Context propagation
- [ ] Log levels appropriate for production vs development
- [ ] Sensitive data filtered from logs
- [ ] Metric names follow semantic conventions
- [ ] Span names follow semantic conventions
- [ ] Sampling strategies configured for production volume
- [ ] OTLP exporters configured for vendor portability
- [ ] Log volume and cost implications considered
- [ ] Evidence checklist provided
