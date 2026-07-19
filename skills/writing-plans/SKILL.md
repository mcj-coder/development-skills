---
name: writing-plans
description: Use this skill when a multi-step task has a validated design and you need a detailed, reviewable implementation plan before touching code.
---

# Writing Plans

## Intent

Create a detailed, test-driven implementation plan that is easy to execute,
review, and recover after interruptions.

---

## When to Use

- After a design/spec has been approved.
- Before any multi-step implementation or refactor.
- When work will be executed by multiple agents or sessions.

---

## Precondition Failure Signal

- Work starts without a plan in `docs/plans/`.
- Tasks are too large to complete in 2-5 minutes.
- Plan lacks exact file paths, commands, or verification steps.

---

## Postcondition Success Signal

- Plan exists in `docs/plans/YYYY-MM-DD-<name>.md` using `skills/writing-plans/templates/plan_template.md`.
- Tasks are atomic and follow RED -> GREEN -> REFACTOR -> COMMIT.
- Each task includes exact file paths and verification commands.
- Tasks are only marked Done after verification steps are executed and evidence is recorded.
- The user approves the plan before execution begins.
- Required review evidence is recorded before marking the plan Delivered.
- Plan is only marked Delivered with explicit user permission.

---

## Process

1. **Source Review**: Read the design and identify impacted components.
2. **Structure**: Use `skills/writing-plans/templates/plan_template.md`.
3. **Decompose**: Split into 2-5 minute tasks.
4. **Specify**: For each task, include:
   - Exact file paths (create/modify/test).
   - RED/GREEN/REFACTOR steps.
   - Commands to run and expected outcomes.
   - Evidence capture requirements for verification output.
   - Commit guidance.
5. **Verification**: Ensure plan tasks include explicit verification steps.
6. **Approval**: Present plan and wait for user approval.
7. **Review**: Request review from relevant review personas for
   plan quality and boundary alignment, and record their collated feedback,
   agreed next steps, and any follow-up plan link in the plan document.
8. **Deliver Gate**: Ask for explicit user permission before marking the plan
   Delivered.
9. **Handover**: Offer execution via `executing-plans` or
   `subagent-driven-development` (if tasks are independent).

---

## Example Test / Validation

- Plan includes at least 3 tasks, each with exact file paths and test commands.

---

## Common Red Flags / Guardrail Violations

- Tasks labelled "Implement X" without steps or commands.
- Missing verification steps or expected outputs.
- Plans that skip RED-GREEN-REFACTOR.
- Proceeding to execution without approval.
- Marking a plan Delivered before required review evidence is recorded.
- Capturing review feedback outside the plan without summarizing it there.
- Marking Delivered without explicit user permission.

---

## Recommended Review Personas

- **Tech Lead** - validates architecture alignment and scope.
- **Software Engineer** - validates task granularity and feasibility.
- **Lead Developer** - validates plan quality and sequencing.
- **Architect** - validates boundaries, colocation, and reuse decisions.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- Execution skills must not start until the plan is approved.
- If requirements change, return to planning.

---

## Conceptual Dependencies

- test-driven-development
- brainstorming

---

## Classification

Governance  
Core

---

## Notes

Plans are the recovery point for interruptions. Make them explicit and complete.
