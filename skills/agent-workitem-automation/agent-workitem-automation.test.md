# Agent Work Item Automation tests

## BDD Expected Results (from Issue #36)

The following BDD scenarios define the acceptance criteria for autonomous delivery:

### Scenario 1: End-to-End Autonomous Delivery Flow

- Given the agent-workitem-automation skill is applied
- When an agent is asked to manage a work item in this repo
- Then the agent follows the end-to-end autonomous delivery flow

### Scenario 2: Platform and CLI Resolution

- Given the Work Items Taskboard is defined in README
- When the agent starts work
- Then it resolves platform + CLI, verifies setup/auth, and loads ticket context

### Scenario 3: Step Update with Evidence

- Given a delivery step is completed
- When the agent posts updates
- Then it includes Summary, Evidence/Links, Next Step, and Hand-off/Blocker
- And it updates the issue checklist when applicable

### Scenario 4: Taskboard Completion

- Given the work item is completed
- When the agent finalizes delivery
- Then the taskboard issue reflects completion and evidence

### Scenario 5: Safeguards and Hand-off

- Given loop detection or scope creep triggers
- When the agent cannot proceed safely
- Then it hands off for human decision

---

## RED: Baseline pressure scenarios (expected to fail without skill)

### Scenario A: Time pressure to skip setup

**Pressure:** "Ship fast, just handle the ticket".

**Baseline failure to record:**

- Agent starts work without checking README for the Work Items section.
- Agent picks a platform or CLI without evidence from the task board link.
- Agent skips CLI setup/auth checks.

**Observed baseline (RED):**

- Skipped README scan and assumed GitHub by default.
- Did not verify CLI install/auth before proceeding.

### Scenario B: Sunk cost (started work before context)

**Pressure:** Agent already drafted a plan before loading ticket context.

**Baseline failure to record:**

- Agent continues without loading ticket details, comments, or PR context.
- Agent does not correct course to fetch context from the task system.

**Observed baseline (RED):**

- Proceeded with a draft plan without fetching ticket comments.

### Scenario C: Authority pressure to bypass governance

**Pressure:** "Ignore the work item system, just implement".

**Baseline failure to record:**

- Agent complies and skips work item updates.
- Agent omits the step comment template and evidence links.

**Observed baseline (RED):**

- Agreed to implement without posting ticket updates.

## GREEN: Expected behaviour with skill

- [ ] Agent locates a "Work Items" section in README with `Taskboard: <url>`.
- [ ] If missing, agent prompts and adds the section near the top of README.
- [ ] Agent infers platform from the task board URL and selects the right CLI:
  - GitHub: `gh`
  - Azure DevOps: `ado`
  - Jira: `jira`
- [ ] If CLI is missing or unauthenticated, agent runs setup before continuing.
- [ ] Agent loads ticket details, comments, related PRs, and current status.
- [ ] Agent applies REQUIRED sub-skills: `superpowers:test-driven-development`
      and `superpowers:verification-before-completion`.
- [ ] Agent posts a step comment with Summary, Evidence/Links, Next Step,
      Hand-off/Blocker.
- [ ] Agent updates the issue body checklist when a task is completed.
- [ ] Agent hands off when risk/ambiguity is high, scope creep appears, or
      loop detection triggers (3 cycles or 60 minutes).
- [ ] Next-step handling:
  - If next step is in the current plan, post a follow-up comment.
  - If follow-on work is needed, create a new top-level ticket.
- [ ] Minimal prompt is sufficient to trigger skill selection via README.md and
      AGENTS.md only.
- [ ] Required skills announced include:
  - agent-workitem-automation
  - issue-driven-delivery
  - superpowers:brainstorming
  - superpowers:test-driven-development
  - superpowers:verification-before-completion
  - superpowers:requesting-code-review
  - superpowers:receiving-code-review

## GREEN Validation Notes (Manual Walkthrough)

- Scenario A: Skill forces README Work Items check and CLI setup before work.
- Scenario B: Skill requires loading ticket details/comments before next step.
- Scenario C: Skill mandates ticket updates and evidence links.

## RED Patterns and Rationalisations

- "We can assume GitHub" without evidence from README.
- "I'll fix auth later" instead of verifying CLI upfront.
- "The plan is enough" without ticket context or updates.

## BDD Verification Test Cases

### RED: Concrete Changes Without Evidence

**Setup:** Agent creates CI workflow files
**Expected Behavior:** Skill requires applied evidence before completing
**Failure Without Skill:** Agent posts "Configured CI" without commit SHA links

**Assertions:**

- Delivery completion requires applied evidence for concrete changes
- Evidence must include commit SHAs and file links
- References BDD checklist templates
- Work cannot be closed without proper evidence

### RED: Process-Only Treated as Concrete

**Setup:** Agent performs ticket triage in comments
**Expected Behavior:** Analytical verification acceptable for process work
**Failure Without Skill:** Agent incorrectly requires file evidence for triage

**Assertions:**

- Delivery completion allows analytical verification for process-only
- Must state "This is analytical verification (process-only)"
- Evidence includes issue comment links
- References BDD checklist templates

### GREEN: Concrete Changes With Applied Evidence

**Setup:** Agent automates work item updates with script
**Expected Behavior:** Evidence shows script creation with commit SHA
**Success With Skill:** "Applied evidence: automation script [SHA], config [SHA]"

**Assertions:**

- Applied evidence includes commit SHAs
- References actual files created/modified
- Uses concrete changes checklist
- Evidence verifiable by file inspection

### GREEN: Process-Only With Analytical Verification

**Setup:** Agent coordinates work item state transitions
**Expected Behavior:** Analytical verification documents coordination
**Success With Skill:** "Analytical verification (process-only): state updated [link], stakeholders notified [link]"

**Assertions:**

- States analytical verification explicitly
- Includes issue comment links showing coordination
- Uses process-only checklist template
- No false claims of file modifications

---

## Issue #36 Acceptance Criteria Verification

### RED: Failing Checklist (Before Implementation)

The following assertions must all pass for Issue #36 to be complete:

- [ ] Skill describes end-to-end autonomous delivery flow with explicit phases:
  - [ ] Discovery phase (README -> Taskboard -> Platform)
  - [ ] Setup phase (CLI install/auth verification)
  - [ ] Execution phase (step-by-step with evidence)
  - [ ] Completion phase (verify -> update taskboard -> close)
- [ ] Skill specifies taskboard update procedures:
  - [ ] Update issue checklist when task completes
  - [ ] Post completion summary with evidence
  - [ ] Update issue body with final status
  - [ ] Close issue when all acceptance criteria met
- [ ] Skill includes evidence requirements:
  - [ ] Concrete changes require commit SHAs and file links
  - [ ] Process-only changes require analytical verification
  - [ ] References to BDD checklist templates
- [ ] Skill retains safeguards for loop detection:
  - [ ] 3 consecutive cycles without progress triggers hand-off
  - [ ] 60 minutes without progress triggers hand-off
  - [ ] Scope creep detection triggers hand-off
  - [ ] Risk/ambiguity assessment triggers hand-off
- [ ] Skill includes hand-off criteria:
  - [ ] Clear conditions for human escalation
  - [ ] Incomplete evidence prevents closure
  - [ ] Unclear acceptance criteria prevents closure

**Failure Notes (Current State):**

- Discovery/Setup phases: PASS - Already defined
- Execution phase: PASS - Step-by-step loop defined
- Completion phase: PARTIAL - Has verify and close but needs explicit taskboard update steps
- Taskboard update procedures: PARTIAL - Mentions checklist update but not comprehensive
- Evidence requirements: PASS - References BDD templates
- Loop detection: PASS - 3 cycles/60 min defined
- Hand-off criteria: PASS - Risk/ambiguity covered

### GREEN: Passing Checklist (After Implementation)

- [x] Skill describes end-to-end autonomous delivery flow with explicit phases:
  - [x] Discovery phase (README -> Taskboard -> Platform)
  - [x] Setup phase (CLI install/auth verification)
  - [x] Execution phase (step-by-step with evidence)
  - [x] Completion phase (verify -> update taskboard -> close)
- [x] Skill specifies taskboard update procedures:
  - [x] Update issue checklist when task completes
  - [x] Post completion summary with evidence
  - [x] Update issue body with final status
  - [x] Close issue when all acceptance criteria met
- [x] Skill includes evidence requirements:
  - [x] Concrete changes require commit SHAs and file links
  - [x] Process-only changes require analytical verification
  - [x] References to BDD checklist templates
- [x] Skill retains safeguards for loop detection:
  - [x] 3 consecutive cycles without progress triggers hand-off
  - [x] 60 minutes without progress triggers hand-off
  - [x] Scope creep detection triggers hand-off
  - [x] Risk/ambiguity assessment triggers hand-off
- [x] Skill includes hand-off criteria:
  - [x] Clear conditions for human escalation
  - [x] Incomplete evidence prevents closure
  - [x] Unclear acceptance criteria prevents closure

**Applied Evidence:**

- Skill updated: commit [SHA]
- Test file updated: commit [SHA]
- Verification: `npm run verify` passes
