# .NET 8 runtime and libraries

## Adopt now

- Re-baseline performance at .NET 8+ (CPU, allocations, GC pauses, startup).
- Simplify stale performance workarounds made unnecessary by newer runtime behavior.

## Evaluate

- AOT/trimming for eligible workloads (CLI, serverless cold-start, edge) after dependency validation.
- Targeted use of newer source generators where they reduce reflection and startup costs.

## Avoid / caution

- Broad refactors for AOT/trimming without first proving feasibility with your dependency graph.
