# Reference: EF Core Migrations Project + Attribute-Linked Type Configurations

This document supports `dotnet-efcore-practices` and is intended to be loaded on demand.

## Migrations in a dedicated project

### Intent

- Keep migration artifacts isolated from runtime persistence code and domain logic.
- Reduce noise in code coverage metrics and ensure coverage gates reflect testable behaviour.

### Typical layout

- `MyApp.Persistence` – DbContext + runtime persistence wiring
- `MyApp.Persistence.Migrations` – migrations and snapshots only

## Excluding migrations from coverage

### Intent

- Exclude generated/scaffolding code such as migration classes and model snapshots.
- Keep coverage thresholds focused on application and domain behaviour.

Implementation depends on your coverage toolchain, but the requirement is:

- migrations project excluded from collection and thresholds.

## Dedicated type configurations + attribute linking

### Pattern overview

- Each entity has a corresponding configuration type implementing `IEntityTypeConfiguration<TEntity>`.
- The configuration type is linked to the entity via a custom attribute to ensure traceability.

### Minimal attribute example (conceptual)

```csharp
[AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
public sealed class EntityConfigurationForAttribute : Attribute
{
    public EntityConfigurationForAttribute(Type entityType) => EntityType = entityType;
    public Type EntityType { get; }
}
```

### Entity configuration example (conceptual)

```csharp
[EntityConfigurationFor(typeof(Customer))]
public sealed class CustomerConfiguration : IEntityTypeConfiguration<Customer>
{
    public void Configure(EntityTypeBuilder<Customer> builder)
    {
        builder.HasKey(x => x.Id);
        // ...
    }
}
```

### Applying configurations (conceptual)

- Scan the target assembly for types with `EntityConfigurationForAttribute`.
- Apply them to `ModelBuilder` in stable order (e.g., by full name) to ensure determinism.

Note: If you prefer EF Core's native `ApplyConfigurationsFromAssembly`, you can still keep the attribute
as a traceability mechanism, but `dotnet-efcore-practices` expects the attribute to be part of the
linking/discovery contract.
