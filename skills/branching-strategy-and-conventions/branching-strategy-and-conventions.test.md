# Branching Strategy and Conventions - BDD Tests

## RED Phase - Baseline Scenarios (WITHOUT Skill)

### Scenario 1: Time Constraint + New Project

```gherkin
Given agent WITHOUT branching-strategy-and-conventions skill
And pressure: time constraint ("need to start coding immediately")
When user says: "Create a new web application repository"
Then record:
  - Does agent define branching strategy? (likely NO - starts with default branch only)
  - Does agent define commit message conventions? (likely NO - freeform commits)
  - Does agent configure branch protection? (likely NO - can commit to main directly)
  - Does agent define merge strategy? (likely NO - allows all merge types)
  - Rationalizations: "Can define strategy later", "Just use main branch for now"
```

### Scenario 2: Sunk Cost + Messy History

```gherkin
Given agent WITHOUT branching-strategy-and-conventions skill
And pressure: sunk cost ("200 commits with inconsistent messages")
When user says: "Our git history is a mess, can you add commit standards?"
Then record:
  - Does agent define commit conventions? (likely NO - would highlight past violations)
  - Does agent add commit message linting? (likely NO - would fail on old commits)
  - Does agent standardize merge strategy? (likely NO - history shows mixed approaches)
  - Rationalizations: "History is already messy", "Can't enforce on existing commits"
```

### Scenario 3: Authority + Release Chaos

```gherkin
Given agent WITHOUT branching-strategy-and-conventions skill
And pressure: authority ("CTO wants releases automated")
And pressure: time ("first automated release tomorrow")
When user says: "Set up automated semantic versioning for releases"
Then record:
  - Does agent require commit conventions first? (likely NO - tries to infer)
  - Does agent enforce commit format? (likely NO - works with freeform)
  - Does agent define branching for releases? (likely NO - releases from main)
  - Rationalizations: "Can parse existing messages", "Commit format not critical"
```

## GREEN Phase - Concrete Scenarios (WITH Skill)

### Scenario 1: New Repository with Trunk-Based Development

```gherkin
Given agent WITH branching-strategy-and-conventions skill
When user says: "Create a new microservice repository for our team"
Then agent responds with:
  "Creating microservice repository with Trunk-Based Development strategy.
   Using main as default branch with short-lived feature branches. Enforcing
   Conventional Commits for automated SemVer. Configuring squash merges to
   preserve SemVer impact in commit messages."
And agent creates:
  - Repository with main as default branch
  - commitlint configuration enforcing Conventional Commits
  - Pre-commit hook for commit message linting
  - Branch protection rules documentation
  - CONTRIBUTING.md documenting strategy
  - Squash merge guidance
```

**Evidence checklist:**

- [ ] main branch as default
- [ ] Conventional Commits enforced (commitlint)
- [ ] Pre-commit hook configured
- [ ] Branching strategy documented (CONTRIBUTING.md)
- [ ] Merge strategy defined (squash with SemVer preservation)
- [ ] Branch protection guidance provided
- [ ] Commit types documented (feat, fix, docs, etc.)

### Scenario 2: Existing Repository - Adding Conventions

```gherkin
Given agent WITH branching-strategy-and-conventions skill
And existing repository with no documented strategy
When user says: "Add commit conventions and branching policy to our Python library"
Then agent responds with:
  "Adding branching strategy and commit conventions to existing Python library.
   Documenting current implicit strategy. Installing commitizen for commit
   assistance and commitlint for validation. Enforcing Conventional Commits
   on new commits only (existing history exempt)."
And agent performs:
  - Analyze existing commit history and branching patterns
  - Document observed strategy in CONTRIBUTING.md
  - Install commitizen and commitlint
  - Configure pre-commit hooks (new commits only)
  - Configure CI validation
  - Document merge strategy
```

**Evidence checklist:**

- [ ] Current strategy analyzed and documented
- [ ] Conventional Commits configured (commitlint)
- [ ] Interactive commit tool added (commitizen)
- [ ] Pre-commit hooks configured
- [ ] CI validation configured
- [ ] Merge strategy documented
- [ ] Exemption for existing history noted

### Scenario 3: Git Flow with Semantic Versioning

```gherkin
Given agent WITH branching-strategy-and-conventions skill
When user says: "Set up Git Flow for our enterprise application with strict release management"
Then agent responds with:
  "Setting up Git Flow branching strategy for enterprise application.
   Establishing main (production), develop (integration), and supporting
   branches (feature/*, release/*, hotfix/*). Enforcing Conventional Commits
   for automated SemVer."
And agent creates:
  - main and develop branches
  - Branch protection rules documentation
  - commitlint configuration
  - Git Flow branch naming conventions
  - CONTRIBUTING.md with Git Flow process
  - Merge strategy rules by branch type
  - SemVer integration documentation
```

**Evidence checklist:**

- [ ] main and develop branches established
- [ ] Branch naming conventions defined
- [ ] Conventional Commits enforced
- [ ] Git Flow process documented
- [ ] Merge strategies defined by branch type
- [ ] Branch protection documented
- [ ] SemVer integration documented
- [ ] Release process documented

## Verification Criteria

### Skill Activation

- [ ] Skill announces itself and reason for application
- [ ] Default behavior is to apply (P0 foundational)
- [ ] Opt-out requires explicit user refusal documented in exclusions.md

### Branching Strategy

- [ ] One of three models selected: Trunk-Based, GitHub Flow, Git Flow
- [ ] Default branch is `main`
- [ ] Branch naming conventions defined and documented
- [ ] Branch protection rules documented or configured

### Commit Conventions

- [ ] Conventional Commits format documented
- [ ] All commit types listed with SemVer impact
- [ ] commitlint configured for validation
- [ ] Pre-commit hook set up
- [ ] CI validation configured
- [ ] Breaking change format documented

### Merge Strategy

- [ ] Default merge strategy defined
- [ ] Squash merge guidance provided
- [ ] SemVer impact preservation documented
- [ ] Merge commits disabled or restricted

### Documentation

- [ ] CONTRIBUTING.md updated with full strategy
- [ ] Commit message examples provided
- [ ] Branch workflow documented
- [ ] PR process documented

## Rationalizations Caught

| Excuse                       | Skill Response                                    |
| ---------------------------- | ------------------------------------------------- |
| "Can define strategy later"  | Apply skill now - 15 minutes prevents confusion   |
| "Just use main for now"      | Define strategy - prevents accidental commits     |
| "Team knows commits"         | Enforce conventions - enables automation          |
| "History is messy"           | Brownfield approach - baseline and enforce on new |
| "Commit format not critical" | Conventional Commits enable SemVer automation     |
| "Too restrictive"            | Balance enforcement with developer experience     |
