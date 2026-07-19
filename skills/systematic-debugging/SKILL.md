---
name: systematic-debugging
description: Use this skill whenever encountering any bug, test failure, or unexpected behaviour to identify root cause before proposing fixes.
---

# Systematic Debugging

## Intent

Ensure that technical issues are resolved by identifying and fixing their root cause, rather than applying superficial "band-aid" patches. This prevents the introduction of new bugs and architectural decay.

---

## When to Use

- Test failures (UnitTest, SystemTest, etc.).
- Unexpected system behaviour or crashes.
- Performance degradation.
- Integration failures between components.
- **Always** before proposing a fix for an observed issue.

---

## Precondition Failure Signal

- A fix is proposed without a documented root cause.
- Multiple "guesses" are tried sequentially to see what works.
- The symptom is addressed, but the underlying trigger remains.
- Diagnostic logs or evidence are missing.

---

## Postcondition Success Signal

- The root cause is identified and documented (WHERE and WHY).
- A minimal reproduction (e.g., a failing test) exists.
- The fix addresses the source of the problem.
- The system is verified as stable after the fix.

---

## Process

1. **Phase 1: Root Cause Investigation**:
   - Read error messages and stack traces completely.
   - Reproduce the issue consistently.
   - Trace data flow backward from the failure point to the source.
   - Add diagnostic instrumentation (logs) at component boundaries if the cause is unclear.
2. **Phase 2: Pattern Analysis**:
   - Find working examples of similar code.
   - Identify every difference between the working and broken states.
3. **Phase 3: Hypothesis and Testing**:
   - Form a single, specific hypothesis ("X is the cause because Y").
   - Test the hypothesis with the smallest possible change.
4. **Phase 4: Implementation**:
   - Create a failing regression test (RED).
   - Implement the fix (GREEN).
   - If 3+ fixes fail, **STOP** and question the architecture with a Tech Lead.
5. **Review**: Tech Lead and Domain Expert review the root cause analysis and the fix.

---

## Example Test / Validation

- **Issue**: API returns 500 on valid input.
- **Investigation**: Trace reveals null reference in `UserService`.
- **Root Cause**: Database query returned null, but service assumed non-null.
- **Fix**: Add null check and appropriate error handling.
- **Validation**: Regression test passes and original symptom is gone.

---

## Common Red Flags / Guardrail Violations

- "Quick fix for now, investigate later".
- Changing multiple variables at once.
- Proposing fixes before tracing data flow.
- Each fix attempt reveals a new, unrelated problem elsewhere (indicates architectural issue).

---

## Recommended Review Personas

- **Tech Lead** – validates root cause depth and architectural implications.
- **Platform Engineer** – validates diagnostic evidence and environment factors.

---

## Skill Priority

P1 – Quality & Correctness

---

## Conflict Resolution Rules

- The "Iron Law" (NO FIX WITHOUT ROOT CAUSE) overrides all delivery pressure.
- If 3+ fixes fail, implementation must stop for an architectural review.

---

## Conceptual Dependencies

- test-driven-development
- verification-and-handover

---

## Classification

Core
Operational

---

## Notes

95% of "unexplained" bugs are incomplete investigations. Symptom fixes are a failure of engineering discipline.
