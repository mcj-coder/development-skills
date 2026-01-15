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

## Contract Test Examples

### OpenAPI Contract Test Example

**Complete OpenAPI specification with breaking change validation:**

```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.2.0
paths:
  /users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        "200":
          description: User found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "404":
          description: User not found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Error"
components:
  schemas:
    User:
      type: object
      required:
        - id
        - name
      properties:
        id:
          type: string
        name:
          type: string
        email:
          type: string
          nullable: true
        role:
          type: string
          enum:
            - admin
            - user
          default: user
    Error:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
        message:
          type: string
```

**Breaking change detection:**

```bash
# Detect incompatible changes
openapi-diff old-spec.yaml new-spec.yaml --fail-on-incompatible

# Examples that trigger failures:
# - Removing 'email' field from User schema
# - Changing 'name' from required to optional
# - Adding 'phone' as required (without default)
# - Changing response from 200/404 to 200 only
# - Changing 'role' enum values (removing 'admin')
```

**Test-driven validation:**

```javascript
describe("User API contract", () => {
  it("GET /users/{id} returns User with required fields", async () => {
    const response = await api.get("/users/123");
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("id");
    expect(response.body).toHaveProperty("name");
    if (response.body.email) {
      expect(typeof response.body.email).toBe("string");
    }
    expect(["admin", "user"]).toContain(response.body.role);
  });

  it("returns 404 error with standard Error contract", async () => {
    const response = await api.get("/users/nonexistent");
    expect(response.status).toBe(404);
    expect(response.body).toHaveProperty("code");
    expect(response.body).toHaveProperty("message");
  });

  it("BREAKS if email field is removed", async () => {
    const response = await api.get("/users/123");
    expect(response.body).toHaveProperty("email");
  });
});
```

### JSON Schema Contract Validation Example

**Schema validation at request/response boundary:**

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "User API Contracts",
  "definitions": {
    "UserRequest": {
      "type": "object",
      "required": ["name"],
      "properties": {
        "name": {
          "type": "string",
          "minLength": 1
        },
        "email": {
          "type": "string",
          "format": "email"
        }
      },
      "additionalProperties": false
    },
    "UserResponse": {
      "type": "object",
      "required": ["id", "name", "createdAt"],
      "properties": {
        "id": {
          "type": "string",
          "pattern": "^[0-9a-f]{24}$"
        },
        "name": {
          "type": "string"
        },
        "email": {
          "type": ["string", "null"],
          "format": "email"
        },
        "role": {
          "type": "string",
          "enum": ["admin", "user"],
          "default": "user"
        },
        "createdAt": {
          "type": "string",
          "format": "date-time"
        }
      },
      "additionalProperties": false
    }
  }
}
```

**Validation code:**

```javascript
const Ajv = require("ajv");
const schema = require("./user-contracts.json");

const ajv = new Ajv();
const validateRequest = ajv.compile(schema.definitions.UserRequest);
const validateResponse = ajv.compile(schema.definitions.UserResponse);

// Request validation
function createUser(data) {
  if (!validateRequest(data)) {
    throw new ValidationError(validateRequest.errors);
  }
}

// Response validation
function returnUser(user) {
  if (!validateResponse(user)) {
    throw new ContractViolation(validateResponse.errors);
  }
  return user;
}
```

## Non-HTTP Contract Checklist

For contracts outside HTTP REST (gRPC, message queues, databases), use this minimal checklist:

### gRPC Contract Checklist

- [ ] `.proto` file versioning strategy defined (separate files per version or field numbers)
- [ ] Backward compatibility rules enforced (new fields must be optional, remove not rename)
- [ ] Tool configured to detect incompatible changes: `buf breaking --against '.git#branch=main'`
- [ ] Service interface changes blocked: removed methods, changed signatures
- [ ] Message field removal flagged as breaking (field reuse tracking via field numbers)
- [ ] Consumer verification: test clients against new proto to catch breaking changes

### Message Queue / Event Contract Checklist

- [ ] Event schema stored (JSON Schema, Avro, or Protobuf) with versioning
- [ ] New optional fields allowed; removed/renamed fields flagged as breaking
- [ ] Schema registry or validation library configured (e.g., Confluent Schema Registry, AWS Glue)
- [ ] Consumer verification: consumers process old event versions (validate backward compatibility)
- [ ] Topic versioning strategy: new topic for major changes vs. versioned events within topic
- [ ] Migration path documented: how consumers upgrade to new event schema

### Database / Storage Contract Checklist

- [ ] Migration scripts maintain backward compatibility for 2+ versions
- [ ] Read operations work with old and new schema versions during migration
- [ ] Rollback procedure tested (can schema change be reversed without data loss?)
- [ ] Consumer code updated simultaneously with schema (avoid read/write mismatches)
- [ ] Optional fields added before removing old fields (support both during transition)

### Command-Line Contract Validation Tools

```bash
# gRPC (Protobuf)
buf breaking current.proto --against previous.proto

# Avro (message queues)
java -jar avro-tools.jar ipc compare old.avsc new.avsc

# GraphQL
graphql-inspector compare schema-old.graphql schema-new.graphql

# OpenAPI/JSON Schema
openapi-diff old.yaml new.yaml --fail-on-incompatible
json-schema-diff old.json new.json
```
