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

**Critical Insight:** Agent explicitly stated that having architecture tests "already in place" in CI would change behavior - enforcement works, but won't be added proactively.

---

## Summary of Baseline Failures

| Scenario | Boundaries Defined | Tests Added | Enforcement |
| -------- | ------------------ | ----------- | ----------- |
| Time pressure | NO | NO | NO |
| Sunk cost | Conceptual only | Partial | NO |
| Authority | NO | NO | NO |

## Rationalizations to Address in GREEN Phase

1. **"Can add later"** - Later never happens without enforcement
2. **"Speed over architecture"** - Architecture prevents defects, saves time long-term
3. **"Demo/MVP doesn't need it"** - Demo code becomes production code
4. **"Too disruptive"** - Brownfield approach exists (permissive initial tests)
5. **"Tech lead said skip"** - Clarify cost with tech lead, don't assume
6. **"Working code ships"** - Shipping debt accumulates interest

## GREEN Phase Requirements

The skill MUST address these specific failures:

- [ ] Opt-out mechanism for explicitly non-production work
- [ ] Explicit brownfield approach for sunk cost scenarios
- [ ] Rationalizations table countering each excuse
- [ ] Red flags list for self-checking
- [ ] Authority pressure handling guidance
