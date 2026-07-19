---
name: incremental-deployment
description: Use this skill when deploying to ensure only modified and impacted components are deployed, with explicit version/tag inputs and environment traceability preserved.
---

# Incremental Deployment Planning

## Intent

Deploy only what changed (and what is impacted), while preserving strict
traceability via immutable versions and tags.

---

## When to Use

- Planning deployments in a monorepo with multiple components
- Preparing environment promotion
- Reviewing deployment scope for safety and efficiency

---

## Precondition Failure Signal

- Broad deployments include unrelated components
- Deployments are triggered from branches without tags
- Environment state cannot be explained in component version terms
- Incremental deployments miss required dependent components

---

## Postcondition Success Signal

- Deployment scope matches impacted components (and required dependencies)
- Deployments reference explicit component versions/tags
- Environment state is traceable to deployed component versions/tags
- Deployment plan is reproducible and reviewable

---

## Process

1. **Source Review**: Inspect the impact set produced by `incremental-change-impact` and the current state of the target environment.
2. **Implementation**: Execute the deployment only for the identified impacted components using their specific versions/tags.
3. **Verification**: Verify that only the intended components were deployed and that their versions/tags correctly reflect the source code.
4. **Documentation**: Update the environment traceability records with the new deployment details.
5. **Review**: Release Manager/SRE and Platform Engineer review the deployment plan and execution results.

---

## Example Test / Validation

- Given a change set, show only impacted components are deployed
- Validate dependent components are included when dependency changes require it
- Confirm environment records can list component versions/tags after deployment

---

## Common Red Flags / Guardrail Violations

- “Just redeploy everything to be safe”
- Deploying from main or HEAD without a tag
- Allowing “implicit latest” component selection
- Changing deployment scope without updating impact assessment

---

## Recommended Review Personas

- **Platform/DevOps Engineer** – validates deployment scope and traceability
- **Tech Lead** – validates correctness of impacted set and risk discipline
- **Domain Expert** – validates runtime dependency assumptions

---

## Skill Priority

P1 – Quality & Correctness  
(Escalate to P0 where traceability/immutability constraints are threatened.)

---

## Conflict Resolution Rules

- Must consume incremental-change-impact and release-tagging-plan outputs
- If uncertainty exists, broaden scope via impact justification, not via bypass of tagging/traceability
- Overrides Delivery/Optimisation shortcuts that weaken traceability

---

## Conceptual Dependencies

- incremental-change-impact
- release-tagging-plan

---

## Classification

Operational  
Governance

---

## Notes

Incremental deployment is only safe when traceability is strict.
