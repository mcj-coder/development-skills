# ADR-001: Skip Artifact Signing

## Status

Accepted

## Context

The repo-best-practices-bootstrap skill recommended configuring artifact signing
for CI/CD artifacts using Sigstore/cosign. This provides supply chain security
by cryptographically signing build outputs.

## Decision

We will not implement artifact signing because:

- This repository does not publish artifacts (libraries, containers, binaries)
- It is a documentation/skill library repository
- No downstream consumers depend on signed artifacts from this repo

## Consequences

- Build outputs are not cryptographically signed
- If we later publish artifacts, this decision should be revisited
- Supply chain attacks via artifact tampering are not mitigated (acceptable given no artifacts)

## References

- Skill: repo-best-practices-bootstrap
- Feature: artifact-signing (Category 2: CI/CD Security)
- Date: 2026-01-07
