---
name: dotnet-bespoke-code-minimisation
description: Bias against bespoke scripts/frameworks by default; prefer mature open-source tools and composable libraries with clear ownership.
---

## Overview

Bias against bespoke internal implementations by preferring mature open-source tools and
composable libraries. When custom code is unavoidable, enforce justification rubrics that
require explicit rationale, ownership, versioning, testing, and security considerations.

## When to Use

- Proposals to write internal mappers, code generators, custom build scripts, or DI containers
- Reviews where new internal tooling or bespoke framework layers are introduced
- Evaluating whether to build vs buy/adopt for any infrastructure component
- Reviewing PRs that add custom implementations for common concerns (validation, retries, caching)
- Architectural decisions involving custom scaffolding or automation scripts

## Core Workflow

1. **Identify the concern**: Determine what functionality is being proposed (mapping, validation, CLI, etc.)
2. **Search for OSS alternatives**: Evaluate mature open-source libraries that solve the same problem
3. **Compare trade-offs**: Assess maintenance burden, test effort, performance, and community support
4. **Apply decision framework**: Choose OSS unless clear justification exists for bespoke code
5. **Require justification rubric**: If bespoke code is proposed, demand explicit rationale,
   ownership, versioning, tests, and security considerations
6. **Document decision**: Record OSS evaluation, selection rationale, and maintenance plan
7. **Verify in PR**: Check that PR includes evidence of OSS evaluation and rubric satisfaction

## Core

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

## Load: PR review checklist

When reviewing PRs proposing new custom code, verify:

- [ ] **OSS Evaluation**: Has the author evaluated mature OSS alternatives?
      (Expect evidence: library list, why each was rejected)
- [ ] **Justification Rubric**: If OSS rejected, is the full rubric satisfied?
  - [ ] Explicit rationale for OSS insufficiency
  - [ ] Named owner (team/person) responsible for maintenance
  - [ ] Versioning and deprecation policy defined
  - [ ] Tests covering critical functionality
  - [ ] Security and supply-chain considerations documented
- [ ] **Library vs Framework**: For applicable cases, has the author chosen
      libraries over frameworks?
- [ ] **Documentation**: Is maintenance burden and support model clearly
      communicated?
- [ ] **Red Flags**: Watch for rationalizations that bypass evaluation (e.g.,
      "we need full control", "OSS is too heavy", "we're special")

**Decision rule**: If OSS evaluation is incomplete or rubric unsatisfied, request
changes before approving.

## Load: worked example

### Scenario: Object Mapping in .NET

**Requirement**: Convert DTOs to domain entities in a health insurance claims
system.

#### Option A: Custom Reflection-Based Mapper (Bespoke)

```csharp
public class ClaimMapper
{
    public DomainClaim MapToClaim(ClaimDto dto)
    {
        var claim = new DomainClaim();
        // Manual property assignment for ~30 properties
        claim.ClaimId = dto.Id;
        claim.MemberId = dto.MemberId;
        // ... 28 more assignments
        return claim;
    }
}
```

**Costs**:

- Maintenance: Manual updates required when entities change (tight coupling)
- Testing: Every mapping path must be tested manually
- Performance: Reflection-based or slow property copying
- Versioning: No clear deprecation path if mapping rules change
- Ownership: Who maintains this when the original author leaves?

**OSS Evaluation**: Rejected without justification.

#### Option B: AutoMapper (OSS Library)

```csharp
services.AddAutoMapper(cfg =>
{
    cfg.CreateMap<ClaimDto, DomainClaim>();
});
```

**Strengths**:

- Maintenance: Configuration-driven, auto-discovers properties by name/convention
- Testing: Industry-standard test patterns, extensive test suite in OSS
- Performance: Mature optimization, benchmarked at scale
- Versioning: Library follows SemVer; breaking changes documented
- Ownership: Active maintainers, funding model established
- Documentation: Comprehensive guides for complex mappings

**Risks**: Dependency on external library (mitigated by extensive industry
adoption and source availability).

#### Option C: Mapperly (Modern OSS Library)

```csharp
[Mapper]
public partial class ClaimMapper
{
    public partial DomainClaim MapToClaim(ClaimDto dto);
}
```

**Strengths**:

- Zero runtime overhead via source generation (better than AutoMapper for
  performance-critical paths)
- Explicit, generated code is auditable
- Compile-time safety
- Minimal dependencies
- Fastest execution path

**Trade-off**: Newer library (active development but smaller ecosystem than
AutoMapper).

#### Decision Framework

| Criterion          | Bespoke          | AutoMapper         | Mapperly         |
| ------------------ | ---------------- | ------------------ | ---------------- |
| Maintenance burden | High (manual)    | Low (config)       | Low (generated)  |
| Test effort        | High             | Medium             | Low              |
| Performance        | Unknown          | Good               | Excellent        |
| Versioning clarity | None             | Documented         | Documented       |
| Ownership model    | Implicit         | Explicit           | Explicit         |
| Industry adoption  | N/A              | Mature (15+ years) | Growing (active) |
| Time to value      | Slow (30+ lines) | Fast (2 lines)     | Fast (1 line)    |

#### Recommendation

**Use Mapperly** for new systems (source generation, zero deps, best
performance) or **AutoMapper** for teams with existing expertise.

**Reject bespoke mapper** unless:

- Performance benchmarks prove custom code materially faster (at scale)
- Mapping logic is genuinely bespoke (not property-to-property)
- Ownership, versioning, and testing documented per rubric

#### Verification

Evidence required in PR:

- [ ] OSS libraries evaluated: AutoMapper, Mapperly, TinyMapper considered
- [ ] Selection rationale: "Mapperly chosen for source-gen performance and
      zero-dependency model"
- [ ] Tests: Core mappings covered
- [ ] Documentation: Mapping conventions explained (if non-obvious)

## Red Flags - STOP

These statements indicate bypass of bespoke minimisation principles:

| Thought                             | Reality                                                         |
| ----------------------------------- | --------------------------------------------------------------- |
| "We need full control over this"    | OSS libraries offer customisation; evaluate before rejecting    |
| "OSS is too heavy for our needs"    | Measure actual overhead; most libraries are well-optimised      |
| "We're special, our case is unique" | Most "unique" cases have OSS solutions; search thoroughly       |
| "I can write this in a day"         | Maintenance cost exceeds initial development; OSS shifts burden |
| "External dependencies are risky"   | Well-maintained OSS with active communities reduces risk        |
| "We'll document it later"           | Undocumented internal code becomes unmaintainable quickly       |
