---
name: dotnet-testing-assertions
description: Standardise unit/integration test assertions on open-source libraries; prefer AwesomeAssertions over non-open-source alternatives.
---

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
