# Testing Strategy

This document describes the testing approach and patterns for this repository.

## Overview

This repository does not have a traditional automated testing framework. Instead, skills are tested using
**simulated testing** with BDD (Behaviour-Driven Development) checklists and agent-based verification.

**Core Principle:** Skills are documentation. Testing documentation means verifying that agents behave
correctly when the documentation is present vs absent.

## TDD for Documentation

### The Iron Law

```text
NO SKILL WITHOUT A FAILING TEST FIRST
```

This applies to:

- New skills
- Edits to existing skills
- Documentation updates

**No exceptions.** If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

### RED-GREEN-REFACTOR Cycle

Skills follow the same TDD cycle as production code:

| TDD Concept             | Skill Creation                               |
| ----------------------- | -------------------------------------------- |
| **Test case**           | Pressure scenario with subagent              |
| **Production code**     | Skill document (SKILL.md)                    |
| **Test fails (RED)**    | Agent violates rule without skill (baseline) |
| **Test passes (GREEN)** | Agent complies with skill present            |
| **Refactor**            | Close loopholes while maintaining compliance |

### RED Phase - Baseline Testing

**Purpose:** Understand what agents do naturally WITHOUT the skill.

**Process:**

1. Create pressure scenarios (3+ with combined pressures)
2. Run scenarios with agent that does NOT have the skill loaded
3. Document behaviour verbatim:
   - What choices did agent make?
   - What rationalizations did it use?
   - What got skipped or done incorrectly?

**Output:** Baseline failures that the skill needs to address.

**Example RED Phase Test:**

```gherkin
Given agent WITHOUT architecture-testing skill
And pressure: time constraint ("need this quickly")
And pressure: sunk cost (already wrote 500 lines)
When user says: "Create a REST API for managing tasks"
Then record:
  - Does agent establish architecture boundaries? (likely NO)
  - Does agent add architecture tests? (likely NO)
  - Rationalizations: "Adding architecture tests later", "Keep it simple for now"
```

### GREEN Phase - Verification

**Purpose:** Verify the skill solves the identified problems.

**Process:**

1. Write minimal skill addressing specific baseline failures
2. Run same scenarios with skill present
3. Verify agent now complies:
   - Announces skill application
   - Performs required steps
   - Produces expected artifacts

**Output:** Concrete BDD scenarios with passing results.

**Example GREEN Phase Test:**

```gherkin
Given agent WITH architecture-testing skill
And same pressure: time constraint + sunk cost
When user says: "Create a REST API for managing tasks"
Then agent responds:
  "Creating REST API. Applying architecture pattern with boundary
   enforcement to ensure maintainability. This includes architecture
   tests to validate dependencies."
And agent creates:
  - Clear layer definitions
  - Architecture tests in tests/Architecture.Tests/
  - Documentation of boundaries
Evidence:
  - [ ] Architecture pattern documented
  - [ ] Tests created and passing
  - [ ] Boundaries explicitly defined
```

### REFACTOR Phase - Close Loopholes

**Purpose:** Make skill bulletproof against rationalizations.

**Process:**

1. Run additional pressure scenarios
2. Identify NEW rationalizations agents use
3. Add explicit counters to skill
4. Build rationalizations table
5. Create red flags list
6. Re-test until bulletproof

**Output:** Skill with comprehensive rationalization coverage.

## Testing Different Skill Types

### Discipline-Enforcing Skills

**Examples:** TDD, verification-before-completion, architecture-testing

**Test with:**

- **Academic questions:** Do they understand the rules?
- **Pressure scenarios:** Do they comply under stress?
- **Multiple pressures combined:** Time + sunk cost + exhaustion
- **Identify rationalizations:** Capture exact excuses used

**Success criteria:** Agent follows rule under maximum pressure.

**Pressure types:**

- **Time:** "Need this quickly", "Deadline is tomorrow"
- **Sunk cost:** "Already wrote 500 lines", "Almost done"
- **Authority:** "Senior dev said just do it", "User wants it now"
- **Exhaustion:** Multiple tasks, context switching

### Technique Skills

**Examples:** condition-based-waiting, root-cause-tracing

**Test with:**

- **Application scenarios:** Can they apply the technique correctly?
- **Variation scenarios:** Do they handle edge cases?
- **Missing information:** Do instructions have gaps?

**Success criteria:** Agent successfully applies technique to new scenario.

### Pattern Skills

**Examples:** reducing-complexity, information-hiding

**Test with:**

- **Recognition scenarios:** Do they recognize when pattern applies?
- **Application scenarios:** Can they use the mental model?
- **Counter-examples:** Do they know when NOT to apply?

**Success criteria:** Agent correctly identifies when/how to apply pattern.

### Reference Skills

**Examples:** API documentation, command references

**Test with:**

- **Retrieval scenarios:** Can they find the right information?
- **Application scenarios:** Can they use what they found correctly?
- **Gap testing:** Are common use cases covered?

**Success criteria:** Agent finds and correctly applies reference information.

## Test Scenario Naming Convention

Test scenarios should use phase-prefixed naming to clearly indicate their purpose:

| Prefix       | Phase/Type                         | Example                           |
| ------------ | ---------------------------------- | --------------------------------- |
| `Test R<N>`  | RED phase (baseline without skill) | `Test R1: C# Version Detection`   |
| `Test G<N>`  | GREEN phase (with skill)           | `Test G1: C# Version Detection`   |
| `Test P<N>`  | Pressure scenarios                 | `Test P1: Resist Time Pressure`   |
| `Test RV<N>` | Review scenarios                   | `Test RV1: PR Review - Migration` |
| `Test RC<N>` | Rationalization closure            | `Test RC1: "Too simple to test"`  |
| `Test I<N>`  | Integration scenarios              | `Test I1: Integration with TDD`   |

**Why phase prefixes?**

- Clearly indicates which phase the test belongs to
- Makes it easy to correlate RED and GREEN scenarios
- Distinguishes pressure testing from functional testing
- Enables quick navigation in large test files

**Alternative (legacy):** Some older test files use simple `Scenario N:` numbering. This is acceptable
but phase-prefixed naming is preferred for new test files.

## BDD Checklist Format

For documentation testing, use BDD checklists:

**Before editing documentation:**

```markdown
## Documentation BDD Checklist

Expected statements in docs/architecture-overview.md:

- [ ] Repository structure section exists
- [ ] Skills directory is documented
- [ ] Integration architecture is described
- [ ] RED-GREEN-REFACTOR methodology is mentioned
- [ ] Progressive loading is explained

Current status: FAILING

- Missing: Repository structure section
- Missing: Integration architecture description
```

**After editing:**

```markdown
## Documentation BDD Checklist

Status: PASSING ✓
All expected statements are present in docs/architecture-overview.md
```

## Pressure Scenario Design

### Combining Pressures

**Single pressure (weak test):**

```gherkin
Given agent WITH skill
And pressure: time constraint
```

**Multiple pressures (strong test):**

```gherkin
Given agent WITH skill
And pressure: time constraint ("deadline in 1 hour")
And pressure: sunk cost ("already wrote 500 lines without tests")
And pressure: authority ("tech lead said skip tests for now")
When user says: "Just finish the feature"
Then agent MUST still follow TDD despite all pressures
```

### Realistic Scenarios

**Use concrete, realistic prompts:**

- ✅ "Create a REST API for task management with users, projects, and tasks"
- ❌ "Create an application"

**Include context that creates pressure:**

- ✅ "We need this for demo tomorrow, can you finish it today?"
- ❌ "Build this feature"

## Rationalization Tables

Skills that enforce discipline must capture common excuses:

```markdown
## Rationalizations (and Reality)

| Excuse                           | Reality                                                                 |
| -------------------------------- | ----------------------------------------------------------------------- |
| "Too simple to test first"       | Simple code breaks. Test takes 30 seconds.                              |
| "Tests after achieve same goals" | Tests-after = "what does this do?" Tests-first = "what should this do?" |
| "It's about spirit not ritual"   | Violating the letter IS violating the spirit.                           |
| "This is different because..."   | It's not different. Write test first.                                   |
```

Source these from actual baseline testing, not speculation.

## Red Flags Lists

Help agents self-check when rationalizing:

```markdown
## Red Flags - STOP and Start Over

- Code before test
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "It's about spirit not ritual"
- "This is different because..."

**All of these mean: Delete code. Start over with TDD.**
```

## Testing Checklist (for Skill Creation)

**Before claiming a skill is complete:**

- [ ] RED Phase completed
  - [ ] 3+ baseline scenarios run WITHOUT skill
  - [ ] Agent behaviour documented verbatim
  - [ ] Rationalizations captured (exact wording)
  - [ ] Failure patterns identified

- [ ] GREEN Phase completed
  - [ ] Skill written addressing specific failures
  - [ ] Same scenarios run WITH skill
  - [ ] Agent now complies with requirements
  - [ ] Concrete BDD scenarios pass with evidence

- [ ] REFACTOR Phase completed
  - [ ] Additional pressure scenarios run
  - [ ] New rationalizations identified
  - [ ] Explicit counters added to skill
  - [ ] Rationalization table built
  - [ ] Red flags list created
  - [ ] Re-verified under pressure

- [ ] Documentation complete
  - [ ] SKILL.md follows agentskills.io spec
  - [ ] Frontmatter includes proper description (CSO rules)
  - [ ] Examples are concrete (not abstract)
  - [ ] Cross-references are correct
  - [ ] Token efficiency targets met

## Common Testing Mistakes

### Skipping RED Phase

**Mistake:** Writing skill before running baseline tests.

**Why it's bad:** You don't know what problems to solve.

**Fix:** Always run baseline scenarios first. No exceptions.

### Abstract BDD Scenarios

**Mistake:**

```gherkin
Given user creates new service
Then agent applies greenfield-baseline
```

**Why it's bad:** Not testable with concrete evidence.

**Fix:**

```gherkin
Given agent WITH greenfield-baseline
When user says: "Create a new REST API for inventory management"
Then agent responds: "{exact expected text}"
And agent creates:
  - src/ directory with {specific structure}
  - tests/ directory with {specific tests}
  - docs/ directory with {specific docs}
```

### Testing Happy Path Only

**Mistake:** Only testing scenarios where agent complies.

**Why it's bad:** Doesn't verify skill handles pressure and rationalizations.

**Fix:** Test under combined pressures (time + sunk cost + authority).

### Speculative Rationalizations

**Mistake:** Guessing what rationalizations agents might use.

**Why it's bad:** May not match actual agent behaviour.

**Fix:** Capture rationalizations verbatim from baseline testing.

## See Also

- [docs/coding-standards.md](coding-standards.md) - TDD requirements for code and docs
- [docs/architecture-overview.md](architecture-overview.md) - RED-GREEN-REFACTOR architecture
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Skill creation process
- `superpowers:writing-skills` - Comprehensive skill testing methodology
