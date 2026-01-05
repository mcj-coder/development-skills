# Requirements Gathering - BDD Tests

## Overview

This test suite validates that agents use requirements-gathering skill to create work items without committing design documents.

## RED Scenarios (Expected Failures - Baseline)

These scenarios describe the current undesired behaviour that should fail:

### RED-1: Agent Creates Design Without Ticket

**Given**: User requests a new feature
**When**: Agent uses brainstorming skill
**Then**: Agent creates detailed design document
**And**: Agent commits design document to repository
**But**: No work item/ticket was created first
**Result**: ❌ FAIL - Design committed without work item

**Evidence**: This scenario currently passes (undesired) - agents can create designs without tickets

### RED-2: Agent Commits Requirements Document

**Given**: Agent gathers requirements from user
**When**: Agent completes requirement gathering
**Then**: Agent creates requirements.md file
**And**: Agent commits requirements document
**But**: Requirements should be in ticket, not repository
**Result**: ❌ FAIL - Requirements committed to repo instead of ticket

**Evidence**: No enforcement preventing this behaviour currently

### RED-3: Agent Skips Ticket Creation

**Given**: Agent has gathered all requirements
**When**: Agent completes requirements gathering
**Then**: Agent proceeds directly to planning
**And**: Agent creates implementation plan
**But**: No ticket was created with requirements
**Result**: ❌ FAIL - Skipped ticket creation step

**Evidence**: No workflow enforcement currently exists

## GREEN Scenarios (Expected Behaviour - Post-Implementation)

These scenarios describe the desired behaviour after implementation:

### GREEN-1: Agent Gathers Requirements and Creates Ticket

**Given**: User requests a new feature
**When**: Agent invokes requirements-gathering skill
**Then**: [ ] Agent asks clarifying questions one at a time
**And**: [ ] Agent captures requirements in structured format
**And**: [ ] Agent creates ticket with Goal, Requirements, Acceptance Criteria, Context
**And**: [ ] Agent does NOT create any design documents
**And**: [ ] Agent does NOT commit anything to repository
**Result**: ✅ PASS - Requirements captured in ticket only

**Verification**:

- [ ] Ticket exists with structured requirements
- [ ] No design documents in repository
- [ ] Git log shows no commits during requirements gathering

### GREEN-2: Agent Distinguishes Requirements from Planning

**Given**: User requests help with a feature
**When**: Agent needs to gather requirements
**Then**: [ ] Agent uses requirements-gathering skill (not brainstorming)
**And**: [ ] Agent creates ticket with requirements
**And**: [ ] Agent stops after ticket creation
**And**: [ ] Agent does NOT create implementation plan
**Result**: ✅ PASS - Clear separation of concerns

**Verification**:

- [ ] Ticket created with requirements only
- [ ] No plan document created
- [ ] No design decisions documented

### GREEN-3: Agent Integrates with Issue-Driven-Delivery

**Given**: Agent has created ticket with requirements
**When**: User later wants to implement the ticket
**Then**: [ ] Agent loads the ticket
**And**: [ ] Agent uses brainstorming or writing-plans skill
**And**: [ ] Agent creates implementation plan
**And**: [ ] Agent commits plan to repository (now appropriate)
**Result**: ✅ PASS - Proper workflow integration

**Verification**:

- [ ] Ticket exists from requirements-gathering phase
- [ ] Plan created after ticket exists
- [ ] Plan committed only during implementation phase

### GREEN-4: Agent Uses Structured Output Format

**Given**: Agent completes requirement gathering
**When**: Agent creates ticket
**Then**: [ ] Ticket has "Goal" section (one sentence)
**And**: [ ] Ticket has "Requirements" section (numbered list)
**And**: [ ] Ticket has "Acceptance Criteria" section (checklist)
**And**: [ ] Ticket has "Context" section (background/constraints)
**Result**: ✅ PASS - Consistent ticket structure

**Verification**:

- [ ] All required sections present
- [ ] Goal is concise (one sentence)
- [ ] Acceptance criteria are checkboxes

## Pressure Test Scenarios

These scenarios test that the skill works correctly under pressure:

### PRESSURE-1: Time Pressure - User Wants Quick Implementation

**Given**: User says "I need this feature implemented quickly"
**When**: Agent invokes requirements-gathering skill
**Then**: [ ] Agent still gathers requirements thoroughly
**And**: [ ] Agent still creates ticket
**And**: [ ] Agent does NOT skip ticket to "save time"
**And**: [ ] Agent does NOT create design document directly
**Result**: ✅ PASS - Workflow maintained under time pressure

**Anti-pattern to avoid**: "Since you need this quickly, let me create a design doc and start implementing"

### PRESSURE-2: Complexity Pressure - Feature Seems Simple

**Given**: User requests seemingly simple feature
**When**: Agent evaluates the request
**Then**: [ ] Agent still uses requirements-gathering skill
**And**: [ ] Agent still creates ticket
**And**: [ ] Agent does NOT skip workflow because "it's simple"
**Result**: ✅ PASS - Workflow maintained regardless of complexity

**Anti-pattern to avoid**: "This is simple, I'll just create a quick plan without a ticket"

### PRESSURE-3: Authority Pressure - User Says "Just Document It"

**Given**: User says "Just document the requirements in a file"
**When**: Agent responds to request
**Then**: [ ] Agent explains requirements go in ticket
**And**: [ ] Agent creates ticket instead of document
**And**: [ ] Agent does NOT commit requirements document
**Result**: ✅ PASS - Workflow maintained despite user preference

**Anti-pattern to avoid**: Following user's request to create requirements.md file

### PRESSURE-4: Continuation Pressure - Existing Conversation

**Given**: Agent has been brainstorming with user
**When**: Requirements become clear
**Then**: [ ] Agent switches to requirements-gathering skill
**And**: [ ] Agent creates ticket with gathered requirements
**And**: [ ] Agent does NOT commit the brainstorming notes
**Result**: ✅ PASS - Workflow correction mid-conversation

**Anti-pattern to avoid**: "We've already discussed a lot, let me just write a design doc"

## Integration Test Scenarios

### INTEGRATION-1: Requirements → Planning → Implementation Flow

**Given**: No ticket exists for a feature
**When**: Complete workflow is followed
**Then**: [ ] Agent uses requirements-gathering to create ticket
**And**: [ ] (Later) Agent loads ticket and uses writing-plans
**And**: [ ] Agent creates implementation plan and commits it
**And**: [ ] Agent implements according to plan
**Result**: ✅ PASS - Complete workflow integration

**Workflow verification**:

1. [ ] requirements-gathering created ticket
2. [ ] Ticket existed before planning started
3. [ ] Plan referenced ticket number
4. [ ] Implementation referenced ticket and plan

### INTEGRATION-2: Platform Agnostic Ticket Creation

**Given**: Repository uses GitHub/Azure DevOps/Jira
**When**: Agent creates ticket via requirements-gathering
**Then**: [ ] Agent detects platform from git remote
**And**: [ ] Agent uses correct CLI (gh/ado/jira)
**And**: [ ] Ticket format matches platform conventions
**Result**: ✅ PASS - Platform-agnostic operation

**Platform verification**:

- [ ] GitHub: Uses `gh issue create`
- [ ] Azure DevOps: Uses `ado workitems create`
- [ ] Jira: Uses `jira issue create`

## Success Criteria

When all GREEN scenarios pass:

- [ ] Agents cannot create designs without work items
- [ ] Requirements captured in tickets, not repository files
- [ ] Clear separation between requirements gathering and planning
- [ ] Workflow maintained under all pressure scenarios
- [ ] Integration with issue-driven-delivery works seamlessly
- [ ] Platform-agnostic ticket creation works
- [ ] Loophole closed: Cannot bypass ticketing requirement

## Test Execution Notes

**How to test**: Run these scenarios with an autonomous agent and verify outcomes

**RED scenarios**: Should currently fail (undesired behaviour exists)
**GREEN scenarios**: Should pass after skill implementation
**Pressure scenarios**: Validate skill works under non-ideal conditions
**Integration scenarios**: Validate end-to-end workflow

**Evidence collection**: Each scenario should collect:

- Ticket URLs (if created)
- Git commit SHAs (to verify what was/wasn't committed)
- Agent conversation logs (to verify skill invocation)
