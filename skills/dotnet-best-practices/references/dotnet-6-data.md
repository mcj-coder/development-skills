# Data and EF/ORM considerations in .NET 6 era

## Adopt now

- Instrument DB access patterns (query timing, error rates).
- Avoid leaking ORM dependencies into domain models and public library surfaces.

## Evaluate

- Codify query expectations in tests to make later upgrades safer.

## Avoid / caution

- Hidden N+1 and unbounded query patterns without telemetry.
