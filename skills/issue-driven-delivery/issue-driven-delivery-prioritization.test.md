# Issue-Driven Delivery Prioritization - BDD Tests

## Overview

This test file validates the work item prioritization rules added to the issue-driven-delivery skill.
Tests follow the RED-GREEN-PRESSURE pattern.

## RED Scenarios (Baseline Without Enhancement)

These scenarios demonstrate failures that occur without prioritization rules.

### RED 1: Agent picks low priority over high priority

#### Given

Queue has P1 and P2 work items

```text
#100 (P2, unblocked, state:new-feature) - Add nice-to-have feature
#101 (P1, unblocked, state:new-feature) - Fix critical bug
```

#### When

Agent selects work without checking priority

#### Then

Agent might pick #100 before #101

**Expected failure:** No prioritization guidance, agent may select randomly or by issue number

**Why this fails:** Without explicit priority rules, agent has no guidance on which work item to select
first.

---

### RED 2: Agent starts new work while in-progress work exists

#### Given

Work item in state:implementation, unassigned (abandoned)

```text
#200 (P1, state:new-feature, unassigned) - New feature
#201 (P2, state:implementation, unassigned) - Partially implemented feature
```

#### When

Agent picks state:new-feature work item

#### Then

Agent selects #200, leaving #201 unfinished

**Expected failure:** No "finish started work" rule, in-progress work remains abandoned

**Why this fails:** Agent doesn't know to prioritize completing in-flight work over starting new work.

---

### RED 3: Agent proceeds with blocked work

#### Given

Work item has blocked label without approval

```text
#300 (P1, blocked, state:new-feature)
Comment: "Blocked waiting for client API key approval"
```

#### When

Agent attempts self-assignment

#### Then

Agent proceeds without checking for approval

**Expected failure:** No blocked enforcement, agent starts work that cannot be completed

**Why this fails:** Without blocked enforcement checks, agent ignores blocking conditions and wastes
effort.

---

### RED 4: Circular dependency causes deadlock

#### Given

A blocks B, B blocks A

```text
#400 (P1, blocked by #401) - Refactor Module A
#401 (P1, blocked by #400) - Refactor Module B
```

#### When

Agent analyzes dependencies

#### Then

Both remain blocked indefinitely

**Expected failure:** No circular dependency resolution, deadlock persists

**Why this fails:** Without detection and resolution algorithm, circular dependencies create permanent
deadlock.

---

## GREEN Scenarios (With Enhancement)

These scenarios demonstrate correct behavior with prioritization rules.

### GREEN 1: Priority ordering enforced

#### Given

Queue has #100 (P2), #101 (P1), #102 (P3)

```text
#100 (P2, unblocked, state:new-feature) - Medium priority
#101 (P1, unblocked, state:new-feature) - High priority
#102 (P3, unblocked, state:new-feature) - Low priority
```

#### When

Agent applies prioritization rules

#### Then

Selects #101 (P1 first)

**Success criteria:**

- Agent checks priority labels on all work items
- Agent selects work item with highest priority (lowest P number)
- Evidence: Command shows priority filtering or explicit priority comparison

---

### GREEN 2: Finish started work first

#### Given

Queue has new and in-progress work

```text
#200 (P1, state:new-feature, unassigned) - New work, high priority
#201 (P2, state:implementation, unassigned) - In-progress work, medium priority
```

#### When

Agent applies prioritization

#### Then

Selects #201 (finish what's started)

**Success criteria:**

- Agent searches for unassigned work in progress states (refinement, implementation, verification)
- Agent prioritizes in-progress work over new work
- Exception: Only P0 production incidents override this rule
- Evidence: Command shows state filtering or explicit state check

---

### GREEN 3: Blocked work rejected without approval

#### Given

Work item blocked without approval

```text
#300 (P1, blocked, state:new-feature)
Comment: "Blocked waiting for client approval"
No approval comment exists
```

#### When

Agent attempts self-assignment

#### Then

- Agent stops with ERROR
- Error message shows blocking reason
- Agent waits for approval

**Success criteria:**

- Agent checks for `blocked` label before self-assignment
- Agent searches comments for approval ("approved to proceed" or "unblocked")
- Agent displays blocking comment in error message
- Agent does not proceed

**Expected error message:**

```text
ERROR: Cannot self-assign blocked work item #300
Blocking reason: "Blocked waiting for client approval"
Requires explicit approval comment to proceed.
```

---

### GREEN 4: Blocked work auto-unblocked when approved

#### Given

Work item blocked, user approves

```text
#400 (P1, blocked, state:new-feature)
Comment 1: "Blocked waiting for client approval"
Comment 2 (user): "approved to proceed"
```

#### When

Agent attempts self-assignment

#### Then

- Agent finds approval comment
- Agent automatically removes `blocked` label
- Agent proceeds with assignment
- Agent logs: "Blocked label removed after approval"

**Success criteria:**

- Agent detects approval comment
- Agent removes `blocked` label before proceeding
- Agent adds comment documenting label removal
- Agent successfully self-assigns

---

### GREEN 5: Auto-unblock on blocker completion

#### Given

Work item blocked by single blocker

```text
#500 (P1, state:implementation) - Blocking work item
#501 (P2, blocked, state:new-feature) - Blocked work item
Comment on #501: "Blocked by #500"
```

#### When issue \#500 closes

#### Then

- System searches for "Blocked by #500"
- #501 `blocked` label automatically removed
- Comment added: "Auto-unblocked: #500 completed [timestamp]"

**Success criteria:**

- Agent runs search query: `gh issue list --search "Blocked by #500" --state open`
- Agent finds #501
- Agent removes `blocked` label from #501
- Agent adds auto-unblock comment with timestamp
- #501 is now unblocked and ready to action

---

### GREEN 6: Circular dependency resolved

#### Given

Circular dependency with dependency blocks only

```text
#600 (P1, blocked by #601) - Refactor Module A
Comment: "Blocked by #601 for interface definition"

#601 (P1, blocked by #600) - Refactor Module B
Comment: "Blocked by #600 for type definitions"
```

#### When

Agent detects cycle during dependency review

#### Then

- Agent detects circular dependency (#600 ↔ #601)
- Agent verifies no manual blockers (both are dependency blocks)
- Agent calculates rework cost:
  - #600 with temp interface = LOW
  - #601 with temp types = MEDIUM
- Agent unblocks #600 (lower rework cost)
- Agent creates #602: "Update Module A with final interface from #601"
- Agent documents resolution in #600 comment

**Success criteria:**

- Agent identifies cycle during dependency review
- Agent checks for manual vs dependency blocking
- Agent chooses task with minimum rework
- Agent creates follow-up work item for rework
- Agent removes `blocked` label from chosen task
- Agent adds comment explaining circular dependency resolution

**Expected comment on #600:**

```text
Circular dependency with #601. Delivering with temporary interface. Follow-up: #602
```

---

## PRESSURE Scenarios (Edge Cases)

These scenarios test behavior under non-ideal conditions.

### PRESSURE 1: Multiple blockers, partial resolution

#### Given

Work item blocked by multiple issues

```text
#700 (P1, blocked by #701, #702, #703)
Comment: "Blocked by #701, #702, #703"
```

#### When issue \#701 closes

#### Then \#701 closes

- #700 comment updated to remove #701: "Blocked by #702, #703"
- `blocked` label remains (still blocked by #702, #703)

#### When issue \#702 closes

#### Then \#702 closes

- #700 comment updated: "Blocked by #703"
- `blocked` label remains (still blocked by #703)

#### When issue \#703 closes

#### Then \#703 closes

- #700 comment removed
- `blocked` label removed
- Comment added: "Auto-unblocked: all blockers resolved"

**Success criteria:**

- Agent parses blocking comment to identify all blockers
- Agent updates comment when partial blocker resolves
- Agent keeps `blocked` label until ALL blockers resolved
- Agent only removes `blocked` label when final blocker resolves

---

### PRESSURE 2: Manual block in circular dependency

#### Given

Circular dependency with manual blocker

```text
#800 (P1, blocked) - Task A
Comment: "Blocked waiting for vendor API specification" (manual block)

#801 (P1, blocked by #800) - Task B (dependency block)
```

#### When

Agent attempts circular resolution

#### Then

- Agent detects circular dependency (#800 → #801 → #800)
- Agent checks for manual blockers
- Agent finds manual block in #800 (waiting for vendor)
- Agent stops with ERROR
- No auto-resolution attempted

**Success criteria:**

- Agent identifies circular dependency
- Agent distinguishes manual blocking from dependency blocking
- Agent detects manual blocker keyword: "waiting for vendor"
- Agent does not apply automatic resolution to manual blocks
- Agent escalates to user intervention

**Expected error:**

```text
ERROR: Circular dependency contains manual blocker
Issue #800 has manual block: "Blocked waiting for vendor API specification"
Requires user intervention - cannot auto-resolve.
```

---

### PRESSURE 3: Priority inheritance chain

#### Given

Transitive dependency chain

```text
#900 (P3, unblocked) - Refactor database layer
#901 (P2, blocked by #900) - Add caching
#902 (P0, blocked by #901) - Production performance fix
```

#### When

Agent calculates effective priority

#### Then

- #900 effective priority: P0 (transitive through #901 from #902)
- #901 effective priority: P0 (inherits from #902)
- #902 effective priority: P0 (original priority)

**Success criteria:**

- Agent traverses dependency chain
- Agent applies transitive priority inheritance
- #900 treated as P0 despite original P3 label
- Selection order: #900, then #901, then #902

**Formula verification:**

```text
#900: effective = min(P3, min(P2, P0)) = P0
#901: effective = min(P2, min(P0)) = P0
#902: effective = P0
```

---

### PRESSURE 4: Tie-breaker with equal blocking counts

#### Given

Multiple blocking tasks with same priority and same blocking count

```text
#1000 (P1, blocks #1001, #1002, #1003) - Fix bug A
#1100 (P1, blocks #1101, #1102, #1103) - Fix bug B
```

#### When

Agent applies tie-breaker

#### Then

- Both have P1 effective priority (tie)
- Both unblock 3 items (tie)
- Agent selects lower issue number: #1000 (FIFO as final fallback)

**Success criteria:**

- Agent calculates unblock count for both tasks
- Agent detects tie on priority and unblock count
- Agent applies FIFO rule (lower issue number)
- #1000 selected before #1100

---

## Test Execution Checklist

**To run these tests manually:**

- [ ] **RED Tests:** Confirm each RED scenario fails as expected without prioritization rules
      (use skill version before this PR)
- [ ] **GREEN Tests:** Confirm each GREEN scenario passes with prioritization rules
      (use skill version from this PR)
- [ ] **PRESSURE Tests:** Confirm edge cases handled correctly with prioritization rules
- [ ] **Integration:** Test full workflow from dependency review → blocking → priority inheritance →
      auto-unblock
- [ ] **Platform Tests:** Verify CLI commands work on GitHub (gh), Azure DevOps (az boards), Jira (jira)

**Evidence requirements:**

For each GREEN and PRESSURE scenario:

- [ ] Screenshot or command output showing correct behavior
- [ ] Issue comment showing blocking/unblocking
- [ ] Label changes documented
- [ ] Priority calculations shown (for inheritance tests)

**Automation note:**

These tests are currently manual. Future work could add automated testing with:

- Temporary test repositories
- Scripted issue creation and manipulation
- Automated verification of agent behavior
- CI/CD integration for regression testing
