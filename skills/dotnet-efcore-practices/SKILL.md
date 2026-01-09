---
name: dotnet-efcore-practices
description: Standardise EF Core usage: isolate migrations in a dedicated project excluded from code coverage, and enforce attribute-linked dedicated type configuration classes.
---

## Core

### When to use

- Any solution using EF Core for persistence.
- Any PR introducing or changing DbContext, entity types, configurations, or migrations.

### Defaults (non-negotiable)

#### 1) Migrations project isolation

- EF Core **migrations must be stored in a dedicated project** (e.g., `*.Persistence.Migrations`).
- The migrations project is treated as **infrastructure output**, not business logic.

##### Code coverage rule

- The migrations project **must be excluded from code coverage** (and from coverage gates),
  as it is generated/operational scaffolding rather than testable behaviour.

#### 2) Dedicated type configuration types

- EF Core entity configuration must be implemented in **dedicated configuration types**
  (one per entity/aggregate root as appropriate), not inline in `OnModelCreating`.
- DbContext should remain orchestration-only (apply configurations), not a monolithic configuration class.

#### 3) Attribute-linked configuration discovery

- Configuration types must be **linked by attribute** to the entity they configure.
- The discovery mechanism (at startup) must apply configurations by scanning these attributes, ensuring:
  - deterministic configuration application,
  - clear traceability between entity and configuration type,
  - avoidance of ad-hoc registration drift.

### Review rules

- Reject PRs that add migrations to the main persistence project or domain project.
- Reject PRs that add entity configuration inline in `OnModelCreating` where a dedicated configuration type is expected.
- Reject PRs where configuration types exist but are not discoverable via the attribute linking mechanism.

## Load: examples

### Recommended project layout

- `MyApp.Persistence` (DbContext, repositories/infrastructure, runtime persistence wiring)
- `MyApp.Persistence.Migrations` (migrations only)
- `MyApp.Domain` (entities/value objects; no EF references where architecture requires)
- `MyApp.Application` (use cases; no EF references where architecture requires)

### Coverage exclusion examples (tooling-agnostic intent)

- Exclude `MyApp.Persistence.Migrations` from coverage collection and thresholds.
- Exclude generated migration snapshots.

## Load: advanced

### Deterministic configuration application

- Ensure attribute scanning is stable and does not depend on nondeterministic ordering.
- Prefer explicit ordering or stable sorting (e.g., by full name) if scanning is used.

### Performance and trimming considerations

- If using reflection-based scanning for configuration discovery, constrain it to:
  - a known assembly list,
  - explicit type filters,
  - and stable ordering.
- In AOT/trimming scenarios, ensure any reflection usage is compatible with trimming requirements
  (or provide a non-reflection fallback).

## Load: enforcement

### Coverage gate

- Coverage enforcement must not fail due to migrations project changes.
- Any change to coverage config must keep the migrations project excluded.

### Review heuristic: EF Core hygiene

- If a PR adds a migration, verify it lands in the dedicated migrations project.
- If a PR changes entities, verify configuration is updated in the dedicated configuration type.
- If a new entity is added, verify it has:
  - a configuration type,
  - an attribute link,
  - and that discovery applies it.
