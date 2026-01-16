---
name: greenfield-baseline
description: Use when starting a new project from scratch to establish proper foundation with quality gates, repository structure, CI/CD, and development standards before any feature work begins.
metadata:
  type: Platform
  priority: P2
---

# Greenfield Baseline

## Overview

**Start right, stay right.** A greenfield project is a rare opportunity to establish excellent
foundations without legacy constraints. This skill ensures new projects begin with proper
baseline infrastructure: quality gates, repository structure, CI/CD pipeline, and development
standards that prevent technical debt from day one.

**REQUIRED:** superpowers:verification-before-completion, superpowers:test-driven-development

## Bootstrapping Skills Decision Matrix

Use this matrix to select the appropriate bootstrapping skill:

| If You Need To...                                            | Use This Skill                  |
| ------------------------------------------------------------ | ------------------------------- |
| Start a new project from scratch                             | **greenfield-baseline** (this)  |
| Add/audit quality tooling (linting, tests, SAST)             | automated-standards-enforcement |
| Add/audit repo security (branch protection, secret scanning) | repo-best-practices-bootstrap   |

### Skill Scope Comparison

| Aspect            | greenfield-baseline          | automated-standards-enforcement  | repo-best-practices-bootstrap |
| ----------------- | ---------------------------- | -------------------------------- | ----------------------------- |
| **Primary Focus** | Project foundation           | Quality tooling                  | Repo security/compliance      |
| **Project State** | New (no existing code)       | New or existing                  | New or existing               |
| **Outputs**       | Repo structure, CI/CD, docs  | Linting, tests, SAST config      | Branch rules, secrets config  |
| **Triggers**      | Entry point for new projects | Triggered by greenfield-baseline | Use after structure exists    |

### Invocation Order for New Projects

```text
1. greenfield-baseline         (establish project structure)
   ├── automated-standards-enforcement (quality tooling - auto-triggered)
   └── repo-best-practices-bootstrap   (security config - invoke after)
2. walking-skeleton-delivery   (E2E validation - invoke after baseline)
```

### Do NOT Use This Skill When

- Project has existing code or structure (this is brownfield - use automated-standards-enforcement
  with brownfield strategy)
- Only need to add quality tooling (use automated-standards-enforcement directly)
- Only need security/compliance audit (use repo-best-practices-bootstrap directly)

## When to Use

- Creating a brand new project or repository
- Starting from scratch with no existing codebase
- User mentions "new project", "greenfield", or "starting fresh"
- Team has opportunity to "do it right from the start"
- Setting up a new microservice in an existing ecosystem

## Detection and Deference

Before creating new baseline structure, check for existing work:

```bash
# Check for existing project structure
ls *.sln *.csproj package.json pyproject.toml Cargo.toml go.mod 2>/dev/null

# Check for existing quality tooling
ls .editorconfig .prettierrc .eslintrc* ruff.toml .github/workflows/*.yml 2>/dev/null

# Check for existing documentation
ls README.md CONTRIBUTING.md docs/ 2>/dev/null
```

**If existing structure found:**

- This is NOT greenfield - use brownfield approach instead
- Apply `automated-standards-enforcement` with brownfield strategy
- Incrementally improve existing structure

**If truly greenfield:**

- Apply full baseline establishment
- Document architecture decisions in ADRs
- Set up quality gates from day one

## Skill Interaction

This skill integrates with and triggers other skills:

| Related Skill                        | Interaction                                 |
| ------------------------------------ | ------------------------------------------- |
| `automated-standards-enforcement`    | Triggered for quality tooling setup         |
| `walking-skeleton-delivery`          | Triggered after baseline for E2E validation |
| `issue-driven-delivery`              | Baseline includes issue tracking setup      |
| `branching-strategy-and-conventions` | Triggered for git workflow establishment    |

**Execution order:** greenfield-baseline first, then walking-skeleton-delivery for E2E validation.

## Core Workflow

1. **Verify truly greenfield** (no existing code/structure)
2. **Define project scope and technology stack**
3. **Establish repository structure:**
   - Source code directories (src/, tests/, docs/)
   - Configuration files (.editorconfig, .gitignore)
   - Documentation skeleton (README.md, CONTRIBUTING.md)
4. **Set up quality gates:**
   - Linting and formatting (language-appropriate)
   - Spelling checks (cspell or similar)
   - Pre-commit hooks
   - CI pipeline with quality checks
5. **Establish development standards:**
   - Coding conventions documented
   - Testing strategy defined
   - Branching strategy configured
6. **Document architecture decisions** (ADR for key choices)
7. **Verify baseline works** (run all quality checks)
8. **Hand off to walking-skeleton** for E2E validation

## Baseline Checklist

A proper greenfield baseline includes:

### Repository Structure

- [ ] Clear directory organisation (src/, tests/, docs/)
- [ ] .gitignore appropriate for technology stack
- [ ] .editorconfig for consistent formatting
- [ ] README.md with project overview and setup instructions
- [ ] CONTRIBUTING.md with contribution guidelines

### Quality Gates

- [ ] Linting configured and passing
- [ ] Formatting configured and enforced
- [ ] Spelling check configured
- [ ] Pre-commit hooks installed
- [ ] CI pipeline running all checks
- [ ] Zero warnings policy established

### Development Standards

- [ ] Coding conventions documented or referenced
- [ ] Testing strategy defined (unit, integration, E2E)
- [ ] Branching strategy documented
- [ ] Commit message conventions defined

### Documentation

- [ ] Architecture Decision Records (ADRs) directory created
- [ ] Initial ADR documenting technology choices
- [ ] Getting started guide for new developers

## Technology-Specific Templates

### .NET Projects

```bash
# Solution structure
dotnet new sln -n ProjectName
dotnet new classlib -n ProjectName.Domain -o src/ProjectName.Domain
dotnet new classlib -n ProjectName.Application -o src/ProjectName.Application
dotnet new webapi -n ProjectName.Api -o src/ProjectName.Api
dotnet new xunit -n ProjectName.Tests -o tests/ProjectName.Tests

# Add projects to solution
dotnet sln add src/**/*.csproj tests/**/*.csproj

# Quality tooling
dotnet new editorconfig
dotnet new tool-manifest
dotnet tool install dotnet-format
```

### Node.js Projects

```bash
# Initialize project
npm init -y

# Quality tooling
npm install --save-dev eslint prettier husky lint-staged cspell

# Initialize ESLint
npx eslint --init

# Set up pre-commit hooks
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
```

### Python Projects

```bash
# Initialize with pyproject.toml
mkdir src tests docs

# Create pyproject.toml with ruff, pytest configuration
# Quality tooling
pip install ruff pytest pre-commit

# Set up pre-commit
pre-commit install
```

## Red Flags - STOP

- "We'll add quality checks later"
- "MVP doesn't need this overhead"
- "Let's just get something working first"
- "Documentation can wait"
- "CI/CD is overkill for now"

**All mean: Apply greenfield-baseline NOW. Technical debt starts at day one without proper foundation.**

## Anti-Patterns to Avoid

| Anti-Pattern         | Why It's Wrong                      | Correct Approach                    |
| -------------------- | ----------------------------------- | ----------------------------------- |
| Skip linting         | Code quality degrades immediately   | Configure linting before first code |
| No CI from start     | "Works on my machine" issues appear | CI pipeline in baseline             |
| Documentation later  | Never happens, knowledge is lost    | README in baseline                  |
| Tests after features | Testing never catches up            | Test infrastructure in baseline     |
| Ad-hoc structure     | Inconsistency causes confusion      | Define structure upfront            |

## Verification Assertions

Before declaring baseline complete:

- [ ] All quality checks pass (`npm run lint` or equivalent)
- [ ] Pre-commit hooks work (test with a dummy commit)
- [ ] CI pipeline runs successfully
- [ ] README explains how to set up and run the project
- [ ] New developer can clone and run checks in under 5 minutes
- [ ] Zero warnings from all tooling

## Completion Evidence

When baseline is established, provide:

```markdown
## Greenfield Baseline Complete

**Repository structure:**

- [x] src/, tests/, docs/ directories created
- [x] .editorconfig configured
- [x] .gitignore appropriate for stack

**Quality gates:**

- [x] Linting: [tool name] configured
- [x] Formatting: [tool name] configured
- [x] Pre-commit hooks: installed and tested
- [x] CI pipeline: [link to workflow]

**Documentation:**

- [x] README.md with setup instructions
- [x] ADR-0001: Technology choices

**Verification:**

- All quality checks pass: [output/link]
- CI pipeline green: [link]

**Next step:** Apply walking-skeleton-delivery for E2E validation
```

## Stack-Agnostic Baseline Path

For projects where technology stack is not yet decided:

### Minimum Viable Baseline (Any Stack)

```bash
# 1. Repository essentials
mkdir -p src tests docs/adr
touch README.md CONTRIBUTING.md .gitignore .editorconfig

# 2. Basic .editorconfig (universal)
cat > .editorconfig << 'EOF'
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
EOF

# 3. Minimal .gitignore
cat > .gitignore << 'EOF'
# IDE
.idea/
.vscode/
*.swp

# Build outputs
/dist/
/build/
/out/

# Dependencies
node_modules/
.venv/
vendor/

# Environment
.env
.env.local
EOF

# 4. README template
cat > README.md << 'EOF'
# Project Name

## Overview
[Brief description]

## Getting Started
[Setup instructions - to be completed when stack is chosen]

## Development
[Development workflow - to be completed]

## License
[License information]
EOF
```

### Stack Selection ADR Template

```markdown
# ADR-0001: Technology Stack Selection

## Status

Proposed

## Context

Starting new project with requirements: [list requirements]

## Decision

We will use [stack] because:

- [Reason 1]
- [Reason 2]

## Consequences

- [Positive consequence]
- [Trade-off to manage]
```

## Minimal Baseline for Prototypes

For rapid prototyping where full baseline is overhead:

### Prototype Baseline (< 1 week projects)

| Item             | Full Baseline      | Prototype Baseline         |
| ---------------- | ------------------ | -------------------------- |
| README.md        | Comprehensive      | One-liner description      |
| .gitignore       | Stack-specific     | Basic IDE/build ignores    |
| Linting          | Full configuration | Language default only      |
| CI/CD            | Full pipeline      | None (manual verification) |
| Tests            | Full strategy      | Smoke tests only           |
| Pre-commit hooks | Full suite         | None                       |
| Documentation    | ADRs, guides       | README only                |

### Prototype Checklist

- [ ] README.md with project purpose
- [ ] .gitignore for IDE and build artifacts
- [ ] Single-command run capability
- [ ] One smoke test proving core functionality
- [ ] Time-boxed: Max 30 minutes on baseline

### Promotion Path: Prototype → Production

When prototype proves valuable:

1. Apply full `greenfield-baseline` retroactively
2. Add quality gates before any additional features
3. Document learnings from prototype phase
4. Treat as brownfield from this point
