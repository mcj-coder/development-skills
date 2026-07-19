---
name: <kebab-case-skill-name>
description: >
  <Concise statement describing WHEN this skill should be used.
  Focus on trigger conditions, not implementation details.>
---

# <Human-readable Skill Title>

## Intent

Describe the purpose of this skill and the problem it exists to solve.
State the desired outcome clearly and unambiguously.

This section answers:

- Why does this skill exist?
- What engineering behaviour does it enforce?

---

## When to Use

List the explicit conditions under which this skill must be applied.

Avoid vague language. If it is unclear when to use the skill, refine the skill.

---

## Precondition Failure Signal

Describe the observable failing state **before** the skill is applied.

These must be:

- Concrete
- Falsifiable
- Observable

If no clear failing state exists, the skill is invalid.

---

## Postcondition Success Signal

Describe the observable passing state **after** the skill is applied.

These must:

- Directly correspond to the precondition failures
- Be demonstrable through tests, checks, or inspection

---

## Process

Define the explicit steps that must be followed to apply this skill and verify the outcome.

Steps must include:

1. **Source Review**: Inspect relevant code, config, or documentation to understand current state and impact.
2. **Implementation**: Apply the changes according to the skill's intent.
3. **Verification**: Perform specific tests or checks to demonstrate the postcondition success signal.
4. **Documentation**: Capture any required design decisions or outcomes (e.g., ADRs).
5. **Review**: Ensure an independent review is performed by the recommended personas.

---

## Example Test / Validation

Describe one or more example validations that prove the skill was applied
correctly.

Do NOT include implementation details or tooling specifics.

---

## Common Red Flags / Guardrail Violations

List common shortcuts, anti-patterns, or behaviours that indicate the skill
has been bypassed or misapplied.

These are policy signals, not suggestions.

---

## Recommended Review Personas

List the roles that should independently review the output of this skill.

For each persona, state their review focus.

Review must be independent of execution.

---

## Skill Priority

State the priority of this skill using the canonical model:

- P0 – Safety & Integrity
- P1 – Quality & Correctness
- P2 – Consistency & Governance
- P3 – Delivery & Flow
- P4 – Optimisation & Convenience

If this skill conflicts with another, higher priority wins.

---

## Conflict Resolution Rules

Describe how conflicts with other skills are resolved.

Include:

- Which skill takes precedence
- Whether escalation or explicit approval is required
- Whether skills must be sequenced rather than combined

No skill may silently override another.

---

## Conceptual Dependencies

List other skills that must be applied before, after, or alongside this one.

Dependencies should be conceptual, not technical.

If none exist, state: “None”.

---

## Classification

Classify the skill as one or more of:

- Core
- Governance
- Operational

Prefer fewer classifications.

---

## Notes

(Optional)

Include clarifications, edge cases, or important context that does not fit
cleanly elsewhere.

Avoid speculative or future-facing guidance.

If this skill produces a plan, use `skills/writing-plans/templates/plan_template.md` and keep the
Task Checklist updated (Status/Verification/Evidence), including Finalization
on delivery or abort.
