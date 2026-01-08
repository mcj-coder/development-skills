# Release gates and policy

## Objective

Define enforceable, auditable security gates and a safe exception path.

## Minimum gates

- SCA + SAST pass (or approved exceptions)
- Build + test suite pass
- Artifact/container scan where applicable
- For libraries: API governance and compatibility checks

## Exception handling

- Time-bound, owned, justified, mitigated, auditable.
