# C# 13 Best Practices (.NET 9) — Delta vs C# 12

## Standards added or changed

- Prefer `params` collections for ergonomic APIs that accept spans/collections without forcing allocations.
- Use partial properties/indexers for source-generator and partial-type scenarios.

## New language patterns

### `params` collections

```csharp
public static string JoinCsv(params ReadOnlySpan<string> values)
    => string.Join(",", values.ToArray());
```

### Partial properties/indexers

```csharp
public partial class User
{
    public partial string DisplayName { get; set; }
}
```

## Tooling and enforcement (delta vs C# 12)

| New / changed item                                                           | Analyzer / Tool | What it enforces                          | Notes                                                 |
| ---------------------------------------------------------------------------- | --------------- | ----------------------------------------- | ----------------------------------------------------- |
| No prominent new built-in IDE rules uniquely tied to C# 13 headline features | N/A             | Continue baseline analyzers + C# 12 rules | Use code review and tests for concurrency/API design. |

## Global suppressions (delta vs C# 12)

- No recommended new global suppressions attributable to C# 13 features.
