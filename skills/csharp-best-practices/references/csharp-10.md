# C# 10 Best Practices (.NET 6) — Baseline Standard

## Scope

This is the baseline standard for this skill. Later reference files are **deltas only**.
Always load this file first.

## Core principles

1. **Immutability by default**: prefer immutable models and explicit state transitions.
2. **Type safety over convenience**: encode domain constraints in types (avoid primitive obsession).
3. **Null-safety**: enable nullable reference types; model null explicitly.
4. **Explicit APIs**: prefer clear signatures and predictable behavior over “clever” language tricks.
5. **Async correctness**: async for I/O; cancellation tokens for public async APIs; avoid sync-over-async.
6. **Small, testable units**: separate pure logic from I/O; isolate time and randomness behind abstractions.
7. **Avoid churn**: modernize touched code; avoid wide formatting-only diffs unless requested.

## Language patterns

### File-scoped namespaces (C# 10)

Prefer file-scoped namespaces in new and modified files.

```csharp
namespace MyApp.Orders;

public sealed class OrderService { }
```

Avoid block-scoped namespaces when your standard is file-scoped.

```csharp
namespace MyApp.Orders
{
    public sealed class OrderService { }
}
```

### Global using directives (C# 10)

Prefer global usings for ubiquitous namespaces to reduce repetition.

```csharp
// GlobalUsings.cs
global using System.Collections.Immutable;
global using Microsoft.Extensions.Logging;
```

Guidance:

- Keep global usings _curated_ to avoid collisions (`Task`, `File`, `Timer`, etc.)
- Prefer solution-wide definition (one place) rather than per-project drift.

### Immutability and records

Use records for immutable, value-like DTOs/messages where structural equality is desirable.

```csharp
public record CustomerDto(string Id, string Name, string Email);
```

If the type represents a mutable entity with identity and lifecycle, prefer a class with explicit mutation methods.

### Value objects as readonly record struct

Use `readonly record struct` for strong IDs and small value objects.

```csharp
public readonly record struct OrderId(Guid Value)
{
    public static OrderId New() => new(Guid.NewGuid());
    public override string ToString() => Value.ToString();
}
```

When converting from primitives, prefer explicit construction or factories rather than implicit casts.

### Nullability posture (NRT)

Enable nullable reference types and treat warnings as actionable.

Principles:

- Use `string?` only when `null` is a valid state.
- Prefer `ArgumentNullException.ThrowIfNull(param)` for guard clauses.
- Avoid `!` suppression except at well-justified boundaries.

### Error handling: exceptions vs Result

Use exceptions for exceptional conditions; prefer explicit Result for expected validation failures.

```csharp
public readonly record struct Result<T>(bool IsSuccess, T? Value, string? Error)
{
    public static Result<T> Ok(T value) => new(true, value, null);
    public static Result<T> Fail(string error) => new(false, default, error);
}
```

### API design

Avoid returning `List<T>` from public APIs; return `IReadOnlyList<T>` or immutable collections.

### Async and cancellation

Avoid `.Result`/`.Wait()`; propagate cancellation tokens.

## Anti-patterns (baseline)

- Primitive obsession
- Mutable DTOs without invariants
- God services
- Hidden side-effects in setters
- Overuse of `var` where type is non-obvious

## Tooling and enforcement (baseline)

| Category                | Tool / Library                        | What it enforces                                | Recommended posture                                             |
| ----------------------- | ------------------------------------- | ----------------------------------------------- | --------------------------------------------------------------- |
| Built-in analyzers      | .NET SDK analyzers / Roslyn analyzers | Quality + style rules integrated into build/IDE | Enable broadly; tune via `.editorconfig`.                       |
| Style analyzers         | StyleCop.Analyzers                    | Layout, naming, documentation, ordering         | Use if you need stricter consistency; configure to avoid noise. |
| Formatter               | `dotnet format`                       | Formats per `.editorconfig` + fixes analyzers   | Use in CI for formatting gate.                                  |
| Best-practice analyzers | Roslynator.Analyzers                  | Best-practice diagnostics + fixes               | Start as suggestions; promote select rules over time.           |
| Best-practice analyzers | Meziantou.Analyzer                    | Design/usage/security/perf/style rules          | Tune for repo tolerance.                                        |

## Global suppressions (baseline)

- Prefer file-scoped namespaces: suppress `IDE0160` (Convert to block-scoped namespace)

```ini
dotnet_diagnostic.IDE0160.severity = none
```
