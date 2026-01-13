# Rollback Procedure Templates

Structured templates for defining rollback procedures by deployment type.

## Rollback Procedure Structure

Every rollback procedure must include:

1. **Detection Phase** - How to identify need for rollback
2. **Decision Criteria** - Explicit Go/No-Go thresholds
3. **Execution Steps** - Ordered rollback actions with timelines
4. **Validation** - How to confirm rollback succeeded
5. **Data Implications** - Any data loss or inconsistency risks

## API/Service Rollback Template

```markdown
### Detection Phase (0-5 minutes)

- Monitor: [Dashboard URL], [Metrics]
- Alert thresholds:
  - Error rate: >X%
  - Latency p95: >Xms
  - Health checks: Any failure

### Decision Criteria

**GO (continue deployment):**

- Error rate <0.5%
- Health checks passing
- p95 latency <200ms
- No customer-reported issues

**NO-GO (trigger rollback):**

- Error rate >1%
- Any health check failing
- p95 latency >500ms
- Critical customer reports

### Rollback Execution

1. [Action] - Timeline: X minutes
   - Command: [specific command]
   - Verification: [how to verify step completed]
2. [Action] - Timeline: X minutes
   ...

### Validation

- [ ] Error rate returned to baseline
- [ ] Health checks passing
- [ ] Latency metrics normal
- [ ] Sample requests successful

### Data Implications

- Data loss: [None | Description]
- Inconsistency risk: [None | Description]
- Recovery procedure: [If applicable]
```

## Database Migration Rollback Template

```markdown
### Detection Phase (0-10 minutes)

- Monitor: Database health, application error rates
- Alerts:
  - Migration tool status
  - Application errors related to schema
  - Lock wait timeouts

### Decision Criteria

**GO (migration successful):**

- Migration completed without errors
- Schema validation passed
- Application startup successful
- No data integrity errors

**NO-GO (trigger rollback):**

- Migration script failed
- Lock timeout exceeded
- Application errors after migration
- Data integrity violations detected

### Rollback Options

**Option 1: Down-Migration (preferred)**

- Scope: Schema changes only, no data loss
- Timeline: <5 minutes
- Command: [down-migration command]
- Verification: Schema matches pre-migration state

**Option 2: Application Rollback (forward-compatible)**

- Scope: Application only, schema remains
- Timeline: ~5 minutes (standard deployment)
- Condition: Migration is forward-compatible
- Data impact: None (schema ignored by old app)

**Option 3: Database Restore (worst case)**

- Scope: Full database restore
- Timeline: ~30 minutes
- Data loss: Changes since backup (max X minutes)
- Requires: Downtime during restore

### Validation

- [ ] Schema matches expected state
- [ ] Application connects successfully
- [ ] Data integrity checks pass
- [ ] No orphaned records or constraint violations

### Data Implications

- Down-migration data loss: [None | Description]
- Restore data loss: Up to X minutes of transactions
- Recovery for lost data: [Procedure if applicable]
```

## Infrastructure Rollback Template

```markdown
### Detection Phase (0-15 minutes)

- Monitor: Infrastructure health, service availability
- Alerts:
  - Node/instance status
  - Service health checks
  - API compatibility errors

### Decision Criteria

**GO (upgrade successful):**

- All nodes/instances healthy
- All services reporting ready
- No API deprecation errors
- External health checks passing

**NO-GO (trigger rollback):**

- Nodes not becoming ready
- Services failing to schedule
- API compatibility errors
- External traffic failing

### Rollback Options

**Option 1: Component Rollback (if supported)**

- Scope: Single component/node
- Timeline: ~10 minutes per component
- Procedure: [Specific rollback steps]
- Limitation: [Any limitations]

**Option 2: Parallel Environment Switch**

- Scope: Full environment
- Timeline: <5 minutes (DNS/LB switch)
- Requires: Parallel environment maintained
- Data sync: [Required for stateful services]

**Option 3: Full Rebuild (last resort)**

- Scope: Complete infrastructure recreation
- Timeline: ~60 minutes
- Data: Restore from backups
- Downtime: Significant

### Validation

- [ ] All components healthy
- [ ] All services available
- [ ] External traffic routing correctly
- [ ] Monitoring showing normal metrics

### Data Implications

- Stateless services: No data impact
- Stateful services: [Sync procedure required]
- Persistent storage: [Verify data accessibility]
```

## Blue-Green Deployment Rollback

```markdown
### Rollback Trigger

- Any NO-GO criteria met during deployment
- Automated: If health checks fail within X minutes
- Manual: On-call decision based on metrics

### Execution (Instant)

1. Switch load balancer back to Blue environment
   - Command: [LB configuration command]
   - Timeline: <30 seconds
2. Verify traffic routing
   - Check: [Traffic metrics dashboard]
3. Keep Green environment for debugging
   - Do NOT destroy until root cause identified

### Validation

- [ ] All traffic routing to Blue
- [ ] Error rate returned to baseline
- [ ] No user-facing impact

### Data Implications

- Data loss: None (if no DB changes in Green)
- Data divergence: [If Green processed transactions, reconciliation needed]
```

## Canary Deployment Rollback

```markdown
### Rollback Trigger

- Canary metrics exceed thresholds
- Error rate in canary >X% higher than baseline
- User complaints from canary population

### Execution (Gradual)

1. Reduce canary traffic to 0%
   - Command: [Traffic routing command]
   - Timeline: Immediate
2. Remove canary instances
   - Timeline: ~5 minutes
3. Investigate canary logs before cleanup

### Validation

- [ ] All traffic to stable version
- [ ] Canary instances terminated
- [ ] Metrics returned to baseline

### Data Implications

- User impact: Limited to canary population
- Data: Canary users may have seen different behavior
```

## Prerequisites Checklist Template

Before any deployment, verify:

```markdown
### Pre-Deployment Checklist

- [ ] Backup completed and verified (timestamp: \_\_\_)
- [ ] Previous version available for rollback
- [ ] Rollback procedure documented and reviewed
- [ ] Monitoring dashboards configured
- [ ] Alert thresholds set
- [ ] On-call engineer identified and available
- [ ] Communication plan ready (if rollback needed)
- [ ] Deployment window confirmed (low-traffic period)
- [ ] Rollback tested in staging environment
- [ ] Go/No-Go criteria documented and agreed
```

## Post-Rollback Actions

After any rollback:

1. **Document incident** - What triggered rollback
2. **Preserve evidence** - Logs, metrics, error messages
3. **Notify stakeholders** - Per communication plan
4. **Root cause analysis** - Schedule investigation
5. **Update deployment plan** - Address identified issues
6. **Reschedule deployment** - After fixes validated
