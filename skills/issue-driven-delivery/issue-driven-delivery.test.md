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
