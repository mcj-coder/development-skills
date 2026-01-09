# dotnet-specification-pattern - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Generic Repository Pressure

**Given** agent WITHOUT dotnet-specification-pattern skill
**And** pressure: authority ("existing codebase uses generic repository")
**When** user says: "Add a method to fetch active customers for a tenant"
**And** the codebase has an `IRepository<T>` with `GetAll()`, `Find()` methods
**Then** record baseline behaviour:

- Does agent create a specification? (expected: NO - adds repository method)
- Does agent avoid generic repository? (expected: NO - extends existing pattern)
- Does agent consider query composition? (expected: NO - creates single-purpose method)
- Rationalizations observed: "Match existing pattern", "Repository handles data access"

### Test R2: Scattered LINQ Pressure

**Given** agent WITHOUT dotnet-specification-pattern skill
**And** pressure: convenience ("just add the query inline")
**When** user says: "Filter orders needing fulfilment with date range"
**And** similar queries exist scattered in handlers/controllers
**Then** record baseline behaviour:

- Does agent extract to specification? (expected: NO - adds inline LINQ)
- Does agent consider reuse? (expected: NO - solves immediate need)
- Does agent expose IQueryable? (expected: YES - passes queryable through layers)
- Rationalizations observed: "Quick fix", "LINQ is readable inline"

### Test R3: N+1 Query Pattern

**Given** agent WITHOUT dotnet-specification-pattern skill
**And** pressure: time ("need this working fast")
**When** user says: "Load customers with their orders and order items"
**And** no includes are specified in the query
**Then** record baseline behaviour:

- Does agent use includes in specification? (expected: NO - lazy loading relied on)
- Does agent consider N+1 prevention? (expected: NO - not mentioned)
- Does agent use split queries? (expected: NO - not considered)
- Rationalizations observed: "EF handles it", "Lazy loading is fine"

### Expected Baseline Failures Summary

- [ ] Agent adds methods to generic repository instead of specifications
- [ ] Agent scatters LINQ queries through handlers/controllers
- [ ] Agent exposes IQueryable outside infrastructure boundaries
- [ ] Agent does not compose specifications for reuse
- [ ] Agent does not consider N+1 query prevention
- [ ] Agent duplicates ORM capabilities in repository abstraction

## GREEN Phase - WITH Skill

### Test G1: Specification Over Generic Repository

**Given** agent WITH dotnet-specification-pattern skill
**When** user says: "Add ability to fetch active customers for a tenant"
**Then** agent responds with specification approach including:

- Recommendation to create `ActiveCustomersForTenantSpec`
- Specification defines criteria, not repository
- Repository remains generic executor

**And** agent implements:

- New specification class using Ardalis.Specification or equivalent
- Tenant parameter in specification constructor
- Where clause for active and tenant filtering

**And** agent provides completion evidence:

- [ ] Specification class created
- [ ] No new methods added to generic repository
- [ ] Query logic encapsulated in specification
- [ ] Specification testable in isolation

### Test G2: Query Composition and Reuse

**Given** agent WITH dotnet-specification-pattern skill
**When** user says: "Need to filter orders by status, date range, and include items"
**Then** agent responds with composable specification approach including:

- Base specification with core criteria
- Composition for additional filters
- Include specifications for eager loading

**And** agent implements:

- `OrdersByStatusSpec` with status filter
- Date range composition capability
- Include specification for OrderItems
- AND/OR composition support

**And** agent provides completion evidence:

- [ ] Specifications are composable
- [ ] Query logic is reusable across handlers
- [ ] No LINQ scattered in handlers/controllers
- [ ] Specifications discoverable and versioned

### Test G3: N+1 Query Prevention

**Given** agent WITH dotnet-specification-pattern skill
**When** user says: "Load customers with their orders and order items"
**Then** agent responds with N+1 prevention approach including:

- Include specification for related entities
- Split query consideration for large graphs
- Compiled query option for hot paths

**And** agent implements:

- Specification with explicit includes
- Split query configuration if needed
- Performance notes in specification

**And** agent provides completion evidence:

- [ ] Includes defined in specification
- [ ] N+1 queries prevented by design
- [ ] Split queries used where appropriate
- [ ] No lazy loading relied upon for expected data

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Generic Repository Method Addition

**Given** agent WITH dotnet-specification-pattern skill
**And** user says: "Add GetActiveCustomersByTenant to the repository"
**When** agent is tempted to add repository method
**Then** agent responds:

- Acknowledges the request
- Explains specification pattern benefits
- Shows repository methods duplicate ORM capabilities
- Proposes specification as alternative

**And** agent does NOT:

- Add method to generic repository
- Duplicate EF Core semantics in abstraction
- Accept "match existing pattern" rationalization

### Test P2: Resist Inline LINQ Pressure

**Given** agent WITH dotnet-specification-pattern skill
**And** user says: "Just add the filter inline, it's only used here"
**When** agent is tempted to scatter LINQ
**Then** agent responds:

- Acknowledges simplicity desire
- Explains specification discoverability and versioning
- Shows inline LINQ leads to duplication
- Proposes specification even for single-use queries

**And** agent does NOT:

- Add LINQ queries inline in handlers
- Expose IQueryable outside infrastructure
- Accept "it's only used here" rationalization

### Test P3: Resist N+1 Acceptance

**Given** agent WITH dotnet-specification-pattern skill
**And** user says: "Lazy loading will handle the related data"
**When** agent is tempted to skip includes
**Then** agent responds:

- Acknowledges lazy loading exists
- Explains N+1 performance implications
- Shows includes prevent unnecessary queries
- Proposes explicit include specification

**And** agent does NOT:

- Rely on lazy loading for expected data
- Skip include considerations
- Accept "EF handles it" rationalization

## Review Scenarios

### Test RV1: PR Review - Generic Repository Extension

**Given** agent WITH dotnet-specification-pattern skill
**And** PR adds new method to `IRepository<T>`
**When** agent reviews PR
**Then** agent verifies:

- [ ] Method does not duplicate ORM capabilities
- [ ] Specification pattern considered
- [ ] Domain-specific justification present if repository extended

**And** agent rejects PR if:

- Generic repository duplicates EF semantics
- Specification pattern applicable but not used
- No justification for repository extension

### Test RV2: PR Review - Query Placement

**Given** agent WITH dotnet-specification-pattern skill
**And** PR adds new query logic
**When** agent reviews PR
**Then** agent verifies:

- [ ] Query logic in specification, not handler/controller
- [ ] IQueryable not exposed outside infrastructure
- [ ] Specification composable and reusable

**And** agent rejects PR if:

- LINQ scattered in handlers/controllers
- IQueryable leaked to application layer
- Query logic not encapsulated in specification

### Test RV3: PR Review - N+1 Prevention

**Given** agent WITH dotnet-specification-pattern skill
**And** PR adds queries loading related entities
**When** agent reviews PR
**Then** agent verifies:

- [ ] Includes defined in specification
- [ ] Split queries considered for large graphs
- [ ] No lazy loading relied upon

**And** agent rejects PR if:

- N+1 queries possible from missing includes
- Lazy loading assumed for expected data
- No performance consideration for eager loading

## Rationalizations Closure

### Test RC1: "Generic repository is our pattern"

**Given** agent WITH dotnet-specification-pattern skill
**When** rationalization: "We already use generic repository everywhere"
**Then** agent responds:

- "Generic repositories often duplicate ORM capabilities unnecessarily."
- "Specifications complement repositories - repository executes, specification defines."
- "Migration path: introduce specs alongside, don't extend repository interface."

### Test RC2: "LINQ inline is more readable"

**Given** agent WITH dotnet-specification-pattern skill
**When** rationalization: "LINQ inline is easier to understand"
**Then** agent responds:

- "Inline LINQ leads to duplication and scattered query logic."
- "Specifications are named, discoverable, and testable."
- "Specs with clear names ARE readable: `OrdersNeedingFulfilmentSpec`."

### Test RC3: "EF handles lazy loading"

**Given** agent WITH dotnet-specification-pattern skill
**When** rationalization: "EF lazy loading will fetch related data"
**Then** agent responds:

- "Lazy loading causes N+1 queries - one per related entity access."
- "Explicit includes in specifications prevent this by design."
- "Specs document expected data shape, lazy loading hides it."

### Test RC4: "Specifications add complexity"

**Given** agent WITH dotnet-specification-pattern skill
**When** rationalization: "Creating spec classes for every query is overkill"
**Then** agent responds:

- "Specs are small, focused classes - simpler than repository method proliferation."
- "Composition reduces total spec count through reuse."
- "Testability of selection logic justifies the class per query."

## Integration Scenarios

### Test I1: Integration with dotnet-efcore-practices

**Given** agent WITH dotnet-specification-pattern skill
**And** agent WITH dotnet-efcore-practices skill
**When** user says: "Set up data access layer for Order aggregate"
**Then** agent:

1. Uses Ardalis.Specification pattern
2. Creates dedicated entity configuration
3. Specification uses configuration's queryable
4. N+1 prevention built into specs

**Evidence:**

- [ ] Specification pattern used
- [ ] EF Core practices followed
- [ ] Query performance considered
- [ ] IQueryable contained to infrastructure

### Test I2: Integration with test-driven-development

**Given** agent WITH dotnet-specification-pattern skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add specification for premium customers"
**Then** agent:

1. First writes failing test for specification criteria
2. Creates specification class
3. Verifies specification testable in isolation
4. Test passes with correct filtering

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Specification tested without database
- [ ] Criteria logic verified in isolation
- [ ] Integration test added for EF translation

## Verification Assertions

Each GREEN test should verify:

- [ ] Specification pattern used over generic repository methods
- [ ] Query logic encapsulated in specifications
- [ ] IQueryable contained within infrastructure boundaries
- [ ] Specifications composable for reuse
- [ ] N+1 queries prevented via explicit includes
- [ ] Split queries considered for large entity graphs
- [ ] Specifications named, discoverable, and versioned
- [ ] Generic repository not extended with query methods
- [ ] PR review rejects violations of these rules
- [ ] Evidence checklist provided
