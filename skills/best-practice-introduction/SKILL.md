---
name: best-practice-introduction
description: Use when introducing new standards, tooling, practices, or asking for adoption/rollout guidance. Produces phased rollout plan with adoption criteria, risk assessment, and rollback triggers.
---

# Best Practice Introduction

## Overview

**P2 Change Management** - Phased rollout with pilot validation. Rollback defined upfront.

**REQUIRED:** superpowers:brainstorming, superpowers:verification-before-completion

## When to Use

- Introducing new standards, tooling, or practices
- Rolling out team-wide process changes
- Adopting architectural patterns or quality gates
- **Opt-out**: Document in `docs/practice-decisions.md`

## Core Workflow

1. Announce skill and identify practice being introduced
2. Define phased rollout plan (minimum 2 phases):
   - Pilot/validation phase (volunteers or smallest scope)
   - Broader adoption phase(s) with escalating enforcement
3. For each phase specify: scope, enforcement level, duration, success criteria
4. Define rollback criteria (productivity, adoption, technical triggers)
5. Define communication plan (announcement, feedback, updates)
6. Track in `docs/practice-rollout.md`

See [Rollout Patterns](references/rollout-patterns.md) for strategies.

## Quick Reference

| Practice Type     | Strategy             | Pilot Scope              |
| ----------------- | -------------------- | ------------------------ |
| Linting/Tooling   | Opt-in pilot         | 1-2 volunteer teams      |
| Architecture      | Component-by-type    | Newest/smallest          |
| Security (urgent) | Immediate + baseline | All, baseline exceptions |
| Process change    | Team-by-team         | Willing early adopters   |

## Red Flags - STOP

- "Apply everywhere immediately"
- "No time for pilot"
- "Already paid for it"
- "Mandate is non-negotiable"
- "Team must adapt"

**All mean: Apply phased approach or document explicit skip.**

See [Rationalizations](references/rationalizations.md) for detailed rebuttals.

## Evidence Checklist

- [ ] Phased rollout plan defined (minimum 2 phases)
- [ ] Each phase has scope, enforcement level, duration, success criteria
- [ ] Rollback criteria defined
- [ ] Communication plan included
- [ ] Success metrics defined
- [ ] Adoption support specified (docs, training, office hours)
