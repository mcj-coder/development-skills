---
name: dotnet-bespoke-code-minimisation
description: Bias against bespoke scripts/frameworks by default; prefer mature open-source tools and composable libraries with clear ownership.
---

## Core

### When to use

- Proposals to write internal mappers, code generators, custom build scripts, custom DI containers,
  or bespoke framework layers.
- Reviews where new internal tooling is introduced.

### Defaults

- Prefer OSS libraries/tools over bespoke implementations for:
  - mapping,
  - validation,
  - retries/circuit breakers,
  - caching,
  - scheduling,
  - logging/metrics,
  - CLI/automation tools,
  - test harnesses.

### Principles

- "Library before framework": small, composable components are preferred.
- "Configuration before code" when it improves transparency and reduces maintenance.
- "Script last": if unavoidable, scripts must be versioned, tested, and documented.

## Load: checklists

### Bespoke justification rubric (required)

A bespoke internal tool/framework must include:

- explicit rationale why OSS alternatives are insufficient,
- ownership (team/person) and support model,
- versioning and deprecation policy,
- tests and documentation,
- security and supply-chain considerations.

## Load: examples

- Prefer an OSS formatter/analyzer/CLI over a custom PowerShell script.
- Prefer an OSS mapping generator over internal reflection-based mapping.

## Load: enforcement

- Reject PRs introducing new internal framework layers without:
  - justification rubric satisfied,
  - a documented maintenance plan,
  - confirmation that OSS options were evaluated and licensing revalidated.
