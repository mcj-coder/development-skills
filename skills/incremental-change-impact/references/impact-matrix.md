# Impact Matrix Templates

## Change Type Impact Matrix

| Change Type      | Code Impact             | Test Impact              | Config Impact      | Doc Impact        | External Impact        |
| ---------------- | ----------------------- | ------------------------ | ------------------ | ----------------- | ---------------------- |
| Method rename    | All callers, reflection | Unit, integration        | Serialization      | API docs, guides  | Breaking if public API |
| Add parameter    | All callers             | All tests calling method | Default values     | API docs          | Breaking if public API |
| Remove parameter | All callers             | All tests calling method | N/A                | API docs          | Breaking if public API |
| Change return    | All consumers of result | Result assertions        | N/A                | API docs          | Breaking if public API |
| Add class/module | None (additive)         | New tests needed         | Possible DI config | Architecture docs | Non-breaking           |
| Delete component | All dependents          | Remove + dependent tests | DI config, routing | All references    | Breaking               |
| Move/relocate    | All imports/references  | Import statements        | Path references    | Path references   | Breaking if external   |
| Config change    | Consumers of config     | Config-dependent tests   | All environments   | Operations docs   | Non-breaking           |
| Schema change    | Data access layer       | Data tests, migrations   | Migration scripts  | Data model docs   | Breaking for consumers |

## Risk Assessment Matrix

| Impact Level | Detection Difficulty | Risk Score | Required Actions                          |
| ------------ | -------------------- | ---------- | ----------------------------------------- |
| HIGH         | HARD                 | CRITICAL   | Full analysis, staged rollout, monitoring |
| HIGH         | EASY                 | HIGH       | Full analysis, quick detection plan       |
| MEDIUM       | HARD                 | HIGH       | Thorough testing, monitoring              |
| MEDIUM       | EASY                 | MEDIUM     | Standard testing, verification            |
| LOW          | HARD                 | MEDIUM     | Extra testing for edge cases              |
| LOW          | EASY                 | LOW        | Standard verification                     |

## Impact Severity Definitions

### HIGH Impact

- Production outage possible
- Data loss or corruption risk
- Security vulnerability
- Multiple dependent systems affected
- External API breaking change

### MEDIUM Impact

- Degraded performance possible
- Partial functionality affected
- Internal API changes
- Single system affected
- Recoverable errors

### LOW Impact

- Cosmetic changes
- Internal refactoring
- Additive changes
- No production risk
- Easily reversible

## Detection Difficulty Definitions

### HARD to Detect

- Reflection/dynamic usage
- Race conditions
- Intermittent failures
- Performance degradation
- Data integrity issues over time

### EASY to Detect

- Compilation errors
- Test failures
- Immediate runtime errors
- Visible UI changes
- Health check failures

## Common Patterns by Domain

### Web API Changes

| Pattern                | Typical Blast Radius                        |
| ---------------------- | ------------------------------------------- |
| Endpoint rename        | Clients, docs, tests, routing config        |
| Request schema change  | Clients, validation, tests, OpenAPI spec    |
| Response schema change | Clients, serialization tests, OpenAPI spec  |
| Authentication change  | All authenticated endpoints, client configs |
| Rate limiting change   | High-volume clients, load tests             |

### Database Changes

| Pattern            | Typical Blast Radius                           |
| ------------------ | ---------------------------------------------- |
| Column rename      | ORM mappings, queries, reports, ETL            |
| Column type change | Data access, validation, migrations, backfills |
| Index change       | Query performance, locking behavior            |
| Constraint change  | Insert/update operations, data validation      |
| Table rename       | All queries, ORM config, foreign keys, reports |

### Infrastructure Changes

| Pattern               | Typical Blast Radius                                |
| --------------------- | --------------------------------------------------- |
| Timeout change        | Retry logic, health checks, cascading timeouts      |
| Memory limit change   | GC behavior, OOM handling, container scheduling     |
| Replica count change  | Load distribution, session affinity, state handling |
| Network policy change | Service communication, security, ingress/egress     |
| Certificate change    | TLS connections, trust chains, client configs       |
