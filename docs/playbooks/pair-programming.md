# Pair Programming with AI Agent

This playbook guides you through using pair programming mode where an AI agent
handles implementation while you supervise.

## Prerequisites

Before starting, ensure you have:

- [ ] `persona-switching` configured (see `skills/persona-switching/SKILL.md`)
- [ ] GitHub CLI (`gh`) installed and authenticated
- [ ] Git worktrees enabled (standard Git feature)
- [ ] Agent has repository access

## Setup

### First-Time Configuration

1. **Configure persona-switching**

   ```bash
   # Source the persona config
   source ~/.claude/persona-config.sh

   # Verify setup
   persona_health_check
   ```

2. **Create worktrees directory**

   ```bash
   mkdir -p ../.worktrees
   echo ".worktrees/" >> .gitignore
   ```

3. **Set notification preferences** (optional)

   Add to your repository's `docs/ways-of-working/pair-programming.md`:

   ```markdown
   ## Notification Preferences

   - notify:checkpoint - Alert on phase transitions
   - notify:blocked - Alert when agent is blocked
   ```

### Per-Session Setup

Each session, verify configuration:

```bash
# Check current persona
show_persona

# Check for active pair programming sessions
gh issue list --label "pair-programming:active"
```

## Daily Usage

### Assigning Work to Agent

#### Option 1: Issue Assignment

```bash
# Assign agent to specific issue
gh issue edit 123 --add-assignee @agent
```

#### Option 2: Manual Command

```bash
# Start pair programming on issue
/pair #123

# Process next priority item
/pair --next
```

#### Option 3: Batch Processing

```bash
# Process all P1 issues
/pair --backlog --priority p1
```

### Monitoring Progress

**Check active work:**

```bash
# View agent's current assignment
gh issue list --assignee @agent --state open --limit 1

# View all active pair programming sessions
gh issue list --label "pair-programming:active"
```

**Read status updates:**

- Agent posts status comments to assigned issues
- Draft PRs show work in progress
- Labels indicate current state:
  - `pair-programming:active` - Working
  - `pair-programming:blocked` - Waiting
  - `pair-programming:review` - Ready for review

### Intervening When Needed

**Request status:**

```bash
gh issue comment 123 --body "@agent status"
```

**Pause work:**

```bash
gh issue comment 123 --body "@agent pause"
```

**Provide guidance:**

```bash
gh issue comment 123 --body "@agent note: Consider using the existing validation helper"
```

**Resume work:**

```bash
gh issue comment 123 --body "@agent continue"
```

## Common Scenarios

### Starting a New Feature

1. Create well-defined issue with acceptance criteria
2. Add priority label (`priority:p1`, `priority:p2`, etc.)
3. Add `ready` label when Definition of Ready met
4. Assign to agent:

   ```bash
   gh issue edit 123 --add-assignee @agent
   ```

5. Agent will:
   - Acknowledge in comment
   - Create plan document
   - Begin implementation
   - Post progress updates

6. Review PR when agent completes

### Bug Fix Workflow

1. Create issue describing bug and expected behaviour
2. Include reproduction steps if available
3. Add `bug` and priority labels
4. Assign to agent

Agent will:

- Reproduce the bug
- Write failing test first (TDD)
- Implement fix
- Verify fix passes
- Create PR

### Handling Blocked Tasks

When agent is blocked:

1. Agent posts blocker details to issue
2. Agent adds `pair-programming:blocked` label
3. Agent switches to parallel work if available

**To unblock:**

- Provide needed information in issue comment
- Resolve external dependency
- Comment `@agent blocker resolved`

Agent will resume blocked task automatically.

### Taking Over Mid-Task

If you need to take over:

```bash
gh issue comment 123 --body "@agent I'm taking over this task"
```

Agent will:

- Post current state summary
- List in-progress work
- Note uncommitted changes
- Remove itself from assignment

**Partial takeover:**

```bash
# Take specific aspect
gh issue comment 123 --body "@agent I'll handle the database migration, continue with API work"
```

### Returning Work to Agent

After your changes:

1. Commit and push your work
2. Update issue with current state
3. Comment to hand back:

   ```bash
   gh issue comment 123 --body "@agent please continue from current state"
   ```

## Troubleshooting

### Agent Not Responding

**Check:**

- Is agent assigned to issue?
- Does issue have `ready` label?
- Is another session active?

**Resolution:**

```bash
# Check agent's current work
gh issue list --assignee @agent --state open

# Re-assign if needed
gh issue edit 123 --remove-assignee @agent
gh issue edit 123 --add-assignee @agent
```

### Stuck in Review Loop

If agent keeps iterating on review feedback:

```bash
# Check iteration count in comments
gh issue view 123 --comments

# Override if needed
gh issue comment 123 --body "@agent proceed to human review despite pending items"
```

### Worktree Conflicts

If worktrees have conflicts:

```bash
# List all worktrees
git worktree list

# Remove stale worktrees
git worktree prune

# Force remove specific worktree
git worktree remove ../.worktrees/wt-backend-123 --force
```

### Reset State

To reset pair programming state on an issue:

```bash
# Remove all pair programming labels
gh issue edit 123 --remove-label "pair-programming:active"
gh issue edit 123 --remove-label "pair-programming:blocked"
gh issue edit 123 --remove-label "pair-programming:review"

# Remove agent assignment
gh issue edit 123 --remove-assignee @agent

# Close any draft PRs
gh pr close <pr-number>
```

### Getting Help

- Review skill documentation: `skills/pair-programming/SKILL.md`
- Check agent's issue comments for context
- Contact repository maintainers

## Quick Reference

| Action            | Command                                              |
| ----------------- | ---------------------------------------------------- |
| Assign work       | `gh issue edit N --add-assignee @agent`              |
| Check status      | `gh issue comment N --body "@agent status"`          |
| Pause work        | `gh issue comment N --body "@agent pause"`           |
| Resume work       | `gh issue comment N --body "@agent continue"`        |
| Take over         | `gh issue comment N --body "@agent I'm taking over"` |
| View active work  | `gh issue list --label "pair-programming:active"`    |
| View blocked work | `gh issue list --label "pair-programming:blocked"`   |
