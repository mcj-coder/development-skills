# library-extraction-stabilisation - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Premature Extraction (2 Consumers)

**Given** agent WITHOUT library-extraction-stabilisation skill
**And** pressure: DRY principle ("don't repeat yourself")
**When** user says: "I'm copying this utility function to the second service, should I extract it?"
**Then** record baseline behaviour:

- Does agent check for 3rd consumer? (expected: NO - assumes 2 is enough)
- Does agent assess stability? (expected: NO - extracts immediately)
- Does agent define ownership? (expected: NO - "shared library" with no owner)
- Rationalizations observed: "DRY says extract now", "Easier to maintain in one place"

### Test R2: Volatile Code Extraction

**Given** agent WITHOUT library-extraction-stabilisation skill
**And** code changed 5 times in the last month
**And** pressure: maintenance burden ("changed it 3 times last month")
**When** user says: "Extract this validation logic into a shared library"
**Then** record baseline behaviour:

- Does agent check if logic has stabilized? (expected: NO - extracts volatile code)
- Does agent define versioning strategy? (expected: NO - assumes latest always works)
- Does agent define breaking change policy? (expected: NO - no governance)
- Rationalizations observed: "Already proven by 4 services", "Library will force stability"

### Test R3: Authority-Driven Extraction

**Given** agent WITHOUT library-extraction-stabilisation skill
**And** pressure: authority ("tech lead said create shared library")
**When** user says: "Create a shared authentication library"
**Then** record baseline behaviour:

- Does agent assess if auth logic is stable? (expected: NO - follows authority)
- Does agent define library ownership team? (expected: NO - assumes everyone owns it)
- Does agent define support expectations? (expected: NO - no SLA or support model)
- Rationalizations observed: "Tech lead knows best", "Best practice recommends it"

### Expected Baseline Failures Summary

- [ ] Agent extracts on 2nd duplication (premature - wait for 3rd consumer)
- [ ] Agent extracts volatile code that changes frequently
- [ ] Agent creates "shared library" with no clear owner
- [ ] Agent doesn't define versioning or breaking change policy
- [ ] Agent doesn't assess extraction costs vs duplication costs

## GREEN Phase - WITH Skill

### Test G1: Premature Extraction Avoided

**Given** agent WITH library-extraction-stabilisation skill
**When** user says: "I'm using this date formatter in 2 services, should I extract it?"
**Then** agent applies extraction readiness assessment:

1. **Consumer count check:**
   - Current consumers: 2
   - Threshold: 3+ consumers (BELOW THRESHOLD)

2. **Recommendation:** WAIT (defer extraction)

3. **Alternative approach provided:**
   - Document location in each service
   - Keep synchronized manually or via script
   - Add TODO comment for future extraction
   - Define re-evaluation triggers

**And** agent provides completion evidence:

- [ ] Consumer count assessed (2 < 3 threshold)
- [ ] Extraction deferred with clear rationale
- [ ] Alternative approach documented
- [ ] Re-evaluation criteria defined
- [ ] No library created prematurely

### Test G2: Stable Extraction with Governance

**Given** agent WITH library-extraction-stabilisation skill
**And** code used by 4 services
**And** code unchanged for 3 months
**When** user says: "Extract the validation library"
**Then** agent applies extraction readiness assessment:

1. **Reuse evidence check:**
   - Current consumers: 4 (meets threshold)
   - Stability: No changes in 3 months (stable)

2. **Library definition:**
   - Name and scope defined
   - Versioning strategy (SemVer)
   - Breaking change policy

3. **Ownership established:**
   - Owner team identified with capacity
   - Support model defined (SLA or best-effort)

4. **Migration plan provided:**
   - Incremental migration steps
   - Rollback strategy
   - Consumer upgrade guide

**And** agent provides completion evidence:

- [ ] Reuse evidence meets threshold (3+ consumers)
- [ ] Stability verified (change frequency assessed)
- [ ] Ownership team defined with capacity
- [ ] SemVer versioning strategy defined
- [ ] Breaking change policy established
- [ ] Migration plan with rollback strategy provided

### Test G3: Volatile Code Extraction Deferred

**Given** agent WITH library-extraction-stabilisation skill
**And** code used by 3 services
**And** code changed 5 times in last month
**When** user says: "Extract the API client into a library"
**Then** agent applies extraction readiness assessment:

1. **Stability assessment:**
   - Change frequency: 5 changes in 30 days (HIGH)
   - Conclusion: NOT STABLE

2. **Recommendation:** DEFER EXTRACTION

3. **Stabilization criteria defined:**
   - Less than 2 changes per month for 2 consecutive months
   - OR all consumers agree on stable interface contract

4. **Alternative approach:**
   - Keep duplicated in services
   - Use code generation to keep in sync
   - Document in ADR
   - Re-assess monthly

**And** agent provides completion evidence:

- [ ] Stability assessed (high change frequency detected)
- [ ] Extraction deferred with rationale
- [ ] Stabilization criteria defined
- [ ] Alternative provided
- [ ] Re-evaluation timeline set

### Test G4: Brainstorming Integration

**Given** agent WITH library-extraction-stabilisation skill
**And** agent WITH superpowers:brainstorming
**When** user says: "Should we extract this HTTP client used by 3 services?"
**Then** agent presents options:

1. **Extract now:** Benefits and risks
2. **Wait for more consumers:** Benefits and risks
3. **Keep duplicated with plan:** Benefits and risks

**And** agent asks clarifying questions:

- Number of consumers and teams
- Change frequency and stability
- Ownership capacity
- Support expectations

**And** agent surfaces tradeoffs:

| Option          | Benefits                         | Risks                              |
| --------------- | -------------------------------- | ---------------------------------- |
| Extract now     | Immediate reuse, single source   | Premature abstraction, coupling    |
| Wait            | Proven stability, clear patterns | Coordination overhead, duplication |
| Keep duplicated | Simplicity, independence         | Maintenance burden, drift          |

**And** agent provides completion evidence:

- [ ] Options presented with tradeoffs
- [ ] Clarifying questions asked
- [ ] Decision factors surfaced
- [ ] Recommendation based on answers

## Pressure Scenarios (WITH Skill)

### Test P1: Resist DRY Pressure

**Given** agent WITH library-extraction-stabilisation skill
**And** user says: "DRY principle says we should extract this now"
**When** only 2 services use the code
**Then** agent responds:

- Acknowledges DRY importance
- Explains DRY applies after proven need
- States 2 uses is not proof (wait for 3rd consumer)
- Proposes interim tracking approach

**And** agent does NOT:

- Extract immediately due to DRY pressure
- Skip consumer count assessment
- Create unowned library

### Test P2: Resist Authority Pressure

**Given** agent WITH library-extraction-stabilisation skill
**And** user says: "Tech lead said create this shared library"
**When** stability or ownership is unclear
**Then** agent responds:

- Respects team dynamics
- Proposes stability/ownership assessment
- Frames as "let's validate requirements"
- Surfaces concerns for tech lead discussion

**And** agent does NOT:

- Automatically follow authority without assessment
- Skip ownership definition
- Create library without support model

### Test P3: Resist Sunk Cost Pressure

**Given** agent WITH library-extraction-stabilisation skill
**And** user says: "We already duplicated this across 4 services, must extract now"
**When** code is still volatile (changed frequently)
**Then** agent responds:

- Acknowledges duplication pain
- Assesses stability before extraction
- Explains volatile library causes upgrade fatigue
- Proposes stabilization-first approach

**And** agent does NOT:

- Extract volatile code due to sunk cost
- Skip stability assessment
- Ignore change frequency

## Integration Scenarios

### Test I1: Integration with verification-before-completion

**Given** agent WITH library-extraction-stabilisation skill
**And** agent WITH superpowers:verification-before-completion
**When** library extraction is "complete"
**Then** agent:

1. Verifies library published to registry
2. Confirms at least one consumer migrated
3. Validates ownership documented
4. Checks versioning strategy documented

**Evidence:**

- [ ] Library exists in package registry
- [ ] At least one consumer using library
- [ ] CODEOWNERS or ownership doc exists
- [ ] CHANGELOG or versioning doc exists

### Test I2: Documentation Integration

**Given** agent WITH library-extraction-stabilisation skill
**When** library is extracted
**Then** agent creates documentation:

- Library registry entry (docs/libraries/{name}.md)
- Migration guide for consumers
- Breaking change policy

**When** extraction is deferred
**Then** agent creates documentation:

- ADR documenting deferral decision
- Stabilization criteria for re-assessment
- Timeline for re-evaluation

## Rationalizations Closure

### Test RC1: "DRY principle says extract now"

**Given** agent WITH library-extraction-stabilisation skill
**When** user rationalizes: "DRY principle says extract now"
**Then** agent responds:

- "DRY applies after proven need. 2 uses isn't proof. Wait for 3rd consumer."
- Applies consumer count assessment
- Does NOT extract prematurely

### Test RC2: "Easier to maintain in one place"

**Given** agent WITH library-extraction-stabilisation skill
**When** user rationalizes: "Easier to maintain in one place"
**Then** agent responds:

- "Only if stable. Volatile library causes consumer upgrade fatigue."
- Applies stability assessment
- Checks change frequency before extracting

### Test RC3: "Library will force stability"

**Given** agent WITH library-extraction-stabilisation skill
**When** user rationalizes: "Library will force stability"
**Then** agent responds:

- "Backwards. Stability enables libraries. Extracting volatile code creates upgrade burden."
- Defers extraction until stable
- Proposes stabilization-first approach

### Test RC4: "Tech lead knows best"

**Given** agent WITH library-extraction-stabilisation skill
**When** user rationalizes: "Tech lead knows best"
**Then** agent responds:

- "Clarify with tech lead. Share stability/ownership concerns. Get alignment."
- Proposes assessment for tech lead review
- Surfaces governance requirements

## Verification Assertions

Each GREEN test should verify:

- [ ] Consumer count assessed (threshold: 3+)
- [ ] Stability assessed (change frequency)
- [ ] Ownership defined (team with capacity)
- [ ] Support model defined (SLA or best-effort)
- [ ] Versioning strategy defined (SemVer)
- [ ] Breaking change policy established
- [ ] Migration plan provided (if extracting)
- [ ] Alternative approach provided (if deferring)
- [ ] Stabilization criteria defined (if deferring)
- [ ] Rationalizations closed (cannot be bypassed)
