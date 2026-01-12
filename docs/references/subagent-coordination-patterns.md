# Subagent Coordination Patterns

When dispatching multiple subagents to work in parallel, coordination is critical to
avoid conflicts and wasted work.

## The Problem

Parallel subagent work on the same file creates issues:

| Problem             | Cause                              | Impact                        |
| ------------------- | ---------------------------------- | ----------------------------- |
| Competing branches  | Multiple agents create same branch | Git push failures             |
| Overlapping work    | No clear section assignment        | Duplicate content, merge pain |
| HEAD lock conflicts | Simultaneous commits to same repo  | Commit failures               |
| Merge complexity    | Divergent changes to same lines    | Manual conflict resolution    |

## Decision Tree

```text
Is work on same file?
    ↓
NO → Safe to parallelize
    - Use separate branches
    - Merge in dependency order
    ↓
YES → How much overlap?
    ↓
    High overlap (same sections) → Serialize
        - One agent at a time
        - Clear handoff points
    ↓
    Low overlap (different sections) → Assign sections
        - Explicit section boundaries
        - Non-overlapping line ranges
    ↓
    No overlap (different concerns) → Use worktrees
        - Isolated working directories
        - Merge after completion
```

## Strategy 1: Use Git Worktrees

**When:** Multiple agents need to work on the same repository simultaneously.

**How:**

```bash
# Create worktree for each subagent
git worktree add ../.worktrees/wt-backend-123 -b feat/backend-123
git worktree add ../.worktrees/wt-frontend-123 -b feat/frontend-123

# Each agent works in their worktree
# No conflicts - completely isolated

# After completion, merge worktree branches
git checkout main
git merge feat/backend-123
git merge feat/frontend-123

# Clean up
git worktree remove ../.worktrees/wt-backend-123
git worktree remove ../.worktrees/wt-frontend-123
```

**Benefits:**

- Complete isolation between agents
- No lock conflicts
- Clean merge history

**Drawbacks:**

- More disk space
- More complex merge process
- Requires coordination on merge order

## Strategy 2: Assign Non-Overlapping Sections

**When:** Multiple agents need to add content to the same file but different sections.

**How:**

```markdown
## Agent Assignment

- Agent A: Add sections 1-3 (lines 1-100)
- Agent B: Add sections 4-6 (lines 101-200)
- Agent C: Add sections 7-9 (lines 201-300)

Each agent ONLY modifies their assigned section.
Do NOT edit outside your section boundaries.
```

**Implementation:**

1. Primary agent creates file skeleton with section markers
2. Assign each subagent to specific sections
3. Subagents work in parallel on different branches
4. Primary agent merges in order (A, B, C)

**Benefits:**

- Parallel work on same file
- Predictable merge points
- Clear ownership

**Drawbacks:**

- Requires upfront planning
- Section boundaries must be clear
- Late changes may cross boundaries

## Strategy 3: Serialize Work

**When:** High overlap or interdependent content makes parallelization risky.

**How:**

```text
Agent A completes → commits → pushes
    ↓
Agent B pulls → continues → commits → pushes
    ↓
Agent C pulls → continues → commits → pushes
```

**Benefits:**

- No conflicts possible
- Each agent sees previous work
- Simple mental model

**Drawbacks:**

- No parallelism benefit
- Slower total completion
- Agents wait for each other

## Choosing the Right Strategy

| Scenario                       | Recommended Strategy | Rationale                         |
| ------------------------------ | -------------------- | --------------------------------- |
| Multiple files, independent    | Parallel branches    | Maximum parallelism, no conflicts |
| Same file, different sections  | Assign sections      | Parallel with coordination        |
| Same file, interleaved content | Serialize            | Avoid merge complexity            |
| Same repo, separate features   | Worktrees            | Complete isolation                |
| Documentation with structure   | Assign sections      | Outline first, fill in parallel   |
| Code with dependencies         | Serialize            | Order matters for compilation     |

## Documentation-Specific Patterns

Documentation skills benefit from an outline-first approach:

### Outline-First Pattern

```text
1. Primary agent creates file with section headers only
2. Assigns sections to subagents
3. Subagents fill content in parallel
4. Primary agent reviews and merges
```

**Example assignment:**

```markdown
# Main Document Title

## Section 1: Overview

<!-- Agent A: Fill this section -->

## Section 2: Implementation

<!-- Agent B: Fill this section -->

## Section 3: Examples

<!-- Agent C: Fill this section -->
```

### Table of Contents Pattern

For large documents:

1. Create TOC as coordination point
2. Each section is a separate file
3. Subagents work on separate files
4. Primary agent assembles final document

## Code-Specific Patterns

### Interface-First Pattern

```text
1. Define interfaces/contracts first
2. Assign implementations to subagents
3. Each agent implements their interface
4. Integration test validates compatibility
```

### Test-First Pattern

```text
1. Write tests for expected behavior
2. Assign test cases to subagents
3. Each agent makes tests pass
4. Merge verified implementations
```

## Conflict Resolution

If conflicts occur despite coordination:

1. **Stop all subagents** - Prevent further divergence
2. **Identify conflict scope** - Which files, which sections
3. **Designate resolver** - Usually primary agent
4. **Merge carefully** - Review each conflict
5. **Re-verify** - Run tests after resolution
6. **Document** - Note what caused conflict for future

## Quick Reference

| Agents | Same File? | Overlap? | Strategy        |
| ------ | ---------- | -------- | --------------- |
| 2+     | No         | N/A      | Parallel        |
| 2+     | Yes        | None     | Assign sections |
| 2+     | Yes        | Low      | Worktrees       |
| 2+     | Yes        | High     | Serialize       |
| Any    | Yes        | Unknown  | Serialize       |
