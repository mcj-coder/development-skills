# Implementation Plan: Issue #75 - Improve Approval Detection and Documentation

## Overview

Enhance the issue-driven-delivery workflow to handle terminal approvals, reaction-based
approvals, and improve approval detection in comment threads.

## Problem Statement

Current workflow requires explicit approval comment with word "approved", but:

- Terminal approvals (user says "approved" in CLI) aren't documented in issue
- Reaction-based approvals (👍 on plan comment) aren't recognized
- Agents may miss approval comments in long threads

This was discovered in Issue #74 where agent didn't initially recognize approval in comment chain.

## Scope

### In Scope

1. Update Step 5 in SKILL.md to include terminal approval documentation
2. Add reaction-based approval recognition guidance
3. Improve approval detection logic in Step 5
4. Add examples for approval detection commands
5. Update Red Flags and Common Mistakes sections
6. Update Rationalizations table with approval-related entries
7. Add BDD test scenarios for approval detection

### Out of Scope

- Automated approval detection (requires GitHub API integration)
- GraphQL implementation for reaction checking
- Modifications to other workflow steps beyond Step 5

## Tasks

### Task 1: Update Step 5 in SKILL.md with Enhanced Approval Logic

Files: `skills/issue-driven-delivery/SKILL.md`

Changes:

- Replace current Step 5 (line 219) with enhanced version
- Include three sub-steps (5a, 5b, 5c) for:
  - Terminal approval documentation
  - Reaction-based approval handling
  - Comprehensive approval detection before requesting

Acceptance Criteria:

- Step 5 contains all three sub-steps
- Each sub-step has clear guidance and examples
- Approval formats documented: "approved", "LGTM", "go ahead", "approved to proceed"
- Commands for posting approval comments provided

### Task 2: Add Approval Detection Examples

Files: `skills/issue-driven-delivery/SKILL.md`

Changes:

- Add bash code examples in Step 5 showing:
  - How to check all comments for approval keywords
  - How to check for reactions (GraphQL API approach)
  - Conditional logic for proceeding when approval found

Acceptance Criteria:

- Code examples are executable and platform-agnostic
- GraphQL limitation documented with workaround
- Examples show checking ALL comments, not just recent ones

### Task 3: Update Common Mistakes Section

Files: `skills/issue-driven-delivery/SKILL.md`

Changes:

- Add new mistakes related to approval detection:
  - "Not documenting terminal approvals in issue comments"
  - "Missing approval comments in long threads"
  - "Not checking for reactions as approval signals"
  - "Requesting approval when it already exists in comments"

Acceptance Criteria:

- At least 4 new approval-related mistakes added
- Mistakes are clear and actionable
- Placed in logical order within existing list (lines 361-387)

### Task 4: Update Red Flags Section

Files: `skills/issue-driven-delivery/SKILL.md`

Changes:

- Add new red flags:
  - "User approved verbally, that's enough"
  - "The approval is somewhere in the comments, I'll assume it's there"
  - "Reactions don't count as real approval"

Acceptance Criteria:

- At least 3 new approval-related red flags added
- Red flags are phrased as problematic statements
- Placed in logical order within existing list (lines 388-408)

### Task 5: Update Rationalizations Table

Files: `skills/issue-driven-delivery/SKILL.md`

Changes:

- Add new rows to Rationalizations table:
  - "Verbal approval is sufficient" -> "All approvals must be documented in issue comments"
  - "I'll just ask for approval again" -> "Check all existing comments first before requesting"
  - "Reactions are informal" -> "thumbs-up reactions are valid approval signals requiring documentation"

Acceptance Criteria:

- At least 3 new approval-related rationalizations added
- Format matches existing table structure (lines 409-426)
- Reality column provides clear corrective guidance

### Task 6: Add BDD Test Scenarios

Files: `skills/issue-driven-delivery/issue-driven-delivery.test.md`

Changes:

- Add new test scenario: "Approval Detection in Comment Thread"
- Add new test scenario: "Terminal Approval Documentation"
- Add new test scenario: "Reaction-Based Approval Recognition"

Acceptance Criteria:

- Three new BDD scenarios added following existing format
- Each scenario has Given/When/Then structure
- Scenarios cover all three approval types (comment, terminal, reaction)
- Scenarios test both detection and documentation behaviors

### Task 7: Verification and Documentation

Files: Multiple

Changes:

- Run all existing BDD tests to ensure no regressions
- Verify markdown formatting with markdownlint
- Check that all internal links still work
- Validate that changes align with issue requirements

Acceptance Criteria:

- All existing tests pass
- No markdown linting errors
- All acceptance criteria from issue #75 are met
- Changes are backwards compatible

## Implementation Approach

1. **Read-first strategy:** Read all relevant files before making changes
2. **Minimal edits:** Use Edit tool to make targeted changes to existing content
3. **Test-driven:** Add BDD tests before updating documentation
4. **Validation:** Run linters and tests after each major change
5. **Evidence:** Commit each task separately with clear messages

## Dependencies

- None (self-contained changes to issue-driven-delivery skill)

## Risks and Mitigations

| Risk                              | Impact | Mitigation                                                         |
| --------------------------------- | ------ | ------------------------------------------------------------------ |
| Breaking existing workflow        | High   | Test all existing scenarios, ensure backward compatibility         |
| GraphQL API unavailable           | Medium | Document limitation and provide workaround guidance                |
| Confusion about approval priority | Medium | Clearly order approval detection logic (check first, then request) |

## Testing Strategy

1. Run existing BDD test suite: `skills/issue-driven-delivery/issue-driven-delivery.test.md`
2. Add new BDD scenarios for approval detection
3. Manual verification: Check that all examples are executable
4. Markdown linting: Ensure no formatting issues introduced

## Acceptance Criteria

All items from issue #75:

- [ ] Step 5 updated to include terminal approval documentation
- [ ] Step 5 updated to recognize thumbs-up reactions
- [ ] Step 5 updated to search all comments before asking
- [ ] Approval detection logic documented
- [ ] Example commands for posting approval comments
- [ ] Red Flags: "User approved verbally, that's enough"
- [ ] Common Mistakes: "Not documenting terminal approvals in issue"
- [ ] Rationalizations table updated

## Timeline Estimate

- Task 1: 30 minutes (core SKILL.md update)
- Task 2: 20 minutes (examples)
- Task 3: 15 minutes (Common Mistakes)
- Task 4: 10 minutes (Red Flags)
- Task 5: 10 minutes (Rationalizations)
- Task 6: 30 minutes (BDD tests)
- Task 7: 20 minutes (verification)

Total: ~2.5 hours

## Success Metrics

1. All acceptance criteria from issue #75 are met
2. All existing BDD tests continue to pass
3. New BDD scenarios validate approval detection
4. No markdown linting errors
5. Documentation is clear and actionable for agents

## Notes

- This change is documentation-only (no code implementation)
- Focus is on agent guidance, not automation
- GraphQL API for reactions is aspirational (documented limitation)
- Changes should work across all supported platforms (GitHub, Azure DevOps, Jira)
