---
name: writing-skills
description: Use this skill when creating or updating any `SKILL.md` to ensure the skill is test-driven, guardrail-enforced, and reviewable.
---

# Writing Skills

## Intent

Create or update skills with the same discipline as production code: clear
pre/post conditions, guardrails, and verification.

---

## When to Use

- Creating a new skill.
- Modifying an existing skill.
- Refactoring skills for composability.

---

## Precondition Failure Signal

- A skill is added without a failing precondition and passing postcondition.
- Red flags or review personas are missing.
- Skill changes are made without verification or peer review.

---

## Postcondition Success Signal

- Skill uses `skills/writing-skills/templates/skill_template.md` structure and required fields.
- Precondition and postcondition are explicit and testable.
- Red flags and review personas are defined.
- Documentation checks pass and review feedback is incorporated.

---

## Process

1. **Plan**: Use `brainstorming` then `writing-plans` if the change is multi-step.
2. **Template**: Start from `skills/writing-skills/templates/skill_template.md`.
3. **Define Tests**: Write precondition and postcondition first.
4. **Guardrails**: Add red flags and conflict resolution rules.
5. **Review Personas**: Specify who validates the output.
6. **Verify**: Run `npm run verify` and fix all issues.
7. **Review**: Request review using `structured-review-workflow`.

---

## Example Test / Validation

- A new skill includes explicit pre/post conditions and passes `npm run verify`.

---

## Common Red Flags / Guardrail Violations

- "It is just documentation" (skipping verification).
- Adding a skill without conflict resolution rules.
- Updating a skill without re-running checks.

---

## Recommended Review Personas

- **Tech Lead** - validates intent and conflicts.
- **Software Engineer** - validates clarity and usability.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- If verification fails, fix before adding more skills.
- If scope expands, return to planning.

---

## Conceptual Dependencies

- documentation-as-code
- verification-and-handover

---

## Classification

Governance  
Core

---

## Notes

Skills are part of the product. Treat them as such.
