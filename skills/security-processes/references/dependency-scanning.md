# Dependency scanning (SCA)

## Objective

Detect vulnerable dependencies early and continuously across ecosystems.

## Controls

- Run SCA scanners in CI on every PR and on a schedule.
- Scan direct and transitive dependencies.
- Fail builds on critical/high vulnerabilities unless exception approved.

## Exception policy (minimum)

- Owner, justification, compensating controls, expiry date, tracking ticket.
- Expired exceptions fail CI.
