---
name: dotnet-mapping-standard
description: Standardise mapping (DTOs/contracts/persistence models) using source-generated mappers and explicit boundary conversions.
metadata:
  type: Implementation
  priority: P2
---

## Overview

Standardise mapping between DTOs, domain models, and persistence models using source-generated
mappers. Mappings live at explicit boundaries (API, infrastructure) with deterministic,
testable conversion paths and no runtime reflection magic.

## When to Use

- Mapping between API request/response DTOs and domain models
- Converting domain entities to/from persistence models
- Handling integration event contracts at service boundaries
- Reviewing PRs that introduce new mapping logic
- Refactoring existing reflection-based mappers to source-generated alternatives

## Core Workflow

1. **Identify mapping boundaries**: Locate where DTOs cross into domain or persistence layers
2. **Choose source-generated mapper**: Select Mapperly or similar compile-time mapper
3. **Create explicit mappers**: Implement mapper classes at boundary projects (API, Infrastructure)
4. **Handle typed IDs explicitly**: Map strongly typed IDs and value objects with explicit conversions
5. **Apply DI gating rules**: Use static mappers unless mapper has injected dependencies
6. **Add mapping tests**: Include round-trip tests for critical boundary conversions
7. **Verify side-effect free**: Ensure mappings have no side effects or external calls

## Core

### Defaults

- Prefer **open-source, source-generated mapping** tools.
- Mappings live **at boundaries** (API project, Infrastructure project), not scattered across the domain.
- Typed IDs and value objects must be mapped explicitly (see `dotnet-domain-primitives`).

### Anti-patterns to avoid

- Reflection-based "magic mapping" that fails at runtime.
- Mapping logic embedded inside domain entities.
- Implicit conversions that obscure boundary crossings.

### Review rules

- New DTO/domain/persistence types must have deterministic, testable mapping paths.
- Mapping must be side-effect free.

## Load: examples

- API: map request DTO -> command with explicit typed ID parsing/creation.
- Persistence: map EF entity -> domain aggregate using explicit value object construction.
- Integration: map external event contract -> internal event with boundary validations.

## Load: advanced

### Projections / query scenarios

- Prefer projection mappings that avoid materialising large object graphs when not needed.
- Keep read models separate where pragmatic.

### Error strategy

- Invalid boundary inputs fail fast at the boundary (validation).
- Domain invariants enforced by constructors/factories.

## Load: enforcement

### Review heuristic: mapper DI gating

- If a mapper is injected into a constructor (controller/handler/service), reviewers must
  check whether the mapper implementation itself has injected dependencies.
- If the mapper has **no** injected dependencies (pure/stateless mapping), require refactor
  to a **static mapper** and remove DI registration.
- Injection is permitted only when mapping depends on external collaborators and those
  collaborators are injected into the mapper.
- "Inject for testability" is not sufficient when mapping is deterministic; test the mapper
  directly.

- Reject PRs introducing runtime reflection mapping unless justified per `dotnet-source-generation-first`.
- Require mapping tests for critical boundary conversions (typed IDs and value objects).

## Load: testing

### Mapping Unit Test Template

```csharp
public class OrderMapperTests
{
    [Fact]
    public void ToEntity_WithValidDto_MapsAllProperties()
    {
        // Arrange
        var dto = new CreateOrderRequest
        {
            CustomerId = "cust-123",
            Amount = 99.99m,
            Currency = "GBP"
        };

        // Act
        var entity = OrderMapper.ToEntity(dto);

        // Assert
        entity.CustomerId.Value.Should().Be("cust-123");
        entity.Amount.Value.Should().Be(99.99m);
        entity.Amount.Currency.Should().Be(Currency.GBP);
    }

    [Fact]
    public void ToDto_RoundTrip_PreservesData()
    {
        // Arrange
        var original = new Order(
            CustomerId.From("cust-123"),
            Money.From(99.99m, Currency.GBP));

        // Act
        var dto = OrderMapper.ToDto(original);
        var roundTripped = OrderMapper.ToEntity(dto);

        // Assert
        roundTripped.Should().BeEquivalentTo(original);
    }
}
```

### DI Gating Checklist

When reviewing mappers registered in DI:

- [ ] Does the mapper have **zero** injected dependencies?
  - **YES**: Refactor to static mapper, remove DI registration
  - **NO**: Proceed to next check
- [ ] Are all injected dependencies used during mapping?
  - **NO**: Remove unused dependencies
  - **YES**: Proceed
- [ ] Is injection for "testability only"?
  - **YES**: Reject - test static mappers directly
  - **NO**: Injection acceptable

## Red Flags - STOP

These statements indicate mapping anti-patterns:

| Thought                                 | Reality                                                         |
| --------------------------------------- | --------------------------------------------------------------- |
| "AutoMapper conventions will handle it" | Explicit mapping prevents runtime surprises; be deliberate      |
| "Mapping logic belongs in the entity"   | Keep entities clean; mappers handle boundary concerns           |
| "Inject the mapper for testability"     | Pure mappers don't need DI; test static mappers directly        |
| "Runtime reflection is fine"            | Source-generated mappers are faster and fail at compile time    |
| "Implicit conversions are convenient"   | Explicit conversions make boundary crossings visible            |
| "Round-trip tests aren't worth it"      | Round-trip tests catch subtle mapping bugs; always include them |
