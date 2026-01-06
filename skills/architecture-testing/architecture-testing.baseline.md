# architecture-testing - TDD Baseline Evidence

**Issue:** #1
**Date:** 2026-01-06
**Status:** RED Phase Complete

## RED Phase (WITHOUT Skill)

### Pressure Scenario 1: Time Constraint + New Project

**Prompt:** "Create a REST API for managing tasks. Demo tomorrow."

**Baseline Behavior Observed:**

- **Established architecture pattern:** NO - Used "simple Controller + EF Core directly"
- **Defined layer boundaries:** NO - "I would not define explicit layer boundaries"
- **Added architecture tests:** NO - "I would not add architecture tests"

**Verbatim Rationalizations:**

1. "I'm explicitly choosing **speed over architecture**"
2. "Demo code often gets thrown away or significantly rewritten"
3. "Architecture enforcement adds value when multiple developers maintain code over time"
4. "A working demo tomorrow beats a well-architected demo next week"
5. "This is pragmatic for a demo - it works, it's readable, and it can be refactored later"

**Structure Proposed:**

```text
TaskApi/
├── Controllers/     (direct DB access)
├── Models/
├── Data/
└── appsettings.json
```

No Domain, Application, Infrastructure separation.

---

### Pressure Scenario 2: Sunk Cost + Refactoring Request

**Prompt:** "800 lines across 15 files, getting messy, add clean architecture."

**Baseline Behavior Observed:**

- **Defined boundaries for existing code:** PARTIAL - "on paper first, not in code"
- **Added tests to enforce boundaries:** PARTIAL - "for newly extracted pieces only"
- **Proposed full migration:** NO - "incremental strangler fig pattern"

**Verbatim Rationalizations:**

1. "Don't create abstractions you're not going to swap (YAGNI)"
2. "Don't add layers just for the pattern"
3. "Accept that 'good enough' architecture that ships beats 'perfect' architecture in progress"
4. "800 lines of working code has value - it handles edge cases you've already discovered"
5. "Rewriting risks reintroducing bugs that were already fixed"
6. "Over-engineering temptation - Clean architecture can lead to creating 5 files where 1 would suffice"

**Key Weakness:** No enforcement mechanism proposed. Boundaries remain conceptual.

---

### Pressure Scenario 3: Authority + Production Rush

**Prompt:** "Tech lead said finish it. Production deploy Friday. Some dependency violations exist."

**Baseline Behavior Observed:**

- **Suggested architecture enforcement:** NO - "I probably wouldn't add these with a 3-day deadline"
- **Added architecture tests:** NO - "They would likely fail on existing code, create friction"
- **Raised concerns about violations:** MINIMAL - "mention briefly" but not block

**Verbatim Rationalizations:**

1. "Following authority direction when it's not clearly harmful"
2. "Working code that ships beats perfect architecture that doesn't"
3. "Adding them now just to block ourselves seems counterproductive"
4. "The dependency violations are a code quality issue, not a correctness issue"
5. "I'd ship it and advocate for cleanup afterward"
6. "Without explicit architectural standards in my instructions, I default to pragmatism over purity"

**Critical Insight:** Agent explicitly stated that having architecture tests "already in place" in CI
would change behavior - enforcement works, but won't be added proactively.

---

## Summary of Baseline Failures

| Scenario      | Boundaries Defined | Tests Added | Enforcement |
| ------------- | ------------------ | ----------- | ----------- |
| Time pressure | NO                 | NO          | NO          |
| Sunk cost     | Conceptual only    | Partial     | NO          |
| Authority     | NO                 | NO          | NO          |

## Rationalizations to Address in GREEN Phase

1. **"Can add later"** - Later never happens without enforcement
2. **"Speed over architecture"** - Architecture prevents defects, saves time long-term
3. **"Demo/MVP doesn't need it"** - Demo code becomes production code
4. **"Too disruptive"** - Brownfield approach exists (permissive initial tests)
5. **"Tech lead said skip"** - Clarify cost with tech lead, don't assume
6. **"Working code ships"** - Shipping debt accumulates interest

## GREEN Phase Requirements

The skill MUST address these specific failures:

- [x] Opt-out mechanism for explicitly non-production work
- [x] Explicit brownfield approach for sunk cost scenarios
- [x] Rationalizations table countering each excuse
- [x] Red flags list for self-checking
- [x] Authority pressure handling guidance

---

## GREEN Phase (WITH Skill)

### Scenario 1: Time Pressure - PASS

**With skill loaded, agent response included:**

- ✅ **Opt-out explicitly offered:** "Do you want production-quality architecture with enforced boundaries?"
- ✅ **Red flag addressed:** Quoted rationalizations table - "Demo doesn't need it → Demos become production"
- ✅ **Pattern options presented:** Clean/Hexagonal/Layered
- ✅ **Time investment stated:** "~10-15 minutes additional setup"
- ✅ **Waited for user decision:** "Which option do you choose?"

**Key quote:** "Even with time pressure, investing 10-15 minutes now in proper boundaries will save hours later."

### Scenario 2: Brownfield (Sunk Cost) - PASS

**With skill loaded, agent response included:**

- ✅ **Brownfield workflow followed:** "For existing code with mixed concerns, we use the brownfield approach"
- ✅ **Minimum 3 layers defined:** Domain, Application, Infrastructure, Presentation
- ✅ **Dependency rules explicit:** "Domain depends on nothing, Application depends only on Domain"
- ✅ **Permissive tests with code example:** NetArchTest with `DoNotResideInNamespace("Domain.Legacy")`
- ✅ **Did NOT propose blocking deploy:** "Does NOT block deployment - current code continues to work"
- ✅ **Documentation planned:** "I'll create/update `docs/architecture-overview.md`"

**Key quote:** "This approach prevents NEW violations, creates migration path - tighten suppressions as you refactor."

### Scenario 3: Authority Pressure - PASS

**With skill loaded, agent response included:**

- ✅ **Red flag recognized:** "STOP - Architecture Testing Required"
- ✅ **Tech lead clarification required:** "Please clarify with the tech lead"
- ✅ **Rationalizations quoted:** "Tech lead said skip it → Clarify cost with tech lead"
- ✅ **Brownfield path proposed:** 3-day timeline with Day 1 adding permissive tests
- ✅ **Did NOT just proceed:** "Once you've had that conversation... I can proceed"
- ✅ **Cost made explicit:** "Skipping means we ship with violations that will compound"

**Key quote:** "Adding architecture tests now (2-4 hours) prevents new violations. Are you aware of this tradeoff?"

---

## GREEN Phase Summary

| Scenario      | Compliance | Key Behavior Change                      |
| ------------- | ---------- | ---------------------------------------- |
| Time pressure | PASS       | Offered opt-out, quoted rationalizations |
| Brownfield    | PASS       | Permissive tests, no deploy blocking     |
| Authority     | PASS       | Required clarification before proceeding |

All baseline failures addressed. Skill successfully changes agent behavior under pressure.

---

## REFACTOR Phase (Loophole Check)

### Loopholes Analyzed

1. **"Tech lead explicitly accepts risk"** - Agent offered to proceed if tech lead acknowledges cost.
   This is acceptable because agent stated would "document this decision in the PR/commit history" -
   audit trail preserved.

2. **User opts out then later requests production features** - Covered by skill workflow: opt-out
   documented in `docs/exclusions.md`, can be reconsidered when requirements change.

3. **Pattern selection confusion** - Agent presented multiple patterns with selection guide. Users can make informed choice.

### No Significant Loopholes Found

The skill successfully:

- Blocks default "skip architecture" behavior
- Requires explicit opt-out or documented risk acceptance
- Provides brownfield path for existing code
- Forces tech lead cost clarification under authority pressure

### Verification Result

**PASSED** - Skill successfully changes agent behavior from architecture-skipping to
architecture-enforcing under all three pressure types (time, sunk cost, authority).
