# aspire-integration-testing - TDD Baseline Evidence

**Issue:** #2
**Date:** 2026-01-06
**Status:** Verified

## RED Phase (WITHOUT Skill)

### Scenario 1: Time Pressure + New Aspire App

**Prompt:** "Create Aspire app with API, worker, PostgreSQL - demo by end of day"

**Baseline Behavior:**

- **Created integration tests:** NO - "I would not" under time pressure
- **Validated health endpoints:** PARTIAL - manual curl only, no automated tests
- **Verified observability:** MINIMAL - "glance at dashboard", no programmatic verification

**Verbatim Rationalizations:**

1. "Manual smoke tests" instead of automated tests
2. "Rely on Aspire's built-in health monitoring in the dashboard"
3. "NOT write tests verifying correlation IDs propagate"
4. "Ship code that works in demo conditions"
5. "Have no automated verification that the distributed system actually functions"

### Scenario 2: Sunk Cost + Debugging Communication

**Prompt:** "5 Aspire services not communicating properly, help debug"

**Baseline Behavior:**

- **Added integration tests:** NO - "would come later"
- **Tested service discovery:** NO - manual configuration inspection
- **Validated health endpoints:** NO - dashboard observation only

**Verbatim Rationalizations:**

1. "Debug manually using logs, dashboard, and trial-and-error"
2. "Fix the immediate problem first, then consider if tests would prevent regression"
3. "Reactive debugging" approach
4. "Not think to use DistributedApplicationTestingBuilder pattern"

### Scenario 3: Authority + Production Rush

**Prompt:** "Architect approved, deploying tomorrow, finish setup"

**Baseline Behavior:**

- **Required integration tests:** NO - "would not block deployment"
- **Validated health endpoints:** NO - "probably not systematically"
- **Tested observability:** NO - "almost certainly not"

**Verbatim Rationalizations:**

1. "It's just staging, we can fix issues there"
2. "The architect approved it, they must have considered this"
3. "Timeline pressure is real, tests can come later"
4. "90% complete means the core functionality works"
5. "Prioritize 'done' over 'done right' given authority approval"

---

## RED Phase Summary

| Scenario | Integration Tests | Health Validation | Observability |
| -------- | ----------------- | ----------------- | ------------- |
| Time pressure | NO | Manual only | Minimal |
| Sunk cost | NO | NO | NO |
| Authority | NO | NO | NO |

## Rationalizations to Address

1. "Aspire handles it automatically" - Must verify, not assume
2. "Too complex to test" - Aspire.Hosting.Testing makes it simple
3. "Can test in staging" - Local testing is 10x faster
4. "Demo doesn't need tests" - Demos become production
5. "Manual verification is enough" - Automated tests catch regression

---

## GREEN Phase (WITH Skill)

### Scenario 1: Time Pressure - PASS

**With skill loaded, agent response included:**

- ✅ **Created integration test project** with Aspire.Hosting.Testing
- ✅ **Health endpoint tests** for /health and /alive
- ✅ **Database connectivity test** for PostgreSQL
- ✅ **Observability smoke test** for structured logging
- ✅ **Test execution guidance** documented

### Scenario 2: Brownfield Debugging - PASS

**With skill loaded, agent response included:**

- ✅ **Systematic testing approach** instead of ad-hoc debugging
- ✅ **Service discovery validation** tests
- ✅ **Cross-component flow verification**
- ✅ **Health checks for all services**

### Scenario 3: Authority Pressure - PASS

**With skill loaded, agent response included:**

- ✅ **Required baseline tests** before deployment
- ✅ **Clarified cost** of skipping tests with stakeholders
- ✅ **Proposed incremental approach** for time constraints
- ✅ **Documented risk** if tests explicitly skipped

---

## Verification Result

**PASSED** - Skill successfully changes agent behavior from test-skipping to systematic integration testing under all pressure types.
