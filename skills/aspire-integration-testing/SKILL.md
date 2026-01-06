---
name: aspire-integration-testing
description: Use when repository includes .NET Aspire usage, distributed application setup, or cross-component behavior validation. Produces BDD-style integration tests with health checks and observability verification.
---

# Aspire Integration Testing

## Overview

Integration tests for .NET Aspire distributed applications. Validates service startup, health endpoints, cross-component communication, and observability.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Repository includes .NET Aspire AppHost
- Distributed application with multiple services
- Cross-component behavior validation needed
- **Opt-out:** User explicitly refuses testing

## Core Workflow

1. **Opt-out check:** User refused testing? Document in `docs/exclusions.md`
2. **Identify components:** APIs, workers, databases, queues, caches
3. **Create test project:** Reference Aspire.Hosting.Testing
4. **Mandatory tests:**
   - Application starts successfully
   - `/health` endpoint for all services (200 OK)
   - `/alive` endpoint for all services (200 OK)
   - Resource connectivity (database, queue connections)
5. **Cross-component flows:** API → queue → worker, API → database
6. **Observability:** Structured logging, correlation IDs
7. **Document:** Test strategy in `tests/README.md`

See [Testing Patterns](references/aspire-testing-patterns.md) and [API Reference](references/aspire-hosting-testing-api.md).

## Rationalizations Table

| Excuse | Reality |
| ------ | ------- |
| "Aspire handles health checks" | Health checks exist but must be validated. Services can fail silently. |
| "Too complex to test" | Aspire.Hosting.Testing makes it straightforward. 20 min setup. |
| "Can test in staging" | Local testing is 10x faster. Staging debugging wastes hours. |
| "Demo doesn't need tests" | Demos become production. Start right or rewrite. |
| "Manual verification is enough" | Manual tests don't catch regression. Automated tests do. |

## Red Flags - STOP

- "Aspire infrastructure just works"
- "Too complex to test distributed systems"
- "Can verify in staging/production"
- "Dashboard shows green"
- "Will add tests later"

**All mean: Apply skill or document explicit opt-out.**
