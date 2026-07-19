---
name: selective-build-test
description: Use this skill whenever preparing local or CI execution to build and test only the impacted components identified by change impact analysis, while preserving quality gates and correctness.
---

# Selective Build & Test Planning

## Intent

Plan and execute only the necessary builds and tests for impacted components,
based on an explicit impact assessment, while maintaining full quality and
correctness standards. This includes using monorepo-aware tooling to ensure
only affected code is re-verified, keeping feedback loops fast.

---

## When to Use

- Before local build/test runs in a monorepo.
- When configuring or reviewing CI behaviour for incremental execution.
- When optimising feedback loops without weakening standards.
- **Always** in multi-component projects to avoid redundant work.

---

## Precondition Failure Signal

- Full repo builds/tests run for small changes.
- Monorepo tooling (e.g., Nx, Turborepo) is present but not used or configured incorrectly.
- Incremental runs miss required tests for impacted components.
- Developers bypass checks because “it takes too long.”
- CI outputs cannot explain why a component did/did not run.

---

## Postcondition Success Signal

- Build/test matrix includes all and only impacted components.
- Tooling correctly identifies "affected" projects based on git graph.
- Required transitive tests are included where dependencies demand it.
- Quality gates remain unchanged; only the scope is reduced.
- Execution is reproducible and reviewable from the same inputs.

---

## Process

1. **Source Review**: Inspect the impact set produced by `incremental-change-impact` and determine the appropriate testing tier (UnitTest, SystemTest, ComponentE2E, E2E, ArchitectureTest) based on the current execution stage (Dev, Pre-commit, Pre-push, CI/CD).
2. **Discovery & Implementation**:
    - Identify the correct monorepo tool (e.g., Nx, Turborepo) for the project stack.
    - Configure the tool (e.g., `nx affected`, `turbo run --filter=[head]`) to only target the identified components and tiers.
3. **Verification**: Execute the build/test and verify that only the intended components and tiers were processed and that they passed.
4. **Documentation**: Document the selective execution plan, including which tiers were run and why.
5. **Review**: Platform/DevOps Engineer and Tech Lead review the selective execution results for correctness, coverage, and alignment with the test execution matrix.

---

## Example Test / Validation

- Change a single component and verify only that component’s build/tests run
- Introduce a dependency change and verify dependent components are included
- Confirm quality gates are identical to full runs for impacted components

---

## Common Red Flags / Guardrail Violations

- Skipping pre-commit hooks or checks “to save time”
- Reducing scope by suppressing tests rather than proving non-impact
- Disabling warnings-as-errors or lint rules to speed up builds
- Incremental logic that is not reproducible or explainable

---

## Recommended Review Personas

- **Platform/DevOps Engineer** – validates correctness of incremental execution
- **Tech Lead** – validates standards are not weakened and scope is justified
- **Domain Expert** – validates dependency assumptions

---

## Skill Priority

P3 – Delivery & Flow  
(Must never override P0–P2 constraints.)

---

## Conflict Resolution Rules

- Must consume the output of incremental-change-impact
- Cannot weaken quality gates; only reduces scope
- If uncertainty exists, broaden scope rather than suppress checks (with justification)

---

## Conceptual Dependencies

- incremental-change-impact
- quality-gate-enforcement

---

## Classification

Operational

---

## Notes

Optimise feedback loops, not standards. Faster is acceptable only when correct. Refer to the repository's "Test Execution Matrix" for stage-specific tier requirements.
