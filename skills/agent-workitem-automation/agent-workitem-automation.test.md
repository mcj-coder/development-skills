# Agent Work Item Automation tests

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
