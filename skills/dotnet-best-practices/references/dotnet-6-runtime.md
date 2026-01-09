# .NET 6 runtime and libraries

## Adopt now

- Establish performance baselines (startup, throughput, allocations) to make later upgrades verifiable.
- Prefer modern BCL APIs; remove legacy patterns that complicate future trimming/AOT work.

## Evaluate

- Early trimming/AOT exploration for small utilities to identify dependency blockers.

## Avoid / caution

- Regressing to allocation-heavy patterns in hot paths without measurement.
