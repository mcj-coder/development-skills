# automated-standards-enforcement - TDD Baseline Evidence

- **Issue:** #89
- **Date:** 2026-01-06
- **Status:** Verified

## RED Phase (WITHOUT Skill)

### Pressure Scenario

- **Pressure:** Time constraint ("need MVP by Friday")
- **Request:** "Create a new Node.js API for customer management"

### Baseline Behavior Observed

Agent WITHOUT skill skipped all quality tooling:

- **Linting:** NO - "The user didn't ask for it"
- **Spell checking:** NO - "It adds setup time"
- **Pre-commit hooks:** NO - "For a 3-day MVP, I assumed 'ship it' was the priority"
- **Clean build policy:** NO - "I treated code quality tools as 'nice to have'"

### Verbatim Rationalizations

1. "The user didn't ask for it"
2. "It adds setup time"
3. "For a 3-day MVP, I assumed 'ship it' was the priority"
4. "I treated code quality tools as 'nice to have'"

## GREEN Phase (WITH Skill)

### Same Pressure Scenario Applied

Agent WITH skill set up all required tooling:

- **Linting:** YES - ESLint with `--max-warnings 0`
- **Spell checking:** YES - cspell configured
- **Pre-commit hooks:** YES - Proposed Husky
- **Clean build policy:** YES - Explicit zero-warnings policy

### Skill Compliance

| Requirement                | Compliant | Evidence                          |
| -------------------------- | --------- | --------------------------------- |
| Linting configured         | YES       | ESLint with TypeScript rules      |
| Formatting configured      | YES       | Prettier proposed                 |
| Spell checking configured  | YES       | cspell configuration              |
| Pre-commit hooks           | YES       | Husky + lint-staged               |
| Clean build policy         | YES       | Zero warnings enforced            |
| CI configuration           | YES       | Proposed GitHub Actions workflow  |

## Verification Result

**PASSED** - Skill successfully changed agent behavior from skipping to enforcing
automated standards under time pressure.
