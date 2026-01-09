---
name: dotnet-domain-primitives
description: Prevent primitive obsession by enforcing StronglyTypedIds and value objects in domain models and at boundaries.
---

## Core

### When to use

- Designing or reviewing domain models (entities, aggregates, commands/events).
- Any non-trivial service where identifiers and "meaningful primitives" recur across layers.

### Defaults (non-negotiable)

- **StronglyTypedIds by default** for all entity identifiers in domain/application code.
- **No primitive IDs** (`Guid`, `int`, `long`, `string`) in the domain layer.
- Use **value objects** for meaningful primitives (e.g., `EmailAddress`, `Money`, `Percentage`, `TenantId`, `CorrelationId`).

### Preferred approach

- Prefer **open-source** libraries that use **source generation** for typed IDs.
- Conversions to/from primitives are permitted only at explicit boundaries:
  - persistence adapters,
  - transport adapters (HTTP, messaging),
  - serialization/deserialization.

### Review rules

- New domain types must not introduce primitive ID properties/fields.
- Mapping layers must map typed IDs explicitly; no "magic" conversions hidden in core domain types.

## Load: examples

### Strongly typed ID (source generator style)

- Define a `CustomerId` type and use it on entities/commands.
- Map to primitive `Guid` at the persistence boundary and transport boundary.

### Value object boundaries

- Allow `string` in DTOs if required by external contracts.
- Convert to `EmailAddress` (value object) inside the application layer.

## Load: advanced

### Integration guidance

- EF Core: value converters for typed IDs and value objects.
- System.Text.Json: custom converters where needed for typed IDs.
- Dapper: type handlers if Dapper is used for read models.

### Operational concerns

- Ensure typed ID types are stable for logging/telemetry (string representation).
- Avoid implicit conversions that obscure boundary crossings.

## Load: enforcement

### Acceptance criteria for PRs

- New entities/aggregates use typed IDs.
- No domain-layer primitive IDs added.
- Boundary conversion is explicit and covered by unit tests.
