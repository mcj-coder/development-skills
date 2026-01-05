# github-issue-driven-delivery - BDD Tests (RED)

## Baseline (No Skill Present)

### Pressure Scenario 1: "Just do it quickly"

Given a user says to implement an issue quickly without mentioning plans or approvals
When the agent responds without this skill
Then the agent skips committing a WIP plan and does not request issue-comment approval

### Pressure Scenario 2: "Keep it local"

Given a user wants work tracked in a local checklist only
When the agent responds without this skill
Then the agent avoids using issue comments and sub-tasks for tracking

### Pressure Scenario 3: "We will fix it later"

Given a user asks to postpone review and evidence
When the agent responds without this skill
Then the agent omits persona reviews and evidence in the issue chain

## Baseline Observations (Simulated)

Without the skill, a typical response rationalizes skipping issue workflow steps:

- "I will proceed and update the issue later."
- "We can keep the plan local to save time."
- "Sub-tasks are optional; I will track progress in my notes."
- "We can create the PR once everything is done."

## Assertions (Expected to Fail Until Skill Exists)

- gh is listed as a prerequisite in the skill.
- A Taskboard issue exists before any changes (read-only and reviews excluded).
- Evidence is posted that required skills were applied for concrete changes
  before opening a PR.
- The workflow requires committing a WIP plan and posting a plan-link comment before execution.
- Plan approval is collected via an issue comment before sub-tasks are created.
- Each plan task maps to an issue sub-task (task list or sub-issue).
- Evidence and reviews are attached to each sub-task.
- Sub-tasks close only after approval and plan task is marked complete.
- Persona reviews are posted in the issue comment chain and summarized in the plan.
- Follow-up changes are new tasks in the same issue.
- Next steps create a new issue with implementation + test detail.
- A PR is created after acceptance.
