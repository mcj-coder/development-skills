---
name: pair-programming
description: |
  Use for autonomous agent/human pair programming with the agent as primary
  implementer and human as supervisor. Enables high autonomy between checkpoints
  with automated review loops before human review.
model: balanced # Implementation work → Sonnet 4.5, GPT-5.1
---

# Pair Programming

## Overview

Pair programming with an AI agent inverts the traditional model: the agent drives
implementation while the human supervises. This enables high throughput on routine
work while preserving human oversight for important decisions.

**Key principles:**

- Agent has high autonomy between human checkpoints
- Automated reviews catch issues before human review
- Human intervenes only when needed
- Work follows issue-driven-delivery throughout

## When to Use

Use this skill when:

- Implementing features from a well-defined backlog
- Processing multiple issues in priority order
- Human wants to supervise rather than actively code
- Work can proceed with periodic checkpoints rather than constant collaboration

Do not use when:

- Exploratory work requiring constant human input
- High-stakes decisions needing real-time human judgement
- Learning/teaching scenarios where collaboration is the goal

## Workflow Phases

```text
TRIGGER → PLANNING → IMPLEMENTATION → REVIEW LOOP → HUMAN CHECKPOINT → MERGE
```

### Phase 1: Trigger

Work begins through one of three mechanisms:

1. **Issue assignment** - `@agent` mention or direct assignment to agent
2. **Manual command** - `/pair` slash command in conversation
3. **Scheduled batch** - Processing backlog items on schedule

On trigger:

1. Acknowledge receipt in issue comment
2. Validate issue meets Definition of Ready (DoR)
3. If DoR fails, request clarification and wait
4. If DoR passes, proceed to Planning

### Phase 2: Planning

Create implementation plan following `issue-driven-delivery`:

1. Read and understand issue requirements
2. Create plan document in `docs/plans/`
3. Identify sub-tasks and dependencies
4. Determine which sub-agents needed (by skill domain)
5. Post plan summary to issue comment
6. Proceed to Implementation (no human approval needed for standard work)

**Escalate to human if:**

- Requirements are ambiguous
- Architectural decisions needed
- Risk assessment unclear

### Phase 3: Implementation

Execute plan using sub-agents and worktrees:

1. Dispatch sub-agents by skill domain (Backend, Frontend, QA, etc.)
2. Each sub-agent works in isolated git worktree
3. Use appropriate persona for commits
4. Coordinate via issue comments
5. Handle blocked states by switching to parallel tasks

**Progress updates:**

- Post status comment at start of each major task
- Update on blockers immediately
- Summary comment when implementation complete

### Phase 4: Review Loop

Before requesting human review, self-review using personas:

1. Run all tests - must pass
2. Request Tech Lead review (architecture, patterns)
3. Request QA review (test coverage, edge cases)
4. Request Security review (if security-relevant changes)
5. Address feedback from each review
6. Iterate until all automated reviews pass

**Only proceed to Human Checkpoint when:**

- All tests green
- All automated persona reviews pass
- No unresolved critical issues

### Phase 5: Human Checkpoint

Request human review via PR:

1. Create PR with comprehensive description
2. Link to issue and plan
3. Summarize what was done and why
4. Note any decisions made during implementation
5. Wait for human review

**Human options:**

- Approve and merge
- Request changes (agent addresses and re-reviews)
- Take over (agent hands off gracefully)

### Phase 6: Merge

On human approval:

1. Squash merge PR
2. Close linked issue with evidence
3. Delete feature branch
4. Archive plan document
5. Run retrospective prompt (per issue-driven-delivery)
6. Proceed to next issue in backlog

## Skill Integrations

### issue-driven-delivery

Core workflow process - all work follows this skill's steps:

- Issue creation and grooming (steps 1-4)
- Planning and refinement (steps 5-7)
- Implementation (steps 8-12)
- Review and closure (steps 13-20)

Reference: `skills/issue-driven-delivery/SKILL.md`

### persona-switching

Identity management for commits and reviews:

- Development work uses developer account
- Reviews use management personas (Tech Lead, QA)
- Commits attributed to working persona

Reference: `skills/persona-switching/SKILL.md`

### superpowers:using-git-worktrees

Parallel development isolation:

- Each sub-agent task gets isolated worktree
- Prevents file conflicts
- Enables true parallel execution

Reference: Superpowers plugin skill

### superpowers:dispatching-parallel-agents

Sub-agent coordination:

- Dispatch by skill domain or workflow phase
- Parallel execution for independent tasks
- Result aggregation and coordination

Reference: Superpowers plugin skill

## Sub-Agent Orchestration

When implementing complex features, the primary agent orchestrates work across
multiple sub-agents. This section documents dispatch strategies, coordination
mechanisms, and result aggregation patterns.

### Dispatch Strategies

Sub-agents can be dispatched using three complementary strategies:

#### By Skill Domain

Dispatch sub-agents based on their specialization:

| Domain   | Sub-Agent Focus                     | Example Tasks                         |
| -------- | ----------------------------------- | ------------------------------------- |
| Backend  | API, database, business logic       | Implement endpoint, write migrations  |
| Frontend | UI components, state management     | Build form, add validation            |
| QA       | Test coverage, edge cases           | Write integration tests, verify flows |
| DevOps   | CI/CD, infrastructure               | Update pipeline, configure deployment |
| Security | Vulnerability assessment, hardening | Review auth flow, scan dependencies   |
| Docs     | Documentation, API specs            | Update README, generate OpenAPI spec  |

**Selection criteria:**

- Match task requirements to sub-agent expertise
- Prefer specialist over generalist for domain-specific work
- Use generalist for cross-cutting concerns

#### By Workflow Phase

Dispatch sub-agents aligned with implementation phases:

```text
PLANNING --> IMPLEMENTATION --> TESTING --> REVIEW --> DOCUMENTATION
```

| Phase          | Sub-Agent Role                              |
| -------------- | ------------------------------------------- |
| Planning       | Analyze requirements, create task breakdown |
| Implementation | Write code following approved plan          |
| Testing        | Create tests, verify acceptance criteria    |
| Review         | Persona-based review (Tech Lead, QA, etc.)  |
| Documentation  | Update docs, add inline comments            |

**Benefits:**

- Clear handoff points between phases
- Each sub-agent operates within defined scope
- Progress easily tracked through phase completion

#### Parallel Execution

Dispatch multiple sub-agents simultaneously for independent tasks:

```text
+------------------+
|  Primary Agent   |
|  (Orchestrator)  |
+--------+---------+
         | dispatch
    +----+----+--------+--------+
    v         v        v        v
+-------+ +-------+ +-------+ +-------+
|Backend| |Frontend| |  QA   | | Docs  |
|Sub-Ag | |Sub-Ag | |Sub-Ag | |Sub-Ag |
+---+---+ +---+---+ +---+---+ +---+---+
    |         |        |        |
    +----+----+--------+--------+
         | aggregate
    +----v----+
    | Results |
    +---------+
```

**Prerequisites for parallel dispatch:**

- Tasks have no shared state dependencies
- Tasks can complete independently
- Clear success criteria for each task
- Isolated worktrees prevent file conflicts

Reference: `superpowers:dispatching-parallel-agents` for detailed parallel
execution patterns.

### Coordination Mechanisms

#### Issue Comments

The primary coordination channel is GitHub issue comments:

```markdown
## Sub-Agent Status Update

**Agent:** Backend Sub-Agent
**Task:** Implement user authentication endpoint
**Status:** In Progress
**Started:** 2024-01-15 10:30 UTC

### Progress

- [x] Database schema created
- [x] Repository layer implemented
- [ ] Controller endpoint (current)
- [ ] Integration tests

### Blockers

None

### Next Update

Expected completion: 2024-01-15 14:00 UTC
```

**Comment conventions:**

- Post status at task start, on blockers, and at completion
- Use consistent formatting for easy parsing
- Tag primary agent on blockers requiring intervention
- Link to relevant commits and PRs

#### Status Tracking

Track sub-agent status using structured labels or status tables:

**Label-based tracking:**

```bash
# Add status label to issue
gh issue edit N --add-label "sub-agent:backend:in-progress"
gh issue edit N --remove-label "sub-agent:backend:in-progress"
gh issue edit N --add-label "sub-agent:backend:complete"
```

**Table-based tracking (in issue body or comment):**

| Sub-Agent | Task              | Status      | Worktree          | Last Update |
| --------- | ----------------- | ----------- | ----------------- | ----------- |
| Backend   | Auth endpoint     | In Progress | `wt-backend-123`  | 10:30 UTC   |
| Frontend  | Login form        | Complete    | `wt-frontend-123` | 11:45 UTC   |
| QA        | Integration tests | Pending     | -                 | -           |
| Docs      | API documentation | Blocked     | `wt-docs-123`     | 12:00 UTC   |

**Status values:**

- `Pending` - Not yet started
- `In Progress` - Actively being worked
- `Blocked` - Waiting on dependency or clarification
- `Complete` - Task finished successfully
- `Failed` - Task could not complete (requires intervention)

### Result Aggregation

After sub-agents complete their tasks, the primary agent aggregates results:

#### Aggregation Checklist

1. **Collect completion status** from all sub-agents
2. **Verify success criteria** met for each task
3. **Merge worktrees** in dependency order
4. **Resolve conflicts** if any arise during merge
5. **Run integration tests** on combined changes
6. **Update issue** with aggregated results

#### Aggregation Report Template

Post aggregation summary to issue:

```markdown
## Sub-Agent Aggregation Report

**Issue:** #123 - Implement user authentication
**Aggregated:** 2024-01-15 15:00 UTC

### Sub-Agent Results

| Sub-Agent | Task              | Result  | Commits          |
| --------- | ----------------- | ------- | ---------------- |
| Backend   | Auth endpoint     | Success | abc1234, def5678 |
| Frontend  | Login form        | Success | 111aaaa, 222bbbb |
| QA        | Integration tests | Success | 333cccc          |
| Docs      | API documentation | Success | 444dddd          |

### Integration Verification

- [x] All worktrees merged successfully
- [x] No merge conflicts
- [x] Integration tests passing
- [x] Build successful

### Combined Artifacts

- PR: #456
- Test coverage: 87% (+5%)
- Documentation: Updated API spec

### Next Steps

Ready for automated review loop (Phase 4)
```

#### Conflict Resolution

When sub-agent work conflicts:

1. **Identify conflict scope** - Which files, which changes
2. **Determine priority** - Use skill priority model (P0 > P1 > P2 > P3)
3. **Resolve in order** - Higher priority sub-agent changes take precedence
4. **Verify resolution** - Run tests after conflict resolution
5. **Document decision** - Record why specific resolution chosen

**Conflict escalation:**

- Minor conflicts: Primary agent resolves
- Architectural conflicts: Escalate to human supervisor
- Security-related conflicts: Always escalate

## Persona Integration

Pair programming uses `persona-switching` to manage identity and attribution across
different workflow phases. This ensures commits are properly attributed and the
correct account permissions are used for each operation.

### Account Usage by Persona Type

| Persona Type | Account                 | Examples                      |
| ------------ | ----------------------- | ----------------------------- |
| Development  | Developer account       | Backend Engineer, QA Engineer |
| Management   | Team/maintainer account | Tech Lead, Scrum Master       |

**Development personas** perform implementation work using a contributor-level
developer account. This includes writing code, creating tests, and addressing
review feedback.

**Management personas** perform elevated operations using a team or maintainer
account. This includes approving PRs, managing labels, and closing issues.

### Commit Attribution Format

All commits include persona attribution in the author name:

```text
Claude (<Persona Name>)
```

Examples:

- `Claude (Backend Engineer)` - Implementation commit
- `Claude (QA Engineer)` - Test commit
- `Claude (Tech Lead)` - Review-related commit

This format provides clear audit trail of which persona authored each change
while maintaining GPG signature validity (GPG validates against email, not name).

### Persona Switching Triggers

Persona switches occur automatically at workflow phase transitions:

| Workflow Phase   | Trigger                     | Persona        |
| ---------------- | --------------------------- | -------------- |
| Planning         | Issue enters refinement     | Tech Lead      |
| Implementation   | Implementation phase begins | Domain expert  |
| Review Loop      | Self-review requested       | Tech Lead / QA |
| Human Checkpoint | PR created                  | Tech Lead      |
| Merge            | PR approved                 | Tech Lead      |

**Within Implementation phase**, switches occur based on task type:

- Backend tasks: Backend Engineer
- Frontend tasks: Frontend Engineer
- Test writing: QA Engineer
- Security fixes: Security Engineer

### Integration with persona-switching Skill

This skill delegates identity management to `persona-switching`:

1. **Setup**: `persona-switching` configures security profiles and shell functions
2. **Runtime**: Use `use_persona <role>` to switch before commits
3. **Verification**: Use `show_persona` to confirm current identity

For full configuration and security details, see:
`skills/persona-switching/SKILL.md`

## Human Supervisor Model

### Supervisor vs Collaborator

| Aspect            | Collaborator (Traditional) | Supervisor (This Skill)    |
| ----------------- | -------------------------- | -------------------------- |
| Human involvement | Constant                   | Periodic checkpoints       |
| Decision making   | Joint                      | Agent with human oversight |
| Code authorship   | Shared                     | Primarily agent            |
| Review timing     | During implementation      | After automated reviews    |
| Best for          | Learning, exploration      | Production throughput      |

### Autonomy Boundaries

**Agent decides autonomously:**

- Implementation details within approved plan
- Sub-agent dispatch and coordination
- Addressing automated review feedback
- Parallel task selection when blocked

**Agent escalates to human:**

- Architectural decisions outside plan scope
- Security-sensitive changes
- Ambiguous requirements
- Blocked with no parallel work available

### Intervention Points

Human can intervene at any time:

1. **Comment on issue** - Agent sees and responds
2. **Comment on PR** - Agent addresses feedback
3. **Take over command** - Agent hands off gracefully
4. **Direct instruction** - Agent follows human direction

### Notification Preferences

Default: **Async notifications**

- Agent posts updates to issue/PR comments
- Human reviews when convenient
- No blocking waits for human response

Configure in ways-of-working if different preference needed.

## Human Supervisor Interface

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

## Detection and Deference

### Detection

Before starting pair programming workflow, check for existing setup:

```bash
# Check for existing pair programming configuration
test -f docs/playbooks/pair-programming.md && echo "Playbook exists"

# Check for existing workflow conventions
test -f docs/ways-of-working/pair-programming.md && echo "Conventions exist"

# Check for active pair programming session
gh issue list --label "pair-programming:active" --state open
```

### Deference

If existing pair programming setup found:

- **Playbook exists**: Follow existing playbook, don't recreate
- **Conventions documented**: Respect documented preferences
- **Active session**: Check status before starting new work

Only create new artifacts if none exist.

## Quick Reference

### Starting a Session

```bash
# Trigger via issue assignment
gh issue edit N --add-assignee @agent

# Or via command
/pair #N

# Or batch mode
/pair --backlog --priority p1,p2
```

### Checking Status

```bash
# View active pair programming issues
gh issue list --label "pair-programming:active"

# View agent's current task
gh issue list --assignee @agent --state open --limit 1
```

### Intervention

```bash
# Request agent pause
gh issue comment N --body "@agent please pause for discussion"

# Take over from agent
gh issue comment N --body "@agent I'm taking over this task"

# Resume agent work
gh issue comment N --body "@agent please continue"
```
