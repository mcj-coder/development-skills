# Human Supervisor Interface

> Reference material for the [`pair-programming`](../SKILL.md) skill.


This section details how human supervisors interact with the agent during pair
programming sessions. All mechanisms are designed for async-first workflows where
the human reviews and intervenes at their convenience.

### Progress Visibility

Supervisors monitor agent progress through these channels:

#### Issue Comments

- Agent posts status updates at each phase transition
- Progress summaries include completed tasks, current work, and blockers
- Comments are timestamped and linked to relevant commits/PRs

#### Status Labels

Labels provide at-a-glance status on issues:

| Label                      | Meaning                               |
| -------------------------- | ------------------------------------- |
| `pair-programming:active`  | Agent actively working on this issue  |
| `pair-programming:blocked` | Agent waiting for input or resolution |
| `pair-programming:review`  | Ready for human review                |
| `pair-programming:paused`  | Work paused pending human decision    |

#### PR Activity

- Draft PRs show work in progress
- PR descriptions summarize implementation decisions
- Commit history provides detailed change trail

### Intervention Points

Human supervisors can intervene at any point in the workflow:

#### During Planning

- Review plan before implementation begins
- Add requirements or constraints
- Redirect approach if needed

#### During Implementation

- Comment on issue to provide guidance
- Request status update
- Pause work for discussion

#### During Review Loop

- Review automated review feedback
- Add additional review criteria
- Override automated decisions

#### At Human Checkpoint

- Full code review on PR
- Request changes or approve
- Take over if needed

#### Command Reference

```bash
# Request immediate status
gh issue comment N --body "@agent status"

# Pause for discussion
gh issue comment N --body "@agent pause"

# Provide guidance
gh issue comment N --body "@agent note: [guidance here]"

# Resume paused work
gh issue comment N --body "@agent continue"
```

### Notification Preferences

By default, the agent operates asynchronously without requiring immediate human
attention. Notification preferences can be configured per repository or session.

#### Default Behaviour (Async)

- Agent posts updates to issue/PR comments
- No direct notifications or alerts sent
- Human reviews at their convenience
- Agent continues work unless blocked

#### Configurable Options

| Preference          | Description                          |
| ------------------- | ------------------------------------ |
| `notify:checkpoint` | Alert human when checkpoint reached  |
| `notify:blocked`    | Alert human when agent is blocked    |
| `notify:complete`   | Alert human when issue complete      |
| `notify:all`        | Alert on all status changes          |
| `notify:none`       | No alerts (default - check comments) |

#### Configuration

Set preferences in repository's ways-of-working documentation or per-session:

```bash
# Set session preference
gh issue comment N --body "@agent notify:checkpoint"

# View current preferences
gh issue comment N --body "@agent preferences"
```

### Takeover Mechanism

When a human supervisor needs to take control of work from the agent:

#### Initiating Takeover

1. Post takeover command on the issue:

   ```bash
   gh issue comment N --body "@agent I'm taking over this task"
   ```

2. Agent acknowledges and prepares handoff:
   - Posts current state summary
   - Lists in-progress work and location
   - Notes any uncommitted changes
   - Removes itself from assignment

#### What Agent Provides on Takeover

- Current branch and commit state
- List of modified files with descriptions
- Any worktrees or parallel work in progress
- Pending decisions or blockers
- Links to relevant plan and documentation

#### Partial Takeover

Human can take over specific aspects while agent continues others:

```bash
# Take over specific sub-task
gh issue comment N --body "@agent I'll handle the database migration, continue with API work"

# Take over review process
gh issue comment N --body "@agent I'll review this PR, you can move to next issue"
```

### Graceful Handoff

When transitioning work back to the agent or between sessions:

#### Agent to Human Handoff

Agent provides comprehensive handoff when:

- Human takes over
- Session ends without completion
- Blocker requires human resolution

#### Handoff Content

```markdown
## Handoff Summary

**Issue**: #N - [Title]
**Status**: [Current phase]
**Branch**: `feat/N-description`

### Completed

- [x] Task 1
- [x] Task 2

### In Progress

- [ ] Task 3 (50% complete, see commit abc123)

### Remaining

- [ ] Task 4
- [ ] Task 5

### Notes

- Decision made: [description]
- Blocker: [description if any]

### Files Modified

- `path/to/file.ts` - [description]
- `path/to/other.ts` - [description]
```

#### Human to Agent Handoff

When returning work to agent:

1. Update issue with current state
2. Commit any local changes
3. Push branch to remote
4. Comment with handoff instruction:

   ```bash
   gh issue comment N --body "@agent please continue from current state"
   ```

#### Resumption Protocol

Agent on resumption:

1. Reads issue history for context
2. Checks branch state and recent commits
3. Posts acknowledgement with understood state
4. Continues from last known good state
