# documentation-as-code - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario 1: Time Constraint + Quick Doc Update

```gherkin
Given agent WITHOUT documentation-as-code skill
And pressure: time constraint ("need to document API before demo")
When user says: "Add README documentation for the new endpoints"
Then record:
  - Does agent validate spelling? (likely NO - just writes content)
  - Does agent check Markdown formatting? (likely NO - content over format)
  - Does agent verify links work? (likely NO - no validation step)
  - Does agent enforce structure? (likely NO - free-form documentation)
  - Rationalizations: "Content matters, not formatting", "Can fix typos later",
    "Demo doesn't care about perfect docs"
```

**Expected Baseline Failure:**
Agent writes documentation without validation, prioritizing speed over quality.

### Pressure Scenario 2: Authority + "Just Document It"

```gherkin
Given agent WITHOUT documentation-as-code skill
And pressure: authority ("manager said just write down what it does")
When user says: "Document the deployment process"
Then record:
  - Does agent apply linting rules? (likely NO - just descriptive text)
  - Does agent enforce completeness? (likely NO - minimal documentation)
  - Does agent add to CI validation? (likely NO - not mentioned)
  - Rationalizations: "Manager wants quick doc", "Better than no documentation",
    "Can improve later"
```

**Expected Baseline Failure:**
Agent produces minimal documentation without quality checks.

### Pressure Scenario 3: Sunk Cost + Existing Docs

```gherkin
Given agent WITHOUT documentation-as-code skill
And pressure: sunk cost ("existing docs folder with 50 files")
When user says: "Add new ADR for database migration strategy"
Then record:
  - Does agent validate existing docs consistency? (likely NO - just adds new file)
  - Does agent check spelling in new ADR? (likely NO - relies on user)
  - Does agent enforce ADR template? (likely NO - free-form structure)
  - Rationalizations: "Existing docs aren't validated", "Just need content added",
    "Template is a guideline"
```

**Expected Baseline Failure:**
Agent adds new documentation without template enforcement or validation.

### Baseline Observations (Simulated)

Without the skill, typical agent responses:

- "I'll create the documentation now." (No mention of validation)
- "Here's the README content." (No spell check)
- "Added the ADR document." (No template enforcement)
- "Documentation complete." (No CI integration)

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario 1: Creating New Documentation with Full Validation

```gherkin
Given agent WITH documentation-as-code skill
When user says: "Create README documentation for the authentication API"
Then agent responds with:
  "Creating authentication API documentation with validation:
   - Markdown linting: markdownlint for consistent formatting
   - Spell checking: cSpell with technical dictionary
   - Link validation: Check all internal/external links
   - Structure: API doc template (overview, endpoints, examples, errors)
   - CI integration: Add docs validation to CI pipeline

   Running validation:
   - markdownlint docs/ (checking formatting)
   - cspell 'docs/**/*.md' (checking spelling)
   - markdown-link-check docs/ (checking links)

   Validation must pass before completion."
And agent creates documentation with proper structure
And agent configures linting/spell checking
And agent adds CI validation
And agent runs validation and reports results
```

**Evidence Checklist:**

- [ ] Documentation follows template structure
- [ ] markdownlint configuration present
- [ ] cSpell configuration with technical dictionary
- [ ] All validation passes (lint, spell, links)
- [ ] CI workflow configured for docs validation
- [ ] Validation runs in PR checks

### Scenario 2: Adding ADR with Template Enforcement

```gherkin
Given agent WITH documentation-as-code skill
And existing docs/architecture/decisions/ directory
When user says: "Document the decision to use PostgreSQL instead of MongoDB"
Then agent responds with:
  "Creating ADR for database selection with template enforcement:
   - Template: ADR standard format (Status, Context, Decision, Consequences)
   - Numbering: Next ADR number determined from existing files
   - Validation: Spell check, lint, link verification
   - Review: ADR requires tech lead approval

   Creating docs/architecture/decisions/ADR-005-postgresql-database.md:
   - Status: Proposed (pending review)
   - Context: Database requirements for scale and consistency
   - Decision: PostgreSQL chosen for ACID guarantees
   - Consequences: Benefits and tradeoffs documented

   Running validation before completion."
And agent creates ADR following template
And agent updates ADR index if present
And agent validates structure and content
```

**Evidence Checklist:**

- [ ] ADR follows standard template
- [ ] Sequential numbering maintained
- [ ] All required sections present (Status, Context, Decision, Consequences)
- [ ] Validation passes (lint, spell)
- [ ] ADR index updated if exists
- [ ] Review process noted

### Scenario 3: Brownfield - Adding Validation to Existing Docs

```gherkin
Given agent WITH documentation-as-code skill
And existing docs/ folder without validation
When user says: "Set up documentation validation for our existing docs"
Then agent responds with:
  "Adding documentation-as-code validation to existing docs:
   - Baseline: Running validation on current docs to identify issues
   - Configuration: Setting up linting, spell check, link validation
   - CI Integration: Adding docs validation workflow
   - Incremental: Allowing existing issues, preventing new ones

   Running baseline:
   - markdownlint docs/ (found 23 formatting issues)
   - cspell 'docs/**/*.md' (found 47 spelling issues)
   - markdown-link-check docs/ (found 8 broken links)

   Strategy:
   - Create .markdownlintignore (existing issues suppressed temporarily)
   - Create .cspell.json with project-specific terms
   - Document baseline issues in docs/validation-baseline.md
   - Configure CI to enforce rules for NEW/MODIFIED docs only
   - Create cleanup plan in docs/validation-cleanup-plan.md

   This prevents regression while allowing incremental improvement."
And agent creates configuration files
And agent suppresses existing issues (documented)
And agent adds CI validation (strict for new changes)
And agent provides cleanup plan
```

**Evidence Checklist:**

- [ ] Baseline validation run and documented
- [ ] Configuration files created (markdownlint, cspell)
- [ ] Existing issues suppressed with ignore files
- [ ] CI validates new/modified docs strictly
- [ ] Cleanup plan documented with priorities
- [ ] Technical dictionary established

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                            | Reality                                             | Skill Enforcement                   |
| --------------------------------- | --------------------------------------------------- | ----------------------------------- |
| "Content matters, not formatting" | Poor formatting reduces readability and trust       | Lint all documentation              |
| "Can fix typos later"             | Typos undermine credibility; spell check is instant | Spell check before completion       |
| "Demo doesn't care about perfect" | Demo docs become production docs                    | Same standards always               |
| "Better than no documentation"    | Low-quality docs can mislead worse than none        | Quality or don't ship               |
| "Existing docs aren't validated"  | Legacy doesn't justify new bad practices            | Brownfield baseline approach        |
| "Template is a guideline"         | Templates ensure consistency and completeness       | Template enforcement for ADRs       |
| "This is different because..."    | All documentation benefits from validation          | No exceptions without documentation |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Just need content down"
- "Can format later"
- "Spelling doesn't matter for internal docs"
- "Template is optional"
- "Existing docs aren't validated"
- "Manager just wants something written"

**All of these mean:** Apply skill, validate documentation quality, or document explicit
exception in baseline.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/documentation-as-code/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] Main SKILL.md is under 300 words
- [ ] References folder contains markdown-linting.md
- [ ] References folder contains spell-checking.md
- [ ] References folder contains templates.md
- [ ] References folder contains validation-configuration.md
- [ ] References folder contains baseline-strategy.md

### Skill Content

- [ ] Priority (P1 Quality & Correctness) documented in Overview
- [ ] References superpowers:verification-before-completion
- [ ] Cross-references automated-standards-enforcement
- [ ] Core workflow documented (6 steps)
- [ ] Quick reference table (check to tool mapping)
- [ ] Brownfield approach documented (5 steps)
- [ ] Red flags listed (4+ items)
- [ ] Rationalizations table present

### Cross-References

- [ ] Markdown linting covers configuration and rules
- [ ] Spell checking covers dictionary management
- [ ] Templates include ADR, API docs, runbooks
- [ ] Validation configuration covers CI workflow
- [ ] Baseline strategy covers brownfield approach

## Integration Test: Full Workflow Simulation

### Test Case: New API Documentation

1. **Trigger**: User says "Create documentation for the user management API"
2. **Expected**: Agent announces documentation-as-code skill
3. **Expected**: Agent creates documentation with template structure
4. **Expected**: Agent configures markdownlint and cspell
5. **Expected**: Agent runs validation before marking complete
6. **Expected**: Agent adds CI workflow for documentation
7. **Verification**: Run `npm run validate:docs` - should pass

### Test Case: Brownfield Documentation

1. **Trigger**: User says "Add validation to our existing documentation"
2. **Expected**: Agent announces documentation-as-code skill
3. **Expected**: Agent runs baseline to identify existing violations
4. **Expected**: Agent documents violations in baseline file
5. **Expected**: Agent configures CI for new changes only
6. **Expected**: Agent provides cleanup plan
7. **Verification**: New docs pass validation; existing issues documented

### Test Case: ADR Creation

1. **Trigger**: User says "Document our decision to use event sourcing"
2. **Expected**: Agent announces documentation-as-code skill
3. **Expected**: Agent uses ADR template
4. **Expected**: Agent includes all required sections
5. **Expected**: Agent validates spelling and formatting
6. **Verification**: ADR follows template; validation passes
