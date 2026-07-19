---
name: semantic-version-impact
description: Use this skill whenever changes affect a deployable component or library to determine the correct semantic version bump based on conventional commits, scope, and observed impact.
---

# Semantic Version Impact Assessment

## Intent

Derive correct semantic version changes per component/library from observed
impact and change intent, ensuring releases are immutable and traceable.

---

## When to Use

- Any time a component/library changes and may be released
- Before tagging, releasing, or deploying
- When reviewing change sets for release readiness

---

## Precondition Failure Signal

- Version bumps are arbitrary or inconsistent
- Conventional commit semantics are ignored or misapplied
- Breaking changes ship under minor/patch versions
- Components that did not change are version-bumped unnecessarily

---

## Postcondition Success Signal

- Each impacted component/library has a justified version bump
- Unchanged components do not receive a new version
- Version decisions align with change intent and observable impact
- Release notes can be derived from the version decision

---

## Process

1. **Source Review**: Inspect the impact set and all commit messages since the last release for each impacted component.
2. **Implementation**: Calculate the appropriate semantic version bump based on the nature of the changes (breaking, feature, fix).
3. **Verification**: Verify that the calculated version correctly reflects the impact on the component's public contract.
4. **Documentation**: Document the proposed version bumps and the rationale for each.
5. **Review**: Tech Lead and Platform Engineer review the version bump calculations.

---

## Example Test / Validation

- Given a change set, identify impacted components and derive version bumps
- Verify breaking changes trigger major version increments
- Verify patch/minor are used appropriately for fixes/features
- Confirm unchanged components remain at current versions

---

## Common Red Flags / Guardrail Violations

- “Just bump minor to be safe”
- Bundling multiple components into one version decision without need
- Downgrading breaking changes to avoid major bump
- Skipping impact analysis and relying on assumptions

---

## Recommended Review Personas

- **Tech Lead** – validates semantic correctness and consistency
- **Release/Platform Engineer** – validates traceability and component scoping
- **Domain Expert** – validates whether change is breaking in practice

---

## Skill Priority

P2 – Consistency & Governance

---

## Conflict Resolution Rules

- Must consume incremental-change-impact output
- Correctness of version semantics overrides convenience
- If breaking status is ambiguous, escalate and document decision

---

## Conceptual Dependencies

- incremental-change-impact

---

## Classification

Governance

---

## Notes

Version numbers are contracts. Treat them as part of the public surface area.
