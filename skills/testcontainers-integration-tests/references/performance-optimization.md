# Performance Optimization for Testcontainers

## Container Lifecycle Strategies

### Strategy 1: Per-Test-Class (Default)

Container starts before test class, stops after test class.

**Pros:** Simple, isolated per test class
**Cons:** Slower (container start per class)
**Use when:** Few test classes, need isolation between classes

### Strategy 2: Shared Fixture (Recommended for CI)

Container starts once, shared across all test classes.

**Pros:** Fast (single container start), still isolated with proper cleanup
**Cons:** Requires careful state cleanup between tests
**Use when:** Many test classes, CI optimization needed

### Strategy 3: Testcontainers Reusable Containers

Containers persist between test runs (development optimization).

**Pros:** Fastest for development iteration
**Cons:** Requires explicit container management, not for CI
**Use when:** Local development with frequent test runs

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

| Metric                  | Target | Optimized           |
| ----------------------- | ------ | ------------------- |
| Container startup       | <30s   | <10s (with reuse)   |
| Per-test time           | <10s   | <3s                 |
| Full suite (20 tests)   | <3min  | <45s                |

## Rationalizations Table

| Excuse | Reality |
| --- | --- |
| "Mocks are faster" | Optimized Testcontainers run in seconds. Container reuse + parallel tests achieve comparable speed. Mocks don't catch SQL bugs |
| "In-memory is close enough" | Database-specific features differ. JSON operators, array types, window functions behave differently. Test with production DB |
| "Testcontainers is too slow" | Optimize with container reuse and parallel execution. Pre-pull images in CI. 4x+ speed improvements possible |
| "Shared test database is standard" | Shared state causes flaky tests. Testcontainers provides isolation without coordination overhead |
| "Can test manually" | Manual testing doesn't scale and isn't repeatable. Automate with Testcontainers for CI |
| "CI doesn't support Docker" | Most CI platforms support Docker. Consider cloud-based CI if truly no Docker support |
