# testing-strategy-dotnet - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Flat Test Project Structure

**Given** agent WITHOUT testing-strategy-dotnet skill
**And** user has a .NET solution with multiple components
**When** user says: "Add tests to my .NET solution"
**Then** record baseline behaviour:

- Does agent use naming convention `<SolutionName>.<ComponentName>.UnitTest`?
  (expected: NO - uses generic names like `Tests` or `MyApp.Tests`)
- Does agent colocate test projects with components? (expected: NO - puts all tests in single project)
- Does agent distinguish unit from system from E2E tiers? (expected: NO - mixes test types)
- Rationalizations observed: "One test project is simpler", "All tests in Tests folder"

### Test R2: No Architecture Testing

**Given** agent WITHOUT testing-strategy-dotnet skill
**And** user has a Clean Architecture .NET solution
**When** user says: "Ensure domain layer has no infrastructure dependencies"
**Then** record baseline behaviour:

- Does agent create NetArchTest or ArchUnitNET tests? (expected: NO - suggests manual review)
- Does agent enforce layering rules automatically? (expected: NO - relies on discipline)
- Does agent add architecture tests to CI gates? (expected: NO - not considered)
- Rationalizations observed: "Code review catches this", "We can check manually"

### Test R3: No Contract Versioning Controls

**Given** agent WITHOUT testing-strategy-dotnet skill
**And** user has a published NuGet library
**When** user says: "I accidentally broke the public API and users are complaining"
**Then** record baseline behaviour:

- Does agent suggest PublicApiAnalyzers? (expected: NO - not aware of tooling)
- Does agent set up API compatibility checks? (expected: NO - manual process)
- Does agent require explicit versioning decisions? (expected: NO - versions arbitrarily)
- Rationalizations observed: "Just bump major version", "SemVer is enough"

### Test R4: Missing Observability in Tests

**Given** agent WITHOUT testing-strategy-dotnet skill
**And** user has system tests for an API
**When** user says: "Write system tests for the order API"
**Then** record baseline behaviour:

- Does agent include correlation ID assertions? (expected: NO - focuses on functional)
- Does agent verify structured logging? (expected: NO - ignores observability)
- Does agent enforce payload logging constraints? (expected: NO - logs everything at Info)
- Rationalizations observed: "Observability is ops concern", "Tests don't need logging checks"

### Test R5: Incorrect Test Tier Selection

**Given** agent WITHOUT testing-strategy-dotnet skill
**And** user has a repository service with SQL queries
**When** user says: "Write tests for the CustomerRepository"
**Then** record baseline behaviour:

- Does agent use real database with Testcontainers for E2E? (expected: NO - mocks database)
- Does agent use Reqnroll for system/E2E tests? (expected: NO - uses plain xUnit)
- Does agent stub only external dependencies in system tests? (expected: NO - mocks internal collaborators)
- Rationalizations observed: "Mocks are faster", "BDD is overkill"

### Expected Baseline Failures Summary

- [ ] Agent uses generic test project names without tier suffixes
- [ ] Agent does not colocate test projects with components
- [ ] Agent does not create architecture tests for layering enforcement
- [ ] Agent does not set up public API tracking or compatibility checks
- [ ] Agent ignores observability assertions in system/E2E tests
- [ ] Agent mocks internal collaborators in system tests
- [ ] Agent does not use BDD style (Reqnroll) for system/E2E tests
- [ ] Agent does not distinguish read-only smoke from journey E2E tests

## GREEN Phase - WITH Skill

### Test G1: Correct Test Project Naming and Structure

**Given** agent WITH testing-strategy-dotnet skill
**When** user says: "Set up tests for OrderService component in MyApp solution"
**Then** agent responds with tiered test structure including:

- `MyApp.OrderService.UnitTest` for class/method-level tests
- `MyApp.OrderService.SystemTest` for BDD system tests
- `MyApp.OrderService.E2E` for component E2E tests
- Test projects colocated with OrderService in solution

**And** agent implements:

- xUnit + Moq for unit tests
- Reqnroll for system and E2E tests
- Correct project references and dependencies

**Evidence:**

- [ ] Unit test project follows `<SolutionName>.<ComponentName>.UnitTest` pattern
- [ ] System test project follows `<SolutionName>.<ComponentName>.SystemTest` pattern
- [ ] E2E test project follows `<SolutionName>.<ComponentName>.E2E` pattern
- [ ] Test projects colocated with component in solution structure
- [ ] Unit tests use xUnit + Moq
- [ ] System/E2E tests use Reqnroll

### Test G2: Architecture Testing Implementation

**Given** agent WITH testing-strategy-dotnet skill
**And** solution uses Clean Architecture pattern
**When** user says: "Add architecture tests to enforce domain isolation"
**Then** agent responds with architecture testing approach including:

- Dedicated `<SolutionName>.ArchitectureTest` project
- NetArchTest.eNhancedEdition or ArchUnitNET setup
- Layering rules for domain independence
- Forbidden dependency rules (e.g., no EF Core in Domain)
- Cyclic dependency prevention

**And** agent implements:

- Architecture test project with recommended library
- Baseline minimum rule set
- CI gate integration for PR checks

**Evidence:**

- [ ] Architecture test project created with correct naming
- [ ] Layering rules implemented (Domain has no Infrastructure dependency)
- [ ] Forbidden dependencies checked (no EF Core types in Domain)
- [ ] Cyclic dependency rules in place
- [ ] Namespace/folder conventions enforced
- [ ] Tests run in PR gates alongside unit tests

### Test G3: Public API Governance Setup

**Given** agent WITH testing-strategy-dotnet skill
**And** user maintains a published NuGet library
**When** user says: "Set up controls to prevent accidental public API breaks"
**Then** agent responds with API governance approach including:

- PublicApiAnalyzers package installation
- Shipped/Unshipped API tracking files
- ApiCompat tool or MSBuild task configuration
- PR gate integration for compatibility checks

**And** agent implements:

- `Microsoft.CodeAnalysis.PublicApiAnalyzers` setup
- API baseline tracking configuration
- Compatibility check in build/PR process

**Evidence:**

- [ ] PublicApiAnalyzers package added to library project
- [ ] PublicAPI.Shipped.txt and PublicAPI.Unshipped.txt created
- [ ] API compatibility tool configured
- [ ] Breaking changes require explicit versioning decision
- [ ] PR gates include API compatibility check

### Test G4: Observability Assertions in System Tests

**Given** agent WITH testing-strategy-dotnet skill
**And** user has system tests for an API component
**When** user says: "Add system tests for OrderProcessor with proper observability"
**Then** agent responds with observability-aware tests including:

- Correlation ID propagation verification
- Structured log assertions for failures
- No unexpected Error/Critical log verification
- Payload logging constraint validation

**And** agent implements:

- Test assertions for correlation ID in responses
- Log capture and structured log verification
- Payload logging level validation (Debug/Trace only for full payloads)

**Evidence:**

- [ ] Correlation ID propagation tested per scenario
- [ ] Structured logs verified for error classification
- [ ] Successful scenarios checked for absence of Error/Critical logs
- [ ] Full payload logging restricted to Debug/Trace levels
- [ ] No secrets or sensitive data in log assertions

### Test G5: Correct Mocking Boundaries in System Tests

**Given** agent WITH testing-strategy-dotnet skill
**When** user says: "Write system tests for OrderService that calls PaymentGateway"
**Then** agent responds with correct mocking boundaries:

- PaymentGateway (external) is mocked/stubbed
- Internal collaborators (repository, domain services) use real implementations
- DI container wires real internal services
- BDD style using Reqnroll

**And** agent implements:

- External dependency stubs only
- Real internal wiring through DI
- Reqnroll feature files for BDD scenarios

**Evidence:**

- [ ] Only external dependencies mocked (PaymentGateway)
- [ ] Internal collaborators use real implementations
- [ ] DI container configured with real internal services
- [ ] BDD feature files using Reqnroll syntax
- [ ] Scenarios test real domain logic flow

### Test G6: Repo-level E2E Test Classification

**Given** agent WITH testing-strategy-dotnet skill
**And** user needs E2E tests for production deployment
**When** user says: "Create E2E tests that can run against production"
**Then** agent responds with E2E classification approach:

- `@smoke @readonly` tagged tests for production safety
- `@journey` tagged tests for staging/sandbox only
- Black box testing (no internal project references)
- Data isolation requirements

**And** agent implements:

- Read-only smoke tests (no create/update/delete)
- Journey tests with test-owned data only
- Tag-based filtering for environment targeting
- Correlation ID retrieval for operational telemetry

**Evidence:**

- [ ] Smoke tests tagged `@smoke @readonly`
- [ ] Journey tests tagged `@journey`
- [ ] Read-only smoke tests do not mutate data
- [ ] Journey tests only in staging/ephemeral/prod-sandbox
- [ ] Tests never impact data not created by test itself
- [ ] Black box tests do not reference internal projects

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Single Test Project Pressure

**Given** agent WITH testing-strategy-dotnet skill
**And** user says: "Just put all tests in one project, it's simpler"
**When** agent is tempted to use single test project
**Then** agent responds:

- Acknowledges simplicity concern
- Explains tier separation enables different execution strategies (PR vs mainline vs post-deploy)
- Shows naming convention enables CI gate configuration
- Proposes tiered structure with clear benefits

**And** agent does NOT:

- Create single `Tests` or `MyApp.Tests` project
- Mix unit, system, and E2E tests in one project
- Abandon naming conventions for convenience

### Test P2: Resist Skipping Architecture Tests

**Given** agent WITH testing-strategy-dotnet skill
**And** user says: "Architecture tests are overkill, we do code review"
**When** agent is tempted to skip architecture testing
**Then** agent responds:

- Acknowledges code review value
- Explains automated enforcement catches drift before review
- Shows architecture tests run in seconds alongside unit tests
- Proposes minimal baseline rule set (not comprehensive)

**And** agent does NOT:

- Skip architecture test project creation
- Rely solely on manual review for dependency enforcement
- Accept "we'll be careful" rationalization

### Test P3: Resist Logging Everything at Info

**Given** agent WITH testing-strategy-dotnet skill
**And** user says: "Log full request/response at Info for debugging"
**When** agent is tempted to log payloads at Info level
**Then** agent responds:

- Acknowledges debugging need
- Explains Info+ logs go to production monitoring systems
- Shows Debug/Trace levels are appropriate for full payloads
- Proposes summary-only logging at Info with correlation ID

**And** agent does NOT:

- Log full request/response bodies at Info/Warn/Error/Critical
- Accept "we'll filter it later" rationalization
- Skip observability constraint validation in tests

## Integration Scenarios

### Test I1: Integration with testcontainers-integration-tests

**Given** agent WITH testing-strategy-dotnet skill
**And** agent WITH testcontainers-integration-tests skill
**When** user says: "Write E2E tests for OrderService with PostgreSQL"
**Then** agent:

1. Creates `<SolutionName>.<ComponentName>.E2E` project (from testing-strategy-dotnet)
2. Uses Testcontainers for PostgreSQL (from testcontainers-integration-tests)
3. Uses Reqnroll for BDD style (from testing-strategy-dotnet)
4. Applies data isolation principles (both skills)

**Evidence:**

- [ ] E2E project follows naming convention
- [ ] Testcontainers used for database
- [ ] Reqnroll used for BDD scenarios
- [ ] Data isolation implemented
- [ ] Observability assertions included

### Test I2: Integration with architecture-testing skill

**Given** agent WITH testing-strategy-dotnet skill
**And** agent WITH architecture-testing skill
**When** user says: "Set up architecture enforcement for Clean Architecture"
**Then** agent:

1. Creates `<SolutionName>.ArchitectureTest` project (from testing-strategy-dotnet)
2. Applies architecture-testing patterns and rules (from architecture-testing)
3. Follows baseline minimum rule set (from testing-strategy-dotnet)
4. Configures CI gate execution (both skills)

**Evidence:**

- [ ] Architecture test project follows naming convention
- [ ] Architecture patterns from both skills applied
- [ ] Minimum baseline rules implemented
- [ ] CI gates configured for PR checks

### Test I3: Integration with superpowers:test-driven-development

**Given** agent WITH testing-strategy-dotnet skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Add a new OrderProcessor class with tests"
**Then** agent:

1. First writes failing test in correct tier (`<SolutionName>.<ComponentName>.UnitTest`)
2. Implements minimal code to make test pass
3. Refactors with additional tests as needed
4. Follows naming conventions throughout

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] Test project follows naming convention
- [ ] Correct test tier selected (unit for class/method tests)
- [ ] xUnit + Moq used for unit tests

## Rationalizations Closure

### Test RC1: "One test project is simpler"

**Given** agent WITH testing-strategy-dotnet skill
**When** rationalization: "One test project is simpler"
**Then** agent responds:

- "Tiered test projects enable selective CI execution. PR gates run unit tests; mainline adds system/E2E."
- "Naming convention enables filtering: `dotnet test --filter 'Category=UnitTest'` vs `Category=E2E`."
- "Setup cost is minimal; operational benefits are significant."

### Test RC2: "Code review catches architecture violations"

**Given** agent WITH testing-strategy-dotnet skill
**When** rationalization: "Code review catches architecture violations"
**Then** agent responds:

- "Architecture tests catch violations immediately, before code review."
- "Automated enforcement prevents drift accumulating between reviews."
- "Tests run in seconds alongside unit tests in PR gates."

### Test RC3: "BDD is overkill for system tests"

**Given** agent WITH testing-strategy-dotnet skill
**When** rationalization: "BDD is overkill for system tests"
**Then** agent responds:

- "BDD scenarios document expected behaviour as living specifications."
- "Reqnroll enables non-technical stakeholders to understand test coverage."
- "Feature files serve as acceptance criteria documentation."

### Test RC4: "We'll version the API when we need to"

**Given** agent WITH testing-strategy-dotnet skill
**When** rationalization: "We'll version the API when we need to"
**Then** agent responds:

- "PublicApiAnalyzers catches accidental breaks before release."
- "Shipped/Unshipped files make API surface explicit and reviewable."
- "Compatibility checks in PR gates prevent surprise breaking changes."

## Verification Assertions

Each GREEN test should verify:

- [ ] Test project naming follows `<SolutionName>.<ComponentName>.<Tier>` pattern
- [ ] Test projects colocated with components in solution
- [ ] Unit tests use xUnit + Moq
- [ ] System/E2E tests use Reqnroll (BDD style)
- [ ] System tests mock only external dependencies
- [ ] Architecture tests exist with baseline rule set
- [ ] Public API governance controls in place (for libraries)
- [ ] Observability assertions included in system/E2E tests
- [ ] Payload logging constrained to Debug/Trace levels
- [ ] E2E tests classified (smoke vs journey) with appropriate tags
- [ ] CI expectations documented (PR vs mainline vs post-deploy)
- [ ] Data isolation enforced in E2E tests
- [ ] Evidence checklist provided
