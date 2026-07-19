---
name: modern-csharp-coding-standards
description: Use this skill whenever writing or reviewing C# code to ensure use of modern language features, high performance, and robust API design.
---

# Modern C# Coding Standards

## Intent

Enforce the use of modern C# (12+) features to improve code safety, readability, and performance. This includes a preference for immutability, functional-style patterns, and zero-allocation techniques.

---

## When to Use

- Writing any new C# code (Records, Pattern matching, Primary constructors).
- Refactoring existing C# code to improve maintainability or performance.
- Designing domain models (Value Objects, Entities).
- Implementing high-performance or async-heavy paths.

---

## Precondition Failure Signal

- Use of mutable classes where `record` or `readonly record struct` is appropriate.
- Deep inheritance hierarchies instead of composition and interfaces.
- Manual null checks instead of Nullable Reference Types and pattern matching.
- Blocking on async code (`.Result`, `.Wait()`) or missing `CancellationToken`.
- Excessive allocations in performance-critical paths (not using `Span<T>`).

---

## Postcondition Success Signal

- Domain models use `record` (DTOs/Entities) and `readonly record struct` (Value Objects).
- Code leverages `switch` expressions and modern pattern matching.
- `Nullable Reference Types` are enabled and warnings addressed.
- Async methods are "async all the way" and respect `CancellationToken`.
- High-performance paths use `Span<T>`, `Memory<T>`, or `ArrayPool<T>`.

---

## Process

1. **Source Review**: Inspect the code for outdated patterns (mutability, inheritance, blocking async).
2. **Implementation**:
   - Refactor to use modern C# features (e.g., convert class to record).
   - Ensure all async calls are awaited and tokens passed.
   - Use `Span<T>` for buffer/string manipulation where performance is key.
3. **Verification**:
   - Run static analysis and linters to ensure compliance.
   - Execute tests to verify behaviour remains unchanged.
   - (Optional) Use benchmarks to demonstrate performance improvements for zero-allocation changes.
4. **Documentation**: Document significant architectural patterns (e.g., Value Objects) in an ADR.
5. **Review**: Tech Lead reviews for adherence to the "Modern C#" spirit.

---

## Key Practices

- Use `record` and `readonly record struct` for immutable domain modeling.
- Prefer pattern matching over nested `if`/`else` branches.
- Pass `CancellationToken` through async call chains.
- Use `Span<T>` and `Memory<T>` for high-performance parsing and buffers.

---

## Example Test / Validation

- **Refactor**: Convert a mutable DTO class to a positional `record`.
- **Validation**: Ensure `Nullable` is enabled in `.csproj` and zero warnings exist.
- **Validation**: Verify `CancellationToken` is passed to all downstream async calls.

---

## Common Red Flags / Guardrail Violations

- "I'm used to the old way" (avoiding records/patterns).
- Ignoring nullable warnings by overusing `!`.
- Creating `BaseEntity` or `BaseService` hierarchies.
- Using `AutoMapper` (prefer `Mapperly` for compile-time safety).

---

## Recommended Review Personas

- **Tech Lead** – validates modern pattern usage and architectural alignment.
- **Software Engineer** – validates implementation details and performance.

---

## Skill Priority

P2 – Consistency & Governance  
(Escalate to P1 for performance-critical or security-related code.)

---

## Conflict Resolution Rules

- Modern C# standards override legacy patterns unless explicitly constrained by framework/interop requirements.
- Immutability is the default; mutability must be justified and scoped.

---

## Conceptual Dependencies

- quality-gate-enforcement
- automated-standards-enforcement

---

## Classification

Governance
Core

---

## Notes

See `skills/modern-csharp-coding-standards/references/reference.md` for focused examples and patterns.
