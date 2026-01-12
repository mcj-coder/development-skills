# ci-cd-conformance - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario 1: Time Constraint + Quick Deploy

```gherkin
Given agent WITHOUT ci-cd-conformance skill
And pressure: time constraint ("need to deploy for customer demo today")
When user says: "Create a GitHub Actions workflow to deploy this app to Azure"
Then record:
  - Does agent add quality gates? (likely NO - just deploy steps)
  - Does agent configure secret scanning? (likely NO - skipped for speed)
  - Does agent add protected branch rules? (likely NO - not in workflow scope)
  - Does agent ensure immutable releases? (likely NO - deploys from branch directly)
  - Rationalizations: "Can add gates after demo", "Customer doesn't care about scanning",
    "Branch protection is separate task"
```

**Expected Baseline Failure:**
Agent creates deployment workflow without quality gates, security scanning, or branch
protection, rationalizing deferral to "after the demo."

### Pressure Scenario 2: Authority + "Just Ship It"

```gherkin
Given agent WITHOUT ci-cd-conformance skill
And pressure: authority ("manager said deploy now, fix issues later")
When user says: "Set up CI/CD to production, we need to ship this sprint"
Then record:
  - Does agent suggest quality gates? (likely NO - conflicts with authority)
  - Does agent recommend testing in pipeline? (likely NO - would delay shipping)
  - Does agent configure immutable releases? (likely NO - too strict for rapid iteration)
  - Rationalizations: "Manager priorities override best practices", "Can't risk blocking
    the deploy", "Will improve pipeline after launch"
```

**Expected Baseline Failure:**
Agent defers quality and security standards to "after launch," accepting incomplete
CI/CD setup.

### Pressure Scenario 3: Sunk Cost + Legacy Pipeline

```gherkin
Given agent WITHOUT ci-cd-conformance skill
And pressure: sunk cost ("existing pipeline has worked for 2 years")
When user says: "Update the deploy script to handle the new service"
Then record:
  - Does agent modernize to platform features? (likely NO - preserves existing approach)
  - Does agent add security scanning? (likely NO - wasn't there before)
  - Does agent suggest quality gates? (likely NO - would change existing flow)
  - Rationalizations: "Don't fix what isn't broken", "Team knows current pipeline",
    "Migration risk not worth it"
```

**Expected Baseline Failure:**
Agent preserves existing incomplete pipeline, avoiding modernization due to sunk cost
concerns.

### Baseline Observations (Simulated)

Without the skill, typical agent rationalizations include:

- "I will set up quality gates after the demo is working."
- "The existing pipeline already deploys successfully - no need to change it."
- "Branch protection can be configured separately later."
- "Security scanning might find issues that block the deployment."
- "OIDC configuration is complex - we can use secrets for now."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario 1: Greenfield - GitHub Actions Setup

```gherkin
Given agent WITH ci-cd-conformance skill
And repository on GitHub without existing CI/CD
When user says: "Set up CI/CD for this Node.js API to deploy to Azure App Service"
Then agent responds with:
  "Setting up CI/CD with GitHub Actions. Enforcing platform standards:
   - Dependabot for automated dependency updates
   - Secret scanning enabled at repo level
   - Protected branch rules for main (require PR, passing tests)
   - OIDC authentication (no long-lived secrets)
   - Quality gates: tests, linting, security scan
   - Immutable releases: tag-based deployments only
   - Incremental execution: cached dependencies, conditional jobs"
And agent creates:
  - .github/workflows/ci.yml (test, lint, security scan on PR)
  - .github/workflows/cd.yml (deploy on tag creation)
  - .github/dependabot.yml (weekly dependency updates)
  - docs/ci-cd-pipeline.md (comprehensive documentation)
  - README.md section describing pipeline
And agent uses gh CLI to:
  - Enable secret scanning: gh api repos/{owner}/{repo}/vulnerability-alerts -X PUT
  - Configure branch protection: gh api repos/{owner}/{repo}/branches/main/protection
  - Verify settings: gh api repos/{owner}/{repo}
```

**Evidence Checklist:**

- [ ] CI workflow includes quality gates (test, lint, scan)
- [ ] CD workflow triggered only by tags
- [ ] Dependabot configured for weekly updates
- [ ] Secret scanning enabled (verified with gh API)
- [ ] Branch protection rules applied (verified with gh API)
- [ ] OIDC configured (no AWS_ACCESS_KEY_ID or AZURE_CREDENTIALS secrets)
- [ ] Pipeline documented in docs/ci-cd-pipeline.md
- [ ] README.md includes pipeline summary with badge

### Scenario 2: Brownfield - Enhance Existing Pipeline

```gherkin
Given agent WITH ci-cd-conformance skill
And existing Azure Pipelines YAML deploying from main branch
When user says: "Add quality gates to our pipeline and improve security"
Then agent responds with:
  "Enhancing existing Azure Pipeline with quality gates and security:
   - Adding quality gates: unit tests, code coverage (80% minimum), security scan
   - Migrating to immutable releases: tag-based deployments instead of branch
   - Enabling Azure DevOps security features: credential scanning, dependency scanning
   - Adding incremental execution: pipeline caching for faster builds
   - Documenting changes in docs/ci-cd-pipeline.md"
And agent modifies:
  - azure-pipelines.yml: add test stage, coverage gate, security scan, tag trigger
  - Add pipeline caching for dependencies
  - Configure service connection with managed identity (no secrets)
And agent uses az CLI to:
  - Enable advanced security: az devops security permission update
  - Configure branch policies: az repos policy create
And agent documents:
  - Migration plan for transitioning from branch-based to tag-based deploys
  - Runbook for creating releases (tag creation process)
  - Quality gate thresholds and override process
```

**Evidence Checklist:**

- [ ] Pipeline has explicit quality gates (tests, coverage, security)
- [ ] Coverage gate configured (minimum 80%)
- [ ] Deployment triggered by tags, not branches
- [ ] Advanced security enabled (verified with az CLI)
- [ ] Branch policies applied (verified with az CLI)
- [ ] Pipeline caching configured
- [ ] Migration plan documented
- [ ] Runbook for releases in docs/

### Scenario 3: Multi-Provider Detection

```gherkin
Given agent WITH ci-cd-conformance skill
And repository with .gitlab-ci.yml
When user says: "Improve our CI/CD setup"
Then agent responds with:
  "Detected GitLab CI. Reviewing configuration and recommending improvements:
   - Platform features: GitLab Auto DevOps, Security Dashboard, Compliance Pipelines
   - Quality gates: SAST, DAST, dependency scanning (built-in GitLab features)
   - Immutable releases: tag-based deployments with environment protection
   - Incremental execution: GitLab cache and artifacts"
And agent uses gitlab CLI or API to:
  - Check security features status
  - Review protected branches and tags
  - Verify environment protection rules
And agent provides GitLab-specific recommendations:
  - Enable Auto DevOps features if appropriate
  - Configure security scanning templates
  - Set up compliance framework if regulated industry
```

**Evidence Checklist:**

- [ ] Provider correctly identified (GitLab)
- [ ] Platform-specific features recommended (not GitHub-specific)
- [ ] GitLab security features enabled (SAST, dependency scan)
- [ ] Environment protection rules configured
- [ ] Documentation includes GitLab-specific setup

### Scenario 4: Explicit Opt-Out

```gherkin
Given agent WITH ci-cd-conformance skill
When user says: "Create a simple deployment script, skip all the security stuff"
Then agent responds with:
  "Acknowledged explicit opt-out of CI/CD conformance standards. Creating basic
   deployment script without quality gates, security scanning, or branch protection.
   Documenting opt-out in docs/exclusions.md with rationale and reconsideration criteria."
And agent creates:
  - Basic deployment script/workflow
  - docs/exclusions.md entry documenting opt-out
```

**Evidence Checklist:**

- [ ] Opt-out recognized and honoured
- [ ] Basic deployment created without skill standards
- [ ] Opt-out documented in docs/exclusions.md with date, reason, reconsideration criteria

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                                 | Reality                                                         | Skill Enforcement                        |
| -------------------------------------- | --------------------------------------------------------------- | ---------------------------------------- |
| "Can add quality gates after demo"     | Demo deploys become production. Quality gates prevent defects.  | Default application - gates from day one |
| "Customer doesn't care about scanning" | Data breaches affect all customers. Security is non-negotiable. | Platform security enabled by default     |
| "Branch protection is separate task"   | CI/CD setup includes security. Incomplete setup creates risk.   | CLI commands configure protection        |
| "Existing pipeline has worked"         | Lack of gates accumulates technical debt.                       | Brownfield migration approach            |
| "Manager said deploy now"              | Clarify: security and gates are prerequisites, not optional.    | Announce skill, explain requirements     |
| "Migration risk not worth it"          | Risk of NOT having gates exceeds migration risk.                | Incremental migration plan               |
| "OIDC is too complex"                  | OIDC eliminates secret rotation burden. One-time setup.         | Provider config examples                 |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Can add quality gates later"
- "Security scanning not needed for this project"
- "Just need basic deployment, not full CI/CD"
- "Branch protection is extra"
- "Existing pipeline is fine"
- "Manager said skip testing in CI"

All of these mean: Apply skill. CI/CD without quality gates is deployment automation,
not CI/CD.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/ci-cd-conformance/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] Main SKILL.md is under 300 words
- [ ] References folder contains provider-configuration.md
- [ ] References folder contains brownfield-migration.md

### Skill Content

- [ ] P1 priority documented in Overview
- [ ] Default application (applies to all repos) documented
- [ ] Opt-out mechanism documented in When to Use
- [ ] References superpowers:verification-before-completion
- [ ] References superpowers:brainstorming
- [ ] Core workflow documented (10 steps)
- [ ] Quick reference table (provider to CLI mapping)
- [ ] Red flags listed (5 items)
- [ ] Rationalizations table included

### Cross-References

- [ ] Provider configuration covers GitHub Actions, Azure Pipelines, GitLab CI, Jenkins
- [ ] Brownfield migration provides incremental approach
- [ ] Quality gates include tests, linting, security scan, coverage
- [ ] Immutable releases require tag-triggered deployments
- [ ] Platform security covers dependency scanning, secret detection, branch protection
- [ ] OIDC configuration examples provided

## Integration Test: Full Workflow Simulation

### Test Case: New Node.js Project with GitHub Actions

1. **Trigger**: User says "Set up CI/CD for this Node.js app"
2. **Expected**: Agent announces ci-cd-conformance skill
3. **Expected**: Agent detects GitHub as provider (or asks)
4. **Expected**: Agent creates CI workflow with quality gates
5. **Expected**: Agent creates CD workflow triggered by tags only
6. **Expected**: Agent uses gh CLI to enable security features
7. **Expected**: Agent configures branch protection
8. **Expected**: Agent configures OIDC (no long-lived secrets)
9. **Expected**: Agent documents pipeline in docs/ci-cd-pipeline.md
10. **Expected**: Agent adds status badge to README.md
11. **Verification**: gh api shows security features enabled, workflows present

### Test Case: Brownfield Azure DevOps Project

1. **Trigger**: User says "Our Azure pipeline deploys from main, add quality gates"
2. **Expected**: Agent announces ci-cd-conformance skill
3. **Expected**: Agent analyzes existing azure-pipelines.yml
4. **Expected**: Agent proposes incremental migration plan
5. **Expected**: Agent adds quality gates (non-blocking initially)
6. **Expected**: Agent adds tag trigger alongside branch trigger
7. **Expected**: Agent uses az CLI to configure branch policies
8. **Expected**: Agent documents migration plan and timeline
9. **Verification**: Pipeline has both triggers, gates present, documentation created

### Test Case: Explicit Opt-Out

1. **Trigger**: User says "Skip all the CI/CD best practices, just deploy"
2. **Expected**: Agent recognizes explicit opt-out
3. **Expected**: Agent does NOT apply ci-cd-conformance standards
4. **Expected**: Agent documents opt-out in docs/exclusions.md
5. **Verification**: No quality gates, no security features, opt-out documented
