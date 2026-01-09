# Reference: AspNetCore.Diagnostics.HealthChecks (Xabaril)

This document supports `dotnet-healthchecks`.

## Canonical implementation set

- <https://github.com/Xabaril/AspNetCore.Diagnostics.HealthChecks>

## Why this ecosystem

- Broad coverage of common infrastructure dependencies
- Consistent API and behaviour
- Active open-source maintenance
- Well understood operational semantics

## Typical usage patterns

```csharp
builder.Services
    .AddHealthChecks()
    .AddSqlServer(connectionString, name: "sql")
    .AddRedis(redis, name: "redis")
    .AddUrlGroup(new Uri("https://example.com"), name: "external-api");
```

## Notes

- Prefer package-provided checks over custom implementations.
- Custom checks should be rare and domain-specific.
