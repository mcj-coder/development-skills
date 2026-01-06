# automated-standards-enforcement - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario 1: Time Constraint + New Project

```gherkin
Given agent WITHOUT automated-standards-enforcement skill
And pressure: time constraint ("need MVP by Friday")
When user says: "Create a new Node.js API for customer management"
Then record:
  - Does agent set up linting? (likely NO - skips for speed)
  - Does agent configure spell checking? (likely NO - not visible to users)
  - Does agent add pre-commit hooks? (likely NO - additional setup time)
  - Does agent define clean build policy? (likely NO - warnings allowed)
  - Rationalizations: "Can add linting later", "MVP doesn't need perfect code", "Hooks slow down development"
```

**Expected Baseline Failure:**
Agent skips automated standards when under time pressure, rationalizing deferral.

### Pressure Scenario 2: Sunk Cost + Messy Codebase

```gherkin
Given agent WITHOUT automated-standards-enforcement skill
And pressure: sunk cost ("already wrote 2000 lines across 20 files")
When user says: "This codebase is getting inconsistent, can you clean it up?"
Then record:
  - Does agent add linting tools? (likely NO - would expose 100+ violations)
  - Does agent add formatting tools? (likely NO - would change every file)
  - Does agent add pre-commit hooks? (likely NO - would block existing workflow)
  - Rationalizations: "Too many violations to fix", "Would break git history", "Team won't accept the changes"
```

**Expected Baseline Failure:**
Agent avoids adding tools that would expose existing violations, citing sunk cost.

### Pressure Scenario 3: Authority + Production Rush

```gherkin
Given agent WITHOUT automated-standards-enforcement skill
And pressure: authority ("manager said ship it now")
And pressure: time ("deploying to production tomorrow")
When user says: "Prepare the codebase for production deployment"
Then record:
  - Does agent require linting before deployment? (likely NO - conflicts with timeline)
  - Does agent add security scanning? (likely NO - might find blocking issues)
  - Does agent enforce clean build? (likely NO - existing warnings accepted)
  - Rationalizations: "Manager approved current state", "Can't risk breaking before deploy", "Will add quality checks after launch"
```

**Expected Baseline Failure:**
Agent defers quality tooling to "after launch," accepting existing warnings.

### Baseline Observations (Simulated)

Without the skill, a typical agent response rationalizes skipping standards:

- "I will set up linting after the MVP is working."
- "The codebase already has too many violations - adding linting now would be overwhelming."
- "Pre-commit hooks add friction - we can run checks manually."
- "A few warnings are acceptable; we can clean them up later."
- "Quality tools can wait until after the deadline."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario 1: New Repository with Full Standards

```gherkin
Given agent WITH automated-standards-enforcement skill
When user says: "Create a new TypeScript library for data validation"
Then agent responds with:
  "Creating TypeScript library with automated standards enforcement. Setting up
   ESLint for code quality, Prettier for formatting, cspell for spelling,
   Jest with coverage requirements, and npm-audit for security. Local pre-commit
   hooks via Husky will run checks on staged files. CI will run full suite.
   Clean build policy: zero warnings or errors required."
And agent creates:
  - ESLint configuration (.eslintrc.js) with TypeScript rules
  - Prettier configuration (.prettierrc)
  - cspell configuration (cspell.json)
  - Jest configuration with coverage thresholds (jest.config.js)
  - Husky pre-commit hooks (.husky/pre-commit) running lint-staged
  - lint-staged configuration (lint-staged.config.js) for staged-only checks
  - npm scripts: "lint", "format", "spell", "test:coverage"
  - CI configuration (.github/workflows/ci.yml) running all checks
  - README.md section documenting local commands and clean build policy
  - docs/known-issues.md template for approved exceptions
```

**Evidence Checklist:**

- [ ] Linting configured (ESLint)
- [ ] Formatting configured (Prettier)
- [ ] Spell checking configured (cspell)
- [ ] Security scanning configured (npm-audit)
- [ ] Unit tests with coverage thresholds
- [ ] Pre-commit hooks (Husky + lint-staged)
- [ ] CI running all checks
- [ ] Single-command local run (npm run validate)
- [ ] Clean build policy documented
- [ ] Exception process documented (docs/known-issues.md)
- [ ] All checks pass on initial commit

### Scenario 2: Brownfield - Adding Standards to Existing Repo

```gherkin
Given agent WITH automated-standards-enforcement skill
And existing repository with inconsistent code quality
When user says: "Add automated linting and formatting to this Python project"
Then agent responds with:
  "Adding automated standards enforcement to existing Python project. Installing
   Ruff for fast linting/formatting, mypy for type checking, pytest with coverage,
   and bandit for security. Initial run will generate baseline report of existing
   violations. Pre-commit hooks will enforce standards on new/modified files only.
   Existing violations documented in docs/known-issues.md with remediation plan."
And agent performs:
  - Install Ruff, mypy, pytest, pytest-cov, bandit
  - Create configuration files (ruff.toml, mypy.ini, pytest.ini, .pre-commit-config.yaml)
  - Run initial checks and generate baseline report
  - Document existing violations in docs/known-issues.md with counts and priority
  - Configure pre-commit hooks to check only modified files
  - Add CI configuration running checks on all files
  - Create make scripts for local validation
  - Update README.md with validation commands
  - Propose incremental remediation plan for existing violations
```

**Evidence Checklist:**

- [ ] Tools configured (Ruff, mypy, pytest, bandit)
- [ ] Baseline violations report generated
- [ ] Violations documented in docs/known-issues.md
- [ ] Pre-commit hooks configured (modified files only)
- [ ] CI configured (all files)
- [ ] Single-command local run documented
- [ ] Incremental remediation plan provided
- [ ] New commits pass all checks

### Scenario 3: Cross-Platform Team with IDE Integration

```gherkin
Given agent WITH automated-standards-enforcement skill
When user says: "Set up code quality tools for our .NET team using VS Code, Rider, and Visual Studio"
Then agent responds with:
  "Setting up automated standards for .NET with cross-platform consistency.
   Using dotnet-format (built into SDK), cspell for spelling, and dotnet test
   with coverage. All tools work consistently across VS Code, Rider, and Visual
   Studio. Configuring EditorConfig for consistent formatting, and git hooks via
   Husky.Net for pre-commit validation."
And agent creates:
  - .editorconfig with formatting rules (consistent across all IDEs)
  - .cspell.json for spelling
  - Directory.Build.props with code analysis settings (<TreatWarningsAsErrors>true</TreatWarningsAsErrors>)
  - Husky.Net task runner for pre-commit hooks
  - PowerShell script (validate.ps1) and bash script (validate.sh) for cross-platform local runs
  - GitHub Actions workflow running dotnet-format, spell check, and tests
  - README.md with IDE-specific setup instructions (extensions, settings)
  - docs/known-issues.md template
```

**Evidence Checklist:**

- [ ] EditorConfig configured (.editorconfig)
- [ ] Code analysis enabled (Directory.Build.props)
- [ ] Spell checking configured (cspell.json)
- [ ] Pre-commit hooks configured (Husky.Net)
- [ ] Cross-platform scripts (validate.ps1, validate.sh)
- [ ] CI configured (GitHub Actions)
- [ ] IDE integration documented for VS Code, Rider, Visual Studio
- [ ] Clean build policy enforced (<TreatWarningsAsErrors>true)
- [ ] All checks pass

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                               | Reality                                                                             | Skill Enforcement                              |
| ------------------------------------ | ----------------------------------------------------------------------------------- | ---------------------------------------------- |
| "Can add linting later"              | Later never comes. Linting setup takes 15 minutes and prevents hours of debugging.  | Default application - standards from day one   |
| "MVP doesn't need quality checks"    | MVPs become production code. Start with quality or plan to rewrite.                 | P0 foundational - applies to all projects      |
| "Too many violations to fix"         | Use baseline approach: document existing violations, enforce on new code only.      | Brownfield workflow in skill                   |
| "Hooks slow down development"        | Pre-commit checks on staged files take <5 seconds. Far faster than debugging later. | lint-staged configuration for speed            |
| "Team won't accept automated checks" | Make checks visible and automated. Teams accept standards when friction is low.     | IDE integration for seamless experience        |
| "Clean build is too strict"          | Warnings indicate real problems. Allowing warnings leads to ignoring all warnings.  | Zero-warning policy with documented exceptions |
| "Can't risk breaking before deploy"  | Automated checks prevent breakage. Skipping checks is the real risk.                | Security scanning in CI                        |
| "User didn't ask for linting"        | P0 foundational skill applies by default unless explicitly refused.                 | Opt-out requires explicit refusal              |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Can add linting later"
- "MVP doesn't need quality checks"
- "Too many violations to fix"
- "Hooks slow development"
- "Clean build too strict"
- "Will break git history"
- "Team won't accept it"

**All of these mean:** Apply skill with brownfield approach or document explicit opt-out.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [x] Skill exists at `skills/automated-standards-enforcement/SKILL.md`
- [x] SKILL.md has YAML frontmatter with name and description
- [x] Main SKILL.md is under 300 words (299 words)
- [x] References folder contains tool-comparison.md
- [x] References folder contains language-configs.md
- [x] References folder contains ide-integration.md
- [x] References folder contains git-hooks-setup.md
- [x] References folder contains ci-configuration.md

### Skill Content

- [x] Default application (P0 foundational) documented in Overview
- [x] Opt-out mechanism documented in When to Use
- [x] References superpowers:verification-before-completion
- [x] References superpowers:test-driven-development
- [x] Core workflow documented (10 steps)
- [x] Quick reference table (standard to tool mapping)
- [x] Clean build policy defined (zero warnings)
- [x] Brownfield approach documented (5 steps)
- [x] Red flags listed (5 items)

### Cross-References

- [ ] README.md lists automated-standards-enforcement skill
- [ ] Tool comparison covers major ecosystems (JS/TS, Python, .NET, Go)
- [ ] Language configs include file-based configuration examples
- [ ] IDE integration covers VS Code, Rider, Visual Studio
- [ ] Git hooks setup covers Husky, Husky.Net, pre-commit framework
- [ ] CI configuration covers GitHub Actions, Azure Pipelines, GitLab CI

## Integration Test: Full Workflow Simulation

### Test Case: New TypeScript Project

1. **Trigger**: User says "Create a new TypeScript library"
2. **Expected**: Agent announces automated-standards-enforcement skill
3. **Expected**: Agent sets up ESLint, Prettier, cspell, Jest
4. **Expected**: Agent configures Husky with lint-staged
5. **Expected**: Agent creates CI configuration
6. **Expected**: Agent documents clean build policy in README
7. **Expected**: All validation passes before first commit
8. **Verification**: Run `npm run validate` - should pass with zero warnings

### Test Case: Brownfield Python Project

1. **Trigger**: User says "Add linting to this Python project"
2. **Expected**: Agent announces automated-standards-enforcement skill
3. **Expected**: Agent runs baseline to identify existing violations
4. **Expected**: Agent documents violations in docs/known-issues.md
5. **Expected**: Agent configures pre-commit for modified files only
6. **Expected**: Agent provides remediation plan
7. **Verification**: New code changes pass all checks; existing violations documented

### Test Case: Explicit Opt-Out

1. **Trigger**: User says "Create a quick prototype, skip all the linting stuff"
2. **Expected**: Agent recognizes explicit opt-out
3. **Expected**: Agent does NOT apply automated-standards-enforcement
4. **Expected**: Agent documents opt-out in docs/exclusions.md
5. **Verification**: No linting or standards configuration created
