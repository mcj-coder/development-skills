# Walking Skeleton Examples by Pattern

## Example 1: New Microservice (Order Processing)

### Skeleton Goal

Prove: HTTP API -> Service layer -> Database roundtrip, deployment pipeline, observability.

### Minimal E2E Flow (BDD)

```gherkin
Feature: Order Creation (Walking Skeleton)

Scenario: Create simple order successfully
  Given the order service is deployed and healthy
  When I POST to /orders with:
    """
    {
      "customerId": 123,
      "items": [{"sku": "ABC", "quantity": 1}]
    }
    """
  Then the response status is 201 Created
  And the response contains an orderId
  And the order is persisted in the database
  And I can GET /orders/{orderId} and retrieve the order
```

### Scope Definition

**IN SCOPE:**

- HTTP API endpoint (POST /orders, GET /orders/{id})
- Basic service layer (no complex business logic)
- Database persistence (single table, basic schema)
- BDD acceptance test validating E2E
- Deployment pipeline (build, test, deploy to staging)
- Health check endpoint (GET /health)
- Basic observability (structured logs, metrics)

**OUT OF SCOPE (defer):**

- Complex business rules (payment validation, inventory check)
- Event publishing
- Authentication/authorization
- Multiple order states
- Comprehensive error handling

### Timeline

2 days

### Completion Evidence

```text
Walking skeleton complete and deployed:

POST /orders creates order (returns 201 with orderId)
GET /orders/{id} retrieves order (returns 200 with order data)
Database persistence verified (table created, data persists)
Acceptance test passes (BDD test validates E2E flow)
Deployed to staging via CI/CD pipeline
Health check responding (GET /health returns 200)
Observability working (structured logs, metrics visible)

Architecture validated. Ready to build features on this foundation.
```

## Example 2: Technology Validation (gRPC + Event Sourcing)

### Skeleton Goal

Prove: gRPC communication works, event sourcing pattern works, technologies integrate.

### Minimal E2E Flow (BDD)

```gherkin
Feature: Account Balance Query (Walking Skeleton)

Scenario: Query account balance via gRPC
  Given account 123 has events:
    | Event Type      | Amount |
    | AccountOpened   | 0      |
    | MoneyDeposited  | 100    |
    | MoneyWithdrawn  | 30     |
  When I call GetBalance gRPC method with accountId=123
  Then the response is 70
  And the balance was computed from event sourcing (not direct DB query)
```

### Scope Definition

**IN SCOPE:**

- gRPC service definition (.proto file)
- gRPC server implementation (basic service)
- gRPC client (test client)
- Event store (EventStoreDB or simple implementation)
- Event sourcing: Write events, replay to compute state
- Projection: Balance computed from events
- Acceptance test validating E2E with gRPC and event sourcing

**OUT OF SCOPE:**

- Complex domain logic
- Multiple projections
- CQRS read models
- Event versioning
- Production-scale event store

### Timeline

3 days (includes learning curve for new technologies)

### Completion Evidence

```text
Technology validation skeleton complete:

gRPC working (service definition, server, client communication)
Event sourcing working (events persisted, replay working, projection accurate)
Technologies integrate successfully
Acceptance test passes (E2E flow with gRPC + event sourcing)

Learnings:
- gRPC: Works well, tooling is good, team can learn this
- Event sourcing: Powerful but complex, consider starting simpler

Recommendation:
- Proceed with gRPC (proven, team comfortable)
- Consider deferring event sourcing (start with CRUD, migrate later if needed)
```

## Example 3: Distributed System (E-commerce)

### Skeleton Goal

Prove: Service-to-service communication, shared infrastructure, independent deployment.

### Minimal E2E Flow (BDD)

```gherkin
Feature: Add Product to Cart (Walking Skeleton)

Scenario: Add product to cart successfully
  Given product "ABC" exists in catalog service
  And user 123 has an empty cart in cart service
  When I POST to /cart/items with:
    """
    {
      "userId": 123,
      "productId": "ABC",
      "quantity": 1
    }
    """
  Then the response status is 200 OK
  And cart service queries catalog service for product details
  And product is added to user's cart
  And I can GET /cart?userId=123 and see the product
```

### Scope Definition

**IN SCOPE:**

- Catalog Service: GET /products/{id} (returns product details)
- Cart Service: POST /cart/items, GET /cart (manages cart, calls catalog)
- Service-to-service: HTTP REST between services
- API Gateway: Routes requests to services
- Databases: Separate DB per service (catalog DB, cart DB)
- Deployment: Both services deploy independently via CI/CD
- Acceptance test: E2E test spanning both services

**OUT OF SCOPE:**

- Checkout service (defer)
- Message bus/events (HTTP for now, add later if needed)
- Service mesh
- Complex catalog features
- Authentication/authorization

### Timeline

4 days

### Completion Evidence

```text
Distributed walking skeleton deployed:

Catalog Service deployed (GET /products/{id} working)
Cart Service deployed (POST /cart/items, GET /cart working)
Service-to-service communication working (cart -> catalog via HTTP)
API Gateway routing requests correctly
Databases: catalog-db and cart-db (separate per service)
Acceptance test passes (E2E across both services)
Independent deployment (each service has its own CI/CD pipeline)

Architecture validated:
- Service boundaries are clear (catalog vs cart)
- Service-to-service communication works (HTTP REST)
- Database per service pattern works
- Independent deployment works

Ready to expand to checkout service and add features.
```

## Pattern Summary

| Pattern            | Focus                       | Key Validation      | Timeline |
| ------------------ | --------------------------- | ------------------- | -------- |
| New Microservice   | Single service E2E          | API + DB + Pipeline | 2 days   |
| Technology Spike   | Unfamiliar tech integration | Tech choices work   | 3 days   |
| Distributed System | Multi-service communication | Services integrate  | 4 days   |
