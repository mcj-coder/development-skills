# Failure Mode Catalog

Comprehensive failure mode analysis by deployment type. Use as a starting point
for enumerating risks specific to your change.

## Failure Mode Template

For each identified failure mode, document:

| Field       | Description                                  |
| ----------- | -------------------------------------------- |
| Symptom     | How the failure manifests to users/operators |
| Detection   | Metrics, logs, or alerts that identify it    |
| Impact      | Business/user consequence (LOW/MEDIUM/HIGH)  |
| Probability | Likelihood of occurrence (LOW/MEDIUM/HIGH)   |
| Risk Rating | Impact x Probability                         |

## API/Service Deployment

### Common Failure Modes

1. **Authentication/Authorization Failures**
   - Symptom: 401/403 errors, login failures
   - Detection: Error rate >1%, health check failures
   - Impact: HIGH (all users affected)
   - Probability: MEDIUM (common integration point)

2. **Database Connection Failures**
   - Symptom: 500 errors, timeout exceptions
   - Detection: Connection pool exhaustion, query timeouts
   - Impact: HIGH (service unavailable)
   - Probability: LOW (usually well-tested)

3. **External Service Integration Issues**
   - Symptom: Partial functionality, cascade failures
   - Detection: Downstream service errors, circuit breaker trips
   - Impact: MEDIUM-HIGH (depends on service criticality)
   - Probability: MEDIUM (external dependencies less controlled)

4. **Memory/Resource Exhaustion**
   - Symptom: OOM errors, slow responses, crashes
   - Detection: Memory metrics, garbage collection frequency
   - Impact: HIGH (service restarts, data loss)
   - Probability: LOW-MEDIUM (depends on load testing)

5. **Configuration Mismatches**
   - Symptom: Unexpected behavior, feature flags wrong
   - Detection: Config validation, smoke tests
   - Impact: MEDIUM-HIGH (varies by configuration)
   - Probability: MEDIUM (manual configuration prone to error)

## Database Migration

### Common Failure Modes

1. **Migration Script Failure Mid-Execution**
   - Symptom: Partial schema changes, constraint errors
   - Detection: Migration tool error, schema validation
   - Impact: HIGH (database inconsistent state)
   - Probability: LOW (usually tested)

2. **Lock Timeout During Migration**
   - Symptom: Migration hangs, other transactions blocked
   - Detection: Lock wait timeout alerts
   - Impact: MEDIUM (temporary unavailability)
   - Probability: MEDIUM (depends on table size and traffic)

3. **Data Integrity Violations**
   - Symptom: FK constraint errors, null violations
   - Detection: Database errors, data validation failures
   - Impact: HIGH (data corruption risk)
   - Probability: LOW (if properly tested)

4. **Application Incompatibility**
   - Symptom: Application errors after migration
   - Detection: App error logs, increased 500 errors
   - Impact: HIGH (service degraded)
   - Probability: MEDIUM (especially with schema changes)

5. **Backup/Restore Failures**
   - Symptom: Cannot restore if rollback needed
   - Detection: Backup verification tests
   - Impact: CRITICAL (potential data loss)
   - Probability: LOW (if backups verified)

## Infrastructure Changes

### Common Failure Modes

1. **API Version Incompatibility**
   - Symptom: Resource creation failures, API errors
   - Detection: Kubernetes/cloud API errors
   - Impact: HIGH (deployments blocked)
   - Probability: MEDIUM (with major version upgrades)

2. **Network Configuration Issues**
   - Symptom: Service connectivity failures, timeouts
   - Detection: Network health checks, DNS resolution
   - Impact: HIGH (services cannot communicate)
   - Probability: MEDIUM (complex configurations)

3. **Certificate/TLS Failures**
   - Symptom: SSL/TLS errors, connection refused
   - Detection: Certificate expiration alerts, health checks
   - Impact: HIGH (secure traffic blocked)
   - Probability: LOW-MEDIUM (depends on cert management)

4. **Resource Quota Exceeded**
   - Symptom: Pod scheduling failures, resource errors
   - Detection: Resource quota alerts, pending pods
   - Impact: MEDIUM (new deployments blocked)
   - Probability: MEDIUM (with scaling operations)

5. **Storage/Volume Issues**
   - Symptom: Data unavailable, mount failures
   - Detection: Volume health checks, storage alerts
   - Impact: CRITICAL (data unavailable)
   - Probability: LOW (storage usually stable)

## Feature Release

### Common Failure Modes

1. **Feature Flag Misconfiguration**
   - Symptom: Feature exposed prematurely or hidden incorrectly
   - Detection: Feature flag audits, user reports
   - Impact: MEDIUM-HIGH (depends on feature)
   - Probability: MEDIUM (manual configuration)

2. **Performance Degradation**
   - Symptom: Slow responses, increased latency
   - Detection: Latency metrics, p95/p99 alerts
   - Impact: MEDIUM (user experience degraded)
   - Probability: MEDIUM (new code paths untested at scale)

3. **Data Model Incompatibility**
   - Symptom: Data corruption, validation errors
   - Detection: Data integrity checks, error logs
   - Impact: HIGH (data integrity risk)
   - Probability: LOW-MEDIUM (depends on change scope)

4. **Third-Party Integration Failures**
   - Symptom: External service errors, payment failures
   - Detection: Integration health checks, error rates
   - Impact: HIGH (business impact if payment/core function)
   - Probability: MEDIUM (external dependencies)

## Risk Rating Matrix

| Impact / Probability | LOW     | MEDIUM | HIGH     |
| -------------------- | ------- | ------ | -------- |
| HIGH                 | Medium  | High   | Critical |
| MEDIUM               | Low     | Medium | High     |
| LOW                  | Minimal | Low    | Medium   |

## Systematic Enumeration Process

1. **Start with deployment type** - Select relevant category above
2. **Review common modes** - Check each against your specific change
3. **Add custom modes** - Consider unique aspects of your system
4. **Assess dependencies** - Enumerate cascade failure risks
5. **Rate each mode** - Use matrix for consistent ratings
6. **Document detection** - Ensure monitoring exists for each mode
