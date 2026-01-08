# C# 14 Best Practices (.NET 10) — Delta vs C# 13

## Standards added or changed

- Prefer field-backed properties (`field`) for simple invariants without manual backing fields.
- Use extension members to improve discoverability, but do not use them to mask poor domain design.

## New language patterns

### Field-backed properties

```csharp
public sealed class User
{
    public string DisplayName
    {
        get => field;
        set => field = value.Trim();
    }
}
```

### Extension members (guidance)

- Prefer a small number of well-named extension containers.
- Avoid extensions that hide expensive behavior or surprising side effects.

## Tooling and enforcement (delta vs C# 13)

| New / changed item                                                                  | Analyzer / Tool | What it enforces                                  | Notes                                             |
| ----------------------------------------------------------------------------------- | --------------- | ------------------------------------------------- | ------------------------------------------------- |
| No widely adopted built-in IDE rules uniquely tied to C# 14 headline features (yet) | N/A             | Continue baseline analyzers + prior version rules | Prefer compiler correctness + review conventions. |

## Global suppressions (delta vs C# 13)

- No recommended new global suppressions attributable to C# 14 features.
