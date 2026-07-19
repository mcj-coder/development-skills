---
name: repository-foundation-bootstrap
description: Use this skill when bootstrapping a new repository or migrating an existing repo to conform to this skill library's standards, ensuring a clean, minimal foundation before feature work begins.
---

# Repository Foundation Bootstrap

## Intent

Establish a clean, standards-aligned repository foundation that supports both
new (greenfield) and existing (brownfield) codebases without introducing drift
or bypassing quality gates.

---

## When to Use

- Starting a new repository from scratch.
- Migrating a brownfield repository to this library's standards.
- Rebuilding or re-establishing repo structure, tooling, or governance.

---

## Precondition Failure Signal

- Repository lacks a verified baseline structure or consistent tooling.
- Quality gates or tooling are introduced on top of unresolved warnings.
- Brownfield migration starts without impact analysis or a transition plan.

---

## Postcondition Success Signal

- Repository baseline is documented and verified with zero warnings.
- Greenfield or brownfield path is explicit and approved.
- Tooling and governance alignment is reproducible and reviewable.

---

## Process

1. **Source Review**: Inspect current repo state (or confirm greenfield) and
   identify missing baseline elements.
2. **Scope Decision**: Declare greenfield vs brownfield path and apply
   `incremental-change-impact` for brownfield migrations.
3. **Plan**: Use `brainstorming` and `writing-plans` to define the bootstrap
   sequence and rollback approach.
4. **Implementation**:
   - Greenfield: initialize repo structure, commit baseline scaffolding, and
     align configuration with repository standards.
   - Brownfield: apply changes incrementally using
     `safe-brownfield-refactor` and `best-practice-introduction`.
5. **Verification**: Run required verification (including security checks when
   applicable) and ensure zero warnings (see `quality-gate-enforcement`).
6. **Documentation**: Record decisions in ADRs when structure or tooling changes
   are introduced.
7. **Review**: Tech Lead and Platform/DevOps review baseline integrity,
   migration safety, and CI/CD alignment.

---

## Example Test / Validation

- Baseline verification suite passes with zero warnings after bootstrap.

---

## Common Red Flags / Guardrail Violations

- Enabling gates before resolving baseline warnings.
- Migrating brownfield repos without impact analysis or rollback plan.
- Applying broad changes without ADRs for structure/tooling decisions.

---

## Recommended Review Personas

- **Tech Lead** - validates scope, sequencing, and architectural intent.
- **Platform/DevOps Engineer** - validates tooling alignment and CI/CD impact.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- If safety or correctness conflicts arise, P0/P1 skills override this skill.
- Brownfield migrations must defer to `safe-brownfield-refactor` and
  `incremental-change-impact` sequencing.

---

## Conceptual Dependencies

- brainstorming
- writing-plans
- incremental-change-impact
- safe-brownfield-refactor
- best-practice-introduction
- quality-gate-enforcement
- ci-cd-conformance
- static-analysis-security (when security posture changes)

---

## Classification

Governance
Core

---

## Notes

This skill defines the repository foundation. It does not replace
`greenfield-baseline` for component-level setup; use both when needed.
