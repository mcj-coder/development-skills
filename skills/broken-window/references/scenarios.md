# Broken Window Scenarios

Detailed examples with expected agent behavior when broken-window skill is active.

## Scenario 1: Git Line Ending Warning

**Context:** Agent commits code and sees:
```
warning: LF will be replaced by CRLF in src/components/LoginForm.tsx
The file will have its original line endings in your working directory
```

**Expected Behavior:**

```
Git warning detected: line ending inconsistency in LoginForm.tsx

Investigating... This indicates missing or inconsistent .gitattributes configuration.

Estimated fix time: 2 minutes (create/update .gitattributes)
Remaining work: 15 minutes
Impact ratio: 0.13x (well under 2x threshold)

Fixing immediately to prevent warning accumulation across the codebase.

[Creates .gitattributes with proper line ending rules]
[Verifies warning resolved with test commit]

Warning resolved. Continuing with original work.
```

**Evidence:**
- [ ] Warning investigated and root cause identified
- [ ] Fix applied (.gitattributes configured)
- [ ] Warning no longer appears on subsequent operations
- [ ] Fix time was <2x remaining work estimate

## Scenario 2: Package Vulnerabilities

**Context:** npm install shows:
```
3 vulnerabilities (2 moderate, 1 high)
```

**Expected Behavior:**

```
Package vulnerabilities detected. Running npm audit for details...

Analysis:
- 2 moderate: Development dependencies (jest, eslint-plugin)
- 1 high: Production dependency (lodash <4.17.21)

Estimated fix time:
- High severity: 5 minutes (update lodash, run tests)
- Moderate: 20 minutes (may require config updates)
Remaining work: 20 minutes
Impact ratio: 1.25x for all, 0.25x for high only

Fixing high-severity production vulnerability immediately.
Documenting moderate dev dependency vulnerabilities for next sprint.

[Updates lodash to 4.17.21]
[Runs tests to verify compatibility]
[Tests pass]
[Documents moderate issues in docs/known-issues.md]

High-severity issue resolved. Moderate issues documented.
```

**Evidence:**
- [ ] Vulnerabilities analyzed (severity, production vs dev)
- [ ] High-severity production issues fixed
- [ ] Tests pass after updates
- [ ] Remaining issues documented with justification

## Scenario 3: Pre-Completion Standards Review

**Context:** Agent finishing feature implementation.

**Expected Behavior:**

```
Feature implementation complete. Running pre-completion standards review...

Checking:
✓ Tests exist for new feature
✗ No entry in CHANGELOG.md for new API endpoint
✗ Missing JSDoc comment on public exportPasswordReset function
✓ Code follows existing patterns
✗ Linting shows 2 warnings (unused import, console.log)

Issues found:
1. Missing CHANGELOG entry
2. Missing JSDoc on public function
3. Two linting warnings

Estimated fix time: 8 minutes total
Work otherwise complete
Impact: Part of completion criteria (N/A to 2x rule)

Fixing all issues before declaring work complete.

[Adds CHANGELOG entry]
[Adds JSDoc comment]
[Removes unused import and console.log]
[Re-runs linter - clean]
[Re-runs tests - passing]

All standards met. Work now complete.
```

**Evidence:**
- [ ] Standards review performed
- [ ] All violations identified
- [ ] Violations fixed (not deferred)
- [ ] Work meets all completion criteria

## Scenario 4: Skills-First Validation (Greenfield)

**Context:** User requests feature in skills-first repository.

**Expected Behavior:**

```
Request: "Add logging to the user service"

Checking repository configuration...
Found AGENTS.md with skills-first-workflow reference.

Running prerequisites validation:
✓ Superpowers skill package installed
✗ test-driven-development skill not loaded
✗ systematic-debugging skill not loaded
✓ writing-skills skill loaded

Issues detected: Missing required skills for implementation

This is a broken window - proceeding without required skills violates repository standards.

Estimated impact: 30 seconds to load skills
Remaining work: Not started
Impact: Prerequisites must be met (N/A to 2x rule)

Loading missing skills before implementation...

[Loads test-driven-development skill]
[Loads systematic-debugging skill]

All prerequisites met. Beginning implementation following TDD workflow.
```

**Evidence:**
- [ ] Skills-first validation performed before starting
- [ ] Missing skills identified
- [ ] All required skills loaded
- [ ] Implementation follows skill requirements

## Scenario 5: Build Warning - 2x Threshold Exceeded

**Context:** TypeScript build shows deprecation warning.

**Expected Behavior:**

```
Build warning detected:
"DeprecationWarning: Foo API deprecated, will be removed in v10. Use Bar API instead."

Investigating impact...
- Affects 15 files across the codebase
- Requires refactoring from Foo API to Bar API
- Needs testing across multiple modules

Estimated fix time: 3 hours (refactor + test)
Remaining work: 1 hour (documentation update)
Impact ratio: 3x (exceeds 2x threshold)

This fix would triple delivery time. Documenting for planned remediation.

Creating entry in docs/known-issues.md...

## Known Issue: Foo API Deprecation

- **Detected:** 2026-01-05
- **Type:** Build Warning (Deprecation)
- **Impact:** Will break when library upgrades to v10
- **Why Not Fixed:** 3-hour fix exceeds 2x threshold (1 hour remaining work)
- **Mitigation:** Pinned library to v9.x in package.json
- **Resolution Plan:** Schedule refactoring sprint before v10 release
- **Approved By:** [User to confirm]

Documented. Continuing with planned work.
User should be aware this needs scheduling.
```

**Evidence:**
- [ ] Warning investigated
- [ ] Fix time accurately estimated
- [ ] 2x threshold calculation shown
- [ ] Issue documented in known-issues.md with complete information
- [ ] Mitigation applied (version pinning)

## Scenario 6: False "Normal Behavior" Rationalization

**Context:** Agent encounters repeated test timeout warnings.

**WRONG Behavior (Without Skill):**

```
Test warnings detected:
"Warning: Test exceeded 5000ms timeout in 3 tests"

These timeouts are likely due to slow CI environment or network dependencies.
This is normal for integration tests. Proceeding...
```

**CORRECT Behavior (With Skill):**

```
Test warnings detected:
"Warning: Test exceeded 5000ms timeout in 3 tests"

RED FLAG: Rationalizing as "normal behavior"

Warnings indicate problems. Investigating root cause...

[Examines failing tests]
[Identifies missing proper async handling in test setup]

Root cause: Tests not properly waiting for database connection.
Not a "slow CI" issue - this is a test quality issue.

Estimated fix time: 10 minutes (add proper await in beforeEach)
Remaining work: 30 minutes
Impact ratio: 0.33x (under 2x threshold)

Fixing immediately.

[Adds proper async/await in test setup]
[Re-runs tests - no warnings]

Issue resolved. These weren't "normal" - they were broken windows.
```

**Evidence:**
- [ ] Rejected "normal behavior" rationalization
- [ ] Investigated actual root cause
- [ ] Fixed underlying issue
- [ ] Verified warnings eliminated

## Anti-Pattern Examples

### Anti-Pattern 1: Offering Deferral as Default Option

**WRONG:**
```
I see linting errors. Would you like me to:
1. Fix them now
2. Document them for later
3. Suppress them with inline comments
```

**CORRECT:**
```
Linting errors detected. Applying 2x rule...

Estimated fix time: 3 minutes
Remaining work: 20 minutes
Impact ratio: 0.15x

Fixing immediately (well under 2x threshold).
[Fixes errors]
Done.
```

### Anti-Pattern 2: Treating Warnings as Optional

**WRONG:**
```
Build completed successfully with 2 warnings.
The warnings don't prevent the build, so we can proceed.
```

**CORRECT:**
```
Build completed with 2 warnings - these are broken windows.

Investigating warnings...
[Analyzes each warning]
[Applies 2x rule]
[Fixes or documents each]

Build now clean.
```

### Anti-Pattern 3: Skipping Pre-Completion Review

**WRONG:**
```
Feature implemented and tests passing.
Ready to commit!
```

**CORRECT:**
```
Feature implemented and tests passing.

Running pre-completion standards review...
[Checks tests, docs, patterns, linting]
[Identifies any gaps]
[Fixes gaps]

All standards met. NOW ready to commit.
```
