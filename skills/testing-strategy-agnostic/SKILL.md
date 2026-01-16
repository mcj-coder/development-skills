---
name: testing-strategy-agnostic
description: Use when defining, reviewing, or improving a testing strategy in any stack; focuses on layered testing, incremental enforcement, data safety, architecture enforcement, contract versioning, and observability.
metadata:
  type: Quality
  priority: P1
---

# Testing Strategy (Platform & Tooling Agnostic)

## Overview

Establish a pragmatic, layered testing strategy that maximises signal, supports incremental
adoption, and ensures failures are diagnosable with minimal noise. Extend functional testing
with **architecture testing** and **public API/contract governance** so solutions remain
maintainable over time.

## Testing Skills Decision Tree

Use this decision tree to select the appropriate testing skill:

```text
Start Here
    │
    ├── Defining overall testing strategy?
    │   └── YES → testing-strategy-agnostic (this skill)
    │
    ├── Using .NET?
    │   │
    │   ├── YES → testing-strategy-dotnet (for .NET conventions)
    │   │         │
    │   │         ├── Using .NET Aspire distributed apps?
    │   │         │   └── YES → aspire-integration-testing
    │   │         │
    │   │         └── Need real database/queue/cache in tests?
    │   │             └── YES → testcontainers-integration-tests
    │   │
    │   └── NO → Use this skill with language-specific tooling
    │
    └── Need architecture boundary testing?
        └── YES → architecture-testing
```

### Testing Skills Comparison

| Skill                            | Scope                     | When to Use                             |
| -------------------------------- | ------------------------- | --------------------------------------- |
| **testing-strategy-agnostic**    | Any stack                 | Defining overall strategy, principles   |
| testing-strategy-dotnet          | .NET only                 | .NET-specific conventions and tooling   |
| aspire-integration-testing       | .NET Aspire               | Distributed apps with multiple services |
| testcontainers-integration-tests | Any stack with containers | Tests needing real infrastructure       |
| architecture-testing             | Any stack                 | Enforcing architectural boundaries      |

### Invocation Flow

For a complete .NET testing implementation:

1. **testing-strategy-agnostic** - Understand principles (if new to testing strategy)
2. **testing-strategy-dotnet** - Apply .NET-specific conventions
3. **testcontainers-integration-tests** OR **aspire-integration-testing** - For integration tests
4. **architecture-testing** - For boundary enforcement

### Do NOT Use This Skill When

- You need .NET-specific tooling guidance (use testing-strategy-dotnet)
- You're implementing Aspire-specific tests (use aspire-integration-testing)
- You need container-based infrastructure for tests (use testcontainers-integration-tests)

## When to Use

- Defining or modernising a test strategy.
- Designing CI quality gates (tiers, coverage, architecture constraints, compatibility checks).
- Reviewing changes that impact solution structure, public interfaces, or integration contracts.
- Introducing or tightening E2E/system testing and their operational criteria.

## Core Principles

- **Layered test pyramid** (Unit → System → E2E).
- **Incremental enforcement** focused on changed code (and changed contracts/APIs).
- **Repeatability and isolation** (test-owned state only).
- **Strict data safety** (never mutate non-test-owned data).
- **Observability is testable** (diagnosable failures, controlled noise).
- **Architecture is enforceable** (structure and dependency rules are verified continuously).
- **Contracts and public APIs are governed** (versioning discipline and compatibility checks).

---

## Test Tiers

### Unit Tests

- Validate class- and method-level behaviour.
- Fully isolated from external I/O.
- Deterministic and fast.

### System Tests

- Validate component behaviour with real internal wiring.
- Stub/mock **external dependencies only**.
- Validate functional outcomes and **operational diagnosability**.

### E2E Tests

- Validate end-to-end user journeys.
- Minimal, high-value scenarios.
- Strong isolation and cleanup guarantees.

---

## Architecture Testing (Hard Requirements)

Architecture tests enforce solution structure and prevent architectural drift.

### What to enforce

- **Layering rules** (e.g., UI depends on Application; Application depends on Domain; Domain depends on nothing).
- **Allowed dependencies** at package/module boundaries.
- **No cyclic dependencies** between modules.
- **Namespace/folder conventions** (e.g., vertical slices, bounded contexts, feature folders).
- **Forbidden frameworks** in the wrong layer (e.g., no persistence types in Domain).
- **Test project conventions** (naming, colocation, allowed references).

### Where to place architecture tests

- Prefer a dedicated test suite (or a dedicated project) that runs as part of PR gates.
- Keep rules **small, explicit, and business-aligned** (avoid overly abstract purity constraints).

### Incremental enforcement

- Apply strict architecture rules to new modules and modified boundaries first.
- Fail fast on **new violations**, optionally tolerate legacy violations with a tracked baseline until touched.

---

## Contract Versioning & Public Interfaces (Hard Requirements)

### Concepts

- **Integration contracts**: APIs/events/messages shared between components.
- **Published library public surface**: exported types/members that downstream consumers compile against.

### Rules

- Contracts must be **versioned explicitly** and follow a clear compatibility policy.
- Breaking changes require:
  - a new major version (or a new contract version),
  - clear migration guidance,
  - and a compatibility window where applicable.
- PRs must include:
  - contract change notes (what changed, why),
  - and evidence of compatibility checks (automated where feasible).

### Recommended automated checks

- **API compatibility checks** comparing current output to a baseline.
- **Public API surface snapshots** (generated lists) to detect accidental exposure.
- **Consumer-driven contract tests** where multiple consumers exist (especially for events).
- **Schema linting** and backward-compat validation for messages (where applicable).

---

## Observability Requirements (System & E2E)

### Minimum Telemetry Bar ("Just Enough")

- Correlation / trace identifiers
- Structured logs with operation name and error classification
- Dependency visibility (name, outcome, failure classification)
- Actionable diagnostics without payload noise

### Payload Logging Constraints (Hard Rule)

- Full request/response payloads MUST be logged **only** at `Debug` or `Trace` levels.
- `Info`/`Warn`/`Error`/`Critical` logs MUST NOT include full payloads.
- Payload logging must be redacted and gated behind environment-specific log level configuration.

### Noise Controls

- Avoid repeated identical error logs across retries; prefer one summary error with context.
- Successful scenarios should not emit unexpected `Error`/`Critical` logs.

---

## Acceptance Criteria Templates

### System Tests

- Functional behaviour validated.
- Failures produce structured logs with correlation IDs and error classification.
- Successful scenarios emit no unexpected `Error`/`Critical` logs (unless explicitly expected).
- Full payloads are absent from `Info`+ logs; payload detail appears only with `Debug`/`Trace` enabled.
- Where relevant, verifies the component's **contract behaviour** and version handling.

### E2E Tests

- End-to-end traceability (correlation/trace) across the journey.
- Diagnosable failures via logs/traces with controlled noise.
- Never mutates data not created by the test; cleanup is reliable/idempotent.
- Full payloads are absent from `Info`+ logs; payload detail appears only with `Debug`/`Trace` enabled.
- Where relevant, validates cross-component **contract compatibility** and version negotiation/fallback.

---

## Review Heuristics

- Lowest-cost tier used for the behaviour being proven.
- Architecture rules: does the change preserve layering and allowed dependencies?
- Contract discipline: is the contract/public interface change intentional, versioned, and compatible?
- Observability: are failures diagnosable without payload dumps?
- Payload discipline: full payloads restricted to `Debug`/`Trace` only.

---

## Minimal Baseline Strategy Template

For small repositories or MVP projects, use this streamlined testing strategy:

### Small Repo Testing Strategy

````markdown
# Testing Strategy: [Project Name]

## Scope

[1-2 sentence project description]

## Test Tiers

### Unit Tests (Required)

- **Coverage target**: 70% on business logic
- **Focus**: Domain models, validators, pure functions
- **Exclusions**: Controllers, database access, external integrations

### Integration Tests (Required for APIs)

- **Coverage**: All public API endpoints
- **Approach**: In-memory database or TestContainers
- **Focus**: Request/response contracts, error handling

### E2E Tests (Optional for MVP)

- **Scope**: Critical user journey only (e.g., signup → core action)
- **Frequency**: Run on merge to main, not on every PR

## Quality Gates

| Gate                     | Threshold | Enforcement         |
| ------------------------ | --------- | ------------------- |
| Unit test pass           | 100%      | Block merge         |
| Coverage (changed files) | 70%       | Block merge         |
| Integration tests        | 100% pass | Block merge         |
| E2E tests                | 100% pass | Block merge to main |

## Execution

```bash
# Unit tests (fast, run on every commit)
npm test -- --coverage

# Integration tests (run on PR)
npm run test:integration

# E2E tests (run on merge to main)
npm run test:e2e
```
````

## Evidence Template

When documenting test coverage:

```markdown
## Test Evidence

- Unit tests: [X/Y passing] ([coverage report link])
- Integration tests: [X/Y passing]
- Changed files coverage: [X]%
```

### When to Upgrade from Minimal

Upgrade to full strategy when ANY of these occur:

- Team size exceeds 3 developers
- More than 2 integration points (external APIs, databases)
- Production incidents related to untested scenarios
- Code complexity metrics indicate high cyclomatic complexity
- Contract versioning becomes necessary

## Red Flags - STOP

These statements indicate testing strategy anti-patterns:

| Thought                             | Reality                                                                       |
| ----------------------------------- | ----------------------------------------------------------------------------- |
| "We'll add tests later"             | Untested code becomes untestable; test-first is non-negotiable                |
| "E2E tests cover everything"        | E2E tests are slow and brittle; use the test pyramid                          |
| "100% coverage means bug-free"      | Coverage measures execution, not correctness; focus on meaningful assertions  |
| "Mocking everything is fine"        | Over-mocking hides integration failures; stub only external dependencies      |
| "Architecture tests are overkill"   | Architectural drift is expensive to fix; enforce boundaries continuously      |
| "Contract changes don't need tests" | Breaking changes break consumers; version explicitly and verify compatibility |
