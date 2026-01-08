# dotnet-efcore-practices - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Migration Placement Pressure

**Given** agent WITHOUT dotnet-efcore-practices skill
**And** pressure: convenience ("just add it to the persistence project")
**When** user says: "Add a new migration for the Order entity"
**And** the persistence project already has migrations inline
**Then** record baseline behaviour:

- Does agent isolate migrations? (expected: NO - follows existing pattern)
- Does agent create a dedicated migrations project? (expected: NO - adds inline)
- Does agent consider coverage impact? (expected: NO - not mentioned)
- Rationalizations observed: "Keep migrations with DbContext", "Simpler structure"

### Test R2: Inline Configuration Pressure

**Given** agent WITHOUT dotnet-efcore-practices skill
**And** pressure: authority ("existing codebase uses OnModelCreating")
**When** user says: "Add configuration for the new Product entity"
**And** other entities are configured inline in DbContext
**Then** record baseline behaviour:

- Does agent create dedicated configuration type? (expected: NO - follows pattern)
- Does agent use IEntityTypeConfiguration<T>? (expected: NO - adds to OnModelCreating)
- Does agent consider maintainability? (expected: NO - consistency wins)
- Rationalizations observed: "Match existing pattern", "All in one place"

### Test R3: Missing Attribute Linking

**Given** agent WITHOUT dotnet-efcore-practices skill
**And** pressure: time ("need this done quickly")
**When** user says: "Create EF configuration for Customer entity"
**And** no attribute-linking pattern exists in codebase
**Then** record baseline behaviour:

- Does agent add traceability attribute? (expected: NO - not considered)
- Does agent ensure deterministic discovery? (expected: NO - uses ApplyConfigurationsFromAssembly only)
- Does agent document entity-config link? (expected: NO - assumed obvious)
- Rationalizations observed: "EF auto-discovers configs", "Attributes are overhead"

### Expected Baseline Failures Summary

- [ ] Agent adds migrations to main persistence project
- [ ] Agent configures entities inline in OnModelCreating
- [ ] Agent does not use dedicated configuration types
- [ ] Agent does not add attribute linking for traceability
- [ ] Agent does not consider coverage exclusion for migrations
- [ ] Agent does not ensure deterministic configuration application

## GREEN Phase - WITH Skill

### Test G1: Migration Project Isolation

**Given** agent WITH dotnet-efcore-practices skill
**When** user says: "Add a new migration for the Order entity"
**Then** agent responds with migration isolation approach including:

- Recommendation for dedicated migrations project
- Project naming convention (e.g., `*.Persistence.Migrations`)
- Coverage exclusion requirement

**And** agent implements:

- Migration in dedicated project
- Project reference setup if new project
- Coverage configuration update if needed

**And** agent provides completion evidence:

- [ ] Migration created in dedicated migrations project
- [ ] Migration not in main persistence or domain project
- [ ] Coverage config excludes migrations project
- [ ] Project structure follows recommended layout

### Test G2: Dedicated Type Configuration

**Given** agent WITH dotnet-efcore-practices skill
**When** user says: "Add EF configuration for the new Invoice entity"
**Then** agent responds with dedicated configuration approach including:

- New configuration class implementing IEntityTypeConfiguration<Invoice>
- Attribute linking for traceability
- DbContext remaining orchestration-only

**And** agent implements:

- InvoiceConfiguration class with attribute
- Configuration registered via discovery mechanism
- No inline configuration in OnModelCreating

**And** agent provides completion evidence:

- [ ] Dedicated configuration type created
- [ ] IEntityTypeConfiguration<T> implemented
- [ ] Entity-configuration attribute link present
- [ ] Configuration discoverable by attribute scanning
- [ ] OnModelCreating remains orchestration-only

### Test G3: Attribute-Linked Configuration Discovery

**Given** agent WITH dotnet-efcore-practices skill
**And** multiple entities require configuration
**When** user says: "Set up EF Core configuration infrastructure"
**Then** agent responds with attribute-linked discovery including:

- Custom attribute definition (EntityConfigurationForAttribute or equivalent)
- Configuration discovery mechanism
- Deterministic application order

**And** agent implements:

- Attribute class with EntityType property
- Assembly scanning for attributed configuration types
- Stable ordering (by full name) for determinism

**And** agent provides completion evidence:

- [ ] Custom attribute defined for entity-config linking
- [ ] Discovery mechanism scans for attributed types
- [ ] Configurations applied in stable/deterministic order
- [ ] Traceability from entity to configuration type established
- [ ] No ad-hoc registration drift possible

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Inline Migration Pressure

**Given** agent WITH dotnet-efcore-practices skill
**And** user says: "Just put the migration in the Persistence project, simpler"
**When** agent is tempted to add migrations to main project
**Then** agent responds:

- Acknowledges simplicity desire
- Explains migrations are generated scaffolding, not business logic
- Shows coverage metrics will be skewed
- Proposes dedicated migrations project

**And** agent does NOT:

- Add migrations to main persistence project
- Add migrations to domain project
- Skip coverage exclusion consideration

### Test P2: Resist OnModelCreating Configuration Pressure

**Given** agent WITH dotnet-efcore-practices skill
**And** user says: "Other entities are configured in OnModelCreating, be consistent"
**When** agent is tempted to add inline configuration
**Then** agent responds:

- Acknowledges consistency concern
- Explains DbContext becomes monolithic with inline config
- Shows dedicated types improve maintainability
- Proposes migration path for existing inline configs

**And** agent does NOT:

- Add entity configuration inline in OnModelCreating
- Accept "consistency with bad pattern" rationalization
- Create configuration without attribute linking

### Test P3: Resist Attribute Overhead Pressure

**Given** agent WITH dotnet-efcore-practices skill
**And** user says: "Attributes are overhead, EF auto-discovers configurations"
**When** agent is tempted to skip attribute linking
**Then** agent responds:

- Acknowledges EF's native discovery capability
- Explains traceability benefits of explicit linking
- Shows deterministic ordering prevents subtle bugs
- Proposes attribute as complement to ApplyConfigurationsFromAssembly

**And** agent does NOT:

- Skip attribute linking for traceability
- Accept "EF handles it" rationalization
- Create configuration without entity link

## Review Scenarios

### Test RV1: PR Review - Migration Placement

**Given** agent WITH dotnet-efcore-practices skill
**And** PR adds a new migration
**When** agent reviews PR
**Then** agent verifies:

- [ ] Migration is in dedicated migrations project
- [ ] Migration is NOT in main persistence project
- [ ] Migration is NOT in domain project
- [ ] Coverage config still excludes migrations

**And** agent rejects PR if:

- Migration is in wrong project
- Coverage exclusion missing or removed

### Test RV2: PR Review - Entity Configuration

**Given** agent WITH dotnet-efcore-practices skill
**And** PR adds new entity or changes configuration
**When** agent reviews PR
**Then** agent verifies:

- [ ] Dedicated configuration type exists
- [ ] Configuration implements IEntityTypeConfiguration<T>
- [ ] Attribute links configuration to entity
- [ ] Configuration is discoverable by scanning
- [ ] OnModelCreating not used for entity config

**And** agent rejects PR if:

- Configuration is inline in OnModelCreating
- Attribute link is missing
- Configuration not discoverable

### Test RV3: PR Review - New Entity Checklist

**Given** agent WITH dotnet-efcore-practices skill
**And** PR adds new entity type
**When** agent reviews PR
**Then** agent verifies complete entity setup:

- [ ] Entity class defined
- [ ] Configuration type created
- [ ] Attribute link present
- [ ] Configuration discovered and applied
- [ ] Any migration in correct project

## Integration Scenarios

### Test I1: Integration with testcontainers-integration-tests

**Given** agent WITH dotnet-efcore-practices skill
**And** agent WITH testcontainers-integration-tests skill
**When** user says: "Set up integration tests for EF Core persistence"
**Then** agent:

1. Uses Testcontainers for real database
2. Tests entity configurations work correctly
3. Verifies migrations apply cleanly to real database
4. Tests attribute-linked discovery functions

**Evidence:**

- [ ] Testcontainers used (not in-memory or mocks)
- [ ] Entity configurations tested with real DB
- [ ] Migrations tested against real DB schema
- [ ] Configuration discovery verified

### Test I2: Integration with test-driven-development

**Given** agent WITH dotnet-efcore-practices skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add new Order aggregate with persistence"
**Then** agent:

1. First writes failing test for Order persistence
2. Creates Order entity
3. Creates OrderConfiguration with attribute
4. Creates migration in migrations project
5. Verifies test passes

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Dedicated configuration created
- [ ] Attribute linking implemented
- [ ] Migration in correct project

## Rationalizations Closure

### Test RC1: "Migrations belong with DbContext"

**Given** agent WITH dotnet-efcore-practices skill
**When** rationalization: "Migrations should be with the DbContext"
**Then** agent responds:

- "Migrations are generated scaffolding, not application code."
- "Isolating migrations keeps coverage metrics accurate and meaningful."
- "DbContext references migrations project; migrations don't need DbContext code."

### Test RC2: "OnModelCreating is simpler"

**Given** agent WITH dotnet-efcore-practices skill
**When** rationalization: "All configuration in OnModelCreating is simpler"
**Then** agent responds:

- "OnModelCreating becomes a monolithic class as entities grow."
- "Dedicated configuration types enable single-responsibility."
- "Attribute linking provides clear traceability and discoverability."

### Test RC3: "Attributes are unnecessary overhead"

**Given** agent WITH dotnet-efcore-practices skill
**When** rationalization: "EF auto-discovers, attributes are overhead"
**Then** agent responds:

- "Attributes provide explicit traceability between entity and configuration."
- "Deterministic ordering prevents subtle bugs from nondeterministic scanning."
- "Attributes complement EF discovery, they don't replace it."

### Test RC4: "Coverage doesn't matter for migrations"

**Given** agent WITH dotnet-efcore-practices skill
**When** rationalization: "Just exclude migration files from coverage"
**Then** agent responds:

- "Project-level exclusion is cleaner than file-pattern exclusion."
- "Dedicated project makes exclusion config simpler and more robust."
- "Prevents accidental coverage of new migrations without config updates."

## Verification Assertions

Each GREEN test should verify:

- [ ] Migrations in dedicated project (not inline)
- [ ] Migrations project excluded from coverage
- [ ] Dedicated configuration types used
- [ ] IEntityTypeConfiguration<T> implemented
- [ ] Attribute linking for entity-config traceability
- [ ] Configuration discovery via attribute scanning
- [ ] Deterministic configuration application order
- [ ] DbContext is orchestration-only (applies configs, doesn't define them)
- [ ] PR review rejects violations of these rules
- [ ] Evidence checklist provided
