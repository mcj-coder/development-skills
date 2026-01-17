---
name: dotnet-efcore-practices
description: Standardise EF Core usage: isolate migrations in a dedicated project excluded from code coverage, and enforce attribute-linked dedicated type configuration classes.
---

## Overview

Standardise Entity Framework Core usage with dedicated migrations projects excluded from code
coverage, attribute-linked configuration types for entities, and deterministic configuration
discovery. This ensures clean separation between business logic and infrastructure scaffolding.

## When to Use

- Any solution using EF Core for persistence
- Adding or modifying DbContext, entity types, or configurations
- Creating or updating EF Core migrations
- Setting up code coverage exclusions for infrastructure projects
- Reviewing PRs that change persistence layer structure

## Core Workflow

1. **Verify project structure**: Ensure migrations are in a dedicated `*.Persistence.Migrations` project
2. **Configure coverage exclusion**: Add `<ExcludeFromCodeCoverage>true</ExcludeFromCodeCoverage>` to migrations project
3. **Create configuration types**: Implement dedicated `IEntityTypeConfiguration<T>` for each entity
4. **Link via attributes**: Use attribute-based discovery to connect entities to their configurations
5. **Keep DbContext clean**: DbContext applies configurations, not define them inline
6. **Ensure deterministic ordering**: Configuration scanning uses stable ordering (e.g., by full name)
7. **Verify coverage gate**: Run tests to confirm migrations project excluded from coverage reports
8. **Add repository tests**: Use xUnit with `IAsyncLifetime` for async repository testing

## Core

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

## Load: coverage tooling

### Coverlet configuration example

**`.runsettings` (repository root):**

```xml
<?xml version="1.0" encoding="utf-8"?>
<RunSettings>
  <DataCollectionRunSettings>
    <DataCollectors>
      <DataCollector friendlyName="XPlat Code Coverage" assemblyQualifiedName="Coverlet.Collector.DataCollection.CoverletInstrumentationCollector, coverlet.collector">
        <Configuration>
          <ExcludeByAttribute>CompilerGeneratedAttribute,GeneratedCodeAttribute,ExcludeFromCodeCoverageAttribute</ExcludeByAttribute>
          <ExcludeByFile>**/Migrations/**/*.cs</ExcludeByFile>
        </Configuration>
      </DataCollector>
    </DataCollectors>
  </DataCollectionRunSettings>
</RunSettings>
```

**Alternative: `.csproj` exclusion (for Migrations project):**

```xml
<PropertyGroup>
  <ExcludeFromCodeCoverage>true</ExcludeFromCodeCoverage>
</PropertyGroup>
```

### xUnit repository pattern examples

**Repository interface with xUnit tests:**

```csharp
// Domain: IOrderRepository.cs
public interface IOrderRepository
{
    Task<Order?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task AddAsync(Order order, CancellationToken cancellationToken = default);
    Task UpdateAsync(Order order, CancellationToken cancellationToken = default);
}

// Persistence: OrderRepository.cs
public class OrderRepository : IOrderRepository
{
    private readonly AppDbContext _context;

    public OrderRepository(AppDbContext context) => _context = context;

    public Task<Order?> GetByIdAsync(int id, CancellationToken ct) =>
        _context.Orders.FirstOrDefaultAsync(o => o.Id == id, ct);

    public Task AddAsync(Order order, CancellationToken ct)
    {
        _context.Orders.Add(order);
        return _context.SaveChangesAsync(ct);
    }

    public Task UpdateAsync(Order order, CancellationToken ct)
    {
        _context.Orders.Update(order);
        return _context.SaveChangesAsync(ct);
    }
}

// Tests: OrderRepositoryTests.cs
public class OrderRepositoryTests : IAsyncLifetime
{
    private DbContextOptions<AppDbContext> _options = null!;
    private AppDbContext _context = null!;

    public async Task InitializeAsync()
    {
        _options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        _context = new AppDbContext(_options);
        await _context.Database.EnsureCreatedAsync();
    }

    public async Task DisposeAsync()
    {
        await _context.DisposeAsync();
    }

    [Fact]
    public async Task GetByIdAsync_WithValidId_ReturnsOrder()
    {
        // Arrange
        var order = new Order { Id = 1, Status = OrderStatus.Pending };
        _context.Orders.Add(order);
        await _context.SaveChangesAsync();

        var repository = new OrderRepository(_context);

        // Act
        var result = await repository.GetByIdAsync(1);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(1, result.Id);
    }

    [Fact]
    public async Task AddAsync_WithNewOrder_PersistsSuccessfully()
    {
        // Arrange
        var order = new Order { Status = OrderStatus.Pending };
        var repository = new OrderRepository(_context);

        // Act
        await repository.AddAsync(order);
        var retrieved = await _context.Orders.FindAsync(order.Id);

        // Assert
        Assert.NotNull(retrieved);
        Assert.Equal(OrderStatus.Pending, retrieved.Status);
    }
}
```

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

## Load: verification

### Verification commands

**1. Verify migrations project is excluded from coverage:**

```bash
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

Expected output: Coverage report excludes `*.Persistence.Migrations` assembly.

**2. Verify coverage threshold passes:**

```bash
dotnet test /p:CollectCoverage=true /p:Threshold=75
```

Expected: Build succeeds even if migrations project has low/zero coverage.

**3. List excluded coverage paths:**

```bash
# Inspect .runsettings to confirm ExcludeByFile patterns
cat .runsettings
```

Expected: File contains exclusion patterns for migrations path (e.g., `**/Migrations/**/*.cs`).

### Verification checklist

- [ ] Migrations project has `<ExcludeFromCodeCoverage>true</ExcludeFromCodeCoverage>` in `.csproj` OR excluded in `.runsettings`
- [ ] Run `dotnet test /p:CollectCoverage=true` and verify migrations assembly does not appear in coverage report
- [ ] xUnit repository tests use `IAsyncLifetime` for async setup/teardown
- [ ] Configuration types exist in Persistence project (not in migrations)
- [ ] Migration files are in dedicated `*.Persistence.Migrations` project only

## Red Flags - STOP

These statements indicate EF Core hygiene issues:

| Thought                                    | Reality                                                            |
| ------------------------------------------ | ------------------------------------------------------------------ |
| "Migrations can stay in the main project"  | Isolate migrations in a dedicated project; they're scaffolding     |
| "OnModelCreating is fine for all config"   | Use dedicated configuration types per entity; keep DbContext clean |
| "Coverage should include migrations"       | Exclude migrations from coverage; they're generated infrastructure |
| "Ad-hoc configuration is faster"           | Attribute-linked discovery ensures consistency; prevents drift     |
| "In-memory database is enough for tests"   | Use TestContainers for realistic persistence testing when needed   |
| "Reflection scanning order doesn't matter" | Ensure deterministic ordering; non-determinism causes subtle bugs  |
