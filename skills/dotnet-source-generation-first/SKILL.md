---
name: dotnet-source-generation-first
description: Prefer compile-time source generation over runtime evaluation for repetitive cross-cutting concerns (mapping, logging, regex, etc.).
---

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

## Load: enforcement

- Any PR adding reflection-based mapping or runtime codegen must include:
  - a justification,
  - a benchmark or measurable rationale,
  - confirmation that no suitable OSS source-gen alternative exists.
