# Issue-Driven Delivery Grooming Phase - BDD Tests

## Overview

This test suite validates the backlog grooming phase that prepares issues for refinement.

## RED Scenarios (Expected Failures - Baseline)

These scenarios describe current undesired behaviour that should fail:

### RED-1: Issue Enters Refinement Without Grooming

**Given:** New issue is created in backlog
**And:** Issue has not been groomed
**When:** Agent attempts to start refinement
**Then:** Agent proceeds without validating issue readiness
**But:** Agent should verify issue has been groomed first
**Result:** FAIL - No grooming check exists

**Evidence:** Current SKILL.md has no grooming phase section

### RED-2: Issue Missing Required Labels Proceeds

**Given:** Issue exists without component, work-type, or priority labels
**When:** Agent starts working on issue
**Then:** Agent proceeds without validating labels
**But:** Agent should require categorization during grooming
**Result:** FAIL - No label validation in grooming phase

**Evidence:** Labels only checked at close time, not at grooming time

## GREEN Scenarios (Expected Behaviour - Post-Implementation)

These scenarios describe the desired behaviour after implementation:

### GREEN-1: Grooming Validates Requirements Origin

**Given:** Agent is grooming a new issue
**When:** Agent runs requirements validation activity
**Then:** [ ] Agent checks if issue went through requirements-gathering
**And:** [ ] Agent flags issues created without proper requirements
**Result:** PASS - Requirements origin validated

**Verification:**

- [ ] Grooming section includes requirements validation activity
- [ ] Activity has clear steps for validation

### GREEN-2: Grooming Applies Required Labels

**Given:** Agent is grooming an issue without labels
**When:** Agent runs categorization activity
**Then:** [ ] Agent adds component label based on scope
**And:** [ ] Agent adds work-type label based on content
**And:** [ ] Agent adds priority label based on urgency
**Result:** PASS - Labels applied during grooming

**Verification:**

- [ ] Categorization activity documented in grooming section
- [ ] References component-tagging.md for taxonomy

### GREEN-3: Grooming Detects Duplicate Issues

**Given:** Agent is grooming a new issue
**And:** Similar issue already exists in backlog
**When:** Agent runs duplicate detection activity
**Then:** [ ] Agent searches for similar issues
**And:** [ ] Agent flags potential duplicates for review
**And:** [ ] Agent links related issues
**Result:** PASS - Duplicates detected

**Verification:**

- [ ] Duplicate detection activity documented
- [ ] Steps include search and linking

### GREEN-4: Grooming Verifies Blocking Dependencies

**Given:** Agent is grooming an issue with blocked label
**When:** Agent runs blocked/blocking verification activity
**Then:** [ ] Agent verifies blocker issues exist
**And:** [ ] Agent checks if blockers are still open
**And:** [ ] Agent updates dependency comments if stale
**Result:** PASS - Dependencies verified

**Verification:**

- [ ] Blocked/blocking verification activity documented
- [ ] Includes check for circular dependencies

### GREEN-5: Grooming Checks for Unanswered Questions

**Given:** Agent is grooming an issue with comments
**And:** Some comments contain questions without responses
**When:** Agent runs follow-up review activity
**Then:** [ ] Agent identifies unanswered questions
**And:** [ ] Agent flags issue as needing response
**And:** [ ] Agent does not proceed until questions addressed
**Result:** PASS - Follow-up items identified

**Verification:**

- [ ] Follow-up review activity documented
- [ ] Exit criteria prevents proceeding with unanswered questions

### GREEN-6: Grooming Validates Standards Compliance

**Given:** Agent is grooming an issue
**When:** Agent runs standards alignment activity
**Then:** [ ] Agent checks issue against repo standards
**And:** [ ] Agent verifies acceptance criteria exist
**And:** [ ] Agent validates issue template compliance
**Result:** PASS - Standards validated

**Verification:**

- [ ] Standards alignment activity documented
- [ ] Acceptance criteria validation included

### GREEN-7: Issue Ready Exits Grooming

**Given:** Issue has passed all 6 grooming activities
**When:** Agent evaluates grooming status
**Then:** [ ] Agent transitions issue to state:refinement
**And:** [ ] Agent records grooming completion in comment
**Result:** PASS - Clean transition to refinement

**Verification:**

- [ ] Exit criteria checklist documented
- [ ] State transition command provided

## PRESSURE Scenarios (Edge Cases)

These scenarios test that grooming works correctly under non-ideal conditions:

### PRESSURE-1: Urgent Issue Requires Expedited Grooming

**Given:** P0 critical issue is created
**When:** Agent evaluates grooming requirements
**Then:** [ ] Agent performs abbreviated grooming (essential checks only)
**And:** [ ] Agent documents expedited grooming in comment
**And:** [ ] Agent proceeds to refinement quickly
**Result:** PASS - P0 issues get expedited path

**Anti-pattern to avoid:** Blocking P0 issues with full grooming ceremony

**Verification:**

- [ ] P0 expedited path documented
- [ ] Abbreviated activities listed

### PRESSURE-2: Issue Created Via External Integration

**Given:** Issue was created by automation (not requirements-gathering)
**When:** Agent runs requirements validation
**Then:** [ ] Agent recognizes external origin
**And:** [ ] Agent does not block for missing requirements-gathering
**And:** [ ] Agent validates issue content is sufficient
**Result:** PASS - External issues handled gracefully

**Anti-pattern to avoid:** Rejecting valid issues because of creation method

**Verification:**

- [ ] External issue handling documented
- [ ] Content validation alternative provided

### PRESSURE-3: Issue Already Partially Groomed

**Given:** Issue has some labels but not all required ones
**When:** Agent runs grooming
**Then:** [ ] Agent identifies missing labels only
**And:** [ ] Agent does not duplicate existing labels
**And:** [ ] Agent completes remaining grooming activities
**Result:** PASS - Partial grooming handled incrementally

**Anti-pattern to avoid:** Re-running all grooming activities from scratch

**Verification:**

- [ ] Incremental grooming approach documented or implied

## Success Criteria

When all GREEN scenarios pass:

- [ ] Grooming phase section exists in issue-driven-delivery SKILL.md
- [ ] All 6 grooming activities documented with steps
- [ ] Exit criteria defined for grooming phase
- [ ] State transition from grooming to refinement documented
- [ ] P0 expedited path documented
- [ ] BDD scenarios cover all grooming activities
- [ ] PRESSURE scenarios handle edge cases

## Test Execution Notes

**How to test:** Verify issue-driven-delivery SKILL.md contains grooming phase section

**RED scenarios:** Should currently fail (no grooming phase exists)
**GREEN scenarios:** Should pass after SKILL.md is updated
**PRESSURE scenarios:** Validate grooming handles edge cases

**Evidence collection:** Each scenario should verify:

- Presence of grooming section in SKILL.md
- Documented activities match scenario expectations
- Edge cases have explicit handling
