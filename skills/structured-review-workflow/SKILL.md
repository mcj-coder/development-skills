---
name: structured-review-workflow
description: Use this skill when you need an end-to-end review workflow that coordinates both requesting and receiving feedback.
---

# Structured Review Workflow

## Intent

Coordinate review activities by composing the request and response skills so
feedback is handled consistently and evidence remains the source of truth.

---

## When to Use

- When you need the full review loop (request + receive).
- When multiple review personas are involved.
- When review scope or expectations are ambiguous.

---

## Precondition Failure Signal

- Review is requested without evidence.
- Feedback is implemented without verification or clarification.
- Scope grows beyond the original task.

---

## Postcondition Success Signal

- Review request includes summary, evidence, and focus areas.
- Feedback is handled item-by-item with verification evidence.
- The review loop closes with explicit reviewer notification.

---

## Process

1. **Request**: Apply `requesting-code-review`.
2. **Receive**: Apply `receiving-code-review`.
3. **Close**: Re-run verification and notify reviewers.
4. **Review**: Tech Lead validates process adherence.

---

## Example Test / Validation

- **Request**: "Please review feat-X. Tests pass (logs attached). Focus on the migration in `V1__init.sql`."
- **Response**: "Applied null check in `UserService.cs`. Keeping list as-is because [technical reason]."

---

## Common Red Flags / Guardrail Violations

- Skipping `requesting-code-review` or `receiving-code-review`.
- Ignoring reviewer comments without justification.
- Expanding scope to appease subjective feedback.

---

## Recommended Review Personas

- **Tech Lead** – validates process integrity and technical outcomes.
- **Software Engineer** – validates peer-level clarity and maintainability.

---

## Skill Priority

P2 – Consistency & Governance

---

## Conflict Resolution Rules

- Postcondition Success Signals from applied skills are the objective truth in any review conflict.
- Escalate to the Skill Priority Model (P0-P4) if reviewers disagree on priorities.

---

## Conceptual Dependencies

- requesting-code-review
- receiving-code-review
- verification-and-handover

---

## Classification

Governance
Core

---

## Notes

Reviews are about the code, not the person. Use the defined skills as the common language for feedback.
