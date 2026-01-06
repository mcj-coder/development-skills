# testcontainers-integration-tests - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Mock Everything Pressure

**Given** agent WITHOUT testcontainers-integration-tests skill
**And** pressure: time ("need tests written today")
**When** user says: "Write integration tests for the order repository"
**And** repository has complex SQL queries and transactions
**Then** record baseline behaviour:

- Does agent use real database? (expected: NO - mocks repository)
- Does agent test actual SQL? (expected: NO - mocks bypass SQL)
- Does agent test transactions? (expected: NO - mocks don't have transactions)
- Rationalizations observed: "Mocks are faster", "Unit tests are enough"

### Test R2: In-Memory Database Authority

**Given** agent WITHOUT testcontainers-integration-tests skill
**And** pressure: authority ("tech lead uses H2 for testing")
**When** user says: "Write tests for PostgreSQL-specific queries"
**And** queries use PostgreSQL-specific features (JSON operators, array types)
**Then** record baseline behaviour:

- Does agent question H2 compatibility? (expected: NO - follows pattern)
- Does agent test PostgreSQL features? (expected: NO - H2 doesn't support them)
- Does agent suggest Testcontainers? (expected: NO - not considered)
- Rationalizations observed: "H2 is the standard here", "Close enough"

### Test R3: Shared Database Sunk Cost

**Given** agent WITHOUT testcontainers-integration-tests skill
**And** pressure: sunk cost ("team uses shared test database for 2 years")
**When** user says: "Integration tests are flaky and fail randomly"
**And** flakiness is due to shared state between tests
**Then** record baseline behaviour:

- Does agent identify shared state problem? (expected: NO - blames test code)
- Does agent suggest test isolation? (expected: NO - works around shared state)
- Does agent propose Testcontainers? (expected: NO - too disruptive)
- Rationalizations observed: "Just need better cleanup", "Shared database is standard"

### Expected Baseline Failures Summary

- [ ] Agent mocks database instead of using real database
- [ ] Agent uses in-memory database incompatible with production
- [ ] Agent doesn't implement test isolation
- [ ] Agent doesn't test database-specific features
- [ ] Agent doesn't test transactions or concurrency
- [ ] Agent creates flaky tests due to shared state

## GREEN Phase - WITH Skill

### Test G1: Integration Tests with Testcontainers

**Given** agent WITH testcontainers-integration-tests skill
**When** user says: "Write integration tests for OrderRepository using PostgreSQL"
**Then** agent responds with Testcontainers approach including:

- Real PostgreSQL container configuration
- Container lifecycle management (start/stop)
- Test isolation strategy (transactions or cleanup)
- Database schema setup (migrations)

**And** agent implements:

- Testcontainers setup for PostgreSQL
- Test class with proper lifecycle
- Tests against real database (no mocks)

**And** agent provides completion evidence:

- [ ] Testcontainers library selected for language
- [ ] Container configured with production-matching version
- [ ] Container lifecycle managed (start/stop)
- [ ] Test isolation implemented
- [ ] Tests query real database (no mocks)
- [ ] Database-specific features tested

### Test G2: Multi-Container Setup

**Given** agent WITH testcontainers-integration-tests skill
**And** application uses PostgreSQL and RabbitMQ
**When** user says: "Write integration tests for order processing flow"
**Then** agent responds with multi-container approach including:

- Multiple container configuration
- Parallel container startup for performance
- End-to-end test spanning containers

**And** agent implements:

- PostgreSQL and RabbitMQ containers
- Parallel startup (Task.WhenAll or equivalent)
- E2E test verifying database and queue

**And** agent provides completion evidence:

- [ ] Multiple containers configured
- [ ] Containers started in parallel
- [ ] End-to-end test with both components
- [ ] Database verified with real queries
- [ ] Message queue verified with real consumer
- [ ] Container cleanup implemented

### Test G3: CI/CD Optimization

**Given** agent WITH testcontainers-integration-tests skill
**And** tests run in CI/CD pipeline
**When** user says: "Integration tests are too slow in CI (3 minutes)"
**Then** agent responds with optimization strategies including:

- Container reuse (singleton/fixture pattern)
- Parallel test execution
- Image pre-pull in CI setup
- Specific image tags (not 'latest')

**And** agent implements:

- Shared fixture for container reuse
- State cleanup between tests (not restart)
- CI configuration for image caching
- Parallel test execution config

**And** agent provides completion evidence:

- [ ] Container reuse implemented (shared fixture)
- [ ] State cleanup between tests
- [ ] Parallel test execution configured
- [ ] CI image pre-pull configured
- [ ] Specific image tags used
- [ ] Performance improvement measured

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Mock Pressure

**Given** agent WITH testcontainers-integration-tests skill
**And** user says: "Mocks are faster, just mock the database"
**When** agent is tempted to use mocks instead of containers
**Then** agent responds:

- Acknowledges performance concern
- Explains optimized Testcontainers run in seconds
- Shows mocks don't catch SQL bugs or DB-specific issues
- Proposes container reuse for speed

**And** agent does NOT:

- Mock database layer for integration tests
- Skip database-specific testing
- Accept "mocks are enough" rationalization

### Test P2: Resist In-Memory Database Pressure

**Given** agent WITH testcontainers-integration-tests skill
**And** user says: "Just use H2, it's close enough to PostgreSQL"
**When** agent is tempted to use in-memory database
**Then** agent responds:

- Acknowledges H2 is convenient
- Explains PostgreSQL-specific features won't work in H2
- Shows JSON operators, array types, etc. differ
- Proposes Testcontainers with real PostgreSQL

**And** agent does NOT:

- Use in-memory DB for PostgreSQL-specific tests
- Accept "close enough" rationalization
- Skip testing database-specific features

### Test P3: Resist Shared Database Pressure

**Given** agent WITH testcontainers-integration-tests skill
**And** user says: "Team uses shared database, just work around it"
**When** agent is tempted to use shared test database
**Then** agent responds:

- Acknowledges existing team practice
- Explains flaky tests from shared state
- Shows isolation prevents coordination overhead
- Proposes Testcontainers for isolated tests

**And** agent does NOT:

- Use shared database without isolation
- Accept "just add cleanup" workaround
- Create tests with shared state dependencies

## Integration Scenarios

### Test I1: Integration with test-driven-development

**Given** agent WITH testcontainers-integration-tests skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add database integration for order service"
**Then** agent:

1. First writes failing integration test with Testcontainers
2. Implements minimal code to make test pass
3. Refactors with more tests as needed

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Testcontainers used in integration tests
- [ ] Real database tested (not mocks)

### Test I2: Integration with verification-before-completion

**Given** agent WITH testcontainers-integration-tests skill
**And** agent WITH superpowers:verification-before-completion
**When** integration tests are "complete"
**Then** agent:

1. Runs all integration tests
2. Confirms containers start and stop cleanly
3. Verifies tests pass with real infrastructure
4. Provides evidence checklist

**Evidence:**

- [ ] Verification commands run before declaring complete
- [ ] Integration tests passing
- [ ] Container lifecycle verified (no orphaned containers)
- [ ] Evidence provided (test output, not just assertion)

## Rationalizations Closure

### Test RC1: "Mocks are faster"

**Given** agent WITH testcontainers-integration-tests skill
**When** rationalization: "Mocks are faster"
**Then** agent responds:

- "Optimized Testcontainers run in seconds. Container reuse + parallel tests achieve comparable speed."
- "Mocks don't catch SQL bugs or database-specific issues. Real database tests catch real bugs."

### Test RC2: "In-memory is close enough"

**Given** agent WITH testcontainers-integration-tests skill
**When** rationalization: "H2 is close enough to PostgreSQL"
**Then** agent responds:

- "Database-specific features differ. JSON operators, array types, window functions may behave differently."
- "Test with production database for confidence. Testcontainers makes this easy."

### Test RC3: "Testcontainers is too slow"

**Given** agent WITH testcontainers-integration-tests skill
**When** rationalization: "Testcontainers is too slow for CI"
**Then** agent responds:

- "Optimize with container reuse (shared fixture) and parallel execution."
- "Pre-pull images in CI setup. Specific image tags enable caching."
- "4x+ speed improvements possible with optimization."

### Test RC4: "CI doesn't support Docker"

**Given** agent WITH testcontainers-integration-tests skill
**When** rationalization: "Our CI doesn't have Docker"
**Then** agent responds:

- "Most modern CI supports Docker (GitHub Actions, GitLab CI, Azure DevOps, CircleCI, Jenkins)."
- "If truly no Docker, consider cloud-based CI or cloud-hosted test databases."
- "Testcontainers Cloud available for restricted environments."

## Verification Assertions

Each GREEN test should verify:

- [ ] Testcontainers library selected for language
- [ ] Infrastructure dependencies identified
- [ ] Containers configured with production-matching versions
- [ ] Container lifecycle strategy defined
- [ ] Test isolation implemented
- [ ] Database schema setup (migrations)
- [ ] Tests use real infrastructure (no mocks for infra layer)
- [ ] Database-specific features tested
- [ ] Multi-container setup if needed
- [ ] CI/CD optimization applied
- [ ] Container requirements documented
- [ ] Execution time measured (<10s per test or optimized)
- [ ] Evidence checklist provided
