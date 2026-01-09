---
name: dotnet-healthchecks
description: Standardise health check implementation using the AspNetCore.Diagnostics.HealthChecks open-source ecosystem.
---

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
