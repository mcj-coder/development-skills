---
name: branching-strategy-and-conventions
description: Use when creating any repository, defining Git workflows, or enforcing commit conventions. Establishes branching policy, commit message standards (Conventional Commits), and merge rules aligned to SemVer.
---

# Branching Strategy and Conventions

## Overview

**P0 Foundational** - Applies by default. Establishes branching model, commit conventions, and merge strategy.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Any repository (default)
- New repository creation
- Existing repo without documented branching policy
- User requests Git branching or commit conventions
- Release management or versioning strategy needed

## Core Workflow

1. Announce skill (default for all repos)
2. Define branching strategy (Trunk-Based, GitHub Flow, or Git Flow)
3. Set default branch as `main`
4. Define branch naming: `feature/*`, `fix/*`, `docs/*`, `hotfix/*`, `release/*`
5. Configure Conventional Commits ([Commit Conventions](references/commit-conventions.md))
6. Set up commitlint + pre-commit hooks
7. Define merge strategy: disable merge commits, prefer `--ff-only` or squash
8. Document squash merge SemVer preservation ([Squash Merge Guide](references/squash-merge-guide.md))
9. Configure branch protection rules
10. Document in CONTRIBUTING.md
11. Brownfield: baseline existing history, enforce on new commits

## Quick Reference

| Element         | Standard                                   | Enforcement     |
| --------------- | ------------------------------------------ | --------------- |
| Default Branch  | `main`                                     | Repository      |
| Branch Naming   | `feature/*`, `fix/*`, `docs/*`             | CI validation   |
| Commit Format   | Conventional Commits                       | commitlint      |
| Commit Types    | feat, fix, docs, chore, refactor, test, ci | Pre-commit + CI |
| Merge Strategy  | Squash (multi-commit) or FF-only (single)  | Branch rules    |
| Breaking Change | `feat!:` or `BREAKING CHANGE` footer       | SemVer MAJOR    |

See [Branching Models](references/branching-models.md) for strategy comparison.

## Red Flags - STOP

- "Can define strategy later"
- "Just use main for now"
- "Team knows commits"
- "History is messy anyway"
- "Commit format not important"
- "Can parse freeform messages"
- "Too restrictive for developers"

**All mean: Apply skill or document explicit opt-out in exclusions.md.**

## Rationalizations

| Excuse                            | Reality                                                                                 |
| --------------------------------- | --------------------------------------------------------------------------------------- |
| "Can define strategy later"       | Later never comes. Strategy takes 15 minutes, prevents project-long confusion.          |
| "Just use main branch for now"    | No strategy = accidental commits to main, no review process, deployment chaos.          |
| "Team knows how to write commits" | Inconsistent messages break automation, make history unreadable, prevent SemVer.        |
| "History is already messy"        | Enforce on new commits. Baseline existing history, don't rewrite it.                    |
| "Commit format not critical"      | Conventional Commits enable changelogs, SemVer, release notes. Critical for automation. |

## Evidence Checklist

- [ ] Branching strategy defined (Trunk-Based, GitHub Flow, or Git Flow)
- [ ] Default branch is `main`
- [ ] Branch naming conventions documented
- [ ] Conventional Commits configured (commitlint)
- [ ] Pre-commit hooks configured
- [ ] Merge strategy defined (squash or FF-only)
- [ ] CONTRIBUTING.md updated
