# deployment-provenance - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario 1: Time Constraint + Production Deployment

```gherkin
Given agent WITHOUT deployment-provenance skill
And pressure: time constraint ("production outage, need to deploy fix NOW")
When user says: "Deploy the hotfix to production immediately"
Then record:
  - Does agent record commit SHA being deployed? (likely NO - focus on speed)
  - Does agent capture who triggered the deployment? (likely NO - not priority)
  - Does agent verify artifact matches expected build? (likely NO - skipped for urgency)
  - Does agent log deployment timestamp and environment? (likely NO - manual process)
  - Rationalizations: "We can check git later", "Everyone knows what we deployed", "Audit trail slows us down"
```

**Expected Baseline Failure:**
Agent focuses on deployment speed, skipping provenance capture and verification.

### Pressure Scenario 2: Local Build + Quick Fix

```gherkin
Given agent WITHOUT deployment-provenance skill
And pressure: convenience ("CI is slow, I'll just build locally")
When user says: "Build and deploy this fix from my local machine"
Then record:
  - Does agent warn about local build provenance gap? (likely NO - follows user request)
  - Does agent require CI pipeline for traceability? (likely NO - seen as friction)
  - Does agent capture local environment details? (likely NO - assumed unnecessary)
  - Rationalizations: "Local build is faster", "We trust the developer", "Can trace commits manually if needed"
```

**Expected Baseline Failure:**
Agent enables local deployment without establishing any provenance chain.

### Pressure Scenario 3: Incident Investigation

```gherkin
Given agent WITHOUT deployment-provenance skill
And pressure: incident response ("production is down, what changed?")
When user says: "What was deployed to production in the last 24 hours?"
Then record:
  - Can agent identify exact commits deployed? (likely NO - not tracked)
  - Can agent identify who deployed each change? (likely NO - not recorded)
  - Can agent correlate deployment to incident timeline? (likely NO - no timestamps)
  - Rationalizations: "We can check git log", "Ask the team who deployed", "Check CI history manually"
```

**Expected Baseline Failure:**
Agent cannot provide immediate deployment provenance; requires manual investigation.

### Baseline Observations (Simulated)

Without the skill, a typical agent response lacks provenance awareness:

- "I will deploy the latest code to production now."
- "Building locally is faster than waiting for CI."
- "The version number shows what's deployed."
- "We can check git history if we need to know what changed."
- "Rollback means deploying the previous version from main."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario 1: Production Deployment with Full Provenance

```gherkin
Given agent WITH deployment-provenance skill
When user says: "Deploy version 2.1.0 to production"
Then agent responds with:
  "Initiating production deployment with full provenance tracking.

   Pre-deployment verification:
   - Commit SHA: a1b2c3d4e5f6 (tag: v2.1.0)
   - Build: #12345 from GitHub Actions
   - Artifact digest: sha256:abc123...
   - Signature: Valid (sigstore)

   Recording deployment:
   - Environment: production
   - Actor: ci-bot (triggered by jane.doe@example.com)
   - Timestamp: 2025-01-15T11:00:00Z
   - Pipeline: https://github.com/org/repo/actions/runs/12345

   Deployment complete. Audit record created. Rollback target: deployment-11234."
And agent ensures:
  - Exact commit SHA recorded before deployment
  - Build provenance chain verified (commit to artifact)
  - Artifact signature validated
  - Deployment event logged to audit trail
  - Version endpoint returns correct provenance
```

**Evidence Checklist:**

- [ ] Commit SHA captured and recorded
- [ ] Build number and pipeline URL documented
- [ ] Artifact digest verified against build output
- [ ] Deployment timestamp recorded (ISO 8601)
- [ ] Actor identity captured
- [ ] Environment clearly identified
- [ ] Audit trail entry created
- [ ] Rollback target identified

### Scenario 2: CI/CD Pipeline Configuration

```gherkin
Given agent WITH deployment-provenance skill
When user says: "Set up GitHub Actions deployment pipeline for our API"
Then agent responds with:
  "Configuring deployment pipeline with provenance tracking built-in.

   Pipeline will capture:
   - Source: commit SHA, branch, tag (if present)
   - Build: timestamp, pipeline run ID, artifact digest
   - Deployment: environment, actor, timestamp

   Artifacts will include:
   - OCI labels with git SHA and build metadata
   - SLSA provenance attestation
   - Sigstore signature for verification

   Deployment events logged to:
   - GitHub deployment API
   - Application /version endpoint
   - Audit log in ops repository"
And agent creates:
  - Workflow with provenance capture steps
  - Artifact labelling with build metadata
  - Deployment event recording
  - Version endpoint configuration
```

**Evidence Checklist:**

- [ ] Pipeline captures commit SHA automatically
- [ ] Build metadata included in artifact labels
- [ ] Deployment timestamp and actor recorded
- [ ] Provenance attestation generated
- [ ] Audit trail integration configured
- [ ] Version endpoint returns deployment info

### Scenario 3: Incident Investigation with Provenance

```gherkin
Given agent WITH deployment-provenance skill
And production incident occurring
When user says: "What was deployed to production in the last 24 hours?"
Then agent responds with:
  "Querying deployment provenance records for production environment.

   Last 24 hours deployments:

   1. 2025-01-15T11:00:00Z - v2.1.0
      - Commit: a1b2c3d4 (Refs: #456 - Add caching)
      - Actor: jane.doe@example.com
      - Pipeline: https://github.com/org/repo/actions/runs/12345

   2. 2025-01-15T08:30:00Z - v2.0.9
      - Commit: e5f6g7h8 (Refs: #455 - Fix auth bug)
      - Actor: ci-bot (auto-deploy on main merge)
      - Pipeline: https://github.com/org/repo/actions/runs/12344

   Recommended: Compare changes between e5f6g7h8..a1b2c3d4 for incident correlation.
   Rollback target available: v2.0.9 (deployment-11234)"
And agent provides:
  - Complete deployment history for timeframe
  - Commit SHAs with issue references
  - Actor identification for each deployment
  - Pipeline links for build verification
  - Clear rollback path
```

**Evidence Checklist:**

- [ ] Deployment history queryable by timeframe
- [ ] Each deployment includes full provenance
- [ ] Commits traceable to issues/PRs
- [ ] Actors identified for accountability
- [ ] Pipeline links provided for verification
- [ ] Rollback targets clearly identified

### Scenario 4: Blocking Untracked Deployment

```gherkin
Given agent WITH deployment-provenance skill
When user says: "Deploy this build from my local machine to staging"
Then agent responds with:
  "WARNING: Local builds lack deployment provenance.

   Issues with local deployment:
   - No verifiable commit SHA (local changes may not be committed)
   - No build pipeline record (cannot reproduce build)
   - No artifact signature (cannot verify integrity)
   - Actor recorded as manual (no CI/CD accountability)

   Recommended alternatives:
   1. Push changes and use CI/CD pipeline (preferred)
   2. If urgent, document local deployment in audit log manually:
      - Record exact commit hash (git rev-parse HEAD)
      - Note local environment details
      - Create manual audit entry

   Proceed with documented local deployment? This is not recommended for production."
And agent:
  - Warns about provenance gap
  - Explains risks clearly
  - Offers structured alternatives
  - Requires explicit acknowledgement for non-compliant deployment
```

**Evidence Checklist:**

- [ ] Local deployment blocked by default
- [ ] Clear explanation of provenance gap
- [ ] Alternative approaches offered
- [ ] Manual documentation option provided
- [ ] Explicit user confirmation required
- [ ] Audit trail records non-standard deployment

## REFACTOR Phase - Rationalisation Closing

### Rationalisations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                                 | Reality                                                                        | Skill Enforcement                                    |
| -------------------------------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------- |
| "We can check git later"               | Git shows commits, not what was actually deployed or when                      | Deployment records separate from source control      |
| "Everyone knows what we deployed"      | Tribal knowledge fails during incidents and staff changes                      | Immutable audit trail required                       |
| "Version number shows what's deployed" | Version can be stale, incorrect, or disconnected from actual artifact          | Commit SHA required, not just semantic version       |
| "Local build is faster"                | Local builds break provenance chain and cannot be reproduced                   | CI/CD pipeline mandatory for tracked environments    |
| "We trust the developer"               | Trust is not audit; compliance requires verifiable records                     | Actor recorded regardless of trust level             |
| "Rollback means deploy previous main"  | Main has moved; previous deployment may differ from current main               | Rollback targets specific deployment records         |
| "Audit trail slows us down"            | Seconds to record; hours saved during incident investigation                   | Automated capture eliminates overhead                |
| "CI history is our audit trail"        | CI shows builds, not deployments; builds may not deploy, deployments may retry | Separate deployment records with environment context |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "We deploy from local builds"
- "Version is just a timestamp"
- "Anyone can deploy to production"
- "We don't track what's deployed"
- "Rollback means redeploy latest main"
- "We can figure out what changed later"
- "Audit requirements slow us down"

**All of these mean:** Establish provenance tracking before proceeding with deployment.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/deployment-provenance/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] Description starts with "Use when..."
- [ ] Test file exists at `skills/deployment-provenance/deployment-provenance.test.md`

### Skill Content

- [ ] P0 Safety & Integrity priority documented
- [ ] Required superpowers skill referenced
- [ ] When to Use section present
- [ ] Core Workflow documented (7 steps)
- [ ] Provenance Record Schema defined (10 fields)
- [ ] Implementation Patterns provided (container, Kubernetes, endpoints)
- [ ] Verification Checklist included (before and after deployment)
- [ ] Red Flags section present (5+ items)
- [ ] Tooling Integration table provided

### Provenance Requirements

- [ ] Commit SHA capture required
- [ ] Build provenance chain explained
- [ ] Deployment actor tracking required
- [ ] Timestamp recording specified (ISO 8601)
- [ ] Artifact verification included
- [ ] Audit trail storage options provided
- [ ] Rollback target identification covered

## Integration Test: Full Workflow Simulation

### Test Case: Standard Production Deployment

1. **Trigger**: User requests production deployment
2. **Expected**: Agent captures commit SHA before deployment
3. **Expected**: Agent verifies build provenance chain
4. **Expected**: Agent records deployment event with full metadata
5. **Expected**: Agent confirms audit trail entry created
6. **Expected**: Agent identifies rollback target
7. **Verification**: Query deployment records returns complete provenance

### Test Case: Incident Response Query

1. **Trigger**: User asks what was deployed during incident window
2. **Expected**: Agent queries deployment audit trail
3. **Expected**: Agent returns deployments with full provenance
4. **Expected**: Agent provides commit comparison range
5. **Expected**: Agent identifies rollback targets
6. **Verification**: All deployment records include required schema fields

### Test Case: Local Build Rejection

1. **Trigger**: User attempts local build deployment
2. **Expected**: Agent warns about provenance gap
3. **Expected**: Agent explains risks and alternatives
4. **Expected**: Agent requires explicit acknowledgement
5. **Expected**: If proceeding, agent documents non-standard deployment
6. **Verification**: Audit trail records deviation from standard process
