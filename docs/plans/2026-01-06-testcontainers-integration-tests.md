# Testcontainers Integration Tests Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan
> task-by-task.

**Goal:** Create a skill that guides agents to use Testcontainers for integration tests with real
infrastructure instead of mocks.

**Architecture:** Skill follows progressive loading pattern with core SKILL.md (<300 words) and
references folder for language-specific setup, performance optimization, and CI/CD integration.
References superpowers:test-driven-development and superpowers:verification-before-completion.

**Tech Stack:** Testcontainers for Java, .NET, Python, and Node.js; Docker; CI/CD platforms
(GitHub Actions, GitLab CI, Azure DevOps)

---

## Task 1: Create BDD Test File (RED Phase)

### Files

- Create: `skills/testcontainers-integration-tests/testcontainers-integration-tests.test.md`

### Step 1: Write the failing BDD test scenarios

Define baseline (RED) scenarios that should fail without the skill, then GREEN scenarios that pass
with the skill. This follows the repository's TDD mandate.

```markdown
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
```

### Step 2: Verify checklist fails against current state

Run: Check that no `skills/testcontainers-integration-tests/SKILL.md` exists
Expected: File does not exist (RED phase confirmed)

### Step 3: Commit BDD test file

```bash
git add skills/testcontainers-integration-tests/testcontainers-integration-tests.test.md
git commit -m "test(testcontainers): add BDD test scenarios (RED phase)"
```

---

## Task 2: Create SKILL.md Core File

### Files

- Create: `skills/testcontainers-integration-tests/SKILL.md`

### Step 1: Write the skill file (under 300 words)

```markdown
---
name: testcontainers-integration-tests
description: Use when integration tests require real infrastructure (database, message queue, cache) or when mocking infrastructure is insufficient. Defines container lifecycle, test isolation, and performance optimization for Testcontainers-based testing.
---

# Testcontainers Integration Tests

## Overview

Use **real infrastructure in containers** for integration tests. Mocks don't catch SQL bugs,
database-specific issues, or integration failures. Testcontainers provides isolated, repeatable
tests with production-equivalent infrastructure.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Integration tests need real database, queue, or cache
- Tests verify database-specific features (JSON, arrays, transactions)
- Mocking infrastructure is insufficient for test confidence
- Tests are flaky due to shared test database state
- Repository uses or should use Testcontainers

## Core Workflow

1. **Identify infrastructure dependencies** (database type, version, queue, cache)
2. **Select Testcontainers library** for your language (Java, .NET, Python, Node)
3. **Configure container** with production-matching version
4. **Define lifecycle strategy** (per-class or shared fixture)
5. **Implement test isolation** (transactions, cleanup, or fresh schema)
6. **Set up database schema** (migrations or scripts)
7. **Write tests against real infrastructure**
8. **Optimize for CI** (container reuse, parallel execution, image pre-pull)

See `references/language-setup.md` for language-specific configuration.
See `references/performance-optimization.md` for container reuse strategies.
See `references/ci-cd-integration.md` for CI/CD patterns.

## Quick Reference

| Container | Use Case | Image |
|-----------|----------|-------|
| PostgreSQL | Relational DB | postgres:15 |
| MySQL | Relational DB | mysql:8 |
| MongoDB | Document DB | mongo:6 |
| Redis | Cache | redis:7-alpine |
| RabbitMQ | Message Queue | rabbitmq:3.12-management |
| Kafka | Event Streaming | confluentinc/cp-kafka:7.4 |

## Red Flags - STOP

- "Mocks are faster" / "H2 is close enough"
- "Shared test database is fine" / "CI doesn't support Docker"
- "Testcontainers is too slow" / "Just add better cleanup"

**All mean: Apply testcontainers-integration-tests with optimizations.**

See `references/performance-optimization.md` for rationalizations table.
```

### Step 2: Verify file is under 300 words

Run: Word count check on SKILL.md content (excluding code blocks)
Expected: Under 300 words in prose content

### Step 3: Commit SKILL.md

```bash
git add skills/testcontainers-integration-tests/SKILL.md
git commit -m "feat(testcontainers): add core skill specification"
```

---

## Task 3: Create Language Setup Reference

### Files

- Create: `skills/testcontainers-integration-tests/references/language-setup.md`

### Step 1: Write language-specific setup guide

```markdown
# Language-Specific Testcontainers Setup

## .NET (Testcontainers for .NET)

### Installation

```bash
dotnet add package Testcontainers.PostgreSql
dotnet add package Testcontainers.RabbitMq
# Additional modules as needed
```

### Basic Setup

```csharp
using Testcontainers.PostgreSql;
using Xunit;

public class OrderRepositoryTests : IAsyncLifetime
{
    private PostgreSqlContainer _postgres = null!;

    public async Task InitializeAsync()
    {
        _postgres = new PostgreSqlBuilder()
            .WithImage("postgres:15")
            .Build();
        await _postgres.StartAsync();
    }

    public async Task DisposeAsync()
    {
        await _postgres.DisposeAsync();
    }

    [Fact]
    public async Task CanSaveAndRetrieveOrder()
    {
        var connectionString = _postgres.GetConnectionString();
        // Use connectionString with your repository
    }
}
```

### Shared Fixture (Container Reuse)

```csharp
public class PostgresFixture : IAsyncLifetime
{
    public PostgreSqlContainer Container { get; private set; } = null!;

    public async Task InitializeAsync()
    {
        Container = new PostgreSqlBuilder()
            .WithImage("postgres:15")
            .Build();
        await Container.StartAsync();
    }

    public async Task DisposeAsync()
    {
        await Container.DisposeAsync();
    }
}

[CollectionDefinition("Postgres")]
public class PostgresCollection : ICollectionFixture<PostgresFixture> { }

[Collection("Postgres")]
public class OrderRepositoryTests
{
    private readonly PostgresFixture _fixture;

    public OrderRepositoryTests(PostgresFixture fixture)
    {
        _fixture = fixture;
    }
}
```

## Java (Testcontainers for Java)

### Installation (Maven)

```xml
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>postgresql</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
```

### Basic Setup (JUnit 5)

```java
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.junit.jupiter.api.Test;

@Testcontainers
class OrderRepositoryTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15");

    @Test
    void canSaveAndRetrieveOrder() {
        String jdbcUrl = postgres.getJdbcUrl();
        // Use jdbcUrl with your repository
    }
}
```

### Shared Container (Singleton Pattern)

```java
public abstract class PostgresTestBase {
    static final PostgreSQLContainer<?> POSTGRES;

    static {
        POSTGRES = new PostgreSQLContainer<>("postgres:15");
        POSTGRES.start();
    }
}

class OrderRepositoryTest extends PostgresTestBase {
    @Test
    void canSaveAndRetrieveOrder() {
        String jdbcUrl = POSTGRES.getJdbcUrl();
    }
}
```

## Python (testcontainers-python)

### Installation

```bash
pip install testcontainers[postgres]
pip install testcontainers[rabbitmq]
```

### Basic Setup (pytest)

```python
import pytest
from testcontainers.postgres import PostgresContainer

@pytest.fixture(scope="module")
def postgres():
    with PostgresContainer("postgres:15") as postgres:
        yield postgres

def test_can_save_order(postgres):
    connection_url = postgres.get_connection_url()
    # Use connection_url with your repository
```

### Shared Container (Session Scope)

```python
import pytest
from testcontainers.postgres import PostgresContainer

@pytest.fixture(scope="session")
def postgres():
    container = PostgresContainer("postgres:15")
    container.start()
    yield container
    container.stop()
```

## Node.js (testcontainers)

### Installation

```bash
npm install --save-dev testcontainers
```

### Basic Setup (Jest)

```typescript
import { PostgreSqlContainer, StartedPostgreSqlContainer } from "@testcontainers/postgresql";

describe("OrderRepository", () => {
    let container: StartedPostgreSqlContainer;

    beforeAll(async () => {
        container = await new PostgreSqlContainer("postgres:15").start();
    }, 60000);

    afterAll(async () => {
        await container.stop();
    });

    it("can save and retrieve order", async () => {
        const connectionUri = container.getConnectionUri();
        // Use connectionUri with your repository
    });
});
```

### Shared Container (Global Setup)

```typescript
// globalSetup.ts
import { PostgreSqlContainer } from "@testcontainers/postgresql";

export default async function globalSetup() {
    const container = await new PostgreSqlContainer("postgres:15").start();
    process.env.DATABASE_URL = container.getConnectionUri();
    (global as any).__POSTGRES_CONTAINER__ = container;
}

// globalTeardown.ts
export default async function globalTeardown() {
    await (global as any).__POSTGRES_CONTAINER__?.stop();
}
```

## Common Patterns Across Languages

### Container Selection by Infrastructure

| Infrastructure | .NET Package              | Java Module | Python Module            | Node Package               |
| -------------- | ------------------------- | ----------- | ------------------------ | -------------------------- |
| PostgreSQL     | Testcontainers.PostgreSql | postgresql  | testcontainers[postgres] | @testcontainers/postgresql |
| MySQL          | Testcontainers.MySql      | mysql       | testcontainers[mysql]    | @testcontainers/mysql      |
| MongoDB        | Testcontainers.MongoDb    | mongodb     | testcontainers[mongodb]  | @testcontainers/mongodb    |
| Redis          | Testcontainers.Redis      | -           | testcontainers[redis]    | @testcontainers/redis      |
| RabbitMQ       | Testcontainers.RabbitMq   | rabbitmq    | testcontainers[rabbitmq] | @testcontainers/rabbitmq   |
| Kafka          | Testcontainers.Kafka      | kafka       | testcontainers[kafka]    | @testcontainers/kafka      |

### Migration Execution

Run migrations before tests to set up schema:

```csharp
// .NET: Use FluentMigrator or EF Core
await using var connection = new NpgsqlConnection(connectionString);
await connection.OpenAsync();
await new Migrator(connection).MigrateAsync();
```

```java
// Java: Use Flyway
Flyway.configure()
    .dataSource(postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword())
    .load()
    .migrate();
```

```python
# Python: Use Alembic
from alembic import command
from alembic.config import Config
config = Config("alembic.ini")
config.set_main_option("sqlalchemy.url", connection_url)
command.upgrade(config, "head")
```

### Step 2: Commit reference file

```bash
git add skills/testcontainers-integration-tests/references/language-setup.md
git commit -m "docs(testcontainers): add language-specific setup reference"
```

---

## Task 4: Create Performance Optimization Reference

### Files

- Create: `skills/testcontainers-integration-tests/references/performance-optimization.md`

### Step 1: Write performance optimization guide

````markdown
# Performance Optimization for Testcontainers

## Container Lifecycle Strategies

### Strategy 1: Per-Test-Class (Default)

Container starts before test class, stops after test class.

- **Pros:** Simple, isolated per test class
- **Cons:** Slower (container start per class)
- **Use when:** Few test classes, need isolation between classes

### Strategy 2: Shared Fixture (Recommended for CI)

Container starts once, shared across all test classes.

- **Pros:** Fast (single container start), still isolated with proper cleanup
- **Cons:** Requires careful state cleanup between tests
- **Use when:** Many test classes, CI optimization needed

### Strategy 3: Testcontainers Reusable Containers

Containers persist between test runs (development optimization).

- **Pros:** Fastest for development iteration
- **Cons:** Requires explicit container management, not for CI
- **Use when:** Local development with frequent test runs

## Container Reuse Implementation

### .NET Shared Fixture

```csharp
public class DatabaseFixture : IAsyncLifetime
{
    public PostgreSqlContainer Container { get; private set; } = null!;
    public string ConnectionString => Container.GetConnectionString();

    public async Task InitializeAsync()
    {
        Container = new PostgreSqlBuilder()
            .WithImage("postgres:15")
            .Build();
        await Container.StartAsync();
        await RunMigrations();
    }

    public async Task DisposeAsync() => await Container.DisposeAsync();

    private async Task RunMigrations()
    {
        // Run migrations once when fixture initializes
    }
}

// xUnit collection for shared fixture
[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture> { }

// All tests in this collection share the container
[Collection("Database")]
public class OrderTests { }

[Collection("Database")]
public class CustomerTests { }
```

### Java Singleton Pattern

```java
public abstract class AbstractIntegrationTest {
    protected static final PostgreSQLContainer<?> POSTGRES;

    static {
        POSTGRES = new PostgreSQLContainer<>("postgres:15")
            .withReuse(true); // Enable container reuse
        POSTGRES.start();

        // Run migrations once
        Flyway.configure()
            .dataSource(POSTGRES.getJdbcUrl(), POSTGRES.getUsername(), POSTGRES.getPassword())
            .load()
            .migrate();
    }

    @BeforeEach
    void cleanDatabase() {
        // Clean data between tests, not restart container
        cleanAllTables();
    }
}
```

## Test Isolation Strategies

### Strategy 1: Transaction Rollback (Fastest)

Each test runs in a transaction that's rolled back after the test.

```csharp
public class OrderTests : IAsyncLifetime
{
    private NpgsqlConnection _connection = null!;
    private NpgsqlTransaction _transaction = null!;

    public async Task InitializeAsync()
    {
        _connection = new NpgsqlConnection(connectionString);
        await _connection.OpenAsync();
        _transaction = await _connection.BeginTransactionAsync();
    }

    public async Task DisposeAsync()
    {
        await _transaction.RollbackAsync();
        await _connection.DisposeAsync();
    }

    [Fact]
    public async Task TestInTransaction()
    {
        // Changes here are rolled back automatically
    }
}
```

### Strategy 2: Database Cleanup (More Realistic)

Clean specific tables between tests.

```csharp
public async Task CleanDatabase()
{
    await using var cmd = new NpgsqlCommand(@"
        TRUNCATE orders, order_items, customers RESTART IDENTITY CASCADE
    ", _connection);
    await cmd.ExecuteNonQueryAsync();
}
```

### Strategy 3: Fresh Schema (Most Isolated)

Create new schema per test class.

```csharp
public async Task CreateFreshSchema(string schemaName)
{
    await using var cmd = new NpgsqlCommand($@"
        CREATE SCHEMA {schemaName};
        SET search_path TO {schemaName};
    ", _connection);
    await cmd.ExecuteNonQueryAsync();
    await RunMigrations(schemaName);
}
```

## Parallel Test Execution

### .NET (xUnit)

```json
// xunit.runner.json
{
    "parallelizeAssembly": true,
    "parallelizeTestCollections": true,
    "maxParallelThreads": 4
}
```

Each collection runs in parallel, but tests within a collection run sequentially.
Use separate collections for tests that can run in parallel:

```csharp
[Collection("Database-1")]
public class OrderTests { }

[Collection("Database-2")]
public class CustomerTests { }
```

### Java (JUnit 5)

```properties
# junit-platform.properties
junit.jupiter.execution.parallel.enabled = true
junit.jupiter.execution.parallel.mode.default = concurrent
junit.jupiter.execution.parallel.mode.classes.default = concurrent
```

### Python (pytest)

```bash
pytest -n auto  # Uses pytest-xdist for parallel execution
```

## CI/CD Optimization

### Image Pre-Pull

Pre-pull images in CI setup step to avoid pull time during tests:

```yaml
# GitHub Actions
- name: Pre-pull Docker images
  run: |
    docker pull postgres:15
    docker pull rabbitmq:3.12-management
    docker pull redis:7-alpine
```

### Specific Image Tags

Always use specific image tags (not `latest`) for caching:

```csharp
// GOOD: Specific tag, cached
.WithImage("postgres:15")

// BAD: Latest tag, may re-pull
.WithImage("postgres:latest")
```

### Container Resource Limits

Set resource limits to prevent CI resource exhaustion:

```csharp
.WithResourceMapping(new ResourceConfiguration
{
    Memory = "512m",
    Cpu = "0.5"
})
```

## Performance Measurement

### Measure Container Startup Time

```csharp
var stopwatch = Stopwatch.StartNew();
await container.StartAsync();
stopwatch.Stop();
Console.WriteLine($"Container started in {stopwatch.ElapsedMilliseconds}ms");
```

### Target Performance

| Metric                 | Target | Optimized         |
| ---------------------- | ------ | ----------------- |
| Container startup      | <30s   | <10s (with reuse) |
| Per-test time          | <10s   | <3s               |
| Full suite (20 tests)  | <3min  | <45s              |

## Rationalizations Table

| Excuse                             | Reality                                                                      |
| ---------------------------------- | ---------------------------------------------------------------------------- |
| "Mocks are faster"                 | Optimized Testcontainers run in seconds. Reuse + parallel achieves speed.   |
| "In-memory is close enough"        | DB features differ. JSON, arrays, window functions vary. Test with prod DB. |
| "Testcontainers is too slow"       | Optimize with reuse and parallel. Pre-pull images. 4x+ improvement.         |
| "Shared test database is standard" | Shared state causes flaky tests. Testcontainers provides isolation.         |
| "Can test manually"                | Manual testing doesn't scale. Automate with Testcontainers for CI.          |
| "CI doesn't support Docker"        | Most CI platforms support Docker. Consider cloud-based CI otherwise.        |
````

### Step 2: Commit reference file

```bash
git add skills/testcontainers-integration-tests/references/performance-optimization.md
git commit -m "docs(testcontainers): add performance optimization reference"
```

---

## Task 5: Create CI/CD Integration Reference

### Files

- Create: `skills/testcontainers-integration-tests/references/ci-cd-integration.md`

### Step 1: Write CI/CD integration guide

````markdown
# CI/CD Integration for Testcontainers

## GitHub Actions

### Basic Setup

```yaml
name: Integration Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Pre-pull Docker images
        run: |
          docker pull postgres:15
          docker pull rabbitmq:3.12-management

      - name: Set up .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'

      - name: Run integration tests
        run: dotnet test --filter "Category=Integration"
```

### Docker-in-Docker (DinD)

GitHub Actions ubuntu-latest has Docker pre-installed. No special configuration
needed.

### Parallel Jobs

```yaml
jobs:
  test-postgres:
    runs-on: ubuntu-latest
    steps:
      - name: Pre-pull Postgres
        run: docker pull postgres:15
      - name: Run Postgres tests
        run: dotnet test --filter "Category=Postgres"

  test-rabbitmq:
    runs-on: ubuntu-latest
    steps:
      - name: Pre-pull RabbitMQ
        run: docker pull rabbitmq:3.12-management
      - name: Run RabbitMQ tests
        run: dotnet test --filter "Category=RabbitMQ"
```

## GitLab CI

### Basic Setup

```yaml
integration-tests:
  image: mcr.microsoft.com/dotnet/sdk:8.0
  services:
    - docker:dind
  variables:
    DOCKER_HOST: tcp://docker:2375
    DOCKER_TLS_CERTDIR: ""
  before_script:
    - docker pull postgres:15
    - docker pull rabbitmq:3.12-management
  script:
    - dotnet test --filter "Category=Integration"
```

### Using Docker Socket

```yaml
integration-tests:
  image: mcr.microsoft.com/dotnet/sdk:8.0
  variables:
    DOCKER_HOST: unix:///var/run/docker.sock
  script:
    - dotnet test --filter "Category=Integration"
  tags:
    - docker-socket  # Runner with Docker socket mounted
```

## Azure DevOps

### Basic Setup

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - task: Docker@2
    displayName: 'Pre-pull Docker images'
    inputs:
      command: 'pull'
      arguments: 'postgres:15'

  - task: DotNetCoreCLI@2
    displayName: 'Run integration tests'
    inputs:
      command: 'test'
      arguments: '--filter "Category=Integration"'
```

### Self-Hosted Agent with Docker

For self-hosted agents, ensure Docker is installed and the agent user has Docker
permissions:

```bash
sudo usermod -aG docker azdevops
```

## Jenkins

### Pipeline with Docker

```groovy
pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/dotnet/sdk:8.0'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Pre-pull Images') {
            steps {
                sh 'docker pull postgres:15'
                sh 'docker pull rabbitmq:3.12-management'
            }
        }

        stage('Integration Tests') {
            steps {
                sh 'dotnet test --filter "Category=Integration"'
            }
        }
    }
}
```

## CircleCI

### Basic Setup

```yaml
version: 2.1

jobs:
  integration-tests:
    machine:
      image: ubuntu-2204:current
    steps:
      - checkout
      - run:
          name: Pre-pull Docker images
          command: |
            docker pull postgres:15
            docker pull rabbitmq:3.12-management
      - run:
          name: Run integration tests
          command: dotnet test --filter "Category=Integration"

workflows:
  test:
    jobs:
      - integration-tests
```

## Testcontainers Cloud

For environments where Docker is restricted or unavailable:

### Configuration

```bash
# Set environment variable
export TC_CLOUD_TOKEN=your-token

# Or use config file
# ~/.testcontainers.properties
tc.cloud.token=your-token
```

### When to Use

- Corporate environments with Docker restrictions
- Environments without Docker socket access
- Consistent performance across different CI environments

## Common CI Issues and Solutions

### Issue: Container Pull Timeout

- **Symptom:** Tests fail with image pull timeout
- **Solution:** Pre-pull images in setup step, use specific tags

```yaml
- name: Pre-pull with timeout
  run: docker pull postgres:15
  timeout-minutes: 5
```

### Issue: Port Conflicts

- **Symptom:** "Address already in use" errors
- **Solution:** Testcontainers uses random ports by default. Ensure you're using `getMappedPort()`
  not hardcoded ports.

```java
// GOOD: Dynamic port
int port = postgres.getMappedPort(5432);

// BAD: Hardcoded port
int port = 5432;  // May conflict
```

### Issue: Resource Exhaustion

- **Symptom:** Tests fail intermittently, Docker daemon unresponsive
- **Solution:** Clean up containers, limit parallel jobs, increase CI resources

```yaml
# Cleanup after tests
- name: Docker cleanup
  if: always()
  run: docker system prune -f
```

### Issue: Slow First Test

- **Symptom:** First test takes 30+ seconds, subsequent tests fast
- **Solution:** Use shared fixture pattern for container reuse

### Issue: Flaky Tests in CI

- **Symptom:** Tests pass locally but fail in CI
- **Solution:** Check for timing issues, increase wait times, use health checks

```csharp
.WithWaitStrategy(
    Wait.ForUnixContainer()
        .UntilPortIsAvailable(5432)
        .UntilMessageIsLogged("database system is ready to accept connections")
)
```

## CI Resource Requirements

| CI Platform    | Minimum Resources            | Recommended           |
|----------------|------------------------------|-----------------------|
| GitHub Actions | ubuntu-latest (2 CPU, 7GB)   | Sufficient            |
| GitLab CI      | Docker-in-Docker             | Medium runner (2+ CPU)|
| Azure DevOps   | ubuntu-latest                | Sufficient            |
| Jenkins        | Docker socket access         | 4GB+ memory           |
| CircleCI       | machine executor             | Large resource class  |

## Performance Optimization Checklist for CI

- [ ] Pre-pull Docker images in setup step
- [ ] Use specific image tags (not `latest`)
- [ ] Implement container reuse (shared fixture)
- [ ] Configure parallel test execution
- [ ] Add Docker cleanup step (always runs)
- [ ] Monitor test execution time
- [ ] Set appropriate timeouts
- [ ] Use health checks for container readiness
````

### Step 2: Commit reference file

```bash
git add skills/testcontainers-integration-tests/references/ci-cd-integration.md
git commit -m "docs(testcontainers): add CI/CD integration reference"
```

---

## Task 6: Update cspell.json

### Files

- Modify: `cspell.json`

### Step 1: Add new words for Testcontainers domain

Add to the words array:

- "testcontainers"
- "Testcontainers"

### Step 2: Verify spelling passes

Run: `npx cspell "skills/testcontainers-integration-tests/**/*.md"` (if cspell available)
Expected: No spelling errors

### Step 3: Commit cspell changes

```bash
git add cspell.json
git commit -m "chore: add testcontainers to spell check dictionary"
```

---

## Task 7: Update README.md

### Files

- Modify: `README.md`

### Step 1: Add skill entry to Skills section

Add to the Skills list:

```markdown
- `testcontainers-integration-tests` - P1 integration testing with real infrastructure via
  Testcontainers
```

### Step 2: Commit README changes

```bash
git add README.md
git commit -m "docs: add testcontainers-integration-tests to skills list"
```

---

## Task 8: Final Verification and Push

### Step 1: Run verification checks

- Check all new files exist
- Verify SKILL.md is under 300 words (prose content)
- Verify BDD test file has RED and GREEN phases
- Verify references folder has all three files

### Step 2: Push to remote

```bash
git push -u origin feat/issue-28-testcontainers-integration-tests
```

### Step 3: Create PR

```bash
gh pr create --title "feat(skill): add testcontainers-integration-tests skill (Issue #28)" --body "$(cat <<'EOF'
## Summary

- Add testcontainers-integration-tests skill for P1 Quality & Correctness priority
- Guides agents to use Testcontainers for real infrastructure testing
- Progressive loading: core SKILL.md (<300 words) + 3 reference documents
- BDD test file with RED/GREEN/REFACTOR phases

## Changes

- `skills/testcontainers-integration-tests/SKILL.md` - Core skill specification
- `skills/testcontainers-integration-tests/testcontainers-integration-tests.test.md` - BDD tests
- `skills/testcontainers-integration-tests/references/language-setup.md` - Java, .NET, Python, Node
- `skills/testcontainers-integration-tests/references/performance-optimization.md` - Container reuse
- `skills/testcontainers-integration-tests/references/ci-cd-integration.md` - CI patterns
- `cspell.json` - Added testcontainers words
- `README.md` - Added skill to list

## Key Features

- Container lifecycle strategies (per-class, shared fixture)
- Test isolation patterns (transactions, cleanup, fresh schema)
- Multi-container setup for complex infrastructure
- CI/CD optimization (container reuse, parallel execution, image pre-pull)
- References superpowers:test-driven-development and superpowers:verification-before-completion

## Evidence

- BDD test file follows RED-GREEN-REFACTOR methodology
- SKILL.md under 300 words (progressive loading)
- References provide on-demand detail

Closes #28

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Completion Checklist

- [ ] Feature branch created: `feat/issue-28-testcontainers-integration-tests`
- [ ] Implementation plan saved to `docs/plans/`
- [ ] BDD test file created with RED/GREEN phases
- [ ] SKILL.md created (<300 words)
- [ ] `references/language-setup.md` created
- [ ] `references/performance-optimization.md` created
- [ ] `references/ci-cd-integration.md` created
- [ ] cspell.json updated
- [ ] README.md updated
- [ ] All files committed with evidence
- [ ] Branch pushed to remote
- [ ] PR created referencing Issue #28
