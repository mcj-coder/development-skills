---
name: brainstorming
description: Use this skill before any creative or multi-step work to clarify intent, explore alternatives, and produce a validated design or specification.
---

# Brainstorming

## Intent

Turn a rough idea into a clear, reviewable design by asking focused questions,
considering alternatives, and validating the approach before any planning or
implementation begins.

---

## When to Use

- Before creating new features or components.
- When requirements are vague or shifting.
- When multiple design approaches are plausible.
- Before any plan is written.

---

## Precondition Failure Signal

- Implementation or planning starts without a validated design.
- Only one approach is considered.
- Requirements are clarified mid-implementation.
- The user has not explicitly approved a design.

---

## Postcondition Success Signal

- A design/spec exists and has been validated by the user.
- At least 2-3 approaches were compared with trade-offs.
- Open questions are captured and resolved or explicitly deferred.

---

## Process

1. **Source Review**: Inspect existing docs/code relevant to the topic.
2. **Clarify**: Ask one question per message; use multiple choice when possible.
3. **Explore**: Propose 2-3 approaches with trade-offs and a recommendation.
4. **Validate**: Present the design in small sections (200-300 words) and
   confirm each section before continuing.
5. **Document**: Save the validated design in `docs/designs/YYYY-MM-DD-<topic>.md`.
6. **Handover**: Ask whether to proceed to planning (`writing-plans`).

---

## Example Test / Validation

- **Idea**: "Add user profiles."
- **Validation**: A design document exists with 2-3 approaches, data flow, and
  error handling, and the user explicitly approves it.

---

## Common Red Flags / Guardrail Violations

- Asking multiple questions at once.
- Skipping alternatives because one idea "seems obvious".
- Presenting a full design without section-by-section confirmation.
- Moving to planning before explicit approval.

---

## Recommended Review Personas

- **Tech Lead** - validates architectural intent and trade-offs.
- **Software Engineer** - validates feasibility and clarity.

---

## Skill Priority

P2 - Consistency & Governance  
(Must precede planning and implementation work.)

---

## Conflict Resolution Rules

- If requirements change, return to this skill and re-validate.
- Planning skills must not begin until this skill is complete.

---

## Conceptual Dependencies

- writing-plans (for plan integration)

---

## Classification

Governance  
Core

---

## Notes

This skill is about thinking, not building. It must finish before planning.
