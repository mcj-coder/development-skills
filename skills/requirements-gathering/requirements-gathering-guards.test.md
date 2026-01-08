# Requirements-Gathering Guard - BDD Tests

## Overview

This test suite validates that the requirements-gathering skill includes a precondition guard
that checks whether a ticket already exists for the work before proceeding.

## RED Scenarios (Expected Failures - Baseline)

These scenarios describe current undesired behaviour that should fail:

### RED-1: Agent Loads Requirements-Gathering When Ticket Already Exists

**Given:** User asks agent to help with a feature
**And:** A GitHub issue already exists for this feature
**When:** Agent loads requirements-gathering skill
**Then:** Agent proceeds to gather requirements
**But:** Agent should have checked for existing ticket first
**Result:** FAIL - No precondition check performed

**Evidence:** Current SKILL.md has no precondition check section

### RED-2: Agent Proceeds Without Checking Preconditions

**Given:** Agent has loaded requirements-gathering skill
**And:** Agent skips to "Core Workflow" section
**When:** Agent begins gathering requirements
**Then:** Agent may duplicate existing ticket work
**But:** Agent should have verified preconditions first
**Result:** FAIL - Precondition check bypassed

**Evidence:** No guard section exists to enforce check

## GREEN Scenarios (Expected Behaviour - Post-Implementation)

These scenarios describe the desired behaviour after implementation:

### GREEN-1: Agent Checks If Ticket Exists Before Proceeding

**Given:** Agent has loaded requirements-gathering skill
**When:** Agent reads skill content
**Then:** [ ] Agent sees "Precondition Check" section near top
**And:** [ ] Agent verifies "No ticket exists for this work" condition
**Result:** PASS - Precondition check is visible and clear

**Verification:**

- [ ] Precondition Check section exists in SKILL.md
- [ ] Section appears before Core Workflow
- [ ] Check includes "Does a ticket exist?" verification

### GREEN-2: Agent Redirects to Brainstorming If Ticket Exists with Unclear Requirements

**Given:** Agent runs precondition check
**And:** Ticket exists for the work
**And:** Ticket requirements are unclear or incomplete
**When:** Agent evaluates precondition result
**Then:** [ ] Guard indicates precondition failed
**And:** [ ] Guard recommends brainstorming skill
**And:** [ ] Agent uses process-skill-router or brainstorming directly
**Result:** PASS - Correct redirect for unclear requirements

**Verification:**

- [ ] Guard provides redirect path for unclear requirements
- [ ] Brainstorming skill is recommended
- [ ] Agent does not proceed with requirements-gathering

### GREEN-3: Agent Redirects to Writing-Plans If Ticket Exists with Clear Requirements

**Given:** Agent runs precondition check
**And:** Ticket exists for the work
**And:** Ticket requirements are clear and complete
**When:** Agent evaluates precondition result
**Then:** [ ] Guard indicates precondition failed
**And:** [ ] Guard recommends writing-plans skill
**And:** [ ] Agent uses process-skill-router or writing-plans directly
**Result:** PASS - Correct redirect for clear requirements

**Verification:**

- [ ] Guard provides redirect path for clear requirements
- [ ] Writing-plans skill is recommended
- [ ] Agent does not proceed with requirements-gathering

### GREEN-4: Agent Proceeds When No Ticket Exists

**Given:** Agent runs precondition check
**And:** No ticket exists for the work
**When:** Agent evaluates precondition result
**Then:** [ ] Guard indicates precondition passed
**And:** [ ] Agent proceeds to Core Workflow
**Result:** PASS - Correct behaviour when precondition met

**Verification:**

- [ ] Guard confirms no ticket exists
- [ ] Agent continues with requirements-gathering
- [ ] No redirect occurs

## PRESSURE Scenarios (Edge Cases)

These scenarios test that the guard works correctly under ambiguous conditions:

### PRESSURE-1: Ticket Exists But Is Closed

**Given:** Agent runs precondition check
**And:** A closed ticket exists for similar work
**When:** Agent evaluates precondition
**Then:** [ ] Guard treats closed ticket as "no ticket exists"
**And:** [ ] Agent proceeds with requirements-gathering to create new ticket
**Result:** PASS - Closed tickets do not block new work

**Anti-pattern to avoid:** Blocking new ticket creation due to historical closed issues

**Verification:**

- [ ] Guard only considers open tickets
- [ ] Closed tickets do not trigger redirect

### PRESSURE-2: Ticket Exists But Is Draft/Incomplete State

**Given:** Agent runs precondition check
**And:** A draft or incomplete ticket exists for this work
**When:** Agent evaluates precondition
**Then:** [ ] Guard treats draft ticket as "ticket exists with unclear requirements"
**And:** [ ] Agent redirects to brainstorming to refine the draft
**Result:** PASS - Draft tickets trigger requirements refinement

**Verification:**

- [ ] Guard recognizes draft/incomplete state
- [ ] Redirect to brainstorming for refinement

### PRESSURE-3: Multiple Tickets Exist for Related Work

**Given:** Agent runs precondition check
**And:** Multiple open tickets exist that might relate to this work
**When:** Agent evaluates precondition
**Then:** [ ] Guard prompts for clarification
**And:** [ ] Agent asks user which ticket (if any) applies
**And:** [ ] Agent does not make assumptions
**Result:** PASS - Ambiguous cases prompt for clarification

**Anti-pattern to avoid:** Assuming the first matching ticket is correct

**Verification:**

- [ ] Guard detects multiple potential matches
- [ ] User is asked to clarify which ticket applies

## Success Criteria

When all GREEN scenarios pass:

- [ ] Precondition check section exists in requirements-gathering SKILL.md
- [ ] Guard checks for existing ticket before proceeding
- [ ] Redirect paths are clear for different ticket states
- [ ] Edge cases are handled gracefully
- [ ] Process-skill-router is referenced for complex routing

## Test Execution Notes

**How to test:** Verify requirements-gathering SKILL.md contains precondition guard section

**RED scenarios:** Should currently fail (no guard exists)
**GREEN scenarios:** Should pass after SKILL.md is updated
**PRESSURE scenarios:** Validate guard handles edge cases

**Evidence collection:** Each scenario should verify:

- Presence of guard section in SKILL.md
- Correct redirect recommendations
- Handling of edge cases
