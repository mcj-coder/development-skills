---
name: dispatching-parallel-agents
description: Use this skill when you have multiple independent tasks or failures that can be investigated in parallel without shared state.
---

# Dispatching Parallel Agents

## Intent

Reduce cycle time by delegating independent investigations or tasks to parallel
agents while preventing scope collisions.

---

## When to Use

- Multiple independent failures or tasks exist.
- The tasks do not share state or files.
- The output can be integrated without ordering dependencies.

---

## Precondition Failure Signal

- Parallel agents modify the same files or components.
- Tasks are not clearly scoped.
- Integration requires rework because outputs conflict.

---

## Postcondition Success Signal

- Each agent has a focused scope and clear constraints.
- Outputs are reviewed and integrated without conflicts.
- Full verification passes after integration.

---

## Process

1. **Partition**: Group work into independent domains.
2. **Scope**: Define precise tasks, constraints, and expected outputs.
3. **Dispatch**: Assign one agent per domain.
4. **Review**: Validate each result for scope and correctness.
5. **Integrate**: Merge outputs and run full verification.

---

## Example Test / Validation

- Three independent test failures are investigated in parallel and the suite
  passes after integration.

---

## Common Red Flags / Guardrail Violations

- "Fix everything" prompts with no constraints.
- Parallel changes to shared files.
- Skipping integration verification.

---

## Recommended Review Personas

- **Platform Engineer** - validates integration and verification.
- **Tech Lead** - validates scope boundaries.

---

## Skill Priority

P3 - Delivery & Flow

---

## Conflict Resolution Rules

- If tasks are related, prefer `systematic-debugging` over parallelisation.
- Safety and correctness skills override speed.

---

## Conceptual Dependencies

- systematic-debugging
- verification-and-handover

---

## Classification

Delivery  
Operational

---

## Notes

Parallelism is a tool, not a default. Use only for truly independent work.
