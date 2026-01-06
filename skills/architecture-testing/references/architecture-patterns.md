# Architecture Patterns Reference

## Clean Architecture

**Layers (inside out):**

1. Domain - Entities, value objects, domain services
2. Application - Use cases, DTOs, interfaces
3. Infrastructure - Database, external services, frameworks
4. Presentation - Controllers, views, API endpoints

**Dependency Rule:** All dependencies point inward. Domain has no dependencies.

## Hexagonal Architecture (Ports & Adapters)

**Structure:**

- Core: Domain logic and port interfaces
- Adapters: Implementations (DB, HTTP, messaging)

**Dependency Rule:** Adapters depend on ports, never core on adapters.

## Onion Architecture

**Layers:**

1. Domain Model (center)
2. Domain Services
3. Application Services
4. Infrastructure (outer)

**Dependency Rule:** Each layer can only depend on inner layers.

## Layered Architecture

**Layers:**

1. Presentation
2. Business Logic
3. Data Access

**Dependency Rule:** Each layer depends only on the layer directly below.

## Modular Monolith

**Structure:**

- Independent modules with clear boundaries
- Modules communicate through defined interfaces
- Can be extracted to microservices later

**Dependency Rule:** No circular dependencies between modules.

## Quick Selection Guide

| Pattern | Best For |
| ------- | -------- |
| Clean | Complex domain logic, testability focus |
| Hexagonal | Multiple I/O adapters (APIs, queues, DBs) |
| Onion | Domain-centric applications |
| Layered | Simple CRUD, small teams |
| Modular Monolith | Future microservice extraction |
