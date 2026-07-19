# Modern C# Coding Standards Reference

## Records and Value Objects

- Use `record` for DTOs and aggregates; use `readonly record struct` for value objects.
- Prefer explicit validation in constructors or factories.

## Pattern Matching

- Use `switch` expressions and property patterns for readability.
- Avoid deep `if`/`else` chains when patterns apply.

## Async and Cancellation

- Pass `CancellationToken` through all async calls.
- Use `ValueTask` only for hot paths with frequent synchronous completion.
- Use `ConfigureAwait(false)` in library code, not in application code.

## Performance Patterns

- Use `Span<T>` and `Memory<T>` for high-performance parsing and buffers.
- Use `ArrayPool<T>` for large temporary buffers to reduce GC pressure.

## Result vs Exceptions

- Use Result types for expected errors (validation, business rules).
- Reserve exceptions for unexpected failures and programmer errors.
