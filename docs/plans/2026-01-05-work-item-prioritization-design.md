# Work Item Prioritization Design

## Summary

Add comprehensive work item prioritization rules to issue-driven-delivery skill to help agents and teams deliver work in optimal order, with blocked work enforcement and automatic dependency resolution.

## Problem

Current issue-driven-delivery skill lacks explicit prioritization guidance. Teams and agents need clear rules for:
- Which work item to pick next when multiple items are ready
- How to handle blocking dependencies
- How to prioritize when multiple items have same priority
- How to prevent circular dependencies from creating deadlock
- How to enforce blocked work item approval before proceeding

Without these rules, agents may:
- Pick low-priority work over critical items
- Start new work while in-progress work remains unfinished
- Proceed with blocked work without approval
- Create or fail to resolve circular dependencies

## Goals

1. Establish 5-tier prioritization hierarchy for work item selection
2. Enforce blocked work approval at self-assignment and state transitions
3. Distinguish manual blocking (user-added) from dependency blocking (system-added)
4. Provide automatic unblocking when blocking work items complete
5. Resolve circular dependencies with minimal rework
6. Add dependency review during refinement phase

## Non-Goals

- Automatic priority assignment (humans still set priority labels)
- Cross-repository dependency tracking
- Real-time dependency graph visualization
- Automatic task scheduling or assignment

## Architecture

### Integration Points

**1. New Reference Document:**
- File: `skills/issue-driven-delivery/references/prioritization-rules.md`
- Content: 5-tier priority hierarchy, blocking types, circular dependency resolution
- Similar depth to `component-tagging.md` (~300-400 lines)

**2. Main SKILL.md Updates:**
- Add "Work Item Prioritization" section after "Work Item Tagging"
- Brief summary of 5 rules + link to reference
- ~50 lines in main skill

**3. Core Workflow Changes:**
- Step 3a: Add blocked check at refinement self-assignment
- Step 4b: Add dependency review during planning
- Step 7b, 7c: Add blocked check at implementation transition and self-assignment
- Step 8b, 8c: Add blocked check at verification transition and self-assignment
- Step 10b: Add blocked check before closing
- Step 20: Add auto-unblocking when work item closes

## Design Details

### Prioritization Hierarchy (5 Tiers)

**Tier 1: Finish Started Work (Highest Priority)**
- Target: Unassigned work items in progress states (refinement, implementation, verification)
- Rationale: Minimize WIP, complete in-flight work before starting new
- Query: `state:(refinement|implementation|verification) assignee:""`
- Exception: P0 production incidents override this tier

**Tier 2: Critical Production Issues (P0)**
- Target: Priority P0 with keywords: "production", "down", "data loss", "security"
- Overrides finish-started-work rule
- Must be actioned immediately

**Tier 3: Priority Order (P0 → P1 → P2 → P3 → P4)**
- Standard priority-based delivery
- Work through P0s, then P1s, then P2s, etc.
- Lower number = higher priority

**Tier 4: Blocking Task Priority Inheritance**
- Blocking tasks inherit priority from blocked tasks
- Formula: `effective_priority = min(task_priority, min(blocked_tasks_priority))`
- Example: P2 task blocking P0 task becomes P0 effective priority
- Transitive: Inherits from entire dependency chain

**Tier 5: Blocking Task Tie-Breaker**
- When multiple blocking tasks have same effective priority
- Count: Direct + transitive blocked work items
- Choose task that unblocks most items
- Final fallback: Lower issue number (FIFO)

### Blocking Types

**Manual Blocking (User-Added):**
- User explicitly adds `blocked` label + comment (e.g., "blocked waiting for client approval")
- Cannot be auto-resolved - requires explicit user approval
- Comment patterns: "waiting for", "blocked by external", "needs approval from"
- Only unblocked by:
  - User comment: "approved to proceed" or "unblocked"
  - User removes `blocked` label
- Circular dependency resolution cannot override manual blocks

**Dependency Blocking (System-Added):**
- Added during dependency review in refinement
- Comment links to blocking work item: "Blocked by #123"
- Can be auto-resolved when:
  - Blocking work item closes
  - Circular dependency resolution applies

### Blocked Work Enforcement

**Check Points:**
- Self-assignment (steps 3a, 7c, 8c)
- State transitions (steps 7b, 8b, 10b)

**Logic:**
```
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

**Error Message:**
```
ERROR: Cannot self-assign blocked work item #X
Blocking reason: [blocking comment text]
Requires explicit approval comment to proceed.
```

### Automatic Unblocking

When work item closes (step 20):

1. Search for "Blocked by #X" in open work item comments (X = closing issue)
2. Parse blocking comment to identify all blockers
3. If closing issue is sole blocker:
   - Remove `blocked` label
   - Add comment: "Auto-unblocked: #X completed [timestamp]"
4. If multiple blockers remain:
   - Update comment: Remove resolved blocker from list
   - Keep `blocked` label until all blockers resolved
5. Log unblocking action for audit trail

**Query Pattern:**
```bash
gh issue list --search "Blocked by #100" --state open
```

### Circular Dependency Resolution

**Detection:** A → B → C → A creates cycle

**Pre-check:** Verify no manual blockers in cycle
- Search comments for manual blocking patterns: "waiting for", "external", "approval", "client"
- If ANY task has manual block → STOP, cannot auto-resolve
- Error: "Circular dependency contains manual blocker. Requires user intervention."

**Resolution Steps (if all blocks are dependency-based):**
1. Calculate rework cost for each task in cycle
2. Choose task with minimum rework
3. Remove `blocked` label from chosen task
4. Update comment: "Unblocked to resolve circular dependency with #X, #Y. Follow-up: #Z"
5. Create follow-up task for rework
6. Link follow-up to original task

**Rework Cost Heuristics:**
- Interface changes < Implementation changes < Architecture changes
- Temporary mocks/stubs = low rework cost
- Schema migrations = high rework cost

### Dependency Review During Refinement

**New Step 4b (during planning):**

During planning, perform dependency review:
1. Search open work items for potential dependencies
2. Check if current work depends on or blocks other work
3. Analyze follow-on task relationships (ensure original not blocked by follow-up)
4. If dependencies found:
   - Add `blocked` label if work depends on incomplete items
   - Add comment: "Blocked by #123 - [reason]"
   - Update blocking item: "Blocking #current - [impact]"
5. Validate no circular dependencies created
6. If circular dependency: Document in plan, propose resolution

## Examples

### Example 1: Simple Priority Ordering

**Queue state:**
- #100 (P2, unblocked, new-feature)
- #101 (P1, unblocked, bug)
- #102 (P3, unblocked, enhancement)

**Selection:** #101 (highest priority wins)

### Example 2: Finish Started Work

**Queue state:**
- #200 (P1, state:new-feature, unassigned)
- #201 (P2, state:implementation, unassigned) ← someone started, didn't finish

**Selection:** #201 (finish what's started before starting new)

### Example 3: Priority Inheritance

**Initial state:**
- #300 (P2): Add authentication module
- #301 (P0): Production deployment (depends on #300)

**After dependency analysis:**
- #300 effective priority: P0 (inherits from #301)

**Selection:** #300 before other P2 work (inherited priority)

### Example 4: Tie-Breaker (Most Unblocked)

**Queue state:**
- #400 (P1): Fix auth bug [blocks #401, #402]
- #500 (P1): Fix DB bug [blocks #501, #502, #503, #504, #505]

**Selection:** #500 (unblocks 5 items vs 2 items)

### Example 5: Manual Block - Cannot Proceed

**Work item #600:**
- Labels: blocked, P1
- Comment: "Blocked waiting for client API key approval"

**Agent attempts self-assign:**
```
ERROR: Cannot self-assign blocked work item #600
Blocking reason: "Blocked waiting for client API key approval"
Requires explicit approval comment to proceed.
```

**Resolution:** Wait for user comment "approved to proceed" or "unblocked"

### Example 6: Circular Dependency Resolution

**Cycle detected:**
- #700: Refactor Module A (blocked by #701 for interface definition)
- #701: Refactor Module B (blocked by #700 for type definitions)

**Dependency analysis:**
- Both are dependency blocks (not manual)
- Rework cost: #700 with temp interface = LOW, #701 with temp types = MEDIUM

**Resolution:**
1. Unblock #700 (lower rework cost)
2. Create #702: "Update Module A with final interface from #701"
3. Comment on #700: "Circular dependency with #701. Delivering with temporary interface. Follow-up: #702"
4. Remove blocked label from #700
5. #700 proceeds, #701 remains blocked until #700 completes

### Example 7: Auto-Unblock on Completion

**Initial state:**
- #800: Fix authentication (closed)
- #801: Deploy authentication (blocked by #800)
- Comment on #801: "Blocked by #800"

**When #800 closes:**
1. System searches for "Blocked by #800"
2. Finds #801
3. Removes `blocked` label from #801
4. Adds comment: "Auto-unblocked: #800 completed [2026-01-05T10:30:00Z]"

### Example 8: Multiple Blockers - Partial Resolution

**Initial state:**
- #900: Feature X (blocked by #901, #902, #903)
- Comment on #900: "Blocked by #901, #902, #903"

**When #901 closes:**
1. System finds #900
2. Updates comment: "Blocked by #902, #903"
3. Keeps `blocked` label (still has 2 blockers)

**When #902 closes:**
1. Updates comment: "Blocked by #903"
2. Keeps `blocked` label (still has 1 blocker)

**When #903 closes:**
1. Removes comment and `blocked` label
2. Adds comment: "Auto-unblocked: all blockers resolved"

## BDD Test Scenarios

### RED Scenarios (Baseline Without Enhancement)

**RED 1: Agent picks low priority over high priority**
- **Given:** Queue has P1 and P2 work items
- **When:** Agent selects work without checking priority
- **Then:** Might pick P2 before P1
- **Expected failure:** No prioritization guidance

**RED 2: Agent starts new work while in-progress work exists**
- **Given:** Work item in state:implementation, unassigned (abandoned)
- **When:** Agent picks state:new-feature work item
- **Then:** Leaves in-progress work unfinished
- **Expected failure:** No "finish started work" rule

**RED 3: Agent proceeds with blocked work**
- **Given:** Work item has blocked label without approval
- **When:** Agent attempts self-assignment
- **Then:** Proceeds without checking for approval
- **Expected failure:** No blocked enforcement

**RED 4: Circular dependency causes deadlock**
- **Given:** A blocks B, B blocks A
- **When:** Agent analyzes dependencies
- **Then:** Both remain blocked indefinitely
- **Expected failure:** No circular dependency resolution

### GREEN Scenarios (With Enhancement)

**GREEN 1: Priority ordering enforced**
- **Given:** Queue has #100 (P2), #101 (P1), #102 (P3)
- **When:** Agent applies prioritization rules
- **Then:** Selects #101 (P1 first)

**GREEN 2: Finish started work first**
- **Given:** #200 (P1, new-feature), #201 (P2, implementation, unassigned)
- **When:** Agent applies prioritization
- **Then:** Selects #201 (finish what's started)

**GREEN 3: Blocked work rejected without approval**
- **Given:** #300 has blocked label, comment "waiting for client approval"
- **When:** Agent attempts self-assignment
- **Then:** ERROR with blocking reason shown
- **And:** Agent stops, waits for approval

**GREEN 4: Blocked work auto-unblocked when approved**
- **Given:** #400 blocked, user comments "approved to proceed"
- **When:** Agent attempts self-assignment
- **Then:** Automatically removes blocked label
- **And:** Proceeds with assignment
- **And:** Logs: "Blocked label removed after approval"

**GREEN 5: Auto-unblock on blocker completion**
- **Given:** #500 blocks #501 (sole blocker)
- **When:** #500 closes
- **Then:** #501 blocked label automatically removed
- **And:** Comment added: "Auto-unblocked: #500 completed"

**GREEN 6: Circular dependency resolved**
- **Given:** #600 blocks #601, #601 blocks #600 (both dependency blocks)
- **When:** Agent detects cycle during dependency review
- **Then:** Calculates rework cost for each
- **And:** Unblocks task with minimum rework
- **And:** Creates follow-up task for rework
- **And:** Documents resolution in comments

### PRESSURE Scenarios (Edge Cases)

**PRESSURE 1: Multiple blockers, partial resolution**
- **Given:** #700 blocked by #701, #702, #703
- **When:** #701 closes
- **Then:** #700 comment updated to remove #701
- **And:** Blocked label remains (still blocked by #702, #703)
- **And:** Label only removed when all blockers resolved

**PRESSURE 2: Manual block in circular dependency**
- **Given:** #800 blocks #801 (manual: "waiting for vendor")
- **And:** #801 blocks #800 (dependency block)
- **When:** Agent attempts circular resolution
- **Then:** ERROR: "Circular dependency contains manual blocker"
- **And:** No auto-resolution attempted

**PRESSURE 3: Priority inheritance chain**
- **Given:** #900 (P3) blocks #901 (P2) blocks #902 (P0)
- **When:** Agent calculates effective priority
- **Then:** #900 inherits P0 (transitive through chain)
- **And:** #901 inherits P0

**PRESSURE 4: Tie-breaker with equal blocking counts**
- **Given:** #1000 (P1) blocks 3 items, #1001 (P1) blocks 3 items
- **When:** Agent applies tie-breaker
- **Then:** Selects lower issue number (FIFO as final fallback)

## Implementation Plan

### Phase 1: Reference Document
1. Create `references/prioritization-rules.md`
2. Document 5-tier hierarchy with detailed explanations
3. Document blocking types (manual vs dependency)
4. Document circular dependency resolution algorithm
5. Add examples for each rule

### Phase 2: Core Workflow Updates
1. Update step 3a: Add blocked check at refinement self-assignment
2. Add step 4b: Dependency review during planning
3. Update step 7b, 7c: Add blocked check at implementation
4. Update step 8b, 8c: Add blocked check at verification
5. Update step 10b: Add blocked check before closing
6. Update step 20: Add auto-unblocking logic

### Phase 3: Main SKILL.md Updates
1. Add "Work Item Prioritization" section after "Work Item Tagging"
2. Link to prioritization-rules.md reference
3. Update "Common Mistakes" section
4. Update "Red Flags" section
5. Update "Rationalizations" table

### Phase 4: BDD Tests
1. Create `issue-driven-delivery-prioritization.test.md`
2. Add RED scenarios (4 baseline failures)
3. Add GREEN scenarios (6 success cases)
4. Add PRESSURE scenarios (4 edge cases)

### Phase 5: Documentation
1. Update README.md if needed
2. Commit design document
3. Create implementation plan

## Success Criteria

- Agents consistently pick highest-priority work
- Blocked work cannot proceed without explicit approval
- Circular dependencies detected and resolved automatically
- Completed work automatically unblocks dependent items
- Manual blocks distinguished from dependency blocks
- All BDD scenarios pass

## Open Questions

None - design approved.

## Related Work

- Issue #41: Taskboard traceability (establishes requirement for work items)
- Issue #42: TDD/BDD verification requirements (testing standards)
- Issue #65: PR requirement enforcement (another workflow enhancement)
- Component tagging reference (priority levels P0-P4 already defined)

## Risks and Mitigations

**Risk:** Automatic unblocking might remove blocks prematurely
- **Mitigation:** Only remove when ALL blockers resolved, maintain audit trail

**Risk:** Circular dependency resolution might choose wrong task
- **Mitigation:** Use rework cost heuristics, require manual approval for manual blocks

**Risk:** Priority inheritance might create unexpected high-priority work
- **Mitigation:** Document transitive inheritance clearly, make calculation transparent

**Risk:** Agents might not follow prioritization rules
- **Mitigation:** Add to Common Mistakes and Red Flags, enforce at assignment time
