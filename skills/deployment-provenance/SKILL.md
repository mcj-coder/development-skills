---
name: deployment-provenance
description: Use when deploying software to production or staging environments to ensure complete traceability of what was deployed, when, by whom, and from which source. Essential for audit compliance, incident investigation, and rollback decisions.
---

# Deployment Provenance

## Overview

**P0 Safety & Integrity** - Deployment provenance establishes immutable traceability from running
artifact back to source commit, build process, and deployment actor. Critical for audit compliance,
security incident response, and confident rollback decisions.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Deploying to production or staging environments
- Setting up CI/CD pipelines for any deployable artifact
- Investigating production incidents requiring deployment history
- Establishing audit compliance for regulated environments
- Enabling confident rollback decisions

## Core Workflow

1. **Source Identification**: Tag or record exact commit SHA deployed
2. **Build Provenance**: Capture build number, pipeline, and build timestamp
3. **Artifact Signing**: Sign artifacts cryptographically (optional but recommended)
4. **Deployment Recording**: Log deployment timestamp, environment, and actor
5. **Artifact Labelling**: Embed provenance metadata in artifact (labels, manifests)
6. **Audit Trail**: Persist deployment records to immutable store
7. **Verification**: Validate provenance chain before and after deployment

## Provenance Record Schema

Every deployment MUST capture:

| Field              | Description                         | Example                                   |
| ------------------ | ----------------------------------- | ----------------------------------------- |
| `commit_sha`       | Full Git commit SHA                 | `a1b2c3d4e5f6...`                         |
| `branch`           | Source branch name                  | `main`, `release/1.2.0`                   |
| `build_id`         | CI/CD build identifier              | `build-12345`                             |
| `build_timestamp`  | When artifact was built (ISO 8601)  | `2025-01-15T10:30:00Z`                    |
| `deploy_timestamp` | When deployment occurred (ISO 8601) | `2025-01-15T11:00:00Z`                    |
| `environment`      | Target environment                  | `production`, `staging`                   |
| `actor`            | Who/what triggered deployment       | `ci-bot`, `jane.doe@example.com`          |
| `artifact_digest`  | SHA256 hash of deployed artifact    | `sha256:abc123...`                        |
| `pipeline_url`     | Link to CI/CD pipeline run          | `https://github.com/org/repo/actions/...` |
| `signature`        | Cryptographic signature (if signed) | `sigstore:...` or `gpg:...`               |

## Implementation Patterns

### Container Deployments

```dockerfile
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL org.opencontainers.image.created="${BUILD_TIMESTAMP}"
LABEL org.opencontainers.image.source="${REPO_URL}"
LABEL com.example.build-id="${BUILD_ID}"
LABEL com.example.pipeline-url="${PIPELINE_URL}"
```

### Kubernetes Deployments

```yaml
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
    app.example.com/git-sha: "${GIT_SHA}"
    app.example.com/build-id: "${BUILD_ID}"
    app.example.com/deployed-by: "${ACTOR}"
    app.example.com/deployed-at: "${DEPLOY_TIMESTAMP}"
```

### Application Version Endpoints

Expose `/version` or `/health` endpoint returning provenance:

```json
{
  "version": "1.2.3",
  "commit": "a1b2c3d4",
  "build": "12345",
  "built_at": "2025-01-15T10:30:00Z",
  "environment": "production"
}
```

## Audit Trail Storage

Store deployment records in an append-only audit log:

- **Git-based**: Deployment log file in ops repository
- **Database**: Append-only table with deployment events
- **External**: Audit systems (Splunk, CloudTrail, Azure Monitor)

Minimum retention: Follow organisational compliance requirements (typically 1-7 years).

## Verification Checklist

Before deployment:

- [ ] Commit SHA matches expected release
- [ ] Build provenance chain intact (commit to artifact)
- [ ] Artifact digest matches build output
- [ ] Signature valid (if signing enabled)
- [ ] Deployment actor authorised for target environment

After deployment:

- [ ] Version endpoint returns expected provenance
- [ ] Deployment event recorded in audit log
- [ ] Rollback target identified (previous deployment record)

## Red Flags - STOP

- "We deploy from local builds" - No reproducibility or audit trail
- "Version is just a timestamp" - Cannot trace to source code
- "Anyone can deploy to production" - No actor accountability
- "We don't track what's deployed" - Incident investigation impossible
- "Rollback means redeploy latest main" - May not match previous state

**All mean: Establish provenance tracking before proceeding with deployment.**

## Tooling Integration

| Platform       | Provenance Tool                              |
| -------------- | -------------------------------------------- |
| GitHub Actions | Built-in attestations, Sigstore, SLSA        |
| Azure DevOps   | Pipeline artifacts, deployment gates         |
| GitLab CI      | Release evidence, container signing          |
| Jenkins        | Build metadata plugin, artifact fingerprints |
| ArgoCD         | Application annotations, sync status         |
| Kubernetes     | OCI labels, admission controllers            |

## Related Practices

- **SLSA Framework**: Supply-chain Levels for Software Artifacts
- **Sigstore**: Keyless signing and verification
- **SBOM**: Software Bill of Materials for dependency provenance
- **GitOps**: Git as single source of truth for deployments
