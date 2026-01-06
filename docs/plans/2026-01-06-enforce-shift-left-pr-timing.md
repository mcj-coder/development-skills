# Implementation Plan: Enforce SHIFT LEFT - PRs only after verification and role-based reviews

**Issue:** #77
**Date:** 2026-01-06
**Status:** WIP - Awaiting Approval

## Problem Statement

Current workflow allows PRs to be opened before verification and role-based reviews are
complete, violating SHIFT LEFT principles. This creates pressure to approve PRs prematurely
and undermines thorough review processes.

**Example violation (Issue #74):**

1. Implementation completed
2. PR #76 opened immediately
3. Verification started AFTER PR opened
4. Role-based reviews done AFTER PR opened

**Correct SHIFT LEFT workflow:**

1. Implementation completed
2. QA Engineer verification (acceptance criteria)
3. Role-based reviews (Skill Author, Documentation Expert, etc.)
4. Post all evidence to issue
5. THEN open PR (after verification/reviews complete)
6. PR approval (evidence already exists)
7. Merge

## Root Cause

The `finishing-a-development-branch` skill (referenced in issue) doesn't exist yet in this
repository, and the `issue-driven-delivery` skill allows PR creation at step 15 without
explicit verification checkpoint enforcement.

## Solution Design

### 1. Create finishing-a-development-branch Skill

This skill will be invoked after implementation and testing complete, guiding developers
through the proper workflow for completing a development branch.

**Key features:**

- Check verification requirements based on change type
- Block PR creation until verification/reviews complete
- Provide clear guidance on what needs to be done before PR
- Support different change types (skills, docs, code)

### 2. Update issue-driven-delivery Skill

Add explicit SHIFT LEFT enforcement at critical workflow points:

- Step 8c: Clarify verification happens before PR
- New step 11.5: Create PR only after verification/reviews complete
- Update Red Flags, Common Mistakes, Rationalizations

### 3. Add Comprehensive Guidance

Provide clear patterns, anti-patterns, and enforcement mechanisms to prevent violations.

## Tasks

### Task 1: Create finishing-a-development-branch Skill

**Acceptance criteria:**

- Skill file created at `skills/finishing-a-development-branch/SKILL.md`
- Includes verification checkpoint that checks for:
  - Skill modifications (requires Skill Author review)
  - Documentation changes (requires Documentation Expert review)
  - Custom requirements from issue
- Blocks PR creation with clear message when verification pending
- Provides actionable guidance on completing verification
- Includes test scenarios in `finishing-a-development-branch.test.md`

**Implementation details:**

- Create skill structure following existing skill patterns
- Add verification checkpoint logic before presenting PR option
- Include examples of correct and incorrect workflows
- Add Common Mistakes and Red Flags specific to PR timing

**Files to create:**

- `skills/finishing-a-development-branch/SKILL.md`
- `skills/finishing-a-development-branch/finishing-a-development-branch.test.md`

### Task 2: Update issue-driven-delivery Skill - Step 8c Clarification

**Acceptance criteria:**

- Step 8c explicitly states "Do not open PR yet"
- Clear guidance that verification happens before PR creation
- References finishing-a-development-branch skill for next steps

**Implementation details:**

- Update step 8c in `skills/issue-driven-delivery/SKILL.md`
- Add note that verification and role-based reviews must complete first
- Reference finishing-a-development-branch skill as the proper next step

**Files to modify:**

- `skills/issue-driven-delivery/SKILL.md` (line ~251)

### Task 3: Update issue-driven-delivery Skill - Add Step 11.5

**Acceptance criteria:**

- New step 11.5 added after role-based reviews
- Explicitly requires verification/reviews complete before PR
- References evidence posting requirements
- Clear statement that PR creation is the final step

**Implementation details:**

- Insert new step between current step 11 and step 15
- Renumber subsequent steps
- Add clear guidance on evidence requirements
- Link to finishing-a-development-branch skill

**Files to modify:**

- `skills/issue-driven-delivery/SKILL.md` (insert after line ~283)

### Task 4: Add Red Flags for PR Timing Violations

**Acceptance criteria:**

- Red Flags section updated with PR-timing violations
- Three specific red flags added per issue requirements
- Clear and actionable warning statements

**Implementation details:**

- Add to Red Flags section in `skills/issue-driven-delivery/SKILL.md`:
  - "I'll open the PR now and get reviews later"
  - "PR can be in draft while verification happens"
  - "Reviews can happen during PR review"

**Files to modify:**

- `skills/issue-driven-delivery/SKILL.md` (line ~388-408)

### Task 5: Add Common Mistakes for Verification Timing

**Acceptance criteria:**

- Common Mistakes section updated with verification timing
- Three specific mistakes added per issue requirements
- Describes consequence of each mistake

**Implementation details:**

- Add to Common Mistakes section in `skills/issue-driven-delivery/SKILL.md`:
  - Opening PR before verification complete (violates SHIFT LEFT)
  - Opening PR before role-based reviews (missing critical feedback)
  - Using "draft PR" as excuse to skip pre-PR verification

**Files to modify:**

- `skills/issue-driven-delivery/SKILL.md` (line ~362-387)

### Task 6: Add Rationalizations Table

**Acceptance criteria:**

- Rationalizations section updated with SHIFT LEFT excuses
- Three excuse/reality pairs added per issue requirements
- Clear explanation of why each excuse is invalid

**Implementation details:**

- Add to Rationalizations section in `skills/issue-driven-delivery/SKILL.md`:
  - "Draft PR is fine before verification" → PR creates merge pressure
  - "Reviews can happen in PR comments" → SHIFT LEFT means finding issues before PR
  - "Opening PR early shows progress" → Progress shown via work item state

**Files to modify:**

- `skills/issue-driven-delivery/SKILL.md` (line ~409-426)

### Task 7: Create Test Scenarios for finishing-a-development-branch

**Acceptance criteria:**

- Test file covers verification checkpoint scenarios
- Tests for skill modifications
- Tests for documentation changes
- Tests for blocking PR when verification pending
- Tests for successful PR creation after verification

**Implementation details:**

- Create BDD-style test scenarios
- Cover both happy path and blocking scenarios
- Include examples of required role reviews

**Files to create:**

- `skills/finishing-a-development-branch/finishing-a-development-branch.test.md`

## Verification Plan

### QA Engineer Verification

**Acceptance criteria verification:**

- [ ] All 6 tasks complete with files modified/created
- [ ] finishing-a-development-branch skill blocks PR when verification pending
- [ ] issue-driven-delivery skill has clear SHIFT LEFT guidance
- [ ] Red Flags include all 3 PR-timing violations
- [ ] Common Mistakes include all 3 verification timing mistakes
- [ ] Rationalizations include all 3 excuse/reality pairs
- [ ] Test scenarios cover verification checkpoint logic

**Functional testing:**

- Simulate finishing implementation with skill changes (should block PR)
- Simulate finishing implementation with docs changes (should block PR)
- Simulate finishing implementation with verification complete (should allow PR)
- Verify issue-driven-delivery workflow guidance is clear

### Role-Based Reviews Required

**Skill Author review:**

- Review finishing-a-development-branch skill for correctness
- Verify skill follows existing patterns and conventions
- Check that verification checkpoint logic is sound
- Confirm test scenarios are comprehensive

**Documentation Expert review:**

- Review clarity of SHIFT LEFT guidance
- Verify Red Flags, Common Mistakes, Rationalizations are clear
- Check that workflow steps are unambiguous
- Confirm examples are helpful

## Success Criteria

- [ ] finishing-a-development-branch skill created with verification checkpoint
- [ ] issue-driven-delivery skill updated with SHIFT LEFT enforcement
- [ ] Red Flags updated (3 items)
- [ ] Common Mistakes updated (3 items)
- [ ] Rationalizations updated (3 items)
- [ ] All verification tests pass
- [ ] Skill Author review complete with no critical issues
- [ ] Documentation Expert review complete with no critical issues
- [ ] Evidence posted to issue #77
- [ ] PR created AFTER all verification/reviews complete
- [ ] PR approved by Tech Lead
- [ ] Changes merged to main

## Risks and Mitigations

**Risk:** finishing-a-development-branch skill may not integrate well with existing workflows
**Mitigation:** Follow existing skill patterns; review with Skill Author before finalization

**Risk:** Developers may find verification checkpoint too restrictive
**Mitigation:** Provide clear guidance and examples; SHIFT LEFT benefits outweigh inconvenience

**Risk:** Test scenarios may not cover all edge cases
**Mitigation:** Review with QA Engineer; iterate based on feedback

## Timeline

- Task 1: 45 minutes (skill creation)
- Task 2-6: 30 minutes (updates to issue-driven-delivery)
- Task 7: 30 minutes (test scenarios)
- Verification: 30 minutes
- Reviews: 30 minutes
- Total: ~3 hours

## Dependencies

None - this is a self-contained enhancement to existing skills.

## Follow-up Work

Potential follow-up work (out of scope for this issue):

- Add automation to detect PR creation before verification
- Create dashboard showing verification status
- Add metrics tracking SHIFT LEFT compliance
