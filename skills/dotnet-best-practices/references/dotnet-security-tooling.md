# .NET-specific security tooling and enforcement

## Scope

This reference is intentionally limited to tooling that is .NET/NuGet/MSBuild/Roslyn-centric.
For broader security processes and multi-language tooling, use the `security-processes` skill.

## 1) NuGet vulnerability auditing (dotnet CLI)

### CI gate

- Run: `dotnet package list --vulnerable --include-transitive`
- Policy: fail builds above your risk threshold; manage exceptions centrally with an owner and expiry.

## 2) Central Package Management (CPM) as an enforcement foundation

When supported, adopt `Directory.Packages.props` so you can:

- consolidate dependency versions
- review dependency drift centrally
- implement consistent policies across projects

## 3) Minimise public attack surface for published libraries

### Public API governance

- Use Public API analyzers to:
  - explicitly track public APIs
  - fail builds when public surface changes without review artifacts
- Default to `internal`; treat public types/members as security-relevant entry points.

## 4) Validate published library public interfaces (API compatibility)

### CI gate

- Run API compatibility checks against a baseline package (usually the latest released stable version).
- Fail the build on breaking API changes unless explicitly approved as a major-version release.

## 5) SemVer enforcement for packages (API-level)

- Rule: **No breaking API changes without a major version increment.**
- Gate releases by coupling:
  - API compat results
  - package version change rules
- Require migration notes for major releases (breaking-change communication is part of security and reliability).

## 6) Roslyn analyzers for insecure patterns (build-time SAST for .NET)

- Enable security-focused analyzers in CI for .NET projects.
- Treat high-confidence, high-severity diagnostics as build failures.
- Require justified, localized suppressions (never blanket disable).
