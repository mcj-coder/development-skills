# Work Item Prioritization Rules

## Overview

This document defines the prioritization rules for selecting which work item to action next when multiple
work items are available. These rules help agents and teams deliver work in optimal order, minimize
work-in-progress, and resolve blocking dependencies efficiently.

## The 5-Tier Prioritization Hierarchy

When selecting the next work item to action, apply these rules in order:

### Tier 1: Finish Started Work (Highest Priority)

**Target:** Unassigned work items in progress states (refinement, implementation, verification)

**Rationale:** Minimize work-in-progress by completing in-flight work before starting new work. Unfinished
work creates bottlenecks, wastes context-switching time, and reduces throughput.

**Query Pattern:**

```bash
# GitHub
gh issue list --label "state:refinement,state:implementation,state:verification" --assignee "" --limit 10

# Azure DevOps
az boards work-item query --wiql "SELECT [System.Id] FROM WorkItems WHERE [System.AssignedTo] = '' AND [System.State] IN ('Refinement', 'Implementation', 'Verification')"

# Jira
jira issue list --jql "assignee is EMPTY AND status IN ('Refinement', 'Implementation', 'Verification')"
```

**Exception:** P0 critical production issues override this tier (see Tier 2).

**Example:**

```text
Available work items:
- #100 (P1, state:new-feature) - Not started
- #101 (P2, state:implementation, unassigned) - Started but abandoned

Selection: #101
Reason: Finish started work before starting new work
```

### Tier 2: Critical Production Issues (P0)

**Target:** Priority P0 work items with critical production impact

**Keywords:** "production", "down", "outage", "data loss", "security breach", "critical"

**Rationale:** Production incidents require immediate attention to minimize business impact. These override
the "finish started work" rule.

**Identification:**

- Priority label: `priority:p0`
- Title/body contains production impact keywords
- Severity indicates immediate business impact

**Example:**

```text
Available work items:
- #200 (P2, state:implementation, unassigned) - Started work
- #201 (P0, state:new-feature) - "Production API returning 500 errors"

Selection: #201
Reason: P0 production incident overrides finish-started-work rule
```

### Tier 3: Priority Order (P0 → P1 → P2 → P3 → P4)

**Target:** Work items ordered by priority label

**Rationale:** Deliver highest-priority work first to maximize business value and minimize risk.

**Priority Levels:**

| Level | Name | Description |
| ----- | ------------ | ----------------------------------------------- |
| P0 | Critical | System down, data loss, security breach |
| P1 | High | Major functionality broken, blocking other work |
| P2 | Medium | Important but not urgent, has workarounds |
| P3 | Low | Nice to have, minimal impact |
| P4 | Nice-to-have | Future consideration, low priority |

**Selection Rule:** Work through all P0 work items, then all P1s, then all P2s, etc.

**Example:**

```text
Available work items:
- #300 (P2, unblocked, state:new-feature)
- #301 (P1, unblocked, state:new-feature)
- #302 (P3, unblocked, state:new-feature)

Selection: #301
Reason: P1 has higher priority than P2 and P3
```

### Tier 4: Blocking Task Priority Inheritance

**Target:** Work items that block other work items inherit the highest priority from their blocked items

**Formula:**

```text
effective_priority = min(task_priority, min(blocked_tasks_priority))
```

**Note:** Lower priority number = higher priority (P0 > P1 > P2 > P3 > P4)

**Rationale:** Unblock high-priority work by completing its dependencies first. A low-priority task blocking
a high-priority task becomes high-priority by necessity.

**Transitive:** Priority inheritance applies transitively through the entire dependency chain.

**Example - Simple Inheritance:**

```text
Initial state:
- #400 (P2): Add authentication module
- #401 (P0): Production deployment (blocked by #400)

After dependency analysis:
- #400 effective priority: P0 (inherits from #401)

Selection: #400 before other P2 work
Reason: Inherited P0 priority from blocked task
```

**Example - Transitive Inheritance:**

```text
Dependency chain:
- #500 (P3): Refactor database layer
- #501 (P2): Add caching (blocked by #500)
- #502 (P0): Performance fix (blocked by #501)

Effective priorities:
- #500: P0 (transitive through #501 from #502)
- #501: P0 (inherits from #502)
- #502: P0 (original priority)

Selection order: #500, then #501, then #502
Reason: #500 transitively inherits P0 from end of chain
```

### Tier 5: Blocking Task Tie-Breaker

**Target:** When multiple blocking tasks have the same effective priority, choose the task that unblocks the
most work items

**Count:** Sum of direct and transitive blocked work items

**Formula:**

```text
unblock_count = count(directly_blocked) + count(transitively_blocked)
```

**Rationale:** Maximize throughput by unblocking the most work items with a single completion.

**Final Fallback:** If unblock counts are equal, choose lower issue number (FIFO - first in, first out).

**Example - Tie-Breaker by Count:**

```text
Available work items (both P1 effective priority):
- #600 (P1): Fix auth bug [blocks #601, #602]
- #700 (P1): Fix DB bug [blocks #701, #702, #703, #704, #705]

Unblock counts:
- #600: 2 items
- #700: 5 items

Selection: #700
Reason: Unblocks 5 items vs 2 items
```

**Example - Final Fallback (FIFO):**

```text
Available work items (both P1, both unblock 3 items):
- #800 (P1): Fix API bug [blocks #801, #802, #803]
- #900 (P1): Fix UI bug [blocks #901, #902, #903]

Unblock counts:
- #800: 3 items
- #900: 3 items

Selection: #800
Reason: Lower issue number (FIFO as final fallback)
```

## Blocking Types

Work items can be blocked for two distinct reasons: manual (external) blockers or dependency (internal)
blockers. The type of blocker determines how it can be resolved.

### Manual Blocking (User-Added)

**Definition:** User explicitly adds `blocked` label with comment explaining external blocker

**Comment Patterns:**

- "waiting for [external party]"
- "blocked by external dependency"
- "needs approval from [stakeholder]"
- "blocked by client decision"

**Cannot be Auto-Resolved:** Manual blocks require explicit human intervention to clear

**Only Unblocked By:**

1. User comment: "approved to proceed" or "unblocked"
2. User removes `blocked` label manually

**Circular Dependency Resolution:** Cannot override manual blocks - requires user intervention

**Example:**

```text
Issue #1000:
- Labels: blocked, P1
- Comment: "Blocked waiting for client API key approval"

Agent attempts self-assignment:
ERROR: Cannot self-assign blocked work item #1000
Blocking reason: "Blocked waiting for client API key approval"
Requires explicit approval comment to proceed.

Resolution: Wait for user comment "approved to proceed" or user removes blocked label
```

### Dependency Blocking (System-Added)

**Definition:** Added during dependency review in refinement when work item depends on incomplete work items

**Comment Pattern:**

- "Blocked by #123 - [reason]"
- Links to specific blocking work item(s)

**Can be Auto-Resolved When:**

1. Blocking work item closes
2. Circular dependency resolution applies (see below)

**Example:**

```text
Issue #1100:
- Labels: blocked, P2, state:new-feature
- Comment: "Blocked by #1050 - requires authentication module"

When #1050 closes:
1. System searches for "Blocked by #1050"
2. Finds #1100
3. Removes blocked label from #1100
4. Adds comment: "Auto-unblocked: #1050 completed [2026-01-05T10:30:00Z]"
```

## Blocked Work Enforcement

Blocked work items cannot proceed without explicit approval. The enforcement happens at two critical
checkpoints:

### Checkpoints

**Self-Assignment (Steps 3a, 7c, 8c):**

- Before assigning work item, check for `blocked` label
- If blocked without approval, stop with error

**State Transitions (Steps 7b, 8b, 10b):**

- Before transitioning state, check for `blocked` label
- If blocked without approval, stop with error

### Enforcement Logic

```text
IF work_item.has_label('blocked'):
    approval_comment = find_comment(contains: "approved to proceed" OR "unblocked")
    IF approval_comment.exists():
        remove_label('blocked')
        log("Blocked label removed after approval")
        proceed()
    ELSE:
        error("Cannot proceed - blocked work item without approval")
        show_blocking_comment()
        stop()
```

### Error Message

```text
ERROR: Cannot self-assign blocked work item #X
Blocking reason: [blocking comment text]
Requires explicit approval comment to proceed.
```

**User Actions to Resolve:**

1. Post comment: "approved to proceed" or "unblocked"
2. Remove `blocked` label manually

## Automatic Unblocking

When a work item closes (step 20), the system automatically unblocks dependent work items that were blocked
solely by that issue.

### Auto-Unblock Process

**When work item closes:**

1. **Search for dependent work items:**

   ```bash
   gh issue list --search "Blocked by #X" --state open
   ```

2. **Parse blocking comment** to identify all blockers:
   - Single blocker: "Blocked by #100"
   - Multiple blockers: "Blocked by #100, #101, #102"

3. **If closing issue is sole blocker:**
   - Remove `blocked` label
   - Add comment: "Auto-unblocked: #X completed [timestamp]"

4. **If multiple blockers remain:**
   - Update comment: Remove resolved blocker from list
   - Keep `blocked` label until all blockers resolved

5. **Log unblocking action** for audit trail

### Examples

#### Example 1: Single Blocker - Full Unblock

```text
Initial state:
- #2000: Fix authentication (closed)
- #2001: Deploy authentication (blocked by #2000)
- Comment on #2001: "Blocked by #2000"

When #2000 closes:
1. System searches for "Blocked by #2000"
2. Finds #2001
3. Removes blocked label from #2001
4. Adds comment: "Auto-unblocked: #2000 completed [2026-01-05T10:30:00Z]"

Result: #2001 is now unblocked and ready to action
```

#### Example 2: Multiple Blockers - Partial Resolution

```text
Initial state:
- #2100: Feature X (blocked by #2101, #2102, #2103)
- Comment on #2100: "Blocked by #2101, #2102, #2103"

When #2101 closes:
1. System finds #2100
2. Updates comment: "Blocked by #2102, #2103"
3. Keeps blocked label (still has 2 blockers)

When #2102 closes:
1. Updates comment: "Blocked by #2103"
2. Keeps blocked label (still has 1 blocker)

When #2103 closes:
1. Removes comment and blocked label
2. Adds comment: "Auto-unblocked: all blockers resolved"

Result: #2100 is now unblocked
```

## Circular Dependency Resolution

Circular dependencies create deadlock where work items block each other in a cycle. These must be detected
and resolved to allow progress.

### Detection

**Pattern:** A → B → C → A creates cycle

**Example:**

```text
#3000 blocks #3001
#3001 blocks #3002
#3002 blocks #3000

Result: Circular dependency - all three blocked by each other
```

### Pre-Check: Manual Blocker Detection

**CRITICAL:** Before applying automatic resolution, verify no manual blockers exist in cycle

**Manual Blocking Patterns:**

- Comments containing: "waiting for", "external", "approval", "client"
- User-added blocked labels with external dependencies

**If ANY task in cycle has manual block:**

- STOP: Cannot auto-resolve
- ERROR: "Circular dependency contains manual blocker. Requires user intervention."
- Escalate to user for manual resolution

### Resolution Steps (If All Blocks Are Dependency-Based)

#### 1. Calculate Rework Cost for Each Task in Cycle

Use these heuristics to estimate rework cost:

**Low Rework:**

- Interface changes (easy to update later)
- Temporary mocks/stubs (designed to be replaced)
- Configuration changes (simple updates)

**Medium Rework:**

- Implementation changes (moderate code changes)
- API contract changes (some refactoring needed)
- Data structure changes (some migration needed)

**High Rework:**

- Architecture changes (extensive refactoring)
- Schema migrations (database migrations, data migration)
- Breaking API changes (affects many consumers)

#### 2. Choose Task with Minimum Rework

Select the task that has the lowest rework cost when delivered with temporary solution.

#### 3. Remove Blocked Label from Chosen Task

**4. Update Comment:**

```text
Unblocked to resolve circular dependency with #X, #Y.
Delivering with [temporary solution].
Follow-up: #Z
```

#### 5. Create Follow-Up Task for Rework

Create new work item to perform rework after blocking tasks complete:

- Title: "Update [component] with final [dependency] from #X"
- Link to original task
- Set priority to match or lower than original

#### 6. Link Follow-Up to Original Task

Add comment to original task referencing follow-up.

### Example

**Cycle Detected:**

```text
#4000: Refactor Module A (blocked by #4001 for interface definition)
#4001: Refactor Module B (blocked by #4000 for type definitions)
```

**Dependency Analysis:**

- Both are dependency blocks (not manual)
- Rework cost: #4000 with temp interface = LOW
- Rework cost: #4001 with temp types = MEDIUM

**Resolution:**

1. Unblock #4000 (lower rework cost)
2. Create #4002: "Update Module A with final interface from #4001"
3. Comment on #4000: "Circular dependency with #4001. Delivering with temporary interface.
   Follow-up: #4002"
4. Remove blocked label from #4000
5. #4000 proceeds, #4001 remains blocked until #4000 completes
6. When #4000 completes, #4001 auto-unblocks
7. When #4001 completes, #4002 can begin rework

## Dependency Review During Refinement

During refinement (before transitioning to implementation), perform dependency review to identify and
document blocking relationships.

### New Step 4b: Dependency Review (During Planning)

**During planning, perform dependency review:**

1. **Search Open Work Items for Potential Dependencies**

   ```bash
   # Search for related work items
   gh issue list --state open --label "state:new-feature,state:implementation,state:verification"
   ```

2. **Check if Current Work Depends On or Blocks Other Work**
   - Does current work require functionality from other open work items?
   - Does current work provide functionality needed by other open work items?

3. **Analyze Follow-On Task Relationships**
   - Ensure original task is not blocked by its own follow-up tasks
   - Follow-ups should be enhancements, not blockers
   - Example: "Create feature X" should NOT be blocked by "Add tests for feature X"

4. **If Dependencies Found:**
   - Add `blocked` label if work depends on incomplete items
   - Add comment: "Blocked by #123 - [reason]"
   - Update blocking item: "Blocking #current - [impact]"

5. **Validate No Circular Dependencies Created**
   - Check dependency chain doesn't create cycle
   - If circular dependency detected, document in plan and propose resolution

6. **If Circular Dependency:**
   - Document in plan
   - Propose resolution following circular dependency rules
   - Get approval before proceeding

### Example Dependency Review

#### Work Item #5000: "Add user profile page"

**Dependency Review:**

```text
1. Search open work items:
   - Found #4900: "Add authentication system" (state:implementation)
   - Found #5001: "Add profile editing" (state:new-feature)

2. Dependencies:
   - #5000 depends on #4900 (needs authentication to secure profile page)
   - #5001 depends on #5000 (needs profile page to add editing)

3. Follow-on analysis:
   - No follow-up tasks yet
   - Will create follow-up for profile picture upload (not a blocker)

4. Add blocking relationships:
   - Add blocked label to #5000
   - Comment: "Blocked by #4900 - requires authentication system"
   - Comment on #4900: "Blocking #5000 - profile page needs auth"

5. No circular dependencies detected
```

**Result:** #5000 marked as blocked, dependency documented, waiting for #4900 to complete.

## Platform-Specific CLI Commands

### GitHub (gh CLI)

**Check blocked status:**

```bash
gh issue view 123 --json labels --jq '.labels[].name' | grep blocked
```

**Find blocked work items:**

```bash
gh issue list --label "blocked" --state open
```

**Add blocked label with comment:**

```bash
gh issue edit 123 --add-label "blocked"
gh issue comment 123 --body "Blocked by #100 - requires authentication module"
```

**Remove blocked label (after approval):**

```bash
gh issue edit 123 --remove-label "blocked"
gh issue comment 123 --body "Blocked label removed after approval"
```

**Search for dependent work items:**

```bash
gh issue list --search "Blocked by #100" --state open
```

### Azure DevOps (az boards CLI)

**Check blocked status:**

```bash
az boards work-item show --id 123 --query "fields.'System.Tags'" --output tsv | grep blocked
```

**Add blocked tag with comment:**

```bash
az boards work-item update --id 123 --fields System.Tags="blocked"
az boards work-item discussion create --id 123 --message "Blocked by #100 - requires authentication module"
```

**Remove blocked tag:**

```bash
# Remove blocked from tags
az boards work-item update --id 123 --fields System.Tags=""
```

### Jira (jira CLI)

**Check blocked status:**

```bash
jira issue view PROJ-123 --plain | grep Labels | grep blocked
```

**Add blocked label with comment:**

```bash
jira issue update PROJ-123 --label blocked
jira issue comment PROJ-123 "Blocked by PROJ-100 - requires authentication module"
```

**Remove blocked label:**

```bash
# Update labels without blocked
jira issue update PROJ-123 --label ""
```

## Summary

**Prioritization Order:**

1. Finish started work (unless P0 production incident)
2. P0 production incidents
3. Priority order (P0 → P1 → P2 → P3 → P4)
4. Blocking tasks inherit priority from blocked tasks
5. Tie-breaker: Most unblocked items, then FIFO

**Blocking Types:**

- Manual: User-added, requires explicit approval to clear
- Dependency: System-added, auto-clears when blockers complete

**Blocked Enforcement:**

- Check at self-assignment and state transitions
- Require approval comment or label removal to proceed

**Automatic Unblocking:**

- When blocker closes, auto-unblock dependent items
- Partial unblock if multiple blockers remain

**Circular Dependencies:**

- Detect cycles during dependency review
- Resolve by unblocking task with least rework
- Create follow-up for rework after cycle completes

**Dependency Review:**

- Perform during refinement (step 4b)
- Check for dependencies against open work items
- Document blocking relationships
- Validate no circular dependencies
