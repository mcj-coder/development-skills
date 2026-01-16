---
name: dotnet-healthchecks
description: Standardise health check implementation using the AspNetCore.Diagnostics.HealthChecks open-source ecosystem.
---

## Overview

Standardise health check implementation using the AspNetCore.Diagnostics.HealthChecks (Xabaril)
open-source ecosystem. Prefer battle-tested packages over bespoke probes for liveness, readiness,
and dependency health endpoints across databases, caches, message brokers, and external services.

## Core

### When to use

- Any ASP.NET Core service exposing liveness, readiness, or dependency health endpoints.
- Any PR introducing health checks for infrastructure dependencies.

### Defaults (strong preference)

- Use **AspNetCore.Diagnostics.HealthChecks** (Xabaril) implementations by default.
- Prefer existing, battle-tested health check packages over bespoke probes.

### Covered dependencies (non-exhaustive)

- SQL Server, PostgreSQL, MySQL
- Redis
- Azure services
- AWS services
- Message brokers
- URLs / HTTP endpoints

### Rationale

- Widely adopted OSS ecosystem
- Consistent health semantics
- Reduced bespoke code
- Clear operational behaviour

### Review rules

- Reject bespoke health check implementations when a suitable Xabaril package exists.
- Custom health checks are permitted only for truly domain-specific dependencies.

## Load: examples

### Registration (conceptual)

```csharp
builder.Services
    .AddHealthChecks()
    .AddSqlServer(connectionString)
    .AddRedis(redisConnection)
    .AddUrlGroup(new Uri("https://example.com"));
```

### Endpoint mapping (conceptual)

```csharp
app.MapHealthChecks("/health");
```

## Load: advanced

### Liveness vs readiness

- Liveness: process is running
- Readiness: dependencies are reachable and correctly configured

### Configuration hygiene

- Avoid embedding secrets directly in health check registration.
- Prefer named health checks for clarity in dashboards.

## Load: enforcement

### Review heuristic: health checks

- If a PR adds a health check, verify an existing Xabaril implementation was evaluated.
- If a custom implementation is added, require justification explaining why OSS alternatives are insufficient.

## Load: endpoint verification

### Health check endpoint verification

Verify health checks are working using simple HTTP commands:

```bash
# Check liveness (process running)
curl -i http://localhost:5000/health/live

# Check readiness (dependencies available)
curl -i http://localhost:5000/health/ready

# Check combined health endpoint
curl -i http://localhost:5000/health
```

Expected responses:

- **200 OK**: Health check passed
- **503 Service Unavailable**: Health check failed (dependency unreachable)
- **JSON response** includes individual check status:

```json
{
  "status": "Healthy",
  "checks": {
    "sql-orders-db": {
      "status": "Healthy",
      "description": null,
      "duration": "00:00:00.0234567"
    },
    "redis-cache": {
      "status": "Unhealthy",
      "description": "Connection refused",
      "duration": "00:00:00.0123456"
    }
  },
  "totalDuration": "00:00:00.0500000"
}
```

## Load: readiness vs liveness guidelines

### Probe types and orchestration patterns

**Liveness Probes** verify the process is running:

- Configuration: `/health/live`
- Checks: minimal - only process state, no external dependencies
- Failure action: Kubernetes restarts pod
- Use when: Process might hang or deadlock
- Example: No database checks, no external service calls

```csharp
builder.Services
    .AddHealthChecks()
    .AddCheck("process-alive", () => HealthCheckResult.Healthy(), tags: new[] { "live" });

app.MapHealthChecks("/health/live",
    new HealthCheckOptions
    {
        Predicate = reg => reg.Tags.Contains("live")
    });
```

**Readiness Probes** verify dependencies are reachable:

- Configuration: `/health/ready`
- Checks: all infrastructure dependencies (database, cache, message broker)
- Failure action: Kubernetes removes pod from load balancer, allows time for recovery
- Use when: Dependencies may be temporarily unavailable during startup or updates
- Example: Database connectivity, Redis access, external API availability

```csharp
builder.Services
    .AddHealthChecks()
    .AddSqlServer(sqlConnection, name: "sql-orders-db", tags: new[] { "ready" })
    .AddRedis(redisConnection, name: "redis-cache", tags: new[] { "ready" });

app.MapHealthChecks("/health/ready",
    new HealthCheckOptions
    {
        Predicate = reg => reg.Tags.Contains("ready")
    });
```

### Separation strategy

Use tag-based filtering to separate liveness from readiness:

- Tag liveness checks with `"live"`
- Tag readiness checks with `"ready"`
- Use `Predicate` parameter in `MapHealthChecks()` to filter by tags
- This prevents temporary dependency failures from restarting the pod

## Load: health check testing

### Unit testing custom health checks

Test custom `IHealthCheck` implementations:

```csharp
[Fact]
public async Task CheckAsync_WhenDatabaseConnected_ReturnsHealthy()
{
    // Arrange
    var mockConnection = new Mock<IDbConnection>();
    var healthCheck = new DatabaseHealthCheck(mockConnection.Object);

    // Act
    var result = await healthCheck.CheckAsync(
        new HealthCheckContext { Registration = new HealthCheckRegistration("test", null, null, null) });

    // Assert
    Assert.Equal(HealthStatus.Healthy, result.Status);
}

[Fact]
public async Task CheckAsync_WhenDatabaseUnreachable_ReturnsUnhealthy()
{
    // Arrange
    var mockConnection = new Mock<IDbConnection>();
    mockConnection.Setup(c => c.Open()).Throws<SqlException>();
    var healthCheck = new DatabaseHealthCheck(mockConnection.Object);

    // Act
    var result = await healthCheck.CheckAsync(
        new HealthCheckContext { Registration = new HealthCheckRegistration("test", null, null, null) });

    // Assert
    Assert.Equal(HealthStatus.Unhealthy, result.Status);
}
```

### Integration testing endpoints

Test health check endpoints in ASP.NET Core integration tests:

```csharp
public class HealthCheckEndpointTests : IAsyncLifetime
{
    private readonly WebApplicationFactory<Program> _factory;
    private HttpClient _client;

    public async Task InitializeAsync()
    {
        _factory = new WebApplicationFactory<Program>();
        _client = _factory.CreateClient();
    }

    [Fact]
    public async Task LivenessEndpoint_ReturnsOk_WhenProcessRunning()
    {
        // Act
        var response = await _client.GetAsync("/health/live");

        // Assert
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task ReadinessEndpoint_ReturnsBadServiceAvailable_WhenDatabaseDown()
    {
        // Setup: stop database via test container or mock

        // Act
        var response = await _client.GetAsync("/health/ready");

        // Assert
        Assert.Equal(HttpStatusCode.ServiceUnavailable, response.StatusCode);
        var json = await response.Content.ReadAsAsync<HealthReport>();
        Assert.Equal("Unhealthy", json["status"]);
    }

    [Fact]
    public async Task CombinedHealthEndpoint_ExcludesLivenessDetails_InReadyTag()
    {
        // Act
        var response = await _client.GetAsync("/health/ready");
        var json = await response.Content.ReadAsAsync<dynamic>();

        // Assert
        Assert.NotNull(json["checks"]["sql-orders-db"]);
        // Liveness check should not be in readiness endpoint
        Assert.Null(json["checks"]["process-alive"]);
    }

    public async Task DisposeAsync()
    {
        _client?.Dispose();
        _factory?.Dispose();
    }
}
```

### TestContainers integration testing

Test health checks against real infrastructure:

```csharp
public class HealthCheckWithTestContainersTests : IAsyncLifetime
{
    private readonly PostgreSqlContainer _postgreSqlContainer = new PostgreSqlBuilder()
        .WithImage("postgres:15")
        .Build();

    private WebApplicationFactory<Program> _factory;
    private HttpClient _client;

    public async Task InitializeAsync()
    {
        await _postgreSqlContainer.StartAsync();
        var connectionString = _postgreSqlContainer.GetConnectionString();

        _factory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                builder.ConfigureAppConfiguration((context, config) =>
                {
                    config.AddInMemoryCollection(new Dictionary<string, string>
                    {
                        ["ConnectionStrings:Default"] = connectionString
                    });
                });
            });

        _client = _factory.CreateClient();
    }

    [Fact]
    public async Task ReadinessCheck_WithRealPostgres_ReturnsHealthy()
    {
        // Act
        var response = await _client.GetAsync("/health/ready");

        // Assert
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    public async Task DisposeAsync()
    {
        _client?.Dispose();
        _factory?.Dispose();
        await _postgreSqlContainer.StopAsync();
    }
}
```

## Red Flags - STOP

These statements indicate health check anti-patterns:

| Thought                              | Reality                                                        |
| ------------------------------------ | -------------------------------------------------------------- |
| "We'll write our own health checks"  | Use Xabaril packages; they're battle-tested for common deps    |
| "Liveness should check the database" | Liveness checks process state only; database is for readiness  |
| "One health endpoint is enough"      | Separate liveness from readiness; prevent unnecessary restarts |
| "Health checks don't need tests"     | Test both unit (IHealthCheck) and integration (endpoints)      |
| "Embed connection strings directly"  | Use configuration; avoid secrets in health check registration  |
| "Any failure should restart the pod" | Readiness failures remove from LB; only liveness restarts      |
