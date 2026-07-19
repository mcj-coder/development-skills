---
name: using-skill-library
description: Use this skill at the start of any session to load the skill inventory, apply trigger rules, and establish the required planning workflow.
---

# Using Skill Library

## Intent

Ensure every session starts with the correct skill inventory, priority rules,
and workflow discipline.

---

## When to Use

- At the start of any session before taking action.
- Before asking clarifying questions.

---

## Precondition Failure Signal

- Work begins without loading the skills table.
- Skills are applied without checking trigger conditions.
- Planning begins without establishing the required workflow.

---

## Postcondition Success Signal

- Skill front matter (name + description) is loaded from `skills/**/SKILL.md`.
- Priority and conflict rules are loaded from `docs/principles.md`.
- Relevant skills are identified and announced before acting.

---

## Process

1. **Inventory**: Read each skill's front matter (`name`, `description`) from `skills/**/SKILL.md`.
2. **Principles**: Read `docs/principles.md` for priority and conflicts.
3. **Trigger Check**: Match the task to relevant skills.
4. **Announce**: State which skills apply and why.
5. **Plan**: Use `brainstorming` then `writing-plans` for multi-step work.

---

## Example Test / Validation

- Session begins with an explicit list of applicable skills and a plan request.

---

## Common Red Flags / Guardrail Violations

- "I'll check skills after I look around."
- Acting before announcing applied skills.
- Skipping planning because the task feels small.

---

## Recommended Review Personas

- **Tech Lead** - validates scope and priority adherence.
- **Software Engineer** - validates correct skill selection.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- If skill selection is ambiguous, ask before proceeding.

---

## Conceptual Dependencies

- brainstorming
- writing-plans
- documentation-as-code

---

## Classification

Governance  
Core

---

## Notes

This is the "session bootstrap" skill.
