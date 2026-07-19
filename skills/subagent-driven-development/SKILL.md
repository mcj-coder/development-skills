---
name: subagent-driven-development
description: Use this skill when executing an approved plan with independent tasks that can be delegated to separate agents in the current session.
---

# Subagent-Driven Development

## Intent

Execute plan tasks via focused subagents with explicit review loops to reduce
context pollution and improve quality.

---

## When to Use

- Tasks are independent and can be executed in isolation.
- You want faster iteration with structured review between tasks.

---

## Precondition Failure Signal

- Multiple subagents edit overlapping files simultaneously.
- Tasks proceed without review or verification.
- Subagents lack full task context.

---

## Postcondition Success Signal

- Each task is executed by a fresh subagent with clear scope.
- Spec compliance review occurs before code-quality review.
- Plan status and evidence are updated after each task.

---

## Process

1. **Prepare**: Extract full task text and context from the plan.
2. **Dispatch**: Send a single task to one subagent with constraints and
   expected output.
3. **Review (Spec)**: Validate that the task meets plan requirements.
4. **Review (Quality)**: Validate code quality and standards.
5. **Update Plan**: Record verification evidence and mark the task Done.
6. **Repeat**: Continue task by task until complete.
7. **Finalize**: Use `finishing-a-development-branch`.

---

## Example Test / Validation

- Task shows evidence from tests and both review stages before being marked Done.

---

## Common Red Flags / Guardrail Violations

- Skipping spec review.
- Allowing subagents to read the plan instead of providing full task context.
- Running multiple implementation subagents in parallel for the same area.

---

## Recommended Review Personas

- **Tech Lead** - validates spec compliance.
- **Software Engineer** - validates code quality and consistency.

---

## Skill Priority

P3 - Delivery & Flow

---

## Conflict Resolution Rules

- If a review fails, the same task must be fixed before moving on.
- Quality and verification skills override speed.

---

## Conceptual Dependencies

- requesting-code-review
- verification-and-handover

---

## Classification

Delivery  
Operational

---

## Notes

Fresh context per task improves quality and reduces drift.
