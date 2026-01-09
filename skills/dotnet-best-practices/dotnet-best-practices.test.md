# dotnet-best-practices - Test Scenarios

## Overview

This test file validates that the `dotnet-best-practices` skill provides version-aware .NET
platform guidance, upgrade planning, and code review support. Tests cover platform alignment
review, version-specific guidance, upgrade planning, and security posture review.

---

## RED Phase - Baseline Testing (WITHOUT Skill)

### Scenario 1: Platform Alignment Review (Baseline)

**Given:** An agent without the `dotnet-best-practices` skill
**When:** Asked to review a .NET 6 codebase for platform alignment
**Then:** The agent:

- [ ] May provide generic .NET advice without version-specific context
- [ ] Lacks structured "Adopt now / Evaluate / Avoid" categorization
- [ ] Does not reference progressive loading of version-specific documentation
- [ ] May not identify deprecated APIs specific to .NET 6

### Scenario 2: Version-Specific Guidance (Baseline)

**Given:** An agent without the `dotnet-best-practices` skill
**When:** Asked what improvements are available in .NET 10
**Then:** The agent:

- [ ] Provides general knowledge without structured guidance
- [ ] Does not distinguish between LTS and STS release policies
- [ ] Lacks categorized adoption recommendations (Adopt now / Evaluate / Avoid)
- [ ] Cannot progressively load detailed sub-references (runtime, SDK, ASP.NET Core, data)

### Scenario 3: Upgrade Planning (Baseline)

**Given:** An agent without the `dotnet-best-practices` skill
**When:** Asked to create an upgrade plan from .NET 6 to .NET 10
**Then:** The agent:

- [ ] Provides generic upgrade steps without cumulative guidance
- [ ] Lacks structured playbook with inventory, dependency readiness, test gates
- [ ] Does not reference breaking changes across multiple majors
- [ ] Cannot identify superseded guidance that should not be carried forward

### Scenario 4: Security Posture Review (Baseline)

**Given:** An agent without the `dotnet-best-practices` skill
**When:** Asked to review security posture of a .NET application
**Then:** The agent:

- [ ] Provides generic security advice without .NET-specific tooling
- [ ] Does not reference NuGet vulnerability auditing commands
- [ ] Lacks Central Package Management enforcement recommendations
- [ ] Does not mention public API governance or Roslyn security analyzers

---

## GREEN Phase - WITH Skill

### Scenario 1: Platform Alignment Review (With Skill)

**Given:** An agent with the `dotnet-best-practices` skill loaded
**When:** Asked to review a .NET 6 codebase for platform alignment
**Then:** The agent:

- [ ] Loads version-specific reference (`references/dotnet-6.md`)
- [ ] Progressively loads sub-references as needed (runtime, SDK, ASP.NET Core, data)
- [ ] Applies "Adopt now / Evaluate / Avoid" categorization
- [ ] Identifies patterns that should be modernized for future LTS upgrades
- [ ] Applies code review lens criteria (platform alignment, performance, security, maintainability, upgrade readiness)

### Scenario 2: Version-Specific Guidance (With Skill)

**Given:** An agent with the `dotnet-best-practices` skill loaded
**When:** Asked what improvements are available in .NET 10
**Then:** The agent:

- [ ] Identifies .NET 10 as a current LTS release
- [ ] Loads `references/dotnet-10.md` and applicable sub-references
- [ ] Provides structured "Adopt now" items (JIT improvements, GC refinements, identity metrics)
- [ ] Provides "Evaluate" items (Span-based APIs, file-based apps)
- [ ] Provides "Avoid / caution" items (assuming older defaults, toolchain drift)
- [ ] Recommends .NET 10 as the default production landing zone

### Scenario 3: Upgrade Planning (With Skill)

**Given:** An agent with the `dotnet-best-practices` skill loaded
**When:** Asked to create an upgrade plan from .NET 6 to .NET 10
**Then:** The agent:

- [ ] Loads `references/upgrade-cumulative.md` for multi-major upgrade guidance
- [ ] Loads `references/lts-upgrade-playbook.md` for practical steps
- [ ] Provides cumulative checklist covering repository governance, runtime/perf, observability, web hygiene
- [ ] Identifies superseded guidance (prefer latest approach, remove older workarounds)
- [ ] Structures plan with: Inventory, Dependency readiness, Test gates, Execution, Validation, Rollout
- [ ] Specifies expected outputs: Upgrade ADR, backlog, evidence pack

### Scenario 4: Security Posture Review (With Skill)

**Given:** An agent with the `dotnet-best-practices` skill loaded
**When:** Asked to review security posture of a .NET application
**Then:** The agent:

- [ ] Loads `references/dotnet-security-tooling.md` for .NET-specific guidance
- [ ] Recommends NuGet vulnerability auditing (`dotnet package list --vulnerable --include-transitive`)
- [ ] Recommends Central Package Management for dependency governance
- [ ] Advises public API governance with analyzers for published libraries
- [ ] Recommends API compatibility checks and SemVer enforcement
- [ ] Advises enabling Roslyn security analyzers with justified suppressions
- [ ] Refers to `security-processes` skill for cross-language security concerns

### Scenario 5: Code Review Application (With Skill)

**Given:** An agent with the `dotnet-best-practices` skill loaded
**When:** Reviewing a pull request for a .NET 8 application
**Then:** The agent applies the code review lens:

- [ ] **Platform alignment**: Checks if code aligns with .NET 8 recommended patterns
- [ ] **Runtime and performance**: Identifies unnecessary allocations, sync-over-async, blocking I/O
- [ ] **Security posture**: Checks for widened API surface, weakened defaults
- [ ] **Maintainability**: Verifies analyzers are respected, configuration is consistent
- [ ] **Upgrade readiness**: Assesses if changes will complicate future LTS upgrades

### Scenario 6: LTS vs STS Policy Awareness (With Skill)

**Given:** An agent with the `dotnet-best-practices` skill loaded
**When:** Asked about .NET 7 or .NET 9 for production use
**Then:** The agent:

- [ ] Identifies .NET 7 and .NET 9 as STS releases
- [ ] Advises default production landing zone is the latest LTS
- [ ] Recommends STS only when specific platform features are required
- [ ] Requires explicit follow-on plan to land on latest LTS when using STS

---

## Evidence

**Verification checklist:**

- [ ] SKILL.md contains valid frontmatter with `name` and `description` fields
- [ ] All 20 reference files exist in `references/` directory
- [ ] SKILL.md references use `references/` path (not `refs/`)
- [ ] Progressive loading model is documented in SKILL.md
- [ ] Baseline engineering standards are documented (Security, Reliability, Performance, Maintainability)
- [ ] Code review lens criteria are documented
- [ ] Outputs section defines expected deliverables

**Reference files verified (20 total):**

.NET 6 (LTS):

- [ ] `references/dotnet-6.md`
- [ ] `references/dotnet-6-runtime.md`
- [ ] `references/dotnet-6-sdk-tooling.md`
- [ ] `references/dotnet-6-aspnetcore.md`
- [ ] `references/dotnet-6-data.md`

.NET 7 (STS):

- [ ] `references/dotnet-7.md`

.NET 8 (LTS):

- [ ] `references/dotnet-8.md`
- [ ] `references/dotnet-8-runtime.md`
- [ ] `references/dotnet-8-sdk-tooling.md`
- [ ] `references/dotnet-8-aspnetcore.md`
- [ ] `references/dotnet-8-data.md`

.NET 9 (STS):

- [ ] `references/dotnet-9.md`

.NET 10 (LTS):

- [ ] `references/dotnet-10.md`
- [ ] `references/dotnet-10-runtime.md`
- [ ] `references/dotnet-10-sdk-tooling.md`
- [ ] `references/dotnet-10-aspnetcore.md`
- [ ] `references/dotnet-10-data-desktop.md`

Cross-Version:

- [ ] `references/dotnet-security-tooling.md`
- [ ] `references/upgrade-cumulative.md`
- [ ] `references/lts-upgrade-playbook.md`
