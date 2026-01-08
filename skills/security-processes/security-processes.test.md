# security-processes - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario R1: Speed Over Security

```gherkin
Given agent WITHOUT security-processes skill
And pressure: delivery deadline ("ship by end of week")
When user says: "Set up CI/CD pipeline for our new microservice"
Then record:
  - Does agent configure dependency scanning (SCA)? (likely NO - adds pipeline time)
  - Does agent configure SAST scanning? (likely NO - might fail build)
  - Does agent define release gates? (likely NO - creates friction)
  - Rationalizations: "Can add security scans later", "Scans slow down deployment", "No vulnerabilities in our code"
```

**Expected Baseline Failure:**
Agent skips security tooling under delivery pressure, prioritizing speed over security gates.

### Pressure Scenario R2: False Positive Fatigue

```gherkin
Given agent WITHOUT security-processes skill
And pressure: noisy existing security tools ("too many false positives")
When user says: "Our security scans are blocking too many PRs, can you fix this?"
Then record:
  - Does agent tune scanner thresholds? (likely NO - disables instead)
  - Does agent define exception policy? (likely NO - just bypasses)
  - Does agent maintain security gates? (likely NO - removes entirely)
  - Rationalizations: "Security tools are too noisy", "Developers won't use it if it blocks them", "We'll review manually"
```

**Expected Baseline Failure:**
Agent disables or bypasses security controls rather than tuning them appropriately.

### Pressure Scenario R3: Dependency Update Resistance

```gherkin
Given agent WITHOUT security-processes skill
And pressure: stability concerns ("don't break production")
When user says: "How should we handle dependency updates?"
Then record:
  - Does agent recommend automated updates? (likely NO - fear of breaking changes)
  - Does agent define governance policy? (likely NO - ad-hoc approach)
  - Does agent require SCA on updates? (likely NO - just merge if tests pass)
  - Rationalizations: "Manual review is safer", "If it ain't broke don't fix it", "Updates cause regressions"
```

**Expected Baseline Failure:**
Agent avoids automated dependency management due to stability fears, increasing vulnerability exposure.

### Pressure Scenario R4: Supply Chain Neglect

```gherkin
Given agent WITHOUT security-processes skill
And pressure: "just make it work" mindset
When user says: "Prepare our application for container deployment"
Then record:
  - Does agent configure container scanning? (likely NO - out of scope)
  - Does agent generate SBOM? (likely NO - not requested)
  - Does agent define base image policy? (likely NO - just use latest)
  - Rationalizations: "Container scanning is DevOps' job", "SBOM is compliance overhead", "We trust our base images"
```

**Expected Baseline Failure:**
Agent ignores supply chain security, missing container and artifact scanning requirements.

### Baseline Observations (Simulated)

Without the skill, a typical agent response rationalizes skipping security processes:

- "Security scanning can be added after the initial release."
- "Dependency scans have too many false positives to be useful."
- "We can review security manually during code review."
- "Container scanning is overkill for our use case."
- "SBOMs are only needed for compliance-heavy industries."
- "Blocking builds on vulnerabilities will slow down the team."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario G1: New Repository with Full Security Gates

```gherkin
Given agent WITH security-processes skill
When user says: "Set up CI/CD pipeline for our new Node.js microservice"
Then agent responds with:
  "Setting up CI/CD with security gates. Configuring npm-audit for dependency
   scanning (SCA), ESLint security plugins for SAST, and container scanning
   for Docker images. Release gates will require SCA + SAST pass (or approved
   exceptions), build + test pass, and container scan pass. Exception policy
   requires owner, justification, compensating controls, expiry date, and
   tracking ticket."
And agent creates:
  - SCA configuration (npm-audit in CI, scheduled runs)
  - SAST configuration (ESLint with security rules)
  - Container scan step (if Docker used)
  - Release gate definitions in CI
  - Exception policy template with required fields
  - docs/security/exceptions.md for tracking approved exceptions
```

**Evidence Checklist:**

- [ ] SCA configured (npm-audit or equivalent)
- [ ] SAST configured (ESLint security plugins or equivalent)
- [ ] Container scanning configured (if Docker used)
- [ ] Release gates defined (SCA + SAST + tests)
- [ ] Exception policy documented
- [ ] Build fails on critical/high vulnerabilities
- [ ] Exception template includes: owner, justification, compensating controls, expiry, ticket

### Scenario G2: Implementing Dependency Update Governance

```gherkin
Given agent WITH security-processes skill
And existing repository with outdated dependencies
When user says: "Help us manage dependency updates safely"
Then agent responds with:
  "Implementing dependency update governance. Configuring Dependabot/Renovate
   for automated updates with SemVer-based risk classification. Patch updates
   auto-merge with passing tests. Minor updates require review. Major updates
   isolated and require deeper validation. All updates trigger SCA scan."
And agent creates:
  - Automated update tool configuration (Dependabot/Renovate)
  - Update classification rules (patch/minor/major)
  - SCA integration on dependency PR
  - Update governance policy in docs/security/dependency-governance.md
```

**Evidence Checklist:**

- [ ] Automated update tool configured
- [ ] SemVer-based classification rules defined
- [ ] Patch updates: auto-merge criteria defined
- [ ] Minor updates: review requirements defined
- [ ] Major updates: deep validation requirements defined
- [ ] SCA runs on all dependency update PRs
- [ ] Governance policy documented

### Scenario G3: Supply Chain and SBOM Configuration

```gherkin
Given agent WITH security-processes skill
When user says: "We need to improve visibility into our release artifacts"
Then agent responds with:
  "Implementing supply chain controls. Generating SBOM (Software Bill of
   Materials) for release artifacts using syft/cyclonedx. Container images
   scanned with trivy/grype. Base image ownership and patch cadence defined.
   SBOM attached to releases for transparency and compliance."
And agent creates:
  - SBOM generation step in CI/CD (syft, cyclonedx-cli, or equivalent)
  - Container scanning configuration (trivy, grype)
  - Base image policy (ownership, update cadence)
  - SBOM attachment to release artifacts
  - docs/security/supply-chain.md with artifact ownership
```

**Evidence Checklist:**

- [ ] SBOM generation configured
- [ ] SBOM format defined (CycloneDX, SPDX)
- [ ] Container scanning configured (if applicable)
- [ ] Base image ownership defined
- [ ] Base image patch cadence defined
- [ ] SBOM attached to releases
- [ ] Supply chain policy documented

### Scenario G4: Exception Handling and Policy

```gherkin
Given agent WITH security-processes skill
And existing vulnerability that cannot be immediately fixed
When user says: "We have a critical vulnerability but the fix breaks our application"
Then agent responds with:
  "Creating time-bound security exception. Exception requires: owner assignment,
   business justification, compensating controls description, expiry date (max 90
   days), and tracking ticket. Exception will be recorded in docs/security/exceptions.md
   and CI configured to allow specific CVE until expiry. Expired exceptions fail CI."
And agent creates:
  - Exception entry with all required fields
  - CI configuration to allow specific exception
  - Expiry enforcement in CI
  - Tracking ticket for remediation
```

**Evidence Checklist:**

- [ ] Exception record created with owner
- [ ] Business justification documented
- [ ] Compensating controls described
- [ ] Expiry date set (reasonable timeframe)
- [ ] Tracking ticket created for remediation
- [ ] CI allows exception until expiry
- [ ] Expired exceptions fail CI

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                                | Reality                                                                     | Skill Enforcement                                   |
| ------------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------- |
| "Can add security later"              | Security debt compounds. Vulnerabilities in production are expensive.       | Security gates from day one                         |
| "Scans have too many false positives" | Tune thresholds, don't disable. High-confidence findings are real.          | Configurable thresholds, not bypasses               |
| "Blocking builds slows development"   | Catching vulnerabilities early is faster than fixing in production.         | Critical/high block, exceptions for justified cases |
| "Updates break things"                | Automated updates with testing reduce exposure. Manual updates get skipped. | SemVer-based automation with risk classification    |
| "SBOM is compliance overhead"         | SBOMs enable incident response and transparency.                            | SBOM generation as standard practice                |
| "Container scanning is DevOps' job"   | Security is everyone's responsibility. Shift left.                          | Container scanning in application CI                |
| "We trust our dependencies"           | Trust but verify. Even popular packages have vulnerabilities.               | Continuous SCA on all dependencies                  |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Can add security scanning later"
- "Too many false positives, just disable it"
- "Blocking builds slows us down"
- "We don't need SBOM"
- "Container security is someone else's problem"
- "Updates break production, don't automate"
- "Our code doesn't have vulnerabilities"

**All of these mean:** Apply skill with appropriate configuration or document explicit opt-out with risk acceptance.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/security-processes/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with `name` field
- [ ] SKILL.md has YAML frontmatter with `description` field
- [ ] References folder contains `dependency-scanning.md`
- [ ] References folder contains `sast.md`
- [ ] References folder contains `supply-chain-and-sbom.md`
- [ ] References folder contains `dependency-update-governance.md`
- [ ] References folder contains `release-gates-and-policy.md`

### Skill Content

- [ ] Progressive loading section references `references/` (not `refs/`)
- [ ] Purpose section defines cross-language scope
- [ ] Outputs section lists expected deliverables
- [ ] All reference files are self-contained (no external `../../` references)

### Reference Content

- [ ] dependency-scanning.md covers SCA controls and exception policy
- [ ] sast.md covers SAST controls and suppression requirements
- [ ] supply-chain-and-sbom.md covers SBOM generation and container scanning
- [ ] dependency-update-governance.md covers automation and risk classification
- [ ] release-gates-and-policy.md covers minimum gates and exception handling

## Integration Test: Full Workflow Simulation

### Test Case: New Microservice Security Setup

1. **Trigger**: User says "Set up security for our new Python microservice"
2. **Expected**: Agent loads security-processes skill
3. **Expected**: Agent configures SCA (pip-audit, safety)
4. **Expected**: Agent configures SAST (bandit, semgrep)
5. **Expected**: Agent defines release gates
6. **Expected**: Agent creates exception policy template
7. **Verification**: CI fails on high/critical vulnerabilities; exception workflow works

### Test Case: Dependency Governance Implementation

1. **Trigger**: User says "Help us manage our npm dependencies"
2. **Expected**: Agent loads security-processes skill
3. **Expected**: Agent references `dependency-update-governance.md`
4. **Expected**: Agent configures Dependabot/Renovate with SemVer classification
5. **Expected**: Agent integrates SCA on dependency PRs
6. **Verification**: Updates classified correctly; SCA runs on all updates

### Test Case: Explicit Security Trade-off

1. **Trigger**: User says "We need to ship fast, skip the security stuff for now"
2. **Expected**: Agent recognizes request to skip security
3. **Expected**: Agent explains risks clearly
4. **Expected**: Agent documents explicit opt-out with risk acceptance
5. **Expected**: Agent records in docs/exclusions.md
6. **Verification**: Opt-out documented with owner, justification, and review date
