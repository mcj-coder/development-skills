---
name: dotnet-source-generation-first
description: Prefer compile-time source generation over runtime evaluation for repetitive cross-cutting concerns (mapping, logging, regex, etc.).
metadata:
  type: Implementation
  priority: P2
---

## Overview

Prefer compile-time source generation over runtime reflection for repetitive cross-cutting
concerns like mapping, serialization, regex, and logging. Source generation provides
determinism, compile-time verification, reduced runtime overhead, and better AOT/trimming
compatibility.

## When to Use

- Introducing or reviewing repetitive cross-cutting mechanisms (mappers, serializers, regex, logging templates)
- Building performance-sensitive systems or services with startup-time concerns
- Targeting AOT compilation or assembly trimming scenarios
- Evaluating mapping or serialization libraries for a new project
- Reviewing PRs that propose reflection-based or runtime codegen approaches

## Core Workflow

1. Identify the cross-cutting concern (mapping, serialization, regex, logging)
2. Check if a source-generation library exists for the use case (e.g., Mapperly, System.Text.Json source generators, GeneratedRegex)
3. Evaluate the source-gen library against requirements (API compatibility, feature set, maintainability)
4. Implement using the source-generation approach
5. Verify compile-time generation is working (check generated files, no runtime reflection warnings)
6. Benchmark if performance is critical (use the minimal benchmark template in Load: advanced)

## Core

### When to use

- Introducing or reviewing repetitive cross-cutting mechanisms (mappers, serializers, regex, logging templates).
- Performance-sensitive systems, services with startup-time concerns, or AOT/trimming constraints.

### Defaults (strong preference)

- Prefer **source generation** over:
  - reflection-based scanning,
  - runtime expression compilation,
  - dynamic invocation for repetitive tasks.

### Rationale

- Determinism and compile-time verification.
- Reduced runtime overhead and improved diagnosability.
- Better compatibility with AOT/trimming scenarios.

### Review rules

- If a runtime/reflection-based tool is proposed, require explicit justification:
  - functional necessity,
  - measurable benefits,
  - absence of acceptable OSS source-gen alternatives.

## Load: examples

- Mapping: prefer a source-generated mapper (e.g., Mapperly-style approach).
- Regex: use compile-time generated regex for hot paths.
- Logging: prefer compile-time friendly patterns (e.g., message template generators where appropriate).

## Load: advanced

### AOT/trimming checklist

- Avoid reflection-based discovery for core execution paths.
- Ensure analyzers/source generators are included and pinned.
- Validate publish trimming warnings and address them as part of release readiness.

### Benchmarking guidance

- Benchmark representative payload sizes and typical request flows.
- Focus on startup time, allocations, and throughput for mapping/serialization-heavy systems.

### Minimal benchmark template

When evaluating reflection vs source-generated approaches, use this template:

```csharp
[MemoryDiagnoser]
public class MappingBenchmark
{
    private MySourceEntity _source = default!;
    private Mapper _mapper = default!;

    [GlobalSetup]
    public void Setup() => _mapper = new Mapper();

    [Benchmark]
    public MyTargetDto Reflection_MapViaReflection() => MapViaReflection(_source);

    [Benchmark]
    public MyTargetDto SourceGenerated_MapViaSourceGen() => _mapper.Map(_source);
}
```

**Focus areas:**

- Startup time (cold startup with reflection vs AOT-friendly source gen)
- Allocations per operation
- Throughput (operations/sec) for hot paths
- Comparison baseline: measure reflection first, then source-gen

### Acceptable exceptions to source-generation-first

Reflection/runtime codegen may be used when:

1. **Ad-hoc/one-time operations**: Not part of hot paths; cost is negligible.
   - Example: Loading configuration at startup (once per app lifetime)
   - Justification: Overhead is paid once, not per-request

2. **Highly dynamic scenarios**: Type information unavailable at compile-time.
   - Example: Plugin systems where types loaded at runtime from external assemblies
   - Justification: No source-gen alternative exists; runtime introspection necessary

3. **Backwards compatibility constraints**: Source-gen requires breaking API changes.
   - Example: Maintaining legacy API surface while migrating to source-gen
   - Justification: Breaking change risk outweighs performance benefit; schedule migration

4. **Prototype/experimental phases**: Validation before investing in source-gen.
   - Example: Proof-of-concept that reflection will later be replaced
   - Justification: Speed of iteration > performance; document migration plan

**Required for exceptions:**

- Explicit PR justification
- Clear scope boundary (not used in hot paths)
- Migration path documented (if temporary)

## Load: enforcement

- Any PR adding reflection-based mapping or runtime codegen must include:
  - a justification,
  - a benchmark or measurable rationale,
  - confirmation that no suitable OSS source-gen alternative exists.

## Red Flags - STOP

These statements indicate source generation bypass:

| Thought                            | Reality                                                  |
| ---------------------------------- | -------------------------------------------------------- |
| "Reflection is more flexible"      | Source gen handles most cases; flexibility rarely needed |
| "Startup cost doesn't matter"      | AOT/trimming require source gen; plan for it early       |
| "We'll optimize later"             | Retrofitting source gen is expensive; start with it      |
| "No source-gen library exists"     | Check thoroughly; ecosystem is rapidly growing           |
| "It's just a few operations"       | Hot paths compound; measure before dismissing            |
| "Dynamic types require reflection" | True for plugins; false for most business code           |
