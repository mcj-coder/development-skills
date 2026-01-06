# issue-driven-delivery - BDD Tests (RED)

## Baseline (No Skill Present)

### Pressure Scenario 1: "Just do it quickly"

Given a user says to implement a work item quickly without mentioning plans or approvals
When the agent responds without this skill
Then the agent skips committing a WIP plan and does not request comment approval

### Pressure Scenario 2: "Keep it local"

Given a user wants work tracked in a local checklist only
When the agent responds without this skill
Then the agent avoids using work item comments and sub-tasks for tracking

### Pressure Scenario 3: "We will fix it later"

Given a user asks to postpone review and evidence
When the agent responds without this skill
Then the agent omits role reviews and evidence in the work item chain

## Baseline Observations (Simulated)

Without the skill, a typical response rationalizes skipping work item workflow steps:

- "I will proceed and update the work item later."
- "We can keep the plan local to save time."
- "Sub-tasks are optional; I will track progress in my notes."
- "We can create the PR once everything is done."

## Assertions (Expected to Fail Until Skill Exists)

- Ticketing CLI is listed as a prerequisite in the skill (gh/ado/jira).
- A Taskboard work item exists before any changes (read-only and reviews excluded).
- Evidence is posted that required skills were applied for concrete changes
  before opening a PR.
- The workflow requires committing a WIP plan and posting a plan-link comment before execution.
- Plan approval is collected via a work item comment before sub-tasks are created.
- Each plan task maps to a work item sub-task (task list or sub-work-item).
- Evidence and reviews are attached to each sub-task.
- Sub-tasks close only after approval and plan task is marked complete.
- Role reviews are posted in the work item comment chain and summarized in the plan.
- Follow-up changes are new tasks in the same work item.
- Next steps create a new work item with implementation + test detail.
- A PR is created after acceptance.
- Work item state is updated through lifecycle (new feature → refinement → implementation → verification → complete).
- Work item is tagged with appropriate component (e.g., `skill` for skills repositories).
- State is set to `refinement` during planning.
- State is set to `implementation` after plan approval.
- State is set to `verification` when implementation complete.
- Work item cannot be closed without component tag.

## Approval Detection Scenarios

### Scenario 1: Terminal Approval Documentation

Given a user approves a plan verbally in the terminal session
When the agent receives terminal approval
Then the agent posts an explicit approval comment to the issue
And the comment format is "Approved [in terminal session]"
And approval is preserved in issue history for traceability

### Scenario 2: Reaction-Based Approval Recognition

Given a user adds a thumbs-up (👍) reaction to the plan comment
When the agent checks for approval signals
Then the agent recognizes the reaction as a valid approval
And posts an explicit approval comment "Approved [via 👍 reaction on plan comment]"
And proceeds with implementation

### Scenario 3: Approval Detection in Comment Thread

Given multiple comments exist in the issue thread
And one comment contains "approved" or "LGTM" keyword
When the agent checks for approval before requesting
Then the agent searches ALL comments (not just recent ones)
And detects the existing approval comment
And posts acknowledgment: "Approval detected in comment thread. Proceeding with implementation."
And does not request redundant approval

### BDD Verification Pressure Scenario

Given concrete changes are made (code, config, documentation files)
When agent prepares to open PR
Then agent must post applied evidence with commit SHAs and file links
And evidence must show skill was actually used in THIS repository

Given process-only work is performed (planning, reviews, requirements)
When agent prepares to complete work
Then analytical verification is acceptable with issue comment links
And evidence must state "This is analytical verification (process-only)"

## BDD Verification Test Cases

### RED: Concrete Changes Without Applied Evidence

**Setup:** Agent makes documentation changes
**Expected Behavior:** Skill requires applied evidence before PR
**Failure Without Skill:** Agent posts "Updated documentation" without commit SHA links

**Assertions:**
- Step 16 requires applied evidence for concrete changes
- Evidence must include commit SHAs
- Evidence must include file links
- References BDD checklist templates

### RED: Process-Only Work Treated as Concrete

**Setup:** Agent performs brainstorming in issue comments
**Expected Behavior:** Analytical verification acceptable
**Failure Without Skill:** Agent incorrectly requires commit evidence for planning

**Assertions:**
- Step 16 allows analytical verification for process-only
- Must state "This is analytical verification (process-only)"
- Evidence includes issue comment links
- References BDD checklist templates

### GREEN: Concrete Changes With Applied Evidence

**Setup:** Agent implements feature with TDD
**Expected Behavior:** Evidence shows failing test, implementation, passing test
**Success With Skill:** "TDD applied: failing test [SHA1], implementation [SHA2], passing [SHA3]"

**Assertions:**
- Applied evidence includes commit SHAs
- References actual files modified in repository
- Uses concrete changes checklist template
- Evidence is verifiable by inspection

### GREEN: Process-Only With Analytical Verification

**Setup:** Agent conducts requirements gathering in issue
**Expected Behavior:** Analytical verification documents process application
**Success With Skill:** "Analytical verification (process-only): requirements captured [link], alternatives explored [link]"

**Assertions:**
- States analytical verification explicitly
- Includes issue comment links
- Uses process-only checklist template
- No false claim of repository file modifications

## PR Requirement Enforcement Scenarios

### RED: Closing Issue Without PR

**Setup:** Agent completes verification and attempts to close work item
**Pressure:** "Verification is complete, so I can close it now."
**Expected Behavior:** Skill blocks closure until PR exists and is merged
**Failure Without Enforcement:** Agent closes issue immediately after verification

**Assertions:**

- Step 10a verifies PR exists and is merged before closing
- Error message displayed when attempting to close without merged PR
- Exception documented for read-only work

### RED: PR-Skipping Red Flag Detection

**Setup:** Agent considers closing issue without creating PR
**Pressure:** "I'll close the issue without creating a PR."
**Expected Behavior:** Agent recognizes this as a red flag and stops
**Failure Without Red Flag:** Agent proceeds with closure

**Assertions:**

- Red Flags section includes "I'll close the issue without creating a PR."
- Red Flags section includes "Verification is complete, so I can close it now."
- Agent stops when recognizing PR-skipping pattern

### RED: PR Rationalization Counter

**Setup:** Agent rationalizes skipping PR step
**Pressure:** "Changes are pushed, that's enough"
**Expected Behavior:** Rationalizations table counters this excuse
**Failure Without Rationalization:** Agent accepts "pushed = done" logic

**Assertions:**

- Rationalizations table includes "Verification complete means I can close"
- Rationalizations table includes "Changes are pushed, that's enough"
- Reality column explains PR provides review process and merge tracking

### GREEN: Proper Closure With Merged PR

**Setup:** Agent has merged PR and all verifications complete
**Expected Behavior:** Agent can close work item
**Success With Enforcement:** Work item closes only after confirming merged PR

**Assertions:**

- Step 10a checklist verifies merged PR
- Work item closes successfully when PR is merged
- Exception path works for read-only work
