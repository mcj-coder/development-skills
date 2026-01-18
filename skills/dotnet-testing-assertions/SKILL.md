---
name: dotnet-testing-assertions
description: Standardise unit/integration test assertions on open-source libraries; prefer AwesomeAssertions over non-open-source alternatives.
metadata:
  type: Implementation
  priority: P1
---

## Overview

Standardise test assertions on open-source libraries, preferring AwesomeAssertions (the
community fork of FluentAssertions) for fluent, readable assertions with better error
messages. Enforce OSS license revalidation for all test dependencies.

## When to Use

- Establishing or reviewing test conventions for a new project
- Introducing or upgrading assertion libraries in existing projects
- Migrating from FluentAssertions to AwesomeAssertions
- Reviewing PRs that add new test dependencies
- Evaluating assertion library license compliance

## Core Workflow

1. Verify the assertion library is open-source (check license)
2. Add AwesomeAssertions package reference to test projects
3. Update using statements to reference AwesomeAssertions namespace
4. Write fluent assertions using Should() extension methods
5. Use BeEquivalentTo for DTOs with exclusions for generated fields
6. Use BeCloseTo for time assertions to avoid brittle exact matches
7. Run tests to verify assertions work correctly

## Core

### When to use

- Establishing or reviewing test conventions.
- Introducing or upgrading assertion libraries.

### Defaults

- Prefer **AwesomeAssertions** (formerly FluentAssertions) for fluent assertions (open source).
- Test framework selection is separate (e.g., xUnit) and may be governed elsewhere.

> **Note:** AwesomeAssertions is the community-maintained fork of FluentAssertions after the
> original project returned to open source governance. The API is largely compatible, making
> migration straightforward for existing FluentAssertions users.

### Review rules

- Do not introduce assertion libraries that are not open source.
- Apply the OSS license revalidation gate (see `dotnet-open-source-first-governance`).

## Load: examples

- Assert equivalence for DTOs and read models.
- Assert exception types and messages where stable.
- Use precise assertions for time, GUIDs, collections, and nullable scenarios.

## Load: advanced

- Avoid brittle assertions that over-specify implementation details.
- Prefer structural assertions for API contract tests.
- For non-deterministic values (timestamps/IDs), assert invariants and ranges.

## Load: enforcement

- Reject PRs that introduce non-open-source assertion libraries.
- Require a documented license verification for new/updated test dependencies.

## Load: migration

### Migration Checklist (FluentAssertions → AwesomeAssertions)

- [ ] **Update NuGet packages**: Replace `FluentAssertions` with `AwesomeAssertions`
- [ ] **Update using statements**: `using FluentAssertions;` → `using AwesomeAssertions;`
- [ ] **Run tests**: Verify all existing tests pass (API is largely compatible)
- [ ] **Check breaking changes**: Review release notes for any API differences
- [ ] **Update CI**: Ensure package restore works in CI pipeline
- [ ] **Document decision**: Add ADR noting the migration and rationale

### Sample Assertion Diff

```diff
// Package reference
- <PackageReference Include="FluentAssertions" Version="6.12.0" />
+ <PackageReference Include="AwesomeAssertions" Version="7.0.0" />

// Using statement
- using FluentAssertions;
+ using AwesomeAssertions;

// Assertions remain the same
result.Should().NotBeNull();
result.Items.Should().HaveCount(3);
result.CreatedAt.Should().BeCloseTo(DateTime.UtcNow, TimeSpan.FromSeconds(1));
```

### Common Assertion Patterns

```csharp
// Object equivalence (ignoring specific properties)
actual.Should().BeEquivalentTo(expected, options => options
    .Excluding(x => x.Id)
    .Excluding(x => x.CreatedAt));

// Collection assertions
items.Should().ContainSingle(x => x.Name == "Test");
items.Should().BeInAscendingOrder(x => x.Priority);
items.Should().AllSatisfy(x => x.IsValid.Should().BeTrue());

// Exception assertions
action.Should().Throw<ValidationException>()
    .WithMessage("*required*");

// Async assertions
await action.Should().ThrowAsync<NotFoundException>();
```

### xUnit vs AwesomeAssertions Comparison

| xUnit Assert                     | AwesomeAssertions              | Benefit               |
| -------------------------------- | ------------------------------ | --------------------- |
| `Assert.Equal(expected, actual)` | `actual.Should().Be(expected)` | Fluent, readable      |
| `Assert.NotNull(obj)`            | `obj.Should().NotBeNull()`     | Chaining support      |
| `Assert.Contains(item, list)`    | `list.Should().Contain(item)`  | Better error messages |
| `Assert.Throws<T>(action)`       | `action.Should().Throw<T>()`   | Message assertions    |

## Red Flags - STOP

These statements indicate assertion anti-patterns:

| Thought                               | Reality                                                      |
| ------------------------------------- | ------------------------------------------------------------ |
| "xUnit Assert is good enough"         | Fluent assertions provide better error messages and chaining |
| "Any assertion library will do"       | Ensure OSS license compliance; verify before adopting        |
| "Assert exact timestamps"             | Use BeCloseTo for time; exact matches are brittle            |
| "Assert full object equality"         | Use BeEquivalentTo with exclusions; ignore generated fields  |
| "Over-specify implementation details" | Assert behaviour and outcomes, not implementation            |
| "Skip license verification"           | All test dependencies need OSS license revalidation          |
