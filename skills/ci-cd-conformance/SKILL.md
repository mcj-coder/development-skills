---
name: ci-cd-conformance
description: Use when user creates/modifies CI/CD pipelines, mentions deployment automation, quality gates, or release processes. Applies to all repositories by default to ensure platform-specific best practices (dependency scanning, secret detection, protected branches).
metadata:
  type: Platform
  priority: P2
---

# CI/CD Conformance

## Overview

**P1 Quality & Correctness** - Enforces quality gates, immutable releases, and platform
security features. Prevents defective deployments.

**REQUIRED:** superpowers:verification-before-completion, superpowers:brainstorming

## When to Use

- Creating/modifying CI/CD pipelines
- Deployment automation, quality gates, release processes
- **Default**: Applies to all repositories
- **Opt-out**: User explicitly refuses

## Core Workflow

1. Detect CI/CD provider (GitHub Actions, Azure Pipelines, GitLab CI, Jenkins)
2. Prompt CLI install if missing (gh, az, glab)
3. Announce skill application
4. Configure quality gates: tests, linting, security scan, coverage threshold
5. Configure immutable releases: tag-triggered deployments only
6. Configure incremental execution: caching, conditional jobs
7. Enable platform security: dependency scanning, secret detection, branch protection
8. Configure OIDC/managed identity (eliminate long-lived secrets)
9. Document pipeline in docs/ci-cd-pipeline.md
10. Add status badge and summary to README.md

## Quick Reference

| Provider        | CLI     | Security Features                         |
| --------------- | ------- | ----------------------------------------- |
| GitHub Actions  | gh      | Dependabot, CodeQL, secret scanning, OIDC |
| Azure Pipelines | az      | Advanced security, credential scanning    |
| GitLab CI       | glab    | SAST, DAST, dependency scanning           |
| Jenkins         | jenkins | Plugin-based security                     |

See [Provider Configuration](references/provider-configuration.md) for setup details.

## Red Flags - STOP

- "Can add quality gates later"
- "Security scanning not needed"
- "Just need basic deployment"
- "Branch protection is extra"
- "Existing pipeline is fine"

All of these mean: Apply skill. CI/CD without quality gates is deployment automation,
not CI/CD.

## Rationalizations

| Excuse                                 | Reality                                                         |
| -------------------------------------- | --------------------------------------------------------------- |
| "Can add quality gates after demo"     | Demo deploys become production. Quality gates prevent defects.  |
| "Customer doesn't care about scanning" | Data breaches affect all customers. Security is non-negotiable. |
| "Branch protection is separate"        | CI/CD setup includes security. Incomplete setup creates risk.   |
| "Existing pipeline has worked"         | Lack of gates accumulates technical debt.                       |
| "Migration risk not worth it"          | Risk of NOT having gates exceeds migration risk.                |

See [Brownfield Migration](references/brownfield-migration.md) for incremental approaches.
