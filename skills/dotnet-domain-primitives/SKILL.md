---
name: dotnet-domain-primitives
description: Prevent primitive obsession by enforcing StronglyTypedIds and value objects in domain models and at boundaries.
---

## Overview

Prevent primitive obsession by enforcing strongly typed identifiers and value objects in
domain models. Conversions to/from primitives are permitted only at explicit boundaries
(persistence, transport, serialization), ensuring type safety and validation throughout
the domain layer.

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

## API Boundary Mapping & Validation

### Before: Primitive Obsession at Boundaries

```csharp
// API Controller - accepts primitives
[ApiController]
[Route("api/[controller]")]
public class CustomersController
{
    private readonly ICustomerService _service;

    [HttpPost]
    public async Task<IActionResult> CreateCustomer(CreateCustomerRequest request)
    {
        // No type safety - primitives passed directly to service
        var result = await _service.CreateCustomer(request.Id, request.Email);
        return Ok(result);
    }
}

// Service layer - accepts primitives, loses domain context
public class CustomerService
{
    public async Task<CustomerDto> CreateCustomer(string id, string email)
    {
        // Validation scattered across layers
        if (string.IsNullOrWhiteSpace(email))
            throw new ArgumentException("Email required");

        // No connection to domain types
        var customer = new Customer { Id = Guid.Parse(id), Email = email };
        await _repository.AddAsync(customer);
        return new CustomerDto { Id = customer.Id.ToString(), Email = email };
    }
}

// DTO - exposes internal structure
public class CreateCustomerRequest
{
    public string Id { get; set; }
    public string Email { get; set; }
}
```

**Problems:**

- No type safety between layers
- Validation scattered across concerns
- Easy to pass invalid primitives

### After: Domain Primitives at Boundaries

```csharp
// Domain types
public partial class CustomerId : IStronglyTypedId<Guid> { }
public partial class EmailAddress : IValueObject<string> { }

// API Controller - explicit boundary conversion
[ApiController]
[Route("api/[controller]")]
public class CustomersController
{
    private readonly ICustomerService _service;
    private readonly ICustomerMapper _mapper;

    [HttpPost]
    public async Task<IActionResult> CreateCustomer(CreateCustomerRequest request)
    {
        // Explicit conversion at boundary
        var customerId = new CustomerId(Guid.Parse(request.Id));
        var email = EmailAddress.Create(request.Email).ThrowIfFailure();

        var result = await _service.CreateCustomer(customerId, email);
        return Ok(_mapper.ToResponse(result));
    }
}

// Service layer - type-safe, domain-focused
public class CustomerService
{
    public async Task<Customer> CreateCustomer(CustomerId id, EmailAddress email)
    {
        // Domain types ensure validity before service runs
        var customer = Customer.Create(id, email).ThrowIfFailure();
        await _repository.AddAsync(customer);
        return customer;
    }
}

// Mapper - explicit conversion layer
public class CustomerMapper
{
    public CustomerResponse ToResponse(Customer customer)
    {
        return new CustomerResponse
        {
            Id = customer.Id.Value.ToString(),  // Explicit back to primitive
            Email = customer.Email.Value        // Explicit back to primitive
        };
    }
}
```

**Benefits:**

- Type safety enforced across layers
- Validation centralized in domain types
- Clear boundary crossing
- Compiler prevents invalid combinations

### Validation Steps for Domain Primitive Implementation

1. **API Controllers:**
   - [ ] DTO properties remain primitives
   - [ ] Convert DTOs to domain types immediately upon entry
   - [ ] Use mapper/converter class for boundary crossing

2. **Service Layer:**
   - [ ] Accept domain primitives, not raw types
   - [ ] Never accept `Guid` when `CustomerId` exists
   - [ ] Ensure validation runs before service logic

3. **Mapping & Serialization:**
   - [ ] JSON serialization handles conversion via custom converters
   - [ ] EF Core value converters map domain types ↔ database columns
   - [ ] No implicit conversions in constructors

4. **Testing:**
   - [ ] Unit test boundary conversion in mapper
   - [ ] Integration test proves invalid primitives rejected at API
   - [ ] Verify domain type validation runs before service

## Load: enforcement

### Acceptance criteria for PRs

- New entities/aggregates use typed IDs.
- No domain-layer primitive IDs added.
- Boundary conversion is explicit and covered by unit tests.

## Red Flags - STOP

These statements indicate primitive obsession patterns:

| Thought                               | Reality                                                       |
| ------------------------------------- | ------------------------------------------------------------- |
| "Guid is fine for identifiers"        | Primitive IDs lose type safety; use strongly typed IDs        |
| "String is good enough for email"     | Value objects centralise validation; prevent invalid data     |
| "Implicit conversions are convenient" | Implicit conversions obscure boundaries; be explicit          |
| "Domain types add too much ceremony"  | Source generators eliminate boilerplate; use them             |
| "We'll add types later"               | Retrofitting types is expensive; start with them              |
| "Validation can happen anywhere"      | Centralise validation in domain types; single source of truth |
