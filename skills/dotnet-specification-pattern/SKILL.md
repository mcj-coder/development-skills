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

## Load: specification examples

### Basic Specification Implementation

```csharp
// Base specification interface
public interface ISpecification<T>
{
    Expression<Func<T, bool>> Criteria { get; }
    List<Expression<Func<T, object>>> Includes { get; }
    Expression<Func<T, object>>? OrderBy { get; }
    Expression<Func<T, object>>? OrderByDescending { get; }
    int? Take { get; }
    int? Skip { get; }
}

// Concrete specification
public class ActiveCustomersForTenantSpec : Specification<Customer>
{
    public ActiveCustomersForTenantSpec(Guid tenantId)
    {
        Criteria = c => c.TenantId == tenantId && c.IsActive;
        Includes.Add(c => c.Orders);
        OrderBy = c => c.Name;
    }
}

// Usage in repository
public async Task<List<Customer>> ListAsync(ISpecification<Customer> spec)
{
    return await ApplySpecification(spec).ToListAsync();
}

// Composing specifications
var spec = new ActiveCustomersForTenantSpec(tenantId)
    .And(new HasRecentOrdersSpec(DateTime.UtcNow.AddDays(-30)));
```

### Ardalis.Specification Example (Recommended Library)

```csharp
// Using Ardalis.Specification NuGet package
public class OrdersNeedingFulfilmentSpec : Specification<Order>
{
    public OrdersNeedingFulfilmentSpec(DateTime cutoffDate)
    {
        Query
            .Where(o => o.Status == OrderStatus.Pending)
            .Where(o => o.CreatedAt >= cutoffDate)
            .Include(o => o.Customer)
            .Include(o => o.LineItems)
            .OrderByDescending(o => o.Priority)
            .ThenBy(o => o.CreatedAt);
    }
}

// Repository usage
var orders = await _repository.ListAsync(
    new OrdersNeedingFulfilmentSpec(DateTime.UtcNow.AddDays(-7)));
```

## Load: migration from repository pattern

### Migration Path Checklist

When migrating from generic repository to specification pattern:

- [ ] **Identify query hotspots**: Find all `GetAll()`, `Find()`, `Where()` calls
- [ ] **Extract selection logic**: Create specifications for reused/complex queries
- [ ] **Replace inline LINQ**: Convert ad-hoc `.Where()` chains to named specs
- [ ] **Remove generic methods**: Deprecate `GetAll()`, keep only `ListAsync(spec)`
- [ ] **Add composition**: Combine specs with `.And()` / `.Or()` where needed

### Before: Generic Repository (Anti-Pattern)

```csharp
// Generic repository exposes ORM semantics
public interface IRepository<T>
{
    IQueryable<T> GetAll();
    T? GetById(int id);
    IEnumerable<T> Find(Expression<Func<T, bool>> predicate);
}

// Scattered LINQ in handlers
var customers = _repo.GetAll()
    .Where(c => c.TenantId == tenantId && c.IsActive)
    .Include(c => c.Orders)
    .OrderBy(c => c.Name)
    .ToList();
```

### After: Specification Pattern

```csharp
// Specification-based repository
public interface IRepository<T>
{
    Task<T?> GetByIdAsync(int id);
    Task<List<T>> ListAsync(ISpecification<T> spec);
    Task<int> CountAsync(ISpecification<T> spec);
}

// Named, testable specification
var customers = await _repo.ListAsync(
    new ActiveCustomersForTenantSpec(tenantId));
```

### Migration Sequencing

1. **Week 1**: Add specification infrastructure (base class, repository support)
2. **Week 2**: Extract 3-5 most-used query patterns into specifications
3. **Week 3**: Deprecate generic query methods (`GetAll()`, `Find()`)
4. **Week 4**: Remove deprecated methods, enforce specs in code review
