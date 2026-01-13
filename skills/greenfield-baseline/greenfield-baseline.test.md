# greenfield-baseline - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Pressure - Skip Quality Gates

**Given** agent WITHOUT greenfield-baseline skill
**And** pressure: time ("need to ship fast")
**When** user says: "Create a new API project, we need it running by end of week"
**Then** record baseline behaviour:

- Does agent set up linting? (expected: NO - focuses on features)
- Does agent configure pre-commit hooks? (expected: NO - "overhead")
- Does agent create CI pipeline? (expected: NO - "can add later")
- Does agent document architecture decisions? (expected: NO - "documentation later")
- Rationalizations observed: "MVP doesn't need this", "Add quality checks later"

### Test R2: Complexity Avoidance - Minimal Setup

**Given** agent WITHOUT greenfield-baseline skill
**And** pressure: simplicity ("keep it simple")
**When** user says: "Start a new microservice for user management"
**Then** record baseline behaviour:

- Does agent create proper directory structure? (expected: NO - flat structure)
- Does agent set up .editorconfig? (expected: NO - "IDE handles it")
- Does agent create CONTRIBUTING.md? (expected: NO - "team knows process")
- Does agent establish testing infrastructure? (expected: NO - "tests come with features")
- Rationalizations observed: "Keeping it simple", "Don't over-engineer"

### Test R3: Feature Focus - Documentation Debt

**Given** agent WITHOUT greenfield-baseline skill
**And** pressure: delivery ("need working features")
**When** user says: "Build a new e-commerce backend from scratch"
**Then** record baseline behaviour:

- Does agent create README with setup instructions? (expected: MINIMAL - just title)
- Does agent document technology choices? (expected: NO - "self-explanatory")
- Does agent establish coding conventions? (expected: NO - "team can decide later")
- Rationalizations observed: "Code is documentation", "README can wait"

### Expected Baseline Failures Summary

- [ ] Agent doesn't establish linting before writing code
- [ ] Agent doesn't configure pre-commit hooks
- [ ] Agent doesn't create CI pipeline from day one
- [ ] Agent creates ad-hoc directory structure
- [ ] Agent skips documentation skeleton
- [ ] Agent doesn't document architecture decisions
- [ ] Agent focuses on features before establishing foundations

## GREEN Phase - WITH Skill

### Test G1: New API Project with Full Baseline

**Given** agent WITH greenfield-baseline skill
**When** user says: "Create a new .NET API project for inventory management"
**Then** agent responds with baseline plan including:

- Repository structure (src/, tests/, docs/)
- Quality gates (linting, formatting, spelling)
- CI pipeline configuration
- Documentation skeleton
- Timeline estimate (1-2 hours for baseline)

**And** agent implements:

- Proper solution structure with layered architecture
- .editorconfig with team conventions
- Pre-commit hooks for quality checks
- GitHub Actions workflow for CI
- README.md with setup instructions
- ADR for technology choices

**And** agent verifies:

- All linting passes
- Pre-commit hooks work
- CI pipeline runs green
- Documentation is complete

**And** agent provides completion evidence:

- [ ] Repository structure established (src/, tests/, docs/)
- [ ] .editorconfig configured
- [ ] .gitignore appropriate for .NET
- [ ] Linting configured and passing
- [ ] Pre-commit hooks installed and tested
- [ ] CI pipeline created and green
- [ ] README.md with setup instructions
- [ ] ADR-0001 documenting technology choices
- [ ] Zero warnings from all tooling

### Test G2: Node.js Project with Quality Gates

**Given** agent WITH greenfield-baseline skill
**When** user says: "Start a new Node.js backend service"
**Then** agent responds with baseline plan including:

- Package structure and directory layout
- ESLint and Prettier configuration
- Husky pre-commit hooks
- GitHub Actions CI pipeline
- Documentation requirements

**And** agent implements:

- package.json with proper scripts
- .eslintrc with sensible defaults
- .prettierrc for consistent formatting
- .husky with pre-commit hook
- cspell.json for spelling checks
- CI workflow for all quality checks

**And** agent provides completion evidence:

- [ ] npm run lint passes with zero warnings
- [ ] npm run format checks pass
- [ ] Pre-commit hook tested with sample commit
- [ ] CI pipeline configured and running
- [ ] README with npm scripts documented
- [ ] Developer can start in under 5 minutes

### Test G3: Python Project with Modern Tooling

**Given** agent WITH greenfield-baseline skill
**When** user says: "Create a new Python microservice with FastAPI"
**Then** agent responds with baseline plan including:

- pyproject.toml-based configuration
- Ruff for linting and formatting
- Pre-commit hooks
- pytest infrastructure
- CI pipeline

**And** agent implements:

- pyproject.toml with all tool configuration
- Ruff configuration for linting
- Pre-commit config with ruff hooks
- pytest configuration
- GitHub Actions CI workflow

**And** agent provides completion evidence:

- [ ] ruff check passes
- [ ] ruff format --check passes
- [ ] pytest infrastructure ready
- [ ] Pre-commit hooks working
- [ ] CI pipeline green
- [ ] Virtual environment instructions in README

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH greenfield-baseline skill
**And** user says: "We need this running by Friday, no time for setup overhead"
**When** agent is tempted to skip quality gates
**Then** agent responds:

- Acknowledges deadline concern
- Explains baseline takes 1-2 hours, not days
- Shows that skipping baseline costs more time later
- Proposes rapid baseline followed by features
- Demonstrates baseline enables faster feature development

**And** agent does NOT:

- Skip linting "to save time"
- Defer CI pipeline "until later"
- Create ad-hoc structure "for speed"
- Skip documentation "for MVP"

### Test P2: Resist Complexity Avoidance

**Given** agent WITH greenfield-baseline skill
**And** user says: "Keep it simple, we don't need all that tooling"
**When** agent is tempted to minimise setup
**Then** agent responds:

- Acknowledges simplicity goal
- Explains baseline IS simple - just foundational
- Shows complexity comes from ad-hoc decisions later
- Proposes minimal but complete baseline
- Distinguishes "simple foundation" from "missing foundation"

**And** agent does NOT:

- Skip pre-commit hooks as "complexity"
- Avoid .editorconfig as "unnecessary"
- Remove CI as "overhead"
- Dismiss documentation as "premature"

### Test P3: Resist Feature-First Pressure

**Given** agent WITH greenfield-baseline skill
**And** user says: "Let's build features first, we can clean up later"
**When** agent is tempted to skip to implementation
**Then** agent responds:

- Acknowledges desire to see progress
- Explains baseline IS progress - foundational progress
- Shows "clean up later" never happens
- Proposes 2-hour baseline then features
- Demonstrates first feature benefits from baseline

**And** agent does NOT:

- Start features without quality gates
- Promise to "add linting later"
- Skip testing infrastructure
- Defer documentation

## Integration Scenarios

### Test I1: Integration with automated-standards-enforcement

**Given** agent WITH greenfield-baseline skill
**And** agent WITH automated-standards-enforcement skill
**When** user says: "Create a new repository for our team"
**Then** agent:

1. First applies greenfield-baseline for structure
2. Triggers automated-standards-enforcement for quality tooling
3. Ensures zero-warning clean build policy
4. Verifies all enforcement mechanisms work

**Evidence:**

- [ ] Baseline structure established
- [ ] Quality enforcement configured
- [ ] Clean build verified
- [ ] Skills integrated correctly

### Test I2: Integration with walking-skeleton-delivery

**Given** agent WITH greenfield-baseline skill
**And** agent WITH walking-skeleton-delivery skill
**When** user says: "Start a new order processing system"
**Then** agent:

1. First applies greenfield-baseline for foundations
2. Then triggers walking-skeleton-delivery for E2E validation
3. Walking skeleton builds on established baseline
4. All skeleton code passes baseline quality gates

**Evidence:**

- [ ] Baseline complete before skeleton starts
- [ ] Skeleton uses established structure
- [ ] Skeleton code passes linting
- [ ] CI runs skeleton tests

### Test I3: Integration with issue-driven-delivery

**Given** agent WITH greenfield-baseline skill
**And** agent WITH issue-driven-delivery skill
**When** user says: "Create a new project for the team"
**Then** agent:

1. Creates baseline with issue template setup
2. Establishes labels and project board structure
3. Documents workflow in CONTRIBUTING.md
4. First issues created for remaining setup tasks

**Evidence:**

- [ ] Issue templates configured
- [ ] Labels appropriate for workflow
- [ ] CONTRIBUTING.md documents process
- [ ] Setup tasks tracked as issues

## Rationalizations Closure

### Test RC1: "MVP doesn't need this"

**Given** agent WITH greenfield-baseline skill
**When** user or agent rationalizes: "MVP doesn't need quality gates"
**Then** agent responds:

- "Technical debt starts at line one. MVP is fastest with quality gates, not without."
- Explains quality gates ENABLE speed
- Shows cost of adding later vs now
- Baseline takes hours, debt takes weeks to fix

### Test RC2: "Add linting later"

**Given** agent WITH greenfield-baseline skill
**When** user or agent rationalizes: "We can add linting later"
**Then** agent responds:

- "Later never comes. Adding linting to existing code means fixing hundreds of issues."
- Shows brownfield remediation cost
- Explains greenfield advantage: zero violations from start
- 10 minutes now vs hours later

### Test RC3: "Keep it simple, no tooling"

**Given** agent WITH greenfield-baseline skill
**When** user or agent rationalizes: "Too much tooling, keep it simple"
**Then** agent responds:

- "Foundation tooling IS simple. It's missing tooling that creates complexity."
- Distinguishes helpful automation from complexity
- Shows tooling reduces cognitive load
- Explains .editorconfig means fewer debates

### Test RC4: "Documentation can wait"

**Given** agent WITH greenfield-baseline skill
**When** user or agent rationalizes: "We'll document later"
**Then** agent responds:

- "Knowledge is freshest now. Documentation debt compounds faster than code debt."
- README takes 15 minutes when you know the setup
- Takes hours when you've forgotten
- ADRs prevent re-debating decisions

### Test RC5: "CI is overkill for now"

**Given** agent WITH greenfield-baseline skill
**When** user or agent rationalizes: "CI pipeline can come later"
**Then** agent responds:

- "CI from day one catches issues immediately. Adding later means retrofitting."
- First PR should run through CI
- Establishes team expectations
- Prevents "works on my machine"

## Verification Assertions

Each GREEN test should verify:

- [ ] Repository structure follows conventions (src/, tests/, docs/)
- [ ] .editorconfig present and configured
- [ ] .gitignore appropriate for technology stack
- [ ] Linting configured with zero warnings
- [ ] Pre-commit hooks installed and tested
- [ ] CI pipeline configured and green
- [ ] README.md with setup instructions
- [ ] Architecture decisions documented (ADR)
- [ ] Zero warnings policy established
- [ ] New developer setup time under 5 minutes
- [ ] All rationalizations closed (cannot bypass baseline)

## Edge Cases

### Test E1: Existing Repository Detected

**Given** agent WITH greenfield-baseline skill
**When** agent detects existing project files (package.json, \*.sln, etc.)
**Then** agent:

- Recognises this is NOT greenfield
- Does NOT apply greenfield-baseline
- Suggests automated-standards-enforcement with brownfield approach
- Explains why greenfield approach doesn't apply

### Test E2: Monorepo Context

**Given** agent WITH greenfield-baseline skill
**When** user says: "Add a new service to our monorepo"
**Then** agent:

- Recognises monorepo context
- Applies baseline at service level, not repo level
- Reuses existing repo-level tooling where appropriate
- Adds service-specific configuration as needed

### Test E3: Technology Stack Unknown

**Given** agent WITH greenfield-baseline skill
**When** user says: "Start a new project" without specifying technology
**Then** agent:

- Asks about technology stack before applying baseline
- Does NOT assume technology
- Provides technology-specific baseline once confirmed
- Documents technology choice in ADR
