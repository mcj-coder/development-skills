# Dependency Analysis Techniques

## Direct Dependency Tracing

### Code-Level Dependencies

**Static Analysis:**

- Find all callers of a method/function
- Trace import/using statements
- Identify inheritance hierarchies
- Map interface implementations

**File Path Identification:**

Always provide file paths and line numbers:

```text
Affected callers:
- src/Services/UserService.cs:45 - GetUserById()
- src/Controllers/UserController.cs:23 - GetUser()
- src/Repositories/UserRepository.cs:67 - FindUser()
```

### Configuration Dependencies

Check for references in:

- Application configuration (appsettings.json, .env)
- Environment-specific configs (dev, staging, prod)
- Infrastructure as code (Terraform, ARM templates)
- Docker/container configurations
- CI/CD pipeline definitions

## Indirect Dependency Tracing

### Reflection Usage

Search for patterns:

```csharp
// .NET
typeof(Class).GetMethod("MethodName")
Activator.CreateInstance
MethodInfo.Invoke
```

```javascript
// JavaScript/TypeScript
object["methodName"];
eval("methodName");
window["functionName"];
```

### Serialization

Check for:

- JSON property names matching method/class names
- XML serialization attributes
- Database column mappings
- API contract definitions (OpenAPI, GraphQL schemas)

### Dynamic Loading

- Plugin systems
- Module federation
- Dynamic imports
- Assembly loading

## Cascading Effect Analysis

### Timeout Chains

When changing a timeout, check entire chain:

```text
Client timeout (10s)
  -> API gateway timeout (8s)
    -> Service timeout (5s)
      -> Database timeout (3s)
```

Misalignment causes:

- Premature client failures
- Orphaned server requests
- Resource leaks

### Retry Logic

Changes to timeouts/thresholds affect:

- Retry counts
- Backoff intervals
- Circuit breaker thresholds
- Total operation time

### Error Handling

Changes may affect:

- Error message content
- Exception types
- Fallback behavior
- Logging patterns

## Test Identification

### By Category

**Unit Tests:**

- Direct tests of changed component
- Mock-based tests referencing component

**Integration Tests:**

- Tests using real dependencies
- Database tests
- API tests
- Message queue tests

**End-to-End Tests:**

- Full system tests
- UI automation tests
- Contract tests
- Performance tests

### Coverage Analysis

1. Identify tests directly covering changed code
2. Identify tests covering dependent code
3. Note uncovered paths that may break silently

## Documentation Mapping

Check for references in:

- API documentation (Swagger, README)
- Architecture decision records (ADRs)
- Changelogs
- Developer guides
- External API documentation
- Knowledge base articles
