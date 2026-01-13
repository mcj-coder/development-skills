# Deployment Strategies Guide

Select the appropriate deployment strategy based on risk profile, system
characteristics, and organizational capabilities.

## Strategy Comparison Matrix

| Strategy   | Downtime    | Rollback Speed | Infrastructure | Risk Level |
| ---------- | ----------- | -------------- | -------------- | ---------- |
| Blue-Green | Zero        | Instant        | 2x required    | Low        |
| Canary     | Zero        | Fast           | Minimal extra  | Low        |
| Rolling    | Zero        | Medium         | None extra     | Medium     |
| Big-Bang   | During swap | Slow           | None extra     | High       |

## Blue-Green Deployment

**Description:** Maintain two identical environments. Deploy to inactive (Green),
switch traffic when validated, keep Blue as instant rollback.

### When to Use

- Zero-downtime requirement
- Need instant rollback capability
- Can afford 2x infrastructure during deployment
- Database changes are forward/backward compatible
- High-criticality services (payment, authentication)

### When NOT to Use

- Cost-constrained environment (2x infrastructure)
- Database migrations requiring exclusive locks
- Services with large persistent state (sync complexity)
- Frequent deployments (overhead may not be worth it)

### Rollback Characteristics

- **Speed:** Instant (<30 seconds)
- **Data:** No loss if DB unchanged
- **Complexity:** Simple (traffic switch only)
- **Risk:** Very low

### Implementation Checklist

- [ ] Load balancer supports instant switching
- [ ] Both environments identically configured
- [ ] Database compatible with both versions
- [ ] Health checks validate before switching
- [ ] Monitoring covers both environments

## Canary Deployment

**Description:** Route small percentage of traffic to new version. Gradually
increase if metrics remain healthy. Roll back by routing 100% to stable.

### When to Use

- Need real-world validation before full rollout
- User impact tolerance for small percentage
- Good observability and metrics
- Changes may have subtle performance impacts
- Large user base (statistical significance)

### When NOT to Use

- Small user base (canary too small to detect issues)
- All-or-nothing features (feature flags better)
- Database schema changes (all instances share DB)
- Urgent hotfixes (too slow)

### Rollback Characteristics

- **Speed:** Fast (minutes)
- **Data:** Canary users may have different experience
- **Complexity:** Medium (traffic routing)
- **Risk:** Low (limited blast radius)

### Implementation Checklist

- [ ] Traffic routing supports percentage-based splits
- [ ] Metrics can segment by version
- [ ] Automated health comparison (canary vs stable)
- [ ] Clear escalation path for canary failures
- [ ] Feature flags for canary-only features

### Traffic Progression Example

```text
Stage 1:  1% for 10 minutes  - Detect catastrophic failures
Stage 2:  5% for 30 minutes  - Detect significant issues
Stage 3: 25% for 1 hour      - Detect performance regressions
Stage 4: 50% for 2 hours     - Broader validation
Stage 5: 100%                - Full rollout
```

## Rolling Deployment

**Description:** Replace instances one at a time (or in batches). Each batch
validated before proceeding. No extra infrastructure required.

### When to Use

- Cannot afford extra infrastructure
- Acceptable brief capacity reduction during rollout
- Instances are stateless or gracefully drained
- Moderate risk tolerance
- Standard application updates

### When NOT to Use

- Zero capacity reduction tolerance
- Stateful instances without graceful handoff
- Need instant rollback (rolling back takes time)
- Very large deployments (takes too long)

### Rollback Characteristics

- **Speed:** Medium (reverse rolling update)
- **Data:** Instances may have processed requests
- **Complexity:** Medium (must reverse in order)
- **Risk:** Medium (partial state during rollout)

### Implementation Checklist

- [ ] Health checks validate each instance
- [ ] Graceful shutdown configured
- [ ] Connection draining enabled
- [ ] Batch size configured appropriately
- [ ] Rollback automation available

### Batch Size Guidance

| Cluster Size | Batch Size | Rationale                      |
| ------------ | ---------- | ------------------------------ |
| 3-5          | 1          | Maintain quorum                |
| 6-10         | 2          | Balance speed and risk         |
| 11-20        | 3-4        | Faster rollout, still cautious |
| 20+          | 10-20%     | Percentage-based               |

## Big-Bang Deployment

**Description:** Replace all instances simultaneously. Typically involves
downtime. Simplest approach but highest risk.

### When to Use

- Downtime is acceptable (maintenance window)
- Changes incompatible with rolling (schema migration)
- Very small, non-critical services
- Development/staging environments
- One-time migrations

### When NOT to Use

- Production systems requiring high availability
- Customer-facing services
- Changes that can use safer strategies
- Frequent deployments

### Rollback Characteristics

- **Speed:** Slow (redeploy previous version)
- **Data:** May have processed during failed deployment
- **Complexity:** High (full redeploy required)
- **Risk:** High (all-or-nothing)

### Risk Mitigation

- [ ] Scheduled during lowest traffic period
- [ ] Maintenance page ready
- [ ] Previous version immediately deployable
- [ ] Database backup before deployment
- [ ] Extended testing in staging
- [ ] Stakeholder communication plan

## Strategy Selection Decision Tree

```text
START: New deployment planned
  |
  +-> Is zero downtime required?
       |
       +-> YES: Can afford 2x infrastructure?
       |         |
       |         +-> YES: Use BLUE-GREEN
       |         |
       |         +-> NO: Need gradual validation?
       |                  |
       |                  +-> YES: Use CANARY
       |                  |
       |                  +-> NO: Use ROLLING
       |
       +-> NO: Is change incompatible with rolling?
                |
                +-> YES: Use BIG-BANG (with downtime)
                |
                +-> NO: Prefer ROLLING or BLUE-GREEN
```

## Database-Aware Strategy Selection

Database changes add complexity. Consider:

| DB Change Type              | Compatible Strategies        | Notes                          |
| --------------------------- | ---------------------------- | ------------------------------ |
| Additive (new column/table) | All                          | Forward-compatible             |
| Nullable column removal     | Blue-Green, Big-Bang         | Requires coordination          |
| Schema restructure          | Big-Bang                     | Usually requires downtime      |
| Data migration              | Rolling (app), Big-Bang (DB) | Separate app and DB deployment |

## Strategy Combinations

Complex deployments may combine strategies:

1. **Database First (Big-Bang) + App (Blue-Green)**
   - Migrate DB during maintenance window
   - Deploy new app version with instant rollback
   - Suitable for schema changes with zero-downtime app deploy

2. **Canary (App) + Feature Flag**
   - Deploy to all, but feature flag controls exposure
   - Canary users get flag enabled
   - Combines deployment validation with feature rollout

3. **Rolling (Infrastructure) + Blue-Green (App)**
   - Infrastructure changes rolled incrementally
   - Application deployment uses blue-green per node
   - Reduces blast radius for both layers
