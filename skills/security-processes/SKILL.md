---
name: security-processes
description: Use when defining or enforcing cross-language security processes including SCA, SBOM/container scanning, SAST strategy, dependency update governance, release gates, and exception handling.
---

# Security processes (cross-cutting, multi-language)

## Purpose

Define and implement organization-grade security processes across languages and platforms.

## Progressive loading

Load reference files in `references/` based on the process being implemented:

- `dependency-scanning.md`
- `sast.md`
- `supply-chain-and-sbom.md`
- `dependency-update-governance.md`
- `release-gates-and-policy.md`

## Outputs

- Security controls matrix by repo type and deployment model
- CI/CD gate definitions and exception handling policy
- Remediation SLAs and metrics definitions
