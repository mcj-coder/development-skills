---
name: automated-standards-enforcement
description: Use when creating or modifying any repository to establish automated quality enforcement (linting, spelling, tests, SAST, security). Applies by default unless user explicitly refuses. Ensures clean build policy with minimal developer friction.
metadata:
  type: Platform
  priority: P0
---

# Automated Standards Enforcement

## Overview

**P0 Foundational** - Applies by default. Zero-warning clean builds. Baseline for brownfield.

**REQUIRED:** superpowers:verification-before-completion, superpowers:test-driven-development

## Bootstrapping Skills Decision Matrix

Use this matrix to select the appropriate bootstrapping skill:

| If You Need To...                                            | Use This Skill                             |
| ------------------------------------------------------------ | ------------------------------------------ |
| Start a new project from scratch                             | greenfield-baseline                        |
| Add/audit quality tooling (linting, tests, SAST)             | **automated-standards-enforcement** (this) |
| Add/audit repo security (branch protection, secret scanning) | repo-best-practices-bootstrap              |

### Skill Scope Comparison

| Aspect            | greenfield-baseline          | automated-standards-enforcement | repo-best-practices-bootstrap |
| ----------------- | ---------------------------- | ------------------------------- | ----------------------------- |
| **Primary Focus** | Project foundation           | Quality tooling                 | Repo security/compliance      |
| **Project State** | New (no existing code)       | New or existing                 | New or existing               |
| **Outputs**       | Repo structure, CI/CD, docs  | Linting, tests, SAST config     | Branch rules, secrets config  |
| **Triggers**      | Entry point for new projects | Auto-triggered or standalone    | Use after structure exists    |

### Invocation Context

- **Greenfield projects**: Auto-triggered by greenfield-baseline
- **Brownfield projects**: Invoke directly with brownfield approach
- **Existing repos**: Invoke directly for quality tooling audit/addition

### Do NOT Use This Skill When

- Starting a brand new project (use greenfield-baseline, which triggers this skill)
- Only need repo security/compliance (use repo-best-practices-bootstrap)
- Quality tooling already exists and passes (no changes needed)

## When to Use

- Creating/modifying repository
- **Opt-out**: User explicitly refuses

## Core Workflow

1. Announce skill (default for all repos)
2. Identify: linting, spelling, tests, SAST, security
3. Map to tools ([Tool Comparison](references/tool-comparison.md))
4. Enforce: pre-commit hooks + CI
5. Single-command local run (`npm run validate`)
6. Document in README.md
7. Clean build (zero warnings)
8. Exceptions: `docs/known-issues.md`
9. IDE integrations ([IDE Integration](references/ide-integration.md))
10. Brownfield: baseline, enforce on new code

## Quick Reference

| Standard   | Typical Tools               | Enforcement         |
| ---------- | --------------------------- | ------------------- |
| Linting    | ESLint, Ruff, dotnet-format | Pre-commit + CI     |
| Formatting | Prettier, Black             | Pre-commit          |
| Spelling   | cspell                      | Pre-commit + CI     |
| Tests      | Jest, pytest, xUnit         | CI (coverage gates) |
| Security   | npm-audit, bandit, SAST     | CI                  |

See [Language Configs](references/language-configs.md) for ecosystem-specific setup.

## Clean Build Policy

**Zero warnings/errors required.** Exceptions documented in `docs/known-issues.md` with
justification and remediation plan. See [Git Hooks Setup](references/git-hooks-setup.md)
and [CI Configuration](references/ci-configuration.md) for enforcement.

## Brownfield Approach

1. Run baseline to identify existing violations
2. Document in `docs/known-issues.md` with counts
3. Pre-commit: check modified files only
4. CI: document baseline exceptions
5. Incremental remediation over time

## Red Flags - STOP

- "Can add linting later"
- "MVP doesn't need quality checks"
- "Too many violations to fix"
- "Hooks slow development"
- "Clean build too strict"

**All mean: Apply brownfield approach or document explicit opt-out.**

See [Tool Comparison](references/tool-comparison.md) for selection guidance.

## Reference CI Workflow Templates

Use pre-built CI workflow templates for common platforms:

| Platform       | Template                                                                                           | Description           |
| -------------- | -------------------------------------------------------------------------------------------------- | --------------------- |
| GitHub Actions | [templates/github-lint-workflow.yml.template](templates/github-lint-workflow.yml.template)         | Lint and format check |
| GitHub Actions | [templates/github-security-workflow.yml.template](templates/github-security-workflow.yml.template) | Security scanning     |
| Azure DevOps   | [templates/azure-pipelines-lint.yml.template](templates/azure-pipelines-lint.yml.template)         | Lint pipeline         |

### Using Templates

1. Copy template to `.github/workflows/` or pipeline directory
2. Replace `{LANGUAGE}` with your primary language (node, dotnet, python)
3. Adjust tool commands to match your `package.json` / `Makefile` scripts
4. Commit and verify workflow runs
