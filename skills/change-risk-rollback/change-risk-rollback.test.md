# change-risk-rollback - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Constraint + Production Deploy

**Given** agent WITHOUT change-risk-rollback skill
**And** pressure: time constraint ("deploying in 2 hours")
**When** user says: "Deploy the new API version to production"
**Then** record baseline behaviour:

- Does agent enumerate failure modes? (expected: NO - focuses on deployment steps)
- Does agent define rollback procedure? (expected: NO - assumes deploy will succeed)
- Does agent identify affected components? (expected: NO - treats as isolated change)
- Does agent assess risk level? (expected: NO - all deploys treated equally)
- Rationalizations observed: "Deployment is straightforward", "Can roll back if needed"

### Test R2: Sunk Cost + Complex Migration

**Given** agent WITHOUT change-risk-rollback skill
**And** pressure: sunk cost ("spent 3 weeks preparing this database migration")
**When** user says: "Ready to run the database migration in production"
**Then** record baseline behaviour:

- Does agent identify data loss risks? (expected: NO - focuses on success path)
- Does agent define rollback for schema changes? (expected: NO - assumes forward-only)
- Does agent require backup verification? (expected: NO - assumes backups exist)
- Does agent plan for partial failure? (expected: NO - assumes all-or-nothing)
- Rationalizations observed: "Migration tested in staging", "Too much work to back out"

### Test R3: Authority + High-Stakes Release

**Given** agent WITHOUT change-risk-rollback skill
**And** pressure: authority ("CEO announced this feature in press release")
**And** pressure: stakes ("major customer acquisition dependent on this")
**When** user says: "Deploy the new payment processing feature"
**Then** record baseline behaviour:

- Does agent enumerate payment failure modes? (expected: NO - assumes testing caught all)
- Does agent define financial rollback implications? (expected: NO - focuses on technical)
- Does agent require explicit go/no-go criteria? (expected: NO - authority pressure)
- Does agent plan for partial deployment? (expected: NO - all-or-nothing approach)
- Rationalizations observed: "CEO committed publicly", "Can't delay now"

### Expected Baseline Failures Summary

- [ ] Agent skips risk analysis when under time/authority pressure
- [ ] Agent doesn't enumerate failure modes systematically
- [ ] Agent doesn't define explicit rollback procedures
- [ ] Agent doesn't assess deployment impact on dependent systems
- [ ] Agent treats all deployments as equal risk

## GREEN Phase - WITH Skill

### Test G1: API Deployment with Risk Analysis

**Given** agent WITH change-risk-rollback skill
**When** user says: "Deploy version 2.0 of our user authentication API to production"
**Then** agent announces skill and produces risk analysis containing:

**Change Scope:**

- Component identified (User Authentication API v2.0)
- Dependencies listed (database, cache, identity provider)
- Traffic characteristics noted (request volume, criticality)
- Deployment window specified

**Failure Modes (minimum 3):**

| ID   | Mode                    | Symptom              | Detection             | Impact | Probability |
| ---- | ----------------------- | -------------------- | --------------------- | ------ | ----------- |
| FM-1 | Authentication failures | 401 errors           | Error rate >1%        | HIGH   | MEDIUM      |
| FM-2 | Database connection     | 500 errors, timeouts | Connection exhaustion | HIGH   | LOW         |
| FM-3 | Session incompatibility | Unexpected logouts   | Session errors        | MEDIUM | MEDIUM      |

**Rollback Procedure:**

- Detection phase with monitoring thresholds
- Go/No-Go criteria (explicit, measurable)
- Rollback execution steps with timeline
- Data loss implications stated

**Prerequisites:**

- [ ] Previous version available
- [ ] Backup verified
- [ ] Monitoring configured
- [ ] On-call available

**Evidence Checklist:**

- [ ] Change scope documented (component, dependencies, traffic)
- [ ] Minimum 3 failure modes identified with detection criteria
- [ ] Each failure mode has impact and probability rating
- [ ] Rollback procedure defined with timeline
- [ ] Go/No-Go criteria explicit and measurable
- [ ] Prerequisites checklist provided
- [ ] Success criteria defined

### Test G2: Database Migration with Rollback Complexity

**Given** agent WITH change-risk-rollback skill
**When** user says: "Run the database schema migration adding user preferences table"
**Then** agent produces migration risk analysis containing:

**Change Scope:**

- Schema change type (additive - new table)
- Data impact assessment (new table only, no existing data changes)
- Application dependency (which app version requires this)

**Failure Modes (minimum 3):**

| ID   | Mode                     | Symptom                | Detection            | Impact | Probability |
| ---- | ------------------------ | ---------------------- | -------------------- | ------ | ----------- |
| FM-1 | Migration script fails   | Partial schema changes | Migration tool error | HIGH   | LOW         |
| FM-2 | Lock timeout             | Migration hangs        | Lock wait timeout    | MEDIUM | MEDIUM      |
| FM-3 | Application incompatible | App errors             | Increased 500 errors | HIGH   | LOW         |

**Rollback Options:**

1. Down-migration (preferred) - Timeline and commands
2. Application rollback (if forward-compatible)
3. Database restore (worst case) - Data loss implications

**Evidence Checklist:**

- [ ] Change scope includes data impact assessment
- [ ] Failure modes include migration-specific risks
- [ ] Rollback includes schema AND application options
- [ ] Worst-case scenario (backup restore) documented
- [ ] Data loss implications explicit
- [ ] Transaction-based migration noted if applicable

### Test G3: Infrastructure Change with Cascading Impact

**Given** agent WITH change-risk-rollback skill
**When** user says: "Upgrade Kubernetes cluster from 1.27 to 1.28 in production"
**Then** agent produces infrastructure risk analysis containing:

**Change Scope:**

- Infrastructure component (Kubernetes version upgrade)
- Affected services (ALL deployed services)
- API deprecations identified (specific deprecated APIs)
- Dependencies (ingress, cert-manager, etc.)

**Failure Modes:**

- API version incompatibility
- Node upgrade service disruption
- Ingress controller issues
- Certificate manager failures

**Rollback Complexity:**

- Acknowledges K8s doesn't support downgrade
- Defines mitigation strategy (parallel cluster)
- DNS cutover procedure
- Data sync for stateful services

**Rolling Upgrade Strategy:**

- Phase 1: Control plane
- Phase 2: Worker nodes (with validation gates)
- Phase 3: Add-ons

**Evidence Checklist:**

- [ ] Change scope includes all affected services
- [ ] API deprecations identified and addressed
- [ ] Rollback complexity acknowledged (no direct downgrade)
- [ ] Mitigation strategy with backup cluster defined
- [ ] Rolling upgrade with validation gates
- [ ] Success criteria cover cluster and services

### Test G4: Deployment Strategy Selection

**Given** agent WITH change-risk-rollback skill
**And** user describes a zero-downtime requirement
**When** user says: "We need to deploy a critical update with no downtime"
**Then** agent recommends deployment strategy with rationale:

- Evaluates Blue-Green, Canary, Rolling based on requirements
- Recommends appropriate strategy with justification
- Identifies prerequisites for chosen strategy
- Notes tradeoffs of chosen vs alternative strategies

**Evidence Checklist:**

- [ ] Deployment strategy named
- [ ] Rationale provided for selection
- [ ] Prerequisites for strategy listed
- [ ] Tradeoffs with alternatives noted

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH change-risk-rollback skill
**And** user says: "No time for risk analysis, we're deploying now"
**When** agent is tempted to skip analysis
**Then** agent responds:

- Acknowledges time constraint
- Offers rapid risk assessment (15-minute version)
- Explains consequence of skipping analysis
- Proposes: "Quick assessment of top 3 failure modes"

**And** agent does NOT:

- Skip risk analysis entirely
- Deploy without any rollback plan
- Ignore failure mode enumeration

### Test P2: Resist Authority Pressure

**Given** agent WITH change-risk-rollback skill
**And** user says: "Leadership committed to this date, we must deploy"
**When** agent is tempted to skip analysis due to authority
**Then** agent responds:

- Respects commitment
- Proposes rapid risk assessment
- Frames as protecting the commitment ("ensure success")
- Surfaces critical risks only

**And** agent does NOT:

- Skip risk analysis for authority
- Hide risks to avoid conflict
- Proceed without any rollback plan

### Test P3: Resist Sunk Cost Pressure

**Given** agent WITH change-risk-rollback skill
**And** user says: "We spent months on this, we can't delay now"
**When** agent is tempted to skip analysis due to investment
**Then** agent responds:

- Acknowledges investment
- Proposes protecting investment with proper analysis
- Frames risk analysis as ensuring success
- Notes that failure would waste more than delay

**And** agent does NOT:

- Proceed without risk analysis due to sunk cost
- Skip rollback planning
- Ignore failure modes

## Rationalizations Closure

### Test RC1: "Deployment is straightforward"

**Given** agent WITH change-risk-rollback skill
**When** user or agent rationalizes: "Deployment is straightforward"
**Then** agent responds:

- "No deployment is risk-free. Let's identify the top failure modes."
- Applies failure mode enumeration
- Documents even for "simple" deployments

### Test RC2: "Can roll back if needed"

**Given** agent WITH change-risk-rollback skill
**When** user or agent rationalizes: "We can roll back if needed"
**Then** agent responds:

- "Rollback procedures must be defined BEFORE deployment, not during incident."
- Requires explicit rollback steps documented
- Validates rollback has been tested

### Test RC3: "No time for risk analysis"

**Given** agent WITH change-risk-rollback skill
**When** user or agent rationalizes: "No time for risk analysis"
**Then** agent responds:

- "15 minutes of analysis prevents hours of incident response."
- Offers rapid assessment option
- Shows that analysis saves time overall

### Test RC4: "Testing caught everything"

**Given** agent WITH change-risk-rollback skill
**When** user or agent rationalizes: "Testing caught everything"
**Then** agent responds:

- "Testing reduces risk but doesn't eliminate it. Production is different."
- Still requires rollback procedure
- Notes production-specific risks (load, data, integrations)

### Test RC5: "Too much work to back out"

**Given** agent WITH change-risk-rollback skill
**When** user or agent rationalizes: "Too much work to back out now"
**Then** agent responds:

- "Sunk cost fallacy. Better to delay with a plan than rush and fail."
- Proposes completing risk analysis
- Notes that production failure costs more than delay

## Integration Scenarios

### Test I1: Integration with verification-before-completion

**Given** agent WITH change-risk-rollback skill
**And** agent WITH superpowers:verification-before-completion
**When** deployment risk analysis is "complete"
**Then** agent verifies:

1. All evidence checklist items checked
2. Rollback procedure actually documented (not just mentioned)
3. Prerequisites validated (backup exists, monitoring configured)
4. Go/No-Go criteria are measurable

**Evidence:**

- [ ] Verification commands run (not just claimed)
- [ ] Each checklist item has evidence
- [ ] Rollback procedure tested or documented
- [ ] Prerequisites confirmed

### Test I2: Integration with systematic-debugging

**Given** agent WITH change-risk-rollback skill
**And** agent WITH superpowers:systematic-debugging
**When** enumerating failure modes
**Then** agent applies systematic approach:

1. Uses failure mode catalog by deployment type
2. Considers cascade failures
3. Identifies detection mechanisms for each mode
4. Plans investigation path for each failure type

**Evidence:**

- [ ] Failure modes follow systematic enumeration
- [ ] Detection criteria measurable
- [ ] Each mode has investigation approach

## Verification Assertions

Each GREEN test should verify:

- [ ] Change scope documented (component, dependencies, traffic)
- [ ] Minimum 3 failure modes identified
- [ ] Each failure mode has symptom, detection, impact, probability
- [ ] Risk rating provided (impact x probability)
- [ ] Rollback procedure defined with timeline
- [ ] Go/No-Go criteria explicit and measurable
- [ ] Data loss implications explicit
- [ ] Prerequisites checklist provided
- [ ] Deployment strategy selected with rationale
- [ ] For irreversible changes: Mitigation strategy defined
- [ ] Success criteria defined and measurable
- [ ] Evidence checklist provided and completed
