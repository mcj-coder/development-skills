---
name: test-driven-development
description: Use this skill whenever implementing any feature or bugfix to ensure behaviour is defined by tests before implementation.
---

# Test-Driven Development (TDD)

## Intent

Ensure that all code is driven by requirements expressed as automated tests. This minimizes over-engineering (YAGNI), prevents regressions, and provides immediate verification of the "Postcondition Success Signal".

---

## When to Use

- **Always**: New features, Bug fixes, Refactoring, Behaviour changes.
- **Exceptions (with human permission)**: Throwaway prototypes, Generated code, Configuration files.

---

## Precondition Failure Signal

- Production code is written before a corresponding failing test exists.
- Test passes immediately without implementation changes (testing existing behaviour).
- Failure message is not related to the missing feature (testing the wrong thing).

---

## Postcondition Success Signal

- **The Iron Law**: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.
- Every new feature or fix is accompanied by at least one passing test that previously failed correctly.
- Tests are minimal and show intent (demonstrate the desired API/behaviour).

---

## Process

1. **Source Review**: Identify the appropriate testing tier (UnitTest, SystemTest, etc.) and specific behaviour to implement.
2. **RED (Write Failing Test)**: Write one minimal test showing what should happen.
3. **Verify RED**: Run the test and watch it fail for the expected reason. If it passes or errors out with a typo, fix the test.
4. **GREEN (Minimal Code)**: Write the simplest code to pass the test. Do not add features or "improve" beyond the test.
5. **Verify GREEN**: Run the test and watch it pass. Ensure all other tests still pass.
6. **REFACTOR**: Clean up code, remove duplication, and improve names while keeping tests green.
7. **Repeat**: Move to the next minimal behaviour.

---

## Example Test / Validation

- **Bug Fix**: Empty email accepted.
  - RED: `test('rejects empty email', async () => { ... })`
  - Verify RED: `FAIL: expected 'Email required', got undefined`
  - GREEN: Implement check.
  - Verify GREEN: `PASS`

---

## Common Red Flags / Guardrail Violations

- Writing tests after implementation ("Test-Last").
- "Keep as reference": Keeping code written before tests instead of deleting it.
- Skipping TDD because it's "too simple" or "takes too long".
- Tests that test mock behaviour instead of real code behaviour.

---

## Recommended Review Personas

- **Software Engineer** – validates Red-Green-Refactor discipline.
- **Tech Lead** – validates that tests capture the spirit of the requirements.

---

## Skill Priority

P1 – Quality & Correctness

---

## Conflict Resolution Rules

- TDD overrides all lower-priority delivery pressures.
- If TDD is not possible (e.g., untestable legacy code), it must be recorded as technical debt and a `safe-brownfield-refactor` plan created.

---

## Conceptual Dependencies

- quality-gate-enforcement
- scoped-colocation

---

## Classification

Core

---

## Notes

If you didn't watch the test fail, you don't know if it tests the right thing.
Work code without real tests is technical debt.
