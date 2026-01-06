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
    protected static final PostgreSQLContainer<?> POSTGRES;

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
import {
  PostgreSqlContainer,
  StartedPostgreSqlContainer,
} from "@testcontainers/postgresql";

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
