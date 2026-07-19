---
name: executing-plans
description: Use this skill when you have an approved implementation plan and need to execute it in batches with review checkpoints.
---

# Executing Plans

## Intent

Execute an approved plan in controlled batches with explicit checkpoints,
keeping plan status and evidence up to date.

---

## When to Use

- After a plan is approved and ready to execute.
- When execution happens in a separate session or requires checkpoints.

---

## Precondition Failure Signal

- Plan steps are skipped or reordered without approval.
- No status updates or evidence are recorded in the plan.
- Tasks are marked Done without executing their verification steps.
- Execution continues after a blocker without clarification.

---

## Postcondition Success Signal

- Each executed task is marked in the plan with verification evidence.
- Tasks are not marked Done until verification steps are run and evidence is recorded.
- Blockers are raised immediately and resolved before proceeding.
- Progress is reported between batches.

---

## Process

1. **Load Plan**: Read the plan and identify batch size (default 3 tasks).
2. **Review**: Raise questions or gaps before starting.
3. **Execute Batch**:
   - Mark tasks In Progress.
   - Follow steps exactly (including tests).
   - Record verification evidence (command output, link, or note).
   - Mark tasks Done only after verification steps have run and evidence is recorded.
4. **Report**: Summarise changes and verification for the batch.
5. **Checkpoint**: Wait for feedback before next batch.
6. **Complete**: After final batch, move to `finishing-a-development-branch`.

---

## Example Test / Validation

- Plan shows updated status and evidence for tasks 1-3 after first batch.

---

## Common Red Flags / Guardrail Violations

- Executing tasks without updating plan status.
- Continuing despite failing verification.
- Skipping checkpoint feedback.

---

## Recommended Review Personas

- **Tech Lead** - validates adherence to plan and scope.
- **Platform Engineer** - validates verification evidence and build scope.

---

## Skill Priority

P3 - Delivery & Flow  
(Subordinate to quality and safety skills.)

---

## Conflict Resolution Rules

- If verification fails, stop and apply `systematic-debugging`.
- Do not proceed without plan updates and evidence.

---

## Conceptual Dependencies

- verification-and-handover
- systematic-debugging

---

## Classification

Delivery  
Operational

---

## Notes

Batching reduces context loss and keeps reviews focused.
