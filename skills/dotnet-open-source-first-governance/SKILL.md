---
name: dotnet-open-source-first-governance
description: Enforce open-source-first dependency selection with mandatory live license revalidation (web search) and review-time gating.
---

## Core

### When to use

- Selecting a new dependency.
- Upgrading any dependency (minor or major).
- Performing PR, architecture, security, or dependency reviews.

### Policy (non-negotiable)

- Strongly prefer **open-source** tooling and libraries.
- Prefer established OSS libraries over bespoke scripts/frameworks.
- OSS status is **time-sensitive** and must be revalidated.

## Load: checklists

### Mandatory: live license verification (web search)

For every dependency selection/upgrade/review, perform a **live web search** to confirm:

- the component is **still open source** today,
- the **current license** (and any dual-license terms) is acceptable,
- no recent licensing change introduces:
  - source-available restrictions,
  - field-of-use or non-commercial limitations,
  - delayed-open clauses,
  - copyleft obligations conflicting with the intended distribution model.

**Historical OSS status is insufficient.**

### Authoritative sources to check (minimum)

- Project homepage / official docs
- Source repository `LICENSE` file (and recent commits)
- Release notes / official announcements
- Issue tracker discussions relating to licensing changes

### Version-specific licensing

- Verify licensing for the **exact version** being adopted.
- If pinning to an older OSS version, document:
  - rationale,
  - maintenance plan,
  - security posture and upgrade strategy.

### Transitive dependencies

- Spot-check critical transitive dependencies for license changes (especially build-time tools and generators).

## Load: enforcement

### Hard gate (required)

A dependency proposal/PR/ADR is **incomplete** without:

- License name
- Verification source(s)
- Verification date (UTC)

Default outcome if missing: **reject or defer**.

### Agent rule: automatic revalidation trigger

When encountering a new library, an upgrade, or a dependency review, the agent must:

1. perform a live web search for current licensing,
2. flag ambiguity or recent changes,
3. mark the dependency **unapproved** if licensing cannot be verified confidently.
