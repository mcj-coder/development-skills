# csharp-best-practices - Test Scenarios

## Overview

This test file validates that the `csharp-best-practices` skill provides version-aware C#
language guidance, detecting the effective C# version and applying best practices progressively
from C# 10 upward. Tests cover version detection, progressive reference loading, optional
analyzer governance, and execution flow.

---

## RED Phase - Baseline Testing (WITHOUT Skill)

### Scenario 1: C# Version Detection (Baseline)

**Given:** An agent without the `csharp-best-practices` skill
**When:** Asked to apply C# best practices to a .NET 8 project
**Then:** The agent:

- [ ] May not systematically detect the effective C# version
- [ ] Does not check `<LangVersion>` in csproj or Directory.Build.props
- [ ] Lacks precedence rules for version detection (csproj → Directory.Build.props → TFM inference)
- [ ] Does not report how the effective version was determined

### Scenario 2: Progressive Reference Loading (Baseline)

**Given:** An agent without the `csharp-best-practices` skill
**When:** Asked about best practices for a C# 12 project
**Then:** The agent:

- [ ] Provides generic C# advice without version-specific context
- [ ] Does not load references progressively from C# 10 baseline
- [ ] Lacks understanding that later versions have higher priority when guidance conflicts
- [ ] Cannot identify which features are available at each C# version

### Scenario 3: Optional Analyzer Governance (Baseline)

**Given:** An agent without the `csharp-best-practices` skill
**When:** Encountering an optional analyzer rule (e.g., IDE0290 - Use primary constructor)
**Then:** The agent:

- [ ] May enable the rule globally without clarification
- [ ] Does not distinguish optional from mandatory analyzer rules
- [ ] May mass-refactor existing code to satisfy the rule
- [ ] Does not pause to request user clarification on contentious rules

### Scenario 4: Multi-Targeting Support (Baseline)

**Given:** An agent without the `csharp-best-practices` skill
**When:** Working on a project targeting both net6.0 and net8.0
**Then:** The agent:

- [ ] May apply C# 12 features without considering net6.0 compatibility
- [ ] Does not understand minimum version requirement for shared code
- [ ] Lacks guidance on TFM-guarded regions for higher-version features
- [ ] May introduce compile errors in lower TFM builds

---

## GREEN Phase - WITH Skill

### Scenario 1: C# Version Detection (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Asked to apply C# best practices to a .NET 8 project
**Then:** The agent:

- [ ] Checks `<LangVersion>` in the project csproj first
- [ ] Falls back to `Directory.Build.props` if not in csproj
- [ ] Falls back to TFM inference (net8.0 → C# 12) if no explicit LangVersion
- [ ] Records the effective C# version and how it was determined
- [ ] Documents active configuration/platform assumptions used

### Scenario 2: Progressive Reference Loading (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Asked about best practices for a C# 12 project
**Then:** The agent:

- [ ] Always loads baseline `references/csharp-10.md` first
- [ ] Loads `references/csharp-11.md` next (since 12 >= 11)
- [ ] Loads `references/csharp-12.md` last (highest priority)
- [ ] Applies priority rule: highest supported version wins on conflicts
- [ ] Reports ordered list of reference docs consulted (C#10 → C#11 → C#12)
- [ ] Documents highest-version feature(s) applied and where

### Scenario 3: Optional Analyzer Governance (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Encountering an optional analyzer rule (e.g., IDE0290 - Use primary constructor)
**Then:** The agent:

- [ ] Pauses global enforcement (does not enable in .editorconfig globally)
- [ ] Does NOT mass-refactor existing code to satisfy the rule
- [ ] Requests clarification from user with options: Enable globally / Enable for new code / Leave disabled
- [ ] Provides explanation of what the rule enforces and key trade-offs
- [ ] Defaults to leaving rule disabled globally if no response
- [ ] May apply opportunistically only to newly written or directly modified code
- [ ] Records analyzer ID, user decision, and enforcement scope

### Scenario 4: Multi-Targeting Support (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Working on a project targeting both net6.0 and net8.0
**Then:** The agent:

- [ ] Identifies that shared code uses the minimum C# version (C# 10 for net6.0)
- [ ] Loads only `references/csharp-10.md` for shared code
- [ ] Advises using `#if NET8_0_OR_GREATER` for C# 12 features in TFM-guarded regions
- [ ] Loads higher-version references only for TFM-specific source sets

### Scenario 5: Execution Flow (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Tasked with implementing a feature in a C# 13 project
**Then:** The agent:

- [ ] Step 1: Detects and records effective C# version (13)
- [ ] Step 2: Loads references progressively (C#10 → C#11 → C#12 → C#13)
- [ ] Step 3: Applies best practices only to touched code (not broad refactor)
- [ ] Step 4: Validates build and tests after changes
- [ ] Step 5: Emits summary of applied practices and any pending optional analyzer decisions

### Scenario 6: Guardrails Enforcement (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Working on C# code
**Then:** The agent:

- [ ] Does not enable preview features unless explicitly configured
- [ ] Does not upgrade SDK or TFM unless requested
- [ ] Avoids unrelated formatting changes and "style churn"
- [ ] Modernizes only touched code unless broader refactor is requested

### Scenario 7: Baseline Best Practices (C# 10) (With Skill)

**Given:** An agent with the `csharp-best-practices` skill loaded
**When:** Implementing or reviewing C# 10 code
**Then:** The agent applies baseline patterns:

- [ ] Prefers file-scoped namespaces in new and modified files
- [ ] Recommends global usings for ubiquitous namespaces (curated list)
- [ ] Uses records for immutable, value-like DTOs/messages
- [ ] Uses `readonly record struct` for strong IDs and small value objects
- [ ] Enables nullable reference types; treats warnings as actionable
- [ ] Prefers `ArgumentNullException.ThrowIfNull(param)` for guard clauses
- [ ] Returns `IReadOnlyList<T>` from public APIs (not `List<T>`)
- [ ] Propagates cancellation tokens; avoids `.Result`/`.Wait()`

---

## Evidence

**Verification checklist:**

- [ ] SKILL.md contains valid frontmatter with `name` and `description` fields
- [ ] All 5 C# version reference files exist in `references/` directory
- [ ] SKILL.md documents version detection precedence (csproj → Directory.Build.props → TFM)
- [ ] Progressive loading model is documented in SKILL.md
- [ ] Optional analyzer governance section is documented
- [ ] Guardrails section is documented
- [ ] Execution flow is documented with 5 steps

**Reference files verified:**

- [ ] `references/csharp-10.md` (baseline standard)
- [ ] `references/csharp-11.md`
- [ ] `references/csharp-12.md`
- [ ] `references/csharp-13.md`
- [ ] `references/csharp-14.md`

**Example files verified:**

- [ ] `examples/detect-language-version.md`
