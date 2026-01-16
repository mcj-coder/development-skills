---
name: walking-skeleton-delivery
description: Use when starting new system or migration requiring minimal end-to-end slice for architecture validation. Defines simplest E2E flow in BDD format, establishes deployment pipeline, and validates technical decisions before full build-out.
---

# Walking Skeleton Delivery

## Overview

Build the **simplest possible end-to-end slice** first. Prove architecture works before
investing in features. A walking skeleton is production-quality code (not throwaway)
that validates your technical decisions in days, not weeks.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Starting new system or microservice
- Major migration or rewrite
- Validating unfamiliar technology stack
- Building distributed system (multi-service)
- User asks to "prove the architecture" or "validate approach"

## Detection and Deference

Before creating new skeleton structure, check for existing work:

```bash
# Check for existing solution/project structure
ls *.sln src/ 2>/dev/null

# Check for existing deployment pipeline
ls .github/workflows/*.yml azure-pipelines.yml 2>/dev/null

# Check for existing architecture ADRs
ls docs/adr/*skeleton* docs/adr/*architecture* 2>/dev/null
```

**If existing structure found:**

- Build skeleton within existing project layout
- Use existing deployment pipeline patterns
- Reference existing architecture decisions

**If no structure found:**

- Create minimal project structure using templates
- Document decisions in architecture ADR

## Decision Capture

Document skeleton architecture decisions:

```bash
# Create architecture ADR for skeleton
cp templates/skeleton-adr.md.template docs/adr/0001-walking-skeleton-architecture.md
```

Key decisions to capture:

- Technology choices with rationale
- Explicit scope (in/out)
- Validation criteria
- Learnings after validation

## Core Workflow

1. **Define skeleton goal** (what are we proving?)
2. **Define minimal E2E flow in BDD format** (Gherkin scenario)
3. **Define scope explicitly:**
   - IN: Minimal components for E2E (API, persistence, basic observability)
   - OUT: Business logic, auth, error handling (deferred)
4. **Implement simplest possible code** (no premature features)
5. **Create BDD acceptance test**
6. **Establish deployment pipeline**
7. **Deploy and verify E2E works**
8. **Document learnings, define next steps**

See `references/examples-by-pattern.md` for concrete examples.

## Skeleton Scope Template

**IN SCOPE (minimal):** HTTP endpoint, basic persistence, health check, deployment pipeline, BDD test

**OUT OF SCOPE (defer):** Complex business rules, authentication, comprehensive error handling, multiple states

## Red Flags - STOP

- "Need features first" / "Deployment later"
- "Architecture will emerge" / "Too late for skeleton"
- "This delays delivery" / "We'll figure it out"

**All mean: Apply walking skeleton before building features.**

See `references/pitfalls-and-scope-creep.md` for rationalizations table.
See `references/technology-spike-distinction.md` for spike vs skeleton guidance.

## Reference Templates

Templates for skeleton implementation:

| Template                                                                        | Purpose                        |
| ------------------------------------------------------------------------------- | ------------------------------ |
| [skeleton-adr.md](templates/skeleton-adr.md.template)                           | Architecture decision template |
| [aspnet-skeleton-structure.md](templates/aspnet-skeleton-structure.md.template) | ASP.NET project structure      |
| [skeleton-scope-checklist.md](templates/skeleton-scope-checklist.md.template)   | Scope control checklist        |

### Quick Setup

```bash
# Create architecture ADR
mkdir -p docs/adr
cp templates/skeleton-adr.md.template docs/adr/0001-walking-skeleton-architecture.md

# Follow ASP.NET skeleton structure
cat templates/aspnet-skeleton-structure.md.template

# Use scope checklist during implementation
cat templates/skeleton-scope-checklist.md.template
```

### Scaffolding Commands

```bash
# .NET solution
dotnet new sln -n YourApp
dotnet new webapi -n YourApp.Api -o src/YourApp.Api

# Node.js
npm init -y
npm install express

# Python
python -m venv .venv
pip install fastapi uvicorn
```

## Sample Skeleton Acceptance Test

### BDD Scenario (Gherkin)

```gherkin
Feature: Walking Skeleton E2E Validation
  As a developer
  I want to verify the skeleton can process a request end-to-end
  So that I can validate the architecture before building features

  Scenario: Health check returns healthy status
    Given the API is running
    When I request GET /health
    Then the response status should be 200
    And the response body should contain "Healthy"

  Scenario: Create and retrieve item proves persistence works
    Given the API is running
    And the database is empty
    When I POST to /api/items with body '{"name": "test"}'
    Then the response status should be 201
    And the response should contain an "id"
    When I GET /api/items/{id}
    Then the response status should be 200
    And the response body should contain "test"
```

### Test Implementation (.NET Example)

```csharp
public class SkeletonAcceptanceTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public SkeletonAcceptanceTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task HealthCheck_ReturnsHealthy()
    {
        // When
        var response = await _client.GetAsync("/health");

        // Then
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("Healthy");
    }

    [Fact]
    public async Task CreateAndRetrieveItem_ProvesE2EWorks()
    {
        // When - Create
        var createResponse = await _client.PostAsJsonAsync("/api/items",
            new { name = "skeleton-test" });

        // Then - Created
        createResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var created = await createResponse.Content.ReadFromJsonAsync<ItemDto>();
        created!.Id.Should().NotBeEmpty();

        // When - Retrieve
        var getResponse = await _client.GetAsync($"/api/items/{created.Id}");

        // Then - Retrieved
        getResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var retrieved = await getResponse.Content.ReadFromJsonAsync<ItemDto>();
        retrieved!.Name.Should().Be("skeleton-test");
    }
}
```

## Minimal Deployment Pipeline Example

### GitHub Actions (.github/workflows/skeleton-deploy.yml)

```yaml
name: Walking Skeleton Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: "8.0.x"

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore

      - name: Test (includes skeleton acceptance tests)
        run: dotnet test --no-build --verbosity normal

  deploy-skeleton:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: skeleton-validation
    steps:
      - uses: actions/checkout@v4

      - name: Build container
        run: docker build -t skeleton-app:${{ github.sha }} .

      - name: Deploy to validation environment
        run: |
          echo "Deploy skeleton to validation environment"
          # Replace with actual deployment commands
          # docker push, kubectl apply, etc.

      - name: Verify skeleton E2E
        run: |
          # Wait for deployment
          sleep 30
          # Hit health endpoint
          curl -f https://skeleton-validation.example.com/health
          # Run smoke test
          curl -f -X POST https://skeleton-validation.example.com/api/items \
            -H "Content-Type: application/json" \
            -d '{"name":"smoke-test"}'
```

### Pipeline Validation Checklist

- [ ] Pipeline triggers on push to main
- [ ] Build step succeeds
- [ ] Skeleton acceptance tests pass
- [ ] Deployment to validation environment succeeds
- [ ] Health check responds after deployment
- [ ] E2E smoke test passes in deployed environment
