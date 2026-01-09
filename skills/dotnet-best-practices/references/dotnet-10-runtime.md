# .NET 10 runtime and base libraries

## Adopt now

- **JIT/compiler improvements**
  - Action: re-run latency and throughput benchmarks; reassess previously "hot" paths that required manual tuning.
- **GC/runtime refinements**
  - Action: re-baseline memory profiles and tail-latency metrics; validate pause times under load.

## Evaluate

- **Span-based normalization and allocation-reducing APIs**
  - Adopt selectively in hot paths where you can demonstrate measurable benefit.

## Avoid / caution

- Depending on undocumented JIT/GC behaviors observed in older versions.
