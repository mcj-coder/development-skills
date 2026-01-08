# C# 12 Best Practices (.NET 8) — Delta vs C# 11

## Standards added or changed

- Prefer primary constructors for small DI services and simple types where it reduces boilerplate without obscuring initialization.
- Prefer collection expressions in tests and simple mappings when it improves readability.

## New language patterns

### Primary constructors (selectively)

```csharp
public sealed class OrderService(IOrderRepository repo, ILogger<OrderService> log)
{
    public Task<Order?> GetAsync(OrderId id, CancellationToken ct) => repo.GetAsync(id, ct);
}
```

### Collection expressions

```csharp
int[] ids = [1, 2, 3];
List<string> names = ["a", "b"];
```

## Tooling and enforcement (delta vs C# 11)

| New / changed item | Analyzer / Tool    | What it enforces                                                  | Classification                    |
| ------------------ | ------------------ | ----------------------------------------------------------------- | --------------------------------- |
| `IDE0290`          | .NET SDK analyzers | Suggests converting eligible types to primary constructors        | Optional (requires clarification) |
| `IDE0028`          | .NET SDK analyzers | Suggests simplifying collection initialization                    | Default                           |
| `IDE0305`          | .NET SDK analyzers | Suggests using collection expressions for certain fluent patterns | Optional (requires clarification) |

## Global suppressions (delta vs C# 11)

Optional recommendations. Request clarification before enabling globally.

- `IDE0290` — Use primary constructor — Optional (requires clarification)

```ini
dotnet_diagnostic.IDE0290.severity = none
```

- `IDE0305` — Use collection expression for fluent — Optional (requires clarification)

```ini
dotnet_diagnostic.IDE0305.severity = none
```
