# Contract Testing Strategies

## Overview

Contract testing validates that API changes remain compatible with consumer expectations.

## Testing Approaches

### Consumer-Driven Contracts

Consumers define their expectations; providers validate against them.

**Tools:** Pact, Spring Cloud Contract

**When to Use:**

- Multiple consumers with different needs
- Need to catch breaking changes before deployment
- Want consumers to drive API design

**Example (Pact):**

```javascript
// Consumer defines expectation
const interaction = {
  state: "user exists",
  uponReceiving: "a request for user by id",
  withRequest: {
    method: "GET",
    path: "/users/123",
  },
  willRespondWith: {
    status: 200,
    body: {
      id: "123",
      name: like("John"),
      email: like("john@example.com"),
    },
  },
};

// Provider verifies against consumer contracts
```

### Provider Contracts

Provider defines the contract; consumers validate against it.

**Tools:** OpenAPI, JSON Schema, Protobuf

**When to Use:**

- Provider-first API design
- Public APIs with unknown consumers
- Need to document contract formally

**Example (OpenAPI):**

```yaml
paths:
  /users/{id}:
    get:
      responses:
        "200":
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "404":
          description: User not found
```

### Schema Validation

Validates structural compatibility of requests/responses.

**Tools:** JSON Schema, Avro, Protobuf

**What It Catches:**

- Field removals
- Type changes
- Required/optional changes
- Format changes

**What It Misses:**

- Behavior changes (null to error)
- Business logic changes
- Side effect changes

### Behavioral Testing

Validates semantic compatibility of API behavior.

**What It Catches:**

- Null handling changes
- Error response changes
- Side effect changes
- Business rule changes

**Example:**

```javascript
describe("getUserById behavior contract", () => {
  it("returns null when user not found (not 404)", async () => {
    const result = await api.getUserById("nonexistent");
    expect(result).toBeNull();
    // If this changes to 404, this test fails
  });
});
```

## CI Integration

### Pre-Merge Validation

```yaml
# .github/workflows/contract-validation.yml
contract-check:
  runs-on: ubuntu-latest
  steps:
    - name: Detect API changes
      run: |
        git diff origin/main -- 'openapi/**' '**/contracts/**'

    - name: Validate backward compatibility
      run: |
        openapi-diff old-spec.yaml new-spec.yaml --fail-on-incompatible

    - name: Run contract tests
      run: npm run test:contracts

    - name: Verify consumer contracts
      run: pact verify --provider-base-url=$API_URL
```

### Breaking Change Detection

```bash
# OpenAPI diff
openapi-diff previous.yaml current.yaml --fail-on-incompatible

# JSON Schema compatibility
json-schema-compatibility check old.json new.json

# Protobuf compatibility
buf breaking --against '.git#branch=main'
```

## Greenfield Setup

For new projects, establish contract validation from the start:

1. **Define contract format:** OpenAPI, JSON Schema, or Protobuf
2. **Add schema validation:** Request/response validation in API
3. **Set up contract tests:** Consumer-driven or provider contracts
4. **Configure CI checks:** Fail build on breaking changes
5. **Document SemVer policy:** In CONTRIBUTING.md
6. **Create pre-1.0 ADR:** If in beta development

## Brownfield Adoption

For existing projects without contract validation:

1. **Baseline current behavior:**
   - Generate OpenAPI from code annotations
   - Create schema from sample responses
   - Write behavioral tests for current behavior

2. **Add validation incrementally:**
   - Start with new endpoints only
   - Add schema validation to responses
   - Configure CI to detect changes (warn, not fail initially)

3. **Tighten over time:**
   - Convert warnings to failures
   - Extend coverage to existing endpoints
   - Add consumer contract testing

## Tool Comparison

| Tool                  | Type            | Language | Best For           |
| --------------------- | --------------- | -------- | ------------------ |
| Pact                  | Consumer-driven | Multi    | Microservices      |
| Spring Cloud Contract | Consumer-driven | Java     | Spring ecosystem   |
| OpenAPI Diff          | Schema          | Any      | REST APIs          |
| Buf                   | Schema          | Any      | Protobuf/gRPC      |
| JSON Schema           | Schema          | Any      | JSON payloads      |
| Dredd                 | Provider        | Any      | OpenAPI validation |
