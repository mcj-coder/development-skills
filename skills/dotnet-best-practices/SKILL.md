---
name: dotnet-best-practices
description: >
  Use when designing, implementing, maintaining, or reviewing .NET features, projects, and
  codebases. Covers architecture, runtime/framework choices, SDK/tooling, packaging, deployment
  strategy, and version-aware best practices, including code review and ongoing maintenance
  scenarios.
metadata:
  type: Implementation
  priority: P2
---

# .NET best practices (version-aware, progressive-loading)

## Overview

Apply modern .NET platform capabilities and recommended engineering practices across the full
lifecycle of a .NET codebase. This skill covers runtime/framework choices, SDK/tooling,
packaging, deployment strategy, and version-aware best practices for implementation,
maintenance, and code review scenarios.

## Purpose

Apply modern .NET platform capabilities and recommended engineering practices across the
**full lifecycle** of a .NET codebase, including:

- feature implementation and enhancement
- routine maintenance and refactoring
- code review and pull request validation
- runtime/framework upgrades
- production hardening and operational improvements

This skill complements a C# language-focused skill by concentrating on .NET runtime/framework,
hosting, SDK/tooling, packaging, and operational practices.

## Upgrade policy (default)

- Default for production: **upgrade to the latest LTS .NET version**.
- Use STS releases only when a specific platform feature is required and you have an explicit
  follow-on plan to land on the latest LTS.

## When to use

Use this skill when you are:

- Implementing new .NET features or services
- Modifying existing application or library code
- Reviewing pull requests or performing structured code reviews
- Refactoring or modernizing legacy .NET code
- Upgrading target frameworks, SDKs, or runtime versions
- Validating alignment with current .NET platform best practices
- Establishing or enforcing repository standards for .NET projects

For cross-language or organization-wide security processes, use the `security-processes` skill alongside this one.

## Core Workflow

1. Identify target .NET version and load corresponding version reference
2. For upgrades, load upgrade-cumulative.md and lts-upgrade-playbook.md
3. Apply baseline engineering standards (security, reliability, performance, maintainability)
4. Review code against version-specific recommended patterns
5. Validate configuration centralisation and analyzer enforcement
6. Produce target framework recommendation and adoption checklist
7. Document risks, breaking changes, and required test gates

## Progressive loading model

1. Read this file (baseline standards + operating procedure).
2. Load only the references you need:

- Version indexes:
  - `references/dotnet-6.md`, `references/dotnet-7.md`, `references/dotnet-8.md`, `references/dotnet-9.md`, `references/dotnet-10.md`
- If upgrading across majors, also load:
  - `references/upgrade-cumulative.md`
  - `references/lts-upgrade-playbook.md`
- For .NET-specific security enforcement, load:
  - `references/dotnet-security-tooling.md`
- For cross-language security processes (SCA/SBOM/container scanning, policy gates, exception handling), use:
  - `security-processes` skill

## Baseline engineering standards (version-agnostic)

### Security

- Prefer secure defaults; do not weaken them without a threat-model justification.
- Enforce HTTPS and HSTS in production; own reverse-proxy/header configuration explicitly.
- Centralize authN/authZ; validate all inbound data; avoid unsafe dynamic deserialization patterns.
- Patch cadence: treat runtime/framework security updates as routine work with defined SLAs.

### Reliability

- Ensure graceful shutdown and cancellation propagation (`IHostApplicationLifetime`, hosted services).
- Use bounded concurrency, timeouts, and resilience for outbound calls; prevent retry storms.
- Avoid sync-over-async; use async end-to-end for I/O.

### Performance

- Measure first: tracing/metrics, baseline benchmarks.
- Avoid allocations on hot paths; use pooling where it materially helps.
- Use Span/Memory-friendly APIs where appropriate (especially in libraries).
- Consider AOT/trimming selectively (CLI, serverless cold-start, edge) once compatibility is validated.

### Maintainability & governance

- Centralize build configuration in `Directory.Build.props` / `Directory.Build.targets`.
- Enable analyzers; move toward warnings-as-errors for critical projects/new code.
- Keep nullable reference types enabled and clean (avoid blanket suppressions).
- Standardize package versioning strategy.
- Adopt **NuGet Central Package Management** (`Directory.Packages.props`) as soon as supported
  by your toolchain, and enforce "no versions in csproj PackageReference" with documented
  exceptions.

## Code review lens (how to apply this skill in PRs)

When used during code review, apply this skill to evaluate:

- **Platform alignment**
  - Is the code aligned with the target .NET version's recommended patterns?
  - Are deprecated or superseded APIs being introduced?

- **Runtime and performance awareness**
  - Does the change introduce unnecessary allocations, sync-over-async, or blocking I/O?
  - Are newer runtime/library capabilities being ignored where they would simplify or harden the code?

- **Security posture**
  - Does the change unnecessarily widen the public API surface?
  - Are defaults being weakened (auth, HTTPS, serialization, validation)?

- **Maintainability**
  - Are analyzers respected or suppressed without justification?
  - Is configuration, dependency management, and hosting consistent with repo standards?

- **Upgrade readiness**
  - Will this change make future LTS upgrades harder (tight coupling, legacy patterns, hidden assumptions)?

## Outputs (what this skill should produce)

- Target framework recommendation (latest LTS) and upgrade plan/backlog.
- Version-specific adoption checklist (what to adopt now vs later).
- Cumulative upgrade checklist when crossing multiple majors.
- Risks/breaking-change checklist and required test gates (contract/perf/integration).
- Repository standards updates (packaging, analyzers, SDK pinning, CI enforcement).

## Red Flags - STOP

These statements indicate misalignment with .NET best practices:

| Thought                                     | Reality                                                                   |
| ------------------------------------------- | ------------------------------------------------------------------------- |
| "We'll stay on .NET 6 indefinitely"         | LTS versions have end-of-life dates; plan upgrades proactively            |
| "Sync-over-async is fine for this case"     | Async should be end-to-end; sync-over-async causes thread pool starvation |
| "We don't need analyzers"                   | Analyzers catch issues at compile time; enable and address warnings       |
| "NuGet package versions in csproj are fine" | Use Central Package Management for consistency and security               |
| "Security patches can wait"                 | Runtime security updates need defined SLAs; treat as routine work         |
| "AOT/trimming will just work"               | Validate compatibility before enabling; many patterns are incompatible    |
