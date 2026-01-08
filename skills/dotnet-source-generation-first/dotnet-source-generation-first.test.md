# dotnet-source-generation-first - Test Scenarios

## Overview

This test file validates that the `dotnet-source-generation-first` skill enforces compile-time
source generation over runtime reflection for cross-cutting concerns. Tests cover preference
for source generation, AOT/trimming compatibility, and justification requirements for runtime
approaches.

---

## RED Phase - Baseline Testing (WITHOUT Skill)

### Scenario 1: Mapping Library Selection (Baseline)

**Given:** An agent without the `dotnet-source-generation-first` skill
**When:** Asked to recommend a mapping library for a .NET application
**Then:** The agent:

- [ ] May suggest AutoMapper without highlighting reflection concerns
- [ ] Does not prioritize source-generated alternatives by default
- [ ] Lacks structured preference for compile-time verification
- [ ] Does not consider AOT/trimming implications

### Scenario 2: Regex Implementation (Baseline)

**Given:** An agent without the `dotnet-source-generation-first` skill
**When:** Asked to implement regex validation in a hot path
**Then:** The agent:

- [ ] May use runtime-compiled regex patterns
- [ ] Does not recommend `[GeneratedRegex]` attribute by default
- [ ] Lacks awareness of compile-time regex generation benefits
- [ ] Does not consider startup time or allocation implications

### Scenario 3: Logging Implementation (Baseline)

**Given:** An agent without the `dotnet-source-generation-first` skill
**When:** Asked to implement structured logging
**Then:** The agent:

- [ ] May use string interpolation or runtime message templates
- [ ] Does not recommend source-generated logging methods
- [ ] Lacks awareness of `[LoggerMessage]` attribute benefits
- [ ] Does not consider compile-time validation of log message templates

### Scenario 4: AOT/Trimming Review (Baseline)

**Given:** An agent without the `dotnet-source-generation-first` skill
**When:** Asked to prepare an application for AOT compilation
**Then:** The agent:

- [ ] Provides generic AOT guidance without systematic reflection audit
- [ ] Does not identify reflection-heavy libraries as blockers
- [ ] Lacks structured checklist for AOT readiness
- [ ] Does not recommend source-generated alternatives for common patterns

### Scenario 5: PR Review with Reflection (Baseline)

**Given:** An agent without the `dotnet-source-generation-first` skill
**When:** Reviewing a PR that introduces AutoMapper for DTO mapping
**Then:** The agent:

- [ ] Accepts reflection-based mapping without requiring justification
- [ ] Does not ask for benchmarks or measurable rationale
- [ ] Does not verify absence of source-gen alternatives
- [ ] Lacks enforcement of justification requirements

---

## GREEN Phase - WITH Skill

### Scenario 1: Mapping Library Selection (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Asked to recommend a mapping library for a .NET application
**Then:** The agent:

- [ ] Recommends source-generated mappers (e.g., Mapperly) as the default choice
- [ ] Explains determinism and compile-time verification benefits
- [ ] Highlights reduced runtime overhead compared to reflection-based mappers
- [ ] Notes improved diagnosability with source-generated code
- [ ] Only considers reflection-based alternatives when source-gen is insufficient

### Scenario 2: Regex Implementation (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Asked to implement regex validation in a hot path
**Then:** The agent:

- [ ] Recommends `[GeneratedRegex]` attribute for compile-time generation
- [ ] Explains performance benefits (startup time, allocations)
- [ ] Provides example using source-generated regex pattern
- [ ] Notes AOT/trimming compatibility of generated regex
- [ ] Only suggests runtime regex when dynamic patterns are required

### Scenario 3: Logging Implementation (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Asked to implement structured logging
**Then:** The agent:

- [ ] Recommends `[LoggerMessage]` attribute for source-generated logging
- [ ] Explains compile-time validation of message templates
- [ ] Notes reduced allocations from generated logging methods
- [ ] Provides example using source-generated log method
- [ ] Prefers compile-time friendly patterns over runtime string interpolation

### Scenario 4: AOT/Trimming Readiness Review (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Asked to prepare an application for AOT compilation
**Then:** The agent applies the AOT/trimming checklist:

- [ ] Identifies reflection-based discovery patterns in core execution paths
- [ ] Recommends source-generated alternatives for each reflection usage
- [ ] Verifies analyzers and source generators are included and pinned
- [ ] Reviews publish trimming warnings and provides remediation guidance
- [ ] Validates release readiness with trimming analysis

### Scenario 5: PR Review with Reflection (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Reviewing a PR that introduces AutoMapper for DTO mapping
**Then:** The agent applies review rules:

- [ ] Requires explicit justification for reflection-based approach
- [ ] Asks for functional necessity explanation (why source-gen won't work)
- [ ] Requests benchmark or measurable benefits demonstrating the choice
- [ ] Verifies confirmation that no suitable OSS source-gen alternative exists
- [ ] Blocks PR approval until justification requirements are met

### Scenario 6: Serialization Implementation (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Asked to implement JSON serialization for a performance-critical API
**Then:** The agent:

- [ ] Recommends `System.Text.Json` with source generation (`JsonSerializerContext`)
- [ ] Explains compile-time metadata generation benefits
- [ ] Notes AOT compatibility of source-generated serializers
- [ ] Provides example of `[JsonSerializable]` attribute usage
- [ ] Only considers `Newtonsoft.Json` when specific features require it with justification

### Scenario 7: Benchmarking Guidance (With Skill)

**Given:** An agent with the `dotnet-source-generation-first` skill loaded
**When:** Asked to benchmark source-generated vs reflection-based approaches
**Then:** The agent:

- [ ] Recommends benchmarking representative payload sizes
- [ ] Focuses on startup time measurements
- [ ] Includes allocation tracking in benchmark criteria
- [ ] Measures throughput for mapping/serialization-heavy operations
- [ ] Uses typical request flows as benchmark scenarios

---

## Evidence

**Verification checklist:**

- [ ] SKILL.md contains valid frontmatter with `name` field
- [ ] SKILL.md contains valid frontmatter with `description` field
- [ ] SKILL.md documents when to use the skill
- [ ] SKILL.md defines strong preference defaults (source generation over reflection)
- [ ] SKILL.md explains rationale (determinism, runtime overhead, AOT compatibility)
- [ ] SKILL.md includes review rules for runtime/reflection proposals
- [ ] SKILL.md provides examples (mapping, regex, logging)
- [ ] SKILL.md includes AOT/trimming checklist
- [ ] SKILL.md includes benchmarking guidance
- [ ] SKILL.md defines enforcement requirements for PRs

**Frontmatter validation:**

- [ ] `name: dotnet-source-generation-first` is present
- [ ] `description` field provides clear purpose statement
- [ ] Frontmatter is properly delimited with `---` markers
