---
name: change-risk-rollback
description: Use when planning release, deployment, or infrastructure changes. Produces risk assessment with failure modes, impact rating, rollback procedures, and prerequisite execution criteria before deployment.
metadata:
  type: Process
  priority: P1
---

# Change Risk & Rollback

## Overview

Produce explicit risk and rollback analysis **before** deployment. Enumerate failure
modes, assess impact, define rollback procedures, and establish Go/No-Go criteria.

**REQUIRED:** superpowers:verification-before-completion,
superpowers:systematic-debugging

## When to Use

- Planning release or deployment changes
- Requesting assessment of operational risk
- Discussing rollback procedures
- Planning infrastructure or configuration changes
- Preparing production deployment

## Core Workflow

1. **Identify change scope** (component, dependencies, traffic, window)
2. **Enumerate failure modes** (minimum 3 with symptom, detection, impact, probability)
3. **Rate each risk** (impact x probability)
4. **Define rollback procedure** (detection, Go/No-Go criteria, execution steps, timeline)
5. **List prerequisites** (backups, monitoring, on-call, previous version)
6. **Select deployment strategy** (Blue-Green, Canary, Rolling, Big-Bang)
7. **Define success criteria** (measurable, time-bound)

See `references/failure-modes.md`, `references/rollback-templates.md`,
and `references/deployment-strategies.md` for details.

## Quick Reference

| Risk Level | Impact x Probability | Action Required               |
| ---------- | -------------------- | ----------------------------- |
| Critical   | HIGH x HIGH          | Executive approval, full plan |
| High       | HIGH x MED           | Full rollback plan required   |
| Medium     | MED x MED            | Standard rollback procedures  |
| Low        | LOW x LOW            | Minimal documentation         |

## Red Flags - STOP

- "Deployment is straightforward"
- "Can roll back if needed"
- "No time for risk analysis"
- "Testing caught everything"
- "We'll figure it out if something breaks"

**All mean: Apply skill before deployment or document explicit risk acceptance.**

## Rationalizations Table

| Excuse                      | Reality                                                                  |
| --------------------------- | ------------------------------------------------------------------------ |
| "Deployment is simple"      | No deployment is risk-free. Even simple changes have unexpected impacts. |
| "Can roll back if needed"   | Rollback must be defined BEFORE deployment, not during incident.         |
| "No time for risk analysis" | 15 minutes of analysis prevents hours of incident response.              |
| "Tested in staging"         | Staging doesn't replicate production. Risk analysis still required.      |
| "Too much work to back out" | Sunk cost fallacy. Better to delay than rush and fail.                   |

## Evidence Checklist

- [ ] Change scope documented (component, dependencies, traffic)
- [ ] Minimum 3 failure modes identified with detection criteria
- [ ] Risk rating for each failure mode
- [ ] Rollback procedure with timeline
- [ ] Go/No-Go criteria explicit and measurable
- [ ] Prerequisites checklist provided
- [ ] Deployment strategy selected with rationale
- [ ] Success criteria defined
