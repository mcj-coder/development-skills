---
name: receiving-code-review
description: Use this skill when receiving review feedback to ensure changes are applied with technical rigor and verified evidence.
---

# Receiving Code Review

## Intent

Handle review feedback objectively: clarify, verify, and apply changes without
scope creep or performative agreement.

---

## When to Use

- After receiving PR comments or review notes.
- When feedback conflicts with requirements or architecture.

---

## Precondition Failure Signal

- Feedback is implemented without understanding or verification.
- Changes are made in bulk without testing each item.
- Scope expands beyond the original task.

---

## Postcondition Success Signal

- Each feedback item is addressed: fix, clarify, or reasoned refusal.
- Verification evidence exists for each change.
- Reviewer is notified when all items are resolved.

---

## Process

1. **Read**: Review all feedback without reacting.
2. **Clarify**: Ask for clarification on any ambiguous items.
3. **Evaluate**: Check each item against requirements and codebase reality.
4. **Apply**: Implement one item at a time, then verify.
5. **Record**: Note evidence and decisions (including refusals).
6. **Close**: Notify reviewer and re-run verification as needed.

---

## Example Test / Validation

- Feedback items are listed with fix status and test evidence.

---

## Common Red Flags / Guardrail Violations

- "LGTM" acceptance without evidence.
- Implementing unclear feedback without clarification.
- Changing unrelated code to "tidy up".

---

## Recommended Review Personas

- **Tech Lead** - validates scope and architectural correctness.
- **Software Engineer** - validates implementation and tests.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- If feedback conflicts with higher-priority skills, escalate.
- Do not broaden scope without explicit approval.

---

## Conceptual Dependencies

- verification-and-handover
- structured-review-workflow

---

## Classification

Governance  
Operational

---

## Notes

Review is about correctness, not politeness.
