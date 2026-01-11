---
name: aspire-integration-testing
description: >-
  Use when repository includes .NET Aspire usage, distributed application setup, or
  cross-component behavior validation. Produces BDD-style integration tests with health
  checks and observability verification.
---

# Aspire Integration Testing

## Overview

Integration tests for .NET Aspire distributed applications. Validates service startup,
health endpoints, cross-component communication, and observability.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Repository includes .NET Aspire AppHost
- Distributed application with multiple services
- Cross-component behavior validation needed
- **Opt-out:** User explicitly refuses testing

## Detection and Deference

Before creating Aspire integration tests, check for existing patterns:

### Existing Tests Detection

| Pattern                | Detection Command                           | If Found             |
| ---------------------- | ------------------------------------------- | -------------------- |
| AppHost Tests          | `find . -name "*.AppHost.Tests.csproj"`     | Enhance existing     |
| Aspire.Hosting.Testing | `grep -r "Aspire.Hosting.Testing" *.csproj` | Use existing project |
| Test strategy doc      | `test -f docs/testing-strategy.md`          | Reference existing   |

### Deference Rules

When existing Aspire tests are detected:

1. **Existing test project:** Add new tests to existing project.
2. **Existing strategy doc:** Update rather than duplicate.
3. **Partial coverage:** Add tests for uncovered components only.

Only create new test project when detection finds nothing.

## Decision Capture

Testing decisions must be captured:

1. **Testing Strategy:** Update `docs/testing-strategy.md` with Aspire testing approach
2. **Test Project README:** Document what each test validates
3. **ADR (optional):** For complex multi-component testing decisions

### Testing Strategy Template

Add to `docs/testing-strategy.md`:

```markdown
## Aspire Integration Testing

### Scope

- All AppHost-managed services tested
- Health and alive endpoints validated
- Cross-component flows verified

### Test Categories

1. **Startup Tests:** Application starts, all services healthy
2. **Health Tests:** /health and /alive endpoints
3. **Integration Tests:** Cross-component communication
4. **Observability Tests:** Logging, tracing correlation
```

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

## Reference Templates

Use pre-built templates to accelerate Aspire test setup:

| Template                                                                                         | Use Case                   |
| ------------------------------------------------------------------------------------------------ | -------------------------- |
| [templates/aspire-integration-tests.cs.template](templates/aspire-integration-tests.cs.template) | Basic Aspire test class    |
| [templates/aspire-test-project.csproj.template](templates/aspire-test-project.csproj.template)   | Test project configuration |

### Using Templates

1. Copy templates to `tests/{Project}.AppHost.Tests/`
2. Replace `{NAMESPACE}` with your root namespace
3. Replace `{AppHostProject}` with your AppHost project name
4. Add reference to your AppHost project
5. Run `dotnet test` to verify setup

## Rationalizations Table

| Excuse                          | Reality                                                                |
| ------------------------------- | ---------------------------------------------------------------------- |
| "Aspire handles health checks"  | Health checks exist but must be validated. Services can fail silently. |
| "Too complex to test"           | Aspire.Hosting.Testing makes it straightforward. 20 min setup.         |
| "Can test in staging"           | Local testing is 10x faster. Staging debugging wastes hours.           |
| "Demo doesn't need tests"       | Demos become production. Start right or rewrite.                       |
| "Manual verification is enough" | Manual tests don't catch regression. Automated tests do.               |

## Red Flags - STOP

- "Aspire infrastructure just works"
- "Too complex to test distributed systems"
- "Can verify in staging/production"
- "Dashboard shows green"
- "Will add tests later"

**All mean: Apply skill or document explicit opt-out.**
