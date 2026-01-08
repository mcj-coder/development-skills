# dotnet-mapping-standard - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Reflection-Based Mapper Preference

**Given** agent WITHOUT dotnet-mapping-standard skill
**And** pressure: familiarity ("AutoMapper is the standard")
**When** user says: "Create a mapper for Customer DTO to domain model"
**And** no guidance on mapping approach
**Then** record baseline behaviour:

- Does agent suggest reflection-based mapper? (expected: YES - AutoMapper default)
- Does agent consider source generation? (expected: NO - not default choice)
- Does agent warn about runtime failures? (expected: NO - assumed safe)
- Rationalizations observed: "AutoMapper is widely used", "Convention over configuration"

### Test R2: Mapping Logic in Domain Entity

**Given** agent WITHOUT dotnet-mapping-standard skill
**And** pressure: convenience ("keep it simple, everything in one place")
**When** user says: "Create Customer entity that can be saved to database"
**And** no explicit boundary separation
**Then** record baseline behaviour:

- Does agent embed ToDto/FromDto in entity? (expected: YES - convenient)
- Does agent keep mapping at boundary? (expected: NO - scattered across code)
- Does agent separate concerns? (expected: NO - mixing domain and mapping)
- Rationalizations observed: "Entity knows how to map itself", "Less classes"

### Test R3: Implicit Boundary Conversions

**Given** agent WITHOUT dotnet-mapping-standard skill
**And** pressure: brevity ("less code is better")
**When** user says: "Map Customer to CustomerDto including typed IDs"
**And** existing typed IDs (CustomerId, EmailAddress)
**Then** record baseline behaviour:

- Does agent use explicit conversion? (expected: NO - relies on implicit)
- Does agent add implicit operators? (expected: MAYBE - for convenience)
- Does agent document boundary crossing? (expected: NO - implicit is hidden)
- Rationalizations observed: "Implicit operators are cleaner", "Compiler handles it"

### Test R4: Injecting Stateless Mappers

**Given** agent WITHOUT dotnet-mapping-standard skill
**And** pressure: testability ("inject everything for mocking")
**When** user says: "Create mapper and register in DI"
**And** mapper has no dependencies
**Then** record baseline behaviour:

- Does agent inject stateless mapper? (expected: YES - "inject for testability")
- Does agent consider static mapper? (expected: NO - DI is the pattern)
- Does agent question DI necessity? (expected: NO - assumed requirement)
- Rationalizations observed: "DI enables mocking", "Consistent patterns"

### Expected Baseline Failures Summary

- [ ] Agent defaults to reflection-based mapping (AutoMapper)
- [ ] Agent doesn't warn about runtime mapping failures
- [ ] Agent embeds mapping logic in domain entities
- [ ] Agent scatters mapping across codebase (not at boundaries)
- [ ] Agent uses implicit conversions for typed IDs
- [ ] Agent injects stateless mappers unnecessarily
- [ ] Agent doesn't consider source-generated alternatives

## GREEN Phase - WITH Skill

### Test G1: Source-Generated Mapping Preference

**Given** agent WITH dotnet-mapping-standard skill
**When** user says: "Create a mapper for Customer DTO to domain model"
**Then** agent responds with source-generated approach including:

- Recommendation for Mapperly (or similar source generator)
- Compile-time safety explanation
- No runtime reflection usage

**And** agent implements:

- `[Mapper]` attribute on mapper class
- Partial class with partial mapping methods
- Explicit type conversions for value objects

**And** agent provides completion evidence:

- [ ] Source-generated mapper selected (Mapperly)
- [ ] No reflection-based mapping (no AutoMapper)
- [ ] Compile-time mapping errors caught
- [ ] Mapping is deterministic and testable

### Test G2: Boundary Conversion Patterns

**Given** agent WITH dotnet-mapping-standard skill
**And** application with API, Domain, and Infrastructure layers
**When** user says: "Set up mapping for Order aggregate across layers"
**Then** agent responds with boundary-focused approach including:

- API boundary mapper (DTO <-> Command/Query)
- Infrastructure boundary mapper (Entity <-> Domain)
- Clear separation of mapping locations

**And** agent implements:

- API project contains request/response mappers
- Infrastructure project contains persistence mappers
- Domain layer has no mapping logic

**And** agent provides completion evidence:

- [ ] Mappers located at architectural boundaries
- [ ] No mapping logic in domain entities
- [ ] Clear boundary between layers
- [ ] Mapping paths are explicit and documented

### Test G3: Static Mapper vs DI Injection Rules

**Given** agent WITH dotnet-mapping-standard skill
**When** user says: "Create OrderMapper for converting DTOs"
**And** mapper has no dependencies (pure mapping)
**Then** agent responds with static mapper approach including:

- Static partial class with `[Mapper]` attribute
- No DI registration required
- Direct static method calls at usage site

**And** agent implements:

- `public static partial class OrderMapper`
- Static mapping methods (`ToDto`, `FromDto`)
- No constructor, no injected dependencies

**And** agent provides completion evidence:

- [ ] Mapper is static (no instantiation)
- [ ] No DI registration for mapper
- [ ] Call site uses static methods directly
- [ ] Mapping is pure/side-effect free

### Test G4: DI Injection When Dependencies Required

**Given** agent WITH dotnet-mapping-standard skill
**When** user says: "Create mapper that needs current user context"
**And** mapping requires runtime data (user context, feature flags)
**Then** agent responds with DI-injected approach including:

- Instance mapper with constructor dependencies
- DI registration for mapper
- Justification for instance over static

**And** agent implements:

- Non-static mapper class with constructor
- Dependencies injected (e.g., `IUserContext`)
- DI registration in service collection

**And** agent provides completion evidence:

- [ ] Mapper has constructor dependencies
- [ ] Dependencies are used in mapping logic
- [ ] DI registration justified by dependencies
- [ ] Instance mapper pattern documented

### Test G5: Typed ID and Value Object Mapping

**Given** agent WITH dotnet-mapping-standard skill
**And** domain uses typed IDs (CustomerId, OrderId) and value objects (EmailAddress)
**When** user says: "Map CustomerDto to Customer domain model"
**Then** agent responds with explicit conversion approach including:

- Private mapping methods for typed IDs
- Private mapping methods for value objects
- No implicit operators used

**And** agent implements:

- `private static CustomerId Map(Guid id) => CustomerId.From(id)`
- `private static EmailAddress Map(string email) => EmailAddress.From(email)`
- Explicit boundary documented in mapper

**And** agent provides completion evidence:

- [ ] Typed IDs mapped explicitly
- [ ] Value objects mapped explicitly
- [ ] No implicit conversion operators
- [ ] Boundary conversion is visible and testable

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Reflection Mapping Pressure

**Given** agent WITH dotnet-mapping-standard skill
**And** user says: "Just use AutoMapper, it's the industry standard"
**When** agent is tempted to use reflection-based mapping
**Then** agent responds:

- Acknowledges AutoMapper popularity
- Explains runtime failure risks (configuration errors)
- Shows source-generation catches errors at compile time
- Notes Mapperly provides similar convenience with safety

**And** agent does NOT:

- Use AutoMapper or reflection-based mapper
- Accept "industry standard" rationalization
- Skip source-generated alternative

### Test P2: Resist Mapping in Entity Pressure

**Given** agent WITH dotnet-mapping-standard skill
**And** user says: "Add ToDto() method to Customer entity"
**When** agent is tempted to add mapping to domain entity
**Then** agent responds:

- Acknowledges convenience of entity methods
- Explains separation of concerns violation
- Shows mapping belongs at boundaries, not domain
- Proposes separate mapper class

**And** agent does NOT:

- Add mapping methods to domain entity
- Accept "entity knows itself" rationalization
- Mix mapping with domain logic

### Test P3: Resist Unnecessary DI Injection

**Given** agent WITH dotnet-mapping-standard skill
**And** user says: "Inject the mapper for testability"
**When** mapper has no dependencies (pure mapping)
**Then** agent responds:

- Acknowledges testability concern is valid
- Explains pure mappers are testable without mocking
- Shows static mappers can be tested directly
- Notes DI overhead is unnecessary for stateless code

**And** agent does NOT:

- Inject stateless mapper into DI
- Accept "inject for testability" rationalization
- Add unnecessary abstraction layer

### Test P4: Resist Implicit Conversion Pressure

**Given** agent WITH dotnet-mapping-standard skill
**And** user says: "Add implicit operator for CustomerId to Guid"
**When** agent is tempted to add implicit conversion
**Then** agent responds:

- Acknowledges implicit operators reduce code
- Explains implicit conversion hides boundary crossing
- Shows explicit mapping documents intent
- Notes typed IDs lose value with implicit conversion

**And** agent does NOT:

- Add implicit conversion operators
- Hide boundary conversions
- Accept "less code" rationalization

## Integration Scenarios

### Test I1: Integration with dotnet-domain-primitives

**Given** agent WITH dotnet-mapping-standard skill
**And** agent WITH dotnet-domain-primitives skill
**When** user says: "Create Customer with typed ID and map to DTO"
**Then** agent:

1. Creates typed CustomerId (from domain-primitives)
2. Creates mapper with explicit type conversions
3. No implicit operators between types
4. Boundary conversions are explicit

**Evidence:**

- [ ] Typed ID from domain-primitives used
- [ ] Mapper handles typed ID conversion explicitly
- [ ] No implicit operators added
- [ ] Both skills applied consistently

### Test I2: Integration with test-driven-development

**Given** agent WITH dotnet-mapping-standard skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add mapping for Order aggregate"
**Then** agent:

1. First writes failing test for mapping
2. Implements source-generated mapper
3. Tests verify boundary conversions
4. Refactors if needed

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Mapping tests verify typed ID conversion
- [ ] Tests verify value object conversion
- [ ] Mapper is testable (static or with minimal dependencies)

### Test I3: Integration with verification-before-completion

**Given** agent WITH dotnet-mapping-standard skill
**And** agent WITH superpowers:verification-before-completion
**When** mapping changes are "complete"
**Then** agent:

1. Verifies source-generated mapper used (no reflection)
2. Confirms mapping at boundaries only
3. Checks static vs DI pattern is correct
4. Provides evidence checklist

**Evidence:**

- [ ] Verification commands run before declaring complete
- [ ] No reflection-based mappers found
- [ ] Mappers located at architectural boundaries
- [ ] Static/DI pattern justified for each mapper

## Rationalizations Closure

### Test RC1: "AutoMapper is the standard"

**Given** agent WITH dotnet-mapping-standard skill
**When** rationalization: "AutoMapper is the industry standard, everyone uses it"
**Then** agent responds:

- "AutoMapper relies on runtime reflection and conventions. Configuration errors surface at runtime, not compile time."
- "Source generators like Mapperly provide similar convenience with compile-time safety."
- "Industry popularity doesn't eliminate runtime failure modes."

### Test RC2: "Mapping in entity is convenient"

**Given** agent WITH dotnet-mapping-standard skill
**When** rationalization: "Just add ToDto() to the entity, it knows its own structure"
**Then** agent responds:

- "Entities should not know about DTOs. Domain layer has no dependency on presentation concerns."
- "Mapping logic at boundaries keeps concerns separated and dependencies pointing inward."
- "Convenience now creates coupling debt. Mappers are the right abstraction."

### Test RC3: "Inject mappers for testability"

**Given** agent WITH dotnet-mapping-standard skill
**When** rationalization: "Inject the mapper so we can mock it in tests"
**Then** agent responds:

- "Pure mappers are deterministic. Test inputs produce expected outputs without mocking."
- "Mocking a stateless mapper tests the mock, not the mapping logic."
- "Static mappers are directly testable. DI adds unnecessary indirection."

### Test RC4: "Implicit conversion is cleaner"

**Given** agent WITH dotnet-mapping-standard skill
**When** rationalization: "Implicit operators between types reduce boilerplate"
**Then** agent responds:

- "Implicit conversion defeats the purpose of typed IDs. CustomerId becomes interchangeable with Guid again."
- "Explicit boundary conversion documents where primitives enter/exit domain."
- "Cleaner syntax is not worth hidden boundary crossings."

### Test RC5: "We'll add mapping tests later"

**Given** agent WITH dotnet-mapping-standard skill
**When** rationalization: "Mapping is straightforward, we can add tests later"
**Then** agent responds:

- "Critical boundary conversions need tests now. Typed IDs and value objects have failure modes."
- "Source-generated mappers make testing easy. No excuses to skip coverage."
- "Later becomes never. Mapping bugs at boundaries cause runtime failures."

## Verification Assertions

Each GREEN test should verify:

- [ ] Source-generated mapper library used (Mapperly preferred)
- [ ] No reflection-based mapping (AutoMapper, etc.)
- [ ] Mappers located at architectural boundaries only
- [ ] No mapping logic in domain entities
- [ ] Static mappers used for pure/stateless mapping
- [ ] DI injection only when mapper has dependencies
- [ ] Typed IDs mapped with explicit conversions
- [ ] Value objects mapped with explicit conversions
- [ ] No implicit conversion operators
- [ ] Mapping is deterministic and side-effect free
- [ ] Critical boundary conversions have tests
- [ ] Evidence checklist provided
