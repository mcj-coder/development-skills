# static-analysis-security - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario R1: Speed Over Security Analysis

```gherkin
Given agent WITHOUT static-analysis-security skill
And pressure: delivery deadline ("ship by end of sprint")
When user says: "Set up code review process for our application"
Then record:
  - Does agent configure SAST tools? (likely NO - adds build time)
  - Does agent integrate security linting? (likely NO - might block PRs)
  - Does agent define vulnerability thresholds? (likely NO - creates friction)
  - Rationalizations: "Manual code review catches security issues", "SAST has too many false positives", "We can add security scanning later"
```

**Expected Baseline Failure:**
Agent relies on manual code review without automated security analysis, missing vulnerabilities that humans overlook.

### Pressure Scenario R2: False Positive Avoidance

```gherkin
Given agent WITHOUT static-analysis-security skill
And pressure: developer complaints ("SAST tools are noisy")
When user says: "Our security scans report too many issues, what should we do?"
Then record:
  - Does agent tune scanner rules? (likely NO - disables scanners instead)
  - Does agent configure severity thresholds? (likely NO - removes all gates)
  - Does agent establish suppression policy? (likely NO - ad-hoc ignores)
  - Rationalizations: "Security tools slow down development", "Most findings are false positives", "We'll handle security in production"
```

**Expected Baseline Failure:**
Agent disables or removes security analysis tools rather than properly configuring them.

### Pressure Scenario R3: "Not Our Code" Excuse

```gherkin
Given agent WITHOUT static-analysis-security skill
And pressure: scope limitation mindset
When user says: "How do we ensure our code is secure?"
Then record:
  - Does agent scan first-party code? (likely PARTIAL - may run basic linting)
  - Does agent scan dependencies? (likely NO - "not our code")
  - Does agent scan configuration? (likely NO - "not code")
  - Rationalizations: "We trust our dependencies", "Config isn't a security concern", "Only scan what we write"
```

**Expected Baseline Failure:**
Agent focuses only on first-party code, missing vulnerabilities in dependencies and misconfiguration.

### Pressure Scenario R4: Tool Selection Paralysis

```gherkin
Given agent WITHOUT static-analysis-security skill
And pressure: analysis paralysis
When user says: "We need to add security scanning to our CI pipeline"
Then record:
  - Does agent select appropriate SAST tools? (likely RANDOM - picks first Google result)
  - Does agent consider language coverage? (likely NO - one-size-fits-all)
  - Does agent configure integration properly? (likely PARTIAL - copy-paste config)
  - Rationalizations: "Any scanner is better than none", "We'll optimise later", "Default config is fine"
```

**Expected Baseline Failure:**
Agent selects inappropriate tools or misconfigures them, leading to gaps in coverage or excessive noise.

### Baseline Observations (Simulated)

Without the skill, a typical agent response rationalizes skipping or misconfiguring security analysis:

- "Manual code review is sufficient for security."
- "SAST tools have too many false positives to be useful."
- "We only need to scan our own code, not dependencies."
- "Security scanning slows down the CI pipeline too much."
- "Any security tool is better than none - just pick one."
- "We can configure the scanner properly after release."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario G1: New Project SAST Setup

```gherkin
Given agent WITH static-analysis-security skill
When user says: "Set up security scanning for our new TypeScript project"
Then agent responds with:
  "Setting up static analysis for security. Configuring ESLint with
   security plugins (eslint-plugin-security, @typescript-eslint), Semgrep
   with security rulesets, and npm-audit for dependency scanning. Build
   will fail on high/critical findings. Suppressions require justification
   and tracking ticket."
And agent creates:
  - ESLint configuration with security rules enabled
  - Semgrep configuration with p/security-audit and p/typescript rulesets
  - CI pipeline step for SAST execution
  - Suppression policy template
  - docs/security/sast-configuration.md documenting tool choices
```

**Evidence Checklist:**

- [ ] ESLint security plugin configured
- [ ] Semgrep or equivalent SAST tool configured
- [ ] Language-appropriate rulesets selected
- [ ] CI integration configured
- [ ] Build fails on high/critical severity
- [ ] Suppression policy documented
- [ ] Tool selection rationale documented

### Scenario G2: Multi-Language SAST Configuration

```gherkin
Given agent WITH static-analysis-security skill
And project with Python backend and TypeScript frontend
When user says: "We need security scanning across our full stack"
Then agent responds with:
  "Configuring multi-language SAST. Python: Bandit for SAST, Ruff with
   security rules, Safety for dependency scanning. TypeScript: ESLint
   security plugins, Semgrep. Shared: Semgrep for cross-language patterns,
   Gitleaks for secrets detection. Unified reporting in SARIF format."
And agent creates:
  - Python SAST configuration (Bandit, Ruff security rules)
  - TypeScript SAST configuration (ESLint security, Semgrep)
  - Secrets scanning configuration (Gitleaks or equivalent)
  - Unified CI pipeline with all scanners
  - SARIF output for IDE integration
  - Language-specific suppression configuration
```

**Evidence Checklist:**

- [ ] Python SAST tool configured (Bandit)
- [ ] Python linter with security rules (Ruff)
- [ ] TypeScript SAST configured (ESLint + Semgrep)
- [ ] Secrets detection configured
- [ ] SARIF output format enabled
- [ ] Per-language severity thresholds defined
- [ ] Unified reporting configured

### Scenario G3: Secrets Detection Setup

```gherkin
Given agent WITH static-analysis-security skill
When user says: "We need to prevent secrets from being committed"
Then agent responds with:
  "Implementing secrets detection. Pre-commit hook with Gitleaks for
   real-time detection. CI pipeline scan with TruffleHog for deep history
   analysis. Custom patterns for internal secret formats. Alert on detection
   with remediation guidance."
And agent creates:
  - Pre-commit hook configuration for Gitleaks
  - CI pipeline step for secrets scanning
  - Custom pattern configuration for organisation-specific secrets
  - Remediation runbook for detected secrets
  - docs/security/secrets-detection.md with configuration details
```

**Evidence Checklist:**

- [ ] Pre-commit secrets scanning configured
- [ ] CI secrets scanning configured
- [ ] Custom patterns defined (if applicable)
- [ ] Historical scan capability documented
- [ ] Remediation process documented
- [ ] Alert mechanism configured

### Scenario G4: Vulnerability Threshold Configuration

```gherkin
Given agent WITH static-analysis-security skill
And existing project with legacy vulnerabilities
When user says: "How do we integrate SAST without blocking all our builds?"
Then agent responds with:
  "Implementing graduated SAST rollout. Phase 1: Scan and report only
   (no blocking). Phase 2: Block on critical findings only. Phase 3: Block
   on high and critical. Existing findings baselined with time-bound
   exceptions. New findings must meet threshold immediately."
And agent creates:
  - Baseline configuration capturing existing findings
  - Graduated threshold configuration
  - Exception policy with expiry dates
  - Migration plan document
  - Metrics tracking for vulnerability reduction
```

**Evidence Checklist:**

- [ ] Baseline of existing findings documented
- [ ] Graduated rollout phases defined
- [ ] Exception policy with time bounds
- [ ] New vs existing finding differentiation
- [ ] Metrics for tracking progress
- [ ] Migration timeline documented

### Scenario G5: IDE Integration for Shift-Left

```gherkin
Given agent WITH static-analysis-security skill
When user says: "Developers want to catch security issues before committing"
Then agent responds with:
  "Enabling shift-left security with IDE integration. VSCode: ESLint
   extension with security rules, Semgrep extension for real-time scanning.
   Pre-commit hooks for immediate feedback. Same rules as CI for consistency.
   Developer documentation for setup."
And agent creates:
  - VSCode settings.json recommendations
  - .vscode/extensions.json with security extensions
  - Pre-commit hook configuration
  - Developer setup guide
  - Rule consistency verification between local and CI
```

**Evidence Checklist:**

- [ ] IDE extension recommendations documented
- [ ] Pre-commit hooks configured
- [ ] Same rules in IDE and CI
- [ ] Developer setup documentation
- [ ] Verification that local and CI rules match

## REFACTOR Phase - Rationalisation Closing

### Rationalisations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                                  | Reality                                                                      | Skill Enforcement                                   |
| --------------------------------------- | ---------------------------------------------------------------------------- | --------------------------------------------------- |
| "Manual review catches security issues" | Humans miss patterns that tools catch consistently. Both are needed.         | Automated SAST as baseline, review for logic flaws  |
| "SAST has too many false positives"     | Tune rules and thresholds, don't disable. High-confidence findings are real. | Configurable severity thresholds with justification |
| "We only need to scan our code"         | Dependencies and config are attack surface too.                              | Full-stack scanning including dependencies          |
| "Any scanner is better than none"       | Wrong tool gives false confidence. Language-appropriate tools required.      | Tool selection guidance per language                |
| "Security scanning slows CI"            | Parallel execution and caching minimise impact. Security is non-negotiable.  | Performance optimisation guidance                   |
| "We'll configure properly later"        | Technical debt compounds. Proper config from start.                          | Configuration templates and validation              |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Manual code review is enough for security"
- "Too many false positives, disable the scanner"
- "We only scan our own code"
- "Any security tool will do"
- "We'll tune the scanner after release"
- "Security scanning is too slow for CI"
- "Just suppress all the findings"

**All of these mean:** Apply skill with appropriate configuration or document explicit opt-out with risk acceptance.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/static-analysis-security/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with `name` field
- [ ] SKILL.md has YAML frontmatter with `description` field starting with "Use when"
- [ ] Test file exists at `skills/static-analysis-security/static-analysis-security.test.md`
- [ ] References folder exists at `skills/static-analysis-security/references/`

### Skill Content

- [ ] Purpose section defines SAST and security linting scope
- [ ] Tool selection guidance provided per language
- [ ] Severity threshold configuration documented
- [ ] Suppression policy guidance included
- [ ] IDE integration guidance included
- [ ] CI integration guidance included

### Reference Content

- [ ] Tool comparison reference covers major SAST tools
- [ ] Language-specific configuration examples provided
- [ ] Secrets detection guidance included
- [ ] Suppression policy template provided

## Integration Test: Full Workflow Simulation

### Test Case: New TypeScript Project Setup

1. **Trigger**: User says "Set up security scanning for our new Express.js API"
2. **Expected**: Agent loads static-analysis-security skill
3. **Expected**: Agent configures ESLint with security plugins
4. **Expected**: Agent configures Semgrep with appropriate rulesets
5. **Expected**: Agent configures npm-audit for dependencies
6. **Expected**: Agent sets up CI pipeline integration
7. **Verification**: CI fails on high/critical findings; SARIF output available

### Test Case: Brownfield Integration

1. **Trigger**: User says "Add SAST to our existing Python project without breaking builds"
2. **Expected**: Agent loads static-analysis-security skill
3. **Expected**: Agent runs baseline scan and documents existing findings
4. **Expected**: Agent configures graduated rollout (report-only first)
5. **Expected**: Agent creates exception policy for existing findings
6. **Verification**: Existing findings don't block; new critical findings do block

### Test Case: Secrets Prevention

1. **Trigger**: User says "We accidentally committed an API key, prevent this happening again"
2. **Expected**: Agent loads static-analysis-security skill
3. **Expected**: Agent configures Gitleaks pre-commit hook
4. **Expected**: Agent configures CI secrets scanning
5. **Expected**: Agent provides remediation guidance for the committed secret
6. **Verification**: Pre-commit blocks commits with secrets; CI scans history
