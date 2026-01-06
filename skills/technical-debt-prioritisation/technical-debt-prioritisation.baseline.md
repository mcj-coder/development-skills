# technical-debt-prioritisation - TDD Baseline Evidence

| Property | Value      |
| -------- | ---------- |
| Issue    | #89        |
| Date     | 2026-01-06 |
| Status   | Verified   |

## RED Phase (WITHOUT Skill)

### Pressure Scenario

- Pressure: Time ("we have one sprint for debt work")
- Request: "Prioritize these tech debt items: outdated React v16, flaky tests,
  missing API docs, circular dependencies, hardcoded DB credentials."
- Authority: Team lead pushing for auth refactor

### Baseline Behavior Observed

Agent WITHOUT skill used gut feel / pattern matching:

- Systematic scoring: PARTIAL - Informal, no numerical scores
- Evidence for scores: NO - Made assertions without proof
- Debt categorization: LOOSE - Implicit, not explicit taxonomy
- Quick wins identified: ASSUMED - Based on patterns, not verified
- Multi-horizon roadmap: MINIMAL - Only "future sprint" mention

### Verbatim Rationalizations

1. "Time pressure justifies heuristics"
2. "Security always wins" (used as mental shortcut, not proven)
3. "This is probably typical" (assumed codebase matches patterns)
4. "The user needs an answer now" (justified skipping data gathering)

### Pattern-Matching Anti-Pattern Demonstrated

> "The recommendations are probably reasonable, but they're not rigorously
> justified - they're 'senior engineer intuition' dressed up as analysis."

## GREEN Phase (WITH Skill)

### Same Pressure Scenario Applied

Agent WITH skill applied three-dimensional scoring:

- Systematic scoring: YES - Impact, Risk, Effort on 1-5 scale
- Evidence for scores: YES - Justification for each score
- Debt categorization: YES - Security, Testing, Architecture, Dependencies,
  Documentation
- Quick wins identified: YES - Formula: (Impact + Risk) / Effort > 4.0,
  effort <= 2
- Multi-horizon roadmap: YES - Sprint, Quarterly, 6-Month horizons

### Scoring Framework Applied

| Item                     | Impact | Risk | Effort | Score | Category      |
| ------------------------ | ------ | ---- | ------ | ----- | ------------- |
| Hardcoded DB credentials | 5      | 5    | 1      | 10.0  | Security      |
| Flaky integration tests  | 4      | 4    | 2      | 4.0   | Testing       |
| Circular dependencies    | 4      | 3    | 3      | 2.33  | Architecture  |
| React v16 upgrade        | 3      | 3    | 4      | 1.5   | Dependencies  |
| API documentation        | 2      | 1    | 2      | 1.5   | Documentation |

### Quick Wins Identified Objectively

1. Hardcoded DB credentials (Score: 10.0, Effort: 1) - Highest priority
2. Flaky integration tests (Score: 4.0, Effort: 2) - Second highest

### Skill Compliance

| Requirement               | Compliant | Evidence                              |
| ------------------------- | --------- | ------------------------------------- |
| Three-dimensional scoring | YES       | All 5 items scored on Impact/Risk/Eff |
| Evidence for each score   | YES       | Justification provided for each       |
| Debt categorized by type  | YES       | 5 categories identified               |
| Quick wins using formula  | YES       | Score > 4.0, effort <= 2              |
| Multi-horizon roadmap     | YES       | Sprint, Quarterly, 6-Month            |
| Resisted authority press  | YES       | Auth refactor required separate score |

## Verification Result

PASSED - Skill successfully changed agent behavior from gut-feel to
evidence-based prioritization under time and authority pressure.
