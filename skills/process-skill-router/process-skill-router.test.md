# Process Skill Router - BDD Tests

## Overview

This test suite validates that agents use the process-skill-router to select the correct
process skill based on context and preconditions.

## RED Scenarios (Expected Failures - Baseline)

These scenarios describe current undesired behaviour that should fail:

### RED-1: Agent Loads Brainstorming When No Ticket Exists

**Given:** User requests a new feature
**And:** No GitHub issue or work item exists for the work
**When:** Agent selects a process skill
**Then:** Agent loads `brainstorming` skill
**But:** Agent should have loaded `requirements-gathering` first
**Result:** FAIL - Wrong skill selected when no ticket exists

**Evidence:** This scenario currently passes (undesired) - agents can brainstorm without tickets

### RED-2: Agent Skips Requirements-Gathering for New Feature Request

**Given:** User describes a new feature they want built
**And:** No existing ticket references this feature
**When:** Agent begins work
**Then:** Agent proceeds directly to planning or implementation
**But:** Agent should have gathered requirements and created ticket first
**Result:** FAIL - Skipped requirements-gathering step

**Evidence:** No enforcement preventing this behaviour currently

### RED-3: Agent Skips Verification When Claiming Done

**Given:** Agent has completed implementation work
**When:** Agent claims work is complete
**Then:** Agent marks task as done without verification
**But:** Agent should have used `verification-before-completion` skill
**Result:** FAIL - Skipped verification step before claiming completion

**Evidence:** No workflow enforcement currently exists

## GREEN Scenarios (Expected Behaviour - Post-Implementation)

These scenarios describe the desired behaviour after implementation:

### GREEN-1: Router Directs to Requirements-Gathering When No Ticket Exists

**Given:** User requests new feature work
**And:** No GitHub issue or work item exists for the work
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `requirements-gathering` skill
**And:** [ ] Router provides rationale: "No ticket exists for this work"
**Result:** PASS - Correct skill recommended for ticket-less work

**Verification:**

- [ ] Recommendation is `requirements-gathering`
- [ ] Rationale explains missing ticket condition

### GREEN-2: Router Directs to Brainstorming When Requirements Unclear

**Given:** Agent is working on an existing ticket
**And:** Requirements in the ticket are unclear or incomplete
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `brainstorming` skill
**And:** [ ] Router provides rationale: "Ticket exists but requirements need clarification"
**Result:** PASS - Correct skill recommended for unclear requirements

**Verification:**

- [ ] Ticket exists (precondition met)
- [ ] Recommendation is `brainstorming`

### GREEN-3: Router Directs to Writing-Plans When Ready to Plan

**Given:** Agent is working on an existing ticket
**And:** Requirements are clear and complete
**And:** No implementation plan exists yet
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `writing-plans` skill
**And:** [ ] Router provides rationale: "Ready to create implementation plan"
**Result:** PASS - Correct skill recommended for planning phase

**Verification:**

- [ ] Ticket exists with clear requirements
- [ ] Recommendation is `writing-plans`

### GREEN-4: Router Directs to Systematic-Debugging for Bug Reports

**Given:** User reports unexpected behavior or a bug
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `systematic-debugging` skill
**And:** [ ] Router provides rationale: "Bug or unexpected behavior reported"
**Result:** PASS - Correct skill recommended for debugging

**Verification:**

- [ ] Recommendation is `systematic-debugging`
- [ ] Takes priority over other conditions (P2)

### GREEN-5: Router Directs to Receiving-Code-Review When PR Feedback Exists

**Given:** Agent has submitted a pull request
**And:** Reviewer has provided feedback comments
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `receiving-code-review` skill
**And:** [ ] Router provides rationale: "PR feedback received"
**Result:** PASS - Correct skill recommended for code review feedback

**Verification:**

- [ ] Recommendation is `receiving-code-review`
- [ ] Takes highest priority (P1)

### GREEN-6: Router Directs to TDD When Implementation Plan Exists

**Given:** Agent is working on an existing ticket
**And:** Implementation plan exists and is approved
**And:** Code changes are needed
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `test-driven-development` skill
**And:** [ ] Router provides rationale: "Implementation plan exists, code ready"
**Result:** PASS - Correct skill recommended for implementation

**Verification:**

- [ ] Implementation plan exists
- [ ] Recommendation is `test-driven-development`

### GREEN-7: Router Directs to Verification When Claiming Work Complete

**Given:** Agent has finished implementation
**And:** Agent is about to claim work is complete
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `verification-before-completion` skill
**And:** [ ] Router provides rationale: "Verify before claiming done"
**Result:** PASS - Correct skill recommended before completion

**Verification:**

- [ ] Work appears complete
- [ ] Recommendation is `verification-before-completion`

## PRESSURE Scenarios (Edge Cases)

These scenarios test that the router works correctly under ambiguous conditions:

### PRESSURE-1: Multiple Preconditions Match - Priority Order Respected

**Given:** Agent is debugging a bug (P2 condition)
**And:** No ticket exists yet (P3 condition)
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `systematic-debugging` skill (P2 wins)
**And:** [ ] Router does NOT recommend `requirements-gathering`
**Result:** PASS - Priority order correctly enforced

**Anti-pattern to avoid:** Recommending lower-priority skill when higher-priority matches

**Verification:**

- [ ] P2 (systematic-debugging) takes priority over P3 (requirements-gathering)
- [ ] Only one recommendation is provided

### PRESSURE-2: User Requests Direct Skill - Router Defers to Explicit Choice

**Given:** User explicitly says "use brainstorming skill"
**And:** Context suggests a different skill (e.g., no ticket exists)
**When:** Agent evaluates routing rules
**Then:** [ ] Router defers to user's explicit skill request
**And:** [ ] Router does NOT override user's choice
**Result:** PASS - User's explicit choice respected

**Anti-pattern to avoid:** Overriding explicit user skill requests

**Verification:**

- [ ] User's explicit request takes precedence
- [ ] Router provides recommendation but does not enforce

### PRESSURE-3: No Preconditions Match - Router Prompts for Clarification

**Given:** Agent is in an ambiguous state
**And:** No routing rule preconditions clearly match
**When:** Agent evaluates routing rules
**Then:** [ ] Router indicates "no clear match found"
**And:** [ ] Router prompts user for clarification
**And:** [ ] Router does NOT make arbitrary recommendation
**Result:** PASS - Graceful handling of unclear context

**Anti-pattern to avoid:** Making arbitrary recommendations when context is unclear

**Verification:**

- [ ] No forced recommendation
- [ ] Clear prompt for user clarification

## Priority Order Verification

These scenarios validate the P1-P7 priority ordering:

### PRIORITY-1: P1 (Code Review) Beats All Others

**Given:** PR feedback exists (P1)
**And:** Bug is also reported (P2)
**And:** No ticket exists (P3)
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `receiving-code-review` (P1)
**Result:** PASS - P1 takes highest priority

### PRIORITY-2: P2 (Debugging) Beats P3-P7

**Given:** Bug is reported (P2)
**And:** No ticket exists (P3)
**And:** Work appears complete (P7)
**When:** Agent evaluates routing rules
**Then:** [ ] Router recommends `systematic-debugging` (P2)
**Result:** PASS - P2 beats lower priorities

### PRIORITY-3: Full Priority Chain Respected

**Given:** Context with multiple matching conditions
**When:** Agent evaluates routing rules in priority order
**Then:** [ ] P1 (receiving-code-review) evaluated first
**And:** [ ] P2 (systematic-debugging) evaluated second
**And:** [ ] P3 (requirements-gathering) evaluated third
**And:** [ ] P4 (brainstorming) evaluated fourth
**And:** [ ] P5 (writing-plans) evaluated fifth
**And:** [ ] P6 (test-driven-development) evaluated sixth
**And:** [ ] P7 (verification-before-completion) evaluated last
**Result:** PASS - Full priority chain verified

## Success Criteria

When all GREEN scenarios pass:

- [ ] Agents receive correct skill recommendations based on context
- [ ] Priority order is respected when multiple conditions match
- [ ] User explicit choices are respected over automatic recommendations
- [ ] Ambiguous contexts prompt for clarification rather than guessing
- [ ] All process skills are covered by routing rules

## Test Execution Notes

**How to test:** Run these scenarios with an autonomous agent and verify outcomes

**RED scenarios:** Should currently fail (undesired behaviour exists)
**GREEN scenarios:** Should pass after skill implementation
**PRESSURE scenarios:** Validate router works under non-ideal conditions
**PRIORITY scenarios:** Validate P1-P7 ordering is enforced

**Evidence collection:** Each scenario should collect:

- Recommended skill name
- Rationale provided by router
- Context evaluation details
