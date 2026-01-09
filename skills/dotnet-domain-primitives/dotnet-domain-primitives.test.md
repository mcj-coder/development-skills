# dotnet-domain-primitives - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Primitive ID Convenience

**Given** agent WITHOUT dotnet-domain-primitives skill
**And** pressure: convenience ("just use Guid, it's simpler")
**When** user says: "Create a Customer entity with an ID"
**And** no guidance on ID typing
**Then** record baseline behaviour:

- Does agent use primitive ID type? (expected: YES - uses `Guid` or `int`)
- Does agent consider strongly typed ID? (expected: NO - defaults to primitive)
- Does agent consider mix-up risks? (expected: NO - not evaluated)
- Rationalizations observed: "Guid is standard", "Keep it simple"

### Test R2: Cross-Entity ID Confusion

**Given** agent WITHOUT dotnet-domain-primitives skill
**And** pressure: speed ("we need this feature today")
**When** user says: "Create OrderService with methods for customers and orders"
**And** both entities use `Guid` for IDs
**Then** record baseline behaviour:

- Does agent catch parameter mix-up risk? (expected: NO - all Guids look the same)
- Does agent warn about type confusion? (expected: NO - Guids are interchangeable)
- Does agent suggest typed IDs? (expected: NO - extra complexity)
- Rationalizations observed: "Developers know which ID is which", "Types are overkill"

### Test R3: Meaningful Primitive Sprawl

**Given** agent WITHOUT dotnet-domain-primitives skill
**And** pressure: deadline ("MVP by end of week")
**When** user says: "Add email and phone to Customer"
**And** no existing value objects
**Then** record baseline behaviour:

- Does agent create value objects? (expected: NO - uses `string`)
- Does agent validate format in entity? (expected: MAYBE - ad-hoc validation)
- Does agent enforce invariants? (expected: NO - validation scattered)
- Rationalizations observed: "Strings are fine for MVP", "We'll refactor later"

### Test R4: Boundary Conversion Hidden

**Given** agent WITHOUT dotnet-domain-primitives skill
**And** pressure: authority ("senior dev says implicit is cleaner")
**When** user says: "Save Customer to database"
**And** using EF Core with Guid column
**Then** record baseline behaviour:

- Does agent use explicit conversion? (expected: NO - relies on EF magic)
- Does agent define value converter? (expected: NO - unnecessary overhead)
- Does agent document boundary? (expected: NO - implicit is obvious)
- Rationalizations observed: "EF handles it", "Less code is better"

### Expected Baseline Failures Summary

- [ ] Agent uses primitive IDs (`Guid`, `int`, `long`, `string`) for entities
- [ ] Agent doesn't warn about ID type confusion risks
- [ ] Agent uses `string` for meaningful primitives (email, phone, money)
- [ ] Agent doesn't create value objects for domain concepts
- [ ] Agent relies on implicit conversions at boundaries
- [ ] Agent doesn't define explicit boundary mapping

## GREEN Phase - WITH Skill

### Test G1: StronglyTypedId Enforcement

**Given** agent WITH dotnet-domain-primitives skill
**When** user says: "Create a Customer entity with an ID"
**Then** agent responds with strongly typed approach including:

- StronglyTypedId definition using source generator
- Usage of typed ID in entity
- Explanation of primitive obsession prevention

**And** agent implements:

- `CustomerId` type with `[StronglyTypedId]` attribute
- Entity using `CustomerId` (not `Guid`)
- ToString for logging/telemetry

**And** agent provides completion evidence:

- [ ] StronglyTypedId attribute applied
- [ ] No primitive ID in domain entity
- [ ] Typed ID used consistently across entity
- [ ] Source generator library referenced

### Test G2: No Primitive IDs in Domain Layer

**Given** agent WITH dotnet-domain-primitives skill
**When** user says: "Create OrderService with methods for customers and orders"
**Then** agent responds with typed approach including:

- Separate typed IDs for each entity (CustomerId, OrderId)
- Method signatures preventing ID mix-up
- Compile-time safety explanation

**And** agent implements:

- `CustomerId` and `OrderId` typed IDs
- Service methods with typed parameters
- No `Guid` parameters in domain service

**And** agent provides completion evidence:

- [ ] Each entity has unique typed ID
- [ ] Service methods use typed IDs (not primitives)
- [ ] Compiler prevents passing wrong ID type
- [ ] No `Guid`/`int` IDs in domain layer

### Test G3: Value Object for Meaningful Primitives

**Given** agent WITH dotnet-domain-primitives skill
**When** user says: "Add email and phone number to Customer"
**Then** agent responds with value object approach including:

- EmailAddress value object with validation
- PhoneNumber value object with validation
- Immutability and equality semantics

**And** agent implements:

- `EmailAddress` value object with format validation
- `PhoneNumber` value object with format validation
- Entity using value objects (not strings)

**And** agent provides completion evidence:

- [ ] Value objects created for email and phone
- [ ] Validation encapsulated in value object
- [ ] Entity uses value objects (not `string`)
- [ ] Immutability enforced
- [ ] Equality implemented (value semantics)

### Test G4: Boundary Conversion Patterns

**Given** agent WITH dotnet-domain-primitives skill
**And** application uses EF Core for persistence
**When** user says: "Configure database persistence for Customer"
**Then** agent responds with explicit boundary approach including:

- EF Core value converter for typed ID
- Explicit mapping configuration
- Separation of domain types from persistence

**And** agent implements:

- Value converter for `CustomerId` to `Guid`
- Value converter for `EmailAddress` to `string`
- Entity configuration with converters

**And** agent provides completion evidence:

- [ ] Value converters defined for typed IDs
- [ ] Value converters defined for value objects
- [ ] Entity configuration uses converters
- [ ] Boundary conversion is explicit (not implicit)
- [ ] Domain types unchanged by persistence concerns

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Primitive Convenience Pressure

**Given** agent WITH dotnet-domain-primitives skill
**And** user says: "Just use Guid, strongly typed is overkill"
**When** agent is tempted to use primitive ID
**Then** agent responds:

- Acknowledges perceived complexity
- Explains compile-time safety benefits
- Shows ID mix-up bugs caught at compile time
- Notes source generators minimize boilerplate

**And** agent does NOT:

- Use primitive ID in domain entity
- Skip typed ID for convenience
- Accept "overkill" rationalization

### Test P2: Resist String Value Pressure

**Given** agent WITH dotnet-domain-primitives skill
**And** user says: "String is fine for email, we validate in the controller"
**When** agent is tempted to use string primitive
**Then** agent responds:

- Acknowledges controller validation exists
- Explains validation should be at domain boundary
- Shows scattered validation leads to inconsistency
- Proposes value object with encapsulated validation

**And** agent does NOT:

- Use `string` for email in domain entity
- Accept scattered validation rationalization
- Skip value object creation

### Test P3: Resist Implicit Conversion Pressure

**Given** agent WITH dotnet-domain-primitives skill
**And** user says: "Implicit operators are cleaner, less code"
**When** agent is tempted to add implicit conversions
**Then** agent responds:

- Acknowledges implicit operators reduce code
- Explains implicit conversion hides boundary crossing
- Shows explicit conversion documents intent
- Notes typed IDs lose value with implicit conversion

**And** agent does NOT:

- Add implicit conversion operators to domain types
- Hide boundary conversions
- Accept "less code" rationalization

## Integration Scenarios

### Test I1: Integration with test-driven-development

**Given** agent WITH dotnet-domain-primitives skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add Order aggregate with OrderId"
**Then** agent:

1. First writes failing test expecting typed OrderId
2. Implements OrderId with StronglyTypedId
3. Implements Order aggregate using OrderId
4. Refactors if needed

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Test verifies typed ID (not primitive)
- [ ] Domain uses typed ID throughout

### Test I2: Integration with verification-before-completion

**Given** agent WITH dotnet-domain-primitives skill
**And** agent WITH superpowers:verification-before-completion
**When** domain model changes are "complete"
**Then** agent:

1. Verifies no primitive IDs in domain layer
2. Confirms value objects for meaningful primitives
3. Checks boundary conversions are explicit
4. Provides evidence checklist

**Evidence:**

- [ ] Verification commands run before declaring complete
- [ ] No primitive IDs in domain (verified by search)
- [ ] Value objects validated for key domain concepts
- [ ] Boundary conversions documented

## Rationalizations Closure

### Test RC1: "StronglyTypedId is overkill"

**Given** agent WITH dotnet-domain-primitives skill
**When** rationalization: "StronglyTypedId is overkill for a small project"
**Then** agent responds:

- "Source generators eliminate boilerplate. One attribute creates the entire type."
- "Small projects grow. Primitive obsession debt compounds over time."
- "Compile-time ID mix-up prevention catches bugs before runtime."

### Test RC2: "Strings are fine for email"

**Given** agent WITH dotnet-domain-primitives skill
**When** rationalization: "String is fine for email, validation is in the API layer"
**Then** agent responds:

- "Validation at boundaries allows invalid values in domain. Multiple entry points mean duplicated validation."
- "Value objects encapsulate validation once. Invalid EmailAddress cannot exist in domain."
- "Refactoring from string to value object is expensive. Start correctly."

### Test RC3: "Implicit conversions are cleaner"

**Given** agent WITH dotnet-domain-primitives skill
**When** rationalization: "Implicit operators make code cleaner"
**Then** agent responds:

- "Implicit conversion defeats the purpose of typed IDs. CustomerId becomes interchangeable with Guid again."
- "Explicit boundary conversion documents where primitives enter/exit domain."
- "Less code is not always cleaner. Intent clarity matters."

### Test RC4: "Value converters are boilerplate"

**Given** agent WITH dotnet-domain-primitives skill
**When** rationalization: "EF Core value converters add boilerplate"
**Then** agent responds:

- "Value converters are one-time setup per type. Reused across all entities."
- "Alternative is implicit mapping that hides domain-persistence boundary."
- "Modern EF Core with source-generated converters minimizes code."

## Verification Assertions

Each GREEN test should verify:

- [ ] StronglyTypedId library selected (source generator preferred)
- [ ] No primitive IDs (`Guid`, `int`, `long`, `string`) in domain entities
- [ ] Value objects created for meaningful primitives
- [ ] Validation encapsulated in value objects
- [ ] Boundary conversions explicit (not implicit operators)
- [ ] EF Core value converters defined for persistence
- [ ] JSON converters defined for serialization (if applicable)
- [ ] ToString implemented for logging/telemetry
- [ ] Equality semantics correct for value objects
- [ ] Tests verify typed IDs (not just implementation works)
- [ ] Evidence checklist provided
