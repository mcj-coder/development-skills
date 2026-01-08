---
name: dotnet-specification-pattern
description: Prefer Specification Pattern for query composition and domain selection logic; avoid generic Repository Pattern duplication of ORM semantics.
---

## Core

### When to use

- Any query logic beyond trivial CRUD: filtering, paging, sorting, includes, tenancy constraints, authorization constraints.
- Systems with multiple query shapes or evolving selection logic.

### Defaults

- Prefer **Specification Pattern** over a **generic Repository Pattern**.
- Specifications define _what_ to fetch; infrastructure decides _how_ to execute.
- Keep `IQueryable` exposure inside infrastructure boundaries; application/domain layers use specs or criteria objects.

### Rationale

- Composability and reuse (AND/OR composition).
- Testability of selection logic.
- Reduces accidental duplication of ORM capabilities.

### Anti-patterns to avoid

- "Generic repository" wrappers that re-expose EF semantics (`GetAll`, `Find`, etc.).
- Leaking ORM-specific details into domain/application layers.

## Load: examples

- A `ActiveCustomersForTenantSpec` composed with paging/sorting.
- A `OrdersNeedingFulfilmentSpec` with includes and date filters.
- A global `TenantIsolationSpec` applied consistently.

## Load: advanced

### Performance considerations

- Use split queries or includes judiciously.
- Consider compiled queries for hot paths.
- Ensure specs don't inadvertently cause N+1 query patterns.

### Governance

- Specs are versioned and discoverable; avoid ad-hoc LINQ scattered through handlers/controllers.

## Load: enforcement

- Reject introduction of new generic repository abstractions unless domain-specific and justified.
- Query selection logic should be captured as specs when it is reused or non-trivial.
