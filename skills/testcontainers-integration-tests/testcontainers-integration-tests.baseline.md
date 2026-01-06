# testcontainers-integration-tests - TDD Baseline Evidence

- **Issue:** #89
- **Date:** 2026-01-06
- **Status:** Verified

## RED Phase (WITHOUT Skill)

### Pressure Scenario

- **Pressure:** Time ("need tests written today")
- **Request:** "Write integration tests for OrderRepository with PostgreSQL,
  complex SQL queries including JSON operators and array types."

### Baseline Behavior Observed

Agent WITHOUT skill defaulted to mocking:

- **Real database:** NO - Mocked IDbConnection
- **Actual SQL tested:** NO - Mocks completely bypass SQL
- **Transactions tested:** NO - Mocked transaction.Verify() not actual behavior
- **PostgreSQL-specific features:** NO - JSON operators, arrays not tested

### Verbatim Rationalizations

1. "Mocks are faster to set up"
2. "We can test the logic without infrastructure"
3. "Real database tests are integration tests, we just need unit tests"
4. "We can add real database tests later"
5. "The ORM handles the SQL translation anyway"

### Mock Anti-Pattern Demonstrated

```csharp
// What agent proposed WITHOUT skill:
Mock<IDbConnection> _mockConnection;
Mock<IDbTransaction> _mockTransaction;
// Tests verify mocks were called, NOT that SQL works
```

## GREEN Phase (WITH Skill)

### Same Pressure Scenario Applied

Agent WITH skill applied Testcontainers approach:

- **Real PostgreSQL:** YES - `PostgreSqlBuilder().WithImage("postgres:15")`
- **JSON operators tested:** YES - `->>`, `->`, `@>`, `?` operators
- **Array types tested:** YES - `ANY()`, `@>` containment, `&&` overlap
- **Transactions tested:** YES - Atomic commits, rollbacks, serializable isolation

### Testcontainers Approach Demonstrated

```csharp
// What agent proposed WITH skill:
PostgreSqlContainer _container = new PostgreSqlBuilder()
    .WithImage("postgres:15")
    .Build();

// Tests run actual SQL against real PostgreSQL
await cmd.ExecuteNonQueryAsync(); // Real execution, not mocks
```

### Skill Compliance

| Requirement           | Compliant | Evidence                                  |
| --------------------- | --------- | ----------------------------------------- |
| Real PostgreSQL       | YES       | Testcontainers with postgres:15           |
| JSON operators tested | YES       | `->>`, `->`, `@>`, `?` in tests           |
| Array types tested    | YES       | `ANY()`, `@>`, `&&` operators             |
| Transactions tested   | YES       | Commit, rollback, serializable isolation  |
| Container lifecycle   | YES       | Shared fixture with IAsyncLifetime        |
| Test isolation        | YES       | Transaction rollback between tests        |

## Verification Result

**PASSED** - Skill successfully changed agent behavior from mock-based to
real-infrastructure testing under time pressure.
